1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         require(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) internal returns (uint) {
11         require(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) internal returns (uint) {
16         uint c = a + b;
17         require(c>=a && c>=b);
18         return c;
19     }
20 
21     function safeDiv(uint a, uint b) internal returns (uint) {
22         require(b > 0);
23         uint c = a / b;
24         require(a == b * c + a % b);
25         return c;
26     }
27 }
28 
29 contract Token {
30     function balanceOf(address _owner) constant returns (uint256 balance);
31     function transfer(address _to, uint256 _value) returns (bool success);
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
33     function approve(address _spender, uint256 _value) returns (bool success);
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 /* ERC 20 token */
41 contract ERC20Token is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
45             balances[msg.sender] -= _value;
46             balances[_to] += _value;
47             Transfer(msg.sender, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function balanceOf(address _owner) constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint256 _value) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
73         return allowed[_owner][_spender];
74     }
75 
76     mapping(address => uint256) balances;
77 
78     mapping (address => mapping (address => uint256)) allowed;
79 
80     uint256 public totalSupply;
81 }
82 
83 
84 /**
85  * CAR ICO contract.
86  *
87  */
88 contract CARToken is ERC20Token, SafeMath {
89 
90     string public name = "CAR SHARING";
91     string public symbol = "CAR";
92 	uint public decimals = 9;
93 
94     address public tokenIssuer = 0x0;
95 	
96     // Unlock time
97 	uint public month12Unlock = 1546387199;
98 	uint public month24Unlock = 1577923199;
99 	uint public month30Unlock = 1593647999;
100     uint public month48Unlock = 1641081599;
101 	uint public month60Unlock = 1672617599;
102 	
103 	// End token sale
104 	uint public endTokenSale = 1577836799;
105 	
106 	// Allocated
107     bool public month12Allocated = false;
108 	bool public month24Allocated = false;
109 	bool public month30Allocated = false;
110     bool public month48Allocated = false;
111 	bool public month60Allocated = false;
112 	
113 
114     // Token count
115 	uint totalTokenSaled = 0;
116     uint public totalTokensCrowdSale = 95000000 * 10**decimals;
117     uint public totalTokensReserve = 95000000 * 10**decimals;
118 
119 	event TokenMint(address newTokenHolder, uint amountOfTokens);
120     event AllocateTokens(address indexed sender);
121 
122     function CARToken() {
123         tokenIssuer = msg.sender;
124     }
125 	
126 	/* Change issuer address */
127     function changeIssuer(address newIssuer) {
128         require(msg.sender==tokenIssuer);
129         tokenIssuer = newIssuer;
130     }
131 
132     /* Allocate Tokens */
133     function allocateTokens()
134     {
135         require(msg.sender==tokenIssuer);
136         uint tokens = 0;
137      
138 		if(block.timestamp > month12Unlock && !month12Allocated)
139         {
140 			month12Allocated = true;
141 			tokens = safeDiv(totalTokensReserve, 5);
142 			balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
143 			totalSupply = safeAdd(totalSupply, tokens);
144             
145         }
146         else if(block.timestamp > month24Unlock && !month24Allocated)
147         {
148 			month24Allocated = true;
149 			tokens = safeDiv(totalTokensReserve, 5);
150 			balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
151 			totalSupply = safeAdd(totalSupply, tokens);
152 			
153         }
154 		if(block.timestamp > month30Unlock && !month30Allocated)
155         {
156 			month30Allocated = true;
157 			tokens = safeDiv(totalTokensReserve, 5);
158 			balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
159 			totalSupply = safeAdd(totalSupply, tokens);
160             
161         }
162         else if(block.timestamp > month48Unlock && !month48Allocated)
163         {
164 			month48Allocated = true;
165 			tokens = safeDiv(totalTokensReserve, 5);
166 			balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
167 			totalSupply = safeAdd(totalSupply, tokens);
168         }
169 		else if(block.timestamp > month60Unlock && !month60Allocated)
170         {
171             month60Allocated = true;
172             tokens = safeDiv(totalTokensReserve, 5);
173             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
174             totalSupply = safeAdd(totalSupply, tokens);
175         }
176         else revert();
177 
178         AllocateTokens(msg.sender);
179     }
180     
181 	/* Mint Token */
182     function mintTokens(address tokenHolder, uint256 amountToken) 
183     returns (bool success) 
184     {
185 		require(msg.sender==tokenIssuer);
186 		
187 		if(totalTokenSaled + amountToken <= totalTokensCrowdSale && block.timestamp <= endTokenSale)
188 		{
189 			balances[tokenHolder] = safeAdd(balances[tokenHolder], amountToken);
190 			totalTokenSaled = safeAdd(totalTokenSaled, amountToken);
191 			totalSupply = safeAdd(totalSupply, amountToken);
192 			TokenMint(tokenHolder, amountToken);
193 			return true;
194 		}
195 		else
196 		{
197 		    return false;
198 		}
199     }
200 }