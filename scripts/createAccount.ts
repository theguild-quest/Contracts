import { ethers } from "hardhat";
import { artifacts } from "hardhat";
import { load } from 'ts-dotenv';

const env = load({
  WALLET_PRIVATE_KEY: String,
  ETHERSCAN_API_KEY: String
});


const registryAddress = ethers.getAddress("0x000000006551c19487814612e58FE06813775758");

const exampleERC6551Account = ethers.getAddress("0x00B2140A27ac9003cc8693e2ad3CE48002BD7B37");
const salt = 0;
const chainId = 43113; // fuji testnet
const nftAddress = ethers.getAddress("0x06D825d9303f02B4BfCE5D49504aF33aeeb8e4e1");
const tokenId = 1; // Guild Profile nft ids start from 1


async function main() {
    const provider = ethers.getDefaultProvider(`https://api.avax-test.network/ext/bc/C/rpc`);
    const signer = new ethers.Wallet(env.WALLET_PRIVATE_KEY, provider);

    const registryArtifacts = await artifacts.readArtifact("ERC6551Registry");
    const abi =  registryArtifacts.abi;
    const registry = new ethers.Contract(registryAddress, abi, signer);

    const solver = ethers.getAddress("0x6f9e2777D267FAe69b0C5A24a402D14DA1fBcaA1");
    const seeker = ethers.getAddress("0x6f9e2777D267FAe69b0C5A24a402D14DA1fBcaA1");

    const account = await registry.createAccount(
        exampleERC6551Account, 
        ethers.encodeBytes32String(salt.toString()),
        chainId,
        nftAddress,
        tokenId
        ); 

    console.log(account)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
  