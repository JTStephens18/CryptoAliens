const CryptoAliens = artifacts.require("alienfactory.sol");
const utils = require("./helpers/utils");
const alienNames = ["Alien 1", "Aliens 2"];
contract("alienfactory.sol", (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance;
    beforeEach(async () => {
        contractInstance = await CryptoAliens.new();
    });
    it("should be able to create a new alien", async () => {
        const result = await contractInstance.createRandomAlien(alienNames[0], {from: alice});
        assert.equal(result.receipt.status, true);
        assert.equal(result.logs[0].args.name, alienNames[0]);
    })
    it("should not allow two aliens", async () => {
        await contractInstance.createRandomAlien(alienNames[0], {from: alice});
        await utils.shouldThrow(contractInstance.createRandomAlien(alienNames[1], {from: alice}));
    })

    xcontext("with the single-step transfer scenario", async () => {
        it("should transfer a alien", async () => {
          const result = await contractInstance.createRandomAlien(alienNames[0], {from: alice});
          const alienId = result.logs[0].args.alienId.toNumber();
          await contractInstance.transferFrom(alice, bob, alienId, {from: alice});
          const newOwner = await contractInstance.ownerOf(alienId);
          assert.equal(newOwner, bob);
        })
    })
    xcontext("with the two-step transfer scenario", async () => {
        it("should approve and then transfer a alien when the approved address calls transferFrom", async () => {
          // TODO: Test the two-step scenario.  The approved address calls transferFrom
        })
        it("should approve and then transfer a alien when the owner calls transferFrom", async () => {
            // TODO: Test the two-step scenario.  The owner calls transferFrom
         })
    })
})
