1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
67 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused);
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() public onlyOwner whenNotPaused {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() public onlyOwner whenPaused {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
125     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
126     // benefit is lost if 'b' is also tested.
127     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
128     if (_a == 0) {
129       return 0;
130     }
131 
132     c = _a * _b;
133     assert(c / _a == _b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
141     // assert(_b > 0); // Solidity automatically throws when dividing by 0
142     // uint256 c = _a / _b;
143     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
144     return _a / _b;
145   }
146 
147   /**
148   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
151     assert(_b <= _a);
152     return _a - _b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
159     c = _a + _b;
160     assert(c >= _a);
161     return c;
162   }
163 }
164 
165 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
166 
167 /**
168  * @title ERC20Basic
169  * @dev Simpler version of ERC20 interface
170  * See https://github.com/ethereum/EIPs/issues/179
171  */
172 contract ERC20Basic {
173   function totalSupply() public view returns (uint256);
174   function balanceOf(address _who) public view returns (uint256);
175   function transfer(address _to, uint256 _value) public returns (bool);
176   event Transfer(address indexed from, address indexed to, uint256 value);
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address _owner, address _spender)
187     public view returns (uint256);
188 
189   function transferFrom(address _from, address _to, uint256 _value)
190     public returns (bool);
191 
192   function approve(address _spender, uint256 _value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: contracts/luckybox/LuckyBox.sol
201 
202 contract LuckyBox is Pausable {
203     using SafeMath for *;
204 
205     uint256 public goldBoxAmountForSale;
206     uint256 public silverBoxAmountForSale;
207 
208     uint256 public goldBoxPrice;    // amount of eth for each gold bag.
209     uint256 public silverBoxPrice;
210 
211     address public wallet;
212 
213     mapping (address => uint256) public goldSalesRecord;
214     mapping (address => uint256) public silverSalesRecord;
215 
216     uint256 public goldSaleLimit;
217     uint256 public silverSaleLimit;
218 
219     constructor(address _wallet, uint256 _goldBoxAmountForSale, uint256 _silverBoxAmountForSale) public
220     {
221         require(_wallet != address(0), "need a good wallet to store fund");
222         require(_goldBoxAmountForSale > 0, "Gold bag amount need to be no-zero");
223         require(_silverBoxAmountForSale > 0, "Silver bag amount need to be no-zero");
224 
225         wallet = _wallet;
226         goldBoxAmountForSale = _goldBoxAmountForSale;
227         silverBoxAmountForSale = _silverBoxAmountForSale;
228 
229         goldSaleLimit = 10;
230         silverSaleLimit = 100;
231     }
232 
233     function buyBoxs(address _buyer, uint256 _goldBoxAmount, uint256 _silverBoxAmount) payable public whenNotPaused {
234         require(_buyer != address(0));
235         require(_goldBoxAmount <= goldBoxAmountForSale && _silverBoxAmount <= silverBoxAmountForSale);
236         require(goldSalesRecord[_buyer] + _goldBoxAmount <= goldSaleLimit);
237         require(silverSalesRecord[_buyer] + _silverBoxAmount <= silverSaleLimit);
238 
239         uint256 charge = _goldBoxAmount.mul(goldBoxPrice).add(_silverBoxAmount.mul(silverBoxPrice));
240         require(msg.value >= charge, "No enough ether for buying lucky bags.");
241         require(_goldBoxAmount > 0 || _silverBoxAmount > 0);
242 
243         if (_goldBoxAmount > 0)
244         {
245             goldBoxAmountForSale = goldBoxAmountForSale.sub(_goldBoxAmount);
246             goldSalesRecord[_buyer] += _goldBoxAmount;
247             emit GoldBoxSale(_buyer, _goldBoxAmount, goldBoxPrice);
248         }
249 
250         if (_silverBoxAmount > 0)
251         {
252             silverBoxAmountForSale = silverBoxAmountForSale.sub(_silverBoxAmount);
253             silverSalesRecord[_buyer] += _silverBoxAmount;
254             emit SilverBoxSale(_buyer, _silverBoxAmount, silverBoxPrice);
255         }
256 
257         wallet.transfer(charge);
258 
259         if (msg.value > charge)
260         {
261             uint256 weiToRefund = msg.value.sub(charge);
262             _buyer.transfer(weiToRefund);
263             emit EthRefunded(_buyer, weiToRefund);
264         }
265     }
266 
267     function buyBoxs(uint256 _goldBoxAmount, uint256 _silverBoxAmount) payable public whenNotPaused {
268         buyBoxs(msg.sender, _goldBoxAmount, _silverBoxAmount);
269     }
270 
271     function updateGoldBoxAmountAndPrice(uint256 _goldBoxAmountForSale, uint256 _goldBoxPrice, uint256 _goldLimit) public onlyOwner {
272         goldBoxAmountForSale = _goldBoxAmountForSale;
273         goldBoxPrice = _goldBoxPrice;
274         goldSaleLimit = _goldLimit;
275     }
276 
277     function updateSilverBoxAmountAndPrice(uint256 _silverBoxAmountForSale, uint256 _silverBoxPrice, uint256 _silverLimit) public onlyOwner {
278         silverBoxAmountForSale = _silverBoxAmountForSale;
279         silverBoxPrice = _silverBoxPrice;
280         silverSaleLimit = _silverLimit;
281     }
282 
283 
284 //////////
285 // Safety Methods
286 //////////
287 
288     /// @notice This method can be used by the controller to extract mistakenly
289     ///  sent tokens to this contract.
290     /// @param _token The address of the token contract that you want to recover
291     ///  set to 0 in case you want to extract ether.
292     function claimTokens(address _token) onlyOwner public {
293       if (_token == 0x0) {
294           owner.transfer(address(this).balance);
295           return;
296       }
297 
298       ERC20 token = ERC20(_token);
299       uint balance = token.balanceOf(this);
300       token.transfer(owner, balance);
301 
302       emit ClaimedTokens(_token, owner, balance);
303     }
304 
305 
306     event GoldBoxSale(address indexed _user, uint256 _amount, uint256 _price);
307     
308     event SilverBoxSale(address indexed _user, uint256 _amount, uint256 _price);
309 
310     event EthRefunded(address indexed buyer, uint256 value);
311 
312     event ClaimedTokens(address indexed _token, address indexed _to, uint _amount);
313 
314 }