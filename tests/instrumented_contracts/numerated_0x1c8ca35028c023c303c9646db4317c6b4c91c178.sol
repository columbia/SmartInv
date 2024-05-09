1 pragma solidity 0.4.20;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   /**
43   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 
59   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a % b;
62     //uint256 z = a / b;
63     assert(a == (a / b) * b + c); // There is no case in which this doesn't hold
64     return c;
65   }
66 }
67 
68 
69 /**
70  * @title Basic token
71  * @dev Basic version of StandardToken, with no allowances.
72  */
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) internal balances;
77 
78   uint256 internal totalSupply_;
79 
80   /**
81   * @dev total number of tokens in existence
82   */
83   function totalSupply() public view returns (uint256) {
84     return totalSupply_;
85   }
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94 
95     // SafeMath.sub will throw if there is not enough balance.
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public view returns (uint256 balance) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150     Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    *
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) public view returns (uint256) {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181    * @dev Increase the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To increment
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _addedValue The amount of tokens to increase the allowance by.
189    */
190   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
191     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196   /**
197    * @dev Decrease the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To decrement
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _subtractedValue The amount of tokens to decrease the allowance by.
205    */
206   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 /**
219  * @title Ownable
220  * @dev The Ownable contract has an owner address, and provides basic authorization control
221  * functions, this simplifies the implementation of "user permissions".
222  */
223 contract Ownable {
224   address public owner;
225   address private newOwner;
226 
227   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229 
230   /**
231    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
232    * account.
233    */
234   function Ownable() public {
235     owner = msg.sender;
236   }
237 
238   /**
239    * @dev Throws if called by any account other than the owner.
240    */
241   modifier onlyOwner() {
242     require(msg.sender == owner);
243     _;
244   }
245 
246   /**
247    * @dev Allows the current owner to transfer control of the contract to a newOwner.
248    * @param _newOwner The address to transfer ownership to.
249    */
250   function transferOwnership(address _newOwner) public onlyOwner {
251     require(_newOwner != address(0));
252     newOwner = _newOwner;
253   }
254 
255   /**
256    * @dev The ownership is transferred only if the new owner approves it.
257    */
258   function approveOwnership() public {
259     require(msg.sender == newOwner);
260     OwnershipTransferred(owner, newOwner);
261     owner = newOwner;
262     newOwner = address(0);
263   }
264 
265 }
266 
267 
268 /**
269  * @title Mintable token
270  * @dev Simple ERC20 Token example, with mintable token creation
271  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
272  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
273  */
274 contract MintableToken is StandardToken, Ownable {
275   event Mint(address indexed to, uint256 amount);
276   event MintFinished();
277 
278   bool public mintingFinished = false;
279 
280 
281   modifier canMint() {
282     require(!mintingFinished);
283     _;
284   }
285 
286   /**
287    * @dev Function to mint tokens
288    * @param _to The address that will receive the minted tokens.
289    * @param _amount The amount of tokens to mint.
290    * @return A boolean that indicates if the operation was successful.
291    */
292   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
293     totalSupply_ = totalSupply_.add(_amount);
294     balances[_to] = balances[_to].add(_amount);
295     Mint(_to, _amount);
296     Transfer(address(0), _to, _amount);
297     return true;
298   }
299 
300   /**
301    * @dev Function to stop minting new tokens.
302    * @return True if the operation was successful.
303    */
304   function finishMinting() onlyOwner canMint public returns (bool) {
305     mintingFinished = true;
306     MintFinished();
307     return true;
308   }
309 }
310 
311 contract BurnableToken is StandardToken {
312 
313   mapping(address => bool) private allowedAddressesForBurn;
314   address[50] private burnAddresses;
315   uint public burned;
316 
317   event Burn(address indexed burner, uint value);
318 
319   modifier isAllowed(address _address) {
320     require(allowedAddressesForBurn[_address]);
321     _;
322   }
323 
324   function BurnableToken(address[50] _addresses) public {
325     burnAddresses = _addresses;
326     for (uint i; i < burnAddresses.length; i++) {
327       if (burnAddresses[i] != address(0)) {
328         allowedAddressesForBurn[burnAddresses[i]] = true;
329       }
330     }
331   }
332 
333   /*/**
334   * @dev Burns a specific amount of tokens.
335   * @param _value The amount of token to be burned.
336   */
337   function burn(uint _value) public isAllowed(msg.sender) {
338     require(_value > 0);
339 
340     // no need to require value <= totalSupply, since that would imply the
341     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
342     address burner = msg.sender;
343     balances[burner] = balances[burner].sub(_value);
344     totalSupply_ = totalSupply_.sub(_value);
345     burned = burned.add(_value);
346     Burn(burner, _value);
347     Transfer(burner, 0x0, _value);
348   }
349 
350   function burnAll() public {
351     burn(balances[msg.sender]);
352   }
353 
354   function getBurnAddresses() public view returns(address[50]) {
355     return burnAddresses;
356   }
357 }
358 
359 contract Restrictable is Ownable {
360 
361   address public restrictedAddress;
362 
363   event RestrictedAddressChanged(address indexed restrictedAddress);
364 
365   modifier notRestricted(address tryTo) {
366     require(tryTo != restrictedAddress);
367     _;
368   }
369 
370   //that function could be called only ONCE!!! After that nothing could be reverted!!!
371   function setRestrictedAddress(address _restrictedAddress) onlyOwner public {
372     restrictedAddress = _restrictedAddress;
373     RestrictedAddressChanged(_restrictedAddress);
374     transferOwnership(_restrictedAddress);
375   }
376 }
377 
378 contract GEMERAToken is MintableToken, BurnableToken, Restrictable {
379   string public constant name = "G_TEST";
380   string public constant symbol = "GTEST";
381   uint32 public constant decimals = 18;
382 
383   function GEMERAToken(address[50] _addrs) public BurnableToken(_addrs) {}
384 
385   function transfer(address _to, uint256 _value) public notRestricted(_to) returns (bool) {
386     return super.transfer(_to, _value);
387   }
388 
389   function transferFrom(address _from, address _to, uint256 _value) public notRestricted(_to) returns (bool) {
390     return super.transferFrom(_from, _to, _value);
391   }
392 }