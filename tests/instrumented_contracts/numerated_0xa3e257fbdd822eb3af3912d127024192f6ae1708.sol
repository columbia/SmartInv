1 pragma solidity ^0.4.25;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // Symbol      : TBTC
7 
8 // Name        : Tidbit Coin
9 
10 // Total supply: 100,000,000.000000000000000000
11 
12 // Decimals    : 18
13 
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 
19 // Safe maths
20 
21 // ----------------------------------------------------------------------------
22 
23 library SafeMath {
24 
25     function add(uint a, uint b) internal pure returns (uint c) {
26 
27         c = a + b;
28 
29         require(c >= a);
30 
31     }
32 
33     function sub(uint a, uint b) internal pure returns (uint c) {
34 
35         require(b <= a);
36 
37         c = a - b;
38 
39     }
40 
41     function mul(uint a, uint b) internal pure returns (uint c) {
42 
43         c = a * b;
44 
45         require(a == 0 || c / a == b);
46 
47     }
48 
49     function div(uint a, uint b) internal pure returns (uint c) {
50 
51         require(b > 0);
52 
53         c = a / b;
54 
55     }
56 
57 }
58 
59 
60 
61 // ----------------------------------------------------------------------------
62 
63 // ERC Token Standard #20 Interface
64 
65 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
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
104 // ----------------------------------------------------------------------------
105 
106 // Owned contract
107 
108 // ----------------------------------------------------------------------------
109 
110 contract Owned {
111 
112     address public owner;
113 
114     address public newOwner;
115 
116 
117     event OwnershipTransferred(address indexed _from, address indexed _to);
118 
119 
120     function Owned() public {
121 
122         owner = msg.sender;
123 
124     }
125 
126 
127     modifier onlyOwner {
128 
129         require(msg.sender == owner);
130 
131         _;
132 
133     }
134 
135 
136     function transferOwnership(address _newOwner) public onlyOwner {
137 
138         newOwner = _newOwner;
139 
140     }
141 
142     function acceptOwnership() public {
143 
144         require(msg.sender == newOwner);
145 
146         OwnershipTransferred(owner, newOwner);
147 
148         owner = newOwner;
149 
150         newOwner = address(0);
151 
152     }
153 
154 }
155 
156 
157 
158 // ----------------------------------------------------------------------------
159 
160 // ERC20 Token, with the addition of symbol, name and decimals and an
161 
162 // initial fixed supply
163 
164 // ----------------------------------------------------------------------------
165 
166 contract TBTCToken is ERC20Interface, Owned {
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
192     function TBTCToken() public {
193 
194         symbol = "TBTC";
195 
196         name = "Tidbit Coin";
197 
198         decimals = 18;
199 
200         _totalSupply = 100000000 * 10**uint(decimals);
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
242     // ------------------------------------------------------------------------
243 
244     function transfer(address to, uint tokens) public returns (bool success) {
245 
246         balances[msg.sender] = balances[msg.sender].sub(tokens);
247 
248         balances[to] = balances[to].add(tokens);
249 
250         Transfer(msg.sender, to, tokens);
251 
252         return true;
253 
254     }
255 
256 
257 
258     // ------------------------------------------------------------------------
259 
260     // Token owner can approve for `spender` to transferFrom(...) `tokens`
261 
262     // from the token owner's account
263 
264     // ------------------------------------------------------------------------
265 
266     function approve(address spender, uint tokens) public returns (bool success) {
267 
268         allowed[msg.sender][spender] = tokens;
269 
270         Approval(msg.sender, spender, tokens);
271 
272         return true;
273 
274     }
275 
276 
277 
278     // ------------------------------------------------------------------------
279 
280     // Transfer `tokens` from the `from` account to the `to` account
281 
282     // ------------------------------------------------------------------------
283 
284     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
285 
286         balances[from] = balances[from].sub(tokens);
287 
288         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
289 
290         balances[to] = balances[to].add(tokens);
291 
292         Transfer(from, to, tokens);
293 
294         return true;
295 
296     }
297 
298 
299 
300     // ------------------------------------------------------------------------
301 
302     // Returns the amount of tokens approved by the owner that can be
303 
304     // transferred to the spender's account
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
315 
316     // ------------------------------------------------------------------------
317 
318     // Token owner can approve for `spender` to transferFrom(...) `tokens`
319 
320     // ------------------------------------------------------------------------
321 
322     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
323 
324         allowed[msg.sender][spender] = tokens;
325 
326         Approval(msg.sender, spender, tokens);
327 
328         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
329 
330         return true;
331 
332     }
333 
334 
335 
336     // ------------------------------------------------------------------------
337 
338     // Don't accept ETH
339 
340     // ------------------------------------------------------------------------
341 
342     function () public payable {
343 
344         revert();
345 
346     }
347 
348 
349 
350     // ------------------------------------------------------------------------
351 
352     // Owner can transfer out any accidentally sent ERC20 tokens
353 
354     // ------------------------------------------------------------------------
355 
356     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
357 
358         return ERC20Interface(tokenAddress).transfer(owner, tokens);
359 
360     }
361 
362 }