1 pragma solidity ^0.4.22;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title ERC20Basic
67  * @dev Simpler version of ERC20 interface
68  * See https://github.com/ethereum/EIPs/issues/179
69  */
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address _who) public view returns (uint256);
73   function transfer(address _to, uint256 _value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address _owner, address _spender)
83     public view returns (uint256);
84 
85   function transferFrom(address _from, address _to, uint256 _value)
86     public returns (bool);
87 
88   function approve(address _spender, uint256 _value) public returns (bool);
89   event Approval(
90     address indexed owner,
91     address indexed spender,
92     uint256 value
93   );
94 }
95 
96 /**
97  * @title SafeERC20
98  * @dev Wrappers around ERC20 operations that throw on failure.
99  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
100  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
101  */
102 library SafeERC20 {
103   function safeTransfer(
104     ERC20Basic _token,
105     address _to,
106     uint256 _value
107   )
108     internal
109   {
110     require(_token.transfer(_to, _value));
111   }
112 
113   function safeTransferFrom(
114     ERC20 _token,
115     address _from,
116     address _to,
117     uint256 _value
118   )
119     internal
120   {
121     require(_token.transferFrom(_from, _to, _value));
122   }
123 
124   function safeApprove(
125     ERC20 _token,
126     address _spender,
127     uint256 _value
128   )
129     internal
130   {
131     require(_token.approve(_spender, _value));
132   }
133 }
134 
135 /**
136  * @title Contracts that should be able to recover tokens
137  * @author SylTi
138  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
139  * This will prevent any accidental loss of tokens.
140  */
141 contract CanReclaimToken is Ownable {
142   using SafeERC20 for ERC20Basic;
143 
144   /**
145    * @dev Reclaim all ERC20Basic compatible tokens
146    * @param _token ERC20Basic The address of the token contract
147    */
148   function reclaimToken(ERC20Basic _token) external onlyOwner {
149     uint256 balance = _token.balanceOf(this);
150     _token.safeTransfer(owner, balance);
151   }
152 
153 }
154 
155 /**
156  * @title Pausable
157  * @dev Base contract which allows children to implement an emergency stop mechanism.
158  */
159 contract Pausable is Ownable {
160   event Pause();
161   event Unpause();
162 
163   bool public paused = false;
164 
165 
166   /**
167    * @dev Modifier to make a function callable only when the contract is not paused.
168    */
169   modifier whenNotPaused() {
170     require(!paused);
171     _;
172   }
173 
174   /**
175    * @dev Modifier to make a function callable only when the contract is paused.
176    */
177   modifier whenPaused() {
178     require(paused);
179     _;
180   }
181 
182   /**
183    * @dev called by the owner to pause, triggers stopped state
184    */
185   function pause() public onlyOwner whenNotPaused {
186     paused = true;
187     emit Pause();
188   }
189 
190   /**
191    * @dev called by the owner to unpause, returns to normal state
192    */
193   function unpause() public onlyOwner whenPaused {
194     paused = false;
195     emit Unpause();
196   }
197 }
198 
199 /**
200  * @title SafeMath
201  * @dev Math operations with safety checks that throw on error
202  */
203 library SafeMath {
204 
205   /**
206   * @dev Multiplies two numbers, throws on overflow.
207   */
208   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
209     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
210     // benefit is lost if 'b' is also tested.
211     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
212     if (_a == 0) {
213       return 0;
214     }
215 
216     c = _a * _b;
217     assert(c / _a == _b);
218     return c;
219   }
220 
221   /**
222   * @dev Integer division of two numbers, truncating the quotient.
223   */
224   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
225     // assert(_b > 0); // Solidity automatically throws when dividing by 0
226     // uint256 c = _a / _b;
227     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
228     return _a / _b;
229   }
230 
231   /**
232   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
233   */
234   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
235     assert(_b <= _a);
236     return _a - _b;
237   }
238 
239   /**
240   * @dev Adds two numbers, throws on overflow.
241   */
242   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
243     c = _a + _b;
244     assert(c >= _a);
245     return c;
246   }
247 }
248 
249 contract KindAdsReward is Ownable, CanReclaimToken, Pausable{
250 
251   // Use SafeMath for all uint256
252   using SafeMath for uint256;
253    // The KIND address
254   address tokenAddress;
255   // The KIND Token Instance
256   ERC20 public KIND;
257   // PayAndDistribute Event
258   event PaidAndDistributed(address indexed publisher, uint256 pricePaid, string campaignId);
259 
260   constructor(address _tokenAddress) public {
261     KIND = ERC20(_tokenAddress);
262     tokenAddress = _tokenAddress;
263   }
264 
265   function payAndDistribute(
266     address _publisher,
267     uint256 _priceToPay,
268     uint256 _toPublisher,
269     uint256 _toReward,
270     string _campaignId) public whenNotPaused returns (bool) {
271 
272     require(msg.sender != address(0));
273     require(_priceToPay <= KIND.balanceOf(msg.sender));
274     require(_priceToPay <= KIND.allowance(msg.sender, this));
275     require(_toPublisher.add(_toReward) == _priceToPay);
276     // First move the reward share tokens for this contract
277     KIND.transferFrom(msg.sender, this, _toReward);
278     // Transfer the real payment to the publisher
279     KIND.transferFrom(msg.sender, _publisher, _toPublisher);
280 
281     emit PaidAndDistributed(_publisher, _priceToPay, _campaignId);
282     return true;
283   }
284 
285    /**
286   * @dev Returns the publisher address
287   */
288   function getKindAddress() public view returns (address kindAddress) {
289     return tokenAddress;
290   }
291 
292    /**
293   * @dev Returns the full amount of KIND in this contract
294   */
295   function getTokenBalance() public view returns(uint256 balance) {
296     return KIND.balanceOf(this);
297   }
298 
299 }