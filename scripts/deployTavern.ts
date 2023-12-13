import { ethers } from "hardhat";

async function main() {
  const questImpl = await ethers.deployContract("Quest", [],);
  await questImpl.waitForDeployment();
  console.log("Quest Implementation deployed to: ", questImpl.target)

  const escrowImpl = await ethers.deployContract("Escrow", [[]],);
  await escrowImpl.waitForDeployment();
  console.log("Esrow Implementation deployed to: ", escrowImpl.target)

  const tavern = await ethers.deployContract("Tavern", [questImpl.target, escrowImpl.target],);

  await tavern.waitForDeployment();

  console.log(
    `Tavern deployed to ${tavern.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
