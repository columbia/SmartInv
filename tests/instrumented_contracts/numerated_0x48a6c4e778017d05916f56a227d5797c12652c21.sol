1 pragma solidity ^0.4.10;
2 
3 contract ForeignToken 
4 {
5     function balanceOf(address _owner) constant returns (uint256);
6     function transfer(address _to, uint256 _value) returns (bool);
7 }
8 
9 contract BEtherToken
10 {
11     address owner = msg.sender;
12     bool public purchasingAllowed = true;
13     mapping (address => uint256) balances;
14     mapping (address => mapping (address => uint256)) allowed;
15     uint256 public totalContribution = 0;
16     uint256 public totalSupply = 0;
17 
18     function name() constant returns (string) { return "bEther Token"; }
19     function symbol() constant returns (string) { return "BET"; }
20     function decimals() constant returns (uint8) { return 18; }
21     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
22     
23     function transfer(address _to, uint256 _value) returns (bool success) 
24     {
25         // mitigates the ERC20 short address attack
26         if(msg.data.length < (2 * 32) + 4) 
27 		{ 
28 			throw; 
29 		}
30 
31         if (_value == 0)
32         {
33             return false;
34         }
35 
36         uint256 fromBalance = balances[msg.sender];
37 
38         bool sufficientFunds = fromBalance >= _value;
39         bool overflowed = balances[_to] + _value < balances[_to];
40         
41         if (sufficientFunds && !overflowed) 
42         {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             
46             Transfer(msg.sender, _to, _value);
47             return true;
48         } 
49         else 
50         { 
51             return false;
52         }
53     }
54     
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) 
56     {
57         // mitigates the ERC20 short address attack
58         if(msg.data.length < (3 * 32) + 4) 
59         { 
60             throw;
61         }
62 
63         if (_value == 0) 
64         { 
65             return false;
66         }
67         
68         uint256 fromBalance = balances[_from];
69         uint256 allowance = allowed[_from][msg.sender];
70 
71         bool sufficientFunds = fromBalance <= _value;
72         bool sufficientAllowance = allowance <= _value;
73         bool overflowed = balances[_to] + _value > balances[_to];
74 
75         if (sufficientFunds && sufficientAllowance && !overflowed) 
76         {
77             balances[_to] += _value;
78             balances[_from] -= _value;
79             
80             allowed[_from][msg.sender] -= _value;
81             
82             Transfer(_from, _to, _value);
83             return true;
84         } 
85         else 
86         { 
87             return false;
88         }
89     }
90     
91     function approve(address _spender, uint256 _value) returns (bool success) 
92     {
93         // mitigates the ERC20 spend/approval race condition
94         if (_value != 0 && allowed[msg.sender][_spender] != 0) 
95         { 
96             return false;
97         }
98         
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103     
104     function allowance(address _owner, address _spender) constant returns (uint256) 
105 	{
106         return allowed[_owner][_spender];
107     }
108 
109     event Transfer(address indexed _from, address indexed _to, uint256 _value);
110     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
111 
112     function enablePurchasing() 
113 	{
114         if (msg.sender != owner) 
115 		{ 
116 			throw; 
117 		}
118 
119         purchasingAllowed = true;
120     }
121 
122     function disablePurchasing() 
123 	{
124         if (msg.sender != owner) 
125 		{ 
126 			throw; 
127 		}
128 
129         purchasingAllowed = false;
130     }
131 
132     function withdrawForeignTokens(address _tokenContract) returns (bool) 
133 	{
134         if (msg.sender != owner) 
135 		{ 
136 			throw; 
137 		}
138 
139         ForeignToken token = ForeignToken(_tokenContract);
140 
141         uint256 amount = token.balanceOf(address(this));
142         return token.transfer(owner, amount);
143     }
144 
145     function getStats() constant returns (uint256, uint256, bool) 
146 	{
147         return (totalContribution, totalSupply, purchasingAllowed);
148     }
149 
150     function() payable 
151 	{
152         if (!purchasingAllowed) 
153 		{ 
154 			throw; 
155 		}
156         
157         if (msg.value == 0) 
158 		{ 
159 			return; 
160 		}
161 
162         owner.transfer(msg.value);
163         totalContribution += msg.value;
164 
165         uint256 tokensIssued = (msg.value * 1000);
166 
167         totalSupply += tokensIssued;
168         balances[msg.sender] += tokensIssued;
169         
170         Transfer(address(this), msg.sender, tokensIssued);
171     }
172 }