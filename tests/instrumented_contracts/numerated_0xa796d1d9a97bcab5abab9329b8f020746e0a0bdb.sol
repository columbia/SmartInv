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
14    
15     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
16 
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
32         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
33         if (balances[msg.sender] >= _value && _value > 0) {
34             balances[msg.sender] -= _value;
35             balances[_to] += _value;
36             Transfer(msg.sender, _to, _value);
37             return true;
38         } else { return false; }
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
42         
43         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
44             balances[_to] += _value;
45             balances[_from] -= _value;
46             allowed[_from][msg.sender] -= _value;
47             Transfer(_from, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function balanceOf(address _owner) constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     function approve(address _spender, uint256 _value) returns (bool success) {
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
63       return allowed[_owner][_spender];
64     }
65 
66     mapping (address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;
68     uint256 public totalSupply;
69 }
70 
71 contract JPMorganChase is StandardToken { 
72 
73     
74 
75     string public name;                   
76     uint8 public decimals;               
77     string public symbol;                 
78     string public version = 'H1.0'; 
79     uint256 public unitsOneEthCanBuy;     
80     uint256 public totalEthInWei;          
81     address public fundsWallet;          
82 
83      
84    
85     function JPMorganChase() {
86         balances[msg.sender] = 6000000;                
87         totalSupply = 6000000;                        
88         name = "JPMorgan Chase";                                   
89         decimals = 0;                                               
90         symbol = "JPMC";                                             
91         unitsOneEthCanBuy = 99000;                                      
92         fundsWallet = msg.sender;                                    
93     }
94 
95     function() payable{
96         totalEthInWei = totalEthInWei + msg.value;
97         uint256 amount = msg.value * unitsOneEthCanBuy;
98         if (balances[fundsWallet] < amount) {
99             return;
100         }
101 
102         balances[fundsWallet] = balances[fundsWallet] - amount;
103         balances[msg.sender] = balances[msg.sender] + amount;
104 
105         Transfer(fundsWallet, msg.sender, amount); 
106 
107         
108         fundsWallet.transfer(msg.value);                               
109     }
110 
111     
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115 
116         
117         
118         
119         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
120         return true;
121     }
122 }