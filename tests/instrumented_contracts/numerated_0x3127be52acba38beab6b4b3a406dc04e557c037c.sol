1 pragma solidity ^0.4.20;
2 
3 contract PLATPriceOracle {
4 
5   mapping (address => bool) admins;
6 
7   // How much PLAT you get for 1 ETH, multiplied by 10^18
8   uint256 public ETHPrice = 60000000000000000000000;
9 
10   event PriceChanged(uint256 newPrice);
11 
12   constructor() public {
13     admins[msg.sender] = true;
14   }
15 
16   function updatePrice(uint256 _newPrice) public {
17     require(_newPrice > 0);
18     require(admins[msg.sender] == true);
19     ETHPrice = _newPrice;
20     emit PriceChanged(_newPrice);
21   }
22 
23   function setAdmin(address _newAdmin, bool _value) public {
24     require(admins[msg.sender] == true);
25     admins[_newAdmin] = _value;
26   }
27 }