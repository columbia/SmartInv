1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     // uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return a / b;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
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
68   uint256 totalSupply_;
69 
70   /**
71   * @dev total number of tokens in existence
72   */
73   function totalSupply() public view returns (uint256) {
74     return totalSupply_;
75   }
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85 
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of.
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) public view returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101 }
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 /**
114  * @title Standard ERC20 token
115  *
116  * @dev Implementation of the basic standard token.
117  * @dev https://github.com/ethereum/EIPs/issues/20
118  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
119  */
120 contract StandardToken is ERC20, BasicToken {
121 
122   mapping (address => mapping (address => uint256)) internal allowed;
123 
124 
125   /**
126    * @dev Transfer tokens from one address to another
127    * @param _from address The address which you want to send tokens from
128    * @param _to address The address which you want to transfer to
129    * @param _value uint256 the amount of tokens to be transferred
130    */
131   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135 
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139     emit Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145    *
146    * Beware that changing an allowance with this method brings the risk that someone may use both the old
147    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
148    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
149    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     allowed[msg.sender][_spender] = _value;
155     emit Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifying the amount of tokens still available for the spender.
164    */
165   function allowance(address _owner, address _spender) public view returns (uint256) {
166     return allowed[_owner][_spender];
167   }
168 
169   /**
170    * @dev Increase the amount of tokens that an owner allowed to a spender.
171    *
172    * approve should be called when allowed[_spender] == 0. To increment
173    * allowed value is better to use this function to avoid 2 calls (and wait until
174    * the first transaction is mined)
175    * From MonolithDAO Token.sol
176    * @param _spender The address which will spend the funds.
177    * @param _addedValue The amount of tokens to increase the allowance by.
178    */
179   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
180     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
181     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185   /**
186    * @dev Decrease the amount of tokens that an owner allowed to a spender.
187    *
188    * approve should be called when allowed[_spender] == 0. To decrement
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    * @param _spender The address which will spend the funds.
193    * @param _subtractedValue The amount of tokens to decrease the allowance by.
194    */
195   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
196     uint oldValue = allowed[msg.sender][_spender];
197     if (_subtractedValue > oldValue) {
198       allowed[msg.sender][_spender] = 0;
199     } else {
200       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
201     }
202     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206 }
207 
208 /**
209  * @title MultiOwnable
210  */
211 contract MultiOwnable {
212   address public root;
213   mapping (address => address) public owners; // owner => parent of owner
214   
215   /**
216   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
217   * account.
218   */
219   constructor() public {
220     root = msg.sender;
221     owners[root] = root;
222   }
223   
224   /**
225   * @dev Throws if called by any account other than the owner.
226   */
227   modifier onlyOwner() {
228     require(owners[msg.sender] != 0);
229     _;
230   }
231   
232   /**
233   * @dev Adding new owners
234   */
235   function newOwner(address _owner) onlyOwner external returns (bool) {
236     require(_owner != 0);
237     owners[_owner] = msg.sender;
238     return true;
239   }
240   
241   /**
242     * @dev Deleting owners
243     */
244   function deleteOwner(address _owner) onlyOwner external returns (bool) {
245     require(owners[_owner] == msg.sender || (owners[_owner] != 0 && msg.sender == root));
246     owners[_owner] = 0;
247     return true;
248   }
249 }
250 
251 
252 /**
253  * @title Burnable Token
254  * @dev Token that can be irreversibly burned (destroyed).
255  */
256 contract BurnableToken is BasicToken {
257 
258   event Burn(address indexed burner, uint256 value);
259 
260   /**
261    * @dev Burns a specific amount of tokens.
262    * @param _value The amount of token to be burned.
263    */
264   function burn(uint256 _value) public {
265     _burn(msg.sender, _value);
266   }
267 
268   function _burn(address _who, uint256 _value) internal {
269     require(_value <= balances[_who]);
270     // no need to require value <= totalSupply, since that would imply the
271     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
272 
273     balances[_who] = balances[_who].sub(_value);
274     totalSupply_ = totalSupply_.sub(_value);
275     emit Burn(_who, _value);
276     emit Transfer(_who, address(0), _value);
277   }
278 }
279 
280 
281 /**
282  * @title Basic token
283  * @dev Basic version of StandardToken, with no allowances.
284  */
285 contract Blacklisted is MultiOwnable {
286 
287   mapping(address => bool) public blacklist;
288 
289   /**
290   * @dev Throws if called by any account other than the owner.
291   */
292   modifier notBlacklisted() {
293     require(blacklist[msg.sender] == false);
294     _;
295   }
296 
297   /**
298    * @dev Adds single address to blacklist.
299    * @param _villain Address to be added to the blacklist
300    */
301   function addToBlacklist(address _villain) external onlyOwner {
302     blacklist[_villain] = true;
303   }
304 
305   /**
306    * @dev Adds list of addresses to blacklist. Not overloaded due to limitations with truffle testing.
307    * @param _villains Addresses to be added to the blacklist
308    */
309   function addManyToBlacklist(address[] _villains) external onlyOwner {
310     for (uint256 i = 0; i < _villains.length; i++) {
311       blacklist[_villains[i]] = true;
312     }
313   }
314 
315   /**
316    * @dev Removes single address from blacklist.
317    * @param _villain Address to be removed to the blacklist
318    */
319   function removeFromBlacklist(address _villain) external onlyOwner {
320     blacklist[_villain] = false;
321   }
322 }
323 
324 
325 /**
326  * @title Mintable token
327  * @dev Simple ERC20 Token example, with mintable token creation
328  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
329  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
330  */
331 contract MintableToken is StandardToken, MultiOwnable {
332   event Mint(address indexed to, uint256 amount);
333   event MintFinished();
334 
335   bool public mintingFinished = false;
336 
337 
338   modifier canMint() {
339     require(!mintingFinished);
340     _;
341   }
342 
343   /**
344    * @dev Function to mint tokens
345    * @param _to The address that will receive the minted tokens.
346    * @param _amount The amount of tokens to mint.
347    * @return A boolean that indicates if the operation was successful.
348    */
349   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
350     totalSupply_ = totalSupply_.add(_amount);
351     balances[_to] = balances[_to].add(_amount);
352     emit Mint(_to, _amount);
353     emit Transfer(address(0), _to, _amount);
354     return true;
355   }
356 
357   /**
358    * @dev Function to stop minting new tokens.
359    * @return True if the operation was successful.
360    */
361   function finishMinting() onlyOwner canMint public returns (bool) {
362     mintingFinished = true;
363     emit MintFinished();
364     return true;
365   }
366 }
367 
368 
369 contract YFFStoken is MintableToken, BurnableToken, Blacklisted {
370 
371   string public constant name = "yffs.finance"; // solium-disable-line uppercase
372   string public constant symbol = "YFFS"; // solium-disable-line uppercase
373   uint8 public constant decimals = 18; // solium-disable-line uppercase, // 18 decimals is the strongly suggested default, avoid changing it
374 
375   uint256 public constant INITIAL_SUPPLY = 60 * 1000 * (10 ** uint256(decimals)); 
376 
377   bool public isUnlocked = false;
378   
379   /**
380    * @dev Constructor that gives msg.sender all of existing tokens.
381    */
382   constructor(address _wallet) public {
383     totalSupply_ = INITIAL_SUPPLY;
384     balances[_wallet] = INITIAL_SUPPLY;
385     emit Transfer(address(0), _wallet, INITIAL_SUPPLY);
386   }
387 
388   modifier onlyTransferable() {
389     require(isUnlocked || owners[msg.sender] != 0);
390     _;
391   }
392 
393   function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
394       return super.transferFrom(_from, _to, _value);
395   }
396 
397   function transfer(address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
398       return super.transfer(_to, _value);
399   }
400   
401   function unlockTransfer() public onlyOwner {
402       isUnlocked = true;
403   }
404   
405   function lockTransfer() public onlyOwner {
406       isUnlocked = false;
407   }
408 
409 }