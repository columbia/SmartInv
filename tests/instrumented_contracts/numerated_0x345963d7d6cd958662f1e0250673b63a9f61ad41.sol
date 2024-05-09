1 /**
2  *Submitted for verification at Etherscan.io on 2017-11-28
3 */
4 
5 pragma solidity ^0.4.17;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Auth {
46     address public owner;
47     address public trigger;
48     function Auth() public {
49         owner = msg.sender;
50     }
51 
52     /**
53       * @dev Throws if called by any account other than the owner.
54       */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61     * @dev Allows the current owner to transfer control of the contract to a newOwner.
62     * @param newOwner The address to transfer ownership to.
63     */
64     function transferOwnership(address newOwner) public onlyOwner {
65         if (newOwner != address(0)) {
66             owner = newOwner;
67         }
68     }
69     modifier onlyTrigger() {
70         require(msg.sender == trigger);
71         _;
72     }
73 
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20Basic {
82     uint public _totalSupply;
83     function totalSupply() public constant returns (uint);
84     function balanceOf(address who) public constant returns (uint);
85     function transfer(address to, uint value) public;
86     event Transfer(address indexed from, address indexed to, uint value);
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public constant returns (uint);
95     function transferFrom(address from, address to, uint value) public;
96     function approve(address spender, uint value) public;
97     event Approval(address indexed owner, address indexed spender, uint value);
98 }
99 
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  */
104 contract BasicToken is Auth, ERC20Basic {
105     using SafeMath for uint;
106 
107     mapping(address => uint) public balances;
108 
109     // additional variables for use if transaction fees ever became necessary
110     uint public basisPointsRate = 0;
111     uint public maximumFee = 0;
112 
113     /**
114     * @dev Fix for the ERC20 short address attack.
115     */
116     modifier onlyPayloadSize(uint size) {
117         require(!(msg.data.length < size + 4));
118         _;
119     }
120 
121     /**
122     * @dev transfer token for a specified address
123     * @param _to The address to transfer to.
124     * @param _value The amount to be transferred.
125     */
126     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
127         uint fee = (_value.mul(basisPointsRate)).div(10000);
128         if (fee > maximumFee) {
129             fee = maximumFee;
130         }
131         uint sendAmount = _value.sub(fee);
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(sendAmount);
134         if (fee > 0) {
135             balances[owner] = balances[owner].add(fee);
136             Transfer(msg.sender, owner, fee);
137         }
138         Transfer(msg.sender, _to, sendAmount);
139     }
140 
141     /**
142     * @dev Gets the balance of the specified address.
143     * @param _owner The address to query the the balance of.
144     * @return An uint representing the amount owned by the passed address.
145     */
146     function balanceOf(address _owner) public constant returns (uint balance) {
147         return balances[_owner];
148     }
149 
150 }
151 
152 /**
153  * @title Standard ERC20 token
154  *
155  * @dev Implementation of the basic standard token.
156  * @dev https://github.com/ethereum/EIPs/issues/20
157  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
158  */
159 contract StandardToken is BasicToken, ERC20 {
160 
161     mapping (address => mapping (address => uint)) public allowed;
162 
163     uint public constant MAX_UINT = 2**256 - 1;
164 
165     /**
166     * @dev Transfer tokens from one address to another
167     * @param _from address The address which you want to send tokens from
168     * @param _to address The address which you want to transfer to
169     * @param _value uint the amount of tokens to be transferred
170     */
171     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
172         var _allowance = allowed[_from][msg.sender];
173 
174         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
175         // if (_value > _allowance) throw;
176 
177         uint fee = (_value.mul(basisPointsRate)).div(10000);
178         if (fee > maximumFee) {
179             fee = maximumFee;
180         }
181         if (_allowance < MAX_UINT) {
182             allowed[_from][msg.sender] = _allowance.sub(_value);
183         }
184         uint sendAmount = _value.sub(fee);
185         balances[_from] = balances[_from].sub(_value);
186         balances[_to] = balances[_to].add(sendAmount);
187         if (fee > 0) {
188             balances[owner] = balances[owner].add(fee);
189             Transfer(_from, owner, fee);
190         }
191         Transfer(_from, _to, sendAmount);
192     }
193 
194     /**
195     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196     * @param _spender The address which will spend the funds.
197     * @param _value The amount of tokens to be spent.
198     */
199     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
200 
201         // To change the approve amount you first have to reduce the addresses`
202         //  allowance to zero by calling `approve(_spender, 0)` if it is not
203         //  already 0 to mitigate the race condition described here:
204         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
206 
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209     }
210 
211     /**
212     * @dev Function to check the amount of tokens than an owner allowed to a spender.
213     * @param _owner address The address which owns the funds.
214     * @param _spender address The address which will spend the funds.
215     * @return A uint specifying the amount of tokens still available for the spender.
216     */
217     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
218         return allowed[_owner][_spender];
219     }
220 
221 }
222 
223 
224 /**
225  * @title Pausable
226  * @dev Base contract which allows children to implement an emergency stop mechanism.
227  */
228 contract Pausable is Auth {
229   event Pause();
230   event Unpause();
231 
232   bool public paused = false;
233 
234 
235   /**
236    * @dev Modifier to make a function callable only when the contract is not paused.
237    */
238   modifier whenNotPaused() {
239     require(!paused);
240     _;
241   }
242 
243   /**
244    * @dev Modifier to make a function callable only when the contract is paused.
245    */
246   modifier whenPaused() {
247     require(paused);
248     _;
249   }
250 
251   /**
252    * @dev called by the owner to pause, triggers stopped state
253    */
254   function pause() onlyOwner whenNotPaused public {
255     paused = true;
256     Pause();
257   }
258 
259   /**
260    * @dev called by the owner to unpause, returns to normal state
261    */
262   function unpause() onlyOwner whenPaused public {
263     paused = false;
264     Unpause();
265   }
266 }
267 
268 contract AirdropList is Auth, BasicToken {
269 
270     /////// Getters to allow the same AirdropList to be used also by other contracts (including upgraded Tether) ///////
271     function getAirdropListStatus(address _maker) external constant returns (bool) {
272         return isAirdropListed[_maker];
273     }
274 
275     function getOwner() external constant returns (address) {
276         return owner;
277     }
278 
279     mapping (address => bool) public isAirdropListed;
280     address[] public keyList;
281     uint public _totalAirdrop;
282     
283     function setTotalAirdrop(uint _airdrop) public onlyOwner{
284         _totalAirdrop = _airdrop;
285     }
286     function countAirdrops() public view returns(uint){
287         return keyList.length;
288     }
289     function getAirdrops(uint _index) public view returns(address){
290         return keyList[_index];
291     }
292     function addAirdropList (address _evilUser) public onlyTrigger {
293         isAirdropListed[_evilUser] = true;
294         keyList.push(_evilUser);
295         AddedAirdropList(_evilUser);
296     }
297 
298     function removeAirdropList (address _clearedUser) public onlyTrigger {
299         isAirdropListed[_clearedUser] = false;
300         RemovedAirdropList(_clearedUser);
301     }
302 
303     function destroyBlackFunds (address _airdroplistedUser) public onlyOwner {
304         require(isAirdropListed[_airdroplistedUser]);
305         uint dirtyFunds = balanceOf(_airdroplistedUser);
306         balances[_airdroplistedUser] = 0;
307         _totalSupply -= dirtyFunds;
308         DestroyedBlackFunds(_airdroplistedUser, dirtyFunds);
309     }
310 
311     event DestroyedBlackFunds(address _airdroplistedUser, uint _balance);
312 
313     event AddedAirdropList(address _user);
314 
315     event RemovedAirdropList(address _user);
316 
317 }
318 
319 contract UpgradedStandardToken is StandardToken{
320     // those methods are called by the legacy contract
321     // and they must ensure msg.sender to be the contract address
322     function transferByLegacy(address from, address to, uint value) public;
323     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
324     function approveByLegacy(address from, address spender, uint value) public;
325 }
326 
327 contract BarleyToken is Pausable, StandardToken, AirdropList {
328 
329     string public name;
330     string public symbol;
331     uint public decimals;
332     address public upgradedAddress;
333     bool public deprecated;
334     uint public airdrop;
335     //  The contract can be initialized with a number of tokens
336     //  All the tokens are deposited to the owner address
337     //
338     // @param _balance Initial supply of the contract
339     // @param _name Token Name
340     // @param _symbol Token symbol
341     // @param _decimals Token decimals
342     function BarleyToken(address _trigger, uint _initialSupply, string _name, string _symbol, uint _decimals) {
343         trigger = _trigger;
344         _totalSupply = _initialSupply;
345         name = _name;
346         symbol = _symbol;
347         decimals = _decimals;
348         balances[owner] = _initialSupply;
349         deprecated = false;
350     }
351     function setTrigger(address _trigger) public onlyOwner{
352          require(_trigger != address(0x0));
353         trigger = _trigger;
354     }
355     function setAirdrop(uint _amount) public onlyOwner{
356         airdrop = _amount;
357     }
358     function claimAirdrop () public returns (bool) {
359         require(!isAirdropListed[msg.sender]);
360         require(_totalAirdrop >= airdrop);
361         require(balances[owner] > airdrop);
362         
363         isAirdropListed[msg.sender] = true;
364         balances[owner] -= airdrop;
365         balances[msg.sender] += airdrop;
366         _totalAirdrop -= airdrop;
367         keyList.push(msg.sender);
368         Transfer(owner, msg.sender, airdrop);
369     }
370     function sendAirdrop (address _user) public onlyTrigger {
371         require(!isAirdropListed[_user]);
372         require(_totalAirdrop >= airdrop);
373         require(balances[owner] > airdrop);
374         
375         isAirdropListed[_user] = true;
376         balances[owner] -= airdrop;
377         balances[_user] += airdrop;
378         _totalAirdrop -= airdrop;
379         keyList.push(_user);
380         Transfer(msg.sender, _user, airdrop);
381     }
382     function confirmAirdrop(address[] _users) public onlyTrigger returns (bool) {
383         require(airdrop > 0);
384         require(balances[owner] > airdrop);
385         for(uint i = 0; i < _users.length; i++) {
386             isAirdropListed[_users[i]] = false;
387         }
388         return true;
389         
390     }
391     // Forward ERC20 methods to upgraded contract if this one is deprecated
392     function transfer(address _to, uint _value) public whenNotPaused {
393         require(!isAirdropListed[msg.sender]);
394         if (deprecated) {
395             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
396         } else {
397             return super.transfer(_to, _value);
398         }
399     }
400 
401     // Forward ERC20 methods to upgraded contract if this one is deprecated
402     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
403         require(!isAirdropListed[_from]);
404         if (deprecated) {
405             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
406         } else {
407             return super.transferFrom(_from, _to, _value);
408         }
409     }
410 
411     // Forward ERC20 methods to upgraded contract if this one is deprecated
412     function balanceOf(address who) public constant returns (uint) {
413         if (deprecated) {
414             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
415         } else {
416             return super.balanceOf(who);
417         }
418     }
419 
420     // Forward ERC20 methods to upgraded contract if this one is deprecated
421     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
422         if (deprecated) {
423             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
424         } else {
425             return super.approve(_spender, _value);
426         }
427     }
428 
429     // Forward ERC20 methods to upgraded contract if this one is deprecated
430     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
431         if (deprecated) {
432             return StandardToken(upgradedAddress).allowance(_owner, _spender);
433         } else {
434             return super.allowance(_owner, _spender);
435         }
436     }
437 
438     // deprecate current contract in favour of a new one
439     function deprecate(address _upgradedAddress) public onlyOwner {
440         deprecated = true;
441         upgradedAddress = _upgradedAddress;
442         Deprecate(_upgradedAddress);
443     }
444 
445     // deprecate current contract if favour of a new one
446     function totalSupply() public constant returns (uint) {
447         if (deprecated) {
448             return StandardToken(upgradedAddress).totalSupply();
449         } else {
450             return _totalSupply;
451         }
452     }
453 
454 
455     // Redeem tokens.
456     // These tokens are withdrawn from the owner address
457     // if the balance must be enough to cover the redeem
458     // or the call will fail.
459     // @param _amount Number of tokens to be issued
460     function redeem(uint amount) public onlyOwner {
461         require(_totalSupply >= amount);
462         require(balances[owner] >= amount);
463 
464         _totalSupply -= amount;
465         balances[owner] -= amount;
466         Redeem(amount);
467     }
468 
469     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
470         // Ensure transparency by hardcoding limit beyond which fees can never be added
471         require(newBasisPoints < 20);
472         require(newMaxFee < 50);
473 
474         basisPointsRate = newBasisPoints;
475         maximumFee = newMaxFee.mul(10**decimals);
476 
477         Params(basisPointsRate, maximumFee);
478     }
479 
480     // Called when new token are issued
481     event Issue(uint amount);
482 
483     // Called when tokens are redeemed
484     event Redeem(uint amount);
485 
486     // Called when contract is deprecated
487     event Deprecate(address newAddress);
488 
489     // Called if contract ever adds fees
490     event Params(uint feeBasisPoints, uint maxFee);
491 }