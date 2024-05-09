1 pragma solidity ^0.4.24;
2 contract MyToken {
3     /* Public variables of the token */
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7 
8     /* This creates an array with all balances */
9     mapping (address => uint256) public balanceOf;
10 
11     /* This generates a public event on the blockchain that will notify clients */
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     /* Initializes contract with initial supply tokens to the creator of the contract */
15     constructor(uint256 _supply, string _name, string _symbol, uint8 _decimals) public {
16         /* if supply not given then generate 1 million of the smallest unit of the token */
17         if (_supply == 0) _supply = 1000000;
18 
19         /* Unless you add other functions these variables will never change */
20         balanceOf[msg.sender] = _supply;
21         name = _name;
22         symbol = _symbol;
23 
24         /* If you want a divisible token then add the amount of decimals the base unit has  */
25         decimals = _decimals;
26     }
27 
28     /* Send coins */
29     function transfer(address _to, uint256 _value) public {
30         /* if the sender doenst have enough balance then stop */
31         if (balanceOf[msg.sender] < _value) {revert();}
32         if (balanceOf[_to] + _value < balanceOf[_to]) {revert();}
33 
34         /* Add and subtract new balances */
35         balanceOf[msg.sender] -= _value;
36         balanceOf[_to] += _value;
37 
38         /* Notifiy anyone listening that this transfer took place */
39         emit Transfer(msg.sender, _to, _value);
40     }
41 }