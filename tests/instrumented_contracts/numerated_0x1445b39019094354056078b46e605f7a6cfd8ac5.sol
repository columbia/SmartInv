1 pragma solidity ^0.4.18;
2 
3 // zeppelin-solidity: 1.5.0
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44   uint256 public totalSupply;
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public view returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) internal allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[_from]);
118     require(_value <= allowed[_from][msg.sender]);
119 
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    *
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public view returns (uint256) {
150     return allowed[_owner][_spender];
151   }
152 
153   /**
154    * @dev Increase the amount of tokens that an owner allowed to a spender.
155    *
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    * @param _spender The address which will spend the funds.
161    * @param _addedValue The amount of tokens to increase the allowance by.
162    */
163   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   /**
170    * @dev Decrease the amount of tokens that an owner allowed to a spender.
171    *
172    * approve should be called when allowed[_spender] == 0. To decrement
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    * @param _spender The address which will spend the funds.
177    * @param _subtractedValue The amount of tokens to decrease the allowance by.
178    */
179   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
180     uint oldValue = allowed[msg.sender][_spender];
181     if (_subtractedValue > oldValue) {
182       allowed[msg.sender][_spender] = 0;
183     } else {
184       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185     }
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190 }
191 
192 /**
193  * @title Ownable
194  * @dev The Ownable contract has an owner address, and provides basic authorization control
195  * functions, this simplifies the implementation of "user permissions".
196  */
197 contract Ownable {
198   address public owner;
199 
200 
201   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203 
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   function Ownable() public {
209     owner = msg.sender;
210   }
211 
212 
213   /**
214    * @dev Throws if called by any account other than the owner.
215    */
216   modifier onlyOwner() {
217     require(msg.sender == owner);
218     _;
219   }
220 
221 
222   /**
223    * @dev Allows the current owner to transfer control of the contract to a newOwner.
224    * @param newOwner The address to transfer ownership to.
225    */
226   function transferOwnership(address newOwner) public onlyOwner {
227     require(newOwner != address(0));
228     OwnershipTransferred(owner, newOwner);
229     owner = newOwner;
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
254     function burn(uint _value) onlyOwner public {
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