1 pragma solidity ^0.4.16;
2 
3 contract VaraToken {
4 
5     string public name = "Vara";
6     string public symbol = "VAR";
7     uint8 public decimals = 18;
8     uint256 public initialSupply = 100000000;
9 
10     uint256 totalSupply;
11     address public owner;
12 
13     mapping (address => uint256) public balanceOf;
14 
15     function VaraToken() public {
16         totalSupply = initialSupply * 10 ** uint256(decimals);
17         owner = 0x86f8001374eeCA3530158334198637654B81f702;
18         balanceOf[owner] = totalSupply;
19     }
20 
21     function transfer(address _to, uint256 _value) public {
22         require(balanceOf[msg.sender] >= _value);
23         require(balanceOf[_to] + _value >= balanceOf[_to]);
24         balanceOf[msg.sender] -= _value;
25         balanceOf[_to] += _value;
26     }
27 
28     function () payable public {
29         require(msg.value > 0 ether);
30         require(now > 1514678400);              // 12/12/2017
31         require(now < 1519776000);              // 28/2/2018
32         uint256 amount = msg.value * 750;
33         require(balanceOf[owner] >= amount);
34         require(balanceOf[msg.sender] < balanceOf[msg.sender] + amount);
35         balanceOf[owner] -= amount;
36         balanceOf[msg.sender] += amount;
37         owner.transfer(msg.value);
38     }
39 }