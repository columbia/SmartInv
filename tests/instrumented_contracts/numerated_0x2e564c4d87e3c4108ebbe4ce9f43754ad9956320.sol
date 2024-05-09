1 pragma solidity ^0.4.19;
2 
3 contract Token {
4 
5   
6     function totalSupply() constant returns (uint256 supply) {}
7 
8 
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     function transfer(address _to, uint256 _value) returns (bool success) {}
12 
13 
14     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
15 
16     function approve(address _spender, uint256 _value) returns (bool success) {}
17 
18 
19     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
20 
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 
24 }
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
40         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
41             balances[_to] += _value;
42             balances[_from] -= _value;
43             allowed[_from][msg.sender] -= _value;
44             Transfer(_from, _to, _value);
45             return true;
46         } else { return false; }
47     }
48 
49     function balanceOf(address _owner) constant returns (uint256 balance) {
50         return balances[_owner];
51     }
52 
53     function approve(address _spender, uint256 _value) returns (bool success) {
54         allowed[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
60       return allowed[_owner][_spender];
61     }
62 
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65     uint256 public totalSupply;
66 }
67 
68 contract PowerfulToken is StandardToken { 
69 
70     string public name;                   
71     uint8 public decimals;                
72     string public symbol;                
73     string public version = 'H1.0'; 
74     uint256 public unitsOneEthCanBuy;     
75     uint256 public totalEthInWei;          
76     address public fundsWallet;          
77 
78    
79     function PowerfulToken() {
80         balances[msg.sender] = 110000000000000000000000000;              
81         totalSupply = 110000000000000000000000000;                      
82         name = "PowerfulToken";                                   
83         decimals = 18;                                              
84         symbol = "POW";                                             
85         unitsOneEthCanBuy = 2300;                                      
86         fundsWallet = msg.sender;           
87     }
88 
89     function() payable{
90         totalEthInWei = totalEthInWei + msg.value;
91         uint256 amount = msg.value * unitsOneEthCanBuy;
92         if((balances[fundsWallet]-amount)<30000000000000000000000000)
93         throw;
94         else {
95         balances[fundsWallet] = balances[fundsWallet] - amount;
96         balances[msg.sender] = balances[msg.sender] + amount;
97 
98         Transfer(fundsWallet, msg.sender, amount); 
99 
100 
101         fundsWallet.transfer(msg.value); 
102         }
103     }
104 
105 
106     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109 
110        
111         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
112         return true;
113     }
114 }