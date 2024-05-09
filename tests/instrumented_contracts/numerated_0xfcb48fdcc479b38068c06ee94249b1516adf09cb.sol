1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19     
20 }
21 
22 
23 
24 contract StandardToken is Token {
25 
26     function transfer(address _to, uint256 _value) returns (bool success) {
27         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
28         if (balances[msg.sender] >= _value && _value > 0) {
29             balances[msg.sender] -= _value;
30             balances[_to] += _value;
31             Transfer(msg.sender, _to, _value);
32             return true;
33         } else { return false; }
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
37         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
38         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
39             balances[_to] += _value;
40             balances[_from] -= _value;
41             allowed[_from][msg.sender] -= _value;
42             Transfer(_from, _to, _value);
43             return true;
44         } else { return false; }
45     }
46 
47     function balanceOf(address _owner) constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50 
51     function approve(address _spender, uint256 _value) returns (bool success) {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
58       return allowed[_owner][_spender];
59     }
60 
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     uint256 public totalSupply;
64 }
65 
66 contract ERC20Token is StandardToken {
67 
68     function () {
69         throw;
70     }
71 
72     string public name;
73     uint8 public decimals;
74     string public symbol;
75     string public version = 'H1.0';
76 
77     function ERC20Token(
78         ) {
79         balances[msg.sender] = 100000000000000;
80         totalSupply = 100000000000000;
81         name = "EUROBITS";
82         decimals = 5;                          
83         symbol = "EURB";                               
84     }
85 
86     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
87         allowed[msg.sender][_spender] = _value;
88         Approval(msg.sender, _spender, _value);
89 
90         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
91         return true;
92     }
93 }