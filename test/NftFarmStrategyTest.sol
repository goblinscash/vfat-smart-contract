// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {IERC721Enumerable} from "lib/openzeppelin-contracts/contracts/interfaces/IERC721Enumerable.sol";
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

import {NftFarmStrategy} from "../src/strategies/NftFarmStrategy.sol";
import {SickleFactory} from "../src/SickleFactory.sol";
import {ConnectorRegistry} from "../src/ConnectorRegistry.sol";
import {INftSettingsRegistry} from "../src/interfaces/INftSettingsRegistry.sol";
import {INftTransferLib} from "../src/interfaces/libraries/INftTransferLib.sol";
import {ITransferLib} from "../src/interfaces/libraries/ITransferLib.sol";
import {IFeesLib} from "../src/interfaces/libraries/IFeesLib.sol";
import {ISwapLib} from "../src/interfaces/libraries/ISwapLib.sol";
import {INftZapLib} from "../src/interfaces/libraries/INftZapLib.sol";
import {INftSettingsLib} from "../src/interfaces/libraries/INftSettingsLib.sol";
import {INonfungiblePositionManager} from "../src/interfaces/uniswap/INonfungiblePositionManager.sol";
import {IUniswapV3Pool} from "../src/interfaces/uniswap/IUniswapV3Pool.sol";

import {NftDeposit, Farm, NftIncrease} from "../src/structs/NftFarmStrategyStructs.sol";
import {NftSettings} from "../src/structs/NftSettingsStructs.sol";

import {Sickle} from "../src/Sickle.sol";
import {SickleRegistry} from "../src/SickleRegistry.sol";
import {NftAddLiquidity, Pool} from "../src/structs/NftLiquidityStructs.sol";
import {SwapParams} from "../src/structs/LiquidityStructs.sol";
import {NftZapIn} from "../src/structs/NftZapStructs.sol";

import {NftSettings, RebalanceConfig, ExitConfig} from "../src/structs/NftSettingsStructs.sol";
import {RewardConfig, RewardBehavior} from "../src/structs/PositionSettingsStructs.sol";
import {UniswapV3Connector} from "../src/connectors/UniswapV3Connector.sol";

contract MockERC20 is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals
    ) ERC20(name, symbol) {
        _mint(msg.sender, 1_000_0000000 * (10 ** uint256(decimals)));
    }
}

// Mock NFT Position Manager
contract MockNonfungiblePositionManager is INonfungiblePositionManager {
    struct Position {
        uint256 tokenId;
        uint128 liquidity;
        uint256 amount0;
        uint256 amount1;
    }

    mapping(uint256 => Position) private _positions;
    uint256 public nextTokenId = 1;

    function mint(
        MintParams memory params
    )
        external
        payable
        override
        returns (uint256 tokenId, uint256 amount0, uint256 amount1)
    {
        require(params.amount0Desired > 0, "amount0Desired cannot be zero");
        require(params.amount1Desired > 0, "amount1Desired cannot be zero");

        tokenId = nextTokenId++;
        amount0 = params.amount0Desired;
        amount1 = params.amount1Desired;

        _positions[tokenId] = Position({
            tokenId: tokenId,
            liquidity: 1000,
            amount0: amount0,
            amount1: amount1
        });

        return (tokenId, amount0, amount1);
    }

    function increaseLiquidity(
        IncreaseLiquidityParams memory params
    )
        external
        payable
        override
        returns (uint256 amount0, uint256 amount1, uint256 liquidity)
    {
        require(params.amount0Desired > 0, "amount0Desired cannot be zero");
        require(params.amount1Desired > 0, "amount1Desired cannot be zero");

        Position storage position = _positions[params.tokenId];

        liquidity = 500;
        amount0 = position.amount0 + params.amount0Desired;
        amount1 = position.amount1 + params.amount1Desired;

        position.amount0 = amount0;
        position.amount1 = amount1;
        position.liquidity = uint128(position.liquidity + uint256(liquidity));

        return (amount0, amount1, liquidity);
    }

    function positions(
        uint256 tokenId
    )
        external
        view
        override
        returns (
            uint96 nonce,
            address operator,
            address token0,
            address token1,
            uint24 fee,
            int24 tickLower,
            int24 tickUpper,
            uint128 liquidity,
            uint256 feeGrowthInside0LastX128,
            uint256 feeGrowthInside1LastX128,
            uint128 tokensOwed0,
            uint128 tokensOwed1
        )
    {
        Position memory position = _positions[tokenId];
        return (
            0,
            address(0),
            address(0),
            address(0),
            0,
            0,
            0,
            position.liquidity,
            0,
            0,
            0,
            0
        );
    }

    function burn(uint256 tokenId) external payable override {
        delete _positions[tokenId];
    }

    function collect(
        CollectParams calldata params
    ) external payable override returns (uint256 amount0, uint256 amount1) {
        amount0 = 0;
        amount1 = 0;
    }

    function decreaseLiquidity(
        DecreaseLiquidityParams calldata params
    ) external payable override returns (uint256 amount0, uint256 amount1) {
        amount0 = params.amount0Min;
        amount1 = params.amount1Min;
    }

    function approve(address to, uint256 tokenId) external override {}

    function balanceOf(
        address owner
    ) external view override returns (uint256 balance) {}

    function getApproved(
        uint256 tokenId
    ) external view override returns (address operator) {}

    function isApprovedForAll(
        address owner,
        address operator
    ) external view override returns (bool) {}

    function ownerOf(
        uint256 tokenId
    ) external view override returns (address owner) {}

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external override {}

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external override {}

    function setApprovalForAll(
        address operator,
        bool approved
    ) external override {}

    function supportsInterface(
        bytes4 interfaceId
    ) external view override returns (bool) {}

    function tokenByIndex(
        uint256 index
    ) external view override returns (uint256) {}

    function tokenOfOwnerByIndex(
        address owner,
        uint256 index
    ) external view override returns (uint256) {}

    function totalSupply() external view override returns (uint256) {}

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external override {}
}

