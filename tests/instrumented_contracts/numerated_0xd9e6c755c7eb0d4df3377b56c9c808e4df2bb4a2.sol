1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  */
75 library SafeMath {
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     if (a == 0) {
78       return 0;
79     }
80     uint256 c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
90   }
91 
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[msg.sender]);
123 
124     // SafeMath.sub will throw if there is not enough balance.
125     balances[msg.sender] = balances[msg.sender].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     Transfer(msg.sender, _to, _value);
128     return true;
129   }
130 
131   /**
132   * @dev Gets the balance of the specified address.
133   * @param _owner The address to query the the balance of.
134   * @return An uint256 representing the amount owned by the passed address.
135   */
136   function balanceOf(address _owner) public view returns (uint256 balance) {
137     return balances[_owner];
138   }
139 
140 }
141 
142 
143 
144 
145 
146 
147 
148 /**
149  * @title ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/20
151  */
152 contract ERC20 is ERC20Basic {
153   function allowance(address owner, address spender) public view returns (uint256);
154   function transferFrom(address from, address to, uint256 value) public returns (bool);
155   function approve(address spender, uint256 value) public returns (bool);
156   event Approval(address indexed owner, address indexed spender, uint256 value);
157 }
158 
159 
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    *
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) public view returns (uint256) {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * approve should be called when allowed[_spender] == 0. To increment
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
230     uint oldValue = allowed[msg.sender][_spender];
231     if (_subtractedValue > oldValue) {
232       allowed[msg.sender][_spender] = 0;
233     } else {
234       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235     }
236     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240 }
241 
242 
243 
244 
245 
246 
247 
248 /**
249  * @title Destructible
250  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
251  */
252 contract Destructible is Ownable {
253 
254   function Destructible() public payable { }
255 
256   /**
257    * @dev Transfers the current balance to the owner and terminates the contract.
258    */
259   function destroy() onlyOwner public {
260     selfdestruct(owner);
261   }
262 
263   function destroyAndSend(address _recipient) onlyOwner public {
264     selfdestruct(_recipient);
265   }
266 }
267 
268 
269 contract GeocashToken is StandardToken, Destructible {
270   string public name;
271   string public symbol;
272   uint public decimals;
273   uint public buyPriceInWei;
274   uint public sellPriceInWei;
275   uint public minBalanceForAccounts;
276   address public companyWallet;
277 
278   mapping(address => uint256) balances;
279   mapping (address => bool) public frozenAccounts;
280   event FrozenFunds(address target, bool frozen);
281 
282   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
283 
284   modifier onlyOwner() {
285     require(msg.sender == owner);
286     _;
287   }
288 
289   function GeocashToken(uint256 _minBalanceForAccountsInWei, uint256 _buyPriceInWei, uint256 _sellPriceInWei, address _companyWallet) public {
290     name = 'Geocash';
291     symbol = 'GEO';
292     decimals = 18;
293     totalSupply = 500000000 * (10 ** uint256(decimals));
294     balances[this] = totalSupply;
295     minBalanceForAccounts = _minBalanceForAccountsInWei;
296     buyPriceInWei = _buyPriceInWei;
297     sellPriceInWei = _sellPriceInWei;
298     companyWallet = _companyWallet;
299   }
300 
301 
302   /*Constant functions*/
303   function balanceOf(address _owner) public view returns (uint256 balance) {
304     return balances[_owner];
305   }
306 
307   function isFrozen(address _owner) public view returns (bool frozen){
308     return frozenAccounts[_owner];
309   }
310 
311 
312 
313 
314   /*Non constant functions*/
315 
316   function transfer(address _to, uint256 _value) public returns (bool) {
317     require(_to != address(0));
318     require(!frozenAccounts[msg.sender]);
319     require(!frozenAccounts[_to]);
320     require(_value <= balances[msg.sender]);
321     if(msg.sender.balance < minBalanceForAccounts){
322       sell((minBalanceForAccounts.sub(msg.sender.balance)).div(sellPriceInWei));
323     }
324     balances[msg.sender] = balances[msg.sender].sub(_value);
325     balances[_to] = balances[_to].add(_value);
326     Transfer(msg.sender, _to, _value);
327     return true;
328   }
329 
330   function setBuyPrice(uint _buyPriceInWei) onlyOwner public returns (bool){
331     require(_buyPriceInWei > 0);
332     buyPriceInWei = _buyPriceInWei;
333     return true;
334   }
335 
336   function setSellPrice(uint _sellPriceInWei) onlyOwner public returns (bool){
337     require(_sellPriceInWei > 0);
338     sellPriceInWei = _sellPriceInWei;
339     return true;
340   }
341 
342   function setCompanyWallet(address _wallet) onlyOwner public returns (bool){
343     require(_wallet != address(0));
344     companyWallet = _wallet;
345     return true;
346   }
347 
348   function buy() public payable returns (uint){
349     require(msg.sender != address(0));
350     require(msg.value >= 0);
351     uint amount = msg.value.div(buyPriceInWei).mul(1 ether);
352     require(amount > 0);
353     require(balances[this] >= amount);
354     uint oldBalance = balances[this].add(balances[msg.sender]);
355     balances[this] = balances[this].sub(amount);
356     balances[msg.sender] = balances[msg.sender].add(amount);
357     uint newBalance = balances[this].add(balances[msg.sender]);
358     assert(newBalance == oldBalance);
359     Transfer(this, msg.sender, amount);
360     return amount;
361   }
362 
363   function sell(uint _amount) internal returns(uint revenue) {
364     require(_amount > 0);
365     require(balances[msg.sender]>= _amount);
366     uint oldBalance =  balances[this].add(balances[msg.sender]);
367     balances[this] = balances[this].add(_amount);
368     balances[msg.sender] = balances[msg.sender].sub(_amount);
369     revenue = _amount.mul(sellPriceInWei).div(1 ether);
370     require(revenue > 0);
371     if(!msg.sender.send(revenue)){
372       revert();
373     }
374     else {
375       uint newBalance =  balances[this].add(balances[msg.sender]);
376       assert(newBalance == oldBalance);
377       Transfer(msg.sender, this, _amount);
378       return _amount;
379     }
380   }
381 
382   function freezeAccount(address target, bool freeze) public onlyOwner {
383     frozenAccounts[target] = freeze;
384     FrozenFunds(target, freeze);
385   }
386 
387   function setMinBalance(uint minimumBalanceInWei) public onlyOwner {
388     minBalanceForAccounts = minimumBalanceInWei;
389   }
390 
391   /* @dev send ETH to the company wallet, the token address should keep a reasonable amount of ETH to be able to payout on token sells */
392   function forwardFundToCompanyWallet(uint _amount) public onlyOwner {
393     companyWallet.transfer(_amount);
394   }
395 
396 }