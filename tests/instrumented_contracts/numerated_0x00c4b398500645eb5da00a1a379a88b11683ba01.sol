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
20 
21 
22    function Owned() public
23    {
24       owner = msg.sender;
25    }
26 
27 
28    modifier onlyOwner() {
29       require(isOwner(msg.sender) == true);
30       _;
31    }
32 
33 
34    function isOwner(address _address) public view returns (bool) {
35       return (_address == owner);
36    }
37 
38 
39    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
40       require(_proposedOwner != address(0));
41       require(_proposedOwner != address(this));
42       require(_proposedOwner != owner);
43 
44       proposedOwner = _proposedOwner;
45 
46       OwnershipTransferInitiated(proposedOwner);
47 
48       return true;
49    }
50 
51 
52    function completeOwnershipTransfer() public returns (bool) {
53       require(msg.sender == proposedOwner);
54 
55       owner = msg.sender;
56       proposedOwner = address(0);
57 
58       OwnershipTransferCompleted(owner);
59 
60       return true;
61    }
62 }
63 
64 // ----------------------------------------------------------------------------
65 // OpsManaged - Implements an Owner and Ops Permission Model
66 // Enuma Blockchain Platform
67 //
68 // Copyright (c) 2017 Enuma Technologies.
69 // https://www.enuma.io/
70 // ----------------------------------------------------------------------------
71 
72 
73 
74 
75 //
76 // Implements a security model with owner and ops.
77 //
78 contract OpsManaged is Owned {
79 
80    address public opsAddress;
81 
82    event OpsAddressUpdated(address indexed _newAddress);
83 
84 
85    function OpsManaged() public
86       Owned()
87    {
88    }
89 
90 
91    modifier onlyOwnerOrOps() {
92       require(isOwnerOrOps(msg.sender));
93       _;
94    }
95 
96 
97    function isOps(address _address) public view returns (bool) {
98       return (opsAddress != address(0) && _address == opsAddress);
99    }
100 
101 
102    function isOwnerOrOps(address _address) public view returns (bool) {
103       return (isOwner(_address) || isOps(_address));
104    }
105 
106 
107    function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool) {
108       require(_newOpsAddress != owner);
109       require(_newOpsAddress != address(this));
110 
111       opsAddress = _newOpsAddress;
112 
113       OpsAddressUpdated(opsAddress);
114 
115       return true;
116    }
117 }
118 
119 // ----------------------------------------------------------------------------
120 // Finalizable - Basic implementation of the finalization pattern
121 // Enuma Blockchain Platform
122 //
123 // Copyright (c) 2017 Enuma Technologies.
124 // https://www.enuma.io/
125 // ----------------------------------------------------------------------------
126 
127 
128 
129 
130 contract Finalizable is Owned {
131 
132    bool public finalized;
133 
134    event Finalized();
135 
136 
137    function Finalizable() public
138       Owned()
139    {
140       finalized = false;
141    }
142 
143 
144    function finalize() public onlyOwner returns (bool) {
145       require(!finalized);
146 
147       finalized = true;
148 
149       Finalized();
150 
151       return true;
152    }
153 }
154 
155 // ----------------------------------------------------------------------------
156 // Math - General Math Utility Library
157 // Enuma Blockchain Platform
158 //
159 // Copyright (c) 2017 Enuma Technologies.
160 // https://www.enuma.io/
161 // ----------------------------------------------------------------------------
162 
163 
164 library Math {
165 
166    function add(uint256 a, uint256 b) internal pure returns (uint256) {
167       uint256 r = a + b;
168 
169       require(r >= a);
170 
171       return r;
172    }
173 
174 
175    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176       require(a >= b);
177 
178       return a - b;
179    }
180 
181 
182    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183       if (a == 0) {
184          return 0;
185       }
186 
187       uint256 r = a * b;
188 
189       require(r / a == b);
190 
191       return r;
192    }
193 
194 
195    function div(uint256 a, uint256 b) internal pure returns (uint256) {
196       return a / b;
197    }
198 }
199 
200 // ----------------------------------------------------------------------------
201 // ERC20Interface - Standard ERC20 Interface Definition
202 // Enuma Blockchain Platform
203 //
204 // Copyright (c) 2017 Enuma Technologies.
205 // https://www.enuma.io/
206 // ----------------------------------------------------------------------------
207 
208 // ----------------------------------------------------------------------------
209 // Based on the final ERC20 specification at:
210 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
211 // ----------------------------------------------------------------------------
212 contract ERC20Interface {
213 
214    event Transfer(address indexed _from, address indexed _to, uint256 _value);
215    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
216 
217    function name() public view returns (string);
218    function symbol() public view returns (string);
219    function decimals() public view returns (uint8);
220    function totalSupply() public view returns (uint256);
221 
222    function balanceOf(address _owner) public view returns (uint256 balance);
223    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
224 
225    function transfer(address _to, uint256 _value) public returns (bool success);
226    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
227    function approve(address _spender, uint256 _value) public returns (bool success);
228 }
229 
230 // ----------------------------------------------------------------------------
231 // ERC20Token - Standard ERC20 Implementation
232 // Enuma Blockchain Platform
233 //
234 // Copyright (c) 2017 Enuma Technologies.
235 // https://www.enuma.io/
236 // ----------------------------------------------------------------------------
237 
238 
239 
240 contract ERC20Token is ERC20Interface {
241 
242    using Math for uint256;
243 
244    string  private tokenName;
245    string  private tokenSymbol;
246    uint8   private tokenDecimals;
247    uint256 internal tokenTotalSupply;
248 
249    mapping(address => uint256) internal balances;
250    mapping(address => mapping (address => uint256)) allowed;
251 
252 
253    function ERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {
254       tokenName = _name;
255       tokenSymbol = _symbol;
256       tokenDecimals = _decimals;
257       tokenTotalSupply = _totalSupply;
258 
259       // The initial balance of tokens is assigned to the given token holder address.
260       balances[_initialTokenHolder] = _totalSupply;
261 
262       // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
263       Transfer(0x0, _initialTokenHolder, _totalSupply);
264    }
265 
266 
267    function name() public view returns (string) {
268       return tokenName;
269    }
270 
271 
272    function symbol() public view returns (string) {
273       return tokenSymbol;
274    }
275 
276 
277    function decimals() public view returns (uint8) {
278       return tokenDecimals;
279    }
280 
281 
282    function totalSupply() public view returns (uint256) {
283       return tokenTotalSupply;
284    }
285 
286 
287    function balanceOf(address _owner) public view returns (uint256 balance) {
288       return balances[_owner];
289    }
290 
291 
292    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
293       return allowed[_owner][_spender];
294    }
295 
296 
297    function transfer(address _to, uint256 _value) public returns (bool success) {
298       balances[msg.sender] = balances[msg.sender].sub(_value);
299       balances[_to] = balances[_to].add(_value);
300 
301       Transfer(msg.sender, _to, _value);
302 
303       return true;
304    }
305 
306 
307    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
308       balances[_from] = balances[_from].sub(_value);
309       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
310       balances[_to] = balances[_to].add(_value);
311 
312       Transfer(_from, _to, _value);
313 
314       return true;
315    }
316 
317 
318    function approve(address _spender, uint256 _value) public returns (bool success) {
319       allowed[msg.sender][_spender] = _value;
320 
321       Approval(msg.sender, _spender, _value);
322 
323       return true;
324    }
325 }
326 
327 // ----------------------------------------------------------------------------
328 // FinalizableToken - Extension to ERC20Token with ops and finalization
329 // Enuma Blockchain Platform
330 //
331 // Copyright (c) 2017 Enuma Technologies.
332 // https://www.enuma.io/
333 // ----------------------------------------------------------------------------
334 
335 
336 
337 //
338 // ERC20 token with the following additions:
339 //    1. Owner/Ops Ownership
340 //    2. Finalization
341 //
342 contract FinalizableToken is ERC20Token, OpsManaged, Finalizable {
343 
344    using Math for uint256;
345 
346 
347    // The constructor will assign the initial token supply to the owner (msg.sender).
348    function FinalizableToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public
349       ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)
350       OpsManaged()
351       Finalizable()
352    {
353    }
354 
355 
356    function transfer(address _to, uint256 _value) public returns (bool success) {
357       validateTransfer(msg.sender, _to);
358 
359       return super.transfer(_to, _value);
360    }
361 
362 
363    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
364       validateTransfer(msg.sender, _to);
365 
366       return super.transferFrom(_from, _to, _value);
367    }
368 
369 
370    function validateTransfer(address _sender, address _to) private view {
371       // Once the token is finalized, everybody can transfer tokens.
372       if (finalized) {
373          return;
374       }
375 
376       if (isOwner(_to)) {
377          return;
378       }
379 
380       // Before the token is finalized, only owner and ops are allowed to initiate transfers.
381       // This allows them to move tokens while the sale is still ongoing for example.
382       require(isOwnerOrOps(_sender));
383    }
384 }
385 
386 
387 
388 // ----------------------------------------------------------------------------
389 // Eximchain Token Contract Configuration
390 //
391 // Copyright (c) 2017 Eximchain Pte. Ltd.
392 // http://www.eximchain.com/
393 //
394 // The MIT Licence.
395 // ----------------------------------------------------------------------------
396 
397 
398 contract EximchainTokenConfig {
399 
400     string  public constant TOKEN_SYMBOL      = "EXC";
401     string  public constant TOKEN_NAME        = "Eximchain Token";
402     uint8   public constant TOKEN_DECIMALS    = 18;
403 
404     uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);
405     uint256 public constant TOKEN_TOTALSUPPLY = 150000000 * DECIMALSFACTOR;
406 }
407 
408 
409 // ----------------------------------------------------------------------------
410 // Eximchain Token Contract
411 //
412 // Copyright (c) 2017 Eximchain Pte. Ltd.
413 // http://www.eximchain.com/
414 // The MIT Licence.
415 //
416 // Based on FinalizableToken contract from Enuma Technologies.
417 // Copyright (c) 2017 Enuma Technologies
418 // https://www.enuma.io/
419 // ----------------------------------------------------------------------------
420 
421 
422 
423 contract EximchainToken is FinalizableToken, EximchainTokenConfig {
424 
425 
426    bool public frozen;
427 
428 
429    //
430    // Events
431    //
432    event TokensBurnt(address indexed _account, uint256 _amount);
433    event TokensReclaimed(uint256 _amount);
434    event Frozen();
435 
436 
437    function EximchainToken() public
438       FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY)
439    {
440       frozen = false;
441    }
442 
443 
444    function transfer(address _to, uint256 _value) public returns (bool success) {
445       require(!frozen);
446 
447       return super.transfer(_to, _value);
448    }
449 
450 
451    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
452       require(!frozen);
453 
454       return super.transferFrom(_from, _to, _value);
455    }
456 
457 
458    // Allows a token holder to burn tokens. Once burned, tokens are permanently
459    // removed from the total supply.
460    function burn(uint256 _amount) public returns (bool) {
461       require(_amount > 0);
462 
463       address account = msg.sender;
464       require(_amount <= balanceOf(account));
465 
466       balances[account] = balances[account].sub(_amount);
467       tokenTotalSupply = tokenTotalSupply.sub(_amount);
468 
469       TokensBurnt(account, _amount);
470 
471       return true;
472    }
473 
474 
475    // Allows the owner to reclaim tokens that are assigned to the token contract itself.
476    function reclaimTokens() public onlyOwner returns (bool) {
477 
478       address account = address(this);
479       uint256 amount  = balanceOf(account);
480 
481       if (amount == 0) {
482          return false;
483       }
484 
485       balances[account] = balances[account].sub(amount);
486       balances[owner] = balances[owner].add(amount);
487 
488       Transfer(account, owner, amount);
489 
490       TokensReclaimed(amount);
491 
492       return true;
493    }
494 
495 
496    // Allows the owner to permanently disable token transfers. This can be used
497    // once side chain is ready and the owner wants to stop transfers to take a snapshot
498    // of token balances for the genesis of the side chain.
499    function freeze() public onlyOwner returns (bool) {
500       require(!frozen);
501 
502       frozen = true;
503 
504       Frozen();
505 
506       return true;
507    }
508 }