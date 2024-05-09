1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // AXNET Token contract
7 //
8 // Symbol      : AXN
9 // Name        : AXNET Token
10 // Total supply: 3,000,000,000.000000000000000000
11 // Decimals    : 18
12 // ----------------------------------------------------------------------------
13 
14 
15 
16 // ----------------------------------------------------------------------------
17 
18 // Safe maths
19 
20 // ----------------------------------------------------------------------------
21 
22 library SafeMath {
23 
24     function add(uint a, uint b) internal pure returns (uint c) {
25 
26         c = a + b;
27 
28         require(c >= a);
29 
30     }
31 
32     function sub(uint a, uint b) internal pure returns (uint c) {
33 
34         require(b <= a);
35 
36         c = a - b;
37 
38     }
39 
40     function mul(uint a, uint b) internal pure returns (uint c) {
41 
42         c = a * b;
43 
44         require(a == 0 || c / a == b);
45 
46     }
47 
48     function div(uint a, uint b) internal pure returns (uint c) {
49 
50         require(b > 0);
51 
52         c = a / b;
53 
54     }
55 
56 }
57 
58 
59 
60 // ----------------------------------------------------------------------------
61 
62 // ERC Token Standard #20 Interface
63 
64 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
65 
66 // ----------------------------------------------------------------------------
67 
68 contract ERC20Interface {
69 
70     function totalSupply() public constant returns (uint);
71 
72     function balanceOf(address tokenOwner) public constant returns (uint balance);
73 
74     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
75 
76     function transfer(address to, uint tokens) public returns (bool success);
77 
78     function approve(address spender, uint tokens) public returns (bool success);
79 
80     function transferFrom(address from, address to, uint tokens) public returns (bool success);
81 
82 
83     event Transfer(address indexed from, address indexed to, uint tokens);
84 
85     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
86 
87 }
88 
89 
90 
91 // ----------------------------------------------------------------------------
92 
93 // Owned contract
94 
95 // ----------------------------------------------------------------------------
96 
97 contract Owned {
98 
99     address public owner;
100 
101     function Owned() public {
102 
103         owner = msg.sender;
104 
105     }
106 
107 
108     modifier onlyOwner {
109 
110         require(msg.sender == owner);
111 
112         _;
113 
114     }
115 
116 }
117 
118 
119 
120 // ----------------------------------------------------------------------------
121 
122 // ERC20 Token, with the addition of symbol, name and decimals and an
123 
124 // initial fixed supply
125 
126 // ----------------------------------------------------------------------------
127 
128 contract AXNETToken is ERC20Interface, Owned {
129 
130     using SafeMath for uint;
131 
132 
133     string public symbol;
134 
135     string public  name;
136 
137     uint8 public decimals;
138 
139     uint public _totalSupply;
140 
141 
142     mapping(address => uint) balances;
143 
144     mapping(address => mapping(address => uint)) allowed;
145 
146 
147 
148     // ------------------------------------------------------------------------
149 
150     // Constructor
151 
152     // ------------------------------------------------------------------------
153 
154     function AXNETToken() public {
155 
156         symbol = "AXN";
157 
158         name = "AXNET Token";
159 
160         decimals = 18;
161 
162         _totalSupply = 3000000000 * 10**uint(decimals);
163 
164         balances[owner] = _totalSupply;
165 
166         Transfer(address(0), owner, _totalSupply);
167 
168     }
169 
170 
171 
172     // ------------------------------------------------------------------------
173 
174     // Total supply
175 
176     // ------------------------------------------------------------------------
177 
178     function totalSupply() public constant returns (uint) {
179 
180         return _totalSupply  - balances[address(0)];
181 
182     }
183 
184 
185 
186     // ------------------------------------------------------------------------
187 
188     // Get the token balance for account `tokenOwner`
189 
190     // ------------------------------------------------------------------------
191 
192     function balanceOf(address tokenOwner) public constant returns (uint balance) {
193 
194         return balances[tokenOwner];
195 
196     }
197 
198 
199 
200     // ------------------------------------------------------------------------
201 
202     // Transfer the balance from token owner's account to `to` account
203 
204     // - Owner's account must have sufficient balance to transfer
205 
206     // - 0 value transfers are allowed
207 
208     // ------------------------------------------------------------------------
209 
210     function transfer(address to, uint tokens) public returns (bool success) {
211 
212         balances[msg.sender] = balances[msg.sender].sub(tokens);
213 
214         balances[to] = balances[to].add(tokens);
215 
216         Transfer(msg.sender, to, tokens);
217 
218         return true;
219 
220     }
221 
222 
223 
224     // ------------------------------------------------------------------------
225 
226     // Token owner can approve for `spender` to transferFrom(...) `tokens`
227 
228     // from the token owner's account
229 
230     //
231 
232     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
233 
234     // recommends that there are no checks for the approval double-spend attack
235 
236     // as this should be implemented in user interfaces 
237 
238     // ------------------------------------------------------------------------
239 
240     function approve(address spender, uint tokens) public returns (bool success) {
241 
242         allowed[msg.sender][spender] = tokens;
243 
244         Approval(msg.sender, spender, tokens);
245 
246         return true;
247 
248     }
249 
250 
251 
252     // ------------------------------------------------------------------------
253 
254     // Transfer `tokens` from the `from` account to the `to` account
255 
256     // 
257 
258     // The calling account must already have sufficient tokens approve(...)-d
259 
260     // for spending from the `from` account and
261 
262     // - From account must have sufficient balance to transfer
263 
264     // - Spender must have sufficient allowance to transfer
265 
266     // - 0 value transfers are allowed
267 
268     // ------------------------------------------------------------------------
269 
270     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
271 
272         balances[from] = balances[from].sub(tokens);
273 
274         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
275 
276         balances[to] = balances[to].add(tokens);
277 
278         Transfer(from, to, tokens);
279 
280         return true;
281 
282     }
283 
284 
285 
286     // ------------------------------------------------------------------------
287 
288     // Returns the amount of tokens approved by the owner that can be
289 
290     // transferred to the spender's account
291 
292     // ------------------------------------------------------------------------
293 
294     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
295 
296         return allowed[tokenOwner][spender];
297 
298     }
299 
300 
301     // ------------------------------------------------------------------------
302 
303     // Do accept ETH
304 
305     // ------------------------------------------------------------------------
306 
307     function () public payable {
308 
309 
310     }
311 
312 
313     // ------------------------------------------------------------------------
314     // Owner can withdraw ether if token received.
315     // ------------------------------------------------------------------------
316     function withdraw() public onlyOwner returns (bool result) {
317         
318         return owner.send(this.balance);
319         
320     }
321     
322     // ------------------------------------------------------------------------
323 
324     // Owner can transfer out any accidentally sent ERC20 tokens
325 
326     // ------------------------------------------------------------------------
327 
328     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
329 
330         return ERC20Interface(tokenAddress).transfer(owner, tokens);
331 
332     }
333 
334 }