// Main Test Contract
contract NftFarmStrategyTest is Test {
    MockERC20 public token0;
    MockERC20 public token1;

    NftFarmStrategy public nftFarmStrategy;
    SickleRegistry public sickleRegistry;
    SickleFactory public factory;
    Sickle public sickle;
    ConnectorRegistry public connectorRegistry;
    INftSettingsRegistry public nftSettingsRegistry;
    UniswapV3Connector public connector;

    INftTransferLib public nftTransferLib;
    ITransferLib public transferLib;
    ISwapLib public swapLib;
    IFeesLib public feesLib;
    INftZapLib public nftZapLib;
    INftSettingsLib public nftSettingsLib;

    MockNonfungiblePositionManager public mockNftManager;
    address public user = address(0x123);
    address public uniswapPool = address(0x789); // Mock Uniswap V3 Pool
    address public previousFactoryAddr =
        0x0000000000000000000000000000000000000000;

    // Declare tokensIn and amountsIn as state variables
    address[] public tokensIn = new address[](2);
    uint256[] public amountsIn = new uint256[](2);

    function setUp() public {
        token0 = new MockERC20("Mock Token 0", "MT0", 18);
        token1 = new MockERC20("Mock Token 1", "MT1", 18);
        token0.transfer(user, 100_000_000 ether);
        token1.transfer(user, 100_000_000 ether);
        sickleRegistry = new SickleRegistry(address(this), address(this));

        sickle = new Sickle(sickleRegistry);

        factory = new SickleFactory(
            address(this), // Admin address (owner of the factory)
            address(sickleRegistry),
            address(sickle),
            previousFactoryAddr // Previous SickleFactory address (or 0x0)
        );

        connectorRegistry = new ConnectorRegistry(address(this), address(this));
        nftSettingsRegistry = INftSettingsRegistry(address(0xABC)); // Mock or deploy

        nftTransferLib = INftTransferLib(address(0xDEF));
        transferLib = ITransferLib(address(0x234));
        swapLib = ISwapLib(address(0x456));
        feesLib = IFeesLib(address(0x789));
        nftZapLib = INftZapLib(address(0xABC));
        nftSettingsLib = INftSettingsLib(address(0xEF1));

        // Deploy NftFarmStrategy
        nftFarmStrategy = new NftFarmStrategy(
            factory,
            connectorRegistry,
            nftSettingsRegistry,
            NftFarmStrategy.Libraries({
                nftTransferLib: nftTransferLib,
                transferLib: transferLib,
                swapLib: swapLib,
                feesLib: feesLib,
                nftZapLib: nftZapLib,
                nftSettingsLib: nftSettingsLib
            })
        );

        // Deploy mock NFT Position Manager
        mockNftManager = new MockNonfungiblePositionManager();

        // **Whitelisting NftFarmStrategy in SickleRegistry**
        address[] memory callers = new address[](1); // Declare an array of addresses with size 1
        callers[0] = address(nftFarmStrategy); // Assign the address of nftFarmStrategy
        vm.prank(address(this)); // Simulate admin caller
        sickleRegistry.setWhitelistedCallers(callers, true); // Call the function with the array

        address[] memory nftManagers = new address[](1);
        nftManagers[0] = address(mockNftManager);

        address[] memory strategies = new address[](1);
        strategies[0] = address(nftFarmStrategy);

        // Call setConnectors with dynamic arrays
        connectorRegistry.setConnectors(nftManagers, strategies);

        // Initialize tokensIn array
        tokensIn[0] = address(token0);
        tokensIn[1] = address(token1);

        amountsIn[0] = 5000e18;
        amountsIn[1] = 1000e18;

        // User must approve the strategy to use their tokens
        vm.prank(user);
        token0.approve(address(nftFarmStrategy), 100_000_00000 ether);
        vm.prank(user);
        token1.approve(address(nftFarmStrategy), 100_000_00000 ether);

        vm.prank(user);
        token0.approve(address(transferLib), type(uint256).max);

        vm.prank(user);
        token1.approve(address(transferLib), type(uint256).max);

        // uint256 allowance = token0.allowance(user, address(nftFarmStrategy));
        // console.log("Allowance to nftFarmStrategy:", allowance);

        // allowance = token0.allowance(user, address(transferLib));
        // console.log("Allowance to transferLib:", allowance);

        // vm.prank(user);
        // bool success = token0.transferFrom(
        //     user,
        //     address(nftFarmStrategy),
        //     890000000000000
        // );
        // console.log("Transfer success:", success);

        // Label addresses for better debugging
        vm.label(address(factory), "SickleFactory");
        vm.label(address(connectorRegistry), "ConnectorRegistry");
        vm.label(address(nftSettingsRegistry), "NftSettingsRegistry");
        vm.label(address(nftFarmStrategy), "NftFarmStrategy");
        vm.label(user, "User");
        vm.label(address(mockNftManager), "MockNftManager");
        vm.label(uniswapPool, "UniswapPool");
    }

    function testDeposit() public {
        NftDeposit memory params = NftDeposit({
            farm: Farm({
                stakingContract: address(mockNftManager),
                poolIndex: 0
            }),
            nft: INonfungiblePositionManager(address(mockNftManager)),
            increase: NftIncrease({
                zap: NftZapIn({
                    swaps: new SwapParams[](0),
                    addLiquidityParams: NftAddLiquidity({
                        nft: INonfungiblePositionManager(
                            address(mockNftManager)
                        ),
                        tokenId: 0, // New deposit, so tokenId should be 0
                        pool: Pool({
                            token0: address(token0),
                            token1: address(token1),
                            fee: 3000 // Replace with the actual fee tier (e.g., 3000 for 0.3%)
                        }),
                        tickLower: -6000, // Replace with the actual lower tick
                        tickUpper: 6000, // Replace with the actual upper tick
                        amount0Desired: 5000 ether,
                        amount1Desired: 1000 ether,
                        amount0Min: 5000 ether,
                        amount1Min: 1000 ether,
                        extraData: ""
                    })
                }),
                tokensIn: tokensIn, //new address[](0), //tokensIn,
                amountsIn: amountsIn, // new uint256[](0), //amountsIn,
                extraData: ""
            })
        });

        NftSettings memory settings = NftSettings({
            pool: IUniswapV3Pool(uniswapPool),
            autoRebalance: false,
            rebalanceConfig: RebalanceConfig({
                tickSpacesBelow: 10,
                tickSpacesAbove: 10,
                bufferTicksBelow: 50,
                bufferTicksAbove: 50,
                dustBP: 100,
                priceImpactBP: 500,
                slippageBP: 500,
                cutoffTickLow: -100,
                cutoffTickHigh: 100,
                delayMin: 5,
                rewardConfig: RewardConfig({
                    rewardBehavior: RewardBehavior.None,
                    harvestTokenOut: address(0)
                })
            }),
            automateRewards: true,
            rewardConfig: RewardConfig({
                rewardBehavior: RewardBehavior.None,
                harvestTokenOut: address(0)
            }),
            autoExit: false,
            exitConfig: ExitConfig({
                triggerTickLow: 0,
                triggerTickHigh: 0,
                exitTokenOutLow: address(0),
                exitTokenOutHigh: address(0),
                priceImpactBP: 0,
                slippageBP: 0
            })
        });

        address[] memory sweepTokens = new address[](0);
        address approved = address(0);
        bytes32 referralCode = keccak256("REF123");

        // Mock necessary external calls (if needed)
        vm.mockCall(
            address(mockNftManager),
            abi.encodeWithSelector(
                IERC721.balanceOf.selector,
                address(nftFarmStrategy)
            ),
            abi.encode(1)
        );
        vm.mockCall(
            address(mockNftManager),
            abi.encodeWithSelector(
                IERC721Enumerable.tokenOfOwnerByIndex.selector,
                address(nftFarmStrategy),
                0
            ),
            abi.encode(1)
        );

        // Call the deposit function
        vm.prank(user); // Simulate the call from the user
        nftFarmStrategy.deposit(
            params,
            settings,
            sweepTokens,
            approved,
            referralCode
        );

        // Add assertions to verify the expected behavior
        // Example: Check if the NFT was deposited successfully
        // (You'll need to implement the necessary getters or events in your contract)
    }
}
