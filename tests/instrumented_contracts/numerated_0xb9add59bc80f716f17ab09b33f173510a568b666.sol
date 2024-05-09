1 pragma solidity ^0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'Ballet (BALLET)' 'Fixed Supply Token' token contract
7 
8 //
9 
10 // Symbol      : BALLET
11 
12 // Name        : Ballet
13 
14 // Decimals    : 18
15 
16 //
17 
18 // ----------------------------------------------------------------------------
19 
20 
21 
22 // ----------------------------------------------------------------------------
23 
24 // Safe maths
25 
26 // ----------------------------------------------------------------------------
27 
28 library SafeMath {
29 
30     function add(uint a, uint b) internal pure returns (uint c) {
31 
32         c = a + b;
33 
34         require(c >= a);
35 
36     }
37 
38     function sub(uint a, uint b) internal pure returns (uint c) {
39 
40         require(b <= a);
41 
42         c = a - b;
43 
44     }
45 
46     function mul(uint a, uint b) internal pure returns (uint c) {
47 
48         c = a * b;
49 
50         require(a == 0 || c / a == b);
51 
52     }
53 
54     function div(uint a, uint b) internal pure returns (uint c) {
55 
56         require(b > 0);
57 
58         c = a / b;
59 
60     }
61 
62 }
63 
64 
65 
66 // ----------------------------------------------------------------------------
67 
68 // ERC Token Standard #20 Interface
69 
70 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
71 
72 // ----------------------------------------------------------------------------
73 
74 contract ERC20Interface {
75 
76     function totalSupply() public constant returns (uint);
77 
78     function balanceOf(address tokenOwner) public constant returns (uint balance);
79 
80     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
81 
82     function transfer(address to, uint tokens) public returns (bool success);
83 
84     function approve(address spender, uint tokens) public returns (bool success);
85 
86     function transferFrom(address from, address to, uint tokens) public returns (bool success);
87 
88 
89     event Transfer(address indexed from, address indexed to, uint tokens);
90 
91     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
92 
93 }
94 
95 
96 
97 // ----------------------------------------------------------------------------
98 
99 // Contract function to receive approval and execute function in one call
100 
101 
102 // ----------------------------------------------------------------------------
103 
104 contract ApproveAndCallFallBack {
105 
106     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
107 
108 }
109 
110 
111 
112 // ----------------------------------------------------------------------------
113 
114 // Owned contract
115 
116 // ----------------------------------------------------------------------------
117 
118 contract Owned {
119 
120     address public owner;
121 
122     address public newOwner;
123 
124 
125     event OwnershipTransferred(address indexed _from, address indexed _to);
126 
127 
128     constructor() public {
129 
130         owner = msg.sender;
131 
132     }
133 
134 
135     modifier onlyOwner {
136 
137         require(msg.sender == owner);
138 
139         _;
140 
141     }
142 
143 
144     function transferOwnership(address _newOwner) public onlyOwner {
145 
146         newOwner = _newOwner;
147 
148     }
149 
150     function acceptOwnership() public {
151 
152         require(msg.sender == newOwner);
153 
154         emit OwnershipTransferred(owner, newOwner);
155 
156         owner = newOwner;
157 
158         newOwner = address(0);
159 
160     }
161 
162 }
163 
164 
165 
166 // ----------------------------------------------------------------------------
167 
168 // ERC20 Token, with the addition of symbol, name and decimals and a
169 
170 // fixed supply
171 
172 // ----------------------------------------------------------------------------
173 
174 contract BALLET is ERC20Interface, Owned {
175 
176     using SafeMath for uint;
177 
178 
179     string public symbol;
180 
181     string public  name;
182 
183     uint8 public decimals;
184 
185     uint _totalSupply;
186 
187 
188     mapping(address => uint) balances;
189 
190     mapping(address => mapping(address => uint)) allowed;
191 
192 
193 
194     // ------------------------------------------------------------------------
195 
196     // Constructor
197 
198     // ------------------------------------------------------------------------
199 
200     constructor() public {
201 
202         symbol = "BALLET";
203 
204         name = "Ballet Token";
205 
206         decimals = 18;
207 
208         _totalSupply = 1000000000000000 * 10**uint(decimals);
209 
210         balances[owner] = _totalSupply;
211 
212         emit Transfer(address(0), owner, _totalSupply);
213 
214     }
215 
216 
217 
218     // ------------------------------------------------------------------------
219 
220     // Total supply
221 
222     // ------------------------------------------------------------------------
223 
224     function totalSupply() public view returns (uint) {
225 
226         return _totalSupply.sub(balances[address(0)]);
227 
228     }
229 
230 
231 
232     // ------------------------------------------------------------------------
233 
234     // Get the token balance for account `tokenOwner`
235 
236     // ------------------------------------------------------------------------
237 
238     function balanceOf(address tokenOwner) public view returns (uint balance) {
239 
240         return balances[tokenOwner];
241 
242     }
243 
244 
245 
246     // ------------------------------------------------------------------------
247 
248     // Transfer the balance from token owner's account to `to` account
249 
250     // - Owner's account must have sufficient balance to transfer
251 
252     // - 0 value transfers are allowed
253 
254     // ------------------------------------------------------------------------
255 
256     function transfer(address to, uint tokens) public returns (bool success) {
257 
258         balances[msg.sender] = balances[msg.sender].sub(tokens);
259 
260         balances[to] = balances[to].add(tokens);
261 
262         emit Transfer(msg.sender, to, tokens);
263 
264         return true;
265 
266     }
267 
268 
269 
270     // ------------------------------------------------------------------------
271 
272     // Token owner can approve for `spender` to transferFrom(...) `tokens`
273 
274     // from the token owner's account
275 
276     //
277 
278     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
279 
280     // recommends that there are no checks for the approval double-spend attack
281 
282     // as this should be implemented in user interfaces 
283 
284     // ------------------------------------------------------------------------
285 
286     function approve(address spender, uint tokens) public returns (bool success) {
287 
288         allowed[msg.sender][spender] = tokens;
289 
290         emit Approval(msg.sender, spender, tokens);
291 
292         return true;
293 
294     }
295 
296 
297 
298     // ------------------------------------------------------------------------
299 
300     // Transfer `tokens` from the `from` account to the `to` account
301 
302     // 
303 
304     // The calling account must already have sufficient tokens approve(...)-d
305 
306     // for spending from the `from` account and
307 
308     // - From account must have sufficient balance to transfer
309 
310     // - Spender must have sufficient allowance to transfer
311 
312     // - 0 value transfers are allowed
313 
314     // ------------------------------------------------------------------------
315 
316     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
317 
318         balances[from] = balances[from].sub(tokens);
319 
320         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
321 
322         balances[to] = balances[to].add(tokens);
323 
324         emit Transfer(from, to, tokens);
325 
326         return true;
327 
328     }
329 
330 
331 
332     // ------------------------------------------------------------------------
333 
334     // Returns the amount of tokens approved by the owner that can be
335 
336     // transferred to the spender's account
337 
338     // ------------------------------------------------------------------------
339 
340     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
341 
342         return allowed[tokenOwner][spender];
343 
344     }
345 
346 
347 
348     // ------------------------------------------------------------------------
349 
350     // Token owner can approve for `spender` to transferFrom(...) `tokens`
351 
352     // from the token owner's account. The `spender` contract function
353 
354     // `receiveApproval(...)` is then executed
355 
356     // ------------------------------------------------------------------------
357 
358     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
359 
360         allowed[msg.sender][spender] = tokens;
361 
362         emit Approval(msg.sender, spender, tokens);
363 
364         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
365 
366         return true;
367 
368     }
369 
370 
371 
372     // ------------------------------------------------------------------------
373 
374     // Don't accept ETH
375 
376     // ------------------------------------------------------------------------
377 
378     function () public payable {
379 
380         revert();
381 
382     }
383 
384 
385 
386     // ------------------------------------------------------------------------
387 
388     // Owner can transfer out any accidentally sent ERC20 tokens
389 
390     // ------------------------------------------------------------------------
391 
392     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
393 
394         return ERC20Interface(tokenAddress).transfer(owner, tokens);
395 
396     }
397 
398 }