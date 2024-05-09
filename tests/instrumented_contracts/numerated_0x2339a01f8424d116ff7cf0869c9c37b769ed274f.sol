1 pragma solidity ^0.4.20;
2 
3 contract PLATPriceOracle {
4 
5   mapping (address => bool) admins;
6   
7   // How much Eth you get for 1 PLAT, multiplied by 10^18
8   // Default value is the ICO price, make sure you update
9   uint256 public PLATprice = 12500000000000;
10   
11   event PLATPriceChanged(uint256 newPrice);
12     
13   function PLATPriceOracle() public {
14     admins[msg.sender] = true;
15   }
16 
17   function updatePrice(uint256 _newPrice) public {
18     require(_newPrice > 0);
19     require(admins[msg.sender] == true);
20     PLATprice = _newPrice;
21     emit PLATPriceChanged(_newPrice);
22   }
23   
24   function setAdmin(address _newAdmin, bool _value) public {
25     require(admins[msg.sender] == true);
26     admins[_newAdmin] = _value;   
27   }
28 }