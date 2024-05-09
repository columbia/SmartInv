1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'FIXED' 'Yobit Coin' token contract
7 
8 
9 // Symbol      : FIXED
10 
11 // Name        : Yobit Coin
12 
13 // Total supply: 20,000,00.000000000000000000
14 
15 // Decimals    : 18
16 
17 // ----------------------------------------------------------------------------
18 
19 
20 // ----------------------------------------------------------------------------
21 
22 // Safe maths
23 
24 // ----------------------------------------------------------------------------
25 
26 library SafeMath {
27 
28     function add(uint a, uint b) internal pure returns (uint c) {
29 
30         c = a + b;
31 
32         require(c >= a);
33 
34     }
35 
36     function sub(uint a, uint b) internal pure returns (uint c) {
37 
38         require(b <= a);
39 
40         c = a - b;
41 
42     }
43 
44     function mul(uint a, uint b) internal pure returns (uint c) {
45 
46         c = a * b;
47 
48         require(a == 0 || c / a == b);
49 
50     }
51 
52     function div(uint a, uint b) internal pure returns (uint c) {
53 
54         require(b > 0);
55 
56         c = a / b;
57 
58     }
59 
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 
65 // ERC Token Standard #20 Interface
66 
67 // ----------------------------------------------------------------------------
68 
69 contract ERC20Interface {
70 
71     function totalSupply() public constant returns (uint);
72 
73     function balanceOf(address tokenOwner) public constant returns (uint balance);
74 
75     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
76 
77     function transfer(address to, uint tokens) public returns (bool success);
78 
79     function approve(address spender, uint tokens) public returns (bool success);
80 
81     function transferFrom(address from, address to, uint tokens) public returns (bool success);
82 
83 
84     event Transfer(address indexed from, address indexed to, uint tokens);
85 
86     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
87 
88 }
89 
90 
91 
92 // ----------------------------------------------------------------------------
93 
94 // Contract function to receive approval and execute function in one call
95 
96 // ----------------------------------------------------------------------------
97 
98 contract ApproveAndCallFallBack {
99 
100     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
101 
102 }
103 
104 
105 
106 // ----------------------------------------------------------------------------
107 
108 // Owned contract
109 
110 // ----------------------------------------------------------------------------
111 
112 contract Owned {
113 
114     address public owner;
115 
116     address public newOwner;
117 
118 
119     event OwnershipTransferred(address indexed _from, address indexed _to);
120 
121 
122     function Owned() public {
123 
124         owner = msg.sender;
125 
126     }
127 
128 
129     modifier onlyOwner {
130 
131         require(msg.sender == owner);
132 
133         _;
134 
135     }
136 
137 
138     function transferOwnership(address _newOwner) public onlyOwner {
139 
140         newOwner = _newOwner;
141 
142     }
143 
144     function acceptOwnership() public {
145 
146         require(msg.sender == newOwner);
147 
148         OwnershipTransferred(owner, newOwner);
149 
150         owner = newOwner;
151 
152         newOwner = address(0);
153 
154     }
155 
156 }
157 
158 
159 
160 // ----------------------------------------------------------------------------
161 
162 // ERC20 Token, with the addition of symbol, name and decimals and an initial fixed supply
163 
164 // ----------------------------------------------------------------------------
165 
166 contract YBCLiveToken is ERC20Interface, Owned {
167 
168     using SafeMath for uint;
169 
170 
171     string public symbol;
172 
173     string public  name;
174 
175     uint8 public decimals;
176 
177     uint public _totalSupply;
178 
179 
180     mapping(address => uint) balances;
181 
182     mapping(address => mapping(address => uint)) allowed;
183 
184 
185 
186     // ------------------------------------------------------------------------
187 
188     // Constructor
189 
190     // ------------------------------------------------------------------------
191 
192     function YBCLiveToken() public {
193 
194         symbol = "YBC";
195 
196         name = "Yobit Coin";
197 
198         decimals = 18;
199 
200         _totalSupply = 2000000 * 10**uint(decimals);
201 
202         balances[owner] = _totalSupply;
203 
204         Transfer(address(0), owner, _totalSupply);
205 
206     }
207 
208 
209 
210     // ------------------------------------------------------------------------
211 
212     // Total supply
213 
214     // ------------------------------------------------------------------------
215 
216     function totalSupply() public constant returns (uint) {
217 
218         return _totalSupply  - balances[address(0)];
219 
220     }
221 
222 
223 
224     // ------------------------------------------------------------------------
225 
226     // Get the token balance for account `tokenOwner`
227 
228     // ------------------------------------------------------------------------
229 
230     function balanceOf(address tokenOwner) public constant returns (uint balance) {
231 
232         return balances[tokenOwner];
233 
234     }
235 
236 
237 
238     // ------------------------------------------------------------------------
239 
240     // Transfer the balance from token owner's account to `to` account
241 
242     // - Owner's account must have sufficient balance to transfer
243 
244     // - 0 value transfers are allowed
245 
246     // ------------------------------------------------------------------------
247 
248     function transfer(address to, uint tokens) public returns (bool success) {
249 
250         balances[msg.sender] = balances[msg.sender].sub(tokens);
251 
252         balances[to] = balances[to].add(tokens);
253 
254         Transfer(msg.sender, to, tokens);
255 
256         return true;
257 
258     }
259 
260 
261 
262     // ------------------------------------------------------------------------
263 
264     // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account
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
284     // ------------------------------------------------------------------------
285 
286     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
287 
288         balances[from] = balances[from].sub(tokens);
289 
290         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
291 
292         balances[to] = balances[to].add(tokens);
293 
294         Transfer(from, to, tokens);
295 
296         return true;
297 
298     }
299 
300 
301 
302     // ------------------------------------------------------------------------
303 
304     // Returns the amount of tokens approved by the owner that can be transferred to the spender's account
305 
306     // ------------------------------------------------------------------------
307 
308     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
309 
310         return allowed[tokenOwner][spender];
311 
312     }
313 
314 
315     // ------------------------------------------------------------------------
316 
317     // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account. The `spender` contract function
318 
319     // ------------------------------------------------------------------------
320 
321     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
322 
323         allowed[msg.sender][spender] = tokens;
324 
325         Approval(msg.sender, spender, tokens);
326 
327         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
328 
329         return true;
330 
331     }
332 
333 
334     // ------------------------------------------------------------------------
335 
336     // Don't accept ETH
337 
338     // ------------------------------------------------------------------------
339 
340     function () public payable {
341 
342         revert();
343 
344     }
345 
346 
347     // ------------------------------------------------------------------------
348 
349     // Owner can transfer out any accidentally sent ERC20 tokens
350 
351     // ------------------------------------------------------------------------
352 
353     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
354 
355         return ERC20Interface(tokenAddress).transfer(owner, tokens);
356 
357     }
358 
359 }