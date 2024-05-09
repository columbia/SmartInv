1 pragma solidity 0.4.18;
2 
3 
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
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
51 
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
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 /**
120  * @title Basic token
121  * @dev Basic version of StandardToken, with no allowances.
122  */
123 contract BasicToken is ERC20Basic {
124   using SafeMath for uint256;
125 
126   mapping(address => uint256) balances;
127 
128   uint256 totalSupply_;
129 
130   /**
131   * @dev total number of tokens in existence
132   */
133   function totalSupply() public view returns (uint256) {
134     return totalSupply_;
135   }
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public view returns (uint256) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257 }
258 
259 /**
260  * @title Pausable
261  * @dev Base contract which allows children to implement an emergency stop mechanism.
262  */
263 contract Pausable is Ownable {
264   event Pause();
265   event Unpause();
266 
267   bool public paused = false;
268 
269 
270   /**
271    * @dev Modifier to make a function callable only when the contract is not paused.
272    */
273   modifier whenNotPaused() {
274     require(!paused);
275     _;
276   }
277 
278   /**
279    * @dev Modifier to make a function callable only when the contract is paused.
280    */
281   modifier whenPaused() {
282     require(paused);
283     _;
284   }
285 
286   /**
287    * @dev called by the owner to pause, triggers stopped state
288    */
289   function pause() onlyOwner whenNotPaused public {
290     paused = true;
291     Pause();
292   }
293 
294   /**
295    * @dev called by the owner to unpause, returns to normal state
296    */
297   function unpause() onlyOwner whenPaused public {
298     paused = false;
299     Unpause();
300   }
301 }
302 
303 contract NamCoin is StandardToken, Ownable {
304     string public name = "Nam Coin"; //Token name
305     string public symbol = "NAM"; //Identifier
306     uint8 public constant decimals = 18; //How many decimals to show. To be standard complicant keep it 18
307     uint256 public unitsOneEthCanBuy = 120048;     // Approximately 0.00000833 ETH per Nam coin, means 120048 Nam Coin per ETH
308     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
309     address public fundsWallet; //ETH wallet
310     uint public constant crowdsaleSupply = 60 * (uint(10)**9) * (uint(10)**decimals); // 60 billion NAM available for the crowdsale
311     uint public constant tokenContractSupply = 60 * (uint(10)**9) * (uint(10)**decimals); // 60 billion NAM (50% of 120)
312 
313     // Allow the owner to change the pricing
314     function setUnitsOneEthCanBuy(uint256 new_unitsOneEthCanBuy) public onlyOwner
315     {
316         unitsOneEthCanBuy = new_unitsOneEthCanBuy;
317     }
318     
319     // Allow the owner to transfer tokens from the token contract
320     function issueTokens(address _to, uint256 _amount) public onlyOwner
321     {
322         require(_to != 0x0);
323         this.transfer(_to, _amount);
324     }
325     
326     // Allow the owner to manually transfer the collected ether
327     // after the crowdsale has ended.
328     function transferCollectedEther(address _to) public onlyOwner
329     {
330         require(_to != 0x0);
331         require(!crowdsaleRunning);
332         _to.transfer(this.balance);
333     }
334     
335     bool public crowdsaleRunning = false;
336     uint256 public crowdsaleStartTimestamp;
337     uint256 public crowdsaleDuration = 60 * 24*60*60; // 60 days
338     
339     function startCrowdsale() public onlyOwner
340     {
341         crowdsaleRunning = true;
342         crowdsaleStartTimestamp = now;
343     }
344     
345     function stopCrowdsale() public onlyOwner
346     {
347         crowdsaleRunning = false;
348     }
349     
350     // token purchase lower limit for bonus calculation
351     uint256 public purchaseGold = 10 * (uint(10)**6) * (uint(10)**decimals);
352     uint256 public purchaseSilver = 5 * (uint(10)**6) * (uint(10)**decimals);
353     uint256 public purchaseBronze = 3 * (uint(10)**6) * (uint(10)**decimals);
354     uint256 public purchaseCoffee = 1 * (uint(10)**6) * (uint(10)**decimals);
355 
356     function NamCoin(address _fundsWallet) public {
357         fundsWallet = _fundsWallet;
358         
359         totalSupply_ = crowdsaleSupply + tokenContractSupply;
360         
361         balances[fundsWallet] = crowdsaleSupply;
362         Transfer(0x0, fundsWallet, crowdsaleSupply);
363         
364         balances[this] = tokenContractSupply;
365         Transfer(0x0, this, tokenContractSupply);
366     }
367 
368     function() payable public {
369         // If the crowdsale is not running, cancel the transaction
370         require(crowdsaleRunning);
371         
372         // If the 60-day crowdsale is over, cancel the transaction
373         require(now <= crowdsaleStartTimestamp + crowdsaleDuration);
374         
375         totalEthInWei = totalEthInWei + msg.value;
376         uint256 amount = msg.value * unitsOneEthCanBuy * (uint(10)**decimals) / (1 ether);
377         
378         // add bonus based on token purchased  (20%, 15%, 5%, 3%)
379         if (amount >= purchaseGold) {
380             amount = amount.mul(120).div(100);  
381 
382         }else if (amount >= purchaseSilver) {
383             amount = amount.mul(115).div(100);
384 
385         }else if (amount >= purchaseBronze) {
386             amount = amount.mul(110).div(100);
387 
388         }else if (amount >= purchaseCoffee) {
389             amount = amount.mul(103).div(100);
390 
391         }else {
392             amount = amount.mul(100).div(100);
393         }
394         
395         // Verify that the hardcap has not been reached
396        require (balances[fundsWallet] >= amount);
397 
398         balances[fundsWallet] = balances[fundsWallet] - amount;
399         balances[msg.sender] = balances[msg.sender] + amount;
400 
401         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
402     }
403 
404     /* Approves and then calls the receiving contract */
405     function approveAndCall(address _spender, uint256 _value, bytes _extraData)  public returns (bool success){
406         allowed[msg.sender][_spender] = _value;
407         Approval(msg.sender, _spender, _value);
408 
409         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
410         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
411         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
412         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
413         return true;
414     }
415 }