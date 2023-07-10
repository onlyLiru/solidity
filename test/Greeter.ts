import { expect } from "chai";
import { ethers } from "hardhat";
import { Greeter } from "../typechain-types";

describe("Greeter", () => {
  let contract: Greeter;

  beforeEach(async () => {
    const Greeter = await ethers.getContractFactory("Greeter");
    contract = await Greeter.deploy();
  });

  describe("sum", () => {
    it("参数2和3，返回值是：5", async () => {
      await contract.waitForDeployment();
      const sum = await contract.sum(2, 3);

      expect(sum).to.be.not.undefined;
      expect(sum).to.be.not.NaN;
      expect(sum).to.be.not.null;
      expect(sum).to.equal(5);
    });
  });

  describe("getMyLuckyNumber", () => {
    it("saveLuckyNumber(5), getMyLuckyNumber() => 5", async () => {
      await contract.waitForDeployment();
      await contract.saveLuckyNumber(5);
      const num = await contract.getMyLuckyNumber();

      expect(num).to.be.not.NaN;
      expect(num).to.be.not.undefined;
      expect(num).to.be.not.null;
      expect(num).to.be.equal(5);
    });
  });
});
