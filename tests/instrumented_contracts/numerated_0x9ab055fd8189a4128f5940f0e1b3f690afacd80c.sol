1 pragma solidity ^0.4.17;
2 /**
3  * @title ERC20
4  * @dev ERC20 interface
5  */
6 contract ERC20 {
7     function balanceOf(address who) public view returns (uint256);
8     function transfer(address to, uint256 value) public returns (bool);
9     function allowance(address owner, address spender) public view returns (uint256);
10     function transferFrom(address from, address to, uint256 value) public returns (bool);
11     function approve(address spender, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   function Ownable() {
28     owner = msg.sender;
29   }
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) onlyOwner public {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 }
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 contract Controlled {
74     /// @notice The address of the controller is the only address that can call
75     ///  a function with this modifier
76     modifier onlyController { require(msg.sender == controller); _; }
77     address public controller;
78     function Controlled() public { controller = msg.sender;}
79     /// @notice Changes the controller of the contract
80     /// @param _newController The new controller of the contract
81     function changeController(address _newController) public onlyController {
82         controller = _newController;
83     }
84 }
85 /**
86  * @title MiniMe interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20MiniMe is ERC20, Controlled {
90     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool);
91     function totalSupply() public view returns (uint);
92     function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint);
93     function totalSupplyAt(uint _blockNumber) public view returns(uint);
94     function createCloneToken(string _cloneTokenName, uint8 _cloneDecimalUnits, string _cloneTokenSymbol, uint _snapshotBlock, bool _transfersEnabled) public returns(address);
95     function generateTokens(address _owner, uint _amount) public returns (bool);
96     function destroyTokens(address _owner, uint _amount)  public returns (bool);
97     function enableTransfers(bool _transfersEnabled) public;
98     function isContract(address _addr) internal view returns(bool);
99     function claimTokens(address _token) public;
100     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
101     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
102 }
103 /// @dev The token controller contract must implement these functions
104 contract TokenController {
105     ERC20MiniMe public ethealToken;
106     address public SALE; // address where sale tokens are located
107     /// @notice needed for hodler handling
108     function addHodlerStake(address _beneficiary, uint _stake) public;
109     function setHodlerStake(address _beneficiary, uint256 _stake) public;
110     function setHodlerTime(uint256 _time) public;
111     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
112     /// @param _owner The address that sent the ether to create tokens
113     /// @return True if the ether is accepted, false if it throws
114     function proxyPayment(address _owner) public payable returns(bool);
115     /// @notice Notifies the controller about a token transfer allowing the
116     ///  controller to react if desired
117     /// @param _from The origin of the transfer
118     /// @param _to The destination of the transfer
119     /// @param _amount The amount of the transfer
120     /// @return False if the controller does not authorize the transfer
121     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
122     /// @notice Notifies the controller about an approval allowing the
123     ///  controller to react if desired
124     /// @param _owner The address that calls `approve()`
125     /// @param _spender The spender in the `approve()` call
126     /// @param _amount The amount in the `approve()` call
127     /// @return False if the controller does not authorize the approval
128     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
129 }
130 /**
131  * @title Hodler
132  * @dev Handles hodler reward, TokenController should create and own it.
133  */
134 contract Hodler is Ownable {
135     using SafeMath for uint;
136     // HODLER reward tracker
137     // stake amount per address
138     struct HODL {
139         uint256 stake;
140         // moving ANY funds invalidates hodling of the address
141         bool invalid;
142         bool claimed3M;
143         bool claimed6M;
144         bool claimed9M;
145     }
146     mapping (address => HODL) public hodlerStakes;
147     // total current staking value and hodler addresses
148     uint256 public hodlerTotalValue;
149     uint256 public hodlerTotalCount;
150     // store dates and total stake values for 3 - 6 - 9 months after normal sale
151     uint256 public hodlerTotalValue3M;
152     uint256 public hodlerTotalValue6M;
153     uint256 public hodlerTotalValue9M;
154     uint256 public hodlerTimeStart;
155     uint256 public hodlerTime3M;
156     uint256 public hodlerTime6M;
157     uint256 public hodlerTime9M;
158     // reward HEAL token amount
159     uint256 public TOKEN_HODL_3M;
160     uint256 public TOKEN_HODL_6M;
161     uint256 public TOKEN_HODL_9M;
162     // total amount of tokens claimed so far
163     uint256 public claimedTokens;
164     
165     event LogHodlSetStake(address indexed _setter, address indexed _beneficiary, uint256 _value);
166     event LogHodlClaimed(address indexed _setter, address indexed _beneficiary, uint256 _value);
167     event LogHodlStartSet(address indexed _setter, uint256 _time);
168     /// @dev Only before hodl is started
169     modifier beforeHodlStart() {
170         if (hodlerTimeStart == 0 || now <= hodlerTimeStart)
171             _;
172     }
173     /// @dev Contructor, it should be created by a TokenController
174     function Hodler(uint256 _stake3m, uint256 _stake6m, uint256 _stake9m) {
175         TOKEN_HODL_3M = _stake3m;
176         TOKEN_HODL_6M = _stake6m;
177         TOKEN_HODL_9M = _stake9m;
178     }
179     /// @notice Adding hodler stake to an account
180     /// @dev Only owner contract can call it and before hodling period starts
181     /// @param _beneficiary Recepient address of hodler stake
182     /// @param _stake Amount of additional hodler stake
183     function addHodlerStake(address _beneficiary, uint256 _stake) public onlyOwner beforeHodlStart {
184         // real change and valid _beneficiary is needed
185         if (_stake == 0 || _beneficiary == address(0))
186             return;
187         
188         // add stake and maintain count
189         if (hodlerStakes[_beneficiary].stake == 0)
190             hodlerTotalCount = hodlerTotalCount.add(1);
191         hodlerStakes[_beneficiary].stake = hodlerStakes[_beneficiary].stake.add(_stake);
192         hodlerTotalValue = hodlerTotalValue.add(_stake);
193         LogHodlSetStake(msg.sender, _beneficiary, hodlerStakes[_beneficiary].stake);
194     }
195     /// @notice Setting hodler stake of an account
196     /// @dev Only owner contract can call it and before hodling period starts
197     /// @param _beneficiary Recepient address of hodler stake
198     /// @param _stake Amount to set the hodler stake
199     function setHodlerStake(address _beneficiary, uint256 _stake) public onlyOwner beforeHodlStart {
200         // real change and valid _beneficiary is needed
201         if (hodlerStakes[_beneficiary].stake == _stake || _beneficiary == address(0))
202             return;
203         
204         // add stake and maintain count
205         if (hodlerStakes[_beneficiary].stake == 0 && _stake > 0) {
206             hodlerTotalCount = hodlerTotalCount.add(1);
207         } else if (hodlerStakes[_beneficiary].stake > 0 && _stake == 0) {
208             hodlerTotalCount = hodlerTotalCount.sub(1);
209         }
210         uint256 _diff = _stake > hodlerStakes[_beneficiary].stake ? _stake.sub(hodlerStakes[_beneficiary].stake) : hodlerStakes[_beneficiary].stake.sub(_stake);
211         if (_stake > hodlerStakes[_beneficiary].stake) {
212             hodlerTotalValue = hodlerTotalValue.add(_diff);
213         } else {
214             hodlerTotalValue = hodlerTotalValue.sub(_diff);
215         }
216         hodlerStakes[_beneficiary].stake = _stake;
217         LogHodlSetStake(msg.sender, _beneficiary, _stake);
218     }
219     /// @notice Setting hodler start period.
220     /// @param _time The time when hodler reward starts counting
221     function setHodlerTime(uint256 _time) public onlyOwner beforeHodlStart {
222         require(_time >= now);
223         hodlerTimeStart = _time;
224         hodlerTime3M = _time.add(90 days);
225         hodlerTime6M = _time.add(180 days);
226         hodlerTime9M = _time.add(270 days);
227         LogHodlStartSet(msg.sender, _time);
228     }
229     /// @notice Invalidates hodler account 
230     /// @dev Gets called by EthealController#onTransfer before every transaction
231     function invalidate(address _account) public onlyOwner {
232         if (hodlerStakes[_account].stake > 0 && !hodlerStakes[_account].invalid) {
233             hodlerStakes[_account].invalid = true;
234             hodlerTotalValue = hodlerTotalValue.sub(hodlerStakes[_account].stake);
235             hodlerTotalCount = hodlerTotalCount.sub(1);
236         }
237         // update hodl total values "automatically" - whenever someone sends funds thus
238         updateAndGetHodlTotalValue();
239     }
240     /// @notice Claiming HODL reward for msg.sender
241     function claimHodlReward() public {
242         claimHodlRewardFor(msg.sender);
243     }
244     /// @notice Claiming HODL reward for an address
245     function claimHodlRewardFor(address _beneficiary) public {
246         // only when the address has a valid stake
247         require(hodlerStakes[_beneficiary].stake > 0 && !hodlerStakes[_beneficiary].invalid);
248         uint256 _stake = 0;
249         
250         // update hodl total values
251         updateAndGetHodlTotalValue();
252         // claim hodl if not claimed
253         if (!hodlerStakes[_beneficiary].claimed3M && now >= hodlerTime3M) {
254             _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_3M).div(hodlerTotalValue3M));
255             hodlerStakes[_beneficiary].claimed3M = true;
256         }
257         if (!hodlerStakes[_beneficiary].claimed6M && now >= hodlerTime6M) {
258             _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_6M).div(hodlerTotalValue6M));
259             hodlerStakes[_beneficiary].claimed6M = true;
260         }
261         if (!hodlerStakes[_beneficiary].claimed9M && now >= hodlerTime9M) {
262             _stake = _stake.add(hodlerStakes[_beneficiary].stake.mul(TOKEN_HODL_9M).div(hodlerTotalValue9M));
263             hodlerStakes[_beneficiary].claimed9M = true;
264         }
265         if (_stake > 0) {
266             // increasing claimed tokens
267             claimedTokens = claimedTokens.add(_stake);
268             // transferring tokens
269             require(TokenController(owner).ethealToken().transfer(_beneficiary, _stake));
270             // log
271             LogHodlClaimed(msg.sender, _beneficiary, _stake);
272         }
273     }
274     /// @notice claimHodlRewardFor() for multiple addresses
275     /// @dev Anyone can call this function and distribute hodl rewards
276     /// @param _beneficiaries Array of addresses for which we want to claim hodl rewards
277     function claimHodlRewardsFor(address[] _beneficiaries) external {
278         for (uint256 i = 0; i < _beneficiaries.length; i++)
279             claimHodlRewardFor(_beneficiaries[i]);
280     }
281     /// @notice Setting 3 - 6 - 9 months total staking hodl value if time is come
282     function updateAndGetHodlTotalValue() public returns (uint) {
283         if (now >= hodlerTime3M && hodlerTotalValue3M == 0) {
284             hodlerTotalValue3M = hodlerTotalValue;
285         }
286         if (now >= hodlerTime6M && hodlerTotalValue6M == 0) {
287             hodlerTotalValue6M = hodlerTotalValue;
288         }
289         if (now >= hodlerTime9M && hodlerTotalValue9M == 0) {
290             hodlerTotalValue9M = hodlerTotalValue;
291             // since we can transfer more tokens to this contract, make it possible to retain more than the predefined limit
292             TOKEN_HODL_9M = TokenController(owner).ethealToken().balanceOf(this).sub(TOKEN_HODL_3M).sub(TOKEN_HODL_6M).add(claimedTokens);
293         }
294         return hodlerTotalValue;
295     }
296 }