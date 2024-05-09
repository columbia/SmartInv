1 library SafeMath {
2 
3     function add(uint a, uint b) internal pure returns (uint c) {
4 
5         c = a + b;
6 
7         require(c >= a);
8 
9     }
10 
11     function sub(uint a, uint b) internal pure returns (uint c) {
12 
13         require(b <= a);
14 
15         c = a - b;
16 
17     }
18 
19     function mul(uint a, uint b) internal pure returns (uint c) {
20 
21         c = a * b;
22 
23         require(a == 0 || c / a == b);
24 
25     }
26 
27     function div(uint a, uint b) internal pure returns (uint c) {
28 
29         require(b > 0);
30 
31         c = a / b;
32 
33     }
34 
35 }
36  
37 contract ERC20Interface {
38 
39     function totalSupply() public constant returns (uint);
40 
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42 
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44 
45     function transfer(address to, uint tokens) public returns (bool success);
46 
47     function approve(address spender, uint tokens) public returns (bool success);
48 
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52 
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 
55 }
56 
57 
58 
59 // ----------------------------------------------------------------------------
60 
61 // Contract function to receive approval and execute function in one call
62 
63 //
64 
65 // Borrowed from MiniMeToken
66 
67 // ----------------------------------------------------------------------------
68 
69 contract ApproveAndCallFallBack {
70 
71     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
72 
73 }
74 
75 
76 
77 // ----------------------------------------------------------------------------
78 
79 // Owned contract
80 
81 // ----------------------------------------------------------------------------
82 
83 contract Owned {
84 
85     address public owner;
86 
87     address public newOwner;
88 
89 
90     event OwnershipTransferred(address indexed _from, address indexed _to);
91 
92 
93     constructor() public {
94 
95         owner = msg.sender;
96 
97     }
98 
99 
100     modifier onlyOwner {
101 
102         require(msg.sender == owner);
103 
104         _;
105 
106     }
107 
108 
109     function transferOwnership(address _newOwner) public onlyOwner {
110 
111         newOwner = _newOwner;
112 
113     }
114 
115     function acceptOwnership() public {
116 
117         require(msg.sender == newOwner);
118 
119         emit OwnershipTransferred(owner, newOwner);
120 
121         owner = newOwner;
122 
123         newOwner = address(0);
124  
125     }
126 
127 }
128 
129 
130  
131 // ----------------------------------------------------------------------------
132 
133 // ERC20 Token, with the addition of symbol, name and decimals and a
134 
135 // fixed supply
136 
137 // ----------------------------------------------------------------------------
138 
139 contract TDCToken is ERC20Interface, Owned {
140 
141     using SafeMath for uint;
142 
143 
144     string public symbol;
145 
146     string public  name;
147 
148     uint8 public decimals;
149 
150     uint _totalSupply;
151 
152 
153     mapping(address => uint) balances;
154 
155     mapping(address => mapping(address => uint)) allowed;
156 
157 
158 
159     // ------------------------------------------------------------------------
160 
161     // Constructor
162 
163     // ------------------------------------------------------------------------
164 
165     constructor() public {
166 
167         symbol = "TDC"; 
168 
169         name = "TRUSTDEX TOKEN";
170 
171         decimals = 0;
172   
173         _totalSupply = 150000000 * 10**uint(decimals);
174 
175         balances[owner] = _totalSupply;
176 
177         emit Transfer(address(0), owner, _totalSupply);
178 
179     }
180 
181 
182 
183     // ------------------------------------------------------------------------
184 
185     // Total supply
186 
187     // ------------------------------------------------------------------------
188 
189     function totalSupply() public view returns (uint) {
190 
191         return _totalSupply.sub(balances[address(0)]);
192 
193     }
194 
195 
196 
197     // ------------------------------------------------------------------------
198 
199     // Get the token balance for account `tokenOwner`
200 
201     // ------------------------------------------------------------------------
202 
203     function balanceOf(address tokenOwner) public view returns (uint balance) {
204 
205         return balances[tokenOwner];
206 
207     }
208 
209 
210 
211     // ------------------------------------------------------------------------
212 
213     // Transfer the balance from token owner's account to `to` account
214 
215     // - Owner's account must have sufficient balance to transfer
216 
217     // - 0 value transfers are allowed
218 
219     // ------------------------------------------------------------------------
220 
221     function transfer(address to, uint tokens) public returns (bool success) {
222 
223         balances[msg.sender] = balances[msg.sender].sub(tokens);
224 
225         balances[to] = balances[to].add(tokens);
226 
227         emit Transfer(msg.sender, to, tokens);
228 
229         return true;
230 
231     }
232 
233 
234 
235     // ------------------------------------------------------------------------
236 
237     // Token owner can approve for `spender` to transferFrom(...) `tokens`
238 
239     // from the token owner's account
240 
241     //
242 
243     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
244 
245     // recommends that there are no checks for the approval double-spend attack
246 
247     // as this should be implemented in user interfaces 
248 
249     // ------------------------------------------------------------------------
250 
251     function approve(address spender, uint tokens) public returns (bool success) {
252 
253         allowed[msg.sender][spender] = tokens;
254 
255         emit Approval(msg.sender, spender, tokens);
256 
257         return true;
258 
259     }
260 
261 
262 
263     // ------------------------------------------------------------------------
264 
265     // Transfer `tokens` from the `from` account to the `to` account
266 
267     // 
268 
269     // The calling account must already have sufficient tokens approve(...)-d
270 
271     // for spending from the `from` account and
272 
273     // - From account must have sufficient balance to transfer
274 
275     // - Spender must have sufficient allowance to transfer
276 
277     // - 0 value transfers are allowed
278 
279     // ------------------------------------------------------------------------
280 
281     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
282 
283         balances[from] = balances[from].sub(tokens);
284 
285         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
286 
287         balances[to] = balances[to].add(tokens);
288 
289         emit Transfer(from, to, tokens);
290 
291         return true;
292 
293     }
294 
295 
296 
297     // ------------------------------------------------------------------------
298 
299     // Returns the amount of tokens approved by the owner that can be
300 
301     // transferred to the spender's account
302 
303     // ------------------------------------------------------------------------
304 
305     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
306 
307         return allowed[tokenOwner][spender];
308 
309     }
310 
311 
312 
313     // ------------------------------------------------------------------------
314 
315     // Token owner can approve for `spender` to transferFrom(...) `tokens`
316 
317     // from the token owner's account. The `spender` contract function
318 
319     // `receiveApproval(...)` is then executed
320 
321     // ------------------------------------------------------------------------
322 
323     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
324 
325         allowed[msg.sender][spender] = tokens;
326 
327         emit Approval(msg.sender, spender, tokens);
328 
329         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
330 
331         return true;
332 
333     }
334 
335 
336 
337     // ------------------------------------------------------------------------
338 
339     // Don't accept ETH
340 
341     // ------------------------------------------------------------------------
342 
343     function () public payable {
344 
345         revert();
346 
347     }
348  
349 
350 
351     // ------------------------------------------------------------------------
352 
353     // Owner can transfer out any accidentally sent ERC20 tokens
354 
355     // ------------------------------------------------------------------------
356 
357     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
358 
359         return ERC20Interface(tokenAddress).transfer(owner, tokens);
360 
361     }
362 
363 }