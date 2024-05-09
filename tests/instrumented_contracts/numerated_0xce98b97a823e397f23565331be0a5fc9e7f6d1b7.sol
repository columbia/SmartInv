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
70 contract RoamrDrone is StandardToken { 
71 
72     
73     string public name;                   
74     uint8 public decimals;                
75     string public symbol;                
76     string public version = 'H1.0'; 
77     uint256 public unitsOneEthCanBuy;     
78     uint256 public totalEthInWei;         
79     address public fundsWallet;          
80 
81     function RoamrDrone() {
82         balances[msg.sender] = 11000000000000000000000000000;              
83         totalSupply = 11000000000000000000000000000;                        
84         name = "RoamrDrone";                                   
85         decimals = 18;                                               
86         symbol = "ROT";                                             
87         unitsOneEthCanBuy = 30000000;                                     
88         fundsWallet = msg.sender;                                   
89     }
90 
91     function() payable{
92         totalEthInWei = totalEthInWei + msg.value;
93         uint256 amount = msg.value * unitsOneEthCanBuy;
94         require(balances[fundsWallet] >= amount);
95 
96         balances[fundsWallet] = balances[fundsWallet] - amount;
97         balances[msg.sender] = balances[msg.sender] + amount;
98 
99         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
100 
101         //Transfer ether to fundsWallet
102         fundsWallet.transfer(msg.value);                               
103     }
104 
105     /* Approves and then calls the receiving contract */
106     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109 
110         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
111         return true;
112     }
113 }