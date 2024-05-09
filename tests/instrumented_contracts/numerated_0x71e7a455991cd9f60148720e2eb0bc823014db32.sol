1 pragma solidity ^0.4.18;
2 
3 // zeppelin-solidity: 1.5.0
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   uint256 public totalSupply;
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     if (a == 0) {
66       return 0;
67     }
68     uint256 c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return c;
78   }
79 
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   function add(uint256 a, uint256 b) internal pure returns (uint256) {
86     uint256 c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances.
95  */
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[msg.sender]);
109 
110     // SafeMath.sub will throw if there is not enough balance.
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
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
125 
126 }
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133   function allowance(address owner, address spender) public view returns (uint256);
134   function transferFrom(address from, address to, uint256 value) public returns (bool);
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
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
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public view returns (uint256) {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To decrement
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _subtractedValue The amount of tokens to decrease the allowance by.
220    */
221   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222     uint oldValue = allowed[msg.sender][_spender];
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232 }
233 
234 contract Object is StandardToken, Ownable {
235     string public name;
236     string public symbol;
237     uint8 public constant decimals = 18;
238     bool public mintingFinished = false;
239 
240     event Burn(address indexed burner, uint value);
241     event Mint(address indexed to, uint amount);
242     event MintFinished();
243 
244     modifier canMint() {
245         require(!mintingFinished);
246         _;
247     }
248 
249     function Object(string _name, string _symbol) public {
250         name = _name;
251         symbol = _symbol;
252     }
253 
254     function burn(uint _value) public {
255         require(_value <= balances[msg.sender]);
256         address burner = msg.sender;
257         balances[burner] = balances[burner].sub(_value);
258         totalSupply = totalSupply.sub(_value);
259         Burn(burner, _value);
260     }
261 
262     function mint(address _to, uint _amount) onlyOwner canMint public returns(bool) {
263         totalSupply = totalSupply.add(_amount);
264         balances[_to] = balances[_to].add(_amount);
265         Mint(_to, _amount);
266         Transfer(address(0), _to, _amount);
267         return true;
268     }
269 
270     function finishMinting() onlyOwner canMint public returns(bool) {
271         mintingFinished = true;
272         MintFinished();
273         return true;
274     }
275 
276     function transfer(address _to, uint256 _value) public returns (bool) {
277         require(_to != address(0));
278         require(_value <= balances[msg.sender]);
279         require(_value % (1 ether) == 0); // require whole token transfers
280 
281         // SafeMath.sub will throw if there is not enough balance.
282         balances[msg.sender] = balances[msg.sender].sub(_value);
283         balances[_to] = balances[_to].add(_value);
284         Transfer(msg.sender, _to, _value);
285         return true;
286     }
287 }
288 
289 contract Shop is Ownable {
290     using SafeMath for *;
291 
292     struct ShopSettings {
293         address bank;
294         uint32 startTime;
295         uint32 endTime;
296         uint fundsRaised;
297         uint rate;
298         uint price;
299         //uint recommendedBid;
300     }
301 
302     Object public object;
303     ShopSettings public shopSettings;
304 
305     modifier onlyValidPurchase() {
306         require(msg.value % shopSettings.price == 0); // whole numbers only
307         require((now >= shopSettings.startTime && now <= shopSettings.endTime) && msg.value != 0);
308         _;
309     }
310 
311     modifier whenClosed() { // not actually implemented?
312         require(now > shopSettings.endTime);
313         _;
314     }
315 
316     modifier whenOpen() {
317         require(now < shopSettings.endTime);
318         _;
319     }
320 
321     modifier onlyValidAddress(address _bank) {
322         require(_bank != address(0));
323         _;
324     }
325 
326     modifier onlyOne() {
327         require(calculateTokens() == 1 ether);
328         _;
329     }
330 
331     modifier onlyBuyer(address _beneficiary) {
332         require(_beneficiary == msg.sender);
333         _;
334     }
335 
336     event ShopClosed(uint32 date);
337     event ObjectPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
338 
339     function () external payable {
340         buyObject(msg.sender);
341     }
342 
343     function Shop(address _bank, string _name, string _symbol, uint _rate, uint32 _endTime)
344     onlyValidAddress(_bank) public {
345         require(_rate >= 0);
346         require(_endTime > now);
347         shopSettings = ShopSettings(_bank, uint32(now), _endTime, 0, _rate, 0);
348         calculatePrice(); // set initial price based on initial rate
349         object = new Object(_name, _symbol);
350     }
351 
352     function buyObject(address _beneficiary) onlyValidPurchase
353     onlyBuyer(_beneficiary)
354     onlyValidAddress(_beneficiary) public payable {
355         uint numTokens = calculateTokens();
356         shopSettings.fundsRaised = shopSettings.fundsRaised.add(msg.value);
357         object.mint(_beneficiary, numTokens);
358         ObjectPurchase(msg.sender, _beneficiary, msg.value, numTokens);
359         forwardFunds();
360     }
361 
362     function calculateTokens() internal returns(uint) {
363         // rate is literally tokens per eth in wei;
364         // passing in a rate of 10 ETH (10*10^18) equates to 10 tokens per ETH, or a price of 0.1 ETH per token
365         // rate is always 1/price!
366         calculatePrice(); // update price
367         return msg.value.mul(1 ether).div(1 ether.mul(1 ether).div(shopSettings.rate));
368     }
369 
370     function calculatePrice() internal returns(uint) {
371         shopSettings.price = (1 ether).mul(1 ether).div(shopSettings.rate); // update price based on current rate
372         //shopSettings.recommendedBid = shopSettings.price.add((1 ether).div(100)); // update recommended bid based on current price
373     }
374 
375     function closeShop() onlyOwner whenOpen public {
376         shopSettings.endTime = uint32(now);
377         ShopClosed(uint32(now));
378     }
379 
380     function forwardFunds() internal {
381         shopSettings.bank.transfer(msg.value);
382     }
383 }
384 
385 contract FreeShop is Shop {
386 
387     modifier onlyValidPurchase() { // override to require 0-ETH transactions
388         require(msg.value == 0); // 0 ETH only
389         require(now >= shopSettings.startTime && now <= shopSettings.endTime);
390         _;
391     }
392 
393     modifier onlyValidAddress(address _bank) { // override so we can use a bank address of 0
394         _;
395     }
396 
397     function FreeShop(string _name, string _symbol,  uint32 _endTime)
398     Shop(0, _name, _symbol, 0, _endTime) public
399     {}
400 
401     function calculateTokens() internal returns(uint) { // override to always return 1 token per 'purchase'
402         return (1 ether);
403     }
404 
405     function calculatePrice() internal returns(uint) { // override to fix divide by zero error in Shop
406         shopSettings.price = 0;
407     }
408 
409 }