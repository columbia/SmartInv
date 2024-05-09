1 // $LizaGo
2 
3 pragma solidity ^0.4.4;
4 
5 
6 contract Token {
7 
8     function totalSupply() constant returns (uint256 supply) {}
9 
10 
11     function balanceOf(address _owner) constant returns (uint256 balance) {}
12 
13     function transfer(address _to, uint256 _value) returns (bool success) {}
14 
15  
16     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
17 
18     function approve(address _spender, uint256 _value) returns (bool success) {}
19 
20    
21     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
22 
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 
26 }
27 
28 contract StandardToken is Token {
29 
30     function transfer(address _to, uint256 _value) returns (bool success) {
31 
32         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
33             balances[msg.sender] -= _value;
34             balances[_to] += _value;
35             Transfer(msg.sender, _to, _value);
36             return true;
37         } else {return false;}
38     }
39 
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
41 
42         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
43             balances[_to] += _value;
44             balances[_from] -= _value;
45             allowed[_from][msg.sender] -= _value;
46             Transfer(_from, _to, _value);
47             return true;
48         } else {return false;}
49     }
50 
51     function balanceOf(address _owner) constant returns (uint256 balance) {
52         return balances[_owner];
53     }
54 
55     function approve(address _spender, uint256 _value) returns (bool success) {
56         allowed[msg.sender][_spender] = _value;
57         Approval(msg.sender, _spender, _value);
58         return true;
59     }
60 
61     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
62       return allowed[_owner][_spender];
63     }
64 
65     mapping (address => uint256) balances;
66     mapping (address => mapping (address => uint256)) allowed;
67     uint256 public totalSupply;
68 }
69 
70 contract LizaGo is StandardToken { 
71 
72 
73     string public name;                
74     uint8 public decimals;           
75     string public symbol;                
76     string public version = "1.0"; 
77     uint256 public unitsOneEthCanBuy;    
78     uint256 public totalEthInWei;         
79     address public fundsWallet;           
80 
81  
82     function LizaGo() {
83         balances[msg.sender] = 1000000000000000000000000000;               
84         totalSupply = 1000000000000000000000000000;                        
85         name = "LizaGo";                                              
86         decimals = 18;                                               
87         symbol = "LGO";                                            
88                                             
89         fundsWallet = msg.sender;                                   
90                           
91     }
92     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95 
96         if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {throw;}
97         return true;
98     }
99 }