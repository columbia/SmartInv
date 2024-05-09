1 pragma solidity ^0.4.18;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 
7 // 'PakGoldCoin' token contract
8 
9 //
10 
11 // Deployed to : 0x362Eae330a1D84f565FCd8Fa0F9C7c1e40e8F202
12 
13 // Symbol      : PGC
14 
15 // Name        : PakGoldCoin
16 
17 // Total supply: 1,000,000,000
18 
19 // Decimals    : 18
20 
21 
22 
23 // ----------------------------------------------------------------------------
24 
25 
26 
27 
28 
29 // ----------------------------------------------------------------------------
30 
31 // Safe maths
32 
33 // ----------------------------------------------------------------------------
34 
35 contract SafeMath {
36 
37     function safeAdd(uint a, uint b) public pure returns (uint c) {
38 
39         c = a + b;
40 
41         require(c >= a);
42 
43     }
44 
45     function safeSub(uint a, uint b) public pure returns (uint c) {
46 
47         require(b <= a);
48 
49         c = a - b;
50 
51     }
52 
53     function safeMul(uint a, uint b) public pure returns (uint c) {
54 
55         c = a * b;
56 
57         require(a == 0 || c / a == b);
58 
59     }
60 
61     function safeDiv(uint a, uint b) public pure returns (uint c) {
62 
63         require(b > 0);
64 
65         c = a / b;
66 
67     }
68 
69 }
70 
71 
72 
73 
74 
75 // ----------------------------------------------------------------------------
76 
77 // ERC Token Standard #20 Interface
78 
79 // ----------------------------------------------------------------------------
80 
81 contract ERC20Interface {
82 
83     function totalSupply() public constant returns (uint);
84 
85     function balanceOf(address tokenOwner) public constant returns (uint balance);
86 
87     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
88 
89     function transfer(address to, uint tokens) public returns (bool success);
90 
91     function approve(address spender, uint tokens) public returns (bool success);
92 
93     function transferFrom(address from, address to, uint tokens) public returns (bool success);
94 
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
105 
106 
107 // ----------------------------------------------------------------------------
108 
109 // Contract function to receive approval and execute function in one call
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
120 // ----------------------------------------------------------------------------
121 
122 // Owned contract
123 
124 // ----------------------------------------------------------------------------
125 
126 contract Owned {
127 
128     address public owner;
129 
130     address public newOwner;
131 
132 
133 
134     event OwnershipTransferred(address indexed _from, address indexed _to);
135 
136 
137 
138     function Owned() public {
139 
140         owner = msg.sender;
141 
142     }
143 
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
155 
156     function transferOwnership(address _newOwner) public onlyOwner {
157 
158         newOwner = _newOwner;
159 
160     }
161 
162     function acceptOwnership() public {
163 
164         require(msg.sender == newOwner);
165 
166         OwnershipTransferred(owner, newOwner);
167 
168         owner = newOwner;
169 
170         newOwner = address(0);
171 
172     }
173 
174 }
175 
176 // ----------------------------------------------------------------------------
177 
178 // ERC20 Token, with the addition of symbol, name and decimals and assisted
179 
180 // token transfers
181 
182 // ----------------------------------------------------------------------------
183 
184 contract PakGoldCoin is ERC20Interface, Owned, SafeMath {
185 
186     string public symbol;
187 
188     string public  name;
189 
190     uint8 public decimals;
191 
192     uint public _totalSupply;
193 
194 
195 
196     mapping(address => uint) balances;
197 
198     mapping(address => mapping(address => uint)) allowed;
199 
200     // ------------------------------------------------------------------------
201 
202     // Constructor
203 
204     // ------------------------------------------------------------------------
205 
206     function PakGoldCoin() public {
207 
208         symbol = "PGC";
209 
210         name = "PakGoldCoin";
211 
212         decimals = 18;
213 
214         _totalSupply = 1000000000000000000000000000;
215 
216         balances[0x362Eae330a1D84f565FCd8Fa0F9C7c1e40e8F202] = _totalSupply;
217 
218         Transfer(address(0), 0x362Eae330a1D84f565FCd8Fa0F9C7c1e40e8F202, _totalSupply);
219 
220     }
221 
222    // ------------------------------------------------------------------------
223 
224     // Total supply
225 
226     // ------------------------------------------------------------------------
227 
228     function totalSupply() public constant returns (uint) {
229 
230         return _totalSupply  - balances[address(0)];
231 
232     }
233 
234   // ------------------------------------------------------------------------
235 
236     // Get the token balance for account tokenOwner
237 
238     // ------------------------------------------------------------------------
239 
240     function balanceOf(address tokenOwner) public constant returns (uint balance) {
241 
242         return balances[tokenOwner];
243 
244     }
245 
246     // ------------------------------------------------------------------------
247 
248     // Transfer the balance from token owner's account to to account
249 
250     // - Owner's account must have sufficient balance to transfer
251 
252     // - 0 value transfers are allowed
253 
254     // ------------------------------------------------------------------------
255 
256     function transfer(address to, uint tokens) public returns (bool success) {
257 
258         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
259 
260         balances[to] = safeAdd(balances[to], tokens);
261 
262         Transfer(msg.sender, to, tokens);
263 
264         return true;
265 
266     }
267 
268     // ------------------------------------------------------------------------
269 
270     // Token owner can approve for spender to transferFrom(...) tokens
271 
272     // from the token owner's account
273 
274     // recommends that there are no checks for the approval double-spend attack
275 
276     // as this should be implemented in user interfaces 
277 
278     // ------------------------------------------------------------------------
279 
280     function approve(address spender, uint tokens) public returns (bool success) {
281 
282         allowed[msg.sender][spender] = tokens;
283 
284         Approval(msg.sender, spender, tokens);
285 
286         return true;
287 
288     }
289 
290     // ------------------------------------------------------------------------
291 
292     // Transfer tokens from the from account to the to account
293 
294     // The calling account must already have sufficient tokens approve(...)-d
295 
296     // for spending from the from account and
297 
298     // - From account must have sufficient balance to transfer
299 
300     // - Spender must have sufficient allowance to transfer
301 
302     // - 0 value transfers are allowed
303 
304     // ------------------------------------------------------------------------
305 
306     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
307 
308         balances[from] = safeSub(balances[from], tokens);
309 
310         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
311 
312         balances[to] = safeAdd(balances[to], tokens);
313 
314         Transfer(from, to, tokens);
315 
316         return true;
317 
318     }
319 
320    // ------------------------------------------------------------------------
321 
322     // Returns the amount of tokens approved by the owner that can be
323 
324     // transferred to the spender's account
325 
326     // ------------------------------------------------------------------------
327 
328     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
329 
330         return allowed[tokenOwner][spender];
331 
332     }
333 
334     // ------------------------------------------------------------------------
335 
336     // Token owner can approve for spender to transferFrom(...) tokens
337 
338     // from the token owner's account. The spender contract function
339 
340     // receiveApproval(...) is then executed
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
356     // ------------------------------------------------------------------------
357 
358     // Don't accept ETH
359 
360     // ------------------------------------------------------------------------
361 
362     function () public payable {
363 
364         revert();
365 
366     }
367 
368     // ------------------------------------------------------------------------
369 
370     // Owner can transfer out any accidentally sent ERC20 tokens
371 
372     // ------------------------------------------------------------------------
373 
374     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
375 
376         return ERC20Interface(tokenAddress).transfer(owner, tokens);
377 
378     }
379 
380 }