1 pragma solidity ^0.4.18;
2 
3 
4 contract Owned {
5 
6    address public owner;
7    address public proposedOwner;
8 
9    event OwnershipTransferInitiated(address indexed _proposedOwner);
10    event OwnershipTransferCompleted(address indexed _newOwner);
11    event OwnershipTransferCanceled();
12 
13 
14    function Owned() public
15    {
16       owner = msg.sender;
17    }
18 
19 
20    modifier onlyOwner() {
21       require(isOwner(msg.sender) == true);
22       _;
23    }
24 
25 
26    function isOwner(address _address) public view returns (bool) {
27       return (_address == owner);
28    }
29 
30 
31    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
32       require(_proposedOwner != address(0));
33       require(_proposedOwner != address(this));
34       require(_proposedOwner != owner);
35 
36       proposedOwner = _proposedOwner;
37 
38       OwnershipTransferInitiated(proposedOwner);
39 
40       return true;
41    }
42 
43 
44    function cancelOwnershipTransfer() public onlyOwner returns (bool) {
45       if (proposedOwner == address(0)) {
46          return true;
47       }
48 
49       proposedOwner = address(0);
50 
51       OwnershipTransferCanceled();
52 
53       return true;
54    }
55 
56 
57    function completeOwnershipTransfer() public returns (bool) {
58       require(msg.sender == proposedOwner);
59 
60       owner = msg.sender;
61       proposedOwner = address(0);
62 
63       OwnershipTransferCompleted(owner);
64 
65       return true;
66    }
67 }
68 
69 
70 
71 contract OpsManaged is Owned {
72 
73    address public opsAddress;
74 
75    event OpsAddressUpdated(address indexed _newAddress);
76 
77 
78    function OpsManaged() public
79       Owned()
80    {
81    }
82 
83 
84    modifier onlyOwnerOrOps() {
85       require(isOwnerOrOps(msg.sender));
86       _;
87    }
88 
89 
90    function isOps(address _address) public view returns (bool) {
91       return (opsAddress != address(0) && _address == opsAddress);
92    }
93 
94 
95    function isOwnerOrOps(address _address) public view returns (bool) {
96       return (isOwner(_address) || isOps(_address));
97    }
98 
99 
100    function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool) {
101       require(_newOpsAddress != owner);
102       require(_newOpsAddress != address(this));
103 
104       opsAddress = _newOpsAddress;
105 
106       OpsAddressUpdated(opsAddress);
107 
108       return true;
109    }
110 }
111 
112 
113 library Math {
114 
115    function add(uint256 a, uint256 b) internal pure returns (uint256) {
116       uint256 r = a + b;
117 
118       require(r >= a);
119 
120       return r;
121    }
122 
123 
124    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125       require(a >= b);
126 
127       return a - b;
128    }
129 
130 
131    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132       uint256 r = a * b;
133 
134       require(a == 0 || r / a == b);
135 
136       return r;
137    }
138 
139 
140    function div(uint256 a, uint256 b) internal pure returns (uint256) {
141       return a / b;
142    }
143 }
144 
145 // ----------------------------------------------------------------------------
146 // Based on the final ERC20 specification at:
147 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
148 // ----------------------------------------------------------------------------
149 contract ERC20Interface {
150 
151    event Transfer(address indexed _from, address indexed _to, uint256 _value);
152    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
153 
154    function name() public view returns (string);
155    function symbol() public view returns (string);
156    function decimals() public view returns (uint8);
157    function totalSupply() public view returns (uint256);
158 
159    function balanceOf(address _owner) public view returns (uint256 balance);
160    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
161 
162    function transfer(address _to, uint256 _value) public returns (bool success);
163    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
164    function approve(address _spender, uint256 _value) public returns (bool success);
165 }
166 
167 // ----------------------------------------------------------------------------
168 
169 
170 contract ERC20Token is ERC20Interface {
171 
172    using Math for uint256;
173 
174    string  private tokenName;
175    string  private tokenSymbol;
176    uint8   private tokenDecimals;
177    uint256 internal tokenTotalSupply;
178 
179    mapping(address => uint256) internal balances;
180    mapping(address => mapping (address => uint256)) allowed;
181 
182 
183    function ERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {
184       tokenName = _name;
185       tokenSymbol = _symbol;
186       tokenDecimals = _decimals;
187       tokenTotalSupply = _totalSupply;
188 
189       // The initial balance of tokens is assigned to the given token holder address.
190       balances[_initialTokenHolder] = _totalSupply;
191 
192       // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
193       Transfer(0x0, _initialTokenHolder, _totalSupply);
194    }
195 
196 
197    function name() public view returns (string) {
198       return tokenName;
199    }
200 
201 
202    function symbol() public view returns (string) {
203       return tokenSymbol;
204    }
205 
206 
207    function decimals() public view returns (uint8) {
208       return tokenDecimals;
209    }
210 
211 
212    function totalSupply() public view returns (uint256) {
213       return tokenTotalSupply;
214    }
215 
216 
217    function balanceOf(address _owner) public view returns (uint256 balance) {
218       return balances[_owner];
219    }
220 
221 
222    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
223       return allowed[_owner][_spender];
224    }
225 
226 
227    function transfer(address _to, uint256 _value) public returns (bool success) {
228       balances[msg.sender] = balances[msg.sender].sub(_value);
229       balances[_to] = balances[_to].add(_value);
230 
231       Transfer(msg.sender, _to, _value);
232 
233       return true;
234    }
235 
236 
237    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
238       balances[_from] = balances[_from].sub(_value);
239       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240       balances[_to] = balances[_to].add(_value);
241 
242       Transfer(_from, _to, _value);
243 
244       return true;
245    }
246 
247 
248    function approve(address _spender, uint256 _value) public returns (bool success) {
249       allowed[msg.sender][_spender] = _value;
250 
251       Approval(msg.sender, _spender, _value);
252 
253       return true;
254    }
255 }
256 
257 // ----------------------------------------------------------------------------
258 
259 
260 
261 contract Finalizable is Owned {
262 
263    bool public finalized;
264 
265    event Finalized();
266 
267 
268    function Finalizable() public
269       Owned()
270    {
271       finalized = false;
272    }
273 
274 
275    function finalize() public onlyOwner returns (bool) {
276       require(!finalized);
277 
278       finalized = true;
279 
280       Finalized();
281 
282       return true;
283    }
284 }
285 
286 // -----------------------
287 // ----------------------------------------------------------------------------
288 
289 
290 
291 //
292 contract FinalizableToken is ERC20Token, OpsManaged, Finalizable {
293 
294    using Math for uint256;
295 
296 
297    // The constructor will assign the initial token supply to the owner (msg.sender).
298    function FinalizableToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public
299       ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)
300       OpsManaged()
301       Finalizable()
302    {
303    }
304 
305 
306    function transfer(address _to, uint256 _value) public returns (bool success) {
307       validateTransfer(msg.sender, _to);
308 
309       return super.transfer(_to, _value);
310    }
311 
312 
313    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
314       validateTransfer(msg.sender, _to);
315 
316       return super.transferFrom(_from, _to, _value);
317    }
318 
319 
320    function validateTransfer(address _sender, address _to) private view {
321       require(_to != address(0));
322 
323       // Once the token is finalized, everybody can transfer tokens.
324       if (finalized) {
325          return;
326       }
327 
328       if (isOwner(_to)) {
329          return;
330       }
331 
332       // Before the token is finalized, only owner and ops are allowed to initiate transfers.
333       // This allows them to move tokens while the sale is still ongoing for example.
334       require(isOwnerOrOps(_sender));
335    }
336 }
337 
338 
339 // ----------------------------------------------------------------------------
340 // Token Contract Configuration
341 //
342 // ----------------------------------------------------------------------------
343 
344 
345 contract TokenConfig {
346 
347     string  public constant TOKEN_SYMBOL      = "DUCK";
348     string  public constant TOKEN_NAME        = "Duckcoin";
349     uint8   public constant TOKEN_DECIMALS    = 18;
350 
351     uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);
352     uint256 public constant TOKEN_TOTALSUPPLY = 2000000000000 * DECIMALSFACTOR;
353 }
354 
355 
356 
357 // ----------------------------------------------------------------------------
358 //  - ERC20 Compatible Token
359 //
360 // ----------------------------------------------------------------------------
361 
362 
363 
364 // ----------------------------------------------------------------------------
365 // The  token is a standard ERC20 token with the addition of a few
366 // concepts such as:
367 //
368 // 1. Finalization
369 // Tokens can only be transfered by contributors after the contract has
370 // been finalized.
371 //
372 // 2. Ops Managed Model
373 // In addition to owner, there is a ops role which is used during the sale,
374 // by the sale contract, in order to transfer tokens.
375 // ----------------------------------------------------------------------------
376 contract Duckcoin is FinalizableToken, TokenConfig {
377 
378 
379    event TokensReclaimed(uint256 _amount);
380 
381 
382    function Duckcoin() public
383       FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY)
384    {
385    }
386 
387 
388    // Allows the owner to reclaim tokens that have been sent to the token address itself.
389    function reclaimTokens() public onlyOwner returns (bool) {
390 
391       address account = address(this);
392       uint256 amount  = balanceOf(account);
393 
394       if (amount == 0) {
395          return false;
396       }
397 
398       balances[account] = balances[account].sub(amount);
399       balances[owner] = balances[owner].add(amount);
400 
401       Transfer(account, owner, amount);
402 
403       TokensReclaimed(amount);
404 
405       return true;
406    }
407 }