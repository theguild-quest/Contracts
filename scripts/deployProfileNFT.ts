import { ethers } from "hardhat";

async function main() {
  const factoryAddress = ethers.getAddress("0x6f9e2777D267FAe69b0C5A24a402D14DA1fBcaA1")
  const profileNFT = await ethers.deployContract("ProfileNFT", [factoryAddress],); // factory
  await profileNFT.waitForDeployment();
  console.log("Profile NFT deployed to: ", profileNFT.target)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});