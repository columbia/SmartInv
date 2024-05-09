1 pragma solidity ^0.4.24;
2 
3 // File: c:/ich/contracts/SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: c:/ich/contracts/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: c:/ich/contracts/Pausable.sol
94 
95 /**
96  * @title Pausable
97  * @dev Base contract which allows children to implement an emergency stop mechanism.
98  */
99 contract Pausable is Ownable {
100   event Pause();
101   event Unpause();
102 
103   bool public paused = false;
104 
105 
106   /**
107    * @dev Modifier to make a function callable only when the contract is not paused.
108    */
109   modifier whenNotPaused() {
110     require(!paused);
111     _;
112   }
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is paused.
116    */
117   modifier whenPaused() {
118     require(paused);
119     _;
120   }
121 
122   /**
123    * @dev called by the owner to pause, triggers stopped state
124    */
125   function pause() onlyOwner whenNotPaused public {
126     paused = true;
127     emit Pause();
128   }
129 
130   /**
131    * @dev called by the owner to unpause, returns to normal state
132    */
133   function unpause() onlyOwner whenPaused public {
134     paused = false;
135     emit Unpause();
136   }
137 }
138 
139 // File: c:/ich/contracts/ERC20Basic.sol
140 
141 /**
142  * @title ERC20Basic
143  * @dev Simpler version of ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/179
145  */
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 // File: c:/ich/contracts/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   function setCrowdsale(address tokenWallet, uint256 amount) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: C:/ich/contracts/depCrowd.sol
168 
169 contract crowdsaleContract is Pausable {
170   using SafeMath for uint256;
171 
172   struct Period {
173     uint256 startTimestamp;
174     uint256 endTimestamp;
175     uint256 rate;
176   }
177 
178   Period[] private periods;
179 
180   ERC20 public token;
181   address public wallet;
182   address public tokenWallet;
183   uint256 public weiRaised;
184 
185   /**
186    * @dev A purchase was made.
187    * @param _purchaser Who paid for the tokens.
188    * @param _value Total purchase price in weis.
189    * @param _amount Amount of tokens purchased.
190    */
191   event TokensPurchased(address indexed _purchaser, uint256 _value, uint256 _amount);
192 
193   /**
194    * @dev Constructor, takes initial parameters.
195    * @param _wallet Address where collected funds will be forwarded to.
196    * @param _token Address of the token being sold.
197    * @param _tokenWallet Address holding the tokens, which has approved allowance to this contract.
198    */
199   function crowdsaleContract (address _wallet, address _token, address _tokenWallet, uint maxToken, address realOwner) public {
200     require(_wallet != address(0));
201     require(_token != address(0));
202     require(_tokenWallet != address(0));
203     transferOwnership(realOwner);
204     wallet = _wallet;
205     token = ERC20(_token);
206     tokenWallet = _tokenWallet;
207     require(token.setCrowdsale(_tokenWallet, maxToken));
208   }
209 
210   /**
211    * @dev Send weis, get tokens.
212    */
213   function () external payable {
214     // Preconditions.
215     require(msg.sender != address(0));
216     require(isOpen());
217     uint256 tokenAmount = getTokenAmount(msg.value);
218     if(tokenAmount > remainingTokens()){
219       revert();
220     }
221     weiRaised = weiRaised.add(msg.value);
222 
223     token.transferFrom(tokenWallet, msg.sender, tokenAmount);
224     emit TokensPurchased(msg.sender, msg.value, tokenAmount);
225 
226     wallet.transfer(msg.value);
227   }
228 
229   /**
230    * @dev Add a sale period with its default rate.
231    * @param _startTimestamp Beginning of this sale period.
232    * @param _endTimestamp End of this sale period.
233    * @param _rate Rate at which tokens are sold during this sale period.
234    */
235   function addPeriod(uint256 _startTimestamp, uint256 _endTimestamp, uint256 _rate) onlyOwner public {
236     require(_startTimestamp != 0);
237     require(_endTimestamp > _startTimestamp);
238     require(_rate != 0);
239     Period memory period = Period(_startTimestamp, _endTimestamp, _rate);
240     periods.push(period);
241   }
242 
243   /**
244    * @dev Emergency function to clear all sale periods (for example in case the sale is delayed).
245    */
246   function clearPeriods() onlyOwner public {
247     delete periods;
248   }
249 
250   /**
251    * @dev True while the sale is open (i.e. accepting contributions). False otherwise.
252    */
253   function isOpen() view public returns (bool) {
254     return ((!paused) && (_getCurrentPeriod().rate != 0));
255   }
256 
257   /**
258    * @dev Current rate for the specified purchaser.
259    * @return Custom rate for the purchaser, or current standard rate if no custom rate was whitelisted.
260    */
261   function getCurrentRate() public view returns (uint256 rate) {
262     Period memory currentPeriod = _getCurrentPeriod();
263     require(currentPeriod.rate != 0);
264     rate = currentPeriod.rate;
265   }
266 
267   /**
268    * @dev Number of tokens that a specified address would get by sending right now
269    * the specified amount.
270    * @param _weiAmount Value in wei to be converted into tokens.
271    * @return Number of tokens that can be purchased with the specified _weiAmount.
272    */
273   function getTokenAmount(uint256 _weiAmount) public view returns (uint256) {
274     return _weiAmount.mul(getCurrentRate());
275   }
276 
277   /**
278    * @dev Checks the amount of tokens left in the allowance.
279    * @return Amount of tokens remaining for sale.
280    */
281   function remainingTokens() public view returns (uint256) {
282     return token.allowance(tokenWallet, this);
283   }
284 
285   /*
286    * Internal functions
287    */
288 
289   /**
290    * @dev Returns the current period, or null.
291    */
292   function _getCurrentPeriod() view internal returns (Period memory _period) {
293     _period = Period(0, 0, 0);
294     uint256 len = periods.length;
295     for (uint256 i = 0; i < len; i++) {
296       if ((periods[i].startTimestamp <= block.timestamp) && (periods[i].endTimestamp >= block.timestamp)) {
297         _period = periods[i];
298         break;
299       }
300     }
301   }
302 
303 }
304 
305 // File: ..\contracts\cDep.sol
306 
307 contract cDeployer is Ownable {
308 	
309 	address private main;
310 
311 	function cMain(address nM) public onlyOwner {
312 		main = nM;
313 	}
314 
315 	function deployCrowdsale(address _eWallet, address _token, address _tWallet, uint _maxToken, address reqBy) public returns (address) {
316 		require(msg.sender == main);
317 		crowdsaleContract newContract = new crowdsaleContract(_eWallet, _token, _tWallet, _maxToken, reqBy);
318 		return newContract;
319 	}
320 
321 }