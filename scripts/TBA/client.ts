// client.ts
 
 
import { TokenboundClient } from "@tokenbound/sdk";
import { JsonRpcProvider, Wallet, formatEther } from "ethers";
import { CONSTANTS } from "./constants"
//import { TBAccountParams } from "@tokenbound/sdk/dist/src/TokenboundClient";
 
const { CHAIN_ID, NFT_CONTRACT, NFT_ID, RPC, ACCOUNT_IMPLEMENTATION } = CONSTANTS;
 
export const provider = new JsonRpcProvider(RPC);
 
 
export const wallet = new Wallet(process.env.WALLET_PRIVATE_KEY!, provider);
 
const tokenboundClient = new TokenboundClient({
  signer: wallet,
  chainId: CHAIN_ID,
  implementationAddress: ACCOUNT_IMPLEMENTATION as `0x${string}`
});
 
export const tokenBoundAccount = tokenboundClient.getAccount({
  tokenContract: NFT_CONTRACT as `0x${string}`,
  tokenId: NFT_ID,
});
 
// util function to display balance
export const displayBalance = async (address: string) => {
  const balance = await provider.getBalance(address);
  console.log(`balance of ${address}: ${formatEther(balance)}`)
}
 
export default tokenboundClient;