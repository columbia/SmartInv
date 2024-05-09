1 pragma solidity ^0.4.17;
2 
3 contract TradingHistoryStorage {
4     address public contractOwner;
5     address public genesisVisionAdmin;
6     string public ipfsHash;
7 
8     event NewIpfsHash(string newIpfsHash);
9     event NewGenesisVisionAdmin(address newGenesisVisionAdmin);
10     
11     modifier ownerOnly() {
12         require(msg.sender == contractOwner);
13         _;
14     }
15 
16     modifier gvAdminAndOwnerOnly() {
17         require(msg.sender == genesisVisionAdmin || msg.sender == contractOwner);
18         _;
19     }
20 
21     constructor() {
22         contractOwner = msg.sender;
23     }
24 
25     function updateIpfsHash(string newIpfsHash) public gvAdminAndOwnerOnly() {
26         ipfsHash = newIpfsHash;
27         emit NewIpfsHash(ipfsHash);
28     }
29 
30     function setGenesisVisionAdmin(address newGenesisVisionAdmin) public ownerOnly() {
31         genesisVisionAdmin = newGenesisVisionAdmin;
32         emit NewGenesisVisionAdmin(genesisVisionAdmin);
33     }
34 
35 }