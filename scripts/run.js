const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to: ", nftContract.address);

  let number = await nftContract.getTotalNFTsMinted();

  let txn = await nftContract.makeAnEpicNFT();

  await txn.wait();
  number = await nftContract.getTotalNFTsMinted();

  txn = await nftContract.makeAnEpicNFT();

  await txn.wait();

  number = await nftContract.getTotalNFTsMinted();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
};

runMain();
