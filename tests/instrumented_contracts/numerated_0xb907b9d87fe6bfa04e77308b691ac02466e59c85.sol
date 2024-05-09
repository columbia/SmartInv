1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title Hodler
5  * @dev Handles hodler reward, TokenController should create and own it.
6  */
7 
8 /**
9  * @title ERC20
10  * @dev ERC20 interface
11  */
12 contract ERC20 {
13     function balanceOf(address who) public view returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     function allowance(address owner, address spender) public view returns (uint256);
16     function transferFrom(address from, address to, uint256 value) public returns (bool);
17     function approve(address spender, uint256 value) public returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27   address public owner;
28   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() {
34     owner = msg.sender;
35   }
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) onlyOwner public {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 }
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a * b;
60     assert(a == 0 || c / a == b);
61     return c;
62   }
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 contract Controlled {
80     /// @notice The address of the controller is the only address that can call
81     ///  a function with this modifier
82     modifier onlyController { require(msg.sender == controller); _; }
83     address public controller;
84     function Controlled() public { controller = msg.sender;}
85     /// @notice Changes the controller of the contract
86     /// @param _newController The new controller of the contract
87     function changeController(address _newController) public onlyController {
88         controller = _newController;
89     }
90 }
91 /**
92  * @title MiniMe interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20MiniMe is ERC20, Controlled {
96     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool);
97     function totalSupply() public view returns (uint);
98     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint);
99     function totalSupplyAt(uint _blockNumber) public view returns(uint);
100     function createCloneToken(string _cloneTokenName, uint8 _cloneDecimalUnits, string _cloneTokenSymbol, uint _snapshotBlock, bool _transfersEnabled) public returns(address);
101     function generateTokens(address _owner, uint _amount) public returns (bool);
102     function destroyTokens(address _owner, uint _amount)  public returns (bool);
103     function enableTransfers(bool _transfersEnabled) public;
104     function isContract(address _addr) internal view returns(bool);
105     function claimTokens(address _token) public;
106     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
107     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
108 }
109 /// @dev The token controller contract must implement these functions
110 contract TokenController {
111     ERC20MiniMe public ethealToken;
112     address public SALE; // address where sale tokens are located
113     /// @notice needed for hodler handling
114     function addHodlerStake(address _beneficiary, uint _stake) public;
115     function setHodlerStake(address _beneficiary, uint256 _stake) public;
116     function setHodlerTime(uint256 _time) public;
117     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
118     /// @param _owner The address that sent the ether to create tokens
119     /// @return True if the ether is accepted, false if it throws
120     function proxyPayment(address _owner) public payable returns(bool);
121     /// @notice Notifies the controller about a token transfer allowing the
122     ///  controller to react if desired
123     /// @param _from The origin of the transfer
124     /// @param _to The destination of the transfer
125     /// @param _amount The amount of the transfer
126     /// @return False if the controller does not authorize the transfer
127     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
128     /// @notice Notifies the controller about an approval allowing the
129     ///  controller to react if desired
130     /// @param _owner The address that calls `approve()`
131     /// @param _spender The spender in the `approve()` call
132     /// @param _amount The amount in the `approve()` call
133     /// @return False if the controller does not authorize the approval
134     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
135 }
136 /**
137  * @title Hodler
138  * @dev Handles hodler reward, TokenController should create and own it.
139  */
140 contract EthealHodler is Ownable {
141     using SafeMath for uint;
142 
143     // HODLER reward tracker
144     // stake amount per address
145     struct HODL {
146         uint256 stake;
147         // moving ANY funds invalidates hodling of the address
148         bool invalid;
149         bool claimed3M;
150         bool claimed6M;
151         bool claimed9M;
152     }
153 
154     mapping (address => HODL) public hodlerStakes;
155 
156     // total current staking value and hodler addresses
157     uint256 public hodlerTotalValue;
158     uint256 public hodlerTotalCount;
159 
160     // store dates and total stake values for 3 - 6 - 9 months after normal sale
161     uint256 public hodlerTotalValue3M;
162     uint256 public hodlerTotalValue6M;
163     uint256 public hodlerTotalValue9M;
164     uint256 public hodlerTimeStart;
165     uint256 public hodlerTime3M;
166     uint256 public hodlerTime6M;
167     uint256 public hodlerTime9M;
168 
169     // reward HEAL token amount
170     uint256 public TOKEN_HODL_3M;
171     uint256 public TOKEN_HODL_6M;
172     uint256 public TOKEN_HODL_9M;
173 
174     // total amount of tokens claimed so far
175     uint256 public claimedTokens;
176 
177     
178     event LogHodlSetStake(address indexed _setter, address indexed _beneficiary, uint256 _value);
179     event LogHodlClaimed(address indexed _setter, address indexed _beneficiary, uint256 _value);
180     event LogHodlStartSet(address indexed _setter, uint256 _time);
181 
182 
183     /// @dev Only before hodl is started
184     modifier beforeHodlStart() {
185         if (hodlerTimeStart == 0 || now <= hodlerTimeStart)
186             _;
187     }
188 
189     /// @dev Contructor, it should be created by a TokenController
190     function EthealHodler(uint256 _stake3m, uint256 _stake6m, uint256 _stake9m) {
191         TOKEN_HODL_3M = _stake3m;
192         TOKEN_HODL_6M = _stake6m;
193         TOKEN_HODL_9M = _stake9m;
194     }
195 
196     /// @notice Adding hodler stake to an account
197     /// @dev Only owner contract can call it and before hodling period starts
198     /// @param _beneficiary Recepient address of hodler stake
199     /// @param _stake Amount of additional hodler stake
200     function addHodlerStake(address _beneficiary, uint256 _stake) public onlyOwner beforeHodlStart {
201         // real change and valid _beneficiary is needed
202         if (_stake == 0 || _beneficiary == address(0))
203             return;
204         
205         // add stake and maintain count
206         if (hodlerStakes[_beneficiary].stake == 0)
207             hodlerTotalCount = hodlerTotalCount.add(1);
208 
209         hodlerStakes[_beneficiary].stake = hodlerStakes[_beneficiary].stake.add(_stake);
210 
211         hodlerTotalValue = hodlerTotalValue.add(_stake);
212 
213         LogHodlSetStake(msg.sender, _beneficiary, hodlerStakes[_beneficiary].stake);
214     }
215 
216     /// @notice Add hodler stake for multiple addresses
217     function addManyHodlerStake(address[] _addr, uint256[] _stake) public onlyOwner beforeHodlStart {
218         require(_addr.length == _stake.length);
219 
220         for (uint256 i = 0; i < _addr.length; i++) {
221             addHodlerStake(_addr[i], _stake[i]);
222         }
223     }
224 
225     /// @notice Setting hodler stake of an account
226     /// @dev Only owner contract can call it and before hodling period starts
227     /// @param _beneficiary Recepient address of hodler stake
228     /// @param _stake Amount to set the hodler stake
229     function setHodlerStake(address _beneficiary, uint256 _stake) public onlyOwner beforeHodlStart {
230         // real change and valid _beneficiary is needed
231         if (hodlerStakes[_beneficiary].stake == _stake || _beneficiary == address(0))
232             return;
233         
234         // add stake and maintain count
235         if (hodlerStakes[_beneficiary].stake == 0 && _stake > 0) {
236             hodlerTotalCount = hodlerTotalCount.add(1);
237         } else if (hodlerStakes[_beneficiary].stake > 0 && _stake == 0) {
238             hodlerTotalCount = hodlerTotalCount.sub(1);
239         }
240 
241         uint256 _diff = _stake > hodlerStakes[_beneficiary].stake ? _stake.sub(hodlerStakes[_beneficiary].stake) : hodlerStakes[_beneficiary].stake.sub(_stake);
242         if (_stake > hodlerStakes[_beneficiary].stake) {
243             hodlerTotalValue = hodlerTotalValue.add(_diff);
244         } else {
245             hodlerTotalValue = hodlerTotalValue.sub(_diff);
246         }
247         hodlerStakes[_beneficiary].stake = _stake;
248 
249         LogHodlSetStake(msg.sender, _beneficiary, _stake);
250     }
251 
252     /// @notice Set hodler stake for multiple addresses
253     function setManyHodlerStake(address[] _addr, uint256[] _stake) public onlyOwner beforeHodlStart {
254         require(_addr.length == _stake.length);
255 
256         for (uint256 i = 0; i < _addr.length; i++) {
257             setHodlerStake(_addr[i], _stake[i]);
258         }
259     }
260 
261     /// @notice Setting hodler start period.
262     /// @param _time The time when hodler reward starts counting
263     function setHodlerTime(uint256 _time) public onlyOwner beforeHodlStart {
264         // since we had to redeploy the contract
265         // require(_time >= now);
266 
267         hodlerTimeStart = _time;
268         hodlerTime3M = _time.add(90 days);
269         hodlerTime6M = _time.add(180 days);
270         hodlerTime9M = _time.add(270 days);
271 
272         LogHodlStartSet(msg.sender, _time);
273     }
274 
275     /// @notice Invalidates hodler account 
276     /// @dev Gets called by EthealController#onTransfer before every transaction
277     function invalidate(address _account) public onlyOwner {
278         if (hodlerStakes[_account].stake > 0 && !hodlerStakes[_account].invalid) {
279             // claim before invalidating if there is something to claim
280             claimHodlRewardFor(_account);
281 
282             // invalidate stake
283             hodlerStakes[_account].invalid = true;
284             hodlerTotalValue = hodlerTotalValue.sub(hodlerStakes[_account].stake);
285             hodlerTotalCount = hodlerTotalCount.sub(1);
286         } else {
287             // update hodl total values "automatically" - whenever someone sends funds
288             updateAndGetHodlTotalValue();
289         }
290     }
291 
292     /// @notice Claiming HODL reward for msg.sender
293     function claimHodlReward() public {
294         claimHodlRewardFor(msg.sender);
295     }
296 
297     /// @notice Claiming HODL reward for an address
298     function claimHodlRewardFor(address _beneficiary) public {
299         // only when the address has a valid stake
300         require(hodlerStakes[_beneficiary].stake > 0 && !hodlerStakes[_beneficiary].invalid);
301 
302         uint256 _stake = 0;
303         
304         // update hodl total values
305         updateAndGetHodlTotalValue();
306 
307         // claim hodl if not claimed
308         if (!hodlerStakes[_beneficiary].claimed3M && now >= hodlerTime3M) {
309             _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_3M).div(hodlerTotalValue3M));
310             hodlerStakes[_beneficiary].claimed3M = true;
311         }
312         if (!hodlerStakes[_beneficiary].claimed6M && now >= hodlerTime6M) {
313             _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_6M).div(hodlerTotalValue6M));
314             hodlerStakes[_beneficiary].claimed6M = true;
315         }
316         if (!hodlerStakes[_beneficiary].claimed9M && now >= hodlerTime9M) {
317             _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_9M).div(hodlerTotalValue9M));
318             hodlerStakes[_beneficiary].claimed9M = true;
319         }
320 
321         if (_stake > 0) {
322             // increasing claimed tokens
323             claimedTokens = claimedTokens.add(_stake);
324 
325             // transferring tokens
326             require(TokenController(owner).ethealToken().transfer(_beneficiary, _stake));
327 
328             // log
329             LogHodlClaimed(msg.sender, _beneficiary, _stake);
330         }
331     }
332 
333     /// @notice claimHodlRewardFor() for multiple addresses
334     /// @dev Anyone can call this function and distribute hodl rewards
335     /// @param _beneficiaries Array of addresses for which we want to claim hodl rewards
336     function claimHodlRewardsFor(address[] _beneficiaries) external {
337         for (uint256 i = 0; i < _beneficiaries.length; i++)
338             claimHodlRewardFor(_beneficiaries[i]);
339     }
340 
341     /// @notice Setting 3 - 6 - 9 months total staking hodl value if time is come
342     function updateAndGetHodlTotalValue() public returns (uint) {
343         if (hodlerTime3M > 0 && now >= hodlerTime3M && hodlerTotalValue3M == 0) {
344             hodlerTotalValue3M = hodlerTotalValue;
345         }
346 
347         if (hodlerTime6M > 0 && now >= hodlerTime6M && hodlerTotalValue6M == 0) {
348             hodlerTotalValue6M = hodlerTotalValue;
349         }
350 
351         if (hodlerTime9M > 0 && now >= hodlerTime9M && hodlerTotalValue9M == 0) {
352             hodlerTotalValue9M = hodlerTotalValue;
353 
354             // since we can transfer more tokens to this contract, make it possible to retain more than the predefined limit
355             TOKEN_HODL_9M = TokenController(owner).ethealToken().balanceOf(this).sub(TOKEN_HODL_3M).sub(TOKEN_HODL_6M).add(claimedTokens);
356         }
357 
358         return hodlerTotalValue;
359     }
360 }