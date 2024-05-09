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
23 contract StandardToken is Token {
24 
25     function transfer(address _to, uint256 _value) returns (bool success) {
26 
27         if (balances[msg.sender] >= _value && _value > 0) {
28             balances[msg.sender] -= _value;
29             balances[_to] += _value;
30             Transfer(msg.sender, _to, _value);
31             return true;
32         } else { return false; }
33     }
34 
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
36 
37         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
38             balances[_to] += _value;
39             balances[_from] -= _value;
40             allowed[_from][msg.sender] -= _value;
41             Transfer(_from, _to, _value);
42             return true;
43         } else { return false; }
44     }
45 
46     function balanceOf(address _owner) constant returns (uint256 balance) {
47         return balances[_owner];
48     }
49 
50     function approve(address _spender, uint256 _value) returns (bool success) {
51         allowed[msg.sender][_spender] = _value;
52         Approval(msg.sender, _spender, _value);
53         return true;
54     }
55 
56     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
57       return allowed[_owner][_spender];
58     }
59 
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     uint256 public totalSupply;
63 }
64 
65 
66 contract THO is StandardToken {
67 
68     function () {
69 
70         throw;
71     }
72 
73     string public name;
74     uint8 public decimals;
75     string public symbol;
76     string public version = '1.4';
77 
78 
79     function THO(
80         ) {
81         balances[msg.sender] = 100000000000000000000000000;
82         totalSupply = 100000000000000000000000000;
83         name = "Tihosay";
84         decimals = 18;
85         symbol = "THO";
86     }
87 
88     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91 
92         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
93         return true;
94     }
95 }