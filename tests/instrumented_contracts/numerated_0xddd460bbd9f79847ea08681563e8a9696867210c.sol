1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // Spendcoin Contract
7 //
8 // Symbol      : SPND
9 // Name        : Spendcoin
10 // Total supply: 2,000,000,000.000000000000000000
11 // Decimals    : 18
12 // Website     : https://spendcoin.org
13 // ----------------------------------------------------------------------------
14 
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
94 // Owned contract
95 
96 // ----------------------------------------------------------------------------
97 
98 contract Owned {
99 
100     address public owner;
101 
102     function Owned() public {
103 
104         owner = msg.sender;
105 
106     }
107 
108 
109     modifier onlyOwner {
110 
111         require(msg.sender == owner);
112 
113         _;
114 
115     }
116 
117 }
118 
119 contract Tokenlock is Owned {
120     
121     uint lockStartTime = 0;   //time from when token will be locked
122     uint lockEndTime = 0;     //time from when token will be locked
123     uint8 isLocked = 0;       //flag indicates if token is locked
124 
125     event Freezed(uint starttime, uint endtime);
126     event UnFreezed();
127 
128     modifier validLock {
129         require(isLocked == 0 || (now < lockStartTime || now > lockEndTime));
130         _;
131     }
132     
133     function freezeTime(uint _startTime, uint _endTime) public onlyOwner {
134         isLocked = 1;
135         lockStartTime = _startTime;
136         lockEndTime = _endTime;
137         
138         emit Freezed(lockStartTime, lockEndTime);
139     }
140     
141     function freeze() public onlyOwner {
142         isLocked = 1;
143         lockStartTime = 0;
144         lockEndTime = 90000000000;
145         
146         emit Freezed(lockStartTime, lockEndTime);
147     }
148 
149     function unfreeze() public onlyOwner {
150         isLocked = 0;
151         lockStartTime = 0;
152         lockEndTime = 0;
153         
154         emit UnFreezed();
155     }
156 }
157 
158 
159 // ----------------------------------------------------------------------------
160 
161 // ERC20 Token, with the addition of symbol, name and decimals and an
162 
163 // initial fixed supply
164 
165 // ----------------------------------------------------------------------------
166 
167 contract Spendcoin is ERC20Interface, Tokenlock {
168 
169     using SafeMath for uint;
170 
171 
172     string public symbol;
173 
174     string public  name;
175 
176     uint8 public decimals;
177 
178     uint public _totalSupply;
179 
180 
181     mapping(address => uint) balances;
182 
183     mapping(address => mapping(address => uint)) allowed;
184 
185 
186 
187     // ------------------------------------------------------------------------
188 
189     // Constructor
190 
191     // ------------------------------------------------------------------------
192 
193     function Spendcoin() public {
194 
195         symbol = "SPND";
196 
197         name = "Spendcoin";
198 
199         decimals = 18;
200 
201         _totalSupply = 2000000000 * 10**uint(decimals);
202 
203         balances[owner] = _totalSupply;
204 
205         emit Transfer(address(0), owner, _totalSupply);
206 
207     }
208 
209 
210 
211     // ------------------------------------------------------------------------
212 
213     // Total supply
214 
215     // ------------------------------------------------------------------------
216 
217     function totalSupply() public constant returns (uint) {
218 
219         return _totalSupply  - balances[address(0)];
220 
221     }
222 
223 
224 
225     // ------------------------------------------------------------------------
226 
227     // Get the token balance for account `tokenOwner`
228 
229     // ------------------------------------------------------------------------
230 
231     function balanceOf(address tokenOwner) public constant returns (uint balance) {
232 
233         return balances[tokenOwner];
234 
235     }
236 
237 
238 
239     // ------------------------------------------------------------------------
240 
241     // Transfer the balance from token owner's account to `to` account
242 
243     // - Owner's account must have sufficient balance to transfer
244 
245     // - 0 value transfers are allowed
246 
247     // ------------------------------------------------------------------------
248 
249     function transfer(address to, uint tokens) public returns (bool success) {
250 
251         balances[msg.sender] = balances[msg.sender].sub(tokens);
252 
253         balances[to] = balances[to].add(tokens);
254 
255         emit Transfer(msg.sender, to, tokens);
256 
257         return true;
258 
259     }
260 
261 
262 
263     // ------------------------------------------------------------------------
264 
265     // Token owner can approve for `spender` to transferFrom(...) `tokens`
266 
267     // from the token owner's account
268 
269     //
270 
271     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
272 
273     // recommends that there are no checks for the approval double-spend attack
274 
275     // as this should be implemented in user interfaces 
276 
277     // ------------------------------------------------------------------------
278 
279     function approve(address spender, uint tokens) public returns (bool success) {
280 
281         allowed[msg.sender][spender] = tokens;
282 
283         emit Approval(msg.sender, spender, tokens);
284 
285         return true;
286 
287     }
288 
289 
290 
291     // ------------------------------------------------------------------------
292 
293     // Transfer `tokens` from the `from` account to the `to` account
294 
295     // 
296 
297     // The calling account must already have sufficient tokens approve(...)-d
298 
299     // for spending from the `from` account and
300 
301     // - From account must have sufficient balance to transfer
302 
303     // - Spender must have sufficient allowance to transfer
304 
305     // - 0 value transfers are allowed
306 
307     // ------------------------------------------------------------------------
308 
309     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
310 
311         balances[from] = balances[from].sub(tokens);
312 
313         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
314 
315         balances[to] = balances[to].add(tokens);
316 
317         emit Transfer(from, to, tokens);
318 
319         return true;
320 
321     }
322 
323 
324 
325     // ------------------------------------------------------------------------
326 
327     // Returns the amount of tokens approved by the owner that can be
328 
329     // transferred to the spender's account
330 
331     // ------------------------------------------------------------------------
332 
333     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
334 
335         return allowed[tokenOwner][spender];
336 
337     }
338 
339 
340     // ------------------------------------------------------------------------
341 
342     // Do accept ETH
343 
344     // ------------------------------------------------------------------------
345 
346     function () public payable {
347 
348 
349     }
350 
351 
352     // ------------------------------------------------------------------------
353     // Owner can withdraw ether if token received.
354     // ------------------------------------------------------------------------
355     function withdraw() public onlyOwner returns (bool result) {
356         address tokenaddress = this;
357         return owner.send(tokenaddress.balance);
358     }
359     
360     // ------------------------------------------------------------------------
361 
362     // Owner can transfer out any accidentally sent ERC20 tokens
363 
364     // ------------------------------------------------------------------------
365 
366     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
367 
368         return ERC20Interface(tokenAddress).transfer(owner, tokens);
369 
370     }
371 
372 }