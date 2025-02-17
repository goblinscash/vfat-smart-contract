const { ethers } = require("ethers");
const ABI = require("./abis/abi.json");
const uniPoolABI = require("./abis/uniPoolABI.json");
const ERC20_ABI = require("./abis/erc20.json");
const sickleRegistryABI = require("./abis/SickleRegistry.json");
const connectorRegistryABI = require("./abis/ConnectorRegistry.json");
require("dotenv").config();

const sickleRegistryAddress = "0xFd8E0705EdCc01A142ed0a8e76F036e38B72Bcc3";
const connectorRegistryAddress = "0xdBaE2aA28b83b952f7542F87420897F4e12F1A99";
const nftFarmStrategyAddress = "0xE174bB384365CBD50BF50E8dEeA7DF8b8808dfac";
const transferLib = "0x64e72a67eaE17aa771D97eA07e3407b171f33Fe5"
const nftZapLib = "0x758a3B49A4Fee14B18CC8dFA5CeB547Acc594f21"
const v3Connector = "0x5d6094F3d68d725153d0938ce5b0E4D7815B42A7"

const sickle = "0xa7C075663B6BD49E5d96206e6Bb4740A1a8F6778"

const provider = new ethers.providers.JsonRpcProvider("https://base-sepolia-rpc.publicnode.com");
const signer = new ethers.Wallet(process.env.PVT_KEY, provider);
const nftFarmStrategy = new ethers.Contract(process.env.NFT_FARM_STRATEGY, ABI, signer);
const poolContract = new ethers.Contract(process.env.UNISWAP_POOL, uniPoolABI, provider);

const allowanceDesired = ethers.utils.parseUnits("5000000000000000", 18);
const amount0Desired = ethers.utils.parseUnits("1000", 18);
const amount1Desired = ethers.utils.parseUnits("1000", 18);
const amount0Min = ethers.utils.parseUnits("583.622018870502157692", 18);
const amount1Min = ethers.utils.parseUnits("581.537516819099281181", 18);



const tokenId = 12253
    
const liquidity = "167175499835819766909277" 

async function setupContracts(signer) {
    // Contract Instances
    const sickleRegistry = new ethers.Contract(sickleRegistryAddress, sickleRegistryABI, signer);
    const connectorRegistry = new ethers.Contract(connectorRegistryAddress, connectorRegistryABI, signer);

    const tx0 = await sickleRegistry.setWhitelistedTargets([transferLib, nftZapLib], true)
    await tx0.wait()
    console.log("✅ Targets Whitelisting completed.");

    // **Whitelisting NftFarmStrategy in SickleRegistry**
    console.log("Whitelisting NftFarmStrategy...");
    const tx1 = await sickleRegistry.setWhitelistedCallers([nftFarmStrategyAddress], true);
    await tx1.wait();
    console.log("✅ Whitelisting completed.");

    // **Setting Connectors**
    console.log("Setting connectors...");
    const tx2 = await connectorRegistry.updateConnectors(
        [process.env.NFPM],  // nftManagers
        [v3Connector],  // strategies
        { gasLimit: 3000000 }
    );
    await tx2.wait();
    console.log("✅ Connectors set successfully.");
}

async function approve() {
    const token0 = await poolContract.token0();
    const token1 = await poolContract.token1();

    // Check and set allowances
    const token0Contract = new ethers.Contract(token0, ERC20_ABI, signer);
    const token1Contract = new ethers.Contract(token1, ERC20_ABI, signer);

    const allowance0 = await token0Contract.allowance(signer.address, sickle);
    const allowance1 = await token1Contract.allowance(signer.address, sickle);


    if (allowance1.lt(amount0Desired)) {
        const tx0 = await token0Contract.approve(sickle, allowanceDesired);
        await tx0.wait();
        console.log("Approved Token0");
    }

    if (allowance1.lt(amount1Desired)) {
        const tx1 = await token1Contract.approve(sickle, allowanceDesired);
        await tx1.wait();
        console.log("Approved Token1");
    }

}



