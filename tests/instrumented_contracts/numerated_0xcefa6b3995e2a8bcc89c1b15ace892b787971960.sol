1 pragma solidity ^0.4.8;
2 
3 contract SOA {
4     /* Public variables of the token */
5     string public name = 'SOA Test Token';
6     string public symbol = 'SOA';
7     uint8 public decimals = 2;
8     uint256 public totalSupply = 10000; // 100 
9 
10     /* This creates an array with all balances */
11     mapping (address => uint256) public balanceOf;
12 
13     /* This generates a public event on the blockchain that will notify clients */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     /* Initializes contract with initial supply tokens to the creator of the contract */
17     function SOA() {
18         balanceOf[msg.sender] = totalSupply;
19     }
20 
21     /* Send coins */
22     function transfer(address _to, uint256 _value) {
23         assert(_to != 0x0);
24         assert(balanceOf[msg.sender] >= _value);
25         assert(balanceOf[_to] + _value >= balanceOf[_to]);
26         balanceOf[msg.sender] -= _value;
27         balanceOf[_to] += _value;
28         Transfer(msg.sender, _to, _value);
29     }
30 
31     function balanceOf(address _owner) constant returns (uint256 balance) {
32         return balanceOf[_owner];
33     }
34 }