1 pragma solidity ^0.4.19;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6     function balanceOf(address _owner) constant returns (uint256 balance) {}
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
9     function approve(address _spender, uint256 _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 
14 }
15 
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
20         if (balances[msg.sender] >= _value && _value > 0) {
21             balances[msg.sender] -= _value;
22             balances[_to] += _value;
23             Transfer(msg.sender, _to, _value);
24             return true;
25         } else { return false; }
26     }
27 
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
29         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
30         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31             balances[_to] += _value;
32             balances[_from] -= _value;
33             allowed[_from][msg.sender] -= _value;
34             Transfer(_from, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function balanceOf(address _owner) constant returns (uint256 balance) {
40         return balances[_owner];
41     }
42 
43     function approve(address _spender, uint256 _value) returns (bool success) {
44         allowed[msg.sender][_spender] = _value;
45         Approval(msg.sender, _spender, _value);
46         return true;
47     }
48 
49     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
50       return allowed[_owner][_spender];
51     }
52 
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55     uint256 public totalSupply;
56 }
57 
58 contract PhoneX is StandardToken { 
59 
60     /* Public variables of the token */
61 
62     
63     string public name;                   
64     uint8 public decimals;                
65     string public symbol;                 
66     string public version = 'H1.0'; 
67     uint256 public unitsOneEthCanBuy;     
68     uint256 public totalEthInWei;           
69     address public fundsWallet;           
70 
71     // This is a constructor func
72     
73     function PhoneX() 
74     {
75         balances[msg.sender] = 100000000000000000000000000000;               
76         totalSupply = 100000000000000000000000000000;                        
77         name = "PhoneX";                                   
78         decimals = 18;                                               
79         symbol = "PHX";                                             
80         unitsOneEthCanBuy = 150000;                                      
81         fundsWallet = msg.sender;                                    
82     }
83     
84     function() payable 
85         {
86         totalEthInWei = totalEthInWei + msg.value;
87         uint256 amount = msg.value * unitsOneEthCanBuy;
88         if (balances[fundsWallet] < amount) {
89             return;
90         }
91 
92         balances[fundsWallet] = balances[fundsWallet] - amount;
93         balances[msg.sender] = balances[msg.sender] + amount;
94 
95         Transfer(fundsWallet, msg.sender, amount); 
96 
97         
98         fundsWallet.transfer(msg.value);                               
99     }
100     
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) 
102     {
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
106         return true;
107         
108     }
109 }