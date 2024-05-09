1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'Byzbit' token contract
7 
8 // Deployed to : 0x940b2D687C5FFE1f154c66837F99581F27423bD3
9 
10 // Symbol      : BYT
11 
12 // Name        : Byzbit
13 // Total supply:  10,000,000,000
14 
15 // Decimals    : 18
16 
17 // ----------------------------------------------------------------------------
18 
19 // ----------------------------------------------------------------------------
20 
21 // Safe maths
22 
23 // ----------------------------------------------------------------------------
24 
25 contract SafeMath {
26 
27     function safeAdd(uint a, uint b) public pure returns (uint c) {
28 
29         c = a + b;
30 
31         require(c >= a);
32 
33     }
34 
35     function safeSub(uint a, uint b) public pure returns (uint c) {
36 
37         require(b <= a);
38 
39         c = a - b;
40 
41     }
42 
43     function safeMul(uint a, uint b) public pure returns (uint c) {
44 
45         c = a * b;
46 
47         require(a == 0 || c / a == b);
48 
49     }
50 
51     function safeDiv(uint a, uint b) public pure returns (uint c) {
52 
53         require(b > 0);
54 
55         c = a / b;
56 
57     }
58 
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 
64 // ERC Token Standard #20 Interface
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
83 
84     event Transfer(address indexed from, address indexed to, uint tokens);
85 
86     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
87 
88 }
89 
90 // ----------------------------------------------------------------------------
91 
92 // Contract function to receive approval and execute function in one call
93 
94 // Borrowed from MiniMeToken
95 
96 // ----------------------------------------------------------------------------
97 
98 contract ApproveAndCallFallBack {
99 
100     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
101 
102 }
103 // ----------------------------------------------------------------------------
104 
105 // Owned contract
106 
107 // ----------------------------------------------------------------------------
108 
109 contract Owned {
110 
111     address public owner;
112 
113     address public newOwner;
114 
115 
116 
117     event OwnershipTransferred(address indexed _from, address indexed _to);
118 
119 
120 
121     function Owned() public {
122 
123         owner = msg.sender;
124 
125     }
126 
127 
128 
129     modifier onlyOwner {
130 
131         require(msg.sender == owner);
132 
133         _;
134 
135     }
136 
137 
138 
139     function transferOwnership(address _newOwner) public onlyOwner {
140 
141         newOwner = _newOwner;
142 
143     }
144 
145     function acceptOwnership() public {
146 
147         require(msg.sender == newOwner);
148 
149         OwnershipTransferred(owner, newOwner);
150 
151         owner = newOwner;
152 
153         newOwner = address(0);
154 
155     }
156 
157 }
158 
159 // ----------------------------------------------------------------------------
160 
161 // ERC20 Token, with the addition of symbol, name and decimals and assisted
162 
163 // token transfers
164 
165 // ----------------------------------------------------------------------------
166 
167 contract Byzbit is ERC20Interface, Owned, SafeMath {
168 
169     string public symbol;
170 
171     string public  name;
172 
173     uint8 public decimals;
174 
175     uint public _totalSupply;
176 
177 
178 
179     mapping(address => uint) balances;
180 
181     mapping(address => mapping(address => uint)) allowed;
182 
183     // ------------------------------------------------------------------------
184 
185     // Constructor
186 
187     // ------------------------------------------------------------------------
188 
189     function Byzbit() public {
190 
191         symbol = "BYT";
192 
193         name = "Byzbit";
194 
195         decimals = 18;
196 
197         _totalSupply = 10000000000000000000000000000;
198 
199         balances[0x940b2D687C5FFE1f154c66837F99581F27423bD3] = _totalSupply;
200 
201         Transfer(address(0), 0x940b2D687C5FFE1f154c66837F99581F27423bD3, _totalSupply);
202 
203     }
204 
205    // ------------------------------------------------------------------------
206 
207     // Total supply
208 
209     // ------------------------------------------------------------------------
210 
211     function totalSupply() public constant returns (uint) {
212 
213         return _totalSupply  - balances[address(0)];
214 
215     }
216 
217   // ------------------------------------------------------------------------
218 
219     // Get the token balance for account tokenOwner
220 
221     // ------------------------------------------------------------------------
222 
223     function balanceOf(address tokenOwner) public constant returns (uint balance) {
224 
225         return balances[tokenOwner];
226 
227     }
228 
229     // ------------------------------------------------------------------------
230 
231     // Transfer the balance from token owner's account to to account
232 
233     // - Owner's account must have sufficient balance to transfer
234 
235     // - 0 value transfers are allowed
236 
237     // ------------------------------------------------------------------------
238 
239     function transfer(address to, uint tokens) public returns (bool success) {
240 
241         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
242 
243         balances[to] = safeAdd(balances[to], tokens);
244 
245         Transfer(msg.sender, to, tokens);
246 
247         return true;
248 
249     }
250 
251     // ------------------------------------------------------------------------
252 
253     // Token owner can approve for spender to transferFrom(...) tokens
254 
255     // from the token owner's account
256 
257     // recommends that there are no checks for the approval double-spend attack
258 
259     // as this should be implemented in user interfaces 
260 
261     // ------------------------------------------------------------------------
262 
263     function approve(address spender, uint tokens) public returns (bool success) {
264 
265         allowed[msg.sender][spender] = tokens;
266 
267         Approval(msg.sender, spender, tokens);
268 
269         return true;
270 
271     }
272 
273     // ------------------------------------------------------------------------
274 
275     // Transfer tokens from the from account to the to account
276 
277     // The calling account must already have sufficient tokens approve(...)-d
278 
279     // for spending from the from account and
280 
281     // - From account must have sufficient balance to transfer
282 
283     // - Spender must have sufficient allowance to transfer
284 
285     // - 0 value transfers are allowed
286 
287     // ------------------------------------------------------------------------
288 
289     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
290 
291         balances[from] = safeSub(balances[from], tokens);
292 
293         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
294 
295         balances[to] = safeAdd(balances[to], tokens);
296 
297         Transfer(from, to, tokens);
298 
299         return true;
300 
301     }
302 
303    // ------------------------------------------------------------------------
304 
305     // Returns the amount of tokens approved by the owner that can be
306 
307     // transferred to the spender's account
308 
309     // ------------------------------------------------------------------------
310 
311     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
312 
313         return allowed[tokenOwner][spender];
314 
315     }
316 
317     // ------------------------------------------------------------------------
318 
319     // Token owner can approve for spender to transferFrom(...) tokens
320 
321     // from the token owner's account. The spender contract function
322 
323     // receiveApproval(...) is then executed
324 
325     // ------------------------------------------------------------------------
326 
327     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
328 
329         allowed[msg.sender][spender] = tokens;
330 
331         Approval(msg.sender, spender, tokens);
332 
333         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
334 
335         return true;
336 
337     }
338 
339     // ------------------------------------------------------------------------
340 
341     // Don't accept ETH
342 
343     // ------------------------------------------------------------------------
344 
345     function () public payable {
346 
347         revert();
348 
349     }
350 
351     // ------------------------------------------------------------------------
352 
353     // Owner can transfer out any accidentally sent ERC20 tokens
354 
355     // ------------------------------------------------------------------------
356 
357     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
358 
359         return ERC20Interface(tokenAddress).transfer(owner, tokens);
360 
361     }
362 
363 }