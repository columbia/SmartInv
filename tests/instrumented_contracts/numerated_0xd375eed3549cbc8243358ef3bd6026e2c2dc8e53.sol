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
85  * CSCJ ICO contract.
86  *
87  */
88 contract CSCJToken is ERC20Token, SafeMath {
89 
90     string public name = "CSCJ E-GAMBLE";
91     string public symbol = "CSCJ";
92     uint public decimals = 9;
93 
94     address public tokenIssuer = 0x0;
95     
96     // Unlock time for MAR
97     uint public month6Unlock = 1554854400;
98     uint public month12Unlock = 1570665600;
99     uint public month24Unlock = 1602288000;
100     uint public month36Unlock = 1633824000;
101     uint public month48Unlock = 1665360000;
102 
103     // Unlock time for DAPP
104     uint public month9Unlock = 1562716800;
105     uint public month18Unlock = 1586476800;
106     uint public month27Unlock = 1610236800;
107     uint public month45Unlock = 1657411200;
108     
109     // Allocated MAR
110     bool public month6Allocated = false;
111     bool public month12Allocated = false;
112     bool public month24Allocated = false;
113     bool public month36Allocated = false;
114     bool public month48Allocated = false;
115 
116     // Allocated DAPP
117     bool public month9Allocated = false;
118     bool public month18Allocated = false;
119     bool public month27Allocated = false;
120     bool public month36AllocatedDAPP = false;
121     bool public month45Allocated = false;
122     
123 
124     // Token count
125     uint totalTokenSaled = 0;
126     uint public totalTokensCrowdSale = 95000000 * 10**decimals;
127     uint public totalTokensMAR = 28500000 * 10**decimals;
128     uint public totalTokensDAPP = 28500000 * 10**decimals;
129     uint public totalTokensReward = 38000000 * 10**decimals;
130 
131 
132     event TokenMint(address newTokenHolder, uint amountOfTokens);
133     event AllocateMARTokens(address indexed sender);
134     event AllocateDAPPTokens(address indexed sender);
135 
136     function CSCJToken() {
137         tokenIssuer = msg.sender;
138     }
139     
140     /* Change issuer address */
141     function changeIssuer(address newIssuer) public {
142         require(msg.sender==tokenIssuer);
143         tokenIssuer = newIssuer;
144     }
145 
146     /* Allocate Tokens for MAR */
147     function allocateMARTokens() public {
148         require(msg.sender==tokenIssuer);
149         uint tokens = 0;
150      
151         if(block.timestamp > month6Unlock && !month6Allocated)
152         {
153             month6Allocated = true;
154             tokens = safeDiv(totalTokensMAR, 5);
155             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
156             totalSupply = safeAdd(totalSupply, tokens);
157             
158         }
159         else if(block.timestamp > month12Unlock && !month12Allocated)
160         {
161             month12Allocated = true;
162             tokens = safeDiv(totalTokensMAR, 5);
163             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
164             totalSupply = safeAdd(totalSupply, tokens);
165             
166         }
167         else if(block.timestamp > month24Unlock && !month24Allocated)
168         {
169             month24Allocated = true;
170             tokens = safeDiv(totalTokensMAR, 5);
171             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
172             totalSupply = safeAdd(totalSupply, tokens);
173             
174         }
175         else if(block.timestamp > month36Unlock && !month36Allocated)
176         {
177             month36Allocated = true;
178             tokens = safeDiv(totalTokensMAR, 5);
179             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
180             totalSupply = safeAdd(totalSupply, tokens);
181         }
182         else if(block.timestamp > month48Unlock && !month48Allocated)
183         {
184             month48Allocated = true;
185             tokens = safeDiv(totalTokensMAR, 5);
186             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
187             totalSupply = safeAdd(totalSupply, tokens);
188         }
189         else revert();
190 
191         AllocateMARTokens(msg.sender);
192     }
193 
194     /* Allocate Tokens for DAPP */
195     function allocateDAPPTokens() public {
196         require(msg.sender==tokenIssuer);
197         uint tokens = 0;
198      
199         if(block.timestamp > month9Unlock && !month9Allocated)
200         {
201             month9Allocated = true;
202             tokens = safeDiv(totalTokensDAPP, 5);
203             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
204             totalSupply = safeAdd(totalSupply, tokens);
205         }
206         else if(block.timestamp > month18Unlock && !month18Allocated)
207         {
208             month18Allocated = true;
209             tokens = safeDiv(totalTokensDAPP, 5);
210             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
211             totalSupply = safeAdd(totalSupply, tokens);
212             
213         }
214         else if(block.timestamp > month27Unlock && !month27Allocated)
215         {
216             month27Allocated = true;
217             tokens = safeDiv(totalTokensDAPP, 5);
218             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
219             totalSupply = safeAdd(totalSupply, tokens);
220             
221         }
222         else if(block.timestamp > month36Unlock && !month36AllocatedDAPP)
223         {
224             month36AllocatedDAPP = true;
225             tokens = safeDiv(totalTokensDAPP, 5);
226             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
227             totalSupply = safeAdd(totalSupply, tokens);
228         }
229         else if(block.timestamp > month45Unlock && !month45Allocated)
230         {
231             month45Allocated = true;
232             tokens = safeDiv(totalTokensDAPP, 5);
233             balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
234             totalSupply = safeAdd(totalSupply, tokens);
235         }
236         else revert();
237 
238         AllocateDAPPTokens(msg.sender);
239     }
240     
241     /* Mint Token */
242     function mintTokens(address tokenHolder, uint256 amountToken) public
243     returns (bool success)
244     {
245         require(msg.sender==tokenIssuer);
246         
247         if(totalTokenSaled + amountToken <= totalTokensCrowdSale + totalTokensReward)
248         {
249             balances[tokenHolder] = safeAdd(balances[tokenHolder], amountToken);
250             totalTokenSaled = safeAdd(totalTokenSaled, amountToken);
251             totalSupply = safeAdd(totalSupply, amountToken);
252             TokenMint(tokenHolder, amountToken);
253             return true;
254         }
255         else
256         {
257             return false;
258         }
259     }
260 }