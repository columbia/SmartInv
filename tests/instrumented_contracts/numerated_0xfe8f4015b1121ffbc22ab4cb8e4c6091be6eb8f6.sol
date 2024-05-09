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
24 contract StandardToken is Token {
25 
26     function transfer(address _to, uint256 _value) returns (bool success) {
27 
28         if (balances[msg.sender] >= _value && _value > 0) {
29             balances[msg.sender] -= _value;
30             balances[_to] += _value;
31             Transfer(msg.sender, _to, _value);
32             return true;
33         } else { return false; }
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
37 
38         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
39             balances[_to] += _value;
40             balances[_from] -= _value;
41             allowed[_from][msg.sender] -= _value;
42             Transfer(_from, _to, _value);
43             return true;
44         } else { return false; }
45     }
46 
47     function balanceOf(address _owner) constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50 
51     function approve(address _spender, uint256 _value) returns (bool success) {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
58       return allowed[_owner][_spender];
59     }
60 
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     uint256 public totalSupply;
64 }
65 
66 contract QUARDCOIN is StandardToken {
67 
68     string public name;                   
69     uint8 public decimals;                
70     string public symbol;                 
71     string public version = 'A1.0'; 
72     uint256 public unitsOneEthCanBuy;     
73     uint256 public totalEthInWei;           
74     address public fundsWallet;           
75 
76     function QUARDCOIN() {
77         balances[msg.sender] = 10000000000000000000000000000;               
78         totalSupply = 10000000000000000000000000000;                        
79         name = "QUARDCOIN";                                   
80         decimals = 18;                                               
81         symbol = "QDC";                                             
82         unitsOneEthCanBuy = 44666;                                      
83         fundsWallet = msg.sender;                                
84     }
85 
86     function() payable{
87         totalEthInWei = totalEthInWei + msg.value;
88         uint256 amount = msg.value * unitsOneEthCanBuy;
89         if (balances[fundsWallet] < amount) {
90             return;
91         }
92         
93         balances[fundsWallet] = balances[fundsWallet] - amount;
94         balances[msg.sender] = balances[msg.sender] + amount;
95         
96         Transfer(fundsWallet, msg.sender, amount); 
97         fundsWallet.transfer(msg.value);                               
98     }
99 
100     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
104         return true;
105     }
106 }