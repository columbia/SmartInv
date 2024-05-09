1 pragma solidity ^0.4.23;
2 
3 interface TokenContract {
4   function transfer(address _to, uint256 _value) external returns (bool);
5 }
6 
7 contract Airdrop {
8   address public owner;
9   bool public isTheContract = true;
10 
11   constructor() public {
12   
13     owner = msg.sender;
14   }
15 
16   function sendTokens(address[] addresses, uint256[] _amount, address _tokenAddress) public {
17     //require(msg.sender == owner);
18     uint256 addressCount = addresses.length;
19     uint256 amountCount = _amount.length;
20     require(addressCount == amountCount);
21     TokenContract tkn = TokenContract(_tokenAddress);
22     for (uint256 i = 0; i < addressCount; i++) {
23       tkn.transfer(addresses[i], _amount[i]);
24     }
25   }
26 
27   function destroyMe() public {
28     require(msg.sender == owner);
29     selfdestruct(owner);
30   }
31     
32 }