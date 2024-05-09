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
80 // Owned contract
81 
82 // ----------------------------------------------------------------------------
83 
84 contract Owned {
85 
86     address public owner;
87 
88     constructor() public {
89 
90         owner = msg.sender;
91 
92     }
93 
94 
95     modifier onlyOwner {
96 
97         require(msg.sender == owner);
98 
99         _;
100 
101     }
102 
103 }
104 
105 
106 
107 // ----------------------------------------------------------------------------
108 
109 // ERC20 Token, with the addition of symbol, name and decimals and an
110 
111 // initial fixed supply
112 
113 // ----------------------------------------------------------------------------
114 
115 contract CryptoValleyAlliance is ERC20Interface, Owned {
116 
117     using SafeMath for uint;
118 
119 
120     string public symbol;
121 
122     string public  name;
123 
124     uint8 public decimals;
125 
126     uint public _totalSupply;
127     
128     mapping(address => uint) balances;
129 
130     mapping(address => mapping(address => uint)) allowed;
131 
132     bool public frozen = false;
133 
134     // ------------------------------------------------------------------------
135 
136     // Constructor
137 
138     // ------------------------------------------------------------------------
139 
140     constructor() public {
141 
142         symbol = "CVA";
143 
144         name = "Crypto Valley Alliance";
145 
146         decimals = 9;
147 
148         _totalSupply = 50000000 * 10**uint(decimals);
149 
150         balances[owner] = _totalSupply;
151 
152         emit Transfer(address(0), owner, _totalSupply);
153 
154     }
155 
156     function freeze() onlyOwner public{
157         frozen = true;
158     }
159 
160     function unfreeze() onlyOwner public{
161         frozen = false;
162     }
163     
164     
165     // ------------------------------------------------------------------------
166 
167     // Total supply
168 
169     // ------------------------------------------------------------------------
170 
171     function totalSupply() public constant returns (uint) {
172 
173         return _totalSupply  - balances[address(0)];
174 
175     }
176 
177 
178 
179     // ------------------------------------------------------------------------
180 
181     // Get the token balance for account `tokenOwner`
182 
183     // ------------------------------------------------------------------------
184 
185     function balanceOf(address tokenOwner) public constant returns (uint balance) {
186 
187         return balances[tokenOwner];
188 
189     }
190 
191 
192 
193     // ------------------------------------------------------------------------
194 
195     // Transfer the balance from token owner's account to `to` account
196 
197     // - Owner's account must have sufficient balance to transfer
198 
199     // - 0 value transfers are allowed
200 
201     // ------------------------------------------------------------------------
202 
203     function transfer(address to, uint tokens) public returns (bool success) {
204 
205         require (!frozen);
206         
207         balances[msg.sender] = balances[msg.sender].sub(tokens);
208 
209         balances[to] = balances[to].add(tokens);
210 
211         emit Transfer(msg.sender, to, tokens);
212 
213         return true;
214 
215     }
216 
217 
218 
219     // ------------------------------------------------------------------------
220 
221     // Token owner can approve for `spender` to transferFrom(...) `tokens`
222 
223     // from the token owner's account
224 
225     //
226 
227     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
228 
229     // recommends that there are no checks for the approval double-spend attack
230 
231     // as this should be implemented in user interfaces 
232 
233     // ------------------------------------------------------------------------
234 
235     function approve(address spender, uint tokens) public returns (bool success) {
236 
237         allowed[msg.sender][spender] = tokens;
238 
239         emit Approval(msg.sender, spender, tokens);
240 
241         return true;
242 
243     }
244 
245 
246 
247     // ------------------------------------------------------------------------
248 
249     // Transfer `tokens` from the `from` account to the `to` account
250 
251     // 
252 
253     // The calling account must already have sufficient tokens approve(...)-d
254 
255     // for spending from the `from` account and
256 
257     // - From account must have sufficient balance to transfer
258 
259     // - Spender must have sufficient allowance to transfer
260 
261     // - 0 value transfers are allowed
262 
263     // ------------------------------------------------------------------------
264 
265     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
266 
267         require (!frozen);
268         
269         balances[from] = balances[from].sub(tokens);
270 
271         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
272 
273         balances[to] = balances[to].add(tokens);
274 
275         emit Transfer(from, to, tokens);
276 
277         return true;
278 
279     }
280 
281 
282 
283     // ------------------------------------------------------------------------
284 
285     // Returns the amount of tokens approved by the owner that can be
286 
287     // transferred to the spender's account
288 
289     // ------------------------------------------------------------------------
290 
291     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
292 
293         return allowed[tokenOwner][spender];
294 
295     }
296 
297     // ------------------------------------------------------------------------
298     // Owner can withdraw ether if token received.
299     // ------------------------------------------------------------------------
300     function withdraw() public onlyOwner returns (bool result) {
301         
302         return owner.send(this.balance);
303         
304     }
305     
306     // ------------------------------------------------------------------------
307 
308     // Owner can transfer out any accidentally sent ERC20 tokens
309 
310     // ------------------------------------------------------------------------
311 
312     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
313 
314         return ERC20Interface(tokenAddress).transfer(owner, tokens);
315 
316     }
317 
318 }