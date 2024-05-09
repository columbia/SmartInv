1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   constructor() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     emit OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 }
85 
86 /**
87  * @title Pausable
88  * @dev Base contract which allows children to implement an emergency stop mechanism.
89  */
90 contract Pausable is Ownable {
91   event Pause();
92   event Unpause();
93 
94   bool public paused = false;
95 
96   /**
97    * @dev Modifier to make a function callable only when the contract is not paused.
98    */
99   modifier whenNotPaused() {
100     require(!paused);
101     _;
102   }
103 
104   /**
105    * @dev Modifier to make a function callable only when the contract is paused.
106    */
107   modifier whenPaused() {
108     require(paused);
109     _;
110   }
111 
112   /**
113    * @dev called by the owner to pause, triggers stopped state
114    */
115   function pause() onlyOwner whenNotPaused public {
116     paused = true;
117     emit Pause();
118   }
119 
120   /**
121    * @dev called by the owner to unpause, returns to normal state
122    */
123   function unpause() onlyOwner whenPaused public {
124     paused = false;
125     emit Unpause();
126   }
127 }
128 
129 /**
130  * @title ERC20Basic
131  * @dev Simpler version of ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/179
133  */
134 contract ERC20Basic {
135   function totalSupply() public view returns (uint256);
136   function balanceOf(address who) public view returns (uint256);
137   function transfer(address to, uint256 value) public returns (bool);
138   event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146   function allowance(address owner, address spender) public view returns (uint256);
147   function transferFrom(address from, address to, uint256 value) public returns (bool);
148   function approve(address spender, uint256 value) public returns (bool);
149   event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 /**
153  * @title SafeERC20
154  * @dev Wrappers around ERC20 operations that throw on failure.
155  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
156  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
157  */
158 library SafeERC20 {
159   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
160     require(token.transfer(to, value));
161   }
162 
163   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
164     require(token.transferFrom(from, to, value));
165   }
166 
167   function safeApprove(ERC20 token, address spender, uint256 value) internal {
168     require(token.approve(spender, value));
169   }
170 }
171 
172 contract NamedToken is ERC20 {
173    string public name;
174    string public symbol;
175 }
176 
177 contract BitWich is Pausable {
178     using SafeMath for uint;
179     using SafeERC20 for ERC20;
180     
181     event LogBought(address indexed buyer, uint buyCost, uint amount);
182     event LogSold(address indexed seller, uint sellValue, uint amount);
183     event LogPriceChanged(uint newBuyCost, uint newSellValue);
184 
185     // ERC20 contract to operate over
186     ERC20 public erc20Contract;
187 
188     // amount bought - amount sold = amount willing to buy from others
189     uint public netAmountBought;
190     
191     // number of tokens that can be bought from contract per wei sent
192     uint public buyCost;
193     
194     // number of tokens that can be sold to contract per wei received
195     uint public sellValue;
196     
197     constructor(uint _buyCost, 
198                 uint _sellValue,
199                 address _erc20ContractAddress) public {
200         require(_buyCost > 0);
201         require(_sellValue > 0);
202         
203         buyCost = _buyCost;
204         sellValue = _sellValue;
205         erc20Contract = NamedToken(_erc20ContractAddress);
206     }
207     
208     /* ACCESSORS */
209     function tokenName() external view returns (string) {
210         return NamedToken(erc20Contract).name();
211     }
212     
213     function tokenSymbol() external view returns (string) {
214         return NamedToken(erc20Contract).symbol();
215     }
216     
217     function amountForSale() external view returns (uint) {
218         return erc20Contract.balanceOf(address(this));
219     }
220     
221     // Accessor for the cost in wei of buying a certain amount of tokens.
222     function getBuyCost(uint _amount) external view returns(uint) {
223         uint cost = _amount.div(buyCost);
224         if (_amount % buyCost != 0) {
225             cost = cost.add(1); // Handles truncating error for odd buyCosts
226         }
227         return cost;
228     }
229     
230     // Accessor for the value in wei of selling a certain amount of tokens.
231     function getSellValue(uint _amount) external view returns(uint) {
232         return _amount.div(sellValue);
233     }
234     
235     /* PUBLIC FUNCTIONS */
236     // Perform the buy of tokens for ETH and add to the net amount bought
237     function buy(uint _minAmountDesired) external payable whenNotPaused {
238         processBuy(msg.sender, _minAmountDesired);
239     }
240     
241     // Perform the sell of tokens, send ETH to the seller, and reduce the net amount bought
242     // NOTE: seller must call ERC20.approve() first before calling this,
243     //       unless they can use ERC20.approveAndCall() directly
244     function sell(uint _amount, uint _weiExpected) external whenNotPaused {
245         processSell(msg.sender, _amount, _weiExpected);
246     }
247     
248     /* INTERNAL FUNCTIONS */
249     // NOTE: _minAmountDesired protects against cost increase between send time and process time
250     function processBuy(address _buyer, uint _minAmountDesired) internal {
251         uint amountPurchased = msg.value.mul(buyCost);
252         require(erc20Contract.balanceOf(address(this)) >= amountPurchased);
253         require(amountPurchased >= _minAmountDesired);
254         
255         netAmountBought = netAmountBought.add(amountPurchased);
256         emit LogBought(_buyer, buyCost, amountPurchased);
257 
258         erc20Contract.safeTransfer(_buyer, amountPurchased);
259     }
260     
261     // NOTE: _weiExpected protects against a value decrease between send time and process time
262     function processSell(address _seller, uint _amount, uint _weiExpected) internal {
263         require(netAmountBought >= _amount);
264         require(erc20Contract.allowance(_seller, address(this)) >= _amount);
265         uint value = _amount.div(sellValue); // tokens divided by (tokens per wei) equals wei
266         require(value >= _weiExpected);
267         assert(address(this).balance >= value); // contract should always have enough wei
268         _amount = value.mul(sellValue); // in case of rounding down, reduce the _amount sold
269         
270         netAmountBought = netAmountBought.sub(_amount);
271         emit LogSold(_seller, sellValue, _amount);
272         
273         erc20Contract.safeTransferFrom(_seller, address(this), _amount);
274         _seller.transfer(value);
275     }
276     
277     // NOTE: this should never return true unless this contract has a bug 
278     function lacksFunds() external view returns(bool) {
279         return address(this).balance < getRequiredBalance(sellValue);
280     }
281     
282     /* OWNER FUNCTIONS */
283     // Owner function to check how much extra ETH is available to cash out
284     function amountAvailableToCashout() external view onlyOwner returns (uint) {
285         return address(this).balance.sub(getRequiredBalance(sellValue));
286     }
287 
288     // Owner function for cashing out extra ETH not needed for buying tokens
289     function cashout() external onlyOwner {
290         uint requiredBalance = getRequiredBalance(sellValue);
291         assert(address(this).balance >= requiredBalance);
292         
293         owner.transfer(address(this).balance.sub(requiredBalance));
294     }
295     
296     // Owner function for closing the paused contract and cashing out all tokens and ETH
297     function close() public onlyOwner whenPaused {
298         erc20Contract.transfer(owner, erc20Contract.balanceOf(address(this)));
299         selfdestruct(owner);
300     }
301     
302     // Owner accessor to get how much ETH is needed to send 
303     // in order to change sell price to proposed price
304     function extraBalanceNeeded(uint _proposedSellValue) external view onlyOwner returns (uint) {
305         uint requiredBalance = getRequiredBalance(_proposedSellValue);
306         return (requiredBalance > address(this).balance) ? requiredBalance.sub(address(this).balance) : 0;
307     }
308     
309     // Owner function for adjusting prices (might need to add ETH if raising sell price)
310     function adjustPrices(uint _buyCost, uint _sellValue) external payable onlyOwner whenPaused {
311         buyCost = _buyCost == 0 ? buyCost : _buyCost;
312         sellValue = _sellValue == 0 ? sellValue : _sellValue;
313         
314         uint requiredBalance = getRequiredBalance(sellValue);
315         require(msg.value.add(address(this).balance) >= requiredBalance);
316         
317         emit LogPriceChanged(buyCost, sellValue);
318     }
319     
320     function getRequiredBalance(uint _proposedSellValue) internal view returns (uint) {
321         return netAmountBought.div(_proposedSellValue).add(1);
322     }
323     
324     // Owner can transfer out any accidentally sent ERC20 tokens
325     // excluding the token intended for this contract
326     function transferAnyERC20Token(address _address, uint _tokens) external onlyOwner {
327         require(_address != address(erc20Contract));
328         
329         ERC20(_address).safeTransfer(owner, _tokens);
330     }
331 }
332 
333 contract BitWichLoom is BitWich {
334     constructor() 
335             BitWich(800, 1300, 0xA4e8C3Ec456107eA67d3075bF9e3DF3A75823DB0) public {
336     }
337 }