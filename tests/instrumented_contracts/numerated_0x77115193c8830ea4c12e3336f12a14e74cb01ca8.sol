1 pragma solidity ^0.4.24;
2 
3 contract Fomo3DContractKeyBuyProxyInterface {
4     LongInterface private long_ = LongInterface(0xa62142888aba8370742be823c1782d17a0389da1);
5     uint contractCount = 0;
6     mapping(uint => ChildContract) public myContracts;
7 
8     function buyKeysProxy() external payable {
9 
10         contractCount++;
11         //msg.sender
12         (uint256 referralId,
13         bytes32 name,
14         uint256 keysOwned,
15         uint256 vaultWinnings,
16         uint256 vaultGeneral,
17         uint256 affiliateVault,
18         uint256 playerRndEth) = long_.getPlayerInfoByAddress(msg.sender);
19     
20         myContracts[contractCount] = (new ChildContract).value(msg.value)(referralId);
21         //(new ChildContract).value(msg.value)(referralId);
22     }
23 }
24 
25 contract ChildContract {
26     LongInterface private long_ = LongInterface(0xa62142888aba8370742be823c1782d17a0389da1);
27 
28     constructor(uint256 referralId) public payable {
29         long_.buyXid.value(msg.value)(referralId, 2);
30     }
31 }
32 
33 
34 interface LongInterface {
35     function buyXid(uint256 _affCode, uint256 _team) public payable;
36     function getPlayerInfoByAddress(address _addr) public returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256);
37 }