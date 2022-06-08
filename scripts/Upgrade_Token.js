const {ethers,upgrades} = require("hardhat");

const PROXY = "0x1E526ccC1A6D393BbebEa4DA3e336F37aa8598D7";

async function main() {
    const Token = await ethers.getContractFactory("Token")
    await upgrades.upgradeProxy(PROXY, Token) 
}
main();