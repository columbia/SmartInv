1 pragma solidity ^0.4.19;
2 
3 /* Playground and ERC20 testing by Carl Oscar Aaro */
4 /* https://carloscar.com/ */
5 contract CarlosCoin {
6     string public name = "Carlos Coin";
7     string public symbol = "CARLOS";
8     uint8 public decimals = 18;
9 
10     uint256 public totalSupply = 1000000 * 10 ** uint256(decimals);
11 
12     mapping (address => uint256) public balanceOf;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     function CarlosCoin() public {
17         balanceOf[msg.sender] = totalSupply;
18     }
19 
20     function transfer(address _to, uint256 _value) public {
21         require(_to != 0x0);
22         require(balanceOf[msg.sender] >= _value);
23         require(balanceOf[_to] + _value > balanceOf[_to]);
24 
25         balanceOf[msg.sender] -= _value;
26         balanceOf[_to] += _value;
27         Transfer(msg.sender, _to, _value);
28     }
29 }