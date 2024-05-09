1 pragma solidity ^0.4.21;
2 
3 contract NetkillerToken {
4   string public name;
5   string public symbol;
6   uint public decimals;
7 
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 
10   /* This creates an array with all balances */
11   mapping (address => uint256) public balanceOf;
12 
13   function NetkillerToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint decimalUnits) public {
14     balanceOf[msg.sender] = initialSupply;
15     name = tokenName;
16     symbol = tokenSymbol;
17     decimals = decimalUnits;
18   }
19 
20   /* Send coins */
21   function transfer(address _to, uint256 _value) public {
22     /* Check if the sender has balance and for overflows */
23     require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
24 
25     /* Add and subtract new balances */
26     balanceOf[msg.sender] -= _value;
27     balanceOf[_to] += _value;
28 
29     /* Notify anyone listening that this transfer took place */
30     emit Transfer(msg.sender, _to, _value);
31   }
32 }