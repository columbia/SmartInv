1 pragma solidity ^0.4.19;
2 
3 contract EthAvatar {
4     mapping (address => string) private ipfsHashes;
5 
6     event DidSetIPFSHash(address indexed hashAddress, string hash);
7 
8 
9     function setIPFSHash(string hash) public {
10         ipfsHashes[msg.sender] = hash;
11 
12         DidSetIPFSHash(msg.sender, hash);
13     }
14 
15     function getIPFSHash(address hashAddress) public view returns (string) {
16         return ipfsHashes[hashAddress];
17     }
18 }