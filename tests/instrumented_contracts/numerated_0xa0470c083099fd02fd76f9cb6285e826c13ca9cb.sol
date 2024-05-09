1 pragma solidity ^0.4.21;
2 
3 contract IPFSStore {
4     mapping (uint256 => string) hashes;
5     address owner;
6 
7     function IPFSStore() public {
8         owner = msg.sender;
9     }
10 
11     function setHash(uint256 time_stamp, string ipfs_hash) public {
12         require(msg.sender == owner);
13         hashes[time_stamp] = ipfs_hash;
14     }
15 
16     function getHash(uint256 time_stamp) constant public returns (string) {
17         return hashes[time_stamp];
18     }
19 }