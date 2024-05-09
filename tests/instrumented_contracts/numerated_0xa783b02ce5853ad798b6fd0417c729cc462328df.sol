1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24 
25   /**
26   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract ERC20Basic {
44   function totalSupply() public view returns (uint256);
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public view returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   uint256 totalSupply_;
63 
64   /**
65   * @dev total number of tokens in existence
66   */
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     emit Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public view returns (uint256) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 contract Ownable {
98   address public owner;
99 
100 
101   event OwnershipRenounced(address indexed previousOwner);
102   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104 
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109   constructor() public {
110     owner = msg.sender;
111   }
112 
113   /**
114    * @dev Throws if called by any account other than the owner.
115    */
116   modifier onlyOwner() {
117     require(msg.sender == owner);
118     _;
119   }
120 
121   /**
122    * @dev Allows the current owner to transfer control of the contract to a newOwner.
123    * @param newOwner The address to transfer ownership to.
124    */
125   function transferOwnership(address newOwner) public onlyOwner {
126     require(newOwner != address(0));
127     emit OwnershipTransferred(owner, newOwner);
128     owner = newOwner;
129   }
130 
131   /**
132    * @dev Allows the current owner to relinquish control of the contract.
133    */
134   function renounceOwnership() public onlyOwner {
135     emit OwnershipRenounced(owner);
136     owner = address(0);
137   }
138 }
139 
140 contract StandardToken is ERC20, BasicToken {
141 
142   mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     emit Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    *
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     emit Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(address _owner, address _spender) public view returns (uint256) {
186     return allowed[_owner][_spender];
187   }
188 
189   /**
190    * @dev Increase the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _addedValue The amount of tokens to increase the allowance by.
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   /**
206    * @dev Decrease the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _subtractedValue The amount of tokens to decrease the allowance by.
214    */
215   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226 }
227 
228 contract HODLIT is StandardToken, Ownable {
229   using SafeMath for uint256;
230   string public name = "HODL INCENTIVE TOKEN";
231   string public symbol = "HIT";
232   uint256 public decimals = 18;
233   uint256 public multiplicator = 10 ** decimals;
234   uint256 public totalSupply;
235   uint256 public ICDSupply;
236 
237   uint256 public registeredUsers;
238   uint256 public claimedUsers;
239   uint256 public maxReferrals = 20;
240 
241   uint256 public hardCap = SafeMath.mul(100000000, multiplicator);
242   uint256 public ICDCap = SafeMath.mul(20000000, multiplicator);
243 
244   mapping (address => uint256) public etherBalances;
245   mapping (address => bool) public ICDClaims;
246   mapping (address => uint256) public referrals;
247   mapping (address => bool) public bonusReceived;
248 
249 
250   uint256 public regStartTime = 1519848000; // 28 feb 2018 20:00 GMT
251   uint256 public regStopTime = regStartTime + 7 days;
252   uint256 public POHStartTime = regStopTime;
253   uint256 public POHStopTime = POHStartTime + 7 days;
254   uint256 public ICDStartTime = POHStopTime;
255   uint256 public ICDStopTime = ICDStartTime + 7 days;
256   uint256 public PCDStartTime = ICDStopTime + 14 days;
257 
258   address public ERC721Address;
259 
260   modifier forRegistration {
261     require(block.timestamp >= regStartTime && block.timestamp < regStopTime);
262     _;
263   }
264 
265   modifier forICD {
266     require(block.timestamp >= ICDStartTime && block.timestamp < ICDStopTime);
267     _;
268   }
269 
270   modifier forERC721 {
271     require(msg.sender == ERC721Address && block.timestamp >= PCDStartTime);
272     _;
273   }
274 
275   function HODLIT() public {
276     uint256 reserve = SafeMath.mul(30000000, multiplicator);
277     owner = msg.sender;
278     totalSupply = totalSupply.add(reserve);
279     balances[owner] = balances[owner].add(reserve);
280     Transfer(address(0), owner, reserve);
281   }
282 
283   function() external payable {
284     revert();
285   }
286 
287   function setERC721Address(address _ERC721Address) external onlyOwner {
288     ERC721Address = _ERC721Address;
289   }
290 
291   function setMaxReferrals(uint256 _maxReferrals) external onlyOwner {
292     maxReferrals = _maxReferrals;
293   }
294 
295   function registerEtherBalance(address _referral) external forRegistration {
296     require(
297       msg.sender.balance > 0.2 ether &&
298       etherBalances[msg.sender] == 0 &&
299       _referral != msg.sender
300     );
301     if (_referral != address(0) && referrals[_referral] < maxReferrals) {
302       referrals[_referral]++;
303     }
304     registeredUsers++;
305     etherBalances[msg.sender] = msg.sender.balance;
306   }
307 
308   function claimTokens() external forICD {
309     require(ICDClaims[msg.sender] == false);
310     require(etherBalances[msg.sender] > 0);
311     require(etherBalances[msg.sender] <= msg.sender.balance + 50 finney);
312     ICDClaims[msg.sender] = true;
313     claimedUsers++;
314     require(mintICD(msg.sender, computeReward(etherBalances[msg.sender])));
315   }
316 
317   function declareCheater(address _cheater) external onlyOwner {
318     require(_cheater != address(0));
319     ICDClaims[_cheater] = false;
320     etherBalances[_cheater] = 0;
321   }
322 
323   function declareCheaters(address[] _cheaters) external onlyOwner {
324     for (uint256 i = 0; i < _cheaters.length; i++) {
325       require(_cheaters[i] != address(0));
326       ICDClaims[_cheaters[i]] = false;
327       etherBalances[_cheaters[i]] = 0;
328     }
329   }
330 
331   function mintPCD(address _to, uint256 _amount) external forERC721 returns(bool) {
332     require(_to != address(0));
333     require(_amount + totalSupply <= hardCap);
334     totalSupply = totalSupply.add(_amount);
335     balances[_to] = balances[_to].add(_amount);
336     etherBalances[_to] = _to.balance;
337     Transfer(address(0), _to, _amount);
338     return true;
339   }
340 
341   function claimTwitterBonus() external forICD {
342     require(balances[msg.sender] > 0 && !bonusReceived[msg.sender]);
343     bonusReceived[msg.sender] = true;
344     mintICD(msg.sender, multiplicator.mul(20));
345   }
346 
347   function claimReferralBonus() external forICD {
348     require(referrals[msg.sender] > 0 && balances[msg.sender] > 0);
349     uint256 cache = referrals[msg.sender];
350     referrals[msg.sender] = 0;
351     mintICD(msg.sender, SafeMath.mul(cache * 20, multiplicator));
352   }
353 
354   function computeReward(uint256 _amount) internal view returns(uint256) {
355     if (_amount < 1 ether) return SafeMath.mul(20, multiplicator);
356     if (_amount < 2 ether) return SafeMath.mul(100, multiplicator);
357     if (_amount < 3 ether) return SafeMath.mul(240, multiplicator);
358     if (_amount < 4 ether) return SafeMath.mul(430, multiplicator);
359     if (_amount < 5 ether) return SafeMath.mul(680, multiplicator);
360     if (_amount < 6 ether) return SafeMath.mul(950, multiplicator);
361     if (_amount < 7 ether) return SafeMath.mul(1260, multiplicator);
362     if (_amount < 8 ether) return SafeMath.mul(1580, multiplicator);
363     if (_amount < 9 ether) return SafeMath.mul(1900, multiplicator);
364     if (_amount < 10 ether) return SafeMath.mul(2240, multiplicator);
365     if (_amount < 11 ether) return SafeMath.mul(2560, multiplicator);
366     if (_amount < 12 ether) return SafeMath.mul(2890, multiplicator);
367     if (_amount < 13 ether) return SafeMath.mul(3210, multiplicator);
368     if (_amount < 14 ether) return SafeMath.mul(3520, multiplicator);
369     if (_amount < 15 ether) return SafeMath.mul(3830, multiplicator);
370     if (_amount < 16 ether) return SafeMath.mul(4120, multiplicator);
371     if (_amount < 17 ether) return SafeMath.mul(4410, multiplicator);
372     if (_amount < 18 ether) return SafeMath.mul(4680, multiplicator);
373     if (_amount < 19 ether) return SafeMath.mul(4950, multiplicator);
374     if (_amount < 20 ether) return SafeMath.mul(5210, multiplicator);
375     if (_amount < 21 ether) return SafeMath.mul(5460, multiplicator);
376     if (_amount < 22 ether) return SafeMath.mul(5700, multiplicator);
377     if (_amount < 23 ether) return SafeMath.mul(5930, multiplicator);
378     if (_amount < 24 ether) return SafeMath.mul(6150, multiplicator);
379     if (_amount < 25 ether) return SafeMath.mul(6360, multiplicator);
380     if (_amount < 26 ether) return SafeMath.mul(6570, multiplicator);
381     if (_amount < 27 ether) return SafeMath.mul(6770, multiplicator);
382     if (_amount < 28 ether) return SafeMath.mul(6960, multiplicator);
383     if (_amount < 29 ether) return SafeMath.mul(7140, multiplicator);
384     if (_amount < 30 ether) return SafeMath.mul(7320, multiplicator);
385     if (_amount < 31 ether) return SafeMath.mul(7500, multiplicator);
386     if (_amount < 32 ether) return SafeMath.mul(7660, multiplicator);
387     if (_amount < 33 ether) return SafeMath.mul(7820, multiplicator);
388     if (_amount < 34 ether) return SafeMath.mul(7980, multiplicator);
389     if (_amount < 35 ether) return SafeMath.mul(8130, multiplicator);
390     if (_amount < 36 ether) return SafeMath.mul(8270, multiplicator);
391     if (_amount < 37 ether) return SafeMath.mul(8410, multiplicator);
392     if (_amount < 38 ether) return SafeMath.mul(8550, multiplicator);
393     if (_amount < 39 ether) return SafeMath.mul(8680, multiplicator);
394     if (_amount < 40 ether) return SafeMath.mul(8810, multiplicator);
395     if (_amount < 41 ether) return SafeMath.mul(8930, multiplicator);
396     if (_amount < 42 ether) return SafeMath.mul(9050, multiplicator);
397     if (_amount < 43 ether) return SafeMath.mul(9170, multiplicator);
398     if (_amount < 44 ether) return SafeMath.mul(9280, multiplicator);
399     if (_amount < 45 ether) return SafeMath.mul(9390, multiplicator);
400     if (_amount < 46 ether) return SafeMath.mul(9500, multiplicator);
401     if (_amount < 47 ether) return SafeMath.mul(9600, multiplicator);
402     if (_amount < 48 ether) return SafeMath.mul(9700, multiplicator);
403     if (_amount < 49 ether) return SafeMath.mul(9800, multiplicator);
404     if (_amount < 50 ether) return SafeMath.mul(9890, multiplicator);
405     return SafeMath.mul(10000, multiplicator);
406   }
407 
408   function mintICD(address _to, uint256 _amount) internal returns(bool) {
409     require(_to != address(0));
410     require(_amount + ICDSupply <= ICDCap);
411     totalSupply = totalSupply.add(_amount);
412     ICDSupply = ICDSupply.add(_amount);
413     balances[_to] = balances[_to].add(_amount);
414     etherBalances[_to] = _to.balance;
415     Transfer(address(0), _to, _amount);
416     return true;
417   }
418 }
419 
420 
421 contract Airdrop is Ownable {
422 
423   HODLIT token;
424   address propheth = 0x0368284b0267DF29DD954a5Ed7832c84c09451eA;
425   bool isStopped;
426 
427   event AirdropLog(uint256 indexed id, address indexed user, uint256 claimAmount);
428 
429   mapping(uint256 => bool) public isClaimed;
430   mapping(uint256 => uint256) public claimedAt;
431   mapping(uint256 => address) public claimedBy;
432   mapping(address => uint256) public claims;
433 
434   uint256 public totalClaims;
435   uint256 public airdropLimit = safeMul(10000000, 10 ** 18);
436 
437   constructor(address _token) public {
438     token = HODLIT(_token);
439   }
440 
441   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256 c) {
442     c = a + b;
443     assert(c >= a);
444     return c;
445   }
446 
447   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
448     if (a == 0) {
449       return 0;
450     }
451     uint256 c = a * b;
452     assert(c / a == b);
453     return c;
454   }
455 
456   function ecrecovery(bytes32 hash, bytes sig) internal pure returns (address) {
457     bytes32 r;
458     bytes32 s;
459     uint8 v;
460 
461     // Check the signature length
462     if (sig.length != 65) {
463       return (address(0));
464     }
465 
466     // Divide the signature in r, s and v variables
467     // ecrecover takes the signature parameters, and the only way to get them
468     // currently is to use assembly.
469     // solium-disable-next-line security/no-inline-assembly
470     assembly {
471       r := mload(add(sig, 32))
472       s := mload(add(sig, 64))
473       v := byte(0, mload(add(sig, 96)))
474     }
475 
476     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
477     if (v < 27) {
478       v += 27;
479     }
480 
481     // If the version is correct return the signer address
482     if (v != 27 && v != 28) {
483       return (address(0));
484     } else {
485       // solium-disable-next-line arg-overflow
486       return ecrecover(hash, v, r, s);
487     }
488   }
489 
490   function parseAddr(string _a) internal pure returns (address) {
491     bytes memory tmp = bytes(_a);
492     uint160 iaddr = 0;
493     uint160 b1;
494     uint160 b2;
495     for (uint i=2; i<2+2*20; i+=2){
496       iaddr *= 256;
497       b1 = uint160(tmp[i]);
498       b2 = uint160(tmp[i+1]);
499       if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
500       else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
501       else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
502       if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
503       else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
504       else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
505       iaddr += (b1*16+b2);
506     }
507     return address(iaddr);
508   }
509 
510   function parseInt(string _a, uint _b) internal pure returns (uint) {
511     bytes memory bresult = bytes(_a);
512     uint mint = 0;
513     bool decimals = false;
514     for (uint i=0; i<bresult.length; i++){
515       if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
516         if (decimals){
517           if (_b == 0) break;
518           else _b--;
519         }
520         mint *= 10;
521         mint += uint(bresult[i]) - 48;
522       } else if (bresult[i] == 46) decimals = true;
523     }
524     if (_b > 0) mint *= 10**_b;
525     return mint;
526   }
527 
528 
529 
530   function prophetize(string _id, string _userAddress, string _claimAmount, bytes32 _hash, bytes _sig) internal view returns(bool){
531     require(keccak256("\x19Ethereum Signed Message:\n32", _id,'&',_userAddress,'&', _claimAmount) == _hash);
532     require(ecrecovery(_hash, _sig) == propheth);
533     return true;
534   }
535 
536   function stopAirdrop(bool _choice) external onlyOwner {
537     isStopped = _choice;
538   }
539 
540   function setPropheth(address _propheth) external onlyOwner {
541     propheth = _propheth;
542   }
543 
544   function claim(string _id, string _userAddress, string _claimAmount, bytes32 _hash, bytes _sig) external {
545     require(prophetize(_id, _userAddress, _claimAmount, _hash, _sig) == true && !isStopped);
546 
547     uint256 id = parseInt(_id, 0);
548     address userAddress = parseAddr(_userAddress);
549     uint256 claimAmount;
550 
551     if (token.ICDClaims(userAddress)) {
552         claimAmount = safeMul(parseInt(_claimAmount, 0) * 2, 10 ** 18);
553     } else {
554         claimAmount = safeMul(parseInt(_claimAmount, 0), 10 ** 18);
555     }
556 
557     require(!isClaimed[id] && claimAmount != 0 && userAddress == msg.sender);
558     require(safeAdd(claimAmount, totalClaims) < airdropLimit);
559 
560     isClaimed[id] = true;
561     claimedAt[id] = claimAmount;
562     claimedBy[id] = userAddress;
563     claims[userAddress] = safeAdd(claims[userAddress], claimAmount);
564     totalClaims = safeAdd(totalClaims, claimAmount);
565 
566     require(token.mintPCD(userAddress, claimAmount));
567 
568     emit AirdropLog(id, userAddress, claimAmount);
569 
570   }
571 }