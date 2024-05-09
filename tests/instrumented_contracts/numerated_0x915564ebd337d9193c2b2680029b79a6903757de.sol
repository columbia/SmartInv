1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address _who) public view returns (uint256);
65   function transfer(address _to, uint256 _value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address _owner, address _spender)
77     public view returns (uint256);
78 
79   function transferFrom(address _from, address _to, uint256 _value)
80     public returns (bool);
81 
82   function approve(address _spender, uint256 _value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: contracts/Ownable.sol
91 
92 /**
93  * @title Ownable
94  * @dev The Ownable contract has an owner address, and provides basic authorization control
95  * functions, this simplifies the implementation of "user permissions".
96  */
97 contract Ownable {
98   address public owner;
99 
100 
101   event OwnershipRenounced(address indexed previousOwner);
102   event OwnershipTransferred(
103     address indexed previousOwner,
104     address indexed newOwner
105   );
106 
107 
108   /**
109    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
110    * account.
111    */
112   constructor() public {
113     owner = msg.sender;
114   }
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(msg.sender == owner, "msg.sender not owner");
121     _;
122   }
123 
124   /**
125    * @dev Allows the current owner to relinquish control of the contract.
126    * @notice Renouncing to ownership will leave the contract without an owner.
127    * It will not be possible to call the functions with the `onlyOwner`
128    * modifier anymore.
129    */
130   function renounceOwnership() public onlyOwner {
131     emit OwnershipRenounced(owner);
132     owner = address(0);
133   }
134 
135   /**
136    * @dev Allows the current owner to transfer control of the contract to a newOwner.
137    * @param _newOwner The address to transfer ownership to.
138    */
139   function transferOwnership(address _newOwner) public onlyOwner {
140     _transferOwnership(_newOwner);
141   }
142 
143   /**
144    * @dev Transfers control of the contract to a newOwner.
145    * @param _newOwner The address to transfer ownership to.
146    */
147   function _transferOwnership(address _newOwner) internal {
148     require(_newOwner != address(0), "_newOwner == 0");
149     emit OwnershipTransferred(owner, _newOwner);
150     owner = _newOwner;
151   }
152 }
153 
154 // File: contracts/Pausable.sol
155 
156 /**
157  * @title Pausable
158  * @dev Base contract which allows children to implement an emergency stop mechanism.
159  */
160 contract Pausable is Ownable {
161   event Pause();
162   event Unpause();
163 
164   bool public paused = false;
165 
166 
167   /**
168    * @dev Modifier to make a function callable only when the contract is not paused.
169    */
170   modifier whenNotPaused() {
171     require(!paused, "The contract is paused");
172     _;
173   }
174 
175   /**
176    * @dev Modifier to make a function callable only when the contract is paused.
177    */
178   modifier whenPaused() {
179     require(paused, "The contract is not paused");
180     _;
181   }
182 
183   /**
184    * @dev called by the owner to pause, triggers stopped state
185    */
186   function pause() public onlyOwner whenNotPaused {
187     paused = true;
188     emit Pause();
189   }
190 
191   /**
192    * @dev called by the owner to unpause, returns to normal state
193    */
194   function unpause() public onlyOwner whenPaused {
195     paused = false;
196     emit Unpause();
197   }
198 }
199 
200 // File: contracts/Destructible.sol
201 
202 /**
203  * @title Destructible
204  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
205  */
206 contract Destructible is Ownable {
207   /**
208    * @dev Transfers the current balance to the owner and terminates the contract.
209    */
210   function destroy() public onlyOwner {
211     selfdestruct(owner);
212   }
213 
214   function destroyAndSend(address _recipient) public onlyOwner {
215     selfdestruct(_recipient);
216   }
217 }
218 
219 // File: contracts/ERC20Supplier.sol
220 
221 /**
222  * @title ERC20Supplier.
223  * @author Andrea Speziale <aspeziale@eidoo.io>
224  * @dev Distribute a fixed amount of ERC20 based on a rate rate from a ERC20 reserve to a _receiver for ETH.
225  * Received ETH are redirected to a wallet.
226  */
227 contract ERC20Supplier is
228   Pausable,
229   Destructible
230 {
231   using SafeMath for uint;
232 
233   ERC20 public token;
234   
235   address public wallet;
236   address public reserve;
237   
238   uint public rate;
239 
240   event LogWithdrawAirdrop(address indexed _from, address indexed _token, uint amount);
241   event LogReleaseTokensTo(address indexed _from, address indexed _to, uint _amount);
242   event LogSetWallet(address indexed _wallet);
243   event LogSetReserve(address indexed _reserve);
244   event LogSetToken(address indexed _token);
245   event LogSetrate(uint _rate);
246 
247   /**
248    * @dev Contract constructor.
249    * @param _wallet Where the received ETH are transfered.
250    * @param _reserve From where the ERC20 token are sent to the purchaser.
251    * @param _token Deployed ERC20 token address.
252    * @param _rate Purchase rate, how many ERC20 for the given ETH.
253    */
254   constructor(
255     address _wallet,
256     address _reserve,
257     address _token,
258     uint _rate
259   )
260     public
261   {
262     require(_wallet != address(0), "_wallet == address(0)");
263     require(_reserve != address(0), "_reserve == address(0)");
264     require(_token != address(0), "_token == address(0)");
265     require(_rate != 0, "_rate == 0");
266     wallet = _wallet;
267     reserve = _reserve;
268     token = ERC20(_token);
269     rate = _rate;
270   }
271 
272   function() public payable {
273     releaseTokensTo(msg.sender);
274   }
275 
276   /**
277    * @dev Release purchased ERC20 to the buyer.
278    * @param _receiver Where the ERC20 are transfered.
279    */
280   function releaseTokensTo(address _receiver)
281     internal
282     whenNotPaused
283     returns (bool) 
284   {
285     uint amount = msg.value.mul(rate);
286     wallet.transfer(msg.value);
287     require(
288       token.transferFrom(reserve, _receiver, amount),
289       "transferFrom reserve to _receiver failed"
290     );
291     return true;
292   }
293 
294   /**
295    * @dev Set wallet.
296    * @param _wallet Where the ETH are redirected.
297    */
298   function setWallet(address _wallet) public onlyOwner returns (bool) {
299     require(_wallet != address(0), "_wallet == 0");
300     require(_wallet != wallet, "_wallet == wallet");
301     wallet = _wallet;
302     emit LogSetWallet(wallet);
303     return true;
304   }
305 
306   /**
307    * @dev Set ERC20 reserve.
308    * @param _reserve Where ERC20 are stored.
309    */
310   function setReserve(address _reserve) public onlyOwner returns (bool) {
311     require(_reserve != address(0), "_reserve == 0");
312     require(_reserve != reserve, "_reserve == reserve");
313     reserve = _reserve;
314     emit LogSetReserve(reserve);
315     return true;
316   }
317 
318   /**
319    * @dev Set ERC20 token.
320    * @param _token ERC20 token address.
321    */
322   function setToken(address _token) public onlyOwner returns (bool) {
323     require(_token != address(0), "_token == 0");
324     require(_token != address(token), "_token == token");
325     token = ERC20(_token);
326     emit LogSetToken(token);
327     return true;
328   }
329 
330   /**
331    * @dev Set rate.
332    * @param _rate Multiplier, how many ERC20 for the given ETH.
333    */
334   function setRate(uint _rate) public onlyOwner returns (bool) {
335     require(_rate != 0, "_rate == 0");
336     require(_rate != rate, "_rate == rate");
337     rate = _rate;
338     emit LogSetrate(rate);
339     return true;
340   }
341 
342   /**
343    * @dev Eventually withdraw airdropped token.
344    * @param _token ERC20 address to be withdrawed.
345    */
346   function withdrawAirdrop(ERC20 _token)
347     public
348     onlyOwner
349     returns(bool)
350   {
351     require(address(_token) != 0, "_token address == 0");
352     require(
353       _token.balanceOf(this) > 0,
354       "dropped token balance == 0"
355     );
356     uint256 airdroppedTokenAmount = _token.balanceOf(this);
357     _token.transfer(msg.sender, airdroppedTokenAmount);
358     emit LogWithdrawAirdrop(msg.sender, _token, airdroppedTokenAmount);
359     return true;
360   }
361 }