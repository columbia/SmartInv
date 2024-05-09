1 pragma solidity ^0.4.24;
2 
3 //
4 // A contract to emit events to track changes of users identity data stored in IPFS.
5 //
6 
7 contract IdentityEvents {
8     event IdentityUpdated(address indexed account, bytes32 ipfsHash);
9     event IdentityDeleted(address indexed account);
10 
11     // @param ipfsHash IPFS hash of the updated identity.
12     function emitIdentityUpdated(bytes32 ipfsHash) public {
13         emit IdentityUpdated(msg.sender, ipfsHash);
14     }
15 
16     function emitIdentityDeleted() public {
17         emit IdentityDeleted(msg.sender);
18     }
19 }