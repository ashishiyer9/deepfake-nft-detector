async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const kyc = await ethers.getContractFactory("KYC");
    const KYC = await kyc.deploy(deployer.address);

    console.log("KYC deployed to:", KYC.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
