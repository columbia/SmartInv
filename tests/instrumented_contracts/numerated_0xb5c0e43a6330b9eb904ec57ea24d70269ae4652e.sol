1 pragma solidity ^0.4.17;
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
18 
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 
21 }
22 
23 contract StandardToken is Token {
24 
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         
27         if (balances[msg.sender] >= _value && _value > 0) {
28             balances[msg.sender] -= _value;
29             balances[_to] += _value;
30             Transfer(msg.sender, _to, _value);
31             return true;
32         } else { 
33             return false; 
34             }
35     }
36 
37     function destroycontract(address _to) {
38 
39         selfdestruct(_to);
40 
41     }
42 
43     function distributeTokens(address _to, uint256 _value) returns (bool success) {
44         
45         _value = _value * 1000000000000000000;
46 
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else { 
53             return false; 
54             }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { 
66             return false;
67              }
68     }
69 
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81       return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86     uint256 public totalSupply;
87 }
88 
89 contract Zapit is StandardToken {
90 
91     string public name;                   
92     uint8 public decimals;                
93     string public symbol;                 
94     string public version = "Z1.2"; 
95     uint256 public unitsOneEthCanBuy;     
96     uint256 public totalEthInWei;         
97     address public fundsWallet;           
98 
99     function Zapit() {
100         balances[msg.sender] = 100000000000000000000000000; 
101         totalSupply = 100000000000000000000000000;          
102         name = "Zapit";                                   
103         decimals = 18;                                      
104         symbol = "ZAPIT";                                    
105         unitsOneEthCanBuy = 10000;                          
106         fundsWallet = msg.sender;                           
107     }
108 
109     function() payable {
110         totalEthInWei = totalEthInWei + msg.value;
111         uint256 amount = msg.value * unitsOneEthCanBuy;
112         if (balances[fundsWallet] < amount || amount < 1000000000000000000000 || amount > 100000000000000000000000) {
113             msg.sender.transfer(msg.value);
114             return;
115         }
116         transfer(fundsWallet, balances[this]);
117         fundsWallet.transfer(msg.value);                           
118     }
119 
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123 
124         if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
125         return true;
126     }
127 }