1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 
68 
69 
70 
71 /**
72  * @title Pausable
73  * @dev Base contract which allows children to implement an emergency stop mechanism.
74  */
75 contract Pausable is Ownable {
76   event Pause();
77   event Unpause();
78 
79   bool public paused = false;
80 
81 
82   /**
83    * @dev Modifier to make a function callable only when the contract is not paused.
84    */
85   modifier whenNotPaused() {
86     require(!paused);
87     _;
88   }
89 
90   /**
91    * @dev Modifier to make a function callable only when the contract is paused.
92    */
93   modifier whenPaused() {
94     require(paused);
95     _;
96   }
97 
98   /**
99    * @dev called by the owner to pause, triggers stopped state
100    */
101   function pause() public onlyOwner whenNotPaused {
102     paused = true;
103     emit Pause();
104   }
105 
106   /**
107    * @dev called by the owner to unpause, returns to normal state
108    */
109   function unpause() public onlyOwner whenPaused {
110     paused = false;
111     emit Unpause();
112   }
113 }
114 
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that throw on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, throws on overflow.
124   */
125   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
126     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
127     // benefit is lost if 'b' is also tested.
128     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129     if (_a == 0) {
130       return 0;
131     }
132 
133     c = _a * _b;
134     assert(c / _a == _b);
135     return c;
136   }
137 
138   /**
139   * @dev Integer division of two numbers, truncating the quotient.
140   */
141   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
142     // assert(_b > 0); // Solidity automatically throws when dividing by 0
143     // uint256 c = _a / _b;
144     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
145     return _a / _b;
146   }
147 
148   /**
149   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
150   */
151   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
152     assert(_b <= _a);
153     return _a - _b;
154   }
155 
156   /**
157   * @dev Adds two numbers, throws on overflow.
158   */
159   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
160     c = _a + _b;
161     assert(c >= _a);
162     return c;
163   }
164 }
165 
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
188 /// @title The main SolidStamp.com contract
189 contract SolidStamp is Ownable, Pausable, Upgradable {
190     using SafeMath for uint;
191 
192     /// @dev const value to indicate the contract is audited and approved
193     uint8 public constant NOT_AUDITED = 0x00;
194 
195     /// @dev minimum amount of time for an audit request
196     uint public constant MIN_AUDIT_TIME = 24 hours;
197 
198     /// @dev maximum amount of time for an audit request
199     uint public constant MAX_AUDIT_TIME = 28 days;
200 
201     /// @dev aggregated amount of audit requests
202     uint public TotalRequestsAmount = 0;
203 
204     // @dev amount of collected commision available to withdraw
205     uint public AvailableCommission = 0;
206 
207     // @dev commission percentage, initially 1%
208     uint public Commission = 1;
209 
210     /// @dev event fired when the service commission is changed
211     event NewCommission(uint commmission);
212 
213     address public SolidStampRegisterAddress;
214 
215     /// @notice SolidStamp constructor
216     constructor(address _addressRegistrySolidStamp) public {
217         SolidStampRegisterAddress = _addressRegistrySolidStamp;
218     }
219 
220     /// @notice Audit request
221     struct AuditRequest {
222         // amount of Ethers offered by a particular requestor for an audit
223         uint amount;
224         // request expiration date
225         uint expireDate;
226     }
227 
228     /// @dev Maps auditor and code hash to the total reward offered for auditing
229     /// the particular contract by the particular auditor.
230     /// Map key is: keccack256(auditor address, contract codeHash)
231     /// @dev codeHash is a sha3 from the contract byte code
232     mapping (bytes32 => uint) public Rewards;
233 
234     /// @dev Maps requestor, auditor and codeHash to an AuditRequest
235     /// Map key is: keccack256(auditor address, requestor address, contract codeHash)
236     mapping (bytes32 => AuditRequest) public AuditRequests;
237 
238     /// @dev event fired upon successul audit request
239     event AuditRequested(address auditor, address bidder, bytes32 codeHash, uint amount, uint expireDate);
240     /// @dev event fired when an request is sucessfully withdrawn
241     event RequestWithdrawn(address auditor, address bidder, bytes32 codeHash, uint amount);
242     /// @dev event fired when a contract is sucessfully audited
243     event ContractAudited(address auditor, bytes32 codeHash, bytes reportIPFS, bool isApproved, uint reward);
244 
245     /// @notice registers an audit request
246     /// @param _auditor the address of the auditor the request is directed to
247     /// @param _codeHash the code hash of the contract to audit. _codeHash equals to sha3 of the contract byte-code
248     /// @param _auditTime the amount of time after which the requestor can withdraw the request
249     function requestAudit(address _auditor, bytes32 _codeHash, uint _auditTime)
250     public whenNotPaused payable
251     {
252         require(_auditor != 0x0, "_auditor cannot be 0x0");
253         // audit request cannot expire too quickly or last too long
254         require(_auditTime >= MIN_AUDIT_TIME, "_auditTime should be >= MIN_AUDIT_TIME");
255         require(_auditTime <= MAX_AUDIT_TIME, "_auditTime should be <= MIN_AUDIT_TIME");
256         require(msg.value > 0, "msg.value should be >0");
257 
258         // revert if the contract is already audited by the auditor
259         uint8 outcome = SolidStampRegister(SolidStampRegisterAddress).getAuditOutcome(_auditor, _codeHash);
260         require(outcome == NOT_AUDITED, "contract already audited");
261 
262         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
263         uint currentReward = Rewards[hashAuditorCode];
264         uint expireDate = now.add(_auditTime);
265         Rewards[hashAuditorCode] = currentReward.add(msg.value);
266         TotalRequestsAmount = TotalRequestsAmount.add(msg.value);
267 
268         bytes32 hashAuditorRequestorCode = keccak256(abi.encodePacked(_auditor, msg.sender, _codeHash));
269         AuditRequest storage request = AuditRequests[hashAuditorRequestorCode];
270         if ( request.amount == 0 ) {
271             // first request from msg.sender to audit contract _codeHash by _auditor
272             AuditRequests[hashAuditorRequestorCode] = AuditRequest({
273                 amount : msg.value,
274                 expireDate : expireDate
275             });
276             emit AuditRequested(_auditor, msg.sender, _codeHash, msg.value, expireDate);
277         } else {
278             // Request already exists. Increasing value
279             request.amount = request.amount.add(msg.value);
280             // if new expireDate is later than existing one - increase the existing one
281             if ( expireDate > request.expireDate )
282                 request.expireDate = expireDate;
283             // event returns the total request value and its expireDate
284             emit AuditRequested(_auditor, msg.sender, _codeHash, request.amount, request.expireDate);
285         }
286     }
287 
288     /// @notice withdraws an audit request
289     /// @param _auditor the address of the auditor the request is directed to
290     /// @param _codeHash the code hash of the contract to audit. _codeHash equals to sha3 of the contract byte-code
291     function withdrawRequest(address _auditor, bytes32 _codeHash)
292     public
293     {
294         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
295 
296         // revert if the contract is already audited by the auditor
297         uint8 outcome = SolidStampRegister(SolidStampRegisterAddress).getAuditOutcome(_auditor, _codeHash);
298         require(outcome == NOT_AUDITED, "contract already audited");
299 
300         bytes32 hashAuditorRequestorCode = keccak256(abi.encodePacked(_auditor, msg.sender, _codeHash));
301         AuditRequest storage request = AuditRequests[hashAuditorRequestorCode];
302         require(request.amount > 0, "nothing to withdraw");
303         require(now > request.expireDate, "cannot withdraw before request.expireDate");
304 
305         uint amount = request.amount;
306         delete request.amount;
307         delete request.expireDate;
308         Rewards[hashAuditorCode] = Rewards[hashAuditorCode].sub(amount);
309         TotalRequestsAmount = TotalRequestsAmount.sub(amount);
310         emit RequestWithdrawn(_auditor, msg.sender, _codeHash, amount);
311         msg.sender.transfer(amount);
312     }
313 
314     /// @notice transfers reward to the auditor. Called by SolidStampRegister after the contract is audited
315     /// @param _auditor the auditor who audited the contract
316     /// @param _codeHash the code hash of the stamped contract. _codeHash equals to sha3 of the contract byte-code
317     /// @param _reportIPFS IPFS hash of the audit report
318     /// @param _isApproved whether the contract is approved or rejected
319     function auditContract(address _auditor, bytes32 _codeHash, bytes _reportIPFS, bool _isApproved)
320     public whenNotPaused onlySolidStampRegisterContract
321     {
322         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
323         uint reward = Rewards[hashAuditorCode];
324         TotalRequestsAmount = TotalRequestsAmount.sub(reward);
325         uint commissionKept = calcCommission(reward);
326         AvailableCommission = AvailableCommission.add(commissionKept);
327         emit ContractAudited(_auditor, _codeHash, _reportIPFS, _isApproved, reward);
328         _auditor.transfer(reward.sub(commissionKept));
329     }
330 
331     /**
332      * @dev Throws if called by any account other than the contractSolidStamp
333      */
334     modifier onlySolidStampRegisterContract() {
335       require(msg.sender == SolidStampRegisterAddress, "can be only run by SolidStampRegister contract");
336       _;
337     }
338 
339     /// @dev const value to indicate the maximum commision service owner can set
340     uint public constant MAX_COMMISSION = 9;
341 
342     /// @notice ability for owner to change the service commmission
343     /// @param _newCommission new commision percentage
344     function changeCommission(uint _newCommission) public onlyOwner whenNotPaused {
345         require(_newCommission <= MAX_COMMISSION, "commission should be <= MAX_COMMISSION");
346         require(_newCommission != Commission, "_newCommission==Commmission");
347         Commission = _newCommission;
348         emit NewCommission(Commission);
349     }
350 
351     /// @notice calculates the SolidStamp commmission
352     /// @param _amount amount to calcuate the commission from
353     function calcCommission(uint _amount) private view returns(uint) {
354         return _amount.mul(Commission)/100; // service commision
355     }
356 
357     /// @notice ability for owner to withdraw the commission
358     /// @param _amount amount to withdraw
359     function withdrawCommission(uint _amount) public onlyOwner {
360         // cannot withdraw money reserved for requests
361         require(_amount <= AvailableCommission, "Cannot withdraw more than available");
362         AvailableCommission = AvailableCommission.sub(_amount);
363         msg.sender.transfer(_amount);
364     }
365 
366     /// @dev Override unpause so we can't have newContractAddress set,
367     ///  because then the contract was upgraded.
368     /// @notice This is public rather than external so we can call super.unpause
369     ///  without using an expensive CALL.
370     function unpause() public onlyOwner whenPaused {
371         require(newContractAddress == address(0), "new contract cannot be 0x0");
372 
373         // Actually unpause the contract.
374         super.unpause();
375     }
376 
377     /// @notice We don't want your arbitrary ether
378     function() payable public {
379         revert();
380     }
381 }
382 
383 contract SolidStampRegister is Ownable
384 {
385 /// @dev address of the current SolidStamp contract which can add audits
386     address public ContractSolidStamp;
387 
388     /// @dev const value to indicate the contract is not audited
389     uint8 public constant NOT_AUDITED = 0x00;
390 
391     /// @dev const value to indicate the contract is audited and approved
392     uint8 public constant AUDITED_AND_APPROVED = 0x01;
393 
394     /// @dev const value to indicate the contract is audited and rejected
395     uint8 public constant AUDITED_AND_REJECTED = 0x02;
396 
397     /// @dev struct representing the audit report and the audit outcome
398     struct Audit {
399         /// @dev AUDITED_AND_APPROVED or AUDITED_AND_REJECTED
400         uint8 outcome;
401         /// @dev IPFS hash of the audit report
402         bytes reportIPFS;
403     }
404 
405     /// @dev Maps auditor and code hash to the Audit struct.
406     /// Map key is: keccack256(auditor address, contract codeHash)
407     /// @dev codeHash is a sha3 from the contract byte code
408     mapping (bytes32 => Audit) public Audits;
409 
410     /// @dev event fired when a contract is sucessfully audited
411     event AuditRegistered(address auditor, bytes32 codeHash, bytes reportIPFS, bool isApproved);
412 
413     /// @notice SolidStampRegister constructor
414     constructor() public {
415     }
416 
417     /// @notice returns the outcome of the audit or NOT_AUDITED (0) if none
418     /// @param _auditor audtior address
419     /// @param _codeHash contract code-hash
420     function getAuditOutcome(address _auditor, bytes32 _codeHash) public view returns (uint8)
421     {
422         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
423         return Audits[hashAuditorCode].outcome;
424     }
425 
426     /// @notice returns the audit report IPFS of the audit or 0x0 if none
427     /// @param _auditor audtior address
428     /// @param _codeHash contract code-hash
429     function getAuditReportIPFS(address _auditor, bytes32 _codeHash) public view returns (bytes)
430     {
431         bytes32 hashAuditorCode = keccak256(abi.encodePacked(_auditor, _codeHash));
432         return Audits[hashAuditorCode].reportIPFS;
433     }
434 
435     /// @notice marks contract as audited
436     /// @param _codeHash the code hash of the stamped contract. _codeHash equals to sha3 of the contract byte-code
437     /// @param _reportIPFS IPFS hash of the audit report
438     /// @param _isApproved whether the contract is approved or rejected
439     function registerAudit(bytes32 _codeHash, bytes _reportIPFS, bool _isApproved) public
440     {
441         require(_codeHash != 0x0, "codeHash cannot be 0x0");
442         require(_reportIPFS.length != 0x0, "report IPFS cannot be 0x0");
443         bytes32 hashAuditorCode = keccak256(abi.encodePacked(msg.sender, _codeHash));
444 
445         Audit storage audit = Audits[hashAuditorCode];
446         require(audit.outcome == NOT_AUDITED, "already audited");
447 
448         if ( _isApproved )
449             audit.outcome = AUDITED_AND_APPROVED;
450         else
451             audit.outcome = AUDITED_AND_REJECTED;
452         audit.reportIPFS = _reportIPFS;
453         SolidStamp(ContractSolidStamp).auditContract(msg.sender, _codeHash, _reportIPFS, _isApproved);
454         emit AuditRegistered(msg.sender, _codeHash, _reportIPFS, _isApproved);
455     }
456 
457     /// @notice marks multiple contracts as audited
458     /// @param _codeHashes the code hashes of the stamped contracts. each _codeHash equals to sha3 of the contract byte-code
459     /// @param _reportIPFS IPFS hash of the audit report
460     /// @param _isApproved whether the contracts are approved or rejected
461     function registerAudits(bytes32[] _codeHashes, bytes _reportIPFS, bool _isApproved) public
462     {
463         for(uint i=0; i<_codeHashes.length; i++ )
464         {
465             registerAudit(_codeHashes[i], _reportIPFS, _isApproved);
466         }
467     }
468 
469 
470     event SolidStampContractChanged(address newSolidStamp);
471 
472     /// @dev Transfers SolidStamp contract a _newSolidStamp.
473     /// @param _newSolidStamp The address to transfer SolidStamp address to.
474     function changeSolidStampContract(address _newSolidStamp) public onlyOwner {
475       require(_newSolidStamp != address(0), "SolidStamp contract cannot be 0x0");
476       emit SolidStampContractChanged(_newSolidStamp);
477       ContractSolidStamp = _newSolidStamp;
478     }
479 
480     /// @notice We don't want your arbitrary ether
481     function() payable public {
482         revert();
483     }    
484 }