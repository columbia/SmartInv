1 pragma solidity 0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // ----------------------------------------------------------------------------
36 // ERC Token Standard #20 Interface
37 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
38 // ----------------------------------------------------------------------------
39 contract ERC20Interface {
40     function totalSupply() public constant returns (uint256);
41     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
43     function transfer(address to, uint256 tokens) public returns (bool success);
44     function approve(address spender, uint256 tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
46 
47     function mint(address _to, uint256 _amount) public returns (bool);
48 
49     event Transfer(address indexed from, address indexed to, uint256 tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
51 }
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         require(_newOwner != address(0));
72         require(owner == msg.sender);
73         emit OwnershipTransferred(owner, _newOwner);
74         owner = _newOwner;
75     }
76 }
77 
78 /**
79  * @title AllstocksCrowdsale
80  * @dev Crowdsale is a base contract for managing a token crowdsale,
81  * allowing investors to purchase tokens with ether. This contract implements
82  * such functionality in its most fundamental form and can be extended to provide additional
83  * functionality and/or custom behavior.
84  * The external interface represents the basic interface for purchasing tokens, and conform
85  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
86  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
87  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
88  * behavior.
89  */
90 
91 contract AllstocksCrowdsale is Owned {
92   using SafeMath for uint256;
93 
94   // The token being sold
95   //ERC20Interface public token;
96   address public token;
97 
98   // Address where funds are collected
99   address public ethFundDeposit; 
100 
101   // How many token units a buyer gets per wei // starts with 625 Allstocks tokens per 1 ETH
102   uint256 public tokenExchangeRate = 625;                         
103   
104   // 25m hard cap
105   uint256 public tokenCreationCap =  25 * (10**6) * 10**18; // 25m maximum; 
106 
107   //2.5m softcap
108   uint256 public tokenCreationMin =  25 * (10**5) * 10**18; // 2.5m minimum
109 
110   // Amount of wei raised
111   uint256 public _raised = 0;
112   
113   // switched to true in after setup
114   bool public isActive = false;                 
115  
116   //start time 
117   uint256 public fundingStartTime = 0;
118    
119   //end time
120   uint256 public fundingEndTime = 0;
121 
122   // switched to true in operational state
123   bool public isFinalized = false; 
124   
125   //refund list - will hold a list of all contributers 
126   mapping(address => uint256) public refunds;
127 
128   /**
129    * Event for token Allocate logging
130    * @param allocator for the tokens
131    * @param beneficiary who got the tokens
132    * @param amount amount of tokens purchased
133    */
134   event TokenAllocated(address indexed allocator, address indexed beneficiary, uint256 amount);
135 
136   event LogRefund(address indexed _to, uint256 _value);
137 
138   constructor() public {
139       tokenExchangeRate = 625;
140   }
141 
142   function setup (uint256 _fundingStartTime, uint256 _fundingEndTime, address _token) onlyOwner external {
143     require (isActive == false); 
144     require (isFinalized == false); 			        	   
145     require (msg.sender == owner);                // locks finalize to the ultimate ETH owner
146     require(_fundingStartTime > 0);
147     require(_fundingEndTime > 0 && _fundingEndTime > _fundingStartTime);
148     require(_token != address(0));
149 
150     isFinalized = false;                          // controls pre through crowdsale state
151     isActive = true;                              // set sale status to be true
152     ethFundDeposit = owner;                       // set ETH wallet owner 
153     fundingStartTime = _fundingStartTime;
154     fundingEndTime = _fundingEndTime;
155     //set token
156     token = _token;
157   }
158 
159   /// @dev send funding to safe wallet if minimum is reached 
160   function vaultFunds() public onlyOwner {
161     require(msg.sender == owner);                    // Allstocks double chack
162     require(_raised >= tokenCreationMin);            // have to sell minimum to move to operational 
163     ethFundDeposit.transfer(address(this).balance);  // send the eth to Allstocks
164   }  
165 
166   // -----------------------------------------
167   // Crowdsale external interface
168   // -----------------------------------------
169 
170   /**
171    * @dev fallback function ***DO NOT OVERRIDE***
172    */
173   function () external payable {
174     buyTokens(msg.sender, msg.value);
175   }
176 
177   /**
178    * @dev low level token purchase ***DO NOT OVERRIDE***
179    * @param _beneficiary Address performing the token purchase
180    */
181   function buyTokens(address _beneficiary, uint256 _value) internal {
182     _preValidatePurchase(_beneficiary, _value);
183     // calculate token amount to be created
184     uint256 tokens = _getTokenAmount(_value);
185     // update state
186     uint256 checkedSupply = _raised.add(tokens);
187     //check that we are not over cap
188     require(checkedSupply <= tokenCreationCap);
189     _raised = checkedSupply;
190     bool mined = ERC20Interface(token).mint(_beneficiary, tokens);
191     require(mined);
192     //add sent eth to refunds list
193     refunds[_beneficiary] = _value.add(refunds[_beneficiary]);  // safeAdd 
194     emit TokenAllocated(this, _beneficiary, tokens); // log it
195     //forward funds to deposite only in minimum was reached
196     if(_raised >= tokenCreationMin) {
197       _forwardFunds();
198     }
199   }
200 
201   // @dev method for manageing bonus phases 
202 	function setRate(uint256 _value) external onlyOwner {
203     require (isActive == true);
204     require(msg.sender == owner); // Allstocks double check owner   
205     // Range is set between 500 to 625, based on the bonus program stated in whitepaper.
206     // Upper range is set to 1500 (x3 times margin based on ETH price) .
207     require (_value >= 500 && _value <= 1500); 
208     tokenExchangeRate = _value;
209   }
210 
211   // @dev method for allocate tokens to beneficiary account 
212   function allocate(address _beneficiary, uint256 _value) public onlyOwner returns (bool success) {
213     require (isActive == true);          // sale have to be active
214     require (_value > 0);                // value must be greater then 0 
215     require (msg.sender == owner);       // Allstocks double chack 
216     require(_beneficiary != address(0)); // none empty address
217     uint256 checkedSupply = _raised.add(_value); 
218     require(checkedSupply <= tokenCreationCap); //check that we dont over cap
219     _raised = checkedSupply;
220     bool sent = ERC20Interface(token).mint(_beneficiary, _value); // mint using ERC20 interface
221     require(sent); 
222     emit TokenAllocated(this, _beneficiary, _value); // log it
223     return true;
224   }
225 
226   //claim back token ownership 
227   function transferTokenOwnership(address _newTokenOwner) public onlyOwner {
228     require(_newTokenOwner != address(0));
229     require(owner == msg.sender);
230     Owned(token).transferOwnership(_newTokenOwner);
231   }
232 
233   /// @dev Allows contributors to recover their ether in the case of a failed funding campaign.
234   function refund() external {
235     require (isFinalized == false);  // prevents refund if operational
236     require (isActive == true);      // only if sale is active
237     require (now > fundingEndTime);  // prevents refund until sale period is over
238     require(_raised < tokenCreationMin);  // no refunds if we sold enough
239     require(msg.sender != owner);         // Allstocks not entitled to a refund
240     //get contribution amount in eth
241     uint256 ethValRefund = refunds[msg.sender];
242     //refund should be greater then zero
243     require(ethValRefund > 0);
244     //zero sender refund balance
245     refunds[msg.sender] = 0;
246     //check user balance
247     uint256 allstocksVal = ERC20Interface(token).balanceOf(msg.sender);
248     //substruct from total raised - please notice main assumption is that tokens are not tradeble at this stage.
249     _raised = _raised.sub(allstocksVal);               // extra safe
250     //send eth back to user
251     msg.sender.transfer(ethValRefund);                 // if you're using a contract; make sure it works with .send gas limits
252     emit LogRefund(msg.sender, ethValRefund);          // log it
253   }
254 
255    /// @dev Ends the funding period and sends the ETH home
256   function finalize() external onlyOwner {
257     require (isFinalized == false);
258     require(msg.sender == owner); // Allstocks double chack  
259     require(_raised >= tokenCreationMin);  // have to sell minimum to move to operational
260     require(_raised > 0);
261 
262     if (now < fundingEndTime) {    //if try to close before end time, check that we reach max cap
263       require(_raised >= tokenCreationCap);
264     }
265     else 
266       require(now >= fundingEndTime); //allow finilize only after time ends
267     
268     //transfer token ownership back to original owner
269     transferTokenOwnership(owner);
270     // move to operational
271     isFinalized = true;
272     vaultFunds();  // send the eth to Allstocks
273   }
274 
275   // -----------------------------------------
276   // Internal interface (extensible)
277   // -----------------------------------------
278 
279   /**
280    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
281    * @param _beneficiary Address performing the token purchase
282    * @param _weiAmount Value in wei involved in the purchase
283    */
284   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) view internal {
285     require(now >= fundingStartTime);
286     require(now < fundingEndTime); 
287     require(_beneficiary != address(0));
288     require(_weiAmount != 0);
289   }
290 
291   /**
292    * @dev Override to extend the way in which ether is converted to tokens.
293    * @param _weiAmount Value in wei to be converted into tokens
294    * @return Number of tokens that can be purchased with the specified _weiAmount
295    */
296   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
297     return _weiAmount.mul(tokenExchangeRate);
298   }
299 
300   /**
301    * @dev Determines how ETH is stored/forwarded on purchases.
302    */
303   function _forwardFunds() internal {
304     ethFundDeposit.transfer(msg.value);
305   }
306 }