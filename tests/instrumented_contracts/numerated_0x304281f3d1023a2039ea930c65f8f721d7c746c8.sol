1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 // The AXNET Token is the native currency for the AXNET Ecosystem of products
6 // AXN is a Utility Token and is being distributed AS-IS
7 // Visit https://ax.net/token-terms/ for full details. Thank you
8 //
9 //
10 // AXNET Token Contract
11 //
12 // Symbol      : AXN
13 // Name        : AXNET
14 // Total supply: 1,000,000,000.000000000000000000
15 // Decimals    : 18
16 // Website     : https://ax.net
17 // Company     : Asset Exchange Network (AXNET OÜ)
18 //
19 // ----------------------------------------------------------------------------
20 
21 
22 
23 // ----------------------------------------------------------------------------
24 
25 // Safe maths
26 
27 // ----------------------------------------------------------------------------
28 
29 library SafeMath {
30 
31     function add(uint a, uint b) internal pure returns (uint c) {
32 
33         c = a + b;
34 
35         require(c >= a);
36 
37     }
38 
39     function sub(uint a, uint b) internal pure returns (uint c) {
40 
41         require(b <= a);
42 
43         c = a - b;
44 
45     }
46 
47     function mul(uint a, uint b) internal pure returns (uint c) {
48 
49         c = a * b;
50 
51         require(a == 0 || c / a == b);
52 
53     }
54 
55     function div(uint a, uint b) internal pure returns (uint c) {
56 
57         require(b > 0);
58 
59         c = a / b;
60 
61     }
62 
63 }
64 
65 
66 
67 // ----------------------------------------------------------------------------
68 
69 // ERC Token Standard #20 Interface
70 
71 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
72 
73 // ----------------------------------------------------------------------------
74 
75 contract ERC20Interface {
76 
77     function totalSupply() public constant returns (uint);
78 
79     function balanceOf(address tokenOwner) public constant returns (uint balance);
80 
81     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
82 
83     function transfer(address to, uint tokens) public returns (bool success);
84 
85     function approve(address spender, uint tokens) public returns (bool success);
86 
87     function transferFrom(address from, address to, uint tokens) public returns (bool success);
88 
89 
90     event Transfer(address indexed from, address indexed to, uint tokens);
91 
92     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
93 
94 }
95 
96 
97 
98 // ----------------------------------------------------------------------------
99 
100 // Owned contract
101 
102 // ----------------------------------------------------------------------------
103 
104 contract Owned {
105 
106     address public owner;
107 
108     function Owned() public {
109 
110         owner = msg.sender;
111 
112     }
113 
114 
115     modifier onlyOwner {
116 
117         require(msg.sender == owner);
118 
119         _;
120 
121     }
122 
123 }
124 
125 
126 
127 // ----------------------------------------------------------------------------
128 
129 // ERC20 Token, with the addition of symbol, name and decimals and an
130 
131 // initial fixed supply
132 
133 // ----------------------------------------------------------------------------
134 
135 contract AXNETToken is ERC20Interface, Owned {
136 
137     using SafeMath for uint;
138 
139 
140     string public symbol;
141 
142     string public  name;
143 
144     uint8 public decimals;
145 
146     uint public _totalSupply;
147 
148 
149     mapping(address => uint) balances;
150 
151     mapping(address => mapping(address => uint)) allowed;
152 
153 
154 
155     // ------------------------------------------------------------------------
156 
157     // Constructor
158 
159     // ------------------------------------------------------------------------
160 
161     function AXNETToken() public {
162 
163         symbol = "AXN";
164 
165         name = "AXNET";
166 
167         decimals = 18;
168 
169         _totalSupply = 1000000000 * 10**uint(decimals);
170 
171         balances[owner] = _totalSupply;
172 
173         Transfer(address(0), owner, _totalSupply);
174 
175     }
176 
177 
178 
179     // ------------------------------------------------------------------------
180 
181     // Total supply
182 
183     // ------------------------------------------------------------------------
184 
185     function totalSupply() public constant returns (uint) {
186 
187         return _totalSupply  - balances[address(0)];
188 
189     }
190 
191 
192 
193     // ------------------------------------------------------------------------
194 
195     // Get the token balance for account `tokenOwner`
196 
197     // ------------------------------------------------------------------------
198 
199     function balanceOf(address tokenOwner) public constant returns (uint balance) {
200 
201         return balances[tokenOwner];
202 
203     }
204 
205 
206 
207     // ------------------------------------------------------------------------
208 
209     // Transfer the balance from token owner's account to `to` account
210 
211     // - Owner's account must have sufficient balance to transfer
212 
213     // - 0 value transfers are allowed
214 
215     // ------------------------------------------------------------------------
216 
217     function transfer(address to, uint tokens) public returns (bool success) {
218 
219         balances[msg.sender] = balances[msg.sender].sub(tokens);
220 
221         balances[to] = balances[to].add(tokens);
222 
223         Transfer(msg.sender, to, tokens);
224 
225         return true;
226 
227     }
228 
229 
230 
231     // ------------------------------------------------------------------------
232 
233     // Token owner can approve for `spender` to transferFrom(...) `tokens`
234 
235     // from the token owner's account
236 
237     //
238 
239     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
240 
241     // recommends that there are no checks for the approval double-spend attack
242 
243     // as this should be implemented in user interfaces 
244 
245     // ------------------------------------------------------------------------
246 
247     function approve(address spender, uint tokens) public returns (bool success) {
248 
249         allowed[msg.sender][spender] = tokens;
250 
251         Approval(msg.sender, spender, tokens);
252 
253         return true;
254 
255     }
256 
257 
258 
259     // ------------------------------------------------------------------------
260 
261     // Transfer `tokens` from the `from` account to the `to` account
262 
263     // 
264 
265     // The calling account must already have sufficient tokens approve(...)-d
266 
267     // for spending from the `from` account and
268 
269     // - From account must have sufficient balance to transfer
270 
271     // - Spender must have sufficient allowance to transfer
272 
273     // - 0 value transfers are allowed
274 
275     // ------------------------------------------------------------------------
276 
277     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
278 
279         balances[from] = balances[from].sub(tokens);
280 
281         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
282 
283         balances[to] = balances[to].add(tokens);
284 
285         Transfer(from, to, tokens);
286 
287         return true;
288 
289     }
290 
291 
292 
293     // ------------------------------------------------------------------------
294 
295     // Returns the amount of tokens approved by the owner that can be
296 
297     // transferred to the spender's account
298 
299     // ------------------------------------------------------------------------
300 
301     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
302 
303         return allowed[tokenOwner][spender];
304 
305     }
306 
307 
308     // ------------------------------------------------------------------------
309 
310     // Do accept ETH
311 
312     // ------------------------------------------------------------------------
313 
314     function () public payable {
315 
316 
317     }
318 
319 
320     // ------------------------------------------------------------------------
321     // Owner can withdraw ether if token received.
322     // ------------------------------------------------------------------------
323     function withdraw() public onlyOwner returns (bool result) {
324         
325         return owner.send(this.balance);
326         
327     }
328     
329     // ------------------------------------------------------------------------
330 
331     // Owner can transfer out any accidentally sent ERC20 tokens
332 
333     // ------------------------------------------------------------------------
334 
335     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
336 
337         return ERC20Interface(tokenAddress).transfer(owner, tokens);
338 
339     }
340 
341 }