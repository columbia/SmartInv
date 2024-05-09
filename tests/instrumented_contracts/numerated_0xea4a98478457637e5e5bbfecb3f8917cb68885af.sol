1 pragma solidity ^0.4.16;
2 
3 contract DiscordLink {
4     mapping (bytes => address) private linkage;
5     
6     function setLink(bytes didHash) {
7         require(linkage[didHash] == 0x0);
8         linkage[didHash] = msg.sender;
9     }
10     
11     function changeLink(bytes didHash, address newAddress) {
12         require(linkage[didHash] == msg.sender);
13         linkage[didHash] = newAddress;
14     }
15     
16     function getOwner(bytes didHash) constant returns(address) {
17         return linkage[didHash];
18     }
19 }