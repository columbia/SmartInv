1 pragma solidity ^0.4.25;
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
77 // ----------------------------------------------------------------------------
78 
79 // Contract function to receive approval and execute function in one call
80 
81 //
82 
83 // Borrowed from MiniMeToken
84 
85 // ----------------------------------------------------------------------------
86 
87 contract ApproveAndCallFallBack {
88 
89     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
90 
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 
96 // Owned contract
97 
98 // ----------------------------------------------------------------------------
99 
100 contract Owned {
101 
102     address public owner;
103 
104     address public newOwner;
105 
106 
107     event OwnershipTransferred(address indexed _from, address indexed _to);
108 
109 
110     function Owned() public {
111 
112         owner = msg.sender;
113 
114     }
115 
116 
117     modifier onlyOwner {
118 
119         require(msg.sender == owner);
120 
121         _;
122 
123     }
124 
125 
126     function transferOwnership(address _newOwner) public onlyOwner {
127 
128         newOwner = _newOwner;
129 
130     }
131 
132     function acceptOwnership() public {
133 
134         require(msg.sender == newOwner);
135 
136         OwnershipTransferred(owner, newOwner);
137 
138         owner = newOwner;
139 
140         newOwner = address(0);
141 
142     }
143 
144 }
145 
146 
147 
148 // ----------------------------------------------------------------------------
149 
150 // ERC20 Token, with the addition of symbol, name and decimals and an
151 
152 // initial fixed supply
153 
154 // ----------------------------------------------------------------------------
155 
156 contract ERC20Token is ERC20Interface, Owned {
157 
158     using SafeMath for uint;
159 
160 
161     string public symbol;
162 
163     string public  name;
164 
165     uint8 public decimals;
166 
167     uint public _totalSupply;
168 
169 
170     mapping(address => uint) balances;
171 
172     mapping(address => mapping(address => uint)) allowed;
173 
174 
175 
176     // ------------------------------------------------------------------------
177 
178     // Constructor 
179 
180     // ------------------------------------------------------------------------
181 
182     function ERC20Token() public {
183         name = "Net Ren Chain";
184         symbol = "网红链NRC";
185         decimals = 18;
186         _totalSupply = 1000000000 * 10**uint(decimals);
187 
188         balances[owner] = _totalSupply;
189 
190         Transfer(address(0), owner, _totalSupply);
191     }
192 
193 
194 
195     // ------------------------------------------------------------------------
196 
197     // Total supply
198 
199     // ------------------------------------------------------------------------
200 
201     function totalSupply() public constant returns (uint) {
202 
203         return _totalSupply  - balances[address(0)];
204 
205     }
206 
207 
208 
209     // ------------------------------------------------------------------------
210 
211     // Get the token balance for account `tokenOwner`
212 
213     // ------------------------------------------------------------------------
214 
215     function balanceOf(address tokenOwner) public constant returns (uint balance) {
216 
217         return balances[tokenOwner];
218 
219     }
220 
221 
222 
223     // ------------------------------------------------------------------------
224 
225     // Transfer the balance from token owner's account to `to` account
226 
227     // - Owner's account must have sufficient balance to transfer
228 
229     // - 0 value transfers are allowed
230 
231     // ------------------------------------------------------------------------
232 
233     function transfer(address to, uint tokens) public returns (bool success) {
234 
235         balances[msg.sender] = balances[msg.sender].sub(tokens);
236 
237         balances[to] = balances[to].add(tokens);
238 
239         Transfer(msg.sender, to, tokens);
240 
241         return true;
242 
243     }
244 
245 
246 
247     // ------------------------------------------------------------------------
248 
249     // Token owner can approve for `spender` to transferFrom(...) `tokens`
250 
251     // from the token owner's account
252 
253     //
254 
255     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
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
273 
274     // ------------------------------------------------------------------------
275 
276     // Transfer `tokens` from the `from` account to the `to` account
277 
278     // 
279 
280     // The calling account must already have sufficient tokens approve(...)-d
281 
282     // for spending from the `from` account and
283 
284     // - From account must have sufficient balance to transfer
285 
286     // - Spender must have sufficient allowance to transfer
287 
288     // - 0 value transfers are allowed
289 
290     // ------------------------------------------------------------------------
291 
292     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
293 
294         balances[from] = balances[from].sub(tokens);
295 
296         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
297 
298         balances[to] = balances[to].add(tokens);
299 
300         Transfer(from, to, tokens);
301 
302         return true;
303     }
304 
305 
306     // ------------------------------------------------------------------------
307 
308     // Returns the amount of tokens approved by the owner that can be
309 
310     // transferred to the spender's account
311 
312     // ------------------------------------------------------------------------
313 
314     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
315 
316         return allowed[tokenOwner][spender];
317 
318     }
319 
320 
321     // ------------------------------------------------------------------------
322 
323     // Token owner can approve for `spender` to transferFrom(...) `tokens`
324 
325     // from the token owner's account. The `spender` contract function
326 
327     // `receiveApproval(...)` is then executed
328 
329     // ------------------------------------------------------------------------
330 
331     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
332 
333         allowed[msg.sender][spender] = tokens;
334 
335         Approval(msg.sender, spender, tokens);
336 
337         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
338 
339         return true;
340     }
341 
342 
343     // ------------------------------------------------------------------------
344 
345     // Don't accept ETH
346 
347     // ------------------------------------------------------------------------
348 
349     function () public payable {
350 
351         revert();
352     }
353 
354 
355     // ------------------------------------------------------------------------
356 
357     // Owner can transfer out any accidentally sent ERC20 tokens
358 
359     // ------------------------------------------------------------------------
360 
361     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
362 
363         return ERC20Interface(tokenAddress).transfer(owner, tokens);
364 
365     }
366 }