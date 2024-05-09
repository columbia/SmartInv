1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5 
6     function totalSupply() constant returns (uint256 supply) {}
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8     function transfer(address _to, uint256 _value) returns (bool success) {}
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
10     function approve(address _spender, uint256 _value) returns (bool success) {}
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16 }
17 
18 contract StandardToken is Token {
19 
20     function transfer(address _to, uint256 _value) returns (bool success) {
21 
22         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
23         if (balances[msg.sender] >= _value && _value > 0) {
24             balances[msg.sender] -= _value;
25             balances[_to] += _value;
26             Transfer(msg.sender, _to, _value);
27             return true;
28         } else { return false; }
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
32 
33         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
34         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
35             balances[_to] += _value;
36             balances[_from] -= _value;
37             allowed[_from][msg.sender] -= _value;
38             Transfer(_from, _to, _value);
39             return true;
40         } else { return false; }
41     }
42 
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) returns (bool success) {
48         allowed[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
54       return allowed[_owner][_spender];
55     }
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     uint256 public totalSupply;
60 }
61 
62 contract DoYourOwnResearch is StandardToken { 
63 
64     /* Public variables of the token */
65 
66 
67     string public name;                
68     uint8 public decimals;               
69     string public symbol;                
70     string public version = 'H1.2333'; 
71     uint256 public unitsOneEthCanBuy;     
72     uint256 public totalEthInWei;        
73     address public fundsWallet;           
74  
75     function DoYourOwnResearch() {
76         balances[msg.sender] = 200000000000000000000000000;               
77         totalSupply = 200000000000000000000000000;                      
78         name = "DoYourOwnResearch";   
79         symbol = "DYOR";                                             
80         decimals = 18;                                          
81         unitsOneEthCanBuy = 10000;                                     
82         fundsWallet = msg.sender;                                   
83     }
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
95         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
96 
97         fundsWallet.transfer(msg.value);                               
98     }
99 
100 
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104 
105 
106         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
107         return true;
108     }
109 }