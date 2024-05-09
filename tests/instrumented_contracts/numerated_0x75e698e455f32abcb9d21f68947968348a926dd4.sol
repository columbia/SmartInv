1 pragma solidity ^0.4.25;
2 
3 contract artContract{
4 
5     address private contractOwner;              // Contract owner address
6     string public artInfoHash;              // Current Art Information Hash
7     string public artOwnerHash;                 // Current Art Owners Hash
8     bytes32 public summaryTxHash;               // Current Transaction Hash
9     bytes32 public recentInputTxHash;           // Previous Transaction Hash
10 
11     constructor() public{                                                          // creator address
12         contractOwner = msg.sender;
13     }
14         
15     modifier onlyOwner(){                                                          // Only contract creator could change state for security
16         require(msg.sender == contractOwner);
17         _;
18     }
19 
20     function setArtInfoHash(string memory _infoHash) onlyOwner public {            // Set Art infomation Hash
21         artInfoHash = _infoHash;
22     }    
23     
24     function setArtOwnerHash(string memory _artHash) onlyOwner public {            // Set Owner Hash
25         artOwnerHash = _artHash;
26     }    
27  
28     event setTxOnBlockchain(bytes32);
29  
30     function setTxHash(bytes32 _txHash) onlyOwner public {                         // Set transaction Hash value
31         recentInputTxHash = _txHash;                                               // Store input transaction Hash value
32         summaryTxHash = makeHash(_txHash);                                         // Store summary hash(recent + previous hash)
33         emit setTxOnBlockchain(summaryTxHash);
34     }
35  
36     function getArtInfoHash() public view returns (string memory) {               // Get art information hash value
37         return artInfoHash;
38     }
39 
40     function getArtOwnerHash() public view returns (string memory) {               // Get art owner hash value
41         return artOwnerHash;
42     }
43 
44     function getRecentInputTxHash() public view returns (bytes32) {                     // Get current Transaction Hash
45         return recentInputTxHash;
46     }
47 
48     function getSummaryTxHash() public view returns (bytes32) {                     // Get current Transaction Hash
49         return summaryTxHash;
50     }
51 
52     function makeHash(bytes32 _input) private view returns(bytes32) {         // hash function, summary with previousTxHash and inTxHash
53         return keccak256(abi.encodePacked(_input, summaryTxHash));
54     }
55 }