async function depositNFT() {
    const token0 = await poolContract.token0();
    const token1 = await poolContract.token1();

    // Check and set allowances
    const token0Contract = new ethers.Contract(token0, ERC20_ABI, signer);
    const token1Contract = new ethers.Contract(token1, ERC20_ABI, signer);

    const allowance0 = await token0Contract.allowance(signer.address, process.env.NFT_FARM_STRATEGY);
    const allowance1 = await token1Contract.allowance(signer.address, process.env.NFT_FARM_STRATEGY);


    if (allowance1.lt(amount0Desired)) {
        const tx0 = await token0Contract.approve(process.env.NFT_FARM_STRATEGY, allowanceDesired);
        await tx0.wait();
        console.log("Approved Token0");
    }

    if (allowance1.lt(amount1Desired)) {
        const tx1 = await token1Contract.approve(process.env.NFT_FARM_STRATEGY, allowanceDesired);
        await tx1.wait();
        console.log("Approved Token1");
    }

    // const sickleAddress = "0xa7c075663b6bd49e5d96206e6bb4740a1a8f6778";
    // const tx2 = await token0Contract.approve(sickleAddress, amount0Desired);
    // await tx2.wait();

    // const tx3 = await token1Contract.approve(sickleAddress, amount1Desired);
    // await tx3.wait();

    // const tx4 = await token0Contract.approve(process.env.NFPM, amount0Desired);
    // await tx4.wait();

    // const tx5 = await token1Contract.approve(process.env.NFPM, amount1Desired);
    // await tx5.wait();


    // await setupContracts(signer)

    // Define the `params` struct
    const params = {
        farm: {
            stakingContract: process.env.NFPM,
            poolIndex: 0
        },
        nft: process.env.NFPM,
        increase: {
            zap: {
                swaps: [],
                addLiquidityParams: {
                    nft: process.env.NFPM,
                    tokenId: 0,
                    pool: {
                        token0: token0,
                        token1: token1,
                        fee: 3000
                    },
                    tickLower: -120,
                    tickUpper: 120,
                    amount0Desired: amount0Desired.toString(),
                    amount1Desired: amount1Desired.toString(),
                    amount0Min: amount0Min.toString(),
                    amount1Min: amount1Min.toString(),
                    deadline: Math.floor(Date.now() / 1000) + 600,
                    extraData: "0x"
                }
            },
            tokensIn: [token0, token1],
            amountsIn: [amount0Desired.toString(), amount1Desired.toString()],
            extraData: "0x"
        }
    };

    // Define the `settings` struct
    const settings = {
        pool: process.env.UNISWAP_POOL,
        autoRebalance: false,
        rebalanceConfig: {
            tickSpacesBelow: 0,
            tickSpacesAbove: 0,
            bufferTicksBelow: 0,
            bufferTicksAbove: 0,
            dustBP: 0,
            priceImpactBP: 0,
            slippageBP: 0,
            cutoffTickLow: 0,
            cutoffTickHigh: 0,
            delayMin: 0,
            rewardConfig: {
                rewardBehavior: 0,
                harvestTokenOut: process.env.ZERO
            }
        },
        automateRewards: false,
        rewardConfig: {
            rewardBehavior: 0,
            harvestTokenOut: process.env.ZERO
        },
        autoExit: false,
        exitConfig: {
            triggerTickLow: 0,
            triggerTickHigh: 0,
            exitTokenOutLow: process.env.ZERO,
            exitTokenOutHigh: process.env.ZERO,
            priceImpactBP: 0,
            slippageBP: 0
        }
    };

    const sweepTokens = [process.env.USDC];
    const approved = process.env.ZERO;
    const referralCode = ethers.utils.formatBytes32String("REF123");

    try {
        const tx = await nftFarmStrategy.deposit(
            params,
            settings,
            sweepTokens,
            approved,
            referralCode,
            { gasLimit: 8000000 } // Increased gas limit
        );

        console.log("Transaction Hash:", tx.hash);
        await tx.wait();
        console.log("Deposit Successful!");
    } catch (error) {
        console.error("Transaction Failed:", error.message);
    }
}


async function harvest() {
    const position = {
        farm: {
            stakingContract: process.env.NFPM,
            poolIndex: 0
        },
        nft: process.env.NFPM,
        tokenId: tokenId
    }

    const params = {
        harvest: {
            rewardTokens: [process.env.USDC],
            amount0Max: "340282366920938463463374607431768211455",
            amount1Max: "340282366920938463463374607431768211455",
            extraData: "0x00"
        },
        swaps: [],
        outputTokens: [process.env.USDC],
        sweepTokens: [process.env.USDC]
    }

    try {
        const tx = await nftFarmStrategy.harvest(
            position,
            params,
            { gasLimit: 8000000 }
        );

        console.log("Transaction Hash:", tx.hash);
        await tx.wait();
        console.log("Harvest Successful!");
    } catch (error) {
        console.error("Harvest Transaction Failed:", error.message);
    }
}

