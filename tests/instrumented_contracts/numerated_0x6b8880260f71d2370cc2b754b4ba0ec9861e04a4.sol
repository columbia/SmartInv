1 pragma solidity ^0.4.4;
2 
3 contract Token
4 {
5     function totalSupply() constant returns (uint256 supply) { }
6     function balanceOf(address _owner) constant returns (uint256 balance) { }
7     function transfer(address _to, uint256 _value) returns (bool success) { }
8     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) { }
9     function approve(address _spender, uint256 _value) returns (bool success) { }
10     function allowance(address _owner, address _spender) constant returns (uint256 remaining) { }
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 
14 }
15 
16 contract StandardToken is Token 
17     {
18     function transfer(address _to, uint256 _value) returns(bool success)
19     {
20     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to])
21     {
22         balances[msg.sender] -= _value;
23         balances[_to] += _value;
24         Transfer(msg.sender, _to, _value);
25         return true;
26     }
27     else { return false; }
28 }
29 
30 function transferFrom(address _from, address _to, uint256 _value) returns(bool success)
31 {
32     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to])
33         {
34         balances[_to] += _value;
35         balances[_from] -= _value;
36         allowed[_from][msg.sender] -= _value;
37         Transfer(_from, _to, _value);
38         return true;
39     }
40     else { return false; }
41 }
42 
43 function balanceOf(address _owner) constant returns(uint256 balance)
44 {
45     return balances[_owner];
46 }
47 
48 function approve(address _spender, uint256 _value) returns(bool success)
49 {
50     allowed[msg.sender][_spender] = _value;
51     Approval(msg.sender, _spender, _value);
52     return true;
53 }
54 
55 function allowance(address _owner, address _spender) constant returns(uint256 remaining)
56 {
57     return allowed[_owner][_spender];
58 }
59 
60     mapping(address => uint256) balances;
61     mapping(address => mapping (address => uint256)) allowed;
62     uint256 public totalSupply;
63 }
64 
65 contract RaliusToken is StandardToken { 
66     string public name;                   
67     uint8 public decimals;              
68     string public symbol;                
69     string public version = 'H1.0'; 
70     uint256 public unitsOneEthCanBuy;    
71     uint256 public totalEthInWei;         
72     address public fundsWallet;           
73 
74     function RaliusToken()
75 {
76     balances[msg.sender] = 11000000000000000000000000;               
77     totalSupply = 11000000000000000000000000;                       
78     name = "Ralius Token";                                   
79     decimals = 18;                                             
80     symbol = "RAL";                                            
81     unitsOneEthCanBuy = 2000;                                      
82     fundsWallet = msg.sender;                                 
83 }
84 
85     function() payable{
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
97 fundsWallet.transfer(msg.value);                               
98     }
99 
100     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns(bool success)
101 {
102     allowed[msg.sender][_spender] = _value;
103     Approval(msg.sender, _spender, _value);
104 
105     if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
106     return true;
107 }
108 }