const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();

const infuraProjectId = process.env.INFURA_PROJECT_ID;
const deployerPrivateKey = process.env.DEPLOYER_PRIVATE_KEY;

module.exports = {
  networks: {
    polygon: {
      provider: () => new HDWalletProvider(
        deployerPrivateKey,
        `https://polygon-mainnet.infura.io/v3/${infuraProjectId}`,
        0,
        10, 
        true, 
        "m/44'/60'/0'/0/", 
      ),
      network_id: 137, 
      gas: 5500000,
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
