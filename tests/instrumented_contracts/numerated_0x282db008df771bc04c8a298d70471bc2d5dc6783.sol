1 pragma solidity ^0.4.24;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 
7 // KIMERA - token token deployment template
8 
9 // written by D.R., KIMERA 
10 
11 // First blocked on: 1-Jan-2018 - a happy new year!!!
12 
13 // ----------------------------------------------------------------------------
14 
15 
16 
17 
18 
19 // ----------------------------------------------------------------------------
20 
21 // Safe maths
22 
23 // ----------------------------------------------------------------------------
24 
25 library SafeMath {
26 
27     function add(uint a, uint b) internal pure returns (uint c) {
28 
29         c = a + b;
30 
31         require(c >= a);
32 
33     }
34 
35     function sub(uint a, uint b) internal pure returns (uint c) {
36 
37         require(b <= a);
38 
39         c = a - b;
40 
41     }
42 
43     function mul(uint a, uint b) internal pure returns (uint c) {
44 
45         c = a * b;
46 
47         require(a == 0 || c / a == b);
48 
49     }
50 
51     function div(uint a, uint b) internal pure returns (uint c) {
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
62 
63 
64 
65 // ----------------------------------------------------------------------------
66 
67 // ERC Token Standard #20 Interface
68 
69 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
70 
71 // ----------------------------------------------------------------------------
72 
73 contract ERC20Interface {
74 
75     function totalSupply() public constant returns (uint);
76 
77     function balanceOf(address tokenOwner) public constant returns (uint balance);
78 
79     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
80 
81     function transfer(address to, uint tokens) public returns (bool success);
82 
83     function approve(address spender, uint tokens) public returns (bool success);
84 
85     function transferFrom(address from, address to, uint tokens) public returns (bool success);
86 
87 
88 
89     // calling events for any transfer or a 3rd party approval
90 
91     event Transfer(address indexed from, address indexed to, uint tokens);
92 
93     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
94 
95 }
96 
97 
98 
99 
100 
101 // ----------------------------------------------------------------------------
102 
103 // Contract function to receive approval and execute function in one call
104 
105 //
106 
107 // Borrowed from MiniMeToken
108 
109 // ----------------------------------------------------------------------------
110 
111 contract ApproveAndCallFallBack {
112 
113     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
114 
115 }
116 
117 
118 
119 
120 
121 // ----------------------------------------------------------------------------
122 
123 // Owned contract - defines the owner
124 
125 // ----------------------------------------------------------------------------
126 
127 contract Owned {
128 
129     address public owner;
130 
131     address public newOwner;
132 
133 
134 
135     event OwnershipTransferred(address indexed _from, address indexed _to);
136 
137 
138 
139     constructor() public {
140 
141         owner = msg.sender;
142 
143     }
144 
145 
146 
147     modifier onlyOwner {
148 
149         require(msg.sender == owner);
150 
151         _;
152 
153     }
154 
155 
156 
157     function transferOwnership(address _newOwner) public onlyOwner {
158 
159         newOwner = _newOwner;
160 
161     }
162 
163     function acceptOwnership() public {
164 
165         require(msg.sender == newOwner);
166 
167         emit OwnershipTransferred(owner, newOwner);
168 
169         owner = newOwner;
170 
171         newOwner = address(0);
172 
173     }
174 
175 }
176 
177 
178 
179 
180 
181 // ----------------------------------------------------------------------------
182 
183 // ERC20 Token, with the addition of symbol, name and decimals and an
184 
185 // initial fixed supply
186 
187 // ----------------------------------------------------------------------------
188 
189 contract WAAMToken is ERC20Interface, Owned {
190 
191     using SafeMath for uint;
192 
193 
194 
195     string public constant symbol = "WAAM";
196 
197     string public constant name = "WAAM for the retail";
198 
199     uint8 public constant decimals = 18;
200 
201 	string public constant KimeraID = "5d43a41f-4528-4e98-8b0d-9df57a13864d";
202 
203     uint public _totalSupply;
204 
205 
206 
207     mapping(address => uint) balances;
208 
209     mapping(address => mapping(address => uint)) allowed;
210 
211 
212 
213 
214 
215     // ------------------------------------------------------------------------
216 
217     // Constructor
218 
219     // ------------------------------------------------------------------------
220 
221     constructor() public {
222 
223         _totalSupply = 100000000 * 10**uint(decimals);
224 
225         balances[owner] = _totalSupply;
226 
227         emit Transfer(address(0), owner, _totalSupply);
228 
229     }
230 
231 
232 
233 
234 
235     // ------------------------------------------------------------------------
236 
237     // Total supply
238 
239     // ------------------------------------------------------------------------
240 
241     function totalSupply() public constant returns (uint) {
242 
243         return _totalSupply  - balances[address(0)];
244 
245     }
246 
247 
248 
249 
250 
251     // ------------------------------------------------------------------------
252 
253     // Get the token balance for account `tokenOwner`
254 
255     // ------------------------------------------------------------------------
256 
257     function balanceOf(address tokenOwner) public constant returns (uint balance) {
258 
259         return balances[tokenOwner];
260 
261     }
262 
263 
264 
265 
266 
267     // ------------------------------------------------------------------------
268 
269     // Transfer the balance from token owner's account to `to` account
270 
271     // - Owner's account must have sufficient balance to transfer
272 
273     // - 0 value transfers are allowed
274 
275     // ------------------------------------------------------------------------
276 
277     function transfer(address to, uint tokens) public returns (bool success) {
278 
279         balances[msg.sender] = balances[msg.sender].sub(tokens);
280 
281         balances[to] = balances[to].add(tokens);
282 
283         emit Transfer(msg.sender, to, tokens);
284 
285         return true;
286 
287     }
288 
289 
290 
291 
292 
293     // ------------------------------------------------------------------------
294 
295     // Token owner can approve for `spender` to transferFrom(...) `tokens`
296 
297     // from the token owner's account
298 
299     //
300 
301     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
302 
303     // recommends that there are no checks for the approval double-spend attack
304 
305     // as this should be implemented in user interfaces 
306 
307     // ------------------------------------------------------------------------
308 
309     function approve(address spender, uint tokens) public returns (bool success) {
310 
311         allowed[msg.sender][spender] = tokens;
312 
313         emit Approval(msg.sender, spender, tokens);
314 
315         return true;
316 
317     }
318 
319 
320 
321 
322 
323     // ------------------------------------------------------------------------
324 
325     // Transfer `tokens` from the `from` account to the `to` account
326 
327     // 
328 
329     // The calling account must already have sufficient tokens approve(...)-d
330 
331     // for spending from the `from` account and
332 
333     // - From account must have sufficient balance to transfer
334 
335     // - Spender must have sufficient allowance to transfer
336 
337     // - 0 value transfers are allowed
338 
339     // ------------------------------------------------------------------------
340 
341     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
342 
343         balances[from] = balances[from].sub(tokens);
344 
345         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
346 
347         balances[to] = balances[to].add(tokens);
348 
349         emit Transfer(from, to, tokens);
350 
351         return true;
352 
353     }
354 
355 
356 
357 
358 
359     // ------------------------------------------------------------------------
360 
361     // Returns the amount of tokens approved by the owner that can be
362 
363     // transferred to the spender's account
364 
365     // ------------------------------------------------------------------------
366 
367     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
368 
369         return allowed[tokenOwner][spender];
370 
371     }
372 
373 
374 
375 
376 
377     // ------------------------------------------------------------------------
378 
379     // Token owner can approve for `spender` to transferFrom(...) `tokens`
380 
381     // from the token owner's account. The `spender` contract function
382 
383     // `receiveApproval(...)` is then executed
384 
385     // ------------------------------------------------------------------------
386 
387     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
388 
389         allowed[msg.sender][spender] = tokens;
390 
391         emit Approval(msg.sender, spender, tokens);
392 
393         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
394 
395         return true;
396 
397     }
398 
399 
400 
401 
402 
403     // ------------------------------------------------------------------------
404 
405     // Don't accept ETH
406 
407     // ------------------------------------------------------------------------
408 
409     function () public payable {
410 
411         revert();
412 
413     }
414 
415 
416 
417 
418 
419     // ------------------------------------------------------------------------
420 
421     // Owner can transfer out any accidentally sent ERC20 tokens
422 
423     // ------------------------------------------------------------------------
424 
425     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
426 
427         return ERC20Interface(tokenAddress).transfer(owner, tokens);
428 
429     }
430 
431 }