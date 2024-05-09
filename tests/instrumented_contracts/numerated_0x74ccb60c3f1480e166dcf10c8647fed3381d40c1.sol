1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title Ownable
97  * @dev The Ownable contract has an owner address, and provides basic authorization control
98  * functions, this simplifies the implementation of "user permissions".
99  */
100 contract Ownable {
101   address public owner;
102 
103 
104   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106 
107   /**
108    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
109    * account.
110    */
111   function Ownable() public {
112     owner = msg.sender;
113   }
114 
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(msg.sender == owner);
121     _;
122   }
123 
124 
125   /**
126    * @dev Allows the current owner to transfer control of the contract to a newOwner.
127    * @param newOwner The address to transfer ownership to.
128    */
129   function transferOwnership(address newOwner) public onlyOwner{
130     require(newOwner != address(0));
131     OwnershipTransferred(owner, newOwner);
132     owner = newOwner;
133   }
134 
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    *
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(address _owner, address _spender) public view returns (uint256) {
189     return allowed[_owner][_spender];
190   }
191 
192   /**
193    * @dev Increase the amount of tokens that an owner allowed to a spender.
194    *
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _addedValue The amount of tokens to increase the allowance by.
201    */
202   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
203     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
204     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 
208   /**
209    * @dev Decrease the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To decrement
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _subtractedValue The amount of tokens to decrease the allowance by.
217    */
218   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 /**
232  * @title QBXToken
233  * @dev Very simple ERC20 Token that can be minted.
234  * It is meant to be used in a crowdsale contract.
235  */
236 contract QBXToken is StandardToken, Ownable {
237 
238   string public constant name = "QBX";
239   string public constant symbol = "QBX";
240   uint8 public constant decimals = 18;
241 
242   event Mint(address indexed to, uint256 amount);
243   event MintFinished();
244 
245   bool public mintingFinished = false;
246   address public saleAgent = address(0);
247 
248   modifier canMint() {
249     require(!mintingFinished);
250     _;
251   }
252 
253   function setSaleAgent(address newSaleAgnet) public {
254     require(msg.sender == saleAgent || msg.sender == owner);
255     saleAgent = newSaleAgnet;
256   }
257   /**
258    * @dev Function to mint tokens
259    * @param _to The address that will receive the minted tokens.
260    * @param _amount The amount of tokens to mint.
261    * @return A boolean that indicates if the operation was successful.
262    */
263   function mint(address _to, uint256 _amount) canMint public returns (bool) {
264     require(msg.sender == saleAgent || msg.sender == owner);
265     totalSupply = totalSupply.add(_amount);
266     balances[_to] = balances[_to].add(_amount);
267     Mint(_to, _amount);
268     Transfer(address(0), _to, _amount);
269     return true;
270   }
271 
272   /**
273    * @dev Function to stop minting new tokens.
274    * @return True if the operation was successful.
275    */
276   function finishMinting() canMint public returns (bool) {
277     require((msg.sender == saleAgent || msg.sender == owner));
278     mintingFinished = true;
279     MintFinished();
280     return true;
281   }
282 
283   event Burn(address indexed burner, uint256 value);
284 
285     /**
286      * @dev Burns a specific amount of tokens.
287      * @param _value The amount of token to be burned.
288      */
289     function burn(uint256 _value) public {
290         require(msg.sender == saleAgent || msg.sender == owner);
291         require(_value <= balances[msg.sender]);
292         // no need to require value <= totalSupply, since that would imply the
293         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
294 
295         address burner = msg.sender;
296         balances[burner] = balances[burner].sub(_value);
297         totalSupply = totalSupply.sub(_value);
298         Burn(burner, _value);
299     }
300 
301   function burnFrom(address _from, uint256 _value) public returns (bool success) {
302         require(msg.sender == saleAgent || msg.sender == owner);
303         // Check if the targeted balance is enough
304         require(balances[_from] >= _value);
305         // Check allowance
306         require(_value <= allowed[_from][msg.sender]);
307         // Subtract from the targeted balance
308         balances[_from] = balances[_from].sub(_value);
309          // Subtract from the sender's allowance
310         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
311         // Update totalSupply
312         totalSupply = totalSupply.sub(_value);
313         Burn(_from, _value);
314         return true;
315     }
316 
317 }
318 
319 contract QBXTokenSale is Ownable {
320   using SafeMath for uint256;
321   mapping(address => uint256) balances;
322   // The token being sold
323   QBXToken public token;
324 
325   // address where funds are collected
326   address public wallet;
327 
328   bool public checkMinContribution = true;
329   uint256 public weiMinContribution = 500000000000000000;
330 
331   // how many token units a buyer gets per wei
332   uint256 public rate;
333   // amount of raised money in wei
334   uint256 public weiRaised;
335 
336   /**
337    * event for token purchase logging
338    * @param purchaser who paid for the tokens
339    * @param beneficiary who got the tokens
340    * @param value weis paid for purchase
341    * @param amount amount of tokens purchased
342    */
343   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
344 
345   function QBXTokenSale(
346     uint256 _rate,
347     address _wallet) public {
348     require(_rate > 0);
349     require(_wallet != address(0));
350 
351     token = createTokenContract();
352     rate = _rate;
353     wallet = _wallet;
354     token.setSaleAgent(owner);
355   }
356 
357   // creates the token to be sold.
358   function createTokenContract() internal returns (QBXToken) {
359     return new QBXToken();
360   }
361 
362   // fallback function can be used to buy tokens
363   function () external payable {
364     buyTokens(msg.sender);
365   }
366 
367   function setCheckMinContribution(bool _checkMinContribution) onlyOwner public {
368     checkMinContribution = _checkMinContribution;
369   }
370 
371   function setWeiMinContribution(uint256 _newWeiMinContribution) onlyOwner public {
372     weiMinContribution = _newWeiMinContribution;
373   }
374 
375   // low level token purchase function
376   function buyTokens(address beneficiary) public payable {
377     if(checkMinContribution == true ){
378       require(msg.value > weiMinContribution);
379     }
380     require(beneficiary != address(0));
381 
382     uint256 weiAmount = msg.value;
383 
384     // calculate token amount to be created
385     uint256 tokens = weiAmount.mul(rate);
386 
387     // update state
388     weiRaised = weiRaised.add(weiAmount);
389 
390     token.mint(beneficiary, tokens);
391     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
392 
393     forwardFunds();
394   }
395   
396   // send ether to the fund collection wallet
397   // override to create custom fund forwarding mechanisms
398   function forwardFunds() internal {
399     wallet.transfer(msg.value);
400   }
401 
402   function setWallet(address _wallet) public onlyOwner {
403     wallet = _wallet;
404   }
405 
406   function setRate(uint _newRate) public onlyOwner  {
407     rate = _newRate;
408   }
409 }