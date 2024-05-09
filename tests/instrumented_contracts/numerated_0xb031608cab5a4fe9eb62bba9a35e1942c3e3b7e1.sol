1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original "owner" of the contract to the sender
48    * account.
49    */
50   constructor () public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96   
97   modifier onlyPayloadSize(uint numwords) {
98       assert(msg.data.length >= numwords * 32 + 4);
99       _;
100   }
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
108     require(_to != address(0));
109 
110     // SafeMath.sub will throw if there is not enough balance.
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     emit Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256 balance) {
123     return balances[_owner];
124   }
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public view returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
158     require(_to != address(0));
159 
160     uint256 _allowance = allowed[_from][msg.sender];
161 
162     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
163     // require (_value <= _allowance);
164 
165     balances[_from] = balances[_from].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     allowed[_from][msg.sender] = _allowance.sub(_value);
168     emit Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    *
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     emit Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    */
204   function increaseApproval (address _spender, uint _addedValue) public
205     onlyPayloadSize(2)
206     returns (bool success) {
207     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212   function decreaseApproval (address _spender, uint _subtractedValue) public
213     onlyPayloadSize(2)
214     returns (bool success) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 }
225 
226 
227 /**
228  * @title Burnable Token
229  * @dev Token that can be irreversibly burned (destroyed).
230  */
231 contract BurnableToken is StandardToken {
232 
233     event Burn(address indexed burner, uint256 value);
234 
235     /**
236      * @dev Burns a specific amount of tokens.
237      * @param _value The amount of token to be burned.
238      */
239     function burn(uint256 _value) public {
240         require(_value > 0);
241         require(_value <= balances[msg.sender]);
242         // no need to require value <= totalSupply, since that would imply the
243         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
244 
245         address burner = msg.sender;
246         balances[burner] = balances[burner].sub(_value);
247         totalSupply = totalSupply.sub(_value);
248         emit Burn(burner, _value);
249         emit Transfer(burner, address(0), _value);
250     }
251 }
252 
253 contract Token is BurnableToken, Ownable {
254 
255     string public constant name = "MIG";
256     string public constant symbol = "MIG";
257     uint public constant decimals = 18;
258     // there is no problem in using * here instead of .mul()
259     uint256 public constant initialSupply = 850000000 * (10 ** uint256(decimals));
260 
261     // Constructors
262     constructor () public {
263         totalSupply = initialSupply;
264         balances[msg.sender] = initialSupply; // Send all tokens to owner
265         emit Transfer(address(0x0), owner, initialSupply);
266     }
267 
268 }
269 
270 /**
271  * @title Crowdsale
272  * @dev Crowdsale is a base contract for managing a token crowdsale.
273  * Crowdsales have a start and end timestamps, where investors can make
274  * token purchases and the crowdsale will assign them tokens based
275  * on a token per ETH rate. Funds collected are forwarded 
276  to a wallet
277  * as they arrive.
278  */
279 interface token { function transfer(address receiver, uint amount) external; }
280 contract ERC20CrowdsaleToken is Token {
281   using SafeMath for uint256;
282 
283   uint256 public price = 3000;
284 
285   token tokenReward;
286 
287 
288   uint256 public weiRaised;
289 
290   /**
291    * event for token purchase logging
292    * @param purchaser who paid for the tokens
293    * @param beneficiary who got the tokens
294    * @param value weis paid for purchase
295    * @param amount amount of tokens purchased
296    */
297   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
298 
299 
300   constructor () public {
301 
302     tokenReward = token(address(this));
303   }
304 
305   bool public started = true;
306 
307   function startSale() onlyOwner public {
308 
309     started = true;
310   }
311 
312   function stopSale() onlyOwner public {
313 
314     started = false;
315   }
316 
317   function setPrice(uint256 _price) onlyOwner public {
318 
319     price = _price;
320   }
321 
322   // fallback function can be used to buy tokens
323   function () payable external {
324     buyTokens(msg.sender);
325   }
326 
327   // low level token purchase function
328   function buyTokens(address beneficiary) payable public {
329     require(beneficiary != address(0x0));
330     require(validPurchase());
331 
332     uint256 weiAmount = msg.value;
333 
334     // calculate token amount to be sent
335     uint256 tokens = (weiAmount/10**(18-decimals)) * price; //weiamount * price 
336 
337     // update state
338     weiRaised = weiRaised.add(weiAmount);
339 
340     tokenReward.transfer(beneficiary, tokens);
341     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
342     forwardFunds();
343   }
344 
345   // send ether to the fund collection wallet
346   // override to create custom fund forwarding mechanisms
347   function forwardFunds() internal {
348     owner.transfer(msg.value);
349   }
350 
351   // @return true if the transaction can buy tokens
352   function validPurchase() internal view returns (bool) {
353     bool withinPeriod = started;
354     bool nonZeroPurchase = msg.value != 0;
355     return withinPeriod && nonZeroPurchase;
356   }
357 
358   function withdrawTokens(uint256 _amount) onlyOwner public {
359     tokenReward.transfer(owner,_amount);
360   }
361 }