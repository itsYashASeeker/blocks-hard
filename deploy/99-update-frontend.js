const { ethers, network } = require("hardhat");
const fs = require("fs");

module.exports = async function () {
    const FRONTEND_ADDRESSES_FILE = "../bs_app/src/constants/address.json";
    const FRONTEND_ABI_FILE = "../bs_app/src/constants/abi.json";

    const supply = await ethers.getContract('Supply');
    const currentAddresses = JSON.parse(fs.readFileSync(FRONTEND_ADDRESSES_FILE, 'utf8'));
    const address = await supply.getAddress();
    console.log(address);


    // const current_chain_id = network.config.chainId.toString();
    // console.log(current_chain_id);
    const current_chain_id = 11155111;
    if (current_chain_id in currentAddresses) {
        if (!currentAddresses[current_chain_id].includes(address)) {
            currentAddresses[current_chain_id].push(address);
        }
    }
    else {
        currentAddresses[current_chain_id] = [address];
    }
    // console.log(currentAddresses);
    fs.writeFileSync(FRONTEND_ADDRESSES_FILE, JSON.stringify(currentAddresses));

    // UPDATE ABI
    fs.writeFileSync(FRONTEND_ABI_FILE, JSON.stringify(supply.interface.fragments));
}

module.exports.tags = ['all', 'frontend'];