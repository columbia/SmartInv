1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public constant returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) public constant returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
75 
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of.
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public constant returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92 }
93 
94 
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) internal allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amount of tokens to be transferred
113    */
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[_from]);
117     require(_value <= allowed[_from][msg.sender]);
118 
119     balances[_from] = balances[_from].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    *
129    * Beware that changing an allowance with this method brings the risk that someone may use both the old
130    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152   /**
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    */
158   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
159     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
165     uint oldValue = allowed[msg.sender][_spender];
166     if (_subtractedValue > oldValue) {
167       allowed[msg.sender][_spender] = 0;
168     } else {
169       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
170     }
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175 }
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 
183 contract Ownable {
184   address public owner;
185 
186 
187   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189 
190   /**
191    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
192    * account.
193    */
194   function Ownable() {
195     owner = msg.sender;
196   }
197 
198 
199   /**
200    * @dev Throws if called by any account other than the owner.
201    */
202   modifier onlyOwner() {
203     require(msg.sender == owner);
204     _;
205   }
206 
207 
208   /**
209    * @dev Allows the current owner to transfer control of the contract to a newOwner.
210    * @param newOwner The address to transfer ownership to.
211    */
212   function transferOwnership(address newOwner) onlyOwner public {
213     require(newOwner != address(0));
214     OwnershipTransferred(owner, newOwner);
215     owner = newOwner;
216   }
217 
218 }
219 
220 
221 /**
222  * @title Mintable token
223  * @dev Simple ERC20 Token example, with mintable token creation
224  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
225  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
226  */
227 
228 contract MintableToken is StandardToken, Ownable {
229   event Mint(address indexed to, uint256 amount);
230   event MintFinished();
231 
232   string public name = 'LUKAS TOKEN';  
233   string public symbol = 'LKT';        
234 
235   bool public mintingFinished = false;
236 
237 
238   modifier canMint() {
239     require(!mintingFinished);
240     _;
241   }
242 
243   /**
244    * @dev Function to mint tokens
245    * @param _to The address that will receive the minted tokens.
246    * @param _amount The amount of tokens to mint.
247    * @return A boolean that indicates if the operation was successful.
248    */
249   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
250     totalSupply = totalSupply.add(_amount);
251     balances[_to] = balances[_to].add(_amount);
252     Mint(_to, _amount);
253     Transfer(address(0), _to, _amount);
254     return true;
255   }
256 
257   /**
258    * @dev Function to stop minting new tokens.
259    * @return True if the operation was successful.
260    */
261   function finishMinting() onlyOwner public returns (bool) {
262     mintingFinished = true;
263     MintFinished();
264     return true;
265   }
266 }
267 
268 
269 
270 
271 /**
272  * @title Crowdsale
273  * @dev Crowdsale is a base contract for managing a token crowdsale.
274  * Crowdsales have a start and end timestamps, where investors can make
275  * token purchases and the crowdsale will assign them tokens based
276  * on a token per ETH rate. Funds collected are forwarded to a wallet
277  * as they arrive.
278  */
279 contract Crowdsale {
280   using SafeMath for uint256;
281 
282   // The token being sold
283   MintableToken public token;
284 
285   // start and end timestamps where investments are allowed (both inclusive)
286   uint256 public startTime;
287   uint256 public endTime;
288 
289   // address where funds are collected
290   address public wallet;
291 
292   // how many token units a buyer gets per wei
293   uint256 public rate;
294 
295   // amount of raised money in wei
296   uint256 public weiRaised;
297 
298   /**
299    * event for token purchase logging
300    * @param purchaser who paid for the tokens
301    * @param beneficiary who got the tokens
302    * @param value weis paid for purchase
303    * @param amount amount of tokens purchased
304    */
305   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
306 
307 
308   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
309     require(_startTime >= now);
310     require(_endTime >= _startTime);
311     require(_rate > 0);
312     require(_wallet != address(0));
313 
314     token = createTokenContract();
315     startTime = _startTime;
316     endTime = _endTime;
317     rate = _rate;
318     wallet = _wallet;
319   }
320 
321   // creates the token to be sold.
322   // override this method to have crowdsale of a specific mintable token.
323   function createTokenContract() internal returns (MintableToken) {
324     return new MintableToken();
325   }
326 
327 
328   // fallback function can be used to buy tokens
329   function () payable {
330     buyTokens(msg.sender);
331   }
332 
333   // low level token purchase function
334   function buyTokens(address beneficiary) public payable {
335     require(beneficiary != address(0));
336     require(validPurchase());
337 
338     uint256 weiAmount = msg.value;
339 
340     // calculate token amount to be created
341     uint256 tokens = weiAmount.mul(rate);
342 
343     // update state
344     weiRaised = weiRaised.add(weiAmount);
345 
346     token.mint(beneficiary, tokens);
347     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
348 
349     forwardFunds();
350   }
351 
352   // send ether to the fund collection wallet
353   // override to create custom fund forwarding mechanisms
354   function forwardFunds() internal {
355     wallet.transfer(msg.value);
356   }
357 
358   // @return true if the transaction can buy tokens
359   function validPurchase() internal constant returns (bool) {
360     bool withinPeriod = now >= startTime && now <= endTime;
361     bool nonZeroPurchase = msg.value != 0;
362     return withinPeriod && nonZeroPurchase;
363   }
364 
365   // @return true if crowdsale event has ended
366   function hasEnded() public constant returns (bool) {
367     return now > endTime;
368   }
369 
370 
371 }