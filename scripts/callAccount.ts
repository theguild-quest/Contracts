import { ethers } from "hardhat";
import { artifacts } from "hardhat";
import { load } from 'ts-dotenv';

const env = load({
  WALLET_PRIVATE_KEY: String,
  ETHERSCAN_API_KEY: String
});

const myAccountAddress = ethers.getAddress("0x00B2140A27ac9003cc8693e2ad3CE48002BD7B37");
const tokenAddress = ethers.getAddress("0x9983F755Bbd60d1886CbfE103c98C272AA0F03d6");

async function main() {
    const provider = ethers.getDefaultProvider(`https://api.avax-test.network/ext/bc/C/rpc`);
    const signer = new ethers.Wallet(env.WALLET_PRIVATE_KEY, provider);

    const accountArtifacts = await artifacts.readArtifact("ERC6551Account");
    const abi =  accountArtifacts.abi;
    const account = new ethers.Contract(myAccountAddress, abi, signer);

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


// 3-transfer.ts
 
import { formatEther, parseEther } from "ethers";
import { TBAccountParams } from "@tokenbound/sdk/dist/src/TokenboundClient";
import client, {wallet, provider, tokenBoundAccount, displayBalance} from "./client";
 
// transfer eth from B -> A
(async () => {
  console.log(`wallet: ${wallet.address}`);
  await displayBalance(wallet.address);
  console.log(`TBA address: ${tokenBoundAccount}`)
  displayBalance(tokenBoundAccount)
 
  const amount = parseEther("1");
  console.log(`sending ${formatEther(amount)} ETH from ${tokenBoundAccount} to ${wallet.address}`);
 
  const executedCall = await client.executeCall({
    account: tokenBoundAccount,
    to: wallet.address  as TBAccountParams["tokenContract"],
    value: amount,
    data: "",
  });
  console.log("\n---\n",executedCall,"\n---\n");
 
  await provider.waitForTransaction(executedCall);
  await displayBalance(wallet.address);
  await displayBalance(tokenBoundAccount);
})()