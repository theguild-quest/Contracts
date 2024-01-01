// client.ts
 
 
import { TokenboundClient } from "@tokenbound/sdk";
import { JsonRpcProvider, Wallet, formatEther } from "ethers";
import { CONSTANTS } from "./constants"
import { TBAccountParams } from "@tokenbound/sdk/dist/src/TokenboundClient";
 
const { CHAIN_ID, NFT_CONTRACT, NFT_ID, RPC, ACCOUNT_IMPLEMENTATION } = CONSTANTS;
 
export const provider = new JsonRpcProvider(RPC);
 
 
if (!process.env.TEST_ACCOUNT) {
  console.error ("TEST_ACCOUNT private key undefined in .env");
  process.exit();
}
 
 
export const wallet = new Wallet(process.env.TEST_ACCOUNT, provider);
 
 
const tokenboundClient = new TokenboundClient({
  signer: wallet,
  chainId: CHAIN_ID,
  implementationAddress: ACCOUNT_IMPLEMENTATION as `0x${string}`
});
 
export const tokenBoundAccount = tokenboundClient.getAccount({
  tokenContract: NFT_CONTRACT as TBAccountParams["tokenContract"],
  tokenId: NFT_ID,
});
 
// util function to display balance
const displayBalance = async (address: string) => {
  const balance = await provider.getBalance(address);
  console.log(`balance of ${address}: ${formatEther(balance)}`)
}
 
export default tokenboundClient;