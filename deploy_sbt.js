const hre = require("hardhat");

async function main() {
  const [admin, issuer] = await hre.getSigners();

  const SBT = await hre.ethers.getContractFactory("SoulboundIdentity");
  const sbt = await SBT.deploy("CitizenID", "CID");

  await sbt.waitForDeployment();
  const sbtAddr = await sbt.getAddress();

  // Grant the Issuer Role to a specific service address
  const ISSUER_ROLE = await sbt.ISSUER_ROLE();
  await sbt.grantRole(ISSUER_ROLE, issuer.address);

  console.log(`Soulbound Registry deployed to: ${sbtAddr}`);
  console.log(`Issuer role granted to: ${issuer.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
