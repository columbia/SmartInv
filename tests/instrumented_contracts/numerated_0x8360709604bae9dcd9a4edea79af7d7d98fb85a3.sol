1 pragma solidity ^0.4.24;
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
183 
184     function ERC20Token() public {
185         name = "BOHUTOKEN";
186         symbol = "BHT(BOHU)";
187 
188         decimals = 18;
189 
190         _totalSupply = 4500000000 * 10**uint(decimals);
191 
192         balances[owner] = _totalSupply;
193 
194         Transfer(address(0), owner, _totalSupply);
195 
196     }
197 
198 
199 
200     // ------------------------------------------------------------------------
201 
202     // Total supply
203 
204     // ------------------------------------------------------------------------
205 
206     function totalSupply() public constant returns (uint) {
207 
208         return _totalSupply  - balances[address(0)];
209 
210     }
211 
212 
213 
214     // ------------------------------------------------------------------------
215 
216     // Get the token balance for account `tokenOwner`
217 
218     // ------------------------------------------------------------------------
219 
220     function balanceOf(address tokenOwner) public constant returns (uint balance) {
221 
222         return balances[tokenOwner];
223 
224     }
225 
226 
227 
228     // ------------------------------------------------------------------------
229 
230     // Transfer the balance from token owner's account to `to` account
231 
232     // - Owner's account must have sufficient balance to transfer
233 
234     // - 0 value transfers are allowed
235 
236     // ------------------------------------------------------------------------
237 
238     function transfer(address to, uint tokens) public returns (bool success) {
239 
240         balances[msg.sender] = balances[msg.sender].sub(tokens);
241 
242         balances[to] = balances[to].add(tokens);
243 
244         Transfer(msg.sender, to, tokens);
245 
246         return true;
247 
248     }
249 
250 
251 
252     // ------------------------------------------------------------------------
253 
254     // Token owner can approve for `spender` to transferFrom(...) `tokens`
255 
256     // from the token owner's account
257 
258     //
259 
260     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
261 
262     // recommends that there are no checks for the approval double-spend attack
263 
264     // as this should be implemented in user interfaces 
265 
266     // ------------------------------------------------------------------------
267 
268     function approve(address spender, uint tokens) public returns (bool success) {
269 
270         allowed[msg.sender][spender] = tokens;
271 
272         Approval(msg.sender, spender, tokens);
273 
274         return true;
275 
276     }
277 
278 
279 
280     // ------------------------------------------------------------------------
281 
282     // Transfer `tokens` from the `from` account to the `to` account
283 
284     // 
285 
286     // The calling account must already have sufficient tokens approve(...)-d
287 
288     // for spending from the `from` account and
289 
290     // - From account must have sufficient balance to transfer
291 
292     // - Spender must have sufficient allowance to transfer
293 
294     // - 0 value transfers are allowed
295 
296     // ------------------------------------------------------------------------
297 
298     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
299 
300         balances[from] = balances[from].sub(tokens);
301 
302         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
303 
304         balances[to] = balances[to].add(tokens);
305 
306         Transfer(from, to, tokens);
307 
308         return true;
309 
310     }
311 
312 
313 
314     // ------------------------------------------------------------------------
315 
316     // Returns the amount of tokens approved by the owner that can be
317 
318     // transferred to the spender's account
319 
320     // ------------------------------------------------------------------------
321 
322     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
323 
324         return allowed[tokenOwner][spender];
325 
326     }
327 
328 
329 
330     // ------------------------------------------------------------------------
331 
332     // Token owner can approve for `spender` to transferFrom(...) `tokens`
333 
334     // from the token owner's account. The `spender` contract function
335 
336     // `receiveApproval(...)` is then executed
337 
338     // ------------------------------------------------------------------------
339 
340     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
341 
342         allowed[msg.sender][spender] = tokens;
343 
344         Approval(msg.sender, spender, tokens);
345 
346         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
347 
348         return true;
349 
350     }
351 
352 
353 
354     // ------------------------------------------------------------------------
355 
356     // Don't accept ETH
357 
358     // ------------------------------------------------------------------------
359 
360     function () public payable {
361 
362         revert();
363 
364     }
365 
366 
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