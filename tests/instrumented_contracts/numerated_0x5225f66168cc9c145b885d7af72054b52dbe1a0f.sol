1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
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
80 contract Autonomy is Ownable {
81     address public congress;
82 
83     modifier onlyCongress() {
84         require(msg.sender == congress);
85         _;
86     }
87 
88     /**
89      * @dev initialize a Congress contract address for this token
90      *
91      * @param _congress address the congress contract address
92      */
93     function initialCongress(address _congress) onlyOwner public {
94         require(_congress != address(0));
95         congress = _congress;
96     }
97 
98     /**
99      * @dev set a Congress contract address for this token
100      * must change this address by the last congress contract
101      *
102      * @param _congress address the congress contract address
103      */
104     function changeCongress(address _congress) onlyCongress public {
105         require(_congress != address(0));
106         congress = _congress;
107     }
108 }
109 
110 contract Claimable is Ownable {
111   address public pendingOwner;
112 
113   /**
114    * @dev Modifier throws if called by any account other than the pendingOwner.
115    */
116   modifier onlyPendingOwner() {
117     require(msg.sender == pendingOwner);
118     _;
119   }
120 
121   /**
122    * @dev Allows the current owner to set the pendingOwner address.
123    * @param newOwner The address to transfer ownership to.
124    */
125   function transferOwnership(address newOwner) onlyOwner public {
126     pendingOwner = newOwner;
127   }
128 
129   /**
130    * @dev Allows the pendingOwner address to finalize the transfer.
131    */
132   function claimOwnership() onlyPendingOwner public {
133     OwnershipTransferred(owner, pendingOwner);
134     owner = pendingOwner;
135     pendingOwner = address(0);
136   }
137 }
138 
139 contract OwnerContract is Claimable {
140     Claimable public ownedContract;
141     address internal origOwner;
142 
143     /**
144      * @dev bind a contract as its owner
145      *
146      * @param _contract the contract address that will be binded by this Owner Contract
147      */
148     function bindContract(address _contract) onlyOwner public returns (bool) {
149         require(_contract != address(0));
150         ownedContract = Claimable(_contract);
151         origOwner = ownedContract.owner();
152 
153         // take ownership of the owned contract
154         ownedContract.claimOwnership();
155 
156         return true;
157     }
158 
159     /**
160      * @dev change the owner of the contract from this contract address to the original one.
161      *
162      */
163     function transferOwnershipBack() onlyOwner public {
164         ownedContract.transferOwnership(origOwner);
165         ownedContract = Claimable(address(0));
166         origOwner = address(0);
167     }
168 
169     /**
170      * @dev change the owner of the contract from this contract address to another one.
171      *
172      * @param _nextOwner the contract address that will be next Owner of the original Contract
173      */
174     function changeOwnershipto(address _nextOwner)  onlyOwner public {
175         ownedContract.transferOwnership(_nextOwner);
176         ownedContract = Claimable(address(0));
177         origOwner = address(0);
178     }
179 }
180 
181 contract MintDRCT is OwnerContract, Autonomy {
182     using SafeMath for uint256;
183 
184     uint256 public TOTAL_SUPPLY_CAP = 1000000000E18;
185     bool public capInitialized = false;
186 
187     address[] internal mainAccounts = [
188         0xaD5CcBE3aaB42812aa05921F0513C509A4fb5b67, // tokensale
189         0xBD37616a455f1054644c27CC9B348CE18D490D9b, // community
190         0x4D9c90Cc719B9bd445cea9234F0d90BaA79ad629, // foundation
191         0x21000ec96084D2203C978E38d781C84F497b0edE  // miscellaneous
192     ];
193 
194     uint8[] internal mainPercentages = [30, 40, 15, 15];
195 
196     mapping (address => uint) internal accountCaps;
197 
198     modifier afterCapInit() {
199         require(capInitialized);
200         _;
201     }
202 
203     /**
204      * @dev set capacity limitation for every main accounts
205      *
206      */
207     function initialCaps() onlyOwner public returns (bool) {
208         for (uint i = 0; i < mainAccounts.length; i = i.add(1)) {
209             accountCaps[mainAccounts[i]] = TOTAL_SUPPLY_CAP * mainPercentages[i] / 100;
210         }
211 
212         capInitialized = true;
213 
214         return true;
215     }
216 
217     /**
218      * @dev Mint DRC Tokens from one specific wallet addresses
219      *
220      * @param _ind uint8 the main account index
221      * @param _value uint256 the amounts of tokens to be minted
222      */
223     function mintUnderCap(uint _ind, uint256 _value) onlyOwner afterCapInit public returns (bool) {
224         require(_ind < mainAccounts.length);
225         address accountAddr = mainAccounts[_ind];
226         uint256 accountBalance = MintableToken(ownedContract).balanceOf(accountAddr);
227         require(_value <= accountCaps[accountAddr].sub(accountBalance));
228 
229         return MintableToken(ownedContract).mint(accountAddr, _value);
230     }
231 
232     /**
233      * @dev Mint DRC Tokens from serveral specific wallet addresses
234      *
235      * @param _values uint256 the amounts of tokens to be minted
236      */
237     function mintAll(uint256[] _values) onlyOwner afterCapInit public returns (bool) {
238         require(_values.length == mainAccounts.length);
239 
240         bool res = true;
241         for(uint i = 0; i < _values.length; i = i.add(1)) {
242             res = mintUnderCap(i, _values[i]) && res;
243         }
244 
245         return res;
246     }
247 
248     /**
249      * @dev Mint DRC Tokens from serveral specific wallet addresses upto cap limitation
250      *
251      */
252     function mintUptoCap() onlyOwner afterCapInit public returns (bool) {
253         bool res = true;
254         for(uint i = 0; i < mainAccounts.length; i = i.add(1)) {
255             require(MintableToken(ownedContract).balanceOf(mainAccounts[i]) == 0);
256             res = MintableToken(ownedContract).mint(mainAccounts[i], accountCaps[mainAccounts[i]]) && res;
257         }
258 
259         require(res);
260         return MintableToken(ownedContract).finishMinting(); // when up to cap limit, then stop minting.
261     }
262 
263     /**
264      * @dev raise the supply capacity of one specific wallet addresses
265      *
266      * @param _ind uint the main account index
267      * @param _value uint256 the amounts of tokens to be added to capacity limitation
268      */
269     function raiseCap(uint _ind, uint256 _value) onlyCongress afterCapInit public returns (bool) {
270         require(_ind < mainAccounts.length);
271         require(_value > 0);
272 
273         accountCaps[mainAccounts[_ind]] = accountCaps[mainAccounts[_ind]].add(_value);
274         return true;
275     }
276 
277     /**
278      * @dev query the main account address of one type
279      *
280      * @param _ind the index of the main account
281      */
282     function getMainAccount(uint _ind) public view returns (address) {
283         require(_ind < mainAccounts.length);
284         return mainAccounts[_ind];
285     }
286 
287     /**
288      * @dev query the supply capacity of one type of main account
289      *
290      * @param _ind the index of the main account
291      */
292     function getAccountCap(uint _ind) public view returns (uint256) {
293         require(_ind < mainAccounts.length);
294         return accountCaps[mainAccounts[_ind]];
295     }
296 
297     /**
298      * @dev set one type of main account to another address
299      *
300      * @param _ind the main account index
301      * @param _newAddr address the new main account address
302      */
303     function setMainAccount(uint _ind, address _newAddr) onlyOwner public returns (bool) {
304         require(_ind < mainAccounts.length);
305         require(_newAddr != address(0));
306 
307         mainAccounts[_ind] = _newAddr;
308         return true;
309     }
310 }
311 
312 contract ERC20Basic {
313   function totalSupply() public view returns (uint256);
314   function balanceOf(address who) public view returns (uint256);
315   function transfer(address to, uint256 value) public returns (bool);
316   event Transfer(address indexed from, address indexed to, uint256 value);
317 }
318 
319 contract BasicToken is ERC20Basic {
320   using SafeMath for uint256;
321 
322   mapping(address => uint256) balances;
323 
324   uint256 totalSupply_;
325 
326   /**
327   * @dev total number of tokens in existence
328   */
329   function totalSupply() public view returns (uint256) {
330     return totalSupply_;
331   }
332 
333   /**
334   * @dev transfer token for a specified address
335   * @param _to The address to transfer to.
336   * @param _value The amount to be transferred.
337   */
338   function transfer(address _to, uint256 _value) public returns (bool) {
339     require(_to != address(0));
340     require(_value <= balances[msg.sender]);
341 
342     // SafeMath.sub will throw if there is not enough balance.
343     balances[msg.sender] = balances[msg.sender].sub(_value);
344     balances[_to] = balances[_to].add(_value);
345     Transfer(msg.sender, _to, _value);
346     return true;
347   }
348 
349   /**
350   * @dev Gets the balance of the specified address.
351   * @param _owner The address to query the the balance of.
352   * @return An uint256 representing the amount owned by the passed address.
353   */
354   function balanceOf(address _owner) public view returns (uint256 balance) {
355     return balances[_owner];
356   }
357 
358 }
359 
360 contract ERC20 is ERC20Basic {
361   function allowance(address owner, address spender) public view returns (uint256);
362   function transferFrom(address from, address to, uint256 value) public returns (bool);
363   function approve(address spender, uint256 value) public returns (bool);
364   event Approval(address indexed owner, address indexed spender, uint256 value);
365 }
366 
367 contract StandardToken is ERC20, BasicToken {
368 
369   mapping (address => mapping (address => uint256)) internal allowed;
370 
371 
372   /**
373    * @dev Transfer tokens from one address to another
374    * @param _from address The address which you want to send tokens from
375    * @param _to address The address which you want to transfer to
376    * @param _value uint256 the amount of tokens to be transferred
377    */
378   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
379     require(_to != address(0));
380     require(_value <= balances[_from]);
381     require(_value <= allowed[_from][msg.sender]);
382 
383     balances[_from] = balances[_from].sub(_value);
384     balances[_to] = balances[_to].add(_value);
385     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
386     Transfer(_from, _to, _value);
387     return true;
388   }
389 
390   /**
391    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
392    *
393    * Beware that changing an allowance with this method brings the risk that someone may use both the old
394    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
395    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
396    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
397    * @param _spender The address which will spend the funds.
398    * @param _value The amount of tokens to be spent.
399    */
400   function approve(address _spender, uint256 _value) public returns (bool) {
401     allowed[msg.sender][_spender] = _value;
402     Approval(msg.sender, _spender, _value);
403     return true;
404   }
405 
406   /**
407    * @dev Function to check the amount of tokens that an owner allowed to a spender.
408    * @param _owner address The address which owns the funds.
409    * @param _spender address The address which will spend the funds.
410    * @return A uint256 specifying the amount of tokens still available for the spender.
411    */
412   function allowance(address _owner, address _spender) public view returns (uint256) {
413     return allowed[_owner][_spender];
414   }
415 
416   /**
417    * @dev Increase the amount of tokens that an owner allowed to a spender.
418    *
419    * approve should be called when allowed[_spender] == 0. To increment
420    * allowed value is better to use this function to avoid 2 calls (and wait until
421    * the first transaction is mined)
422    * From MonolithDAO Token.sol
423    * @param _spender The address which will spend the funds.
424    * @param _addedValue The amount of tokens to increase the allowance by.
425    */
426   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
427     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
428     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
429     return true;
430   }
431 
432   /**
433    * @dev Decrease the amount of tokens that an owner allowed to a spender.
434    *
435    * approve should be called when allowed[_spender] == 0. To decrement
436    * allowed value is better to use this function to avoid 2 calls (and wait until
437    * the first transaction is mined)
438    * From MonolithDAO Token.sol
439    * @param _spender The address which will spend the funds.
440    * @param _subtractedValue The amount of tokens to decrease the allowance by.
441    */
442   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
443     uint oldValue = allowed[msg.sender][_spender];
444     if (_subtractedValue > oldValue) {
445       allowed[msg.sender][_spender] = 0;
446     } else {
447       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
448     }
449     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
450     return true;
451   }
452 
453 }
454 
455 contract MintableToken is StandardToken, Ownable {
456   event Mint(address indexed to, uint256 amount);
457   event MintFinished();
458 
459   bool public mintingFinished = false;
460 
461 
462   modifier canMint() {
463     require(!mintingFinished);
464     _;
465   }
466 
467   /**
468    * @dev Function to mint tokens
469    * @param _to The address that will receive the minted tokens.
470    * @param _amount The amount of tokens to mint.
471    * @return A boolean that indicates if the operation was successful.
472    */
473   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
474     totalSupply_ = totalSupply_.add(_amount);
475     balances[_to] = balances[_to].add(_amount);
476     Mint(_to, _amount);
477     Transfer(address(0), _to, _amount);
478     return true;
479   }
480 
481   /**
482    * @dev Function to stop minting new tokens.
483    * @return True if the operation was successful.
484    */
485   function finishMinting() onlyOwner canMint public returns (bool) {
486     mintingFinished = true;
487     MintFinished();
488     return true;
489   }
490 }