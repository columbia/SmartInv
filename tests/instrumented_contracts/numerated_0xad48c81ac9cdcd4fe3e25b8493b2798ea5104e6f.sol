1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // On-Chain Directory by 0xInuarashi.eth
5 // Discord: 0xInuarashi#1234 | Twitter: https://twitter.com/0xInuarashi
6 // For use with Martian Market, and any other open interfaces built by anyone.
7 
8 contract onChainDiscordDirectory {
9 
10     // On Chain Discord Directory
11     mapping(address => string) public addressToDiscord;
12     function setDiscordIdentity(string calldata discordTag_) external {
13         addressToDiscord[msg.sender] = discordTag_;
14     }
15 
16     // Your Twitter if you are adventurous
17     mapping(address => string) public addressToTwitter;
18     function setTwitterIdentity(string calldata twitterTag_) external {
19         addressToTwitter[msg.sender] = twitterTag_;
20     }
21 }