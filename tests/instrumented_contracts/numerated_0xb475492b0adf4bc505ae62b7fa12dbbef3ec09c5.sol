1 pragma solidity ^0.4.4;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 
23 contract Token {
24 
25     function totalSupply() constant returns (uint256 supply) {}
26     function balanceOf(address _owner) constant returns (uint256 balance) {}
27     function transfer(address _to, uint256 _value) returns (bool success) {}
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
31 
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35 }
36 
37 contract StandardToken is Token {
38 
39     function transfer(address _to, uint256 _value) returns (bool success) {
40         
41         if (balances[msg.sender] >= _value && _value > 0) {
42             balances[msg.sender] -= _value;
43             balances[_to] += _value;
44             Transfer(msg.sender, _to, _value);
45             return true;
46         } else { return false; }
47     }
48 
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
50         
51         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52             balances[_to] += _value;
53             balances[_from] -= _value;
54             allowed[_from][msg.sender] -= _value;
55             Transfer(_from, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function balanceOf(address _owner) constant returns (uint256 balance) {
61         return balances[_owner];
62     }
63 
64     function approve(address _spender, uint256 _value) returns (bool success) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71       return allowed[_owner][_spender];
72     }
73 
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;
76     uint256 public totalSupply;
77 }
78 
79 contract Arbitragebit is StandardToken, SafeMath { 
80 
81    
82     string public name;                   
83     uint8 public decimals;                
84     string public symbol;                 
85     string public version = '1.0'; 
86     uint public startDate;
87     uint public bonus1Ends;
88     uint public bonus2Ends;
89     uint public bonus3Ends;
90     uint public endDate;
91     uint256 public unitsOneEthCanBuy;     
92     uint256 public totalEthInWei;         
93     address public fundsWallet;           
94 
95     
96     function Arbitragebit() {
97         balances[msg.sender] = 25000000000000000000000000;  
98         totalSupply = 25000000000000000000000000;   
99         name = "Arbitragebit";               
100         decimals = 18;                          
101         symbol = "ABG";                        
102         unitsOneEthCanBuy = 250;                  
103         fundsWallet = msg.sender;                
104         bonus1Ends = now + 45 minutes + 13 hours + 3 days + 4 weeks;
105         bonus2Ends = now + 45 minutes + 13 hours + 5 days + 8 weeks;
106         bonus3Ends = now + 45 minutes + 13 hours + 1 days + 13 weeks;
107         endDate = now + 45 minutes + 13 hours + 4 days + 17 weeks;
108 
109     }
110 
111     function() payable{
112         totalEthInWei = totalEthInWei + msg.value;
113         require(balances[fundsWallet] >= amount);
114         require(now >= startDate && now <= endDate);
115         uint256 amount;
116         
117 
118         
119        
120        if (now <= bonus1Ends) {
121             amount = msg.value * unitsOneEthCanBuy * 8;
122         } 
123         
124          else if (now <= bonus2Ends && now > bonus1Ends) {
125             amount = msg.value * unitsOneEthCanBuy * 6;
126         }
127         
128         else if (now <= bonus3Ends && now > bonus2Ends) {
129             amount = msg.value * unitsOneEthCanBuy * 5;
130         }
131         
132         else {
133             amount = msg.value * unitsOneEthCanBuy * 4;
134         }
135 
136 
137         balances[fundsWallet] = balances[fundsWallet] - amount;
138         balances[msg.sender] = balances[msg.sender] + amount;
139 
140         Transfer(fundsWallet, msg.sender, amount); 
141 
142         fundsWallet.transfer(msg.value);                               
143     }
144 
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148 
149         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
150         return true;
151     }
152 }