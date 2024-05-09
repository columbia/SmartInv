1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'FIXED' 'Example Fixed Supply Token' token contract
7 
8 //
9 
10 // Symbol      : FIXED
11 
12 // Name        : Example Fixed Supply Token
13 
14 // Total supply: 1,000,000.000000000000000000
15 
16 // Decimals    : 18
17 
18 //
19 
20 // Enjoy.
21 
22 //
23 
24 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
25 
26 // ----------------------------------------------------------------------------
27 
28 
29 
30 // ----------------------------------------------------------------------------
31 
32 // Safe maths
33 
34 // ----------------------------------------------------------------------------
35 
36 library SafeMath {
37 
38     function add(uint a, uint b) internal pure returns (uint c) {
39 
40         c = a + b;
41 
42         require(c >= a);
43 
44     }
45 
46     function sub(uint a, uint b) internal pure returns (uint c) {
47 
48         require(b <= a);
49 
50         c = a - b;
51 
52     }
53 
54     function mul(uint a, uint b) internal pure returns (uint c) {
55 
56         c = a * b;
57 
58         require(a == 0 || c / a == b);
59 
60     }
61 
62     function div(uint a, uint b) internal pure returns (uint c) {
63 
64         require(b > 0);
65 
66         c = a / b;
67 
68     }
69 
70 }
71 
72 
73 
74 // ----------------------------------------------------------------------------
75 
76 // ERC Token Standard #20 Interface
77 
78 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
79 
80 // ----------------------------------------------------------------------------
81 
82 contract ERC20Interface {
83 
84     function totalSupply() public constant returns (uint);
85 
86     function balanceOf(address tokenOwner) public constant returns (uint balance);
87 
88     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
89 
90     function transfer(address to, uint tokens) public returns (bool success);
91 
92     function approve(address spender, uint tokens) public returns (bool success);
93 
94     function transferFrom(address from, address to, uint tokens) public returns (bool success);
95 
96 
97     event Transfer(address indexed from, address indexed to, uint tokens);
98 
99     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
100 
101 }
102 
103 
104 
105 // ----------------------------------------------------------------------------
106 
107 // Contract function to receive approval and execute function in one call
108 
109 //
110 
111 // Borrowed from MiniMeToken
112 
113 // ----------------------------------------------------------------------------
114 
115 contract ApproveAndCallFallBack {
116 
117     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
118 
119 }
120 
121 
122 
123 // ----------------------------------------------------------------------------
124 
125 // Owned contract
126 
127 // ----------------------------------------------------------------------------
128 
129 contract Owned {
130 
131     address public owner;
132 
133     address public newOwner;
134 
135 
136     event OwnershipTransferred(address indexed _from, address indexed _to);
137 
138 
139     function Owned() public {
140 
141         owner = msg.sender;
142 
143     }
144 
145 
146     modifier onlyOwner {
147 
148         require(msg.sender == owner);
149 
150         _;
151 
152     }
153 
154 
155     function transferOwnership(address _newOwner) public onlyOwner {
156 
157         newOwner = _newOwner;
158 
159     }
160 
161     function acceptOwnership() public {
162 
163         require(msg.sender == newOwner);
164 
165         OwnershipTransferred(owner, newOwner);
166 
167         owner = newOwner;
168 
169         newOwner = address(0);
170 
171     }
172 
173 }
174 
175 
176 
177 // ----------------------------------------------------------------------------
178 
179 // ERC20 Token, with the addition of symbol, name and decimals and an
180 
181 // initial fixed supply
182 
183 // ----------------------------------------------------------------------------
184 
185 contract FixedSupplyToken is ERC20Interface, Owned {
186 
187     using SafeMath for uint;
188 
189 
190     string public symbol;
191 
192     string public  name;
193 
194     uint8 public decimals;
195 
196     uint public _totalSupply;
197 
198 
199     mapping(address => uint) balances;
200 
201     mapping(address => mapping(address => uint)) allowed;
202 
203 
204 
205     // ------------------------------------------------------------------------
206 
207     // Constructor
208 
209     // ------------------------------------------------------------------------
210 
211     function FixedSupplyToken() public {
212 
213         symbol = "ATOMS";
214 
215         name = "BCE Universal Atoms";
216 
217         decimals = 18;
218 
219         _totalSupply = 42000000000000000000000000000000000000000000 * 10**uint(decimals);
220 
221         balances[owner] = _totalSupply;
222 
223         Transfer(address(0), owner, _totalSupply);
224 
225     }
226 
227 
228 
229     // ------------------------------------------------------------------------
230 
231     // Total supply
232 
233     // ------------------------------------------------------------------------
234 
235     function totalSupply() public constant returns (uint) {
236 
237         return _totalSupply  - balances[address(0)];
238 
239     }
240 
241 
242 
243     // ------------------------------------------------------------------------
244 
245     // Get the token balance for account `tokenOwner`
246 
247     // ------------------------------------------------------------------------
248 
249     function balanceOf(address tokenOwner) public constant returns (uint balance) {
250 
251         return balances[tokenOwner];
252 
253     }
254 
255 
256 
257     // ------------------------------------------------------------------------
258 
259     // Transfer the balance from token owner's account to `to` account
260 
261     // - Owner's account must have sufficient balance to transfer
262 
263     // - 0 value transfers are allowed
264 
265     // ------------------------------------------------------------------------
266 
267     function transfer(address to, uint tokens) public returns (bool success) {
268 
269         balances[msg.sender] = balances[msg.sender].sub(tokens);
270 
271         balances[to] = balances[to].add(tokens);
272 
273         Transfer(msg.sender, to, tokens);
274 
275         return true;
276 
277     }
278 
279 
280 
281     // ------------------------------------------------------------------------
282 
283     // Token owner can approve for `spender` to transferFrom(...) `tokens`
284 
285     // from the token owner's account
286 
287     //
288 
289     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
290 
291     // recommends that there are no checks for the approval double-spend attack
292 
293     // as this should be implemented in user interfaces 
294 
295     // ------------------------------------------------------------------------
296 
297     function approve(address spender, uint tokens) public returns (bool success) {
298 
299         allowed[msg.sender][spender] = tokens;
300 
301         Approval(msg.sender, spender, tokens);
302 
303         return true;
304 
305     }
306 
307 
308 
309     // ------------------------------------------------------------------------
310 
311     // Transfer `tokens` from the `from` account to the `to` account
312 
313     // 
314 
315     // The calling account must already have sufficient tokens approve(...)-d
316 
317     // for spending from the `from` account and
318 
319     // - From account must have sufficient balance to transfer
320 
321     // - Spender must have sufficient allowance to transfer
322 
323     // - 0 value transfers are allowed
324 
325     // ------------------------------------------------------------------------
326 
327     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
328 
329         balances[from] = balances[from].sub(tokens);
330 
331         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
332 
333         balances[to] = balances[to].add(tokens);
334 
335         Transfer(from, to, tokens);
336 
337         return true;
338 
339     }
340 
341 
342 
343     // ------------------------------------------------------------------------
344 
345     // Returns the amount of tokens approved by the owner that can be
346 
347     // transferred to the spender's account
348 
349     // ------------------------------------------------------------------------
350 
351     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
352 
353         return allowed[tokenOwner][spender];
354 
355     }
356 
357 
358 
359     // ------------------------------------------------------------------------
360 
361     // Token owner can approve for `spender` to transferFrom(...) `tokens`
362 
363     // from the token owner's account. The `spender` contract function
364 
365     // `receiveApproval(...)` is then executed
366 
367     // ------------------------------------------------------------------------
368 
369     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
370 
371         allowed[msg.sender][spender] = tokens;
372 
373         Approval(msg.sender, spender, tokens);
374 
375         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
376 
377         return true;
378 
379     }
380 
381 
382 
383     // ------------------------------------------------------------------------
384 
385     // Don't accept ETH
386 
387     // ------------------------------------------------------------------------
388 
389     function () public payable {
390 
391         revert();
392 
393     }
394 
395 
396 
397     // ------------------------------------------------------------------------
398 
399     // Owner can transfer out any accidentally sent ERC20 tokens
400 
401     // ------------------------------------------------------------------------
402 
403     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
404 
405         return ERC20Interface(tokenAddress).transfer(owner, tokens);
406 
407     }
408 
409 }