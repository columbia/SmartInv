1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     
10     function transfer(address _to, uint256 _value) returns (bool success) {}
11 
12     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
13 
14     function approve(address _spender, uint256 _value) returns (bool success) {}
15 
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
26 contract StandardToken is Token {
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
39         
40         
41         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
42             balances[_to] += _value;
43             balances[_from] -= _value;
44             allowed[_from][msg.sender] -= _value;
45             Transfer(_from, _to, _value);
46             return true;
47         } else { return false; }
48     }
49 
50     function balanceOf(address _owner) constant returns (uint256 balance) {
51         return balances[_owner];
52     }
53 
54     function approve(address _spender, uint256 _value) returns (bool success) {
55         allowed[msg.sender][_spender] = _value;
56         Approval(msg.sender, _spender, _value);
57         return true;
58     }
59 
60     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
61       return allowed[_owner][_spender];
62     }
63 
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66     uint256 public totalSupply;
67 }
68 
69 contract EthereumTravelToken is StandardToken {
70 
71     function () {
72         
73         throw;
74     }
75 
76     
77     string public name;                   
78     uint8 public decimals;                
79     string public symbol;                 
80     string public version = 'H1.0';       
81 
82 
83     function EthereumTravelToken(
84         ) {
85         balances[msg.sender] = 1000000000000000000000000000;               
86         totalSupply = 1000000000000000000000000000;                        
87         name = "Ethereum Travel Token";                                   
88         decimals = 18;                      
89         symbol = "ETHT";                    
90     }
91 
92     
93     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96         
97         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
98         return true;
99     }
100 }