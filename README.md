# Commands to run

This project demonstrates a prototype for how a deepfake detector tool will generate and store NFTs. Use the following commands to get the entire setup running:

```shell
npx hardhat node
npx hardhat deploy scripts/deploy.js --network localhost
npx http-server .
```

Additionally, this needs an IPFS node to be up and running. We used the [Kubo](https://docs.ipfs.tech/install/command-line/) client to setup the node and use the same on our frontend.