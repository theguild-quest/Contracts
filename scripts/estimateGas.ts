import { createPublicClient, http } from 'viem'
import { mainnet } from 'viem/chains'
import  { abi } from '../artifacts/contracts/Tavern.sol/Tavern.json'

async function main() {
const client = createPublicClient({
  chain: mainnet,
  transport: http()
})

// const gas = await client.estimateContractGas(abi
//   , 
//   functionName: 'mint'
// })
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });