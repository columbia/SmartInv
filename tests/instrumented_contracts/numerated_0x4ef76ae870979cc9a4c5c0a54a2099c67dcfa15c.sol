1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 }
87 
88 /**
89  * @title Account
90  * @dev Contract for account.
91  */
92 contract Account is Ownable {
93 
94   mapping (address => bool) public frozenAccounts;
95   
96   event FrozenFunds(address indexed target, bool frozen);
97   
98  
99   function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
100     require(targets.length > 0);
101 
102     for (uint i = 0; i < targets.length; i++) {
103       require(targets[i] != 0x0);
104     }
105 
106     for (i = 0; i < targets.length; i++) {
107       frozenAccounts[targets[i]] = isFrozen;
108       FrozenFunds(targets[i], isFrozen);
109     }
110   }
111 }
112 /**
113  * @title Platform
114  * @dev Used to change platform.
115  */
116 contract Platform is Ownable{
117 
118   using SafeMath for uint256;
119   
120   struct accountInfo {
121     address addr;
122     uint256 amount;
123   }
124   
125   uint256 public changeTotalAmount;
126   uint256 public numAccountsInfo;
127   bool public changePlatformFlag;
128   mapping (uint256 => accountInfo) public AccountInfoList;
129 
130   /**
131    * @dev Flag for platform change processing. Flag state change.
132    */
133   function Platform () onlyOwner public {
134     changeTotalAmount = 0;
135     numAccountsInfo = 0;
136     changePlatformFlag = false;
137   }
138   /**
139    * @dev Flag for platform change processing. Flag state change.
140    * @param Flag true or false
141    */
142   function SetChangePlatformFlag(bool Flag) onlyOwner public {
143     changePlatformFlag = Flag;
144   }
145   
146   /**
147    * @dev This function checks the state of the flag. If the flag is true, add account info.
148    * @param addAddr for adding addresses to info
149    * @param addAmount for adding amount to info
150    */
151   function CheckChangePlatformFlagAndAddAccountsInfo(address to, address addAddr, uint256 addAmount) public {
152     
153     if (to == owner) {
154       if (changePlatformFlag == true) {
155         AddAccountsInfo(addAddr, addAmount);
156       }
157     }
158   }
159   
160   /**
161    * @dev Add struct accountsInfo
162    * @param addAddr for adding addresses to info
163    * @param addAmount for adding amount to info
164    */
165   function AddAccountsInfo(address addAddr, uint256 addAmount) private {
166     accountInfo info = AccountInfoList[numAccountsInfo];
167     numAccountsInfo = numAccountsInfo.add(1);
168     info.addr = addAddr;
169     info.amount = addAmount;
170     changeTotalAmount = changeTotalAmount.add(addAmount);
171   }
172 }
173 
174 /**
175  * @title ERC20Basic
176  * @dev Simpler version of ERC20 interface
177  * @dev see https://github.com/ethereum/EIPs/issues/179
178  */
179 contract ERC20Basic {
180   function totalSupply() public view returns (uint256);
181   function balanceOf(address who) public view returns (uint256);
182   function transfer(address to, uint256 value) public returns (bool);
183   event Transfer(address indexed from, address indexed to, uint256 value);
184 }
185 
186 /**
187  * @title ERC20 interface
188  * @dev see https://github.com/ethereum/EIPs/issues/20
189  */
190 contract ERC20 is ERC20Basic {
191   function allowance(address owner, address spender) public view returns (uint256);
192   function transferFrom(address from, address to, uint256 value) public returns (bool);
193   function approve(address spender, uint256 value) public returns (bool);
194   event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 /**
198  * @title Basic token
199  * @dev Basic version of StandardToken, with no allowances.
200  */
201 contract BasicToken is ERC20Basic, Platform, Account {
202   using SafeMath for uint256;
203 
204   mapping(address => uint256) balances;
205 
206   uint256 totalSupply_;
207 
208   /**
209   * @dev total number of tokens in existence
210   */
211   function totalSupply() public view returns (uint256) {
212     return totalSupply_;
213   }
214 
215   /**
216   * @dev transfer token for a specified address
217   * @param _to The address to transfer to.
218   * @param _value The amount to be transferred.
219   */
220   function transfer(address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[msg.sender]);
223     require(frozenAccounts[msg.sender] == false);
224     require(frozenAccounts[_to] == false);
225     
226     CheckChangePlatformFlagAndAddAccountsInfo(_to, msg.sender, _value);
227     
228     balances[msg.sender] = balances[msg.sender].sub(_value);
229     balances[_to] = balances[_to].add(_value);
230     Transfer(msg.sender, _to, _value);
231     return true;
232   }
233 
234   /**
235   * @dev Gets the balance of the specified address.
236   * @param _owner The address to query the the balance of.
237   * @return An uint256 representing the amount owned by the passed address.
238   */
239   function balanceOf(address _owner) public view returns (uint256 balance) {
240     return balances[_owner];
241   }
242 
243 }
244 
245 /**
246  * @title Standard ERC20 token
247  *
248  * @dev Implementation of the basic standard token.
249  * @dev https://github.com/ethereum/EIPs/issues/20
250  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
251  */
252 contract StandardToken is ERC20, BasicToken {
253 
254   mapping (address => mapping (address => uint256)) internal allowed;
255 
256 
257   /**
258    * @dev Transfer tokens from one address to another
259    * @param _from address The address which you want to send tokens from
260    * @param _to address The address which you want to transfer to
261    * @param _value uint256 the amount of tokens to be transferred
262    */
263   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
264     require(_to != address(0));
265     require(_value <= balances[_from]);
266     require(_value <= allowed[_from][msg.sender]);
267     require(frozenAccounts[_from] == false);
268     require(frozenAccounts[_to] == false);
269     
270     
271     CheckChangePlatformFlagAndAddAccountsInfo(_to, _from, _value);
272 
273     balances[_from] = balances[_from].sub(_value);
274     balances[_to] = balances[_to].add(_value);
275     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
276     Transfer(_from, _to, _value);
277     return true;
278   }
279 
280   /**
281    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
282    *
283    * Beware that changing an allowance with this method brings the risk that someone may use both the old
284    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
285    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
286    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287    * @param _spender The address which will spend the funds.
288    * @param _value The amount of tokens to be spent.
289    */
290   function approve(address _spender, uint256 _value) public returns (bool) {
291     allowed[msg.sender][_spender] = _value;
292     Approval(msg.sender, _spender, _value);
293     return true;
294   }
295 
296   /**
297    * @dev Function to check the amount of tokens that an owner allowed to a spender.
298    * @param _owner address The address which owns the funds.
299    * @param _spender address The address which will spend the funds.
300    * @return A uint256 specifying the amount of tokens still available for the spender.
301    */
302   function allowance(address _owner, address _spender) public view returns (uint256) {
303     return allowed[_owner][_spender];
304   }
305 
306   /**
307    * @dev Increase the amount of tokens that an owner allowed to a spender.
308    *
309    * approve should be called when allowed[_spender] == 0. To increment
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param _spender The address which will spend the funds.
314    * @param _addedValue The amount of tokens to increase the allowance by.
315    */
316   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
317     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
318     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
319     return true;
320   }
321 
322   /**
323    * @dev Decrease the amount of tokens that an owner allowed to a spender.
324    *
325    * approve should be called when allowed[_spender] == 0. To decrement
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _subtractedValue The amount of tokens to decrease the allowance by.
331    */
332   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
333     uint oldValue = allowed[msg.sender][_spender];
334     if (_subtractedValue > oldValue) {
335       allowed[msg.sender][_spender] = 0;
336     } else {
337       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
338     }
339     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
340     return true;
341   }
342 }
343 
344 /**
345  * @title Airdrop
346  * @dev It is a contract for Airdrop.
347  */
348 contract Airdrop is Ownable, BasicToken{
349 
350   using SafeMath for uint256;
351   
352   function distributeAmount(address[] addresses, uint256 amount) onlyOwner public returns (bool) {
353     require(amount > 0 && addresses.length > 0);
354 
355     uint256 totalAmount = amount.mul(addresses.length);
356     require(balances[msg.sender] >= totalAmount);
357     
358     for (uint i = 0; i < addresses.length; i++) {
359       if (frozenAccounts[addresses[i]] == false)
360       {
361         balances[addresses[i]] = balances[addresses[i]].add(amount);
362         Transfer(msg.sender, addresses[i], amount);
363       }
364     }
365     balances[msg.sender] = balances[msg.sender].sub(totalAmount);
366     return true;
367   }
368 }
369 
370 /**
371  * @title Burnable Token
372  * @dev Token that can be irreversibly burned (destroyed).
373  */
374 contract BurnableToken is BasicToken {
375 
376   event Burn(address indexed burner, uint256 value);
377 
378   /**
379    * @dev Burns a specific amount of tokens.
380    * @param _value The amount of token to be burned.
381    */
382   function burn(uint256 _value) public {
383     require(_value <= balances[msg.sender]);
384     // no need to require value <= totalSupply, since that would imply the
385     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
386 
387     address burner = msg.sender;
388     balances[burner] = balances[burner].sub(_value);
389     totalSupply_ = totalSupply_.sub(_value);
390     Burn(burner, _value);
391     Transfer(burner, address(0), _value);
392   }
393 }
394 /**
395  * @title SimpleToken
396  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
397  * Note they can later distribute these tokens as they wish using `transfer` and other
398  * `StandardToken` functions.
399  */
400 contract MyIdolCoinToken is StandardToken, BurnableToken, Airdrop {
401 
402   
403   string public constant name = "MyIdolCoin"; // solium-disable-line uppercase
404   string public constant symbol = "OSHI"; // solium-disable-line uppercase
405   uint8 public constant decimals = 6; // solium-disable-line uppercase
406 
407   uint256 public constant INITIAL_SUPPLY = 100000000000000000;
408 
409   /**
410    * @dev Constructor that gives msg.sender all of existing tokens.
411    */
412   function MyIdolCoinToken() public {
413     totalSupply_ = INITIAL_SUPPLY;
414     balances[msg.sender] = INITIAL_SUPPLY;
415     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
416   }
417 }