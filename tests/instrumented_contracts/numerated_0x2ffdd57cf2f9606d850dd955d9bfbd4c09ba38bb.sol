1 pragma solidity 0.6.12;
2 
3 contract GenTelegram {
4     mapping(address => string) public telegrams;
5 
6     function setTelegram(string calldata telegram) external {
7         telegrams[msg.sender] = telegram;
8     }
9 }