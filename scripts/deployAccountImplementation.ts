import { ethers } from "hardhat";

async function main() {

  const implementation = await ethers.deployContract("ExampleERC6551Account", );

  await implementation.waitForDeployment();

  console.log(
    `Account Implementation deployed to ${implementation.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});