async function rebalance() {
    const token0 = await poolContract.token0();
    const token1 = await poolContract.token1();

    const params = {
        pool: process.env.UNISWAP_POOL,
        position: {
            farm: {
                stakingContract: process.env.NFPM,
                poolIndex: 0
            },
            nft: process.env.NFPM,
            tokenId: tokenId
        },
        harvest: {
            harvest: {
                rewardTokens: [process.env.USDC],
                amount0Max: "340282366920938463463374607431768211455",
                amount1Max: "340282366920938463463374607431768211455",
                extraData: "0x00"
            },
            swaps: [],
            outputTokens: [],
            sweepTokens: [process.env.USDC]
        },
        withdraw: {
            zap: {
                removeLiquidityParams: {
                    nft: process.env.NFPM,
                    tokenId: tokenId,
                    liquidity: liquidity,
                    amount0Min: "0",
                    amount1Min: "0",
                    amount0Max: "340282366920938463463374607431768211455",
                    amount1Max: "340282366920938463463374607431768211455",
                    extraData: "0x00"
                },
                swaps: []
            },
            tokensOut: [process.env.USDC],
            extraData: "0x00"
        },
        increase: {
            tokensIn: [],
            amountsIn: [],
            zap: {
                swaps: [],
                addLiquidityParams: {
                    nft: process.env.NFPM,
                    tokenId: 0,
                    pool: {
                        token0: token0,
                        token1: token1,
                        fee: 3000
                    },
                    tickLower: "-60",
                    tickUpper: "60",
                    amount0Desired: "0",
                    amount1Desired: "0",
                    amount0Min: "0",
                    amount1Min: "0",
                    extraData: "0x00"
                }
            },
            extraData: "0x00"
        }
    }

    const sweepTokens = [process.env.USDC]

    try {
        const tx = await nftFarmStrategy.rebalance(
            params,
            sweepTokens,
            { gasLimit: 8000000 }
        );

        console.log("Transaction Hash:", tx.hash);
        await tx.wait();
        console.log("Rebalance Successful!");
    } catch (error) {
        console.error("Transaction Failed:", error.message);
    }
}

async function compound() {
    await approve()
    const token0 = await poolContract.token0();
    const token1 = await poolContract.token1();

    const position = {
        farm: {
            stakingContract: process.env.NFPM,
            poolIndex: 0
        },
        nft: process.env.NFPM,
        tokenId: tokenId
    }

    const params = {
        harvest: {
            rewardTokens: [process.env.USDC],
            amount0Max: "340282366920938463463374607431768211455",
            amount1Max: "340282366920938463463374607431768211455",
            extraData: "0x00"
        },
        zap: {
            swaps: [],
            addLiquidityParams: {
                nft: process.env.NFPM,
                tokenId: 0,
                pool: {
                    token0: token0,
                    token1: token1,
                    fee: 3000
                },
                tickLower: "-60",
                tickUpper: "60",
                amount0Desired: "0",
                amount1Desired: "0",
                amount0Min: "0",
                amount1Min: "0",
                extraData: "0x00"
            }
        },
    }

    const inPlace = true;
    const sweepTokens = [process.env.USDC]

    try {
        const tx = await nftFarmStrategy.compound(
            position,
            params,
            inPlace,
            sweepTokens,
            { gasLimit: 8000000 }
        );

        console.log("Transaction Hash:", tx.hash);
        await tx.wait();
        console.log("Compound Successful!");
    } catch (error) {
        console.error("Transaction Failed:", error.message);
    }
}

