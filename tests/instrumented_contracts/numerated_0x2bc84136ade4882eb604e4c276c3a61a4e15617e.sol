1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 
38 
39 
40 
41 contract ERC20Basic {
42     uint public _totalSupply;
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address who) public constant returns (uint);
45     function transfer(address to, uint value) public;
46     event Transfer(address indexed from, address indexed to, uint value);
47 }
48 
49 
50 contract ERC20 is ERC20Basic {
51     function allowance(address owner, address spender) public constant returns (uint);
52     function transferFrom(address from, address to, uint value) public;
53     function approve(address spender, uint value) public;
54     event Approval(address indexed owner, address indexed spender, uint value);
55 }
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63     address public owner;
64 
65     /**
66       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67       * account.
68       */
69     function Ownable() public {
70         owner = msg.sender;
71     }
72 
73     /**
74       * @dev Throws if called by any account other than the owner.
75       */
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     /**
82     * @dev Allows the current owner to transfer control of the contract to a newOwner.
83     * @param newOwner The address to transfer ownership to.
84     */
85     function transferOwnership(address newOwner) public onlyOwner {
86         if (newOwner != address(0)) {
87             owner = newOwner;
88         }
89     }
90 
91 }
92 
93 
94 contract BasicToken is Ownable, ERC20Basic {
95     using SafeMath for uint;
96 
97     mapping(address => uint) public balances;
98 
99     // additional variables for use if transaction fees ever became necessary
100     uint public basisPointsRate = 0;
101     uint public maximumFee = 0;
102 
103 
104     modifier onlyPayloadSize(uint size) {
105         require(!(msg.data.length < size + 4));
106         _;
107     }
108 
109 
110     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
111         uint fee = (_value.mul(basisPointsRate)).div(10000);
112         if (fee > maximumFee) {
113             fee = maximumFee;
114         }
115         uint sendAmount = _value.sub(fee);
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(sendAmount);
118         if (fee > 0) {
119             balances[owner] = balances[owner].add(fee);
120             Transfer(msg.sender, owner, fee);
121         }
122         Transfer(msg.sender, _to, sendAmount);
123     }
124 
125     function balanceOf(address _owner) public constant returns (uint balance) {
126         return balances[_owner];
127     }
128 
129 }
130 
131 
132 contract StandardToken is BasicToken, ERC20 {
133 
134     mapping (address => mapping (address => uint)) public allowed;
135 
136     uint public constant MAX_UINT = 2**256 - 1;
137 
138     /**
139     * @dev Transfer tokens from one address to another
140     * @param _from address The address which you want to send tokens from
141     * @param _to address The address which you want to transfer to
142     * @param _value uint the amount of tokens to be transferred
143     */
144     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
145         var _allowance = allowed[_from][msg.sender];
146 
147         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
148         // if (_value > _allowance) throw;
149 
150         uint fee = (_value.mul(basisPointsRate)).div(10000);
151         if (fee > maximumFee) {
152             fee = maximumFee;
153         }
154         if (_allowance < MAX_UINT) {
155             allowed[_from][msg.sender] = _allowance.sub(_value);
156         }
157         uint sendAmount = _value.sub(fee);
158         balances[_from] = balances[_from].sub(_value);
159         balances[_to] = balances[_to].add(sendAmount);
160         if (fee > 0) {
161             balances[owner] = balances[owner].add(fee);
162             Transfer(_from, owner, fee);
163         }
164         Transfer(_from, _to, sendAmount);
165     }
166 
167     /**
168     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169     * @param _spender The address which will spend the funds.
170     * @param _value The amount of tokens to be spent.
171     */
172     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
173 
174         // To change the approve amount you first have to reduce the addresses`
175         //  allowance to zero by calling `approve(_spender, 0)` if it is not
176         //  already 0 to mitigate the race condition described here:
177         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
179 
180         allowed[msg.sender][_spender] = _value;
181         Approval(msg.sender, _spender, _value);
182     }
183 
184     /**
185     * @dev Function to check the amount of tokens than an owner allowed to a spender.
186     * @param _owner address The address which owns the funds.
187     * @param _spender address The address which will spend the funds.
188     * @return A uint specifying the amount of tokens still available for the spender.
189     */
190     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
191         return allowed[_owner][_spender];
192     }
193 
194 }
195 
196 
197 contract BlackList is Ownable, BasicToken {
198 
199     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
200     function getBlackListStatus(address _maker) external constant returns (bool) {
201         return isBlackListed[_maker];
202     }
203 
204     function getOwner() external constant returns (address) {
205         return owner;
206     }
207 
208     mapping (address => bool) public isBlackListed;
209     
210     function addBlackList (address _evilUser) public onlyOwner {
211         isBlackListed[_evilUser] = true;
212         AddedBlackList(_evilUser);
213     }
214 
215     function removeBlackList (address _clearedUser) public onlyOwner {
216         isBlackListed[_clearedUser] = false;
217         RemovedBlackList(_clearedUser);
218     }
219 
220     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
221         require(isBlackListed[_blackListedUser]);
222         uint dirtyFunds = balanceOf(_blackListedUser);
223         balances[_blackListedUser] = 0;
224         _totalSupply -= dirtyFunds;
225         DestroyedBlackFunds(_blackListedUser, dirtyFunds);
226     }
227 
228     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
229 
230     event AddedBlackList(address _user);
231 
232     event RemovedBlackList(address _user);
233 
234 }
235 
236 contract Pausable is Ownable {
237   event Pause();
238   event Unpause();
239 
240   bool public paused = false;
241 
242 
243   /**
244    * @dev Modifier to make a function callable only when the contract is not paused.
245    */
246   modifier whenNotPaused() {
247     require(!paused);
248     _;
249   }
250 
251   /**
252    * @dev Modifier to make a function callable only when the contract is paused.
253    */
254   modifier whenPaused() {
255     require(paused);
256     _;
257   }
258 
259   /**
260    * @dev called by the owner to pause, triggers stopped state
261    */
262   function pause() onlyOwner whenNotPaused public {
263     paused = true;
264     Pause();
265   }
266 
267   /**
268    * @dev called by the owner to unpause, returns to normal state
269    */
270   function unpause() onlyOwner whenPaused public {
271     paused = false;
272     Unpause();
273   }
274 }
275 
276 contract UpgradedStandardToken is StandardToken{
277     // those methods are called by the legacy contract
278     // and they must ensure msg.sender to be the contract address
279     function transferByLegacy(address from, address to, uint value) public;
280     function transferFromByLegacy(address sender, address from, address spender, uint value) public;
281     function approveByLegacy(address from, address spender, uint value) public;
282 }
283 
284 contract BurnableToken is StandardToken {
285 
286     event Burn(address indexed burner, uint256 value);
287 
288     /**
289      * @dev Burns a specific amount of tokens.
290      * @param _value The amount of token to be burned.
291      */
292     function burn(uint256 _value) public {
293         require(_value > 0);
294         require(_value <= balances[msg.sender]);
295         // no need to require value <= totalSupply, since that would imply the
296         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
297 
298         address burner = msg.sender;
299         balances[burner] = balances[burner].sub(_value);
300         _totalSupply = _totalSupply.sub(_value);
301         Burn(burner, _value);
302     }
303 }
304 
305 contract Clost is Pausable, StandardToken, BlackList, BurnableToken {
306 
307     string public name;
308     string public symbol;
309     uint public decimals;
310     address public upgradedAddress;
311     bool public deprecated;
312 
313     //  The contract can be initialized with a number of tokens
314     //  All the tokens are deposited to the owner address
315     //
316     // @param _balance Initial supply of the contract
317     // @param _name Token Name
318     // @param _symbol Token symbol
319     // @param _decimals Token decimals
320     function Clost(uint _initialSupply, string _name, string _symbol, uint _decimals) public {
321         _totalSupply = _initialSupply;
322         name = _name;
323         symbol = _symbol;
324         decimals = _decimals;
325         balances[owner] = _initialSupply;
326         deprecated = false;
327     }
328 
329     // Forward ERC20 methods to upgraded contract if this one is deprecated
330     function transfer(address _to, uint _value) public whenNotPaused {
331         require(!isBlackListed[msg.sender]);
332         if (deprecated) {
333             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
334         } else {
335             return super.transfer(_to, _value);
336         }
337     }
338 
339     // Forward ERC20 methods to upgraded contract if this one is deprecated
340     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
341         require(!isBlackListed[_from]);
342         if (deprecated) {
343             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
344         } else {
345             return super.transferFrom(_from, _to, _value);
346         }
347     }
348 
349     // Forward ERC20 methods to upgraded contract if this one is deprecated
350     function balanceOf(address who) public constant returns (uint) {
351         if (deprecated) {
352             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
353         } else {
354             return super.balanceOf(who);
355         }
356     }
357 
358     // Forward ERC20 methods to upgraded contract if this one is deprecated
359     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
360         if (deprecated) {
361             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
362         } else {
363             return super.approve(_spender, _value);
364         }
365     }
366 
367     // Forward ERC20 methods to upgraded contract if this one is deprecated
368     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
369         if (deprecated) {
370             return StandardToken(upgradedAddress).allowance(_owner, _spender);
371         } else {
372             return super.allowance(_owner, _spender);
373         }
374     }
375 
376     // deprecate current contract in favour of a new one
377     function deprecate(address _upgradedAddress) public onlyOwner {
378         deprecated = true;
379         upgradedAddress = _upgradedAddress;
380         Deprecate(_upgradedAddress);
381     }
382 
383     // deprecate current contract if favour of a new one
384     function totalSupply() public constant returns (uint) {
385         if (deprecated) {
386             return StandardToken(upgradedAddress).totalSupply();
387         } else {
388             return _totalSupply;
389         }
390     }
391 
392     // Issue a new amount of tokens
393     // these tokens are deposited into the owner address
394     //
395     // @param _amount Number of tokens to be issued
396     function issue(uint amount) public onlyOwner {
397         require(_totalSupply + amount > _totalSupply);
398         require(balances[owner] + amount > balances[owner]);
399 
400         balances[owner] += amount;
401         _totalSupply += amount;
402         Issue(amount);
403     }
404         
405 
406     
407     
408 
409     // Redeem tokens.
410     // These tokens are withdrawn from the owner address
411     // if the balance must be enough to cover the redeem
412     // or the call will fail.
413     // @param _amount Number of tokens to be issued
414     function redeem(uint amount) public onlyOwner {
415         require(_totalSupply >= amount);
416         require(balances[owner] >= amount);
417 
418         _totalSupply -= amount;
419         balances[owner] -= amount;
420         Redeem(amount);
421     }
422 
423     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
424         // Ensure transparency by hardcoding limit beyond which fees can never be added
425         require(newBasisPoints < 20);
426         require(newMaxFee < 50);
427 
428         basisPointsRate = newBasisPoints;
429         maximumFee = newMaxFee.mul(10**decimals);
430 
431         Params(basisPointsRate, maximumFee);
432     }
433 
434     // Called when new token are issued
435     event Issue(uint amount);
436 
437     // Called when tokens are redeemed
438     event Redeem(uint amount);
439 
440     // Called when contract is deprecated
441     event Deprecate(address newAddress);
442 
443     // Called if contract ever adds fees
444     event Params(uint feeBasisPoints, uint maxFee);
445 }