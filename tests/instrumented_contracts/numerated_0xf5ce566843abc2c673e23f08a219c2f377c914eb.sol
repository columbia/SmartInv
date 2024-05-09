1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   /**
26   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 contract ERC20Basic {
43   function totalSupply() public view returns (uint256);
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public view returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 /**
92  * @title Destructible
93  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
94  */
95 contract Destructible is Ownable {
96 
97   function Destructible() public payable { }
98 
99   /**
100    * @dev Transfers the current balance to the owner and terminates the contract.
101    */
102   function destroy() onlyOwner public {
103     selfdestruct(owner);
104   }
105 
106   function destroyAndSend(address _recipient) onlyOwner public {
107     selfdestruct(_recipient);
108   }
109 }
110 
111 /**
112  * @title Pausable
113  * @dev Base contract which allows children to implement an emergency stop mechanism.
114  */
115 contract Pausable is Ownable {
116   event Pause();
117   event Unpause();
118 
119   bool public paused = false;
120 
121 
122   /**
123    * @dev Modifier to make a function callable only when the contract is not paused.
124    */
125   modifier whenNotPaused() {
126     require(!paused);
127     _;
128   }
129 
130   /**
131    * @dev Modifier to make a function callable only when the contract is paused.
132    */
133   modifier whenPaused() {
134     require(paused);
135     _;
136   }
137 
138   /**
139    * @dev called by the owner to pause, triggers stopped state
140    */
141   function pause() onlyOwner whenNotPaused public {
142     paused = true;
143     Pause();
144   }
145 
146   /**
147    * @dev called by the owner to unpause, returns to normal state
148    */
149   function unpause() onlyOwner whenPaused public {
150     paused = false;
151     Unpause();
152   }
153 }
154 
155 /**
156  * @dev XGETokensale contract describes deatils of
157  * Exchangeable Gram Equivalent tokensale
158  */
159 contract XGETokensale is Pausable, Destructible {
160     using SafeMath for uint256;
161 
162     // The token being sold
163     ERC20 public token;
164 
165     // Address where funds are collected
166     address public wallet;    
167 
168     // Amount of wei raised
169     uint256 public weiRaised;
170 
171     /**
172      * @dev Price of XGE token in dollars is fixed as 1.995
173      * so in order to calculate the right price from this variable
174      * we need to divide result by 1000
175      */
176     uint256 public USDXGE = 1995;
177 
178     /**
179      * @dev Price of ETH in dollars
180      * To save percition we base it onto 10**18
181      * and mutiply by 1000 to compensate USGXGE
182      */
183     uint256 public USDETH = 400 * 10**21;
184 
185     /**
186      * @dev minimum amount of tokens that can be bought
187      */
188     uint256 public MIN_AMOUNT = 100 * 10**18;
189 
190     /**
191      * Whitelist of approved buyers
192      */
193     mapping(address => uint8) public whitelist;
194 
195     /**
196      * Event for token purchase logging
197      * @param purchaser who paid for the tokens
198      * @param beneficiary who got the tokens
199      * @param value weis paid for purchase
200      * @param amount amount of tokens purchased
201      */
202     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
203 
204     /**
205      * Event for adding new beneficeary account to the contract whitelist
206      * @param beneficiary who will get the tokens
207      */
208     event WhitelistAdd(address indexed beneficiary);
209     
210     /**
211      * Event for removing beneficeary account from the contract whitelist
212      * @param beneficiary who was gonna get the tokens
213      */
214     event WhitelistRemove(address indexed beneficiary);
215 
216     /**
217      * Event for update USD/ETH conversion rate
218      * @param oldRate old rate
219      * @param newRate new rate
220      */
221     event USDETHRateUpdate(uint256 oldRate, uint256 newRate);
222     
223     /**
224      * Event for update USD/XGE conversion rate
225      * @param oldRate old rate
226      * @param newRate new rate
227      */
228     event USDXGERateUpdate(uint256 oldRate, uint256 newRate);
229   
230     /**
231      * @dev XGETokensale constructor
232      * @param _wallet wallet that will hold the main balance
233      * @param _token address of deployed XGEToken contract
234      */
235     function XGETokensale(address _wallet, ERC20 _token) public
236     {
237         require(_wallet != address(0));
238         require(_token != address(0));
239 
240         owner = msg.sender;
241         wallet = _wallet;
242         token = _token;
243     }
244 
245     /**
246      * @dev fallback function ***DO NOT OVERRIDE***
247      */
248     function () external payable {
249         buyTokens(msg.sender);
250     }
251 
252     /**
253      * @dev Function that updates ETH/USD rate
254      * Meant too be called only by owner
255      */
256     function updateUSDETH(uint256 rate) public onlyOwner {
257         require(rate > 0);
258         USDETHRateUpdate(USDETH, rate * 10**18);
259         USDETH = rate * 10**18;
260     }
261 
262     /**
263      * @dev Function that updates ETH/XGE rate
264      * Meant too be called only by owner
265      */
266     function updateUSDXGE(uint256 rate) public onlyOwner {
267         require(rate > 0);
268         USDETHRateUpdate(USDXGE, rate);
269         USDXGE = rate;
270     }
271 
272     /**
273      * @dev Mail method that contains tokensale logic
274      */
275     function buyTokens(address _beneficiary) public payable {
276         require(_beneficiary != address(0));
277         require(whitelist[_beneficiary] != 0);
278         require(msg.value != 0);
279 
280         uint256 weiAmount = msg.value;
281         uint256 rate = USDETH.div(USDXGE);
282 
283         uint256 tokens = weiAmount.mul(rate).div(10**18);
284 
285         // Revert if amount of tokens less then minimum
286         if (tokens < MIN_AMOUNT) {
287             revert();
288         }
289 
290         weiRaised = weiRaised.add(weiAmount);
291         token.transferFrom(owner, _beneficiary, tokens);
292         TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
293 
294         wallet.transfer(weiAmount);
295     }
296 
297     /**
298      * @dev Add buyer to whitelist so it will possbile for him to buy a token
299      * @param buyer address to add
300      */
301     function addToWhitelist(address buyer) public onlyOwner {
302         require(buyer != address(0));
303         whitelist[buyer] = 1;
304         WhitelistAdd(buyer);
305     }
306 
307     /**
308      * @dev Remove buyer fromt whitelist
309      * @param buyer address to remove
310      */
311     function removeFromWhitelist(address buyer) public onlyOwner {
312         require(buyer != address(0));
313         delete whitelist[buyer];
314         WhitelistRemove(buyer);
315     }
316 }