1 pragma solidity ^0.4.24;
2 
3  
4 library SafeMath {
5 
6     function add(uint a, uint b) internal pure returns (uint c) {
7 
8         c = a + b;
9 
10         require(c >= a);
11 
12     }
13 
14     function sub(uint a, uint b) internal pure returns (uint c) {
15 
16         require(b <= a);
17 
18         c = a - b;
19 
20     }
21 
22     function mul(uint a, uint b) internal pure returns (uint c) {
23 
24         c = a * b;
25 
26         require(a == 0 || c / a == b);
27 
28     }
29 
30     function div(uint a, uint b) internal pure returns (uint c) {
31 
32         require(b > 0);
33 
34         c = a / b;
35 
36     }
37 
38 }
39  
40 contract ERC20Interface {
41 
42     function totalSupply() public constant returns (uint);
43 
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45 
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47 
48     function transfer(address to, uint tokens) public returns (bool success);
49 
50     function approve(address spender, uint tokens) public returns (bool success);
51 
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55 
56     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
57 
58 }
59 
60 
61 
62 // ----------------------------------------------------------------------------
63 
64 // Contract function to receive approval and execute function in one call
65 
66 //
67 
68 // Borrowed from MiniMeToken
69 
70 // ----------------------------------------------------------------------------
71 
72 contract ApproveAndCallFallBack {
73 
74     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
75 
76 }
77 
78 
79 
80 // ----------------------------------------------------------------------------
81 
82 // Owned contract
83 
84 // ----------------------------------------------------------------------------
85 
86 contract Owned {
87 
88     address public owner;
89 
90     address public newOwner;
91 
92 
93     event OwnershipTransferred(address indexed _from, address indexed _to);
94 
95 
96     constructor() public {
97 
98         owner = msg.sender;
99 
100     }
101 
102 
103     modifier onlyOwner {
104 
105         require(msg.sender == owner);
106 
107         _;
108 
109     }
110 
111 
112     function transferOwnership(address _newOwner) public onlyOwner {
113 
114         newOwner = _newOwner;
115 
116     }
117 
118     function acceptOwnership() public {
119 
120         require(msg.sender == newOwner);
121 
122         emit OwnershipTransferred(owner, newOwner);
123 
124         owner = newOwner;
125 
126         newOwner = address(0);
127  
128     }
129 
130 }
131 
132 
133  
134 // ----------------------------------------------------------------------------
135 
136 // ERC20 Token, with the addition of symbol, name and decimals and a
137 
138 // fixed supply
139 
140 // ----------------------------------------------------------------------------
141 
142 contract VNDCToken is ERC20Interface, Owned {
143 
144     using SafeMath for uint;
145 
146     string public symbol;
147 
148     string public  name;
149 
150     uint8 public decimals;
151 
152     uint _totalSupply;
153 
154     mapping(address => uint) balances;
155 
156     mapping(address => mapping(address => uint)) allowed;
157 
158 
159 
160     // ------------------------------------------------------------------------
161 
162     // Constructor
163 
164     // ------------------------------------------------------------------------
165 
166     constructor() public {
167 
168         symbol = "VNDC"; 
169 
170         name = "VNDC";
171 
172         decimals = 0;
173   
174         _totalSupply = 99000000000000 * 10**uint(decimals);
175 
176         balances[owner] = _totalSupply;
177 
178         emit Transfer(address(0), owner, _totalSupply);
179 
180     }
181 
182 
183 
184     // ------------------------------------------------------------------------
185 
186     // Total supply
187 
188     // ------------------------------------------------------------------------
189 
190     function totalSupply() public view returns (uint) {
191 
192         return _totalSupply.sub(balances[address(0)]);
193 
194     }
195 
196 
197 
198     // ------------------------------------------------------------------------
199 
200     // Get the token balance for account `tokenOwner`
201 
202     // ------------------------------------------------------------------------
203 
204     function balanceOf(address tokenOwner) public view returns (uint balance) {
205 
206         return balances[tokenOwner];
207 
208     }
209 
210 
211 
212     // ------------------------------------------------------------------------
213 
214     // Transfer the balance from token owner's account to `to` account
215 
216     // - Owner's account must have sufficient balance to transfer
217 
218     // - 0 value transfers are allowed
219 
220     // ------------------------------------------------------------------------
221 
222     function transfer(address to, uint tokens) public returns (bool success) {
223 
224         balances[msg.sender] = balances[msg.sender].sub(tokens);
225 
226         balances[to] = balances[to].add(tokens);
227 
228         emit Transfer(msg.sender, to, tokens);
229 
230         return true;
231 
232     }
233 
234 
235 
236     // ------------------------------------------------------------------------
237 
238     // Token owner can approve for `spender` to transferFrom(...) `tokens`
239 
240     // from the token owner's account
241 
242     //
243 
244     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
245 
246     // recommends that there are no checks for the approval double-spend attack
247 
248     // as this should be implemented in user interfaces 
249 
250     // ------------------------------------------------------------------------
251 
252     function approve(address spender, uint tokens) public returns (bool success) {
253 
254         allowed[msg.sender][spender] = tokens;
255 
256         emit Approval(msg.sender, spender, tokens);
257 
258         return true;
259 
260     }
261 
262 
263 
264     // ------------------------------------------------------------------------
265 
266     // Transfer `tokens` from the `from` account to the `to` account
267 
268     // 
269 
270     // The calling account must already have sufficient tokens approve(...)-d
271 
272     // for spending from the `from` account and
273 
274     // - From account must have sufficient balance to transfer
275 
276     // - Spender must have sufficient allowance to transfer
277 
278     // - 0 value transfers are allowed
279 
280     // ------------------------------------------------------------------------
281 
282     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
283 
284         balances[from] = balances[from].sub(tokens);
285 
286         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
287 
288         balances[to] = balances[to].add(tokens);
289 
290         emit Transfer(from, to, tokens);
291 
292         return true;
293 
294     }
295 
296 
297 
298     // ------------------------------------------------------------------------
299 
300     // Returns the amount of tokens approved by the owner that can be
301 
302     // transferred to the spender's account
303 
304     // ------------------------------------------------------------------------
305 
306     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
307 
308         return allowed[tokenOwner][spender];
309 
310     }
311 
312 
313 
314     // ------------------------------------------------------------------------
315 
316     // Token owner can approve for `spender` to transferFrom(...) `tokens`
317 
318     // from the token owner's account. The `spender` contract function
319 
320     // `receiveApproval(...)` is then executed
321 
322     // ------------------------------------------------------------------------
323 
324     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
325 
326         allowed[msg.sender][spender] = tokens;
327 
328         emit Approval(msg.sender, spender, tokens);
329 
330         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
331 
332         return true;
333 
334     }
335 
336 
337 
338     // ------------------------------------------------------------------------
339 
340     // Don't accept ETH
341 
342     // ------------------------------------------------------------------------
343 
344     function () public payable {
345 
346         revert();
347 
348     }
349  
350 
351 
352     // ------------------------------------------------------------------------
353 
354     // Owner can transfer out any accidentally sent ERC20 tokens
355 
356     // ------------------------------------------------------------------------
357 
358     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
359 
360         return ERC20Interface(tokenAddress).transfer(owner, tokens);
361 
362     }
363 
364 }