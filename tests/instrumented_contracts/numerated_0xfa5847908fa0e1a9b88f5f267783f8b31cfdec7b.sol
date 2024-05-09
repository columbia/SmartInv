1 pragma solidity ^0.4.21;
2 
3 contract TPPC2018Token {
4   address public owner;
5   string public name;
6   string public symbol;
7   uint public decimals;
8   uint256 public totalSupply;
9 
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 
12   /* This creates an array with all balances */
13   mapping (address => uint256) public balanceOf;
14 
15   function TPPC2018Token(uint256 initialSupply, string tokenName, string tokenSymbol, uint decimalUnits) public {
16     owner = msg.sender;
17     totalSupply = initialSupply * 10 ** uint256(decimals);
18     balanceOf[msg.sender] = totalSupply;
19     name = tokenName;
20     symbol = tokenSymbol;
21     decimals = decimalUnits;
22   }
23 
24   /* Send coins */
25   function transfer(address _to, uint256 _value) public {
26     /* Check if the sender has balance and for overflows */
27     require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
28 
29     /* Add and subtract new balances */
30     balanceOf[msg.sender] -= _value;
31     balanceOf[_to] += _value;
32 
33     /* Notify anyone listening that this transfer took place */
34     emit Transfer(msg.sender, _to, _value);
35   }
36 }