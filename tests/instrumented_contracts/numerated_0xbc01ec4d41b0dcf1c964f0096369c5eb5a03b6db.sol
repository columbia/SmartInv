1 pragma solidity ^0.4.23;
2 
3 
4 contract TokenSwap{
5     mapping (address=>address) internal _swapMap;
6     event NBAIRegister (address ERC20Wallet, address NBAIWallet);
7 
8     constructor() public{
9     }
10 
11     function register(address NBAIWallet) public{
12         require(_swapMap[msg.sender] == address(0));
13         _swapMap[msg.sender] = NBAIWallet;
14         emit NBAIRegister(msg.sender, NBAIWallet);
15     }
16 
17     function getNBAIWallet (address ERC20Wallet) constant public returns (address){
18         return _swapMap[ERC20Wallet];
19     }
20 }