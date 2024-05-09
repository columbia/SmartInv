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
22 contract StandardToken is Token {
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25 
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35 
36         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
37             balances[_to] += _value;
38             balances[_from] -= _value;
39             allowed[_from][msg.sender] -= _value;
40             Transfer(_from, _to, _value);
41             return true;
42         } else { return false; }
43     }
44 
45     function balanceOf(address _owner) constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49     function approve(address _spender, uint256 _value) returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
56       return allowed[_owner][_spender];
57     }
58 
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61     uint256 public totalSupply;
62 }
63 
64 contract BitcoinToken is StandardToken { 
65 
66     string public name;                   
67     uint8 public decimals;                
68     string public symbol;                 
69     string public version = 'BitcoinToken 1.0'; 
70     uint256 public unitsOneEthCanBuy;     
71     uint256 public totalEthInWei;         
72     address public fundsWallet;           
73 
74 
75     function BitcoinToken() {	
76         balances[msg.sender] = 2100000000000000000000000000;
77         totalSupply = 2100000000000000000000000000;       
78         name = "₿ Token";                                   
79         decimals = 18;                                             
80         symbol = "₿.to";                                          
81         unitsOneEthCanBuy = 100;                                     
82         fundsWallet = msg.sender;                                    
83     }
84 
85     function() payable{
86         totalEthInWei = totalEthInWei + msg.value;
87         uint256 amount = msg.value * unitsOneEthCanBuy;
88         require(balances[fundsWallet] >= amount);
89 
90         balances[fundsWallet] = balances[fundsWallet] - amount;
91         balances[msg.sender] = balances[msg.sender] + amount;
92 
93         Transfer(fundsWallet, msg.sender, amount);
94 
95         fundsWallet.transfer(msg.value);                               
96     }
97 
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101 
102         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
103         return true;
104     }
105 }