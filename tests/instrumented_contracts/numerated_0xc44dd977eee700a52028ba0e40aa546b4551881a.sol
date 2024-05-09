1 pragma solidity ^0.4.4;
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
19 		
20         if (balances[msg.sender] >= _value && _value > 0) {
21 			
22             balances[msg.sender] -= _value;
23             balances[_to] += _value;
24             Transfer(msg.sender, _to, _value);
25 			
26             return true;
27 			
28         } else {
29 			
30 			return false;
31 			
32 		}
33 		
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
37 		
38         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
39 			
40             balances[_to] += _value;
41             balances[_from] -= _value;
42             allowed[_from][msg.sender] -= _value;
43             Transfer(_from, _to, _value);
44 			
45             return true;
46 			
47         } else {
48 			
49 			return false;
50 			
51 		}
52 		
53     }
54 
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56 		
57         return balances[_owner];
58 		
59     }
60 
61     function approve(address _spender, uint256 _value) returns (bool success) {
62 		
63         allowed[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65 		
66         return true;
67 		
68     }
69 
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71 		
72       return allowed[_owner][_spender];
73 	  
74     }
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78     uint256 public totalSupply;
79 
80 }
81 
82 contract TheSevenSins is StandardToken {
83 
84     string public name;
85     uint8 public decimals;
86     string public symbol;
87     string public version = 'H1.0';
88     uint256 public unitsOneEthCanBuy;
89     uint256 public totalEthInWei;
90     address public fundsWallet;
91 
92     function TheSevenSins() {
93 		
94         balances[msg.sender] = 54000000000000000000000000;
95         totalSupply = 54000000000000000000000000;
96         name = "The Seven Sins";
97         decimals = 18;
98         symbol = "TSS";
99         unitsOneEthCanBuy = 1025;
100         fundsWallet = msg.sender;
101 		
102     }
103 
104     function() payable{
105 		
106         totalEthInWei = totalEthInWei + msg.value;
107         uint256 amount = msg.value * unitsOneEthCanBuy;
108 		
109         if (balances[fundsWallet] < amount) {
110             return;
111         }
112 
113         balances[fundsWallet] = balances[fundsWallet] - amount;
114         balances[msg.sender] = balances[msg.sender] + amount;
115 
116         Transfer(fundsWallet, msg.sender, amount);
117 
118         fundsWallet.transfer(msg.value);
119 		
120     }
121 
122     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
123 		
124         allowed[msg.sender][_spender] = _value;
125         Approval(msg.sender, _spender, _value);
126 
127         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
128 			
129 			throw;
130 			
131 		}
132 		
133         return true;
134 		
135     }
136 	
137 }