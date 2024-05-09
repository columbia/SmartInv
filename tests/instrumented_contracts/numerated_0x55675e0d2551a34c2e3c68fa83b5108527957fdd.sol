1 pragma solidity ^0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'IST34' 'IST34 Token' token contract
7 
8 //
9 
10 // Symbol      : IST34
11 
12 // Name        : IST34 Token
13 
14 // Total supply: 1,000,000,000,000.000000000000000000
15 
16 // Decimals    : 18
17 // ----------------------------------------------------------------------------
18 
19 
20 
21 // ----------------------------------------------------------------------------
22 
23 // Safe maths
24 
25 // ----------------------------------------------------------------------------
26 
27 library SafeMath {
28 
29     function add(uint a, uint b) internal pure returns (uint c) {
30 
31         c = a + b;
32 
33         require(c >= a);
34 
35     }
36 
37     function sub(uint a, uint b) internal pure returns (uint c) {
38 
39         require(b <= a);
40 
41         c = a - b;
42 
43     }
44 
45     function mul(uint a, uint b) internal pure returns (uint c) {
46 
47         c = a * b;
48 
49         require(a == 0 || c / a == b);
50 
51     }
52 
53     function div(uint a, uint b) internal pure returns (uint c) {
54 
55         require(b > 0);
56 
57         c = a / b;
58 
59     }
60 
61 }
62 
63 
64 
65 // ----------------------------------------------------------------------------
66 
67 // ERC Token Standard #20 Interface
68 
69 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
70 
71 // ----------------------------------------------------------------------------
72 
73 contract IST34TokenERC20Interface {
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
88     event Transfer(address indexed from, address indexed to, uint tokens);
89 
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91 
92 }
93 
94 
95 
96 // ----------------------------------------------------------------------------
97 
98 // Contract function to receive approval and execute function in one call
99 
100 //
101 
102 // Borrowed from MiniMeToken
103 
104 // ----------------------------------------------------------------------------
105 
106 contract ApproveAndCallFallBack {
107 
108     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
109 
110 }
111 
112 
113 
114 // ----------------------------------------------------------------------------
115 
116 // Owned contract
117 
118 // ----------------------------------------------------------------------------
119 
120 contract Owned {
121 
122     address public owner;
123 
124     address public newOwner;
125 
126 
127     event OwnershipTransferred(address indexed _from, address indexed _to);
128 
129 
130     constructor() public {
131 
132         owner = msg.sender;
133 
134     }
135 
136 
137     modifier onlyOwner {
138 
139         require(msg.sender == owner);
140 
141         _;
142 
143     }
144 
145 
146     function transferOwnership(address _newOwner) public onlyOwner {
147 
148         newOwner = _newOwner;
149 
150     }
151 
152     function acceptOwnership() public {
153 
154         require(msg.sender == newOwner);
155 
156         emit OwnershipTransferred(owner, newOwner);
157 
158         owner = newOwner;
159 
160         newOwner = address(0);
161 
162     }
163 
164 }
165 
166 
167 
168 // ----------------------------------------------------------------------------
169 
170 // ERC20 Token, with the addition of symbol, name and decimals and a
171 
172 // fixed supply
173 
174 // ----------------------------------------------------------------------------
175 
176 contract IST34Token is IST34TokenERC20Interface, Owned {
177 
178     using SafeMath for uint;
179 
180 
181     string public symbol;
182 
183     string public  name;
184 
185     uint8 public decimals;
186 
187     uint _totalSupply;
188 
189 
190     mapping(address => uint) balances;
191 
192     mapping(address => mapping(address => uint)) allowed;
193 
194 
195 
196     // ------------------------------------------------------------------------
197 
198     // Constructor
199 
200     // ------------------------------------------------------------------------
201 
202     constructor() public {
203 
204         symbol = "IST34";
205 
206         name = "IST34 Token";
207 
208         decimals = 18;
209 
210         _totalSupply = 1000000000000 * 10**uint(decimals);
211 
212         balances[owner] = _totalSupply;
213 
214         emit Transfer(address(0), owner, _totalSupply);
215 
216     }
217 
218 
219 
220     // ------------------------------------------------------------------------
221 
222     // Total supply
223 
224     // ------------------------------------------------------------------------
225 
226     function totalSupply() public view returns (uint) {
227 
228         return _totalSupply.sub(balances[address(0)]);
229 
230     }
231 
232 
233 
234     // ------------------------------------------------------------------------
235 
236     // Get the token balance for account `tokenOwner`
237 
238     // ------------------------------------------------------------------------
239 
240     function balanceOf(address tokenOwner) public view returns (uint balance) {
241 
242         return balances[tokenOwner];
243 
244     }
245 
246 
247 
248     // ------------------------------------------------------------------------
249 
250     // Transfer the balance from token owner's account to `to` account
251 
252     // - Owner's account must have sufficient balance to transfer
253 
254     // - 0 value transfers are allowed
255 
256     // ------------------------------------------------------------------------
257 
258     function transfer(address to, uint tokens) public returns (bool success) {
259 
260         balances[msg.sender] = balances[msg.sender].sub(tokens);
261 
262         balances[to] = balances[to].add(tokens);
263 
264         emit Transfer(msg.sender, to, tokens);
265 
266         return true;
267 
268     }
269 
270 
271 
272     // ------------------------------------------------------------------------
273 
274     // Token owner can approve for `spender` to transferFrom(...) `tokens`
275 
276     // from the token owner's account
277 
278     //
279 
280     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
281 
282     // recommends that there are no checks for the approval double-spend attack
283 
284     // as this should be implemented in user interfaces 
285 
286     // ------------------------------------------------------------------------
287 
288     function approve(address spender, uint tokens) public returns (bool success) {
289 
290         allowed[msg.sender][spender] = tokens;
291 
292         emit Approval(msg.sender, spender, tokens);
293 
294         return true;
295 
296     }
297 
298 
299 
300     // ------------------------------------------------------------------------
301 
302     // Transfer `tokens` from the `from` account to the `to` account
303 
304     // 
305 
306     // The calling account must already have sufficient tokens approve(...)-d
307 
308     // for spending from the `from` account and
309 
310     // - From account must have sufficient balance to transfer
311 
312     // - Spender must have sufficient allowance to transfer
313 
314     // - 0 value transfers are allowed
315 
316     // ------------------------------------------------------------------------
317 
318     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
319 
320         balances[from] = balances[from].sub(tokens);
321 
322         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
323 
324         balances[to] = balances[to].add(tokens);
325 
326         emit Transfer(from, to, tokens);
327 
328         return true;
329 
330     }
331 
332 
333 
334     // ------------------------------------------------------------------------
335 
336     // Returns the amount of tokens approved by the owner that can be
337 
338     // transferred to the spender's account
339 
340     // ------------------------------------------------------------------------
341 
342     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
343 
344         return allowed[tokenOwner][spender];
345 
346     }
347 
348 
349 
350     // ------------------------------------------------------------------------
351 
352     // Token owner can approve for `spender` to transferFrom(...) `tokens`
353 
354     // from the token owner's account. The `spender` contract function
355 
356     // `receiveApproval(...)` is then executed
357 
358     // ------------------------------------------------------------------------
359 
360     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
361 
362         allowed[msg.sender][spender] = tokens;
363 
364         emit Approval(msg.sender, spender, tokens);
365 
366         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
367 
368         return true;
369 
370     }
371 
372 
373 
374     // ------------------------------------------------------------------------
375 
376     // Don't accept ETH
377 
378     // ------------------------------------------------------------------------
379 
380     function () public payable {
381 
382         revert();
383 
384     }
385 
386 
387 
388     // ------------------------------------------------------------------------
389 
390     // Owner can transfer out any accidentally sent ERC20 tokens
391 
392     // ------------------------------------------------------------------------
393 
394     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
395 
396         return IST34TokenERC20Interface(tokenAddress).transfer(owner, tokens);
397 
398     }
399 
400 }