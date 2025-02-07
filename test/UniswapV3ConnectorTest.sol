// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import {Test} from "forge-std/Test.sol";
// import {UniswapV3Connector} from "../src/connectors/UniswapV3Connector.sol";
// import {INonfungiblePositionManager} from "../src/interfaces/uniswap/INonfungiblePositionManager.sol";
// import {NftAddLiquidity, Pool} from "../src/structs/NftLiquidityStructs.sol";

// contract MockNonfungiblePositionManager is INonfungiblePositionManager {
//     struct Position {
//         uint256 tokenId;
//         uint128 liquidity;
//         uint256 amount0;
//         uint256 amount1;
//     }

//     mapping(uint256 => Position) private _positions;
//     uint256 public nextTokenId = 1;

//     // mint function must match the signature of the interface
//     function mint(MintParams memory params)
//         external
//         payable
//         override
//         returns (uint256 tokenId, uint256 amount0, uint256 amount1)
//     {
//         require(params.amount0Desired > 0, "amount0Desired cannot be zero");
//         require(params.amount1Desired > 0, "amount1Desired cannot be zero");

//         tokenId = nextTokenId++; // Generate a new token ID
//         amount0 = params.amount0Desired; // Mock the token amounts
//         amount1 = params.amount1Desired;

//         // Store the position
//         _positions[tokenId] = Position({
//             tokenId: tokenId,
//             liquidity: 1000, // Mock liquidity value
//             amount0: amount0,
//             amount1: amount1
//         });

//         return (tokenId, amount0, amount1); // Return the expected values
//     }

//     // increaseLiquidity function must match the signature of the interface
//     function increaseLiquidity(IncreaseLiquidityParams memory params)
//         external
//         payable
//         override
//         returns (uint256 amount0, uint256 amount1, uint256 liquidity)
//     {
//         require(params.amount0Desired > 0, "amount0Desired cannot be zero");
//         require(params.amount1Desired > 0, "amount1Desired cannot be zero");

//         Position storage position = _positions[params.tokenId];

//         // Mock the liquidity increase
//         liquidity = 500; // Mock liquidity increase
//         amount0 = position.amount0 + params.amount0Desired;
//         amount1 = position.amount1 + params.amount1Desired;

//         position.amount0 = amount0;
//         position.amount1 = amount1;
//         position.liquidity = uint128(position.liquidity + uint256(liquidity)); // Cast to uint128 to match type

//         return (amount0, amount1, liquidity); // Return the expected values
//     }

//     // positions function must match the signature of the interface
//     function positions(uint256 tokenId)
//         external
//         view
//         override
//         returns (
//             uint96 nonce,
//             address operator,
//             address token0,
//             address token1,
//             uint24 fee,
//             int24 tickLower,
//             int24 tickUpper,
//             uint128 liquidity,
//             uint256 feeGrowthInside0LastX128,
//             uint256 feeGrowthInside1LastX128,
//             uint128 tokensOwed0,
//             uint128 tokensOwed1
//         )
//     {
//         Position memory position = _positions[tokenId];
//         return (
//             0, // Mocked nonce
//             address(0), // Mocked operator address
//             address(0), // Mocked token0 address
//             address(0), // Mocked token1 address
//             0, // Mocked fee
//             0, // Mocked tickLower
//             0, // Mocked tickUpper
//             position.liquidity, // Return the liquidity
//             0, // Mocked feeGrowthInside0LastX128
//             0, // Mocked feeGrowthInside1LastX128
//             0, // Mocked tokensOwed0
//             0  // Mocked tokensOwed1
//         );
//     }

//     // Implementing the missing functions to avoid "abstract" error
//     function burn(uint256 tokenId) external payable override {
//         // Mocked burn logic (e.g., remove the position)
//         delete _positions[tokenId];
//     }

//     function collect(CollectParams calldata params)
//         external
//         payable
//         override
//         returns (uint256 amount0, uint256 amount1)
//     {
//         // Mocked collect logic (e.g., return 0 amounts)
//         amount0 = 0;
//         amount1 = 0;
//     }

//     function decreaseLiquidity(DecreaseLiquidityParams calldata params)
//         external
//         payable
//         override
//         returns (uint256 amount0, uint256 amount1)
//     {
//         // Mocked decrease liquidity logic (e.g., decrease liquidity and return amounts)
//         amount0 = params.amount0Min;
//         amount1 = params.amount1Min;
//     }

//     // Empty implementations of other required functions for ERC721 compliance
//     function approve(address to, uint256 tokenId) external override {}

//     function balanceOf(address owner) external view override returns (uint256 balance) {}

//     function getApproved(uint256 tokenId) external view override returns (address operator) {}

//     function isApprovedForAll(address owner, address operator)
//         external
//         view
//         override
//         returns (bool)
//     {}

//     function ownerOf(uint256 tokenId) external view override returns (address owner) {}

//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) external override {}

//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId,
//         bytes calldata data
//     ) external override {}

//     function setApprovalForAll(address operator, bool approved) external override {}

//     function supportsInterface(bytes4 interfaceId) external view override returns (bool) {}

//     function tokenByIndex(uint256 index) external view override returns (uint256) {}

//     function tokenOfOwnerByIndex(address owner, uint256 index)
//         external
//         view
//         override
//         returns (uint256)
//     {}

//     function totalSupply() external view override returns (uint256) {}

//     function transferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) external override {}
// }

// contract UniswapV3ConnectorTest is Test {
//     UniswapV3Connector connector;
//     MockNonfungiblePositionManager mockNftManager;

//     function setUp() public {
//         connector = new UniswapV3Connector();
//         mockNftManager = new MockNonfungiblePositionManager();
//     }

//     function testAddLiquidity_Mint() public {
//         Pool memory pool = Pool({
//             token0: address(0x123),
//             token1: address(0x456),
//             fee: 3000
//         });

//         NftAddLiquidity memory params = NftAddLiquidity({
//             nft: INonfungiblePositionManager(address(mockNftManager)),
//             tokenId: 0,
//             pool: pool,
//             tickLower: -60000,
//             tickUpper: 60000,
//             amount0Desired: 1 ether,
//             amount1Desired: 2 ether,
//             amount0Min: 0.9 ether,
//             amount1Min: 1.9 ether,
//             extraData: ""
//         });

//         vm.startBroadcast();
//         connector.addLiquidity(params);
//         vm.stopBroadcast();
//     }
// }
