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
90 // File: contracts/Vault12LockedTokens.sol
91 
92 contract Vault12LockedTokens {
93     using SafeMath for uint256;
94     uint256 constant internal SECONDS_PER_YEAR = 31561600;
95 
96     modifier onlyV12MultiSig {
97         require(msg.sender == v12MultiSig, "not owner");
98         _;
99     }
100 
101     modifier onlyValidAddress(address _recipient) {
102         require(_recipient != address(0) && _recipient != address(this) && _recipient != address(token), "not valid _recipient");
103         _;
104     }
105 
106     struct Grant {
107         uint256 startTime;
108         uint256 amount;
109         uint256 vestingDuration;
110         uint256 yearsClaimed;
111         uint256 totalClaimed;
112     }
113 
114     event GrantAdded(address recipient, uint256 amount);
115     event GrantTokensClaimed(address recipient, uint256 amountClaimed);
116     event ChangedMultisig(address multisig);
117 
118     ERC20 public token;
119     
120     mapping (address => Grant) public tokenGrants;
121     address public v12MultiSig;
122 
123     constructor(ERC20 _token) public {
124         require(address(_token) != address(0));
125         v12MultiSig = msg.sender;
126         token = _token;
127     }
128     
129     function addTokenGrant(
130         address _recipient,
131         uint256 _startTime,
132         uint256 _amount,
133         uint256 _vestingDurationInYears
134     )
135         onlyV12MultiSig
136         onlyValidAddress(_recipient)
137         external
138     {
139         require(!grantExist(_recipient), "grant already exist");
140         require(_vestingDurationInYears <= 25, "more than 25 years");
141         uint256 amountVestedPerYear = _amount.div(_vestingDurationInYears);
142         require(amountVestedPerYear > 0, "amountVestedPerYear > 0");
143 
144         // Transfer the grant tokens under the control of the vesting contract
145         require(token.transferFrom(msg.sender, address(this), _amount), "transfer failed");
146 
147         Grant memory grant = Grant({
148             startTime: _startTime == 0 ? currentTime() : _startTime,
149             amount: _amount,
150             vestingDuration: _vestingDurationInYears,
151             yearsClaimed: 0,
152             totalClaimed: 0
153         });
154         tokenGrants[_recipient] = grant;
155         emit GrantAdded(_recipient, _amount);
156     }
157 
158     /// @notice Calculate the vested and unclaimed months and tokens available for `_grantId` to claim
159     /// Due to rounding errors once grant duration is reached, returns the entire left grant amount
160     /// Returns (0, 0) if cliff has not been reached
161     function calculateGrantClaim(address _recipient) public view returns (uint256, uint256) {
162         Grant storage tokenGrant = tokenGrants[_recipient];
163 
164         // For grants created with a future start date, that hasn't been reached, return 0, 0
165         if (currentTime() < tokenGrant.startTime) {
166             return (0, 0);
167         }
168 
169         uint256 elapsedTime = currentTime().sub(tokenGrant.startTime);
170         uint256 elapsedYears = elapsedTime.div(SECONDS_PER_YEAR);
171         
172         // If over vesting duration, all tokens vested
173         if (elapsedYears >= tokenGrant.vestingDuration) {
174             uint256 remainingGrant = tokenGrant.amount.sub(tokenGrant.totalClaimed);
175             uint256 remainingYears = tokenGrant.vestingDuration.sub(tokenGrant.yearsClaimed);
176             return (remainingYears, remainingGrant);
177         } else {
178             uint256 i = 0;
179             uint256 tokenGrantAmount = tokenGrant.amount;
180             uint256 totalVested = 0;
181             for(i; i < elapsedYears; i++){
182                 totalVested = (tokenGrantAmount.mul(10)).div(100).add(totalVested); 
183                 tokenGrantAmount = tokenGrant.amount.sub(totalVested);
184             }
185             uint256 amountVested = totalVested.sub(tokenGrant.totalClaimed);
186             return (elapsedYears, amountVested);
187         }
188     }
189 
190     /// @notice Allows a grant recipient to claim their vested tokens. Errors if no tokens have vested
191     /// It is advised recipients check they are entitled to claim via `calculateGrantClaim` before calling this
192     function claimVestedTokens(address _recipient) external {
193         uint256 yearsVested;
194         uint256 amountVested;
195         (yearsVested, amountVested) = calculateGrantClaim(_recipient);
196         require(amountVested > 0, "amountVested is 0");
197 
198         Grant storage tokenGrant = tokenGrants[_recipient];
199         tokenGrant.yearsClaimed = yearsVested;
200         tokenGrant.totalClaimed = tokenGrant.totalClaimed.add(amountVested);
201         
202         require(token.transfer(_recipient, amountVested), "no tokens");
203         emit GrantTokensClaimed(_recipient, amountVested);
204     }
205 
206     function currentTime() public view returns(uint256) {
207         return block.timestamp;
208     }
209 
210     function changeMultiSig(address _newMultisig) 
211         external 
212         onlyV12MultiSig
213         onlyValidAddress(_newMultisig)
214     {
215         v12MultiSig = _newMultisig;
216         emit ChangedMultisig(_newMultisig);
217     }
218 
219     function grantExist(address _recipient) public view returns(bool) {
220         return tokenGrants[_recipient].amount > 0;
221     }
222 
223 }