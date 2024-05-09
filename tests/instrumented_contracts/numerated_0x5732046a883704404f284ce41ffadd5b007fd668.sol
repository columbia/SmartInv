1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Owned - Ownership model with 2 phase transfers
5 // Enuma Blockchain Platform
6 //
7 // Copyright (c) 2017 Enuma Technologies.
8 // https://www.enuma.io/
9 // ----------------------------------------------------------------------------
10 
11 
12 // Implements a simple ownership model with 2-phase transfer.
13 contract Owned {
14 
15    address public owner;
16    address public proposedOwner;
17 
18    event OwnershipTransferInitiated(address indexed _proposedOwner);
19    event OwnershipTransferCompleted(address indexed _newOwner);
20    event OwnershipTransferCanceled();
21 
22 
23    function Owned() public
24    {
25       owner = msg.sender;
26    }
27 
28 
29    modifier onlyOwner() {
30       require(isOwner(msg.sender) == true);
31       _;
32    }
33 
34 
35    function isOwner(address _address) public view returns (bool) {
36       return (_address == owner);
37    }
38 
39 
40    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
41       require(_proposedOwner != address(0));
42       require(_proposedOwner != address(this));
43       require(_proposedOwner != owner);
44 
45       proposedOwner = _proposedOwner;
46 
47       OwnershipTransferInitiated(proposedOwner);
48 
49       return true;
50    }
51 
52 
53    function cancelOwnershipTransfer() public onlyOwner returns (bool) {
54       if (proposedOwner == address(0)) {
55          return true;
56       }
57 
58       proposedOwner = address(0);
59 
60       OwnershipTransferCanceled();
61 
62       return true;
63    }
64 
65 
66    function completeOwnershipTransfer() public returns (bool) {
67       require(msg.sender == proposedOwner);
68 
69       owner = msg.sender;
70       proposedOwner = address(0);
71 
72       OwnershipTransferCompleted(owner);
73 
74       return true;
75    }
76 }
77 
78 // ----------------------------------------------------------------------------
79 // OpsManaged - Implements an Owner and Ops Permission Model
80 // Enuma Blockchain Platform
81 //
82 // Copyright (c) 2017 Enuma Technologies.
83 // https://www.enuma.io/
84 // ----------------------------------------------------------------------------
85 
86 
87 
88 //
89 // Implements a security model with owner and ops.
90 //
91 contract OpsManaged is Owned {
92 
93    address public opsAddress;
94 
95    event OpsAddressUpdated(address indexed _newAddress);
96 
97 
98    function OpsManaged() public
99       Owned()
100    {
101    }
102 
103 
104    modifier onlyOwnerOrOps() {
105       require(isOwnerOrOps(msg.sender));
106       _;
107    }
108 
109 
110    function isOps(address _address) public view returns (bool) {
111       return (opsAddress != address(0) && _address == opsAddress);
112    }
113 
114 
115    function isOwnerOrOps(address _address) public view returns (bool) {
116       return (isOwner(_address) || isOps(_address));
117    }
118 
119 
120    function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool) {
121       require(_newOpsAddress != owner);
122       require(_newOpsAddress != address(this));
123 
124       opsAddress = _newOpsAddress;
125 
126       OpsAddressUpdated(opsAddress);
127 
128       return true;
129    }
130 }
131 
132 // ----------------------------------------------------------------------------
133 // Math - General Math Utility Library
134 // Enuma Blockchain Platform
135 //
136 // Copyright (c) 2017 Enuma Technologies.
137 // https://www.enuma.io/
138 // ----------------------------------------------------------------------------
139 
140 
141 library Math {
142 
143    function add(uint256 a, uint256 b) internal pure returns (uint256) {
144       uint256 r = a + b;
145 
146       require(r >= a);
147 
148       return r;
149    }
150 
151 
152    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153       require(a >= b);
154 
155       return a - b;
156    }
157 
158 
159    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160       uint256 r = a * b;
161 
162       require(a == 0 || r / a == b);
163 
164       return r;
165    }
166 
167 
168    function div(uint256 a, uint256 b) internal pure returns (uint256) {
169       return a / b;
170    }
171 }
172 
173 // ----------------------------------------------------------------------------
174 // ERC20Interface - Standard ERC20 Interface Definition
175 // Enuma Blockchain Platform
176 //
177 // Copyright (c) 2017 Enuma Technologies.
178 // https://www.enuma.io/
179 // ----------------------------------------------------------------------------
180 
181 // ----------------------------------------------------------------------------
182 // Based on the final ERC20 specification at:
183 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
184 // ----------------------------------------------------------------------------
185 contract ERC20Interface {
186 
187    event Transfer(address indexed _from, address indexed _to, uint256 _value);
188    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
189 
190    function name() public view returns (string);
191    function symbol() public view returns (string);
192    function decimals() public view returns (uint8);
193    function totalSupply() public view returns (uint256);
194 
195    function balanceOf(address _owner) public view returns (uint256 balance);
196    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
197 
198    function transfer(address _to, uint256 _value) public returns (bool success);
199    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
200    function approve(address _spender, uint256 _value) public returns (bool success);
201 }
202 
203 // ----------------------------------------------------------------------------
204 // ERC20Token - Standard ERC20 Implementation
205 // Enuma Blockchain Platform
206 //
207 // Copyright (c) 2017 Enuma Technologies.
208 // https://www.enuma.io/
209 // ----------------------------------------------------------------------------
210 
211 
212 contract ERC20Token is ERC20Interface {
213 
214    using Math for uint256;
215 
216    string  private tokenName;
217    string  private tokenSymbol;
218    uint8   private tokenDecimals;
219    uint256 internal tokenTotalSupply;
220 
221    mapping(address => uint256) internal balances;
222    mapping(address => mapping (address => uint256)) allowed;
223 
224 
225    function ERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {
226       tokenName = _name;
227       tokenSymbol = _symbol;
228       tokenDecimals = _decimals;
229       tokenTotalSupply = _totalSupply;
230 
231       // The initial balance of tokens is assigned to the given token holder address.
232       balances[_initialTokenHolder] = _totalSupply;
233 
234       // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
235       Transfer(0x0, _initialTokenHolder, _totalSupply);
236    }
237 
238 
239    function name() public view returns (string) {
240       return tokenName;
241    }
242 
243 
244    function symbol() public view returns (string) {
245       return tokenSymbol;
246    }
247 
248 
249    function decimals() public view returns (uint8) {
250       return tokenDecimals;
251    }
252 
253 
254    function totalSupply() public view returns (uint256) {
255       return tokenTotalSupply;
256    }
257 
258 
259    function balanceOf(address _owner) public view returns (uint256 balance) {
260       return balances[_owner];
261    }
262 
263 
264    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
265       return allowed[_owner][_spender];
266    }
267 
268 
269    function transfer(address _to, uint256 _value) public returns (bool success) {
270       balances[msg.sender] = balances[msg.sender].sub(_value);
271       balances[_to] = balances[_to].add(_value);
272 
273       Transfer(msg.sender, _to, _value);
274 
275       return true;
276    }
277 
278 
279    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
280       balances[_from] = balances[_from].sub(_value);
281       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
282       balances[_to] = balances[_to].add(_value);
283 
284       Transfer(_from, _to, _value);
285 
286       return true;
287    }
288 
289 
290    function approve(address _spender, uint256 _value) public returns (bool success) {
291       allowed[msg.sender][_spender] = _value;
292 
293       Approval(msg.sender, _spender, _value);
294 
295       return true;
296    }
297 }
298 
299 // ----------------------------------------------------------------------------
300 // Finalizable - Basic implementation of the finalization pattern
301 // Enuma Blockchain Platform
302 //
303 // Copyright (c) 2017 Enuma Technologies.
304 // https://www.enuma.io/
305 // ----------------------------------------------------------------------------
306 
307 
308 
309 contract Finalizable is Owned {
310 
311    bool public finalized;
312 
313    event Finalized();
314 
315 
316    function Finalizable() public
317       Owned()
318    {
319       finalized = false;
320    }
321 
322 
323    function finalize() public onlyOwner returns (bool) {
324       require(!finalized);
325 
326       finalized = true;
327 
328       Finalized();
329 
330       return true;
331    }
332 }
333 
334 // ----------------------------------------------------------------------------
335 // FinalizableToken - Extension to ERC20Token with ops and finalization
336 // Enuma Blockchain Platform
337 //
338 // Copyright (c) 2017 Enuma Technologies.
339 // https://www.enuma.io/
340 // ----------------------------------------------------------------------------
341 
342 
343 
344 //
345 // ERC20 token with the following additions:
346 //    1. Owner/Ops Ownership
347 //    2. Finalization
348 //
349 contract FinalizableToken is ERC20Token, OpsManaged, Finalizable {
350 
351    using Math for uint256;
352 
353 
354    // The constructor will assign the initial token supply to the owner (msg.sender).
355    function FinalizableToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public
356       ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)
357       OpsManaged()
358       Finalizable()
359    {
360    }
361 
362 
363    function transfer(address _to, uint256 _value) public returns (bool success) {
364       validateTransfer(msg.sender, _to);
365 
366       return super.transfer(_to, _value);
367    }
368 
369 
370    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
371       validateTransfer(msg.sender, _to);
372 
373       return super.transferFrom(_from, _to, _value);
374    }
375 
376 
377    function validateTransfer(address _sender, address _to) private view {
378       require(_to != address(0));
379 
380       // Once the token is finalized, everybody can transfer tokens.
381       if (finalized) {
382          return;
383       }
384 
385       if (isOwner(_to)) {
386          return;
387       }
388 
389       // Before the token is finalized, only owner and ops are allowed to initiate transfers.
390       // This allows them to move tokens while the sale is still ongoing for example.
391       require(isOwnerOrOps(_sender));
392    }
393 }
394 
395 
396 // ----------------------------------------------------------------------------
397 // BluzelleTokenConfig - Token Contract Configuration
398 //
399 // Copyright (c) 2017 Bluzelle Networks Pte Ltd.
400 // http://www.bluzelle.com/
401 //
402 // The MIT Licence.
403 // ----------------------------------------------------------------------------
404 
405 
406 contract BluzelleTokenConfig {
407 
408     string  public constant TOKEN_SYMBOL      = "BLZ";
409     string  public constant TOKEN_NAME        = "Bluzelle Token";
410     uint8   public constant TOKEN_DECIMALS    = 18;
411 
412     uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);
413     uint256 public constant TOKEN_TOTALSUPPLY = 500000000 * DECIMALSFACTOR;
414 }
415 
416 
417 
418 // ----------------------------------------------------------------------------
419 // BluzelleToken - ERC20 Compatible Token
420 //
421 // Copyright (c) 2017 Bluzelle Networks Pte Ltd.
422 // http://www.bluzelle.com/
423 //
424 // The MIT Licence.
425 // ----------------------------------------------------------------------------
426 
427 
428 
429 // ----------------------------------------------------------------------------
430 // The Bluzelle token is a standard ERC20 token with the addition of a few
431 // concepts such as:
432 //
433 // 1. Finalization
434 // Tokens can only be transfered by contributors after the contract has
435 // been finalized.
436 //
437 // 2. Ops Managed Model
438 // In addition to owner, there is a ops role which is used during the sale,
439 // by the sale contract, in order to transfer tokens.
440 // ----------------------------------------------------------------------------
441 contract BluzelleToken is FinalizableToken, BluzelleTokenConfig {
442 
443 
444    event TokensReclaimed(uint256 _amount);
445 
446 
447    function BluzelleToken() public
448       FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY)
449    {
450    }
451 
452 
453    // Allows the owner to reclaim tokens that have been sent to the token address itself.
454    function reclaimTokens() public onlyOwner returns (bool) {
455 
456       address account = address(this);
457       uint256 amount  = balanceOf(account);
458 
459       if (amount == 0) {
460          return false;
461       }
462 
463       balances[account] = balances[account].sub(amount);
464       balances[owner] = balances[owner].add(amount);
465 
466       Transfer(account, owner, amount);
467 
468       TokensReclaimed(amount);
469 
470       return true;
471    }
472 }