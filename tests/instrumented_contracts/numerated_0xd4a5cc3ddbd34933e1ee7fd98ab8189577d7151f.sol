1 pragma solidity ^0.4.24;
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
38 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipRenounced(address indexed previousOwner);
50   event OwnershipTransferred(
51     address indexed previousOwner,
52     address indexed newOwner
53   );
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   constructor() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to relinquish control of the contract.
74    * @notice Renouncing to ownership will leave the contract without an owner.
75    * It will not be possible to call the functions with the `onlyOwner`
76    * modifier anymore.
77    */
78   function renounceOwnership() public onlyOwner {
79     emit OwnershipRenounced(owner);
80     owner = address(0);
81   }
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param _newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address _newOwner) public onlyOwner {
88     _transferOwnership(_newOwner);
89   }
90 
91   /**
92    * @dev Transfers control of the contract to a newOwner.
93    * @param _newOwner The address to transfer ownership to.
94    */
95   function _transferOwnership(address _newOwner) internal {
96     require(_newOwner != address(0));
97     emit OwnershipTransferred(owner, _newOwner);
98     owner = _newOwner;
99   }
100 }
101 
102 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
103 
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that throw on error
107  */
108 library SafeMath {
109 
110   /**
111   * @dev Multiplies two numbers, throws on overflow.
112   */
113   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
114     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
115     // benefit is lost if 'b' is also tested.
116     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117     if (_a == 0) {
118       return 0;
119     }
120 
121     c = _a * _b;
122     assert(c / _a == _b);
123     return c;
124   }
125 
126   /**
127   * @dev Integer division of two numbers, truncating the quotient.
128   */
129   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
130     // assert(_b > 0); // Solidity automatically throws when dividing by 0
131     // uint256 c = _a / _b;
132     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
133     return _a / _b;
134   }
135 
136   /**
137   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
138   */
139   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
140     assert(_b <= _a);
141     return _a - _b;
142   }
143 
144   /**
145   * @dev Adds two numbers, throws on overflow.
146   */
147   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
148     c = _a + _b;
149     assert(c >= _a);
150     return c;
151   }
152 }
153 
154 // File: contracts/TokenVesting.sol
155 
156 contract TokenVesting is Ownable {
157   using SafeMath for uint;
158 
159   ERC20 public token;
160   address public receiver;
161   uint256 public startTime;
162   uint256 public cliff;
163   uint256 public totalPeriods;
164   uint256 public timePerPeriod;
165   uint256 public totalTokens;
166   uint256 public tokensClaimed;
167 
168   event VestingFunded(uint256 totalTokens);
169   event TokensClaimed(uint256 tokensClaimed);
170   event VestingKilled();
171 
172   /**
173   *@dev contructor
174   *@param _token address of erc20 token
175   *@param _receiver address entitle to claim tokens
176   *@param _startTime moment when counting time starts
177   *@param _cliff delay from _startTime after which vesting starts
178   *@param _totalPeriods total amount of vesting periods
179   *@param _timePerPeriod time in seconds for every vesting period
180   */
181   constructor(
182     address _token,
183     address _receiver,
184     uint256 _startTime,
185     uint256 _cliff,
186     uint256 _totalPeriods,
187     uint256 _timePerPeriod
188   ) public {
189     token = ERC20(_token);
190     receiver = _receiver;
191     startTime = _startTime;
192     cliff = _cliff;
193     totalPeriods = _totalPeriods;
194     timePerPeriod = _timePerPeriod;
195   }
196 
197   /*
198   *@dev function responsible for supplying tokens that will be vested
199   *@param _totalTokens amount of tokens that will be supplied to this contract
200   */
201   function fundVesting(uint256 _totalTokens) public onlyOwner {
202     require(totalTokens == 0, "Vesting already funded");
203     require(token.allowance(owner, address(this)) == _totalTokens);
204     totalTokens = _totalTokens;
205     token.transferFrom(owner, address(this), totalTokens);
206     emit VestingFunded(_totalTokens);
207   }
208 
209   /*
210   *@dev Function that allows the contract owner to change tokens receiver
211   *@param newReceiver the new receiver address
212   */
213   function changeReceiver(address newReceiver) public onlyOwner {
214     require(newReceiver != address(0));
215     receiver = newReceiver;
216   }
217 
218   /**
219   *@dev function that allows receiver to claim tokens, can be called only by
220     receiver
221   */
222   function claimTokens() public {
223 
224     require(totalTokens > 0, "Vesting has not been funded yet");
225     require(msg.sender == receiver, "Only receiver can claim tokens");
226     require(now > startTime.add(cliff), "Vesting hasnt started yet");
227 
228     uint256 timePassed = now.sub(startTime.add(cliff));
229     uint256 tokensToClaim = totalTokens
230       .div(totalPeriods)
231       .mul(timePassed.div(timePerPeriod))
232       .sub(tokensClaimed);
233 
234     token.transfer(receiver, tokensToClaim);
235     tokensClaimed = tokensClaimed.add(tokensToClaim);
236 
237     emit TokensClaimed(tokensToClaim);
238 
239   }
240 
241   /**
242   *@dev function that allows cancel vesting, can be called only by the owner
243   */
244   function killVesting() public onlyOwner {
245     token.transfer(owner, totalTokens.sub(tokensClaimed));
246     tokensClaimed = totalTokens;
247     emit VestingKilled();
248   }
249 
250 }