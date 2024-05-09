1 pragma solidity ^0.4.11;
2 
3 contract MichaelCoin {
4 
5 
6   mapping (address => uint256) balances;
7   mapping (address => mapping (address => uint256)) allowed;
8 
9 
10   string public name = "Michael Coin";
11   string public symbol = "MC";
12   uint8 public decimals = 18;
13   uint256 public totalAmount = 1000000 ether;
14 
15   event Transfer (address indexed _from, address indexed _to, uint256 _value);
16   event Approval (address indexed _owner, address indexed _spender, uint256 _value);
17 
18   function MichaelCoin() {
19     // constructor
20     balances[msg.sender] = totalAmount;
21   }
22   function totalSupply() constant returns(uint) {
23         return totalAmount;
24     }
25   function transfer (address _to, uint256 _value) returns (bool success) {
26     if (balances[msg.sender] >= _value
27         && balances[_to] + _value > balances[_to]) {
28       balances[msg.sender] -= _value;
29       balances[_to] += _value;
30       Transfer(msg.sender, _to, _value);
31       return true;
32     } else { return false; }
33   }
34 
35   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
36     if(balances[_from] >= _value
37         && _value > 0
38         && balances[_to] + _value > balances[_to]
39         && allowed[_from][msg.sender] >= _value) {
40 
41         balances[_from] -= _value;
42         balances[_to] += _value;
43         Transfer(_from, _to, _value);
44 
45         return true;
46     }
47     return false;
48 }
49 
50   function balanceOf(address _owner) constant returns (uint256 balance) {
51     return balances[_owner];
52   }
53 
54   function approve(address _spender, uint256 _value) returns (bool success) {
55     allowed[msg.sender][_spender] = _value;
56     Approval(msg.sender, _spender, _value);
57     return true;
58   }
59 
60   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
61     return allowed[_owner][_spender];
62   }
63 
64   function() {
65     revert();
66   }
67 }