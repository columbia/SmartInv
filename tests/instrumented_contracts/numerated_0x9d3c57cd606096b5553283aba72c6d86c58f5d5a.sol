1 pragma solidity ^0.4.18;
2 
3 contract crowdsale  {
4 
5 mapping(address => bool) public whiteList;
6 event logWL(address wallet, uint256 currenttime);
7 
8     function addToWhiteList(address _wallet) public  {
9         whiteList[_wallet] = true;
10         logWL (_wallet, now);
11     }
12 }