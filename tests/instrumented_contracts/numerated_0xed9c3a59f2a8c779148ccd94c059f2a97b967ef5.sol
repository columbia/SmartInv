1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'XSD' 'Spend' token contract
7 //
8 // Developer Genji Sakamoto
9 //
10 // Symbol      : XSD
11 // Name        : SpendCoin
12 // Total supply: 10,000,000,000.000000000000000000
13 // Decimals    : 18
14 // ----------------------------------------------------------------------------
15 
16 
17 
18 // ----------------------------------------------------------------------------
19 
20 // Safe maths
21 
22 // ----------------------------------------------------------------------------
23 
24 library SafeMath {
25 
26     function add(uint a, uint b) internal pure returns (uint c) {
27 
28         c = a + b;
29 
30         require(c >= a);
31 
32     }
33 
34     function sub(uint a, uint b) internal pure returns (uint c) {
35 
36         require(b <= a);
37 
38         c = a - b;
39 
40     }
41 
42     function mul(uint a, uint b) internal pure returns (uint c) {
43 
44         c = a * b;
45 
46         require(a == 0 || c / a == b);
47 
48     }
49 
50     function div(uint a, uint b) internal pure returns (uint c) {
51 
52         require(b > 0);
53 
54         c = a / b;
55 
56     }
57 
58 }
59 
60 
61 
62 // ----------------------------------------------------------------------------
63 
64 // ERC Token Standard #20 Interface
65 
66 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
67 
68 // ----------------------------------------------------------------------------
69 
70 contract ERC20Interface {
71 
72     function totalSupply() public constant returns (uint);
73 
74     function balanceOf(address tokenOwner) public constant returns (uint balance);
75 
76     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
77 
78     function transfer(address to, uint tokens) public returns (bool success);
79 
80     function approve(address spender, uint tokens) public returns (bool success);
81 
82     function transferFrom(address from, address to, uint tokens) public returns (bool success);
83 
84 
85     event Transfer(address indexed from, address indexed to, uint tokens);
86 
87     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
88 
89 }
90 
91 
92 
93 // ----------------------------------------------------------------------------
94 
95 // Owned contract
96 
97 // ----------------------------------------------------------------------------
98 
99 contract Owned {
100 
101     address public owner;
102 
103     function Owned() public {
104 
105         owner = msg.sender;
106 
107     }
108 
109 
110     modifier onlyOwner {
111 
112         require(msg.sender == owner);
113 
114         _;
115 
116     }
117 
118 }
119 
120 
121 
122 // ----------------------------------------------------------------------------
123 
124 // ERC20 Token, with the addition of symbol, name and decimals and an
125 
126 // initial fixed supply
127 
128 // ----------------------------------------------------------------------------
129 
130 contract SpendCoin is ERC20Interface, Owned {
131 
132     using SafeMath for uint;
133 
134 
135     string public symbol;
136 
137     string public  name;
138 
139     uint8 public decimals;
140 
141     uint public _totalSupply;
142 
143 
144     mapping(address => uint) balances;
145 
146     mapping(address => mapping(address => uint)) allowed;
147 
148 
149 
150     // ------------------------------------------------------------------------
151 
152     // Constructor
153 
154     // ------------------------------------------------------------------------
155 
156     function SpendCoin() public {
157 
158         symbol = "XSD";
159 
160         name = "SpendCoin";
161 
162         decimals = 18;
163 
164         _totalSupply = 10000000000 * 10**uint(decimals);
165 
166         balances[owner] = _totalSupply;
167 
168         Transfer(address(0), owner, _totalSupply);
169 
170     }
171 
172 
173 
174     // ------------------------------------------------------------------------
175 
176     // Total supply
177 
178     // ------------------------------------------------------------------------
179 
180     function totalSupply() public constant returns (uint) {
181 
182         return _totalSupply  - balances[address(0)];
183 
184     }
185 
186 
187 
188     // ------------------------------------------------------------------------
189 
190     // Get the token balance for account `tokenOwner`
191 
192     // ------------------------------------------------------------------------
193 
194     function balanceOf(address tokenOwner) public constant returns (uint balance) {
195 
196         return balances[tokenOwner];
197 
198     }
199 
200 
201 
202     // ------------------------------------------------------------------------
203 
204     // Transfer the balance from token owner's account to `to` account
205 
206     // - Owner's account must have sufficient balance to transfer
207 
208     // - 0 value transfers are allowed
209 
210     // ------------------------------------------------------------------------
211 
212     function transfer(address to, uint tokens) public returns (bool success) {
213 
214         balances[msg.sender] = balances[msg.sender].sub(tokens);
215 
216         balances[to] = balances[to].add(tokens);
217 
218         Transfer(msg.sender, to, tokens);
219 
220         return true;
221 
222     }
223 
224 
225 
226     // ------------------------------------------------------------------------
227 
228     // Token owner can approve for `spender` to transferFrom(...) `tokens`
229 
230     // from the token owner's account
231 
232     //
233 
234     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
235 
236     // recommends that there are no checks for the approval double-spend attack
237 
238     // as this should be implemented in user interfaces 
239 
240     // ------------------------------------------------------------------------
241 
242     function approve(address spender, uint tokens) public returns (bool success) {
243 
244         allowed[msg.sender][spender] = tokens;
245 
246         Approval(msg.sender, spender, tokens);
247 
248         return true;
249 
250     }
251 
252 
253 
254     // ------------------------------------------------------------------------
255 
256     // Transfer `tokens` from the `from` account to the `to` account
257 
258     // 
259 
260     // The calling account must already have sufficient tokens approve(...)-d
261 
262     // for spending from the `from` account and
263 
264     // - From account must have sufficient balance to transfer
265 
266     // - Spender must have sufficient allowance to transfer
267 
268     // - 0 value transfers are allowed
269 
270     // ------------------------------------------------------------------------
271 
272     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
273 
274         balances[from] = balances[from].sub(tokens);
275 
276         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
277 
278         balances[to] = balances[to].add(tokens);
279 
280         Transfer(from, to, tokens);
281 
282         return true;
283 
284     }
285 
286 
287 
288     // ------------------------------------------------------------------------
289 
290     // Returns the amount of tokens approved by the owner that can be
291 
292     // transferred to the spender's account
293 
294     // ------------------------------------------------------------------------
295 
296     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
297 
298         return allowed[tokenOwner][spender];
299 
300     }
301 
302 
303     // ------------------------------------------------------------------------
304 
305     // Do accept ETH
306 
307     // ------------------------------------------------------------------------
308 
309     function () public payable {
310 
311 
312     }
313 
314 
315     // ------------------------------------------------------------------------
316     // Owner can withdraw ether if token received.
317     // ------------------------------------------------------------------------
318     function withdraw() public onlyOwner returns (bool result) {
319         
320         return owner.send(this.balance);
321         
322     }
323     
324     // ------------------------------------------------------------------------
325 
326     // Owner can transfer out any accidentally sent ERC20 tokens
327 
328     // ------------------------------------------------------------------------
329 
330     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
331 
332         return ERC20Interface(tokenAddress).transfer(owner, tokens);
333 
334     }
335 
336 }