1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7 
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10 
11     function transfer(address _to, uint256 _value) returns (bool success) {}
12 
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
14 
15     function approve(address _spender, uint256 _value) returns (bool success) {}
16 
17     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21     
22 }
23 
24 
25 
26 contract ridgeContract is Token {
27 
28     function transfer(address _to, uint256 _value) returns (bool success) {
29 
30         if (balances[msg.sender] >= _value && _value > 0) {
31             balances[msg.sender] -= _value;
32             balances[_to] += _value;
33             Transfer(msg.sender, _to, _value);
34             return true;
35         } else { return false; }
36     }
37 
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
39         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
40             balances[_to] += _value;
41             balances[_from] -= _value;
42             allowed[_from][msg.sender] -= _value;
43             Transfer(_from, _to, _value);
44             return true;
45         } else { return false; }
46     }
47 
48     function balanceOf(address _owner) constant returns (uint256 balance) {
49         return balances[_owner];
50     }
51 
52     function approve(address _spender, uint256 _value) returns (bool success) {
53         allowed[msg.sender][_spender] = _value;
54         Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
59       return allowed[_owner][_spender];
60     }
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     uint256 public totalSupply;
65 }
66 
67 
68 contract RidgeToken is ridgeContract {
69 
70     function () {
71         throw;
72     }
73 
74   
75     string public name;                   
76      uint8 public decimals;                
77     string public symbol;            
78     string public version = 'H1.0.3';  
79 
80 
81     function RidgeToken(
82         ) {
83         balances[msg.sender] = 15000000000000000000000000;               
84         totalSupply = 15000000000000000000000000;                        
85         name = "Ridge";                                  
86         decimals = 18;                            
87         symbol = "XRG";                               
88     }
89 
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93 
94         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
95         return true;
96     }
97 }