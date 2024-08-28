require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require('@nomiclabs/hardhat-waffle');

const { INFURA_API_KEY, PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  defaultNetwork: "sepolia",
  networks: {
    hardhat: {},
    sepolia: {
      url: INFURA_API_KEY,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  },
};
