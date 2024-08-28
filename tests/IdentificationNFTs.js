const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("KYC", function () {
    let KYC, kyc, owner, addr1, addr2;

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        KYC = await ethers.getContractFactory("KYC");
        kyc = await KYC.deploy(owner.address);
        await kyc.deployed();
    });

    it("Should deploy with the correct owner", async function () {
        expect(await kyc.owner()).to.equal(owner.address);
    });

    it("Should mint an NFT and assign it to a user", async function () {
        const metadata = '{"name": "User 1 NFT"}';
        const tokenId = await kyc.createNFT(addr1.address, metadata);

        expect(await kyc.ownerOf(0)).to.equal(addr1.address);
        const userNFTs = await kyc.retrieveNFTs(addr1.address);
        expect(userNFTs.length).to.equal(1);
        expect(userNFTs[0]).to.equal(0);
    });

    it("Should increment the tokenCounter correctly", async function () {
        await kyc.createNFT(addr1.address, '{"name": "User 1 NFT"}');
        await kyc.createNFT(addr2.address, '{"name": "User 2 NFT"}');

        expect(await kyc.ownerOf(1)).to.equal(addr2.address);
        const addr1NFTs = await kyc.retrieveNFTs(addr1.address);
        const addr2NFTs = await kyc.retrieveNFTs(addr2.address);
        expect(addr1NFTs.length).to.equal(1);
        expect(addr2NFTs.length).to.equal(1);
    });

    it("Should emit an NFTcreated event when an NFT is created", async function () {
        await expect(kyc.createNFT(addr1.address, '{"name": "User 1 NFT"}'))
            .to.emit(kyc, 'NFTcreated')
            .withArgs(addr1.address, 0);
    });

    it("Should allow only the owner to create NFTs", async function () {
        await expect(
            kyc.connect(addr1).createNFT(addr1.address, '{"name": "User 1 NFT"}')
        ).to.be.revertedWith("Ownable: caller is not the owner");
    });

    it("Should allow only the owner to retrieve NFTs of a user", async function () {
        await kyc.createNFT(addr1.address, '{"name": "User 1 NFT"}');

        await expect(kyc.connect(addr1).retrieveNFTs(addr1.address))
            .to.be.revertedWith("Ownable: caller is not the owner");
    });

    it("Should return all NFTs owned by a user", async function () {
        await kyc.createNFT(addr1.address, '{"name": "User 1 NFT"}');
        await kyc.createNFT(addr1.address, '{"name": "User 2 NFT"}');

        const userNFTs = await kyc.retrieveNFTs(addr1.address);
        expect(userNFTs.length).to.equal(2);
        expect(userNFTs[0]).to.equal(0);
        expect(userNFTs[1]).to.equal(1);
    });
});
