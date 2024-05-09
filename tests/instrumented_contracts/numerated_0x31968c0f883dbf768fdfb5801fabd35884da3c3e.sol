1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 function totalSupply() constant returns (uint256 supply) {}
5 function balanceOf(address _owner) constant returns (uint256 balance) {}
6 function transfer(address _to, uint256 _value) returns (bool success) {}
7 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
8 function approve(address _spender, uint256 _value) returns (bool success) {}
9 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 contract StandardToken is Token {
14     function transfer(address _to, uint256 _value) returns (bool success) {
15  if (balances[msg.sender] >= _value && _value > 0) {
16             balances[msg.sender] -= _value;
17             balances[_to] += _value;
18             Transfer(msg.sender, _to, _value);
19             return true;
20         } else { return false; }
21     }
22 
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
24 if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
25             balances[_to] += _value;
26             balances[_from] -= _value;
27             allowed[_from][msg.sender] -= _value;
28             Transfer(_from, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 
33     function balanceOf(address _owner) constant returns (uint256 balance) {
34         return balances[_owner];
35     }
36 
37     function approve(address _spender, uint256 _value) returns (bool success) {
38         allowed[msg.sender][_spender] = _value;
39         Approval(msg.sender, _spender, _value);
40         return true;
41     }
42 
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
44       return allowed[_owner][_spender];
45     }
46 
47     mapping (address => uint256) balances;
48     mapping (address => mapping (address => uint256)) allowed;
49     uint256 public totalSupply;
50 }
51 contract KatyaToken is StandardToken {
52 
53     function () {
54 throw;
55     }
56 string public name; 
57     uint8 public decimals;
58     string public symbol;
59     string public version = 'H1.0';
60 function KatyaToken(
61         ) {
62         balances[msg.sender] = 1000000000;
63         totalSupply = 1000000000;
64         name = "Katya Tokareva Token";
65         decimals = 2;
66         symbol = "TKT";
67     }
68 function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71 if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
72         return true;
73     }
74 }