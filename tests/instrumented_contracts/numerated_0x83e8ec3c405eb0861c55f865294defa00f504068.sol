1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     
12     function transfer(address _to, uint256 _value) returns (bool success) {}
13 
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
15 
16     
17     function approve(address _spender, uint256 _value) returns (bool success) {}
18 
19    
20     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
21 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 
25 }
26 
27 contract StandardToken is Token {
28 
29     function transfer(address _to, uint256 _value) returns (bool success) {
30         
31         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
32         if (balances[msg.sender] >= _value && _value > 0) {
33             balances[msg.sender] -= _value;
34             balances[_to] += _value;
35             Transfer(msg.sender, _to, _value);
36             return true;
37         } else { return false; }
38     }
39 
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
41         
42         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
43             balances[_to] += _value;
44             balances[_from] -= _value;
45             allowed[_from][msg.sender] -= _value;
46             Transfer(_from, _to, _value);
47             return true;
48         } else { return false; }
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
70 contract BitcoinCashPrivate is StandardToken { 
71 
72     
73 
74     string public name;                   
75     uint8 public decimals;               
76     string public symbol;                 
77     string public version = 'H1.0'; 
78     uint256 public unitsOneEthCanBuy;     
79     uint256 public totalEthInWei;          
80     address public fundsWallet;          
81 
82      
83    
84     function BitcoinCashPrivate() {
85         balances[msg.sender] = 8000000000000000000000000;                
86         totalSupply = 8000000000000000000000000;                        
87         name = "Bitcoin Cash Private";                                   
88         decimals = 18;                                               
89         symbol = "BCHP";                                             
90         unitsOneEthCanBuy = 650;                                      
91         fundsWallet = msg.sender;                                    
92     }
93 
94     function() payable{
95         totalEthInWei = totalEthInWei + msg.value;
96         uint256 amount = msg.value * unitsOneEthCanBuy;
97         if (balances[fundsWallet] < amount) {
98             return;
99         }
100 
101         balances[fundsWallet] = balances[fundsWallet] - amount;
102         balances[msg.sender] = balances[msg.sender] + amount;
103 
104         Transfer(fundsWallet, msg.sender, amount); 
105 
106         
107         fundsWallet.transfer(msg.value);                               
108     }
109 
110     
111     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114 
115         
116         
117         
118         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
119         return true;
120     }
121 }