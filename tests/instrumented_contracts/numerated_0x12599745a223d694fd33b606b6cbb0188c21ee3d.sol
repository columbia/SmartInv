1 pragma solidity ^0.5.0;
2 contract ABYSSPriceOracle {
3   mapping (address => bool) admins;
4   // How much Tokens you get for 1 ETH, multiplied by 10^18
5   uint256 public ETHPrice = 19470 * 1000000000000000000;
6   event PriceChanged(uint256 newPrice);
7   constructor() public {
8     admins[msg.sender] = true;
9   }
10   function updatePrice(uint256 _newPrice) public {
11     require(_newPrice > 0);
12     require(admins[msg.sender] == true);
13     ETHPrice = _newPrice;
14     emit PriceChanged(_newPrice);
15   }
16   function setAdmin(address _newAdmin, bool _value) public {
17     require(admins[msg.sender] == true);
18     admins[_newAdmin] = _value;
19   }
20 }