1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     c = _a * _b;
58     assert(c / _a == _b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     // assert(_b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = _a / _b;
68     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69     return _a / _b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     assert(_b <= _a);
77     return _a - _b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     c = _a + _b;
85     assert(c >= _a);
86     return c;
87   }
88 }
89 
90 // File: contracts/AdvisorsVesting.sol
91 
92 contract AdvisorsVesting {
93     using SafeMath for uint256;
94     
95     modifier onlyV12MultiSig {
96         require(msg.sender == v12MultiSig, "not owner");
97         _;
98     }
99 
100     modifier onlyValidAddress(address _recipient) {
101         require(_recipient != address(0) && _recipient != address(this) && _recipient != address(token), "not valid _recipient");
102         _;
103     }
104 
105     uint256 constant internal SECONDS_PER_DAY = 86400;
106 
107     struct Grant {
108         uint256 startTime;
109         uint256 amount;
110         uint256 vestingDuration;
111         uint256 vestingCliff;
112         uint256 daysClaimed;
113         uint256 totalClaimed;
114         address recipient;
115         bool isActive;
116     }
117 
118     event GrantAdded(address indexed recipient, uint256 vestingId);
119     event GrantTokensClaimed(address indexed recipient, uint256 amountClaimed);
120     event GrantRemoved(address recipient, uint256 amountVested, uint256 amountNotVested);
121     event ChangedMultisig(address multisig);
122 
123     ERC20 public token;
124     
125     mapping (uint256 => Grant) public tokenGrants;
126 
127     address public v12MultiSig;
128     uint256 public totalVestingCount;
129 
130     constructor(ERC20 _token) public {
131         require(address(_token) != address(0));
132         v12MultiSig = msg.sender;
133         token = _token;
134     }
135     
136     function addTokenGrant(
137         address _recipient,
138         uint256 _startTime,
139         uint256 _amount,
140         uint256 _vestingDurationInDays,
141         uint256 _vestingCliffInDays    
142     ) 
143         external
144         onlyV12MultiSig
145         onlyValidAddress(_recipient)
146     {
147         require(_vestingCliffInDays <= 10*365, "more than 10 years");
148         require(_vestingDurationInDays <= 25*365, "more than 25 years");
149         require(_vestingDurationInDays >= _vestingCliffInDays, "Duration < Cliff");
150         
151         uint256 amountVestedPerDay = _amount.div(_vestingDurationInDays);
152         require(amountVestedPerDay > 0, "amountVestedPerDay > 0");
153 
154         // Transfer the grant tokens under the control of the vesting contract
155         require(token.transferFrom(v12MultiSig, address(this), _amount), "transfer failed");
156 
157         Grant memory grant = Grant({
158             startTime: _startTime == 0 ? currentTime() : _startTime,
159             amount: _amount,
160             vestingDuration: _vestingDurationInDays,
161             vestingCliff: _vestingCliffInDays,
162             daysClaimed: 0,
163             totalClaimed: 0,
164             recipient: _recipient,
165             isActive: true
166         });
167         tokenGrants[totalVestingCount] = grant;
168         emit GrantAdded(_recipient, totalVestingCount);
169         totalVestingCount++;
170     }
171 
172     function getActiveGrants(address _recipient) public view returns(uint256[]){
173         uint256 i = 0;
174         uint256[] memory recipientGrants = new uint256[](totalVestingCount);
175         uint256 totalActive = 0;
176         // total amount of vesting grants assumed to be less than 100
177         for(i; i < totalVestingCount; i++){
178             if(tokenGrants[i].isActive && tokenGrants[i].recipient == _recipient){
179                 recipientGrants[totalActive] = i;
180                 totalActive++;
181             }
182         }
183         assembly {
184             mstore(recipientGrants, totalActive)
185         }
186         return recipientGrants;
187     }
188 
189     /// @notice Calculate the vested and unclaimed months and tokens available for `_grantId` to claim
190     /// Due to rounding errors once grant duration is reached, returns the entire left grant amount
191     /// Returns (0, 0) if cliff has not been reached
192     function calculateGrantClaim(uint256 _grantId) public view returns (uint256, uint256) {
193         Grant storage tokenGrant = tokenGrants[_grantId];
194 
195         // For grants created with a future start date, that hasn't been reached, return 0, 0
196         if (currentTime() < tokenGrant.startTime) {
197             return (0, 0);
198         }
199 
200         // Check cliff was reached
201         uint elapsedTime = currentTime().sub(tokenGrant.startTime);
202         uint elapsedDays = elapsedTime.div(SECONDS_PER_DAY);
203         
204         if (elapsedDays < tokenGrant.vestingCliff) {
205             return (elapsedDays, 0);
206         }
207 
208         // If over vesting duration, all tokens vested
209         if (elapsedDays >= tokenGrant.vestingDuration) {
210             uint256 remainingGrant = tokenGrant.amount.sub(tokenGrant.totalClaimed);
211             return (tokenGrant.vestingDuration, remainingGrant);
212         } else {
213             uint256 daysVested = elapsedDays.sub(tokenGrant.daysClaimed);
214             uint256 amountVestedPerDay = tokenGrant.amount.div(uint256(tokenGrant.vestingDuration));
215             uint256 amountVested = uint256(daysVested.mul(amountVestedPerDay));
216             return (daysVested, amountVested);
217         }
218     }
219 
220     /// @notice Allows a grant recipient to claim their vested tokens. Errors if no tokens have vested
221     /// It is advised recipients check they are entitled to claim via `calculateGrantClaim` before calling this
222     function claimVestedTokens(uint256 _grantId) external {
223         uint256 daysVested;
224         uint256 amountVested;
225         (daysVested, amountVested) = calculateGrantClaim(_grantId);
226         require(amountVested > 0, "amountVested is 0");
227 
228         Grant storage tokenGrant = tokenGrants[_grantId];
229         tokenGrant.daysClaimed = tokenGrant.daysClaimed.add(daysVested);
230         tokenGrant.totalClaimed = tokenGrant.totalClaimed.add(amountVested);
231         
232         require(token.transfer(tokenGrant.recipient, amountVested), "no tokens");
233         emit GrantTokensClaimed(tokenGrant.recipient, amountVested);
234     }
235 
236     /// @notice Terminate token grant transferring all vested tokens to the `_grantId`
237     /// and returning all non-vested tokens to the V12 MultiSig
238     /// Secured to the V12 MultiSig only
239     /// @param _grantId grantId of the token grant recipient
240     function removeTokenGrant(uint256 _grantId) 
241         external 
242         onlyV12MultiSig
243     {
244         Grant storage tokenGrant = tokenGrants[_grantId];
245         require(tokenGrant.isActive, "is not active");
246         address recipient = tokenGrant.recipient;
247         uint256 daysVested;
248         uint256 amountVested;
249         (daysVested, amountVested) = calculateGrantClaim(_grantId);
250 
251         uint256 amountNotVested = (tokenGrant.amount.sub(tokenGrant.totalClaimed)).sub(amountVested);
252 
253         require(token.transfer(recipient, amountVested));
254         require(token.transfer(v12MultiSig, amountNotVested));
255 
256         tokenGrant.startTime = 0;
257         tokenGrant.amount = 0;
258         tokenGrant.vestingDuration = 0;
259         tokenGrant.vestingCliff = 0;
260         tokenGrant.daysClaimed = 0;
261         tokenGrant.totalClaimed = 0;
262         tokenGrant.recipient = address(0);
263         tokenGrant.isActive = false;
264 
265         emit GrantRemoved(recipient, amountVested, amountNotVested);
266     }
267 
268     function currentTime() public view returns(uint256) {
269         return block.timestamp;
270     }
271 
272     function tokensVestedPerDay(uint256 _grantId) public view returns(uint256) {
273         Grant storage tokenGrant = tokenGrants[_grantId];
274         return tokenGrant.amount.div(uint256(tokenGrant.vestingDuration));
275     }
276 
277     function changeMultiSig(address _newMultisig) 
278         external 
279         onlyV12MultiSig
280         onlyValidAddress(_newMultisig)
281     {
282         v12MultiSig = _newMultisig;
283         emit ChangedMultisig(_newMultisig);
284     }
285 
286 }