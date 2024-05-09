1 pragma solidity 0.4.21;
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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 /////////////////////////////////////////////////////////////////
56 /**
57  * @title SafeMath
58  * @dev Math operations with safety checks that throw on error
59  */
60 library SafeMath {
61 
62   /**
63   * @dev Multiplies two numbers, throws on overflow.
64   */
65   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66     if (a == 0) {
67       return 0;
68     }
69     uint256 c = a * b;
70     assert(c / a == b);
71     return c;
72   }
73 
74   /**
75   * @dev Integer division of two numbers, truncating the quotient.
76   */
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return c;
82   }
83 
84   /**
85   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     assert(b <= a);
89     return a - b;
90   }
91 
92   /**
93   * @dev Adds two numbers, throws on overflow.
94   */
95   function add(uint256 a, uint256 b) internal pure returns (uint256) {
96     uint256 c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 //////////////////////////////////////////////////////
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   uint256 public totalSupply_;
113 
114   /**
115   * @dev total number of tokens in existence
116   */
117   function totalSupply() public view returns (uint256) {
118     return totalSupply_;
119   }
120 
121   /**
122   * @dev transfer token for a specified address
123   * @param _to The address to transfer to.
124   * @param _value The amount to be transferred.
125   */
126   function transfer(address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[msg.sender]);
129 
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     emit Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256) {
142     return balances[_owner];
143   }
144 
145 }
146 ///////////////////////////////////////////////////////////////
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152   function allowance(address owner, address spender) public view returns (uint256);
153   function transferFrom(address from, address to, uint256 value) public returns (bool);
154   function approve(address spender, uint256 value) public returns (bool);
155   event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract StandardToken is ERC20, BasicToken {
167 
168   mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185     emit Transfer(_from, _to, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191    *
192    * Beware that changing an allowance with this method brings the risk that someone may use both the old
193    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196    * @param _spender The address which will spend the funds.
197    * @param _value The amount of tokens to be spent.
198    */
199   function approve(address _spender, uint256 _value) public returns (bool) {
200     allowed[msg.sender][_spender] = _value;
201     emit Approval(msg.sender, _spender, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param _owner address The address which owns the funds.
208    * @param _spender address The address which will spend the funds.
209    * @return A uint256 specifying the amount of tokens still available for the spender.
210    */
211   function allowance(address _owner, address _spender) public view returns (uint256) {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To increment
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _addedValue The amount of tokens to increase the allowance by.
224    */
225   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 ////////////////////////////////////////////////////////////////////////
254 	contract TrypCrowdsale is StandardToken, Ownable {
255 	
256     using SafeMath for uint256;
257 
258 	string public name = "the Tryp"; 
259 	string public symbol = "Tryp";
260 	uint public decimals = 0;  // We don't want fractional tokens 
261 	uint256 public constant INITIAL_SUPPLY = 1000000;
262 
263   // The token being sold
264 
265 	StandardToken public token = this;
266 
267   // Addresses where funds are collected
268 
269 	address private constant prizewallet = (0x6eFd9391Db718dEff494C2199CD83E0EFc8102f6);
270 	address private constant prize2wallet = (0x426570e5b796A2845C700B4b49058E097f7dCb54);
271 	address private constant adminwallet = (0xe7d718cc663784480EBB62A672180fbB68f89424);
272 
273   // How many token units a buyer gets per wei
274 
275     uint256 public weiPerToken = 16000000000000000;
276 
277   // Amount of wei raised
278 
279 	uint256 public weiRaised;
280     uint256 public remainingSupply_;
281  
282   /**
283    * Event for token purchase logging
284    * @param purchaser who paid for the tokens
285    * @param beneficiary who got the tokens
286    * @param value weis paid for purchase
287    * @param amount amount of tokens purchased
288    */
289 
290     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
291 
292 
293 	
294     function TrypCrowdsale () public payable {
295 		
296 		totalSupply_ = INITIAL_SUPPLY;
297 		remainingSupply_ = INITIAL_SUPPLY;
298 		balances[msg.sender] = INITIAL_SUPPLY;
299 		emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
300 			
301 	}
302 
303 
304   // -----------------------------------------
305   // Crowdsale external interface
306   // -----------------------------------------
307 
308   /**
309    * @dev fallback function ***DO NOT OVERRIDE***
310    */
311 
312     function () external payable {
313         buyTokens(msg.sender);
314     }
315 
316   /**
317    * @dev low level token purchase ***DO NOT OVERRIDE***
318    * @param _beneficiary Address performing the token purchase
319    */
320     function buyTokens(address _beneficiary) public payable {
321 
322         uint256 weiAmount = msg.value;
323         _preValidatePurchase(_beneficiary, weiAmount);
324 
325     // calculate token amount to be sent
326         uint256 tokens = _getTokenAmount(weiAmount);
327         require(tokens <= remainingSupply_);
328 
329     // update state
330         weiRaised = weiRaised.add(weiAmount);
331 
332         _deliverTokens(_beneficiary, tokens);
333         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
334 
335         _forwardFunds();
336 
337     }
338 
339   // -----------------------------------------
340   // Internal interface (extensible)
341   // -----------------------------------------
342 
343   // Set cost of token in Eth.  Set rate in ETH * 1000 ie: 0.015 eth = setrate 15
344 
345     function setRate (uint256 _ethPriceToday) public onlyOwner {
346 
347         require(_ethPriceToday != 0);
348         weiPerToken = _ethPriceToday.mul(1e18).div(1000);
349     }    
350 
351   /**
352    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
353    * @param _beneficiary Address performing the token purchase
354    * @param _weiAmount Value in wei involved in the purchase
355    */
356 
357     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {
358         
359         require(_beneficiary != address(0));
360         require(_weiAmount != 0);
361     }
362 
363   /**
364    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
365    * @param _beneficiary Address performing the token purchase
366    * @param _tokenAmount Number of tokens to be emitted
367    */
368 
369     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
370 
371         token.transfer(_beneficiary, _tokenAmount);
372         remainingSupply_ = remainingSupply_.sub(_tokenAmount);
373     }
374 
375   // administrative use to correct any token transaction errors
376   
377     function deliverTokensAdmin(address _beneficiary, uint256 _tokenAmount) public onlyOwner {
378 
379         token.transfer(_beneficiary, _tokenAmount);
380         remainingSupply_ = remainingSupply_.sub(_tokenAmount);
381     }
382 
383 
384   /**
385    * @dev Override to extend the way in which ether is converted to tokens.
386    * @param _weiAmount Value in wei to be converted into tokens
387    * @return Number of tokens that can be purchased with the specified _weiAmount
388    */
389    
390    // token meant to be sold in whole numbers.  Round down to nearest whole to avoid fractional purchases
391 
392     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
393 		uint256 _tokens = _weiAmount.div(weiPerToken);
394         return (_tokens);
395     }
396     
397    
398   /**
399    * @dev Determines how ETH is stored/forwarded on purchases.
400    */
401     function _forwardFunds() internal {
402 
403     	uint256 total_eth = (msg.value);
404     	uint256 prize_pool = total_eth.mul(50).div(100);
405     	uint256 prize_pool_sec = total_eth.mul(10).div(100);
406     	uint256 admin_pool = total_eth.sub(prize_pool).sub(prize_pool_sec);
407 
408     	require(prizewallet == (0x6eFd9391Db718dEff494C2199CD83E0EFc8102f6));
409     	prizewallet.transfer(prize_pool);
410 	    require(prize2wallet == (0x426570e5b796A2845C700B4b49058E097f7dCb54));
411     	prize2wallet.transfer(prize_pool_sec);
412 	    require(adminwallet == (0xe7d718cc663784480EBB62A672180fbB68f89424));
413     	adminwallet.transfer(admin_pool);
414     }
415 
416 
417     // Function to remove any ethereum that gets stuck in contract (most likely from under or over payment)   
418     function withdraw() public onlyOwner {
419          uint bal = address(this).balance;
420          address(owner).transfer(bal);
421     }
422 
423 }