1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // ERC20Interface - Standard ERC20 Interface Definition
5 // Enuma Blockchain Platform
6 //
7 // Copyright (c) 2017 Enuma Technologies Limited.
8 // https://www.enuma.io/
9 // ----------------------------------------------------------------------------
10 
11 // ----------------------------------------------------------------------------
12 // Based on the final ERC20 specification at:
13 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
14 // ----------------------------------------------------------------------------
15 contract ERC20Interface {
16 
17    event Transfer(address indexed _from, address indexed _to, uint256 _value);
18    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20    function name() public view returns (string);
21    function symbol() public view returns (string);
22    function decimals() public view returns (uint8);
23    function totalSupply() public view returns (uint256);
24 
25    function balanceOf(address _owner) public view returns (uint256 balance);
26    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
27 
28    function transfer(address _to, uint256 _value) public returns (bool success);
29    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30    function approve(address _spender, uint256 _value) public returns (bool success);
31 }
32 
33 // ----------------------------------------------------------------------------
34 // Math - General Math Utility Library
35 // Enuma Blockchain Platform
36 //
37 // Copyright (c) 2017 Enuma Technologies Limited.
38 // https://www.enuma.io/
39 // ----------------------------------------------------------------------------
40 
41 
42 library Math {
43 
44    function add(uint256 a, uint256 b) internal pure returns (uint256) {
45       uint256 r = a + b;
46 
47       require(r >= a);
48 
49       return r;
50    }
51 
52 
53    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54       require(a >= b);
55 
56       return a - b;
57    }
58 
59 
60    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61       if (a == 0) {
62          return 0;
63       }
64 
65       uint256 r = a * b;
66 
67       require(r / a == b);
68 
69       return r;
70    }
71 
72 
73    function div(uint256 a, uint256 b) internal pure returns (uint256) {
74       return a / b;
75    }
76 }
77 
78 // ----------------------------------------------------------------------------
79 // Owned - Ownership model with 2 phase transfers
80 // Enuma Blockchain Platform
81 //
82 // Copyright (c) 2017 Enuma Technologies Limited.
83 // https://www.enuma.io/
84 // ----------------------------------------------------------------------------
85 
86 
87 // Implements a simple ownership model with 2-phase transfer.
88 contract Owned {
89 
90    address public owner;
91    address public proposedOwner;
92 
93    event OwnershipTransferInitiated(address indexed _proposedOwner);
94    event OwnershipTransferCompleted(address indexed _newOwner);
95 
96 
97    constructor() public
98    {
99       owner = msg.sender;
100    }
101 
102 
103    modifier onlyOwner() {
104       require(isOwner(msg.sender) == true);
105       _;
106    }
107 
108 
109    function isOwner(address _address) public view returns (bool) {
110       return (_address == owner);
111    }
112 
113 
114    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
115       require(_proposedOwner != address(0));
116       require(_proposedOwner != address(this));
117       require(_proposedOwner != owner);
118 
119       proposedOwner = _proposedOwner;
120 
121       emit OwnershipTransferInitiated(proposedOwner);
122 
123       return true;
124    }
125 
126 
127    function completeOwnershipTransfer() public returns (bool) {
128       require(msg.sender == proposedOwner);
129 
130       owner = msg.sender;
131       proposedOwner = address(0);
132 
133       emit OwnershipTransferCompleted(owner);
134 
135       return true;
136    }
137 }
138 
139 // ----------------------------------------------------------------------------
140 // Finalizable - Basic implementation of the finalization pattern
141 // Enuma Blockchain Platform
142 //
143 // Copyright (c) 2017 Enuma Technologies Limited.
144 // https://www.enuma.io/
145 // ----------------------------------------------------------------------------
146 
147 
148 contract Finalizable is Owned() {
149 
150    bool public finalized;
151 
152    event Finalized();
153 
154 
155    constructor() public
156    {
157       finalized = false;
158    }
159 
160 
161    function finalize() public onlyOwner returns (bool) {
162       require(!finalized);
163 
164       finalized = true;
165 
166       emit Finalized();
167 
168       return true;
169    }
170 }
171 
172 // ----------------------------------------------------------------------------
173 // OpsManaged - Implements an Owner and Ops Permission Model
174 // Enuma Blockchain Platform
175 //
176 // Copyright (c) 2017 Enuma Technologies Limited.
177 // https://www.enuma.io/
178 // ----------------------------------------------------------------------------
179 
180 
181 
182 //
183 // Implements a security model with owner and ops.
184 //
185 contract OpsManaged is Owned() {
186 
187    address public opsAddress;
188 
189    event OpsAddressUpdated(address indexed _newAddress);
190 
191 
192    constructor() public
193    {
194    }
195 
196 
197    modifier onlyOwnerOrOps() {
198       require(isOwnerOrOps(msg.sender));
199       _;
200    }
201 
202 
203    function isOps(address _address) public view returns (bool) {
204       return (opsAddress != address(0) && _address == opsAddress);
205    }
206 
207 
208    function isOwnerOrOps(address _address) public view returns (bool) {
209       return (isOwner(_address) || isOps(_address));
210    }
211 
212 
213    function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool) {
214       require(_newOpsAddress != owner);
215       require(_newOpsAddress != address(this));
216 
217       opsAddress = _newOpsAddress;
218 
219       emit OpsAddressUpdated(opsAddress);
220 
221       return true;
222    }
223 }
224 
225 // ----------------------------------------------------------------------------
226 // ERC20Token - Standard ERC20 Implementation
227 // Enuma Blockchain Platform
228 //
229 // Copyright (c) 2017 Enuma Technologies Limited.
230 // https://www.enuma.io/
231 // ----------------------------------------------------------------------------
232 
233 
234 contract ERC20Token is ERC20Interface {
235 
236    using Math for uint256;
237 
238    string  private tokenName;
239    string  private tokenSymbol;
240    uint8   private tokenDecimals;
241    uint256 internal tokenTotalSupply;
242 
243    mapping(address => uint256) internal balances;
244    mapping(address => mapping (address => uint256)) allowed;
245 
246 
247    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {
248       tokenName = _name;
249       tokenSymbol = _symbol;
250       tokenDecimals = _decimals;
251       tokenTotalSupply = _totalSupply;
252 
253       // The initial balance of tokens is assigned to the given token holder address.
254       balances[_initialTokenHolder] = _totalSupply;
255 
256       // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
257       emit Transfer(0x0, _initialTokenHolder, _totalSupply);
258    }
259 
260 
261    function name() public view returns (string) {
262       return tokenName;
263    }
264 
265 
266    function symbol() public view returns (string) {
267       return tokenSymbol;
268    }
269 
270 
271    function decimals() public view returns (uint8) {
272       return tokenDecimals;
273    }
274 
275 
276    function totalSupply() public view returns (uint256) {
277       return tokenTotalSupply;
278    }
279 
280 
281    function balanceOf(address _owner) public view returns (uint256 balance) {
282       return balances[_owner];
283    }
284 
285 
286    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
287       return allowed[_owner][_spender];
288    }
289 
290 
291    function transfer(address _to, uint256 _value) public returns (bool success) {
292       balances[msg.sender] = balances[msg.sender].sub(_value);
293       balances[_to] = balances[_to].add(_value);
294 
295       emit Transfer(msg.sender, _to, _value);
296 
297       return true;
298    }
299 
300 
301    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
302       balances[_from] = balances[_from].sub(_value);
303       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
304       balances[_to] = balances[_to].add(_value);
305 
306       emit Transfer(_from, _to, _value);
307 
308       return true;
309    }
310 
311 
312    function approve(address _spender, uint256 _value) public returns (bool success) {
313       allowed[msg.sender][_spender] = _value;
314 
315       emit Approval(msg.sender, _spender, _value);
316 
317       return true;
318    }
319 }
320 
321 // ----------------------------------------------------------------------------
322 // FinalizableToken - Extension to ERC20Token with ops and finalization
323 // Enuma Blockchain Platform
324 //
325 // Copyright (c) 2017 Enuma Technologies Limited.
326 // https://www.enuma.io/
327 // ----------------------------------------------------------------------------
328 
329 
330 //
331 // ERC20 token with the following additions:
332 //    1. Owner/Ops Ownership
333 //    2. Finalization
334 //
335 contract FinalizableToken is ERC20Token, OpsManaged, Finalizable {
336 
337    using Math for uint256;
338 
339 
340    // The constructor will assign the initial token supply to the owner (msg.sender).
341    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public
342       ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)
343       OpsManaged()
344       Finalizable()
345    {
346    }
347 
348 
349    function transfer(address _to, uint256 _value) public returns (bool success) {
350       validateTransfer(msg.sender, _to);
351 
352       return super.transfer(_to, _value);
353    }
354 
355 
356    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
357       validateTransfer(msg.sender, _to);
358 
359       return super.transferFrom(_from, _to, _value);
360    }
361 
362 
363    function validateTransfer(address _sender, address _to) private view {
364       // Once the token is finalized, everybody can transfer tokens.
365       if (finalized) {
366          return;
367       }
368 
369       if (isOwner(_to)) {
370          return;
371       }
372 
373       // Before the token is finalized, only owner and ops are allowed to initiate transfers.
374       // This allows them to move tokens while the sale is still ongoing for example.
375       require(isOwnerOrOps(_sender));
376    }
377 }
378 
379 
380 
381 // ----------------------------------------------------------------------------
382 // CaspianTokenConfig - Token Contract Configuration
383 //
384 // Copyright (c) 2018 Caspian, Limited (TM).
385 // http://www.caspian.tech/
386 // ----------------------------------------------------------------------------
387 
388 
389 contract CaspianTokenConfig {
390 
391     string  public constant TOKEN_SYMBOL      = "CSP";
392     string  public constant TOKEN_NAME        = "Caspian Token";
393     uint8   public constant TOKEN_DECIMALS    = 18;
394 
395     uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);
396     uint256 public constant TOKEN_TOTALSUPPLY = 1000000000 * DECIMALSFACTOR;
397 }
398 
399 
400 // ----------------------------------------------------------------------------
401 // CaspianToken - ERC20 Compatible Token
402 //
403 // Copyright (c) 2018 Caspian, Limited (TM).
404 // http://www.caspian.tech/
405 //
406 // Based on code from Enuma Technologies.
407 // Copyright (c) 2017 Enuma Technologies Limited.
408 // ----------------------------------------------------------------------------
409 
410 
411 contract CaspianToken is FinalizableToken, CaspianTokenConfig {
412 
413 
414    event TokensReclaimed(uint256 _amount);
415 
416 
417    constructor() public
418       FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY)
419    {
420    }
421 
422 
423    function reclaimTokens() public onlyOwner returns (bool) {
424 
425       address account = address(this);
426       uint256 amount  = balanceOf(account);
427 
428       if (amount == 0) {
429          return false;
430       }
431 
432       balances[account] = balances[account].sub(amount);
433       balances[owner] = balances[owner].add(amount);
434 
435       emit Transfer(account, owner, amount);
436 
437       emit TokensReclaimed(amount);
438 
439       return true;
440    }
441 }