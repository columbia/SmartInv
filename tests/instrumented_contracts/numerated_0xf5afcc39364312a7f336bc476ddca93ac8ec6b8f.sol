1 //pragma solidity ^0.4.0;
2 pragma solidity ^0.4.18;
3 
4  
5 
6 // ----------------------------------------------------------------------------
7 
8 // 'DESI' 'Design token contract
9 
10 //
11 
12 // Symbol      : Desi
13 
14 // Name        : Design token
15 
16 // Total supply: 10,000,000.000000000000000000
17 
18 // Decimals    : 18
19 
20 //
21 
22 // Enjoy.
23 
24 //
25 
26 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
27 
28 // ----------------------------------------------------------------------------
29 
30  
31 
32  
33 
34 // ----------------------------------------------------------------------------
35 
36 // Safe maths
37 
38 // ----------------------------------------------------------------------------
39 
40 library SafeMath {
41 
42     function add(uint a, uint b) internal pure returns (uint c) {
43 
44         c = a + b;
45 
46         require(c >= a);
47 
48     }
49 
50     function sub(uint a, uint b) internal pure returns (uint c) {
51 
52         require(b <= a);
53 
54         c = a - b;
55 
56     }
57 
58     function mul(uint a, uint b) internal pure returns (uint c) {
59 
60         c = a * b;
61 
62         require(a == 0 || c / a == b);
63 
64     }
65 
66     function div(uint a, uint b) internal pure returns (uint c) {
67 
68         require(b > 0);
69 
70         c = a / b;
71 
72     }
73 
74 }
75 
76  
77 
78  
79 
80 // ----------------------------------------------------------------------------
81 
82 // ERC Token Standard #20 Interface
83 
84 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
85 
86 // ----------------------------------------------------------------------------
87 
88 contract ERC20Interface {
89 
90     function totalSupply() public constant returns (uint);
91 
92     function balanceOf(address tokenOwner) public constant returns (uint balance);
93 
94     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
95 
96     function transfer(address to, uint tokens) public returns (bool success);
97 
98     function approve(address spender, uint tokens) public returns (bool success);
99 
100     function transferFrom(address from, address to, uint tokens) public returns (bool success);
101 
102  
103 
104     event Transfer(address indexed from, address indexed to, uint tokens);
105 
106     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
107 
108 }
109 
110  
111 
112  
113 
114 // ----------------------------------------------------------------------------
115 
116 // Contract function to receive approval and execute function in one call
117 
118 //
119 
120 // Borrowed from MiniMeToken
121 
122 // ----------------------------------------------------------------------------
123 
124 contract ApproveAndCallFallBack {
125 
126     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
127 
128 }
129 
130  
131 
132  
133 
134 // ----------------------------------------------------------------------------
135 
136 // Owned contract
137 
138 // ----------------------------------------------------------------------------
139 
140 contract Owned {
141 
142     address public owner;
143 
144     address public newOwner;
145 
146  
147 
148     event OwnershipTransferred(address indexed _from, address indexed _to);
149 
150  
151 
152     function Owned() public {
153 
154         owner = msg.sender;
155 
156     }
157 
158  
159 
160     modifier onlyOwner {
161 
162         require(msg.sender == owner);
163 
164         _;
165 
166     }
167 
168  
169 
170     function transferOwnership(address _newOwner) public onlyOwner {
171 
172         newOwner = _newOwner;
173 
174     }
175 
176     function acceptOwnership() public {
177 
178         require(msg.sender == newOwner);
179 
180         OwnershipTransferred(owner, newOwner);
181 
182         owner = newOwner;
183 
184         newOwner = address(0);
185 
186     }
187 
188 }
189 
190  
191 
192  
193 
194 // ----------------------------------------------------------------------------
195 
196 // ERC20 Token, with the addition of symbol, name and decimals and an
197 
198 // initial fixed supply
199 
200 // ----------------------------------------------------------------------------
201 
202 contract DesignToken is ERC20Interface, Owned {
203 
204     using SafeMath for uint;
205 
206  
207 
208     string public symbol;
209 
210     string public  name;
211 
212     uint8 public decimals;
213 
214     uint public _totalSupply;
215 
216  
217 
218     mapping(address => uint) balances;
219 
220     mapping(address => mapping(address => uint)) allowed;
221 
222  
223 
224  
225 
226     // ------------------------------------------------------------------------
227 
228     // Constructor
229 
230     // ------------------------------------------------------------------------
231 
232     function DesignToken() public {
233 
234         symbol = "Desi";
235 
236         name = "Design";
237 
238         decimals = 18;
239 
240         _totalSupply = 10000000 * 10**uint(decimals);
241 
242         balances[owner] = _totalSupply;
243 
244         Transfer(address(0), owner, _totalSupply);
245 
246     }
247 
248  
249 
250  
251 
252     // ------------------------------------------------------------------------
253 
254     // Total supply
255 
256     // ------------------------------------------------------------------------
257 
258     function totalSupply() public constant returns (uint) {
259 
260         return _totalSupply  - balances[address(0)];
261 
262     }
263 
264  
265 
266  
267 
268     // ------------------------------------------------------------------------
269 
270     // Get the token balance for account `tokenOwner`
271 
272     // ------------------------------------------------------------------------
273 
274     function balanceOf(address tokenOwner) public constant returns (uint balance) {
275 
276         return balances[tokenOwner];
277 
278     }
279 
280  
281 
282  
283 
284     // ------------------------------------------------------------------------
285 
286     // Transfer the balance from token owner's account to `to` account
287 
288     // - Owner's account must have sufficient balance to transfer
289 
290     // - 0 value transfers are allowed
291 
292     // ------------------------------------------------------------------------
293 
294     function transfer(address to, uint tokens) public returns (bool success) {
295 
296         balances[msg.sender] = balances[msg.sender].sub(tokens);
297 
298         balances[to] = balances[to].add(tokens);
299 
300         Transfer(msg.sender, to, tokens);
301 
302         return true;
303 
304     }
305 
306  
307 
308  
309 
310     // ------------------------------------------------------------------------
311 
312     // Token owner can approve for `spender` to transferFrom(...) `tokens`
313 
314     // from the token owner's account
315 
316     //
317 
318     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
319 
320     // recommends that there are no checks for the approval double-spend attack
321 
322     // as this should be implemented in user interfaces
323 
324     // ------------------------------------------------------------------------
325 
326     function approve(address spender, uint tokens) public returns (bool success) {
327 
328         allowed[msg.sender][spender] = tokens;
329 
330         Approval(msg.sender, spender, tokens);
331 
332         return true;
333 
334     }
335 
336  
337 
338  
339 
340     // ------------------------------------------------------------------------
341 
342     // Transfer `tokens` from the `from` account to the `to` account
343 
344     //
345 
346     // The calling account must already have sufficient tokens approve(...)-d
347 
348     // for spending from the `from` account and
349 
350     // - From account must have sufficient balance to transfer
351 
352     // - Spender must have sufficient allowance to transfer
353 
354     // - 0 value transfers are allowed
355 
356     // ------------------------------------------------------------------------
357 
358     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
359 
360         balances[from] = balances[from].sub(tokens);
361 
362         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
363 
364         balances[to] = balances[to].add(tokens);
365 
366         Transfer(from, to, tokens);
367 
368         return true;
369 
370     }
371 
372  
373 
374  
375 
376     // ------------------------------------------------------------------------
377 
378     // Returns the amount of tokens approved by the owner that can be
379 
380     // transferred to the spender's account
381 
382     // ------------------------------------------------------------------------
383 
384     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
385 
386         return allowed[tokenOwner][spender];
387 
388     }
389 
390  
391 
392  
393 
394     // ------------------------------------------------------------------------
395 
396     // Token owner can approve for `spender` to transferFrom(...) `tokens`
397 
398     // from the token owner's account. The `spender` contract function
399 
400     // `receiveApproval(...)` is then executed
401 
402     // ------------------------------------------------------------------------
403 
404     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
405 
406         allowed[msg.sender][spender] = tokens;
407 
408         Approval(msg.sender, spender, tokens);
409 
410         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
411 
412         return true;
413 
414     }
415 
416  
417 
418  
419 
420     // ------------------------------------------------------------------------
421 
422     // Don't accept ETH
423 
424     // ------------------------------------------------------------------------
425 
426     function () public payable {
427 
428         revert();
429 
430     }
431 
432  
433 
434  
435 
436     // ------------------------------------------------------------------------
437 
438     // Owner can transfer out any accidentally sent ERC20 tokens
439 
440     // ------------------------------------------------------------------------
441 
442     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
443 
444         return ERC20Interface(tokenAddress).transfer(owner, tokens);
445 
446     }
447 
448 }