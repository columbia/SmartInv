1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 {
85   uint256 public totalSupply;
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   function allowance(address owner, address spender) public view returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Transfer(address indexed from, address indexed to, uint256 value);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 contract AElfToken is ERC20, Ownable {
96   using SafeMath for uint256;
97 
98   
99   // the controller of minting and destroying tokens
100   address public aelfDevMultisig = 0x6d3E0B5abFc141cAa674a3c11e1580e6fff2a0B9;
101   // the controller of approving of minting and withdraw tokens
102   address public aelfCommunityMultisig = 0x4885B422656D4B316C9C7Abc0c0Ab31A2677d9f0;
103 
104   struct TokensWithLock {
105     uint256 value;
106     uint256 blockNumber;
107   }
108   // Balances for each account
109   mapping(address => uint256) balances;
110   // Tokens with time lock
111   // Only when the tokens' blockNumber is less than current block number,
112   // can the tokens be minted to the owner
113   mapping(address => TokensWithLock) lockTokens;
114   
115   // Owner of account approves the transfer of an amount to another account
116   mapping(address => mapping (address => uint256)) allowed;
117   // Token Cap
118   uint256 public totalSupplyCap = 1e27;
119   // Token Info
120   string public name = "ELF Token";
121   string public symbol = "ELF";
122   uint8 public decimals = 18;
123 
124   bool public mintingFinished = false;
125   // the block number when deploy
126   uint256 public deployBlockNumber = getCurrentBlockNumber();
127   // the min threshold of lock time
128   uint256 public constant TIMETHRESHOLD = 7200;
129   // the time when mintTokensWithinTime can be called
130   uint256 public constant MINTTIME = 216000;
131   // the lock time of minted tokens
132   uint256 public durationOfLock = 7200;
133   // True if transfers are allowed
134   bool public transferable = false;
135   // True if the transferable can be change
136   bool public canSetTransferable = true;
137 
138 
139   modifier canMint() {
140     require(!mintingFinished);
141     _;
142   }
143 
144   modifier only(address _address) {
145     require(msg.sender == _address);
146     _;
147   }
148 
149   modifier nonZeroAddress(address _address) {
150     require(_address != address(0));
151     _;
152   }
153 
154   modifier canTransfer() {
155     require(transferable == true);
156     _;
157   }
158 
159   event SetDurationOfLock(address indexed _caller);
160   event ApproveMintTokens(address indexed _owner, uint256 _amount);
161   event WithdrawMintTokens(address indexed _owner, uint256 _amount);
162   event MintTokens(address indexed _owner, uint256 _amount);
163   event BurnTokens(address indexed _owner, uint256 _amount);
164   event MintFinished(address indexed _caller);
165   event SetTransferable(address indexed _address, bool _transferable);
166   event SetAElfDevMultisig(address indexed _old, address indexed _new);
167   event SetAElfCommunityMultisig(address indexed _old, address indexed _new);
168   event DisableSetTransferable(address indexed _address, bool _canSetTransferable);
169 
170   /**
171    * @dev transfer token for a specified address
172    * @param _to The address to transfer to.
173    * @param _value The amount to be transferred.
174    */
175   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[msg.sender]);
178 
179     // SafeMath.sub will throw if there is not enough balance.
180     balances[msg.sender] = balances[msg.sender].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     Transfer(msg.sender, _to, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Gets the balance of the specified address.
188    * @param _owner The address to query the the balance of.
189    * @return An uint256 representing the amount owned by the passed address.
190    */
191   function balanceOf(address _owner) public view returns (uint256 balance) {
192     return balances[_owner];
193   }
194 
195   /**
196    * @dev Transfer tokens from one address to another
197    * @param _from address The address which you want to send tokens from
198    * @param _to address The address which you want to transfer to
199    * @param _value uint256 the amount of tokens to be transferred
200    */
201   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
202     require(_to != address(0));
203     require(_value <= balances[_from]);
204     require(_value <= allowed[_from][msg.sender]);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    *
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param _spender The address which will spend the funds.
221    * @param _value The amount of tokens to be spent.
222    */
223   function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
224     allowed[msg.sender][_spender] = _value;
225     Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    * @return A uint256 specifying the amount of tokens still available for the spender.
234    */
235   function allowance(address _owner, address _spender) public view returns (uint256) {
236     return allowed[_owner][_spender];
237   }
238 
239   /**
240    * approve should be called when allowed[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    */
245   function increaseApproval(address _spender, uint256 _addedValue) canTransfer public returns (bool) {
246     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   function decreaseApproval(address _spender, uint256 _subtractedValue) canTransfer public returns (bool) {
252     uint256 oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261   /**
262    * @dev Enables token holders to transfer their tokens freely if true
263    * @param _transferable True if transfers are allowed
264    */
265   function setTransferable(bool _transferable) only(aelfDevMultisig) public {
266     require(canSetTransferable == true);
267     transferable = _transferable;
268     SetTransferable(msg.sender, _transferable);
269   }
270 
271   /**
272    * @dev disable the canSetTransferable
273    */
274   function disableSetTransferable() only(aelfDevMultisig) public {
275     transferable = true;
276     canSetTransferable = false;
277     DisableSetTransferable(msg.sender, false);
278   }
279 
280   /**
281    * @dev Set the aelfMultisig
282    * @param _aelfDevMultisig The new aelfMultisig
283    */
284   function setAElfDevMultisig(address _aelfDevMultisig) only(aelfDevMultisig) nonZeroAddress(_aelfDevMultisig) public {
285     aelfDevMultisig = _aelfDevMultisig;
286     SetAElfDevMultisig(msg.sender, _aelfDevMultisig);
287   }
288   /**
289    * @dev Set the aelfCommunityMultisig
290    * @param _aelfCommunityMultisig The new aelfCommunityMultisig
291    */
292   function setAElfCommunityMultisig(address _aelfCommunityMultisig) only(aelfCommunityMultisig) nonZeroAddress(_aelfCommunityMultisig) public {
293     aelfCommunityMultisig = _aelfCommunityMultisig;
294     SetAElfCommunityMultisig(msg.sender, _aelfCommunityMultisig);
295   }
296   /**
297    * @dev Set the duration of lock of tokens approved of minting
298    * @param _durationOfLock the new duration of lock
299    */
300   function setDurationOfLock(uint256 _durationOfLock) canMint only(aelfCommunityMultisig) public {
301     require(_durationOfLock >= TIMETHRESHOLD);
302     durationOfLock = _durationOfLock;
303     SetDurationOfLock(msg.sender);
304   }
305   /**
306    * @dev Get the quantity of locked tokens
307    * @param _owner The address of locked tokens
308    * @return the quantity and the lock time of locked tokens
309    */
310    function getLockTokens(address _owner) nonZeroAddress(_owner) view public returns (uint256 value, uint256 blockNumber) {
311      return (lockTokens[_owner].value, lockTokens[_owner].blockNumber);
312    }
313 
314   /**
315    * @dev Approve of minting `_amount` tokens that are assigned to `_owner`
316    * @param _owner The address that will be assigned the new tokens
317    * @param _amount The quantity of tokens approved of mintting
318    * @return True if the tokens are approved of mintting correctly
319    */
320   function approveMintTokens(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(aelfCommunityMultisig) public returns (bool) {
321     require(_amount > 0);
322     uint256 previousLockTokens = lockTokens[_owner].value;
323     require(previousLockTokens + _amount >= previousLockTokens);
324     uint256 curTotalSupply = totalSupply;
325     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
326     require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap
327     uint256 previousBalanceTo = balanceOf(_owner);
328     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
329     lockTokens[_owner].value = previousLockTokens.add(_amount);
330     uint256 curBlockNumber = getCurrentBlockNumber();
331     lockTokens[_owner].blockNumber = curBlockNumber.add(durationOfLock);
332     ApproveMintTokens(_owner, _amount);
333     return true;
334   }
335   /**
336    * @dev Withdraw approval of minting `_amount` tokens that are assigned to `_owner`
337    * @param _owner The address that will be withdrawn the tokens
338    * @param _amount The quantity of tokens withdrawn approval of mintting
339    * @return True if the tokens are withdrawn correctly
340    */
341   function withdrawMintTokens(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(aelfCommunityMultisig) public returns (bool) {
342     require(_amount > 0);
343     uint256 previousLockTokens = lockTokens[_owner].value;
344     require(previousLockTokens - _amount >= 0);
345     lockTokens[_owner].value = previousLockTokens.sub(_amount);
346     if (previousLockTokens - _amount == 0) {
347       lockTokens[_owner].blockNumber = 0;
348     }
349     WithdrawMintTokens(_owner, _amount);
350     return true;
351   }
352   /**
353    * @dev Mints `_amount` tokens that are assigned to `_owner`
354    * @param _owner The address that will be assigned the new tokens
355    * @return True if the tokens are minted correctly
356    */
357   function mintTokens(address _owner) canMint only(aelfDevMultisig) nonZeroAddress(_owner) public returns (bool) {
358     require(lockTokens[_owner].blockNumber <= getCurrentBlockNumber());
359     uint256 _amount = lockTokens[_owner].value;
360     uint256 curTotalSupply = totalSupply;
361     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
362     require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap
363     uint256 previousBalanceTo = balanceOf(_owner);
364     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
365     
366     totalSupply = curTotalSupply.add(_amount);
367     balances[_owner] = previousBalanceTo.add(_amount);
368     lockTokens[_owner].value = 0;
369     lockTokens[_owner].blockNumber = 0;
370     MintTokens(_owner, _amount);
371     Transfer(0, _owner, _amount);
372     return true;
373   }
374   /**
375    * @dev Mints `_amount` tokens that are assigned to `_owner` within one day after deployment
376    * the tokens minted will be added to balance immediately
377    * @param _owner The address that will be assigned the new tokens
378    * @param _amount The quantity of tokens withdrawn minted
379    * @return True if the tokens are minted correctly
380    */
381   function mintTokensWithinTime(address _owner, uint256 _amount) nonZeroAddress(_owner) canMint only(aelfDevMultisig) public returns (bool) {
382     require(_amount > 0);
383     require(getCurrentBlockNumber() < (deployBlockNumber + MINTTIME));
384     uint256 curTotalSupply = totalSupply;
385     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
386     require(curTotalSupply + _amount <= totalSupplyCap);  // Check for overflow of total supply cap
387     uint256 previousBalanceTo = balanceOf(_owner);
388     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
389     
390     totalSupply = curTotalSupply.add(_amount);
391     balances[_owner] = previousBalanceTo.add(_amount);
392     MintTokens(_owner, _amount);
393     Transfer(0, _owner, _amount);
394     return true;
395   }
396   /**
397    * @dev Transfer tokens to multiple addresses
398    * @param _addresses The addresses that will receieve tokens
399    * @param _amounts The quantity of tokens that will be transferred
400    * @return True if the tokens are transferred correctly
401    */
402   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts) canTransfer public returns (bool) {
403     for (uint256 i = 0; i < _addresses.length; i++) {
404       require(_addresses[i] != address(0));
405       require(_amounts[i] <= balances[msg.sender]);
406       require(_amounts[i] > 0);
407 
408       // SafeMath.sub will throw if there is not enough balance.
409       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
410       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
411       Transfer(msg.sender, _addresses[i], _amounts[i]);
412     }
413     return true;
414   }
415 
416   /**
417    * @dev Burns `_amount` tokens from `_owner`
418    * @param _amount The quantity of tokens being burned
419    * @return True if the tokens are burned correctly
420    */
421   function burnTokens(uint256 _amount) public returns (bool) {
422     require(_amount > 0);
423     uint256 curTotalSupply = totalSupply;
424     require(curTotalSupply >= _amount);
425     uint256 previousBalanceTo = balanceOf(msg.sender);
426     require(previousBalanceTo >= _amount);
427     totalSupply = curTotalSupply.sub(_amount);
428     balances[msg.sender] = previousBalanceTo.sub(_amount);
429     BurnTokens(msg.sender, _amount);
430     Transfer(msg.sender, 0, _amount);
431     return true;
432   }
433   /**
434    * @dev Function to stop minting new tokens.
435    * @return True if the operation was successful.
436    */
437   function finishMinting() only(aelfDevMultisig) canMint public returns (bool) {
438     mintingFinished = true;
439     MintFinished(msg.sender);
440     return true;
441   }
442 
443   function getCurrentBlockNumber() private view returns (uint256) {
444     return block.number;
445   }
446 }