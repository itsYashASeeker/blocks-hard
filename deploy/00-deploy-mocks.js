// // const { network } = require("hardhat");
// // const { developmentChains } = require("../helper-hardhat.config");
// const { ethers } = require("hardhat");
module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts();
    // const chainId = network.config.chainId;

    // if (developmentChains.includes(network.name)) {
    //     log("Local Network detected! Deploying mocks!!!.........");
    //     const raffle = await ethers.getContract("Supply")
    //     console.log(raffle.getAddress());
    // }
    await deploy('Supply', {
        from: deployer,
        arguments: [''],
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1
    })
        .then((res) => {
            console.log("DONE");
        })
    console.log("deploy mocks");
}

// module.exports.tags = ['Supply']