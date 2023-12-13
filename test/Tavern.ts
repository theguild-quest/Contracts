import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
  import { expect } from "chai";
  import { ethers } from "hardhat";
  
  describe("Tavern", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployTavernFixture() {

      const ONE_GWEI = 1_000_000_000;
  
      const lockedAmount = ONE_GWEI;
  
      // Contracts are deployed using the first signer/account by default
      const [owner, seeker, solver] = await ethers.getSigners();
      
      const QuestImplementation = await ethers.getContractFactory("Quest");
      const EscrowImplementation = await ethers.getContractFactory("Escrow");

      const questImpl = await QuestImplementation.deploy();
      const escrowImpl = await EscrowImplementation.deploy([]);

      const Tavern = await ethers.getContractFactory("Tavern");
      const tavern = await Tavern.deploy(questImpl.target, escrowImpl.target);
  
      return { tavern, questImpl, escrowImpl, owner, seeker, solver };
    }
  
    describe("Deployment", function () {
      it("Should set the right quest and escrow implementation addresses", async function () {
        const { tavern, questImpl, escrowImpl } = await loadFixture(deployTavernFixture);
  
        expect(await tavern.escrowImplementation()).to.equal(escrowImpl.target);
        expect(await tavern.questImplementation()).to.equal(questImpl.target);
      });
  
      it("Should set the right owner", async function () {
        const { tavern, owner } = await loadFixture(deployTavernFixture);
  
        expect(await tavern.owner()).to.equal(owner.address);
      });
  

  
    //   it("Should fail if the unlockTime is not in the future", async function () {
    //     // We don't use the fixture here because we want a different deployment
    //     const latestTime = await time.latest();
    //     const Lock = await ethers.getContractFactory("Lock");
    //     await expect(Lock.deploy(latestTime, { value: 1 })).to.be.revertedWith(
    //       "Unlock time should be in the future"
    //     );
    //   });
    });
  
    describe("QuestCreation", function () {
      describe("Creation", function () {
        it("should create the escrow proxy", async function () {
            const { tavern, seeker, solver } = await loadFixture(deployTavernFixture)
            
            const questCreation = await tavern.startNewQuest(solver.address, seeker.address, 100n, "");
            await expect(questCreation).to.emit(tavern,"QuestCreated");
        });
  
        // it("Should revert with the right error if called from another account", async function () {
        //   const { lock, unlockTime, otherAccount } = await loadFixture(
        //     deployOneYearLockFixture
        //   );
  
        //   // We can increase the time in Hardhat Network
        //   await time.increaseTo(unlockTime);
  
        //   // We use lock.connect() to send a transaction from another account
        //   await expect(lock.connect(otherAccount).withdraw()).to.be.revertedWith(
        //     "You aren't the owner"
        //   );
        });
  
        // it("Shouldn't fail if the unlockTime has arrived and the owner calls it", async function () {
        //   const { lock, unlockTime } = await loadFixture(
        //     deployOneYearLockFixture
        //   );
  
        //   // Transactions are sent using the first signer by default
        //   await time.increaseTo(unlockTime);
  
        //   await expect(lock.withdraw()).not.to.be.reverted;
        // });
      });
  
//       describe("Events", function () {
//         it("Should emit an event on withdrawals", async function () {
//           const { lock, unlockTime, lockedAmount } = await loadFixture(
//             deployOneYearLockFixture
//           );
  
//           await time.increaseTo(unlockTime);
  
//           await expect(lock.withdraw())
//             .to.emit(lock, "Withdrawal")
//             .withArgs(lockedAmount, anyValue); // We accept any value as `when` arg
//         });
//       });
  
//       describe("Transfers", function () {
//         it("Should transfer the funds to the owner", async function () {
//           const { lock, unlockTime, lockedAmount, owner } = await loadFixture(
//             deployOneYearLockFixture
//           );
  
//           await time.increaseTo(unlockTime);
  
//           await expect(lock.withdraw()).to.changeEtherBalances(
//             [owner, lock],
//             [lockedAmount, -lockedAmount]
//           );
//         });
//       });
//     });
//   });

});