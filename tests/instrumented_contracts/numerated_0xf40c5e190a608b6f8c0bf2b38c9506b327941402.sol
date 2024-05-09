1 pragma solidity ^0.4.24;
2 
3 // This is the Alethena Share Token. 
4 // To learn more, visit https://github.com/Alethena/Alethena-Shares-Token
5 // Or contact us at contact@alethena.com
6 
7 contract ERC20Basic {
8     function totalSupply() public view returns (uint256);
9     function balanceOf(address who) public view returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 contract ERC20 is ERC20Basic {
15     function allowance(address owner, address spender)
16         public view returns (uint256);
17 
18     function transferFrom(address from, address to, uint256 value)
19         public returns (bool);
20 
21     function approve(address spender, uint256 value) public returns (bool);
22     event Approval(
23     address indexed owner,
24     address indexed spender,
25     uint256 value
26     );
27 }
28 
29 contract Ownable {
30     address public owner;
31     address public master = 0x8fED3492dB590ad34ed42b0F509EB3c9626246Fc;
32 
33     event OwnershipRenounced(address indexed previousOwner);
34     event OwnershipTransferred(
35         address indexed previousOwner,
36         address indexed newOwner
37     );
38 
39 
40   /**
41    * @dev The Ownable constructor sets the original 'owner' of the contract to the sender
42    * account.
43    */
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56   /**
57    * @dev Allows the current owner to relinquish control of the contract.
58    */
59     function renounceOwnership() public onlyOwner {
60         emit OwnershipRenounced(owner);
61         owner = address(0);
62     }
63 
64   /**
65    * @dev Allows the master to transfer control of the contract to a newOwner.
66    * @param _newOwner The address to transfer ownership to.
67    */
68     function transferOwnership(address _newOwner) public {
69         require(msg.sender == master);
70         _transferOwnership(_newOwner);
71     }
72 
73   /**
74    * @dev Transfers control of the contract to a newOwner.
75    * @param _newOwner The address to transfer ownership to.
76    */
77     function _transferOwnership(address _newOwner) internal {
78         require(_newOwner != address(0));
79         emit OwnershipTransferred(owner, _newOwner);
80         owner = _newOwner;
81     }
82 }
83 
84 contract Claimable is ERC20Basic, Ownable {
85 
86     using SafeMath for uint256;
87 
88     struct Claim {
89         address claimant; // the person who created the claim
90         uint256 collateral; // the amount of wei deposited
91         uint256 timestamp;  // the timestamp of the block in which the claim was made
92     }
93 
94     struct PreClaim {
95         bytes32 msghash; // the hash of nonce + address to be claimed
96         uint256 timestamp;  // the timestamp of the block in which the preclaim was made
97     }
98 
99     /** @param collateralRate Sets the collateral needed per share to file a claim */
100     uint256 public collateralRate = 5*10**15 wei;
101 
102     uint256 public claimPeriod = 60*60*24*180; // In seconds ;
103     uint256 public preClaimPeriod = 60*60*24; // In seconds ;
104 
105     mapping(address => Claim) public claims; // there can be at most one claim per address, here address is claimed address
106     mapping(address => PreClaim) public preClaims; // there can be at most one preclaim per address, here address is claimer
107 
108 
109     function setClaimParameters(uint256 _collateralRateInWei, uint256 _claimPeriodInDays) public onlyOwner() {
110         uint256 claimPeriodInSeconds = _claimPeriodInDays*60*60*24;
111         require(_collateralRateInWei > 0);
112         require(_claimPeriodInDays > 90); // must be at least 90 days
113         collateralRate = _collateralRateInWei;
114         claimPeriod = claimPeriodInSeconds;
115         emit ClaimParametersChanged(collateralRate, claimPeriod);
116     }
117 
118     event ClaimMade(address indexed _lostAddress, address indexed _claimant, uint256 _balance);
119     event ClaimPrepared(address indexed _claimer);
120     event ClaimCleared(address indexed _lostAddress, uint256 collateral);
121     event ClaimDeleted(address indexed _lostAddress, address indexed _claimant, uint256 collateral);
122     event ClaimResolved(address indexed _lostAddress, address indexed _claimant, uint256 collateral);
123     event ClaimParametersChanged(uint256 _collateralRate, uint256  _claimPeriodInDays);
124 
125 
126   /** Anyone can declare that the private key to a certain address was lost by calling declareLost
127     * providing a deposit/collateral. There are three possibilities of what can happen with the claim:
128     * 1) The claim period expires and the claimant can get the deposit and the shares back by calling resolveClaim
129     * 2) The "lost" private key is used at any time to call clearClaim. In that case, the claim is deleted and
130     *    the deposit sent to the shareholder (the owner of the private key). It is recommended to call resolveClaim
131     *    whenever someone transfers funds to let claims be resolved automatically when the "lost" private key is
132     *    used again.
133     * 3) The owner deletes the claim and assigns the deposit to the claimant. This is intended to be used to resolve
134     *    disputes. Generally, using this function implies that you have to trust the issuer of the tokens to handle
135     *    the situation well. As a rule of thumb, the contract owner should assume the owner of the lost address to be the
136     *    rightful owner of the deposit.
137     * It is highly recommended that the owner observes the claims made and informs the owners of the claimed addresses
138     * whenever a claim is made for their address (this of course is only possible if they are known to the owner, e.g.
139     * through a shareholder register).
140     * To prevent frontrunning attacks, a claim can only be made if the information revealed when calling "declareLost"
141     * was previously commited using the "prepareClaim" function.
142     */
143 
144     function prepareClaim(bytes32 _hashedpackage) public{
145         preClaims[msg.sender] = PreClaim({
146             msghash: _hashedpackage,
147             timestamp: block.timestamp
148         });
149         emit ClaimPrepared(msg.sender);
150     }
151 
152     function validateClaim(address _lostAddress, bytes32 _nonce) private view returns (bool){
153         PreClaim memory preClaim = preClaims[msg.sender];
154         require(preClaim.msghash != 0);
155         require(preClaim.timestamp + preClaimPeriod <= block.timestamp);
156         require(preClaim.timestamp + 2*preClaimPeriod >= block.timestamp);
157         return preClaim.msghash == keccak256(abi.encodePacked(_nonce, msg.sender, _lostAddress));
158     }
159 
160     function declareLost(address _lostAddress, bytes32 _nonce) public payable{
161         uint256 balance = balanceOf(_lostAddress);
162         require(balance > 0);
163         require(msg.value >= balance.mul(collateralRate));
164         require(claims[_lostAddress].collateral == 0);
165         require(validateClaim(_lostAddress, _nonce));
166 
167         claims[_lostAddress] = Claim({
168             claimant: msg.sender,
169             collateral: msg.value,
170             timestamp: block.timestamp
171         });
172         delete preClaims[msg.sender];
173         emit ClaimMade(_lostAddress, msg.sender, balance);
174     }
175 
176     function getClaimant(address _lostAddress) public view returns (address){
177         return claims[_lostAddress].claimant;
178     }
179 
180     function getCollateral(address _lostAddress) public view returns (uint256){
181         return claims[_lostAddress].collateral;
182     }
183 
184     function getTimeStamp(address _lostAddress) public view returns (uint256){
185         return claims[_lostAddress].timestamp;
186     }
187 
188     function getPreClaimTimeStamp(address _claimerAddress) public view returns (uint256){
189         return preClaims[_claimerAddress].timestamp;
190     }
191 
192     function getMsgHash(address _claimerAddress) public view returns (bytes32){
193         return preClaims[_claimerAddress].msghash;
194     }
195 
196     /**
197      * @dev Clears a claim after the key has been found again and assigns the collateral to the "lost" address.
198      */
199     function clearClaim() public returns (uint256){
200         uint256 collateral = claims[msg.sender].collateral;
201         if (collateral != 0){
202             delete claims[msg.sender];
203             msg.sender.transfer(collateral);
204             emit ClaimCleared(msg.sender, collateral);
205             return collateral;
206         } else {
207             return 0;
208         }
209     }
210 
211    /**
212     * @dev This function is used to resolve a claim.
213     * @dev After waiting period, the tokens on the lost address and collateral can be transferred.
214    */
215     function resolveClaim(address _lostAddress) public returns (uint256){
216         Claim memory claim = claims[_lostAddress];
217         require(claim.collateral != 0, "No claim found");
218         require(claim.claimant == msg.sender);
219         require(claim.timestamp + claimPeriod <= block.timestamp);
220         address claimant = claim.claimant;
221         delete claims[_lostAddress];
222         claimant.transfer(claim.collateral);
223         internalTransfer(_lostAddress, claimant, balanceOf(_lostAddress));
224         emit ClaimResolved(_lostAddress, claimant, claim.collateral);
225         return claim.collateral;
226     }
227 
228     function internalTransfer(address _from, address _to, uint256 _value) internal;
229 
230      /** @dev This function is to be executed by the owner only in case a dispute needs to be resolved manually. */
231     function deleteClaim(address _lostAddress) public onlyOwner(){
232         Claim memory claim = claims[_lostAddress];
233         require(claim.collateral != 0, "No claim found");
234         delete claims[_lostAddress];
235         claim.claimant.transfer(claim.collateral);
236         emit ClaimDeleted(_lostAddress, claim.claimant, claim.collateral);
237     }
238 
239 }
240 
241 contract AlethenaShares is ERC20, Claimable {
242 
243     string public constant name = "Alethena Equity";
244     string public constant symbol = "ALEQ";
245     uint8 public constant decimals = 0; // legally, shares are not divisible
246 
247     using SafeMath for uint256;
248 
249       /** URL where the source code as well as the terms and conditions can be found. */
250     string public constant termsAndConditions = "shares.alethena.com";
251 
252     mapping(address => uint256) balances;
253     uint256 totalSupply_;        // total number of tokenized shares, sum of all balances
254     uint256 totalShares_ = 1397188; // total number of outstanding shares, maybe not all tokenized
255 
256     event Mint(address indexed shareholder, uint256 amount, string message);
257     event Unmint(uint256 amount, string message);
258 
259   /** @dev Total number of tokens in existence */
260     function totalSupply() public view returns (uint256) {
261         return totalSupply_;
262     }
263 
264   /** @dev Total number of shares in existence, not necessarily all represented by a token.
265     * @dev This could be useful to calculate the total market cap.
266     */
267     function totalShares() public view returns (uint256) {
268         return totalShares_;
269     }
270 
271     function setTotalShares(uint256 _newTotalShares) public onlyOwner() {
272         require(_newTotalShares >= totalSupply());
273         totalShares_ = _newTotalShares;
274     }
275 
276   /** Increases the number of the tokenized shares. If the shares are newly issued, the share total also needs to be increased. */
277     function mint(address shareholder, uint256 _amount, string _message) public onlyOwner() {
278         require(_amount > 0);
279         require(totalSupply_.add(_amount) <= totalShares_);
280         balances[shareholder] = balances[shareholder].add(_amount);
281         totalSupply_ = totalSupply_ + _amount;
282         emit Mint(shareholder, _amount, _message);
283     }
284 
285 /** Decrease the number of the tokenized shares. There are two use-cases for this function:
286  *  1) a capital decrease with a destruction of the shares, in which case the law requires that the
287  *     destroyed shares are currently owned by the company.
288  *  2) a shareholder wants to take shares offline. This can only happen with the agreement of the
289  *     the company. To do so, the shares must be transferred to the company first, the company call
290  *     this function and then assigning the untokenized shares back to the shareholder in whatever
291  *     way the new form (e.g. printed certificate) of the shares requires.
292  */
293     function unmint(uint256 _amount, string _message) public onlyOwner() {
294         require(_amount > 0);
295         require(_amount <= balanceOf(owner));
296         balances[owner] = balances[owner].sub(_amount);
297         totalSupply_ = totalSupply_ - _amount;
298         emit Unmint(_amount, _message);
299     }
300 
301   /** This contract is pausible.  */
302     bool public isPaused = false;
303 
304   /** @dev Function to set pause.
305    *  This could for example be used in case of a fork of the network, in which case all
306    *  "wrong" forked contracts should be paused in their respective fork. Deciding which
307    *  fork is the "right" one is up to the owner of the contract.
308    */
309     function pause(bool _pause, string _message, address _newAddress, uint256 _fromBlock) public onlyOwner() {
310         isPaused = _pause;
311         emit Pause(_pause, _message, _newAddress, _fromBlock);
312     }
313 
314     event Pause(bool paused, string message, address newAddress, uint256 fromBlock);
315 
316 //////////////////////////////////////////////////////////////////////////////////////////////////////////////
317 /**
318 The next section contains standard ERC20 routines.
319 Main change: Transfer functions have an additional post function which resolves claims if applicable.
320  */
321 //////////////////////////////////////////////////////////////////////////////////////////////////////////////
322 
323   /**
324   * @dev Transfer token for a specified address
325   * @param _to The address to transfer to.
326   * @param _value The amount to be transferred.
327   */
328     function transfer(address _to, uint256 _value) public returns (bool) {
329         clearClaim();
330         internalTransfer(msg.sender, _to, _value);
331         return true;
332     }
333 
334     function internalTransfer(address _from, address _to, uint256 _value) internal {
335         require(!isPaused);
336         require(_to != address(0));
337         require(_value <= balances[_from]);
338         balances[_from] = balances[_from].sub(_value);
339         balances[_to] = balances[_to].add(_value);
340         emit Transfer(_from, _to, _value);
341     }
342 
343   /**
344   * @dev Gets the balance of the specified address.
345   * @param _owner The address to query the the balance of.
346   * @return An uint256 representing the amount owned by the passed address.
347   */
348     function balanceOf(address _owner) public view returns (uint256) {
349         return balances[_owner];
350     }
351 
352     mapping (address => mapping (address => uint256)) internal allowed;
353 
354   /**
355    * @dev Transfer tokens from one address to another
356    * @param _from address The address which you want to send tokens from
357    * @param _to address The address which you want to transfer to
358    * @param _value uint256 the amount of tokens to be transferred
359    */
360     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
361         require(_value <= allowed[_from][msg.sender]);
362         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
363         internalTransfer(_from, _to, _value);
364         return true;
365     }
366 
367   /**
368    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
369    * Beware that changing an allowance with this method brings the risk that someone may use both the old
370    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
371    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
372    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
373    * @param _spender The address which will spend the funds.
374    * @param _value The amount of tokens to be spent.
375    */
376     function approve(address _spender, uint256 _value) public returns (bool) {
377         require(!isPaused);
378         allowed[msg.sender][_spender] = _value;
379         emit Approval(msg.sender, _spender, _value);
380         return true;
381     }
382 
383     event Approval(address approver, address spender, uint256 value);
384   /**
385    * @dev Function to check the amount of tokens that an owner allowed to a spender.
386    * @param _owner address The address which owns the funds.
387    * @param _spender address The address which will spend the funds.
388    * @return A uint256 specifying the amount of tokens still available for the spender.
389    */
390     function allowance(address _owner, address _spender) public view returns (uint256) {
391         return allowed[_owner][_spender];
392     }
393 
394   /**
395    * @dev Increase the amount of tokens that an owner allowed to a spender.
396    * approve should be called when allowed[_spender] == 0. To increment
397    * allowed value is better to use this function to avoid 2 calls (and wait until
398    * the first transaction is mined)
399    * From MonolithDAO Token.sol
400    * @param _spender The address which will spend the funds.
401    * @param _addedValue The amount of tokens to increase the allowance by.
402    */
403     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
404         require(!isPaused);
405         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
406         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
407         return true;
408     }
409 
410   /**
411    * @dev Decrease the amount of tokens that an owner allowed to a spender.
412    * approve should be called when allowed[_spender] == 0. To decrement
413    * allowed value is better to use this function to avoid 2 calls (and wait until
414    * the first transaction is mined)
415    * From MonolithDAO Token.sol
416    * @param _spender The address which will spend the funds.
417    * @param _subtractedValue The amount of tokens to decrease the allowance by.
418    */
419     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
420         require(!isPaused);
421         uint256 oldValue = allowed[msg.sender][_spender];
422         if (_subtractedValue > oldValue) {
423             allowed[msg.sender][_spender] = 0;
424         } else {
425             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
426         }
427         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
428         return true;
429     }
430 
431 }
432 
433 library SafeMath {
434 
435   /**
436   * @dev Multiplies two numbers, throws on overflow.
437   */
438     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
439         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
440         // benefit is lost if 'b' is also tested.
441         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
442         if (a == 0) {
443             return 0;
444         }
445 
446         c = a * b;
447         assert(c / a == b);
448         return c;
449     }
450 
451   /**
452   * @dev Integer division of two numbers, truncating the quotient.
453   */
454     function div(uint256 a, uint256 b) internal pure returns (uint256) {
455         // assert(b > 0); // Solidity automatically throws when dividing by 0
456         // uint256 c = a / b;
457         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
458         return a / b;
459     }
460 
461   /**
462   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
463   */
464     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
465         assert(b <= a);
466         return a - b;
467     }
468 
469   /**
470   * @dev Adds two numbers, throws on overflow.
471   */
472     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
473         c = a + b;
474         assert(c >= a);
475         return c;
476     }
477 }