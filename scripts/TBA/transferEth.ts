// 3-transfer.ts
 
import { formatEther, parseEther } from "ethers";
//import { TBAccountParams } from "@tokenbound/sdk/dist/src/TokenboundClient";
import client, {wallet, provider, tokenBoundAccount, displayBalance} from "./client";
 
// transfer eth from B -> A
(async () => {
  console.log(`wallet: ${wallet.address}`);
  await displayBalance(wallet.address);
  console.log(`TBA address: ${tokenBoundAccount}`)
  displayBalance(tokenBoundAccount)
 
  const amount = parseEther("1");
  console.log(`sending ${formatEther(amount)} ETH from ${tokenBoundAccount} to ${wallet.address}`);
 
  const executedCall = await client.execute({
    account: tokenBoundAccount,
    to: wallet.address as `0x${string}`,
    value: amount,
    data: "",
  });
  console.log("\n---\n",executedCall,"\n---\n");
 
  await provider.waitForTransaction(executedCall);
  await displayBalance(wallet.address);
  await displayBalance(tokenBoundAccount);
})()