1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // Token Trustee Implementation
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
112 //
113 // Implements a more advanced ownership and permission model based on owner,
114 // admin and ops per Simple Token key management specification.
115 //
116 contract OpsManaged is Owned {
117 
118     address public opsAddress;
119     address public adminAddress;
120 
121     event AdminAddressChanged(address indexed _newAddress);
122     event OpsAddressChanged(address indexed _newAddress);
123 
124 
125     function OpsManaged() public
126         Owned()
127     {
128     }
129 
130 
131     modifier onlyAdmin() {
132         require(isAdmin(msg.sender));
133         _;
134     }
135 
136 
137     modifier onlyAdminOrOps() {
138         require(isAdmin(msg.sender) || isOps(msg.sender));
139         _;
140     }
141 
142 
143     modifier onlyOwnerOrAdmin() {
144         require(isOwner(msg.sender) || isAdmin(msg.sender));
145         _;
146     }
147 
148 
149     modifier onlyOps() {
150         require(isOps(msg.sender));
151         _;
152     }
153 
154 
155     function isAdmin(address _address) internal view returns (bool) {
156         return (adminAddress != address(0) && _address == adminAddress);
157     }
158 
159 
160     function isOps(address _address) internal view returns (bool) {
161         return (opsAddress != address(0) && _address == opsAddress);
162     }
163 
164 
165     function isOwnerOrOps(address _address) internal view returns (bool) {
166         return (isOwner(_address) || isOps(_address));
167     }
168 
169 
170     // Owner and Admin can change the admin address. Address can also be set to 0 to 'disable' it.
171     function setAdminAddress(address _adminAddress) external onlyOwnerOrAdmin returns (bool) {
172         require(_adminAddress != owner);
173         require(_adminAddress != address(this));
174         require(!isOps(_adminAddress));
175 
176         adminAddress = _adminAddress;
177 
178         AdminAddressChanged(_adminAddress);
179 
180         return true;
181     }
182 
183 
184     // Owner and Admin can change the operations address. Address can also be set to 0 to 'disable' it.
185     function setOpsAddress(address _opsAddress) external onlyOwnerOrAdmin returns (bool) {
186         require(_opsAddress != owner);
187         require(_opsAddress != address(this));
188         require(!isAdmin(_opsAddress));
189 
190         opsAddress = _opsAddress;
191 
192         OpsAddressChanged(_opsAddress);
193 
194         return true;
195     }
196 }
197 
198 contract SimpleTokenConfig {
199 
200     string  public constant TOKEN_SYMBOL   = "ST";
201     string  public constant TOKEN_NAME     = "Simple Token";
202     uint8   public constant TOKEN_DECIMALS = 18;
203 
204     uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);
205     uint256 public constant TOKENS_MAX     = 800000000 * DECIMALSFACTOR;
206 }
207 
208 contract ERC20Interface {
209 
210     event Transfer(address indexed _from, address indexed _to, uint256 _value);
211     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
212 
213     function name() public view returns (string);
214     function symbol() public view returns (string);
215     function decimals() public view returns (uint8);
216     function totalSupply() public view returns (uint256);
217 
218     function balanceOf(address _owner) public view returns (uint256 balance);
219     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
220 
221     function transfer(address _to, uint256 _value) public returns (bool success);
222     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
223     function approve(address _spender, uint256 _value) public returns (bool success);
224 }
225 
226 //
227 // Standard ERC20 implementation, with ownership.
228 //
229 contract ERC20Token is ERC20Interface, Owned {
230 
231     using SafeMath for uint256;
232 
233     string  private tokenName;
234     string  private tokenSymbol;
235     uint8   private tokenDecimals;
236     uint256 internal tokenTotalSupply;
237 
238     mapping(address => uint256) balances;
239     mapping(address => mapping (address => uint256)) allowed;
240 
241 
242     function ERC20Token(string _symbol, string _name, uint8 _decimals, uint256 _totalSupply) public
243         Owned()
244     {
245         tokenSymbol      = _symbol;
246         tokenName        = _name;
247         tokenDecimals    = _decimals;
248         tokenTotalSupply = _totalSupply;
249         balances[owner]  = _totalSupply;
250 
251         // According to the ERC20 standard, a token contract which creates new tokens should trigger
252         // a Transfer event and transfers of 0 values must also fire the event.
253         Transfer(0x0, owner, _totalSupply);
254     }
255 
256 
257     function name() public view returns (string) {
258         return tokenName;
259     }
260 
261 
262     function symbol() public view returns (string) {
263         return tokenSymbol;
264     }
265 
266 
267     function decimals() public view returns (uint8) {
268         return tokenDecimals;
269     }
270 
271 
272     function totalSupply() public view returns (uint256) {
273         return tokenTotalSupply;
274     }
275 
276 
277     function balanceOf(address _owner) public view returns (uint256) {
278         return balances[_owner];
279     }
280 
281 
282     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
283         return allowed[_owner][_spender];
284     }
285 
286 
287     function transfer(address _to, uint256 _value) public returns (bool success) {
288         // According to the EIP20 spec, "transfers of 0 values MUST be treated as normal
289         // transfers and fire the Transfer event".
290         // Also, should throw if not enough balance. This is taken care of by SafeMath.
291         balances[msg.sender] = balances[msg.sender].sub(_value);
292         balances[_to] = balances[_to].add(_value);
293 
294         Transfer(msg.sender, _to, _value);
295 
296         return true;
297     }
298 
299 
300     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
301         balances[_from] = balances[_from].sub(_value);
302         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
303         balances[_to] = balances[_to].add(_value);
304 
305         Transfer(_from, _to, _value);
306 
307         return true;
308     }
309 
310 
311     function approve(address _spender, uint256 _value) public returns (bool success) {
312 
313         allowed[msg.sender][_spender] = _value;
314 
315         Approval(msg.sender, _spender, _value);
316 
317         return true;
318     }
319 }
320 
321 //
322 // SimpleToken is a standard ERC20 token with some additional functionality:
323 // - It has a concept of finalize
324 // - Before finalize, nobody can transfer tokens except:
325 //     - Owner and operations can transfer tokens
326 //     - Anybody can send back tokens to owner
327 // - After finalize, no restrictions on token transfers
328 //
329 
330 //
331 // Permissions, according to the ST key management specification.
332 //
333 //                                    Owner    Admin   Ops
334 // transfer (before finalize)           x               x
335 // transferForm (before finalize)       x               x
336 // finalize                                      x
337 //
338 
339 contract SimpleToken is ERC20Token, OpsManaged, SimpleTokenConfig {
340 
341     bool public finalized;
342 
343 
344     // Events
345     event Burnt(address indexed _from, uint256 _amount);
346     event Finalized();
347 
348 
349     function SimpleToken() public
350         ERC20Token(TOKEN_SYMBOL, TOKEN_NAME, TOKEN_DECIMALS, TOKENS_MAX)
351         OpsManaged()
352     {
353         finalized = false;
354     }
355 
356 
357     // Implementation of the standard transfer method that takes into account the finalize flag.
358     function transfer(address _to, uint256 _value) public returns (bool success) {
359         checkTransferAllowed(msg.sender, _to);
360 
361         return super.transfer(_to, _value);
362     }
363 
364 
365     // Implementation of the standard transferFrom method that takes into account the finalize flag.
366     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
367         checkTransferAllowed(msg.sender, _to);
368 
369         return super.transferFrom(_from, _to, _value);
370     }
371 
372 
373     function checkTransferAllowed(address _sender, address _to) private view {
374         if (finalized) {
375             // Everybody should be ok to transfer once the token is finalized.
376             return;
377         }
378 
379         // Owner and Ops are allowed to transfer tokens before the sale is finalized.
380         // This allows the tokens to move from the TokenSale contract to a beneficiary.
381         // We also allow someone to send tokens back to the owner. This is useful among other
382         // cases, for the Trustee to transfer unlocked tokens back to the owner (reclaimTokens).
383         require(isOwnerOrOps(_sender) || _to == owner);
384     }
385 
386     // Implement a burn function to permit msg.sender to reduce its balance
387     // which also reduces tokenTotalSupply
388     function burn(uint256 _value) public returns (bool success) {
389         require(_value <= balances[msg.sender]);
390 
391         balances[msg.sender] = balances[msg.sender].sub(_value);
392         tokenTotalSupply = tokenTotalSupply.sub(_value);
393 
394         Burnt(msg.sender, _value);
395 
396         return true;
397     }
398 
399 
400     // Finalize method marks the point where token transfers are finally allowed for everybody.
401     function finalize() external onlyAdmin returns (bool success) {
402         require(!finalized);
403 
404         finalized = true;
405 
406         Finalized();
407 
408         return true;
409     }
410 }
411 
412 //
413 // Implements a simple trustee which can release tokens based on
414 // an explicit call from the owner.
415 //
416 
417 //
418 // Permissions, according to the ST key management specification.
419 //
420 //                                Owner    Admin   Ops   Revoke
421 // grantAllocation                           x      x
422 // revokeAllocation                                        x
423 // processAllocation                                x
424 // reclaimTokens                             x
425 // setRevokeAddress                 x                      x
426 //
427 
428 contract Trustee is OpsManaged {
429 
430     using SafeMath for uint256;
431 
432 
433     SimpleToken public tokenContract;
434 
435     struct Allocation {
436         uint256 amountGranted;
437         uint256 amountTransferred;
438         bool    revokable;
439     }
440 
441     // The trustee has a special 'revoke' key which is allowed to revoke allocations.
442     address public revokeAddress;
443 
444     // Total number of tokens that are currently allocated.
445     // This does not include tokens that have been processed (sent to an address) already or
446     // the ones in the trustee's account that have not been allocated yet.
447     uint256 public totalLocked;
448 
449     mapping (address => Allocation) public allocations;
450 
451 
452     //
453     // Events
454     //
455     event AllocationGranted(address indexed _from, address indexed _account, uint256 _amount, bool _revokable);
456     event AllocationRevoked(address indexed _from, address indexed _account, uint256 _amountRevoked);
457     event AllocationProcessed(address indexed _from, address indexed _account, uint256 _amount);
458     event RevokeAddressChanged(address indexed _newAddress);
459     event TokensReclaimed(uint256 _amount);
460 
461 
462     function Trustee(SimpleToken _tokenContract) public
463         OpsManaged()
464     {
465         require(address(_tokenContract) != address(0));
466 
467         tokenContract = _tokenContract;
468     }
469 
470 
471     modifier onlyOwnerOrRevoke() {
472         require(isOwner(msg.sender) || isRevoke(msg.sender));
473         _;
474     }
475 
476 
477     modifier onlyRevoke() {
478         require(isRevoke(msg.sender));
479         _;
480     }
481 
482 
483     function isRevoke(address _address) private view returns (bool) {
484         return (revokeAddress != address(0) && _address == revokeAddress);
485     }
486 
487 
488     // Owner and revoke can change the revoke address. Address can also be set to 0 to 'disable' it.
489     function setRevokeAddress(address _revokeAddress) external onlyOwnerOrRevoke returns (bool) {
490         require(_revokeAddress != owner);
491         require(!isAdmin(_revokeAddress));
492         require(!isOps(_revokeAddress));
493 
494         revokeAddress = _revokeAddress;
495 
496         RevokeAddressChanged(_revokeAddress);
497 
498         return true;
499     }
500 
501 
502     // Allows admin or ops to create new allocations for a specific account.
503     function grantAllocation(address _account, uint256 _amount, bool _revokable) public onlyAdminOrOps returns (bool) {
504         require(_account != address(0));
505         require(_account != address(this));
506         require(_amount > 0);
507 
508         // Can't create an allocation if there is already one for this account.
509         require(allocations[_account].amountGranted == 0);
510 
511         if (isOps(msg.sender)) {
512             // Once the token contract is finalized, the ops key should not be able to grant allocations any longer.
513             // Before finalized, it is used by the TokenSale contract to allocate pre-sales.
514             require(!tokenContract.finalized());
515         }
516 
517         totalLocked = totalLocked.add(_amount);
518         require(totalLocked <= tokenContract.balanceOf(address(this)));
519 
520         allocations[_account] = Allocation({
521             amountGranted     : _amount,
522             amountTransferred : 0,
523             revokable         : _revokable
524         });
525 
526         AllocationGranted(msg.sender, _account, _amount, _revokable);
527 
528         return true;
529     }
530 
531 
532     // Allows the revoke key to revoke allocations, if revoke is allowed.
533     function revokeAllocation(address _account) external onlyRevoke returns (bool) {
534         require(_account != address(0));
535 
536         Allocation memory allocation = allocations[_account];
537 
538         require(allocation.revokable);
539 
540         uint256 ownerRefund = allocation.amountGranted.sub(allocation.amountTransferred);
541 
542         delete allocations[_account];
543 
544         totalLocked = totalLocked.sub(ownerRefund);
545 
546         AllocationRevoked(msg.sender, _account, ownerRefund);
547 
548         return true;
549     }
550 
551 
552     // Push model which allows ops to transfer tokens to the beneficiary.
553     // The exact amount to transfer is calculated based on agreements with
554     // the beneficiaries. Here we only restrict that the total amount transfered cannot
555     // exceed what has been granted.
556     function processAllocation(address _account, uint256 _amount) external onlyOps returns (bool) {
557         require(_account != address(0));
558         require(_amount > 0);
559 
560         Allocation storage allocation = allocations[_account];
561 
562         require(allocation.amountGranted > 0);
563 
564         uint256 transferable = allocation.amountGranted.sub(allocation.amountTransferred);
565 
566         if (transferable < _amount) {
567            return false;
568         }
569 
570         allocation.amountTransferred = allocation.amountTransferred.add(_amount);
571 
572         // Note that transfer will fail if the token contract has not been finalized yet.
573         require(tokenContract.transfer(_account, _amount));
574 
575         totalLocked = totalLocked.sub(_amount);
576 
577         AllocationProcessed(msg.sender, _account, _amount);
578 
579         return true;
580     }
581 
582 
583     // Allows the admin to claim back all tokens that are not currently allocated.
584     // Note that the trustee should be able to move tokens even before the token is
585     // finalized because SimpleToken allows sending back to owner specifically.
586     function reclaimTokens() external onlyAdmin returns (bool) {
587         uint256 ownBalance = tokenContract.balanceOf(address(this));
588 
589         // If balance <= amount locked, there is nothing to reclaim.
590         require(ownBalance > totalLocked);
591 
592         uint256 amountReclaimed = ownBalance.sub(totalLocked);
593 
594         address tokenOwner = tokenContract.owner();
595         require(tokenOwner != address(0));
596 
597         require(tokenContract.transfer(tokenOwner, amountReclaimed));
598 
599         TokensReclaimed(amountReclaimed);
600 
601         return true;
602     }
603 }