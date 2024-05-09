1 // SolidStamp contract for https://www.solidstamp.com
2 // The source code is available at https://github.com/SolidStamp/smart-contract/
3 
4 pragma solidity ^0.4.23;
5 
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to relinquish control of the contract.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 pragma solidity ^0.4.23;
67 
68 /**
69  * @title Pausable
70  * @dev Base contract which allows children to implement an emergency stop mechanism.
71  */
72 contract Pausable is Ownable {
73   event Pause();
74   event Unpause();
75 
76   bool public paused = false;
77 
78 
79   /**
80    * @dev Modifier to make a function callable only when the contract is not paused.
81    */
82   modifier whenNotPaused() {
83     require(!paused);
84     _;
85   }
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is paused.
89    */
90   modifier whenPaused() {
91     require(paused);
92     _;
93   }
94 
95   /**
96    * @dev called by the owner to pause, triggers stopped state
97    */
98   function pause() onlyOwner whenNotPaused public {
99     paused = true;
100     emit Pause();
101   }
102 
103   /**
104    * @dev called by the owner to unpause, returns to normal state
105    */
106   function unpause() onlyOwner whenPaused public {
107     paused = false;
108     emit Unpause();
109   }
110 }
111 
112 pragma solidity ^0.4.23;
113 
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
125     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
126     // benefit is lost if 'b' is also tested.
127     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
128     if (a == 0) {
129       return 0;
130     }
131 
132     c = a * b;
133     assert(c / a == b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 a, uint256 b) internal pure returns (uint256) {
141     // assert(b > 0); // Solidity automatically throws when dividing by 0
142     // uint256 c = a / b;
143     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144     return a / b;
145   }
146 
147   /**
148   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     assert(b <= a);
152     return a - b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
159     c = a + b;
160     assert(c >= a);
161     return c;
162   }
163 }
164 
165 pragma solidity ^0.4.23;
166 
167 contract Upgradable is Ownable, Pausable {
168     // Set in case the core contract is broken and an upgrade is required
169     address public newContractAddress;
170 
171     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
172     event ContractUpgrade(address newContract);
173 
174     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
175     ///  breaking bug. This method does nothing but keep track of the new contract and
176     ///  emit a message indicating that the new address is set. It's up to clients of this
177     ///  contract to update to the new contract address in that case. (This contract will
178     ///  be paused indefinitely if such an upgrade takes place.)
179     /// @param _v2Address new address
180     function setNewAddress(address _v2Address) external onlyOwner whenPaused {
181         require(_v2Address != 0x0);
182         newContractAddress = _v2Address;
183         emit ContractUpgrade(_v2Address);
184     }
185 
186 }
187 
188 pragma solidity ^0.4.24;
189 
190 contract SolidStampRegister is Ownable
191 {
192 /// @dev address of the current SolidStamp contract which can add audits
193     address public contractSolidStamp;
194 
195     /// @dev const value to indicate the contract is audited and approved
196     uint8 public constant NOT_AUDITED = 0x00;
197 
198     /// @dev const value to indicate the contract is audited and approved
199     uint8 public constant AUDITED_AND_APPROVED = 0x01;
200 
201     /// @dev const value to indicate the contract is audited and rejected
202     uint8 public constant AUDITED_AND_REJECTED = 0x02;
203 
204     /// @dev Maps auditor and code hash to the outcome of the audit of
205     /// the particular contract by the particular auditor.
206     /// Map key is: keccack256(auditor address, contract codeHash)
207     /// @dev codeHash is a sha3 from the contract byte code
208     mapping (bytes32 => uint8) public AuditOutcomes;
209 
210     /// @dev event fired when a contract is sucessfully audited
211     event AuditRegistered(address auditor, bytes32 codeHash, bool isApproved);
212 
213     /// @notice SolidStampRegister constructor
214     /// @dev import audits from the SolidStamp v1 contract deployed to: 0x0aA7A4482780F67c6B2862Bd68CD67A83faCe355
215     /// @param _existingAuditors list of existing auditors
216     /// @param _existingCodeHashes list of existing code hashes
217     /// @param _outcomes list of existing audit outcomes
218     /// @dev each n-th element represents an existing audit conducted by _existingAuditors[n]
219     /// on code hash _existingCodeHashes[n] with an outcome _outcomes[n]
220     constructor(address[] _existingAuditors, bytes32[] _existingCodeHashes, bool[] _outcomes) public {
221         uint noOfExistingAudits = _existingAuditors.length;
222         require(noOfExistingAudits == _existingCodeHashes.length, "paramters mismatch");
223         require(noOfExistingAudits == _outcomes.length, "paramters mismatch");
224 
225         // set contract address temporarily to owner so that registerAuditOutcome does not revert
226         contractSolidStamp = msg.sender;
227         for (uint i=0; i<noOfExistingAudits; i++){
228             registerAuditOutcome(_existingAuditors[i], _existingCodeHashes[i], _outcomes[i]);
229         }
230         contractSolidStamp = 0x0;
231     }
232 
233     function getAuditOutcome(address _auditor, bytes32 _codeHash) public view returns (uint8)
234     {
235         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
236         return AuditOutcomes[hashAuditorCode];
237     }
238 
239     function registerAuditOutcome(address _auditor, bytes32 _codeHash, bool _isApproved) public onlySolidStampContract
240     {
241         require(_auditor != 0x0, "auditor cannot be 0x0");
242         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
243         if ( _isApproved )
244             AuditOutcomes[hashAuditorCode] = AUDITED_AND_APPROVED;
245         else
246             AuditOutcomes[hashAuditorCode] = AUDITED_AND_REJECTED;
247         emit AuditRegistered(_auditor, _codeHash, _isApproved);
248     }
249 
250 
251     event SolidStampContractChanged(address newSolidStamp);
252     /**
253      * @dev Throws if called by any account other than the contractSolidStamp
254      */
255     modifier onlySolidStampContract() {
256       require(msg.sender == contractSolidStamp, "cannot be run by not SolidStamp contract");
257       _;
258     }
259 
260     /**
261      * @dev Transfers control of the registry to a _newSolidStamp.
262      * @param _newSolidStamp The address to transfer control registry to.
263      */
264     function changeSolidStampContract(address _newSolidStamp) public onlyOwner {
265       require(_newSolidStamp != address(0), "SolidStamp contract cannot be 0x0");
266       emit SolidStampContractChanged(_newSolidStamp);
267       contractSolidStamp = _newSolidStamp;
268     }
269 
270 }
271 
272 pragma solidity ^0.4.24;
273 
274 /// @title The main SolidStamp.com contract
275 contract SolidStamp is Ownable, Pausable, Upgradable {
276     using SafeMath for uint;
277 
278     /// @dev const value to indicate the contract is audited and approved
279     uint8 public constant NOT_AUDITED = 0x00;
280 
281     /// @dev minimum amount of time for an audit request
282     uint public constant MIN_AUDIT_TIME = 24 hours;
283 
284     /// @dev maximum amount of time for an audit request
285     uint public constant MAX_AUDIT_TIME = 28 days;
286 
287     /// @dev aggregated amount of audit requests
288     uint public TotalRequestsAmount = 0;
289 
290     // @dev amount of collected commision available to withdraw
291     uint public AvailableCommission = 0;
292 
293     // @dev commission percentage, initially 9%
294     uint public Commission = 9;
295 
296     /// @dev event fired when the service commission is changed
297     event NewCommission(uint commmission);
298 
299     address public SolidStampRegisterAddress;
300 
301     /// @notice SolidStamp constructor
302     constructor(address _addressRegistrySolidStamp) public {
303         SolidStampRegisterAddress = _addressRegistrySolidStamp;
304     }
305 
306     /// @notice Audit request
307     struct AuditRequest {
308         // amount of Ethers offered by a particular requestor for an audit
309         uint amount;
310         // request expiration date
311         uint expireDate;
312     }
313 
314     /// @dev Maps auditor and code hash to the total reward offered for auditing
315     /// the particular contract by the particular auditor.
316     /// Map key is: keccack256(auditor address, contract codeHash)
317     /// @dev codeHash is a sha3 from the contract byte code
318     mapping (bytes32 => uint) public Rewards;
319 
320     /// @dev Maps requestor, auditor and codeHash to an AuditRequest
321     /// Map key is: keccack256(auditor address, requestor address, contract codeHash)
322     mapping (bytes32 => AuditRequest) public AuditRequests;
323 
324     /// @dev event fired upon successul audit request
325     event AuditRequested(address auditor, address bidder, bytes32 codeHash, uint amount, uint expireDate);
326     /// @dev event fired when an request is sucessfully withdrawn
327     event RequestWithdrawn(address auditor, address bidder, bytes32 codeHash, uint amount);
328     /// @dev event fired when a contract is sucessfully audited
329     event ContractAudited(address auditor, bytes32 codeHash, uint reward, bool isApproved);
330 
331     /// @notice registers an audit request
332     /// @param _auditor the address of the auditor the request is directed to
333     /// @param _codeHash the code hash of the contract to audit. _codeHash equals to sha3 of the contract byte-code
334     /// @param _auditTime the amount of time after which the requestor can withdraw the request
335     function requestAudit(address _auditor, bytes32 _codeHash, uint _auditTime)
336     public whenNotPaused payable
337     {
338         require(_auditor != 0x0, "_auditor cannot be 0x0");
339         // audit request cannot expire too quickly or last too long
340         require(_auditTime >= MIN_AUDIT_TIME, "_auditTime should be >= MIN_AUDIT_TIME");
341         require(_auditTime <= MAX_AUDIT_TIME, "_auditTime should be <= MIN_AUDIT_TIME");
342         require(msg.value > 0, "msg.value should be >0");
343 
344         // revert if the contract is already audited by the auditor
345         uint8 outcome = SolidStampRegister(SolidStampRegisterAddress).getAuditOutcome(_auditor, _codeHash);
346         require(outcome == NOT_AUDITED, "contract already audited");
347 
348         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
349         uint currentReward = Rewards[hashAuditorCode];
350         uint expireDate = now.add(_auditTime);
351         Rewards[hashAuditorCode] = currentReward.add(msg.value);
352         TotalRequestsAmount = TotalRequestsAmount.add(msg.value);
353 
354         bytes32 hashAuditorRequestorCode = keccak256(abi.encodePacked(_auditor, msg.sender, _codeHash));
355         AuditRequest storage request = AuditRequests[hashAuditorRequestorCode];
356         if ( request.amount == 0 ) {
357             // first request from msg.sender to audit contract _codeHash by _auditor
358             AuditRequests[hashAuditorRequestorCode] = AuditRequest({
359                 amount : msg.value,
360                 expireDate : expireDate
361             });
362             emit AuditRequested(_auditor, msg.sender, _codeHash, msg.value, expireDate);
363         } else {
364             // Request already exists. Increasing value
365             request.amount = request.amount.add(msg.value);
366             // if new expireDate is later than existing one - increase the existing one
367             if ( expireDate > request.expireDate )
368                 request.expireDate = expireDate;
369             // event returns the total request value and its expireDate
370             emit AuditRequested(_auditor, msg.sender, _codeHash, request.amount, request.expireDate);
371         }
372     }
373 
374     /// @notice withdraws an audit request
375     /// @param _auditor the address of the auditor the request is directed to
376     /// @param _codeHash the code hash of the contract to audit. _codeHash equals to sha3 of the contract byte-code
377     function withdrawRequest(address _auditor, bytes32 _codeHash)
378     public
379     {
380         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
381 
382         // revert if the contract is already audited by the auditor
383         uint8 outcome = SolidStampRegister(SolidStampRegisterAddress).getAuditOutcome(_auditor, _codeHash);
384         require(outcome == NOT_AUDITED, "contract already audited");
385 
386         bytes32 hashAuditorRequestorCode = keccak256(abi.encodePacked(_auditor, msg.sender, _codeHash));
387         AuditRequest storage request = AuditRequests[hashAuditorRequestorCode];
388         require(request.amount > 0, "nothing to withdraw");
389         require(now > request.expireDate, "cannot withdraw before request.expireDate");
390 
391         uint amount = request.amount;
392         delete request.amount;
393         delete request.expireDate;
394         Rewards[hashAuditorCode] = Rewards[hashAuditorCode].sub(amount);
395         TotalRequestsAmount = TotalRequestsAmount.sub(amount);
396         emit RequestWithdrawn(_auditor, msg.sender, _codeHash, amount);
397         msg.sender.transfer(amount);
398     }
399 
400     /// @notice marks contract as audited
401     /// @param _codeHash the code hash of the stamped contract. _codeHash equals to sha3 of the contract byte-code
402     /// @param _isApproved whether the contract is approved or rejected
403     function auditContract(bytes32 _codeHash, bool _isApproved)
404     public whenNotPaused
405     {
406         bytes32 hashAuditorCode = keccak256(abi.encodePacked(msg.sender, _codeHash));
407 
408         // revert if the contract is already audited by the auditor
409         uint8 outcome = SolidStampRegister(SolidStampRegisterAddress).getAuditOutcome(msg.sender, _codeHash);
410         require(outcome == NOT_AUDITED, "contract already audited");
411 
412         SolidStampRegister(SolidStampRegisterAddress).registerAuditOutcome(msg.sender, _codeHash, _isApproved);
413         uint reward = Rewards[hashAuditorCode];
414         TotalRequestsAmount = TotalRequestsAmount.sub(reward);
415         uint commissionKept = calcCommission(reward);
416         AvailableCommission = AvailableCommission.add(commissionKept);
417         emit ContractAudited(msg.sender, _codeHash, reward, _isApproved);
418         msg.sender.transfer(reward.sub(commissionKept));
419     }
420 
421     /// @dev const value to indicate the maximum commision service owner can set
422     uint public constant MAX_COMMISSION = 33;
423 
424     /// @notice ability for owner to change the service commmission
425     /// @param _newCommission new commision percentage
426     function changeCommission(uint _newCommission) public onlyOwner whenNotPaused {
427         require(_newCommission <= MAX_COMMISSION, "commission should be <= MAX_COMMISSION");
428         require(_newCommission != Commission, "_newCommission==Commmission");
429         Commission = _newCommission;
430         emit NewCommission(Commission);
431     }
432 
433     /// @notice calculates the SolidStamp commmission
434     /// @param _amount amount to calcuate the commission from
435     function calcCommission(uint _amount) private view returns(uint) {
436         return _amount.mul(Commission)/100; // service commision
437     }
438 
439     /// @notice ability for owner to withdraw the commission
440     /// @param _amount amount to withdraw
441     function withdrawCommission(uint _amount) public onlyOwner {
442         // cannot withdraw money reserved for requests
443         require(_amount <= AvailableCommission, "Cannot withdraw more than available");
444         AvailableCommission = AvailableCommission.sub(_amount);
445         msg.sender.transfer(_amount);
446     }
447 
448     /// @dev Override unpause so we can't have newContractAddress set,
449     ///  because then the contract was upgraded.
450     /// @notice This is public rather than external so we can call super.unpause
451     ///  without using an expensive CALL.
452     function unpause() public onlyOwner whenPaused {
453         require(newContractAddress == address(0), "new contract cannot be 0x0");
454 
455         // Actually unpause the contract.
456         super.unpause();
457     }
458 
459     /// @notice We don't welcome tips & donations
460     function() payable public {
461         revert();
462     }
463 }