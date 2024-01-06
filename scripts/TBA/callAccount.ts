import { ethers } from "hardhat";
import { BytesLike } from "ethers";
import { artifacts } from "hardhat";
import { load } from 'ts-dotenv';
import { sign } from "viem/_types/accounts/utils/sign";

const env = load({
  WALLET_PRIVATE_KEY: String,
  ETHERSCAN_API_KEY: String
});

const myAccountAddress = ethers.getAddress("0x2a2CE8A9f2E288DD7a2BD2ff776f4219FfDE3E8B");
const tokenAddress = ethers.getAddress("0x9983F755Bbd60d1886CbfE103c98C272AA0F03d6");
const myAddress = "0x6f9e2777D267FAe69b0C5A24a402D14DA1fBcaA1";

const func = ethers.id("transfer(address,uint256)"); //https://docs.ethers.org/v6/api/hashing/#id
const signature = func.slice(0,10);
console.log(func)
console.log(signature);
const receiver = ethers.zeroPadValue(ethers.getAddress("0x6f9e2777D267FAe69b0C5A24a402D14DA1fBcaA1"), 32);
console.log("Receiver ", receiver);
const amount = ethers.toBeHex(ethers.parseEther("0.5"),32);
console.log("Amount   ", amount);

async function main() {
    const provider = ethers.getDefaultProvider(`https://api.avax-test.network/ext/bc/C/rpc`);
    const signer = new ethers.Wallet(env.WALLET_PRIVATE_KEY, provider);

    const accountArtifacts = await artifacts.readArtifact("IERC6551Executable");
    const abi =  accountArtifacts.abi;
    const account = new ethers.Contract(myAccountAddress, abi, signer);
    
    const calldata: BytesLike = signature + receiver.slice(2) + amount.slice(2);
    console.log(amount.slice(2).length);
    console.log("CallData: ", calldata.slice(0,10), calldata.slice(10, 74),calldata.slice(74, 138), " \n" )

    const solver = ethers.getAddress("0x6f9e2777D267FAe69b0C5A24a402D14DA1fBcaA1");
    const seeker = ethers.getAddress("0x6f9e2777D267FAe69b0C5A24a402D14DA1fBcaA1");

    const tx = await account.execute(
        tokenAddress,
        0,
        calldata,
        0
    )

    console.log(tx)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
