1 pragma solidity ^0.5.9;
2 
3 
4 contract StoredBatches {
5 
6     struct Batch {
7         string ipfsHash;
8     }
9 
10     event Update(string ipfsHash);
11 
12     address protocol;
13 
14     constructor() public {
15         protocol = msg.sender;
16     }
17 
18     modifier onlyProtocol() {
19         if (msg.sender == protocol) {
20             _;
21         }
22     }
23 
24     Batch[] public batches;
25 
26 
27     /// Option to reduce gas usage: https://ethereum.stackexchange.com/questions/17094/how-to-store-ipfs-hash-using-bytes
28     function registerBatch(string memory _ipfsHash) public onlyProtocol {
29         batches.push(Batch(_ipfsHash));
30         emit Update(_ipfsHash);
31     }
32 }