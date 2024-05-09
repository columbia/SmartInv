1 pragma solidity ^0.4.18;
2 
3 contract Phillionex {
4 
5     uint256 public totalSupply = 55*10**27;
6     string public name = "Phillionex";
7     uint8 public decimals = 18;
8     string public symbol = "PHN";
9     mapping (address => uint256) balances;
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     
12 
13     constructor() public {
14         balances[0xcad39D48CC441d472Cf0446C9BEB0Ce3aF3e3BF9] = totalSupply;
15     }
16     
17     function() payable {
18         revert();
19     }
20 
21     function transfer(address _to, uint256 _value) public returns (bool success) {
22         require(balances[msg.sender] >= _value);
23         balances[msg.sender] -= _value;
24         balances[_to] += _value;
25         emit Transfer(msg.sender, _to, _value);
26         return true;
27     }
28 
29     function balanceOf(address _owner) constant public returns (uint256 balance) {
30         return balances[_owner];
31     }
32 
33 }