async function increase() {
    await approve()
    const token0 = await poolContract.token0();
    const token1 = await poolContract.token1();

    const position = {
        farm: {
            stakingContract: process.env.NFPM,
            poolIndex: 0
        },
        nft: process.env.NFPM,
        tokenId: tokenId
    }

    const harvestParams = {
        harvest: {
            rewardTokens: [],
            amount0Max: "340282366920938463463374607431768211455",
            amount1Max: "340282366920938463463374607431768211455",
            extraData: "0x00"
        },
        swaps: [],
        outputTokens: [],
        sweepTokens: [process.env.USDC]
    }

    const increaseParams = {
        tokensIn: [token0, token1],
        amountsIn: [amount0Desired.toString(), amount1Desired.toString()],
        zap: {
            swaps: [],
            addLiquidityParams: {
                nft: process.env.NFPM,
                tokenId: tokenId,
                pool: {
                    token0: token0,
                    token1: token1,
                    fee: 3000
                },
                tickLower: "-120",
                tickUpper: "120",
                amount0Desired: amount0Desired.toString(),
                amount1Desired: amount1Desired.toString(),
                amount0Min: amount0Min.toString(),
                amount1Min: amount1Min.toString(),
                deadline: Math.floor(Date.now() / 1000) + 600,
                extraData: "0x00"
            }
        },
        extraData: "0x00"
    }

    const inPlace = true;
    const sweepTokens = [process.env.USDC]

    try {
        const tx = await nftFarmStrategy.increase(
            position,
            harvestParams,
            increaseParams,
            inPlace,
            sweepTokens,
            { gasLimit: 8000000 }
        );

        console.log("Transaction Hash:", tx.hash);
        await tx.wait();
        console.log("Increase Successful!");
    } catch (error) {
        console.log(error)
    }
}

async function exit() {
    const token0 = await poolContract.token0();
    const token1 = await poolContract.token1();

    const position = {
        farm: {
            stakingContract: process.env.NFPM,
            poolIndex: 0
        },
        nft: process.env.NFPM,
        tokenId: tokenId
    }

    const harvestParams = {
        harvest: {
            rewardTokens: [process.env.USDC, process.env.USDT],
            amount0Max: "340282366920938463463374607431768211455",
            amount1Max: "340282366920938463463374607431768211455",
            extraData: "0x00"
        },
        swaps: [],
        outputTokens: [process.env.USDC, process.env.USDT],
        sweepTokens: [process.env.USDC, process.env.USDT]
    }

    const withdrawParams = {
        zap: {
            removeLiquidityParams: {
                nft: process.env.NFPM,
                tokenId: tokenId,
                liquidity: liquidity,
                amount0Min: "0",
                amount1Min: "0",
                amount0Max: "340282366920938463463374607431768211455",
                amount1Max: "340282366920938463463374607431768211455",
                extraData: "0x00"
            },
            swaps: []
        },
        tokensOut: [process.env.USDC, process.env.USDT],
        extraData: "0x00"
    }

    const sweepTokens = [process.env.USDC, process.env.USDT]
    try {
        const tx = await nftFarmStrategy.exit(
            position,
            harvestParams,
            withdrawParams,
            sweepTokens,
            { gasLimit: 8000000 }
        );

        console.log("Transaction Hash:", tx.hash);
        await tx.wait();
        console.log("Withdraw Successful!");
    } catch (error) {
        console.error("Transaction Failed:", error.message);
    }
}


// Run the function
// depositNFT();
// harvest()
// rebalance()
// compound()
// increase()

exit()


























// const settings = {
//     pool: process.env.UNISWAP_POOL,
//     autoRebalance: false,
//     rebalanceConfig: {
//         tickSpacesBelow: "80",
//         tickSpacesAbove: "80",
//         bufferTicksBelow: "0",
//         bufferTicksAbove: "0",
//         dustBP: "0",
//         priceImpactBP: "0",
//         slippageBP: "0",
//         cutoffTickLow: "0",
//         cutoffTickHigh: "0",
//         delayMin: 0,
//         rewardConfig: {
//             rewardBehavior: 0,
//             harvestTokenOut: process.env.ZERO
//         }
//     },
//     automateRewards: false,
//     rewardConfig: {
//         rewardBehavior: 0,
//         harvestTokenOut: process.env.ZERO
//     },
//     autoExit: false,
//     exitConfig: {
//         triggerTickLow: "0",
//         triggerTickHigh: "0",
//         exitTokenOutLow: process.env.ZERO,
//         exitTokenOutHigh: process.env.ZERO,
//         priceImpactBP: "0",
//         slippageBP: "0"
//     }
// }