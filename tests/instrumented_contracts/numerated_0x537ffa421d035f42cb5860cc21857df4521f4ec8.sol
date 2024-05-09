1 pragma solidity ^0.4.24;
2 
3 /** 
4 Do not transfer tokens to TimelockERC20 directly (via transfer method)! Tokens will be stuck permanently.
5 Use approvals and accept method.
6 **/
7 
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 contract IERC20{
70   function allowance(address owner, address spender) external view returns (uint);
71   function transferFrom(address from, address to, uint value) external returns (bool);
72   function approve(address spender, uint value) external returns (bool);
73   function totalSupply() external view returns (uint);
74   function balanceOf(address who) external view returns (uint);
75   function transfer(address to, uint value) external returns (bool);
76   
77   event Transfer(address indexed from, address indexed to, uint value);
78   event Approval(address indexed owner, address indexed spender, uint value);
79 }
80 
81 contract ITimeMachine {
82   function getTimestamp_() internal view returns (uint);
83 }
84 
85 
86 contract TimeMachineP is ITimeMachine {
87   /**
88   * @dev get current real timestamp
89   * @return current real timestamp
90   */
91   function getTimestamp_() internal view returns(uint) {
92     return block.timestamp;
93   }
94 }
95 
96 
97 contract Ownable {
98   address public owner;
99 
100 
101   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 
103 
104   /**
105    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106    * account.
107    */
108   constructor() public {
109     owner = msg.sender;
110   }
111 
112   /**
113    * @dev Throws if called by any account other than the owner.
114    */
115   modifier onlyOwner() {
116     require(msg.sender == owner);
117     _;
118   }
119 
120   /**
121    * @dev Allows the current owner to transfer control of the contract to a newOwner.
122    * @param newOwner The address to transfer ownership to.
123    */
124   function transferOwnership(address newOwner) public onlyOwner {
125     require(newOwner != address(0));
126     emit OwnershipTransferred(owner, newOwner);
127     owner = newOwner;
128   }
129 
130 }
131 
132 
133 contract SafeERC20Timelock is ITimeMachine, Ownable {
134   using SafeMath for uint;
135 
136   event Lock(address indexed _from, address indexed _for, uint indexed timestamp, uint value);
137   event Withdraw(address indexed _for, uint indexed timestamp, uint value);
138 
139 
140 
141   mapping (address => mapping(uint => uint)) public balance;
142   IERC20 public token;
143   uint public totalBalance;
144 
145   constructor (address _token) public {
146     token = IERC20(_token);
147   }
148 
149   function contractBalance_() internal view returns(uint) {
150     return token.balanceOf(this);
151   }
152 
153   /**
154   * @dev accept token into timelock
155   * @param _for address of future tokenholder
156   * @param _timestamp lock timestamp
157   * @return result of operation: true if success
158   */
159   function accept(address _for, uint _timestamp, uint _tvalue) public returns(bool){
160     require(_for != address(0));
161     require(_for != address(this));
162     require(_timestamp > getTimestamp_());
163     require(_tvalue > 0);
164     uint _contractBalance = contractBalance_();
165     uint _balance = balance[_for][_timestamp];
166     uint _totalBalance = totalBalance;
167     require(token.transferFrom(msg.sender, this, _tvalue));
168     uint _value = contractBalance_().sub(_contractBalance);
169     balance[_for][_timestamp] = _balance.add(_value);
170     totalBalance = _totalBalance.add(_value);
171     emit Lock(msg.sender, _for, _timestamp, _value);
172     return true;
173   }
174 
175 
176   /**
177   * @dev release timelock tokens
178   * @param _for address of future tokenholder
179   * @param _timestamp array of timestamps to unlock
180   * @param _value array of amounts to unlock
181   * @return result of operation: true if success
182   */
183   function release_(address _for, uint[] _timestamp, uint[] _value) internal returns(bool) {
184     uint _len = _timestamp.length;
185     require(_len == _value.length);
186     uint _totalValue;
187     uint _curValue;
188     uint _curTimestamp;
189     uint _subValue;
190     uint _now = getTimestamp_();
191     for (uint i = 0; i < _len; i++){
192       _curTimestamp = _timestamp[i];
193       _curValue = balance[_for][_curTimestamp];
194       _subValue = _value[i];
195       require(_curValue >= _subValue);
196       require(_curTimestamp <= _now);
197       balance[_for][_curTimestamp] = _curValue.sub(_subValue);
198       _totalValue = _totalValue.add(_subValue);
199       emit Withdraw(_for, _curTimestamp, _subValue);
200     }
201     totalBalance = totalBalance.sub(_totalValue);
202     require(token.transfer(_for, _totalValue));
203     return true;
204   }
205 
206 
207   /**
208   * @dev release timelock tokens
209   * @param _timestamp array of timestamps to unlock
210   * @param _value array of amounts to unlock
211   * @return result of operation: true if success
212   */
213   function release(uint[] _timestamp, uint[] _value) external returns(bool) {
214     return release_(msg.sender, _timestamp, _value);
215   }
216 
217   /**
218   * @dev release timelock tokens by force
219   * @param _for address of future tokenholder
220   * @param _timestamp array of timestamps to unlock
221   * @param _value array of amounts to unlock
222   * @return result of operation: true if success
223   */
224   function releaseForce(address _for, uint[] _timestamp, uint[] _value) onlyOwner external returns(bool) {
225     return release_(_for, _timestamp, _value);
226   }
227 
228   /**
229   * @dev Allow to use functions of other contract from this contract
230   * @param _token address of ERC20 contract to call
231   * @param _to address to transfer ERC20 tokens
232   * @param _amount amount to transfer
233   * @return result of operation, true if success
234   */
235   function saveLockedERC20Tokens(address _token, address _to, uint  _amount) onlyOwner external returns (bool) {
236     require(IERC20(_token).transfer(_to, _amount));
237     require(totalBalance <= contractBalance_());
238     return true;
239   }
240 
241   function () public payable {
242     revert();
243   }
244 
245 }
246 
247 contract SafeERC20TimelockProd is TimeMachineP, SafeERC20Timelock {
248   constructor (address _token) public SafeERC20Timelock(_token) {
249   }
250 }