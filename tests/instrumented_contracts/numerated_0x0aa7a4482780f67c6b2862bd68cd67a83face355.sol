1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     emit Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     emit Unpause();
85   }
86 }
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     if (a == 0) {
99       return 0;
100     }
101     c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     // uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return a / b;
114   }
115 
116   /**
117   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
128     c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134 pragma solidity ^0.4.23;
135 
136 
137 contract Upgradable is Ownable, Pausable {
138     // Set in case the core contract is broken and an upgrade is required
139     address public newContractAddress;
140 
141     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
142     event ContractUpgrade(address newContract);
143 
144     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
145     ///  breaking bug. This method does nothing but keep track of the new contract and
146     ///  emit a message indicating that the new address is set. It's up to clients of this
147     ///  contract to update to the new contract address in that case. (This contract will
148     ///  be paused indefinitely if such an upgrade takes place.)
149     /// @param _v2Address new address
150     function setNewAddress(address _v2Address) external onlyOwner whenPaused {
151         require(_v2Address != 0x0);
152         newContractAddress = _v2Address;
153         emit ContractUpgrade(_v2Address);
154     }
155 
156 }
157 
158 /// @title The main SolidStamp.com contract
159 contract SolidStamp is Ownable, Pausable, Upgradable {
160     using SafeMath for uint;
161 
162     /// @dev const value to indicate the contract is audited and approved
163     uint8 public constant NOT_AUDITED = 0x00;
164 
165     /// @dev const value to indicate the contract is audited and approved
166     uint8 public constant AUDITED_AND_APPROVED = 0x01;
167 
168     /// @dev const value to indicate the contract is audited and rejected
169     uint8 public constant AUDITED_AND_REJECTED = 0x02;
170 
171     /// @dev minimum amount of time for an audit request
172     uint public constant MIN_AUDIT_TIME = 24 hours;
173 
174     /// @dev maximum amount of time for an audit request
175     uint public constant MAX_AUDIT_TIME = 28 days;
176 
177     /// @dev aggregated amount of audit requests
178     uint public totalRequestsAmount = 0;
179 
180     // @dev amount of collected commision available to withdraw
181     uint public availableCommission = 0;
182 
183     // @dev commission percentage, initially 9%
184     uint public commission = 9;
185 
186     /// @dev event fired when the service commission is changed
187     event NewCommission(uint commmission);
188 
189     /// @notice SolidStamp constructor
190     constructor() public {
191     }
192 
193     /// @notice Audit request
194     struct AuditRequest {
195         // amount of Ethers offered by a particular requestor for an audit
196         uint amount;
197         // request expiration date
198         uint expireDate;
199     }
200 
201     /// @dev Maps auditor and code hash to the total reward offered for auditing
202     /// the particular contract by the particular auditor.
203     /// Map key is: keccack256(auditor address, contract codeHash)
204     /// @dev codeHash is a sha3 from the contract byte code
205     mapping (bytes32 => uint) public rewards;
206 
207     /// @dev Maps auditor and code hash to the outcome of the audit of
208     /// the particular contract by the particular auditor.
209     /// Map key is: keccack256(auditor address, contract codeHash)
210     /// @dev codeHash is a sha3 from the contract byte code
211     mapping (bytes32 => uint8) public auditOutcomes;
212 
213     /// @dev Maps requestor, auditor and codeHash to an AuditRequest
214     /// Map key is: keccack256(auditor address, requestor address, contract codeHash)
215     mapping (bytes32 => AuditRequest) public auditRequests;
216 
217     /// @dev event fired upon successul audit request
218     event AuditRequested(address auditor, address bidder, bytes32 codeHash, uint amount, uint expireDate);
219     /// @dev event fired when an request is sucessfully withdrawn
220     event RequestWithdrawn(address auditor, address bidder, bytes32 codeHash, uint amount);
221     /// @dev event fired when a contract is sucessfully audited
222     event ContractAudited(address auditor, bytes32 codeHash, uint reward, bool isApproved);
223 
224     /// @notice registers an audit request
225     /// @param _auditor the address of the auditor the request is directed to
226     /// @param _codeHash the code hash of the contract to audit. _codeHash equals to sha3 of the contract byte-code
227     /// @param _auditTime the amount of time after which the requestor can withdraw the request
228     function requestAudit(address _auditor, bytes32 _codeHash, uint _auditTime)
229     public whenNotPaused payable
230     {
231         require(_auditor != 0x0);
232         // audit request cannot expire too quickly or last too long
233         require(_auditTime >= MIN_AUDIT_TIME);
234         require(_auditTime <= MAX_AUDIT_TIME);
235         require(msg.value > 0);
236 
237         bytes32 hashAuditorCode = keccak256(_auditor, _codeHash);
238 
239         // revert if the contract is already audited by the auditor
240         uint8 outcome = auditOutcomes[hashAuditorCode];
241         require(outcome == NOT_AUDITED);
242 
243         uint currentReward = rewards[hashAuditorCode];
244         uint expireDate = now.add(_auditTime);
245         rewards[hashAuditorCode] = currentReward.add(msg.value);
246         totalRequestsAmount = totalRequestsAmount.add(msg.value);
247 
248         bytes32 hashAuditorRequestorCode = keccak256(_auditor, msg.sender, _codeHash);
249         AuditRequest storage request = auditRequests[hashAuditorRequestorCode];
250         if ( request.amount == 0 ) {
251             // first request from msg.sender to audit contract _codeHash by _auditor
252             auditRequests[hashAuditorRequestorCode] = AuditRequest({
253                 amount : msg.value,
254                 expireDate : expireDate
255             });
256             emit AuditRequested(_auditor, msg.sender, _codeHash, msg.value, expireDate);
257         } else {
258             // Request already exists. Increasing value
259             request.amount = request.amount.add(msg.value);
260             // if new expireDate is later than existing one - increase the existing one
261             if ( expireDate > request.expireDate )
262                 request.expireDate = expireDate;
263             // event returns the total request value and its expireDate
264             emit AuditRequested(_auditor, msg.sender, _codeHash, request.amount, request.expireDate);
265         }
266     }
267 
268     /// @notice withdraws an audit request
269     /// @param _auditor the address of the auditor the request is directed to
270     /// @param _codeHash the code hash of the contract to audit. _codeHash equals to sha3 of the contract byte-code
271     function withdrawRequest(address _auditor, bytes32 _codeHash)
272     public
273     {
274         bytes32 hashAuditorCode = keccak256(_auditor, _codeHash);
275 
276         // revert if the contract is already audited by the auditor
277         uint8 outcome = auditOutcomes[hashAuditorCode];
278         require(outcome == NOT_AUDITED);
279 
280         bytes32 hashAuditorRequestorCode = keccak256(_auditor, msg.sender, _codeHash);
281         AuditRequest storage request = auditRequests[hashAuditorRequestorCode];
282         require(request.amount > 0);
283         require(now > request.expireDate);
284 
285         uint amount = request.amount;
286         delete request.amount;
287         delete request.expireDate;
288         rewards[hashAuditorCode] = rewards[hashAuditorCode].sub(amount);
289         totalRequestsAmount = totalRequestsAmount.sub(amount);
290         emit RequestWithdrawn(_auditor, msg.sender, _codeHash, amount);
291         msg.sender.transfer(amount);
292     }
293 
294     /// @notice marks contract as audited
295     /// @param _codeHash the code hash of the stamped contract. _codeHash equals to sha3 of the contract byte-code
296     /// @param _isApproved whether the contract is approved or rejected
297     function auditContract(bytes32 _codeHash, bool _isApproved)
298     public whenNotPaused
299     {
300         bytes32 hashAuditorCode = keccak256(msg.sender, _codeHash);
301 
302         // revert if the contract is already audited by the auditor
303         uint8 outcome = auditOutcomes[hashAuditorCode];
304         require(outcome == NOT_AUDITED);
305 
306         if ( _isApproved )
307             auditOutcomes[hashAuditorCode] = AUDITED_AND_APPROVED;
308         else
309             auditOutcomes[hashAuditorCode] = AUDITED_AND_REJECTED;
310         uint reward = rewards[hashAuditorCode];
311         totalRequestsAmount = totalRequestsAmount.sub(reward);
312         commission = calcCommission(reward);
313         availableCommission = availableCommission.add(commission);
314         emit ContractAudited(msg.sender, _codeHash, reward, _isApproved);
315         msg.sender.transfer(reward.sub(commission));
316     }
317 
318     /// @dev const value to indicate the maximum commision service owner can set
319     uint public constant MAX_COMMISION = 33;
320 
321     /// @notice ability for owner to change the service commmission
322     /// @param _newCommission new commision percentage
323     function changeCommission(uint _newCommission) public onlyOwner whenNotPaused {
324         require(_newCommission <= MAX_COMMISION);
325         require(_newCommission != commission);
326         commission = _newCommission;
327         emit NewCommission(commission);
328     }
329 
330     /// @notice calculates the SolidStamp commmission
331     /// @param _amount amount to calcuate the commission from
332     function calcCommission(uint _amount) private view returns(uint) {
333         return _amount.mul(commission)/100; // service commision
334     }
335 
336     /// @notice ability for owner to withdraw the commission
337     /// @param _amount amount to withdraw
338     function withdrawCommission(uint _amount) public onlyOwner {
339         // cannot withdraw money reserved for requests
340         require(_amount <= availableCommission);
341         availableCommission = availableCommission.sub(_amount);
342         msg.sender.transfer(_amount);
343     }
344 
345     /// @dev Override unpause so we can't have newContractAddress set,
346     ///  because then the contract was upgraded.
347     /// @notice This is public rather than external so we can call super.unpause
348     ///  without using an expensive CALL.
349     function unpause() public onlyOwner whenPaused {
350         require(newContractAddress == address(0));
351 
352         // Actually unpause the contract.
353         super.unpause();
354     }
355 
356     /// @notice We don't welcome tips & donations
357     function() payable public {
358         revert();
359     }
360 }