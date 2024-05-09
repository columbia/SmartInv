1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 
5 // Safe maths
6 
7 // ----------------------------------------------------------------------------
8 
9 library SafeMath {
10 
11     function add(uint a, uint b) internal pure returns (uint c) {
12 
13         c = a + b;
14 
15         require(c >= a);
16 
17     }
18 
19     function sub(uint a, uint b) internal pure returns (uint c) {
20 
21         require(b <= a);
22 
23         c = a - b;
24 
25     }
26 
27     function mul(uint a, uint b) internal pure returns (uint c) {
28 
29         c = a * b;
30 
31         require(a == 0 || c / a == b);
32 
33     }
34 
35     function div(uint a, uint b) internal pure returns (uint c) {
36 
37         require(b > 0);
38 
39         c = a / b;
40 
41     }
42 
43 }
44 
45 
46 
47 // ----------------------------------------------------------------------------
48 
49 // ERC Token Standard #20 Interface
50 
51 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
52 
53 // ----------------------------------------------------------------------------
54 
55 contract ERC20Interface {
56 
57     function totalSupply() public constant returns (uint);
58 
59     function balanceOf(address tokenOwner) public constant returns (uint balance);
60 
61     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
62 
63     function transfer(address to, uint tokens) public returns (bool success);
64 
65     function approve(address spender, uint tokens) public returns (bool success);
66 
67     function transferFrom(address from, address to, uint tokens) public returns (bool success);
68 
69 
70     event Transfer(address indexed from, address indexed to, uint tokens);
71 
72     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
73 
74 }
75 
76 
77 
78 // ----------------------------------------------------------------------------
79 
80 // Contract function to receive approval and execute function in one call
81 
82 //
83 
84 // Borrowed from MiniMeToken
85 
86 // ----------------------------------------------------------------------------
87 
88 contract ApproveAndCallFallBack {
89 
90     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
91 
92 }
93 
94 
95 
96 // ----------------------------------------------------------------------------
97 
98 // Owned contract
99 
100 // ----------------------------------------------------------------------------
101 
102 contract Owned {
103 
104     address public owner;
105 
106     address public newOwner;
107 
108 
109     event OwnershipTransferred(address indexed _from, address indexed _to);
110 
111 
112     function Owned() public {
113 
114         owner = msg.sender;
115 
116     }
117 
118 
119     modifier onlyOwner {
120 
121         require(msg.sender == owner);
122 
123         _;
124 
125     }
126 
127 
128     function transferOwnership(address _newOwner) public onlyOwner {
129 
130         newOwner = _newOwner;
131 
132     }
133 
134     function acceptOwnership() public {
135 
136         require(msg.sender == newOwner);
137 
138         OwnershipTransferred(owner, newOwner);
139 
140         owner = newOwner;
141 
142         newOwner = address(0);
143 
144     }
145 
146 }
147 
148 
149 
150 // ----------------------------------------------------------------------------
151 
152 // ERC20 Token, with the addition of symbol, name and decimals and an
153 
154 // initial fixed supply
155 
156 // ----------------------------------------------------------------------------
157 
158 contract ERC20Token is ERC20Interface, Owned {
159 
160     using SafeMath for uint;
161 
162 
163     string public symbol;
164 
165     string public  name;
166 
167     uint8 public decimals;
168 
169     uint public _totalSupply;
170 
171 
172     mapping(address => uint) balances;
173 
174     mapping(address => mapping(address => uint)) allowed;
175 
176 
177 
178     // ------------------------------------------------------------------------
179 
180     // Constructor 
181 
182     // ------------------------------------------------------------------------
183 	//20000000000000000     发行总量2亿
184     //200000000.00000000 
185 
186     function ERC20Token() public {
187 
188         symbol = "GBCS";
189 
190         name = "Global Brand Coins";
191 
192         decimals = 8;
193 
194         _totalSupply = 20000000000000000;
195 
196         balances[owner] = _totalSupply;
197 
198         Transfer(address(0), owner, _totalSupply);
199 
200     }
201 
202 
203 
204     // ------------------------------------------------------------------------
205 
206     // Total supply
207 
208     // ------------------------------------------------------------------------
209 
210     function totalSupply() public constant returns (uint) {
211 
212         return _totalSupply  - balances[address(0)];
213 
214     }
215 
216 
217 
218     // ------------------------------------------------------------------------
219 
220     // Get the token balance for account `tokenOwner`
221 
222     // ------------------------------------------------------------------------
223 
224     function balanceOf(address tokenOwner) public constant returns (uint balance) {
225 
226         return balances[tokenOwner];
227 
228     }
229 
230 
231 
232     // ------------------------------------------------------------------------
233 
234     // Transfer the balance from token owner's account to `to` account
235 
236     // - Owner's account must have sufficient balance to transfer
237 
238     // - 0 value transfers are allowed
239 
240     // ------------------------------------------------------------------------
241 
242     function transfer(address to, uint tokens) public returns (bool success) {
243 
244         balances[msg.sender] = balances[msg.sender].sub(tokens);
245 
246         balances[to] = balances[to].add(tokens);
247 
248         Transfer(msg.sender, to, tokens);
249 
250         return true;
251 
252     }
253 
254 
255 
256     // ------------------------------------------------------------------------
257 
258     // Token owner can approve for `spender` to transferFrom(...) `tokens`
259 
260     // from the token owner's account
261 
262     //
263 
264     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
265 
266     // recommends that there are no checks for the approval double-spend attack
267 
268     // as this should be implemented in user interfaces 
269 
270     // ------------------------------------------------------------------------
271 
272     function approve(address spender, uint tokens) public returns (bool success) {
273 
274         allowed[msg.sender][spender] = tokens;
275 
276         Approval(msg.sender, spender, tokens);
277 
278         return true;
279 
280     }
281 
282 
283 
284     // ------------------------------------------------------------------------
285 
286     // Transfer `tokens` from the `from` account to the `to` account
287 
288     // 
289 
290     // The calling account must already have sufficient tokens approve(...)-d
291 
292     // for spending from the `from` account and
293 
294     // - From account must have sufficient balance to transfer
295 
296     // - Spender must have sufficient allowance to transfer
297 
298     // - 0 value transfers are allowed
299 
300     // ------------------------------------------------------------------------
301 
302     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
303 
304         balances[from] = balances[from].sub(tokens);
305 
306         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
307 
308         balances[to] = balances[to].add(tokens);
309 
310         Transfer(from, to, tokens);
311 
312         return true;
313 
314     }
315 
316 
317 
318     // ------------------------------------------------------------------------
319 
320     // Returns the amount of tokens approved by the owner that can be
321 
322     // transferred to the spender's account
323 
324     // ------------------------------------------------------------------------
325 
326     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
327 
328         return allowed[tokenOwner][spender];
329 
330     }
331 
332 
333 
334     // ------------------------------------------------------------------------
335 
336     // Token owner can approve for `spender` to transferFrom(...) `tokens`
337 
338     // from the token owner's account. The `spender` contract function
339 
340     // `receiveApproval(...)` is then executed
341 
342     // ------------------------------------------------------------------------
343 
344     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
345 
346         allowed[msg.sender][spender] = tokens;
347 
348         Approval(msg.sender, spender, tokens);
349 
350         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
351 
352         return true;
353 
354     }
355 
356 
357 
358     // ------------------------------------------------------------------------
359 
360     // Don't accept ETH
361 
362     // ------------------------------------------------------------------------
363 
364     function () public payable {
365 
366         revert();
367 
368     }
369 
370 
371 
372     // ------------------------------------------------------------------------
373 
374     // Owner can transfer out any accidentally sent ERC20 tokens
375 
376     // ------------------------------------------------------------------------
377 
378     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
379 
380         return ERC20Interface(tokenAddress).transfer(owner, tokens);
381 
382     }
383 
384 }