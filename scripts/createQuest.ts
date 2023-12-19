import { ethers } from "hardhat";
import { artifacts } from "hardhat";
import { load } from 'ts-dotenv';

const env = load({
  WALLET_PRIVATE_KEY: String,
  ETHERSCAN_API_KEY: String
});


const tavernAddress = ethers.getAddress("0x90d512558CF3e6B10616A503d1Ef5073188466b2");

async function main() {
    const provider = ethers.getDefaultProvider(`https://api.avax-test.network/ext/bc/C/rpc`);
    const signer = new ethers.Wallet(env.WALLET_PRIVATE_KEY, provider);

    const tavernArtifacts = await artifacts.readArtifact("Tavern");
    const abi =  tavernArtifacts.abi;
    const tavern = new ethers.Contract(tavernAddress, abi, signer);

    const solver = ethers.getAddress("0x6f9e2777D267FAe69b0C5A24a402D14DA1fBcaA1");
    const seeker = ethers.getAddress("0x6f9e2777D267FAe69b0C5A24a402D14DA1fBcaA1");

    // without funds 
    const quest = await tavern.startNewQuest(solver, seeker, 10, "string memory infoURI"); 
    console.log(quest)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  