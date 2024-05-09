1 pragma solidity ^0.4.18;
2 
3 contract Proteania {
4 
5     uint256 public totalSupply = 65*10**27;
6     address owner;
7     string public name = "Proteania";
8     uint8 public decimals = 18;
9     string public symbol = "PRN";
10     mapping (address => uint256) balances;
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     
13 
14     constructor() public {
15         owner = msg.sender;
16         balances[owner] = totalSupply;
17     }
18     
19     function() payable {
20         revert();
21     }
22 
23     function transfer(address _to, uint256 _value) public returns (bool success) {
24         require(balances[msg.sender] >= _value);
25         balances[msg.sender] -= _value;
26         balances[_to] += _value;
27         emit Transfer(msg.sender, _to, _value);
28         return true;
29     }
30 
31     function balanceOf(address _owner) constant public returns (uint256 balance) {
32         return balances[_owner];
33     }
34 
35 }