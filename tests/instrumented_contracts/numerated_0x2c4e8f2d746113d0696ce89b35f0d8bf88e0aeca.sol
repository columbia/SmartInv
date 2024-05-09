1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // Simple Token Contract
5 //
6 // Copyright (c) 2017 OpenST Ltd.
7 // https://simpletoken.org/
8 //
9 // The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // SafeMath Library Implementation
14 //
15 // Copyright (c) 2017 OpenST Ltd.
16 // https://simpletoken.org/
17 //
18 // The MIT Licence.
19 //
20 // Based on the SafeMath library by the OpenZeppelin team.
21 // Copyright (c) 2016 Smart Contract Solutions, Inc.
22 // https://github.com/OpenZeppelin/zeppelin-solidity
23 // The MIT License.
24 // ----------------------------------------------------------------------------
25 
26 
27 library SafeMath {
28 
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a * b;
31 
32         assert(a == 0 || c / a == b);
33 
34         return c;
35     }
36 
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         // Solidity automatically throws when dividing by 0
40         uint256 c = a / b;
41 
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43         return c;
44     }
45 
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         assert(b <= a);
49 
50         return a - b;
51     }
52 
53 
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56 
57         assert(c >= a);
58 
59         return c;
60     }
61 }
62 
63 //
64 // Implements basic ownership with 2-step transfers.
65 //
66 contract Owned {
67 
68     address public owner;
69     address public proposedOwner;
70 
71     event OwnershipTransferInitiated(address indexed _proposedOwner);
72     event OwnershipTransferCompleted(address indexed _newOwner);
73 
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79 
80     modifier onlyOwner() {
81         require(isOwner(msg.sender));
82         _;
83     }
84 
85 
86     function isOwner(address _address) internal view returns (bool) {
87         return (_address == owner);
88     }
89 
90 
91     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
92         proposedOwner = _proposedOwner;
93 
94         OwnershipTransferInitiated(_proposedOwner);
95 
96         return true;
97     }
98 
99 
100     function completeOwnershipTransfer() public returns (bool) {
101         require(msg.sender == proposedOwner);
102 
103         owner = proposedOwner;
104         proposedOwner = address(0);
105 
106         OwnershipTransferCompleted(owner);
107 
108         return true;
109     }
110 }
111 
112 contract SimpleTokenConfig {
113 
114     string  public constant TOKEN_SYMBOL   = "ST";
115     string  public constant TOKEN_NAME     = "Simple Token";
116     uint8   public constant TOKEN_DECIMALS = 18;
117 
118     uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);
119     uint256 public constant TOKENS_MAX     = 800000000 * DECIMALSFACTOR;
120 }
121 
122 contract ERC20Interface {
123 
124     event Transfer(address indexed _from, address indexed _to, uint256 _value);
125     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
126 
127     function name() public view returns (string);
128     function symbol() public view returns (string);
129     function decimals() public view returns (uint8);
130     function totalSupply() public view returns (uint256);
131 
132     function balanceOf(address _owner) public view returns (uint256 balance);
133     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
134 
135     function transfer(address _to, uint256 _value) public returns (bool success);
136     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
137     function approve(address _spender, uint256 _value) public returns (bool success);
138 }
139 
140 //
141 // Standard ERC20 implementation, with ownership.
142 //
143 contract ERC20Token is ERC20Interface, Owned {
144 
145     using SafeMath for uint256;
146 
147     string  private tokenName;
148     string  private tokenSymbol;
149     uint8   private tokenDecimals;
150     uint256 internal tokenTotalSupply;
151 
152     mapping(address => uint256) balances;
153     mapping(address => mapping (address => uint256)) allowed;
154 
155 
156     function ERC20Token(string _symbol, string _name, uint8 _decimals, uint256 _totalSupply) public
157         Owned()
158     {
159         tokenSymbol      = _symbol;
160         tokenName        = _name;
161         tokenDecimals    = _decimals;
162         tokenTotalSupply = _totalSupply;
163         balances[owner]  = _totalSupply;
164 
165         // According to the ERC20 standard, a token contract which creates new tokens should trigger
166         // a Transfer event and transfers of 0 values must also fire the event.
167         Transfer(0x0, owner, _totalSupply);
168     }
169 
170 
171     function name() public view returns (string) {
172         return tokenName;
173     }
174 
175 
176     function symbol() public view returns (string) {
177         return tokenSymbol;
178     }
179 
180 
181     function decimals() public view returns (uint8) {
182         return tokenDecimals;
183     }
184 
185 
186     function totalSupply() public view returns (uint256) {
187         return tokenTotalSupply;
188     }
189 
190 
191     function balanceOf(address _owner) public view returns (uint256) {
192         return balances[_owner];
193     }
194 
195 
196     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
197         return allowed[_owner][_spender];
198     }
199 
200 
201     function transfer(address _to, uint256 _value) public returns (bool success) {
202         // According to the EIP20 spec, "transfers of 0 values MUST be treated as normal
203         // transfers and fire the Transfer event".
204         // Also, should throw if not enough balance. This is taken care of by SafeMath.
205         balances[msg.sender] = balances[msg.sender].sub(_value);
206         balances[_to] = balances[_to].add(_value);
207 
208         Transfer(msg.sender, _to, _value);
209 
210         return true;
211     }
212 
213 
214     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
215         balances[_from] = balances[_from].sub(_value);
216         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218 
219         Transfer(_from, _to, _value);
220 
221         return true;
222     }
223 
224 
225     function approve(address _spender, uint256 _value) public returns (bool success) {
226 
227         allowed[msg.sender][_spender] = _value;
228 
229         Approval(msg.sender, _spender, _value);
230 
231         return true;
232     }
233 
234 }
235 
236 
237 
238 //
239 // Implements a more advanced ownership and permission model based on owner,
240 // admin and ops per Simple Token key management specification.
241 //
242 contract OpsManaged is Owned {
243 
244     address public opsAddress;
245     address public adminAddress;
246 
247     event AdminAddressChanged(address indexed _newAddress);
248     event OpsAddressChanged(address indexed _newAddress);
249 
250 
251     function OpsManaged() public
252         Owned()
253     {
254     }
255 
256 
257     modifier onlyAdmin() {
258         require(isAdmin(msg.sender));
259         _;
260     }
261 
262 
263     modifier onlyAdminOrOps() {
264         require(isAdmin(msg.sender) || isOps(msg.sender));
265         _;
266     }
267 
268 
269     modifier onlyOwnerOrAdmin() {
270         require(isOwner(msg.sender) || isAdmin(msg.sender));
271         _;
272     }
273 
274 
275     modifier onlyOps() {
276         require(isOps(msg.sender));
277         _;
278     }
279 
280 
281     function isAdmin(address _address) internal view returns (bool) {
282         return (adminAddress != address(0) && _address == adminAddress);
283     }
284 
285 
286     function isOps(address _address) internal view returns (bool) {
287         return (opsAddress != address(0) && _address == opsAddress);
288     }
289 
290 
291     function isOwnerOrOps(address _address) internal view returns (bool) {
292         return (isOwner(_address) || isOps(_address));
293     }
294 
295 
296     // Owner and Admin can change the admin address. Address can also be set to 0 to 'disable' it.
297     function setAdminAddress(address _adminAddress) external onlyOwnerOrAdmin returns (bool) {
298         require(_adminAddress != owner);
299         require(_adminAddress != address(this));
300         require(!isOps(_adminAddress));
301 
302         adminAddress = _adminAddress;
303 
304         AdminAddressChanged(_adminAddress);
305 
306         return true;
307     }
308 
309 
310     // Owner and Admin can change the operations address. Address can also be set to 0 to 'disable' it.
311     function setOpsAddress(address _opsAddress) external onlyOwnerOrAdmin returns (bool) {
312         require(_opsAddress != owner);
313         require(_opsAddress != address(this));
314         require(!isAdmin(_opsAddress));
315 
316         opsAddress = _opsAddress;
317 
318         OpsAddressChanged(_opsAddress);
319 
320         return true;
321     }
322 }
323 
324 
325 //
326 // SimpleToken is a standard ERC20 token with some additional functionality:
327 // - It has a concept of finalize
328 // - Before finalize, nobody can transfer tokens except:
329 //     - Owner and operations can transfer tokens
330 //     - Anybody can send back tokens to owner
331 // - After finalize, no restrictions on token transfers
332 //
333 
334 //
335 // Permissions, according to the ST key management specification.
336 //
337 //                                    Owner    Admin   Ops
338 // transfer (before finalize)           x               x
339 // transferForm (before finalize)       x               x
340 // finalize                                      x
341 //
342 
343 contract SimpleToken is ERC20Token, OpsManaged, SimpleTokenConfig {
344 
345     bool public finalized;
346 
347 
348     // Events
349     event Burnt(address indexed _from, uint256 _amount);
350     event Finalized();
351 
352 
353     function SimpleToken() public
354         ERC20Token(TOKEN_SYMBOL, TOKEN_NAME, TOKEN_DECIMALS, TOKENS_MAX)
355         OpsManaged()
356     {
357         finalized = false;
358     }
359 
360 
361     // Implementation of the standard transfer method that takes into account the finalize flag.
362     function transfer(address _to, uint256 _value) public returns (bool success) {
363         checkTransferAllowed(msg.sender, _to);
364 
365         return super.transfer(_to, _value);
366     }
367 
368 
369     // Implementation of the standard transferFrom method that takes into account the finalize flag.
370     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
371         checkTransferAllowed(msg.sender, _to);
372 
373         return super.transferFrom(_from, _to, _value);
374     }
375 
376 
377     function checkTransferAllowed(address _sender, address _to) private view {
378         if (finalized) {
379             // Everybody should be ok to transfer once the token is finalized.
380             return;
381         }
382 
383         // Owner and Ops are allowed to transfer tokens before the sale is finalized.
384         // This allows the tokens to move from the TokenSale contract to a beneficiary.
385         // We also allow someone to send tokens back to the owner. This is useful among other
386         // cases, for the Trustee to transfer unlocked tokens back to the owner (reclaimTokens).
387         require(isOwnerOrOps(_sender) || _to == owner);
388     }
389 
390     // Implement a burn function to permit msg.sender to reduce its balance
391     // which also reduces tokenTotalSupply
392     function burn(uint256 _value) public returns (bool success) {
393         require(_value <= balances[msg.sender]);
394 
395         balances[msg.sender] = balances[msg.sender].sub(_value);
396         tokenTotalSupply = tokenTotalSupply.sub(_value);
397 
398         Burnt(msg.sender, _value);
399 
400         return true;
401     }
402 
403 
404     // Finalize method marks the point where token transfers are finally allowed for everybody.
405     function finalize() external onlyAdmin returns (bool success) {
406         require(!finalized);
407 
408         finalized = true;
409 
410         Finalized();
411 
412         return true;
413     }
414 }