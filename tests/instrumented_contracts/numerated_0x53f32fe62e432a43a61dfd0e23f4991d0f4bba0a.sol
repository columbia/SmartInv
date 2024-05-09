1 pragma solidity ^0.4.19;
2 // https://etherscan.io/token/0x53f32fe62e432a43a61dfd0e23f4991d0f4bba0a
3 
4 // ----------------------------------------------------------------------------
5 
6 // Safe maths
7 
8 // ----------------------------------------------------------------------------
9 
10 library SafeMath {
11 
12     function add(uint a, uint b) internal pure returns (uint c) {
13 
14         c = a + b;
15 
16         require(c >= a);
17 
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint c) {
21 
22         require(b <= a);
23 
24         c = a - b;
25 
26     }
27 
28     function mul(uint a, uint b) internal pure returns (uint c) {
29 
30         c = a * b;
31 
32         require(a == 0 || c / a == b);
33 
34     }
35 
36     function div(uint a, uint b) internal pure returns (uint c) {
37 
38         require(b > 0);
39 
40         c = a / b;
41 
42     }
43 
44 }
45 
46 
47 
48 // ----------------------------------------------------------------------------
49 
50 // ERC Token Standard #20 Interface
51 
52 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
53 
54 // ----------------------------------------------------------------------------
55 
56 contract ERC20Interface {
57 
58     function totalSupply() public constant returns (uint);
59 
60     function balanceOf(address tokenOwner) public constant returns (uint balance);
61 
62     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
63 
64     function transfer(address to, uint tokens) public returns (bool success);
65 
66     function approve(address spender, uint tokens) public returns (bool success);
67 
68     function transferFrom(address from, address to, uint tokens) public returns (bool success);
69 
70 
71     event Transfer(address indexed from, address indexed to, uint tokens);
72 
73     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
74 
75 }
76 
77 
78 
79 // ----------------------------------------------------------------------------
80 
81 // Contract function to receive approval and execute function in one call
82 
83 //
84 
85 // Borrowed from MiniMeToken
86 
87 // ----------------------------------------------------------------------------
88 
89 contract ApproveAndCallFallBack {
90 
91     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
92 
93 }
94 
95 
96 
97 // ----------------------------------------------------------------------------
98 
99 // Owned contract
100 
101 // ----------------------------------------------------------------------------
102 
103 contract Owned {
104 
105     address public owner;
106 
107     address public newOwner;
108 
109 
110     event OwnershipTransferred(address indexed _from, address indexed _to);
111 
112 
113     function Owned() public {
114 
115         owner = msg.sender;
116 
117     }
118 
119 
120     modifier onlyOwner {
121 
122         require(msg.sender == owner);
123 
124         _;
125 
126     }
127 
128 
129     function transferOwnership(address _newOwner) public onlyOwner {
130 
131         newOwner = _newOwner;
132 
133     }
134 
135     function acceptOwnership() public {
136 
137         require(msg.sender == newOwner);
138 
139         OwnershipTransferred(owner, newOwner);
140 
141         owner = newOwner;
142 
143         newOwner = address(0);
144 
145     }
146 
147 }
148 
149 
150 
151 // ----------------------------------------------------------------------------
152 
153 // ERC20 Token, with the addition of symbol, name and decimals and an
154 
155 // initial fixed supply
156 
157 // ----------------------------------------------------------------------------
158 
159 contract ERC20Token is ERC20Interface, Owned {
160 
161     using SafeMath for uint;
162 
163 
164     string public symbol;
165 
166     string public  name;
167 
168     uint8 public decimals;
169 
170     uint public _totalSupply;
171 
172 
173     mapping(address => uint) balances;
174 
175     mapping(address => mapping(address => uint)) allowed;
176 
177 
178 
179     // ------------------------------------------------------------------------
180 
181     // Constructor 
182 
183     // ------------------------------------------------------------------------
184 
185     function ERC20Token() public {
186 
187         symbol = "ADC";
188 
189         name = "Africa Development Chain";
190 
191         decimals = 18;
192 
193         _totalSupply = 490000000 * 10**uint(decimals); // 4.9 亿
194 
195         balances[owner] = _totalSupply;
196 
197         Transfer(address(0), owner, _totalSupply);
198 
199     }
200 
201 
202 
203     // ------------------------------------------------------------------------
204 
205     // Total supply
206 
207     // ------------------------------------------------------------------------
208 
209     function totalSupply() public constant returns (uint) {
210 
211         return _totalSupply  - balances[address(0)];
212 
213     }
214 
215 
216 
217     // ------------------------------------------------------------------------
218 
219     // Get the token balance for account `tokenOwner`
220 
221     // ------------------------------------------------------------------------
222 
223     function balanceOf(address tokenOwner) public constant returns (uint balance) {
224 
225         return balances[tokenOwner];
226 
227     }
228 
229 
230 
231     // ------------------------------------------------------------------------
232 
233     // Transfer the balance from token owner's account to `to` account
234 
235     // - Owner's account must have sufficient balance to transfer
236 
237     // - 0 value transfers are allowed
238 
239     // ------------------------------------------------------------------------
240 
241     function transfer(address to, uint tokens) public returns (bool success) {
242 
243         balances[msg.sender] = balances[msg.sender].sub(tokens);
244 
245         balances[to] = balances[to].add(tokens);
246 
247         Transfer(msg.sender, to, tokens);
248 
249         return true;
250 
251     }
252 
253 
254 
255     // ------------------------------------------------------------------------
256 
257     // Token owner can approve for `spender` to transferFrom(...) `tokens`
258 
259     // from the token owner's account
260 
261     //
262 
263     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
264 
265     // recommends that there are no checks for the approval double-spend attack
266 
267     // as this should be implemented in user interfaces 
268 
269     // ------------------------------------------------------------------------
270 
271     function approve(address spender, uint tokens) public returns (bool success) {
272 
273         allowed[msg.sender][spender] = tokens;
274 
275         Approval(msg.sender, spender, tokens);
276 
277         return true;
278 
279     }
280 
281 
282 
283     // ------------------------------------------------------------------------
284 
285     // Transfer `tokens` from the `from` account to the `to` account
286 
287     // 
288 
289     // The calling account must already have sufficient tokens approve(...)-d
290 
291     // for spending from the `from` account and
292 
293     // - From account must have sufficient balance to transfer
294 
295     // - Spender must have sufficient allowance to transfer
296 
297     // - 0 value transfers are allowed
298 
299     // ------------------------------------------------------------------------
300 
301     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
302 
303         balances[from] = balances[from].sub(tokens);
304 
305         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
306 
307         balances[to] = balances[to].add(tokens);
308 
309         Transfer(from, to, tokens);
310 
311         return true;
312 
313     }
314 
315 
316 
317     // ------------------------------------------------------------------------
318 
319     // Returns the amount of tokens approved by the owner that can be
320 
321     // transferred to the spender's account
322 
323     // ------------------------------------------------------------------------
324 
325     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
326 
327         return allowed[tokenOwner][spender];
328 
329     }
330 
331 
332 
333     // ------------------------------------------------------------------------
334 
335     // Token owner can approve for `spender` to transferFrom(...) `tokens`
336 
337     // from the token owner's account. The `spender` contract function
338 
339     // `receiveApproval(...)` is then executed
340 
341     // ------------------------------------------------------------------------
342 
343     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
344 
345         allowed[msg.sender][spender] = tokens;
346 
347         Approval(msg.sender, spender, tokens);
348 
349         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
350 
351         return true;
352 
353     }
354 
355 
356 
357     // ------------------------------------------------------------------------
358 
359     // Don't accept ETH
360 
361     // ------------------------------------------------------------------------
362 
363     function () public payable {
364 
365         revert();
366 
367     }
368 
369 
370 
371     // ------------------------------------------------------------------------
372 
373     // Owner can transfer out any accidentally sent ERC20 tokens
374 
375     // ------------------------------------------------------------------------
376 
377     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
378 
379         return ERC20Interface(tokenAddress).transfer(owner, tokens);
380 
381     }
382 
383 }