import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  networks: {
    hardhat: {},
    localhost: {
      url: "HTTP://127.0.0.1:7545",
    },
  },
};

export default config;
