const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();

const infuraProjectId = process.env.INFURA_PROJECT_ID;
const deployerPrivateKey = process.env.DEPLOYER_PRIVATE_KEY;

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",    
      port: 8545,       
      network_id: "*",   
      gas: 8000000,         
      gasPrice: 2000000000,  
    },
    polygon_mumbai: { 
      provider: () => new HDWalletProvider(
        deployerPrivateKey,
        `wss://polygon-mumbai.infura.io/ws/v3/${infuraProjectId}`,
      ),
      network_id: 80001, 
      gas: 8000000, 
      gasPrice: 1000000000, 
      confirmations: 2,
      timeoutBlocks: 200,
      networkTimeout: 10000000,
    },
    polygon: { //prod
      provider: () => new HDWalletProvider(
        deployerPrivateKey,
        `wss://polygon-mainnet.infura.io/ws/v3/${infuraProjectId}`,
      ),
      network_id: 137,
      gas: 6000000, 
      gasPrice: 15000000000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      networkTimeout: 10000,
      pollingInterval: 15000
    },
  },
  compilers: {
    solc: {
      version: "0.5.16",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
  },
};
