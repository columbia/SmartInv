1 pragma solidity ^0.4.21;
2 
3 contract CioCoinERC21Token {
4   address public owner;
5   string public name;
6   string public symbol;
7   uint public decimals;
8   uint256 public totalSupply;
9   event Transfer(address indexed from, address indexed to, uint256 value);
10   mapping (address => uint256) public balanceOf;
11   
12   function CioCoinERC21Token(uint256 initialSupply, string tokenName, string tokenSymbol, uint decimalUnits) public {
13     owner = msg.sender;
14     totalSupply = initialSupply * 10 ** uint256(decimals);
15     balanceOf[msg.sender] = totalSupply;
16     name = tokenName;
17     symbol = tokenSymbol;
18     decimals = decimalUnits;
19   }
20 
21   function transfer(address _to, uint256 _value) public {
22     require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
23     balanceOf[msg.sender] -= _value;
24     balanceOf[_to] += _value;
25     emit Transfer(msg.sender, _to, _value);
26   }
27 }