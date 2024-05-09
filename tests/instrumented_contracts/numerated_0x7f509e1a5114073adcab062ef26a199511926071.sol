1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     /**
12       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13       * account.
14       */
15     constructor () public {
16         owner = msg.sender;
17     }
18 
19     /**
20       * @dev Throws if called by any account other than the owner.
21       */
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     /**
28     * @dev Allows the current owner to transfer control of the contract to a newOwner.
29     * @param newOwner The address to transfer ownership to.
30     */
31     function transferOwnership(address newOwner) public onlyOwner {
32         if (newOwner != address(0)) {
33             owner = newOwner;
34         }
35     }
36 
37 }
38 
39 /**
40  * @title ERC20Basic
41  * @dev Simpler version of ERC20 interface
42  * See https://github.com/ethereum/EIPs/issues/179
43  */
44 contract ERC20Basic {
45     function totalSupply() public view returns (uint256);
46     function balanceOf(address who) public view returns (uint256);
47     function transfer(address to, uint256 value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56     using SafeMath for uint256;
57 
58     mapping(address => uint256) balances;
59 
60     uint256 totalSupply_;
61 
62     /**
63     * @dev Total number of tokens in existence
64     */
65     function totalSupply() public view returns (uint256) {
66         return totalSupply_;
67     }
68 
69     /**
70     * @dev Transfer token for a specified address
71     * @param _to The address to transfer to.
72     * @param _value The amount to be transferred.
73     */
74     function transfer(address _to, uint256 _value) public returns (bool) {
75         require(_to != address(0), "Address must not be zero.");
76         require(_value <= balances[msg.sender], "There is no enough balance.");
77 
78         balances[msg.sender] = balances[msg.sender].sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         emit Transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     /**
85     * @dev Gets the balance of the specified address.
86     * @param _owner The address to query the the balance of.
87     * @return An uint256 representing the amount owned by the passed address.
88     */
89     function balanceOf(address _owner) public view returns (uint256) {
90         return balances[_owner];
91     }
92 
93 }
94 
95 /**
96  * @title ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/20
98  */
99 contract ERC20 is ERC20Basic {
100     function allowance(address owner, address spender)
101         public view returns (uint256);
102 
103     function transferFrom(address from, address to, uint256 value)
104         public returns (bool);
105 
106     function approve(address spender, uint256 value) public returns (bool);
107     event Approval(
108         address indexed owner,
109         address indexed spender,
110         uint256 value
111     );
112 }
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * https://github.com/ethereum/EIPs/issues/20
119  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is ERC20, BasicToken {
122 
123     mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126     /**
127     * @dev Transfer tokens from one address to another
128     * @param _from address The address which you want to send tokens from
129     * @param _to address The address which you want to transfer to
130     * @param _value uint256 the amount of tokens to be transferred
131     */
132     function transferFrom(
133         address _from,
134         address _to,
135         uint256 _value
136     )
137         public
138         returns (bool)
139     {
140         require(_to != address(0), "Address must not be zero.");
141         require(_value <= balances[_from], "There is no enough balance.");
142         require(_value <= allowed[_from][msg.sender], "There is no enough allowed balance.");
143 
144         balances[_from] = balances[_from].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147         emit Transfer(_from, _to, _value);
148         return true;
149     }
150 
151     /**
152     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153     * Beware that changing an allowance with this method brings the risk that someone may use both the old
154     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157     * @param _spender The address which will spend the funds.
158     * @param _value The amount of tokens to be spent.
159     */
160     function approve(address _spender, uint256 _value) public returns (bool) {
161         allowed[msg.sender][_spender] = _value;
162         emit Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     /**
167     * @dev Function to check the amount of tokens that an owner allowed to a spender.
168     * @param _owner address The address which owns the funds.
169     * @param _spender address The address which will spend the funds.
170     * @return A uint256 specifying the amount of tokens still available for the spender.
171     */
172     function allowance(
173         address _owner,
174         address _spender
175     )
176         public
177         view
178         returns (uint256)
179     {
180         return allowed[_owner][_spender];
181     }
182 
183     /**
184     * @dev Increase the amount of tokens that an owner allowed to a spender.
185     * approve should be called when allowed[_spender] == 0. To increment
186     * allowed value is better to use this function to avoid 2 calls (and wait until
187     * the first transaction is mined)
188     * From MonolithDAO Token.sol
189     * @param _spender The address which will spend the funds.
190     * @param _addedValue The amount of tokens to increase the allowance by.
191     */
192     function increaseApproval(
193         address _spender,
194         uint256 _addedValue
195     )
196         public
197         returns (bool)
198     {
199         allowed[msg.sender][_spender] = (
200         allowed[msg.sender][_spender].add(_addedValue));
201         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 
205     /**
206     * @dev Decrease the amount of tokens that an owner allowed to a spender.
207     * approve should be called when allowed[_spender] == 0. To decrement
208     * allowed value is better to use this function to avoid 2 calls (and wait until
209     * the first transaction is mined)
210     * From MonolithDAO Token.sol
211     * @param _spender The address which will spend the funds.
212     * @param _subtractedValue The amount of tokens to decrease the allowance by.
213     */
214     function decreaseApproval(
215         address _spender,
216         uint256 _subtractedValue
217     )
218         public
219         returns (bool)
220     {
221         uint256 oldValue = allowed[msg.sender][_spender];
222         if (_subtractedValue > oldValue) {
223             allowed[msg.sender][_spender] = 0;
224         } else {
225             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226         }
227         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230 
231 }
232 
233 /**
234  * @title Pausable
235  * @dev Base contract which allows children to implement an emergency stop mechanism.
236  */
237 contract Pausable is Ownable {
238   event Pause();
239   event Unpause();
240 
241   bool public paused = false;
242 
243 
244   /**
245    * @dev Modifier to make a function callable only when the contract is not paused.
246    */
247   modifier whenNotPaused() {
248     require(!paused);
249     _;
250   }
251 
252   /**
253    * @dev Modifier to make a function callable only when the contract is paused.
254    */
255   modifier whenPaused() {
256     require(paused);
257     _;
258   }
259 
260   /**
261    * @dev called by the owner to pause, triggers stopped state
262    */
263   function pause() onlyOwner whenNotPaused public {
264     paused = true;
265     emit Pause();
266   }
267 
268   /**
269    * @dev called by the owner to unpause, returns to normal state
270    */
271   function unpause() onlyOwner whenPaused public {
272     paused = false;
273     emit Unpause();
274   }
275 }
276 
277 contract UpgradedStandardToken is StandardToken{
278     // those methods are called by the legacy contract
279     // and they must ensure msg.sender to be the contract address
280     function transferByLegacy(address from, address to, uint256 value) public returns (bool);
281     function transferFromByLegacy(address sender, address from, address spender, uint256 value) public returns (bool);
282     function approveByLegacy(address from, address spender, uint256 value) public returns (bool);
283 }
284 
285 contract BlackList is Ownable, BasicToken {
286 
287     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
288     function getBlackListStatus(address _maker) external view returns (bool) {
289         return isBlackListed[_maker];
290     }
291 
292     function getOwner() external view returns (address) {
293         return owner;
294     }
295 
296     mapping (address => bool) public isBlackListed;
297     
298     function addBlackList (address _evilUser) public onlyOwner {
299         isBlackListed[_evilUser] = true;
300         emit AddedBlackList(_evilUser);
301     }
302 
303     function removeBlackList (address _clearedUser) public onlyOwner {
304         isBlackListed[_clearedUser] = false;
305         emit RemovedBlackList(_clearedUser);
306     }
307 
308     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
309         require(isBlackListed[_blackListedUser]);
310         uint256 dirtyFunds = balanceOf(_blackListedUser);
311         balances[_blackListedUser] = 0;
312         totalSupply_ -= dirtyFunds;
313         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
314     }
315 
316     event DestroyedBlackFunds(address _blackListedUser, uint256 _balance);
317 
318     event AddedBlackList(address _user);
319 
320     event RemovedBlackList(address _user);
321 
322 }
323 
324 contract AlitaToken is Pausable, StandardToken, BlackList {
325     string public name = "alita";
326     string public symbol = "Alita";
327     uint8 public decimals = 18;
328     uint256 public init_Supply = 1000000000 * 10 ** 18;
329     address public upgradedAddress;
330     bool public deprecated;
331 
332     constructor() public {
333         totalSupply_ = init_Supply;
334         balances[msg.sender] = totalSupply_;
335         deprecated = false;
336     }
337     
338     // Forward ERC20 methods to upgraded contract if this one is deprecated
339     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
340         require(!isBlackListed[msg.sender]);
341         require(!isBlackListed[_to]);
342         if (deprecated) {
343             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
344         } else {
345             return super.transfer(_to, _value);
346         }
347     }
348     
349     // Forward ERC20 methods to upgraded contract if this one is deprecated
350     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
351         require(!isBlackListed[msg.sender]);
352         require(!isBlackListed[_from]);
353         require(!isBlackListed[_to]);
354         if (deprecated) {
355             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
356         } else {
357             return super.transferFrom(_from, _to, _value);
358         }
359     }
360     
361     // Forward ERC20 methods to upgraded contract if this one is deprecated
362     function approve(address _spender, uint256 _value) public returns (bool) {
363         require(!isBlackListed[msg.sender]);
364         require(!isBlackListed[_spender]);
365         if (deprecated) {
366             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
367         } else {
368             return super.approve(_spender, _value);
369         }
370     }
371     
372     // Forward ERC20 methods to upgraded contract if this one is deprecated
373     function allowance(address _owner, address _spender) public view  returns (uint256) {
374         if (deprecated) {
375             return StandardToken(upgradedAddress).allowance(_owner, _spender);
376         } else {
377             return super.allowance(_owner, _spender);
378         }
379     }
380     
381     // Forward ERC20 methods to upgraded contract if this one is deprecated
382     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
383         if (deprecated) {
384             return StandardToken(upgradedAddress).increaseApproval(_spender, _addedValue);
385         } else {
386             return super.increaseApproval(_spender, _addedValue);
387         }
388     }
389     
390     // Forward ERC20 methods to upgraded contract if this one is deprecated
391     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
392         if (deprecated) {
393             return StandardToken(upgradedAddress).increaseApproval(_spender, _subtractedValue);
394         } else {
395             return super.decreaseApproval(_spender, _subtractedValue);
396         }
397     }
398     
399     // deprecate current contract in favour of a new one
400     function deprecate(address _upgradedAddress) public onlyOwner {
401         deprecated = true;
402         upgradedAddress = _upgradedAddress;
403         emit Deprecate(_upgradedAddress);
404     }
405     
406     // Called when contract is deprecated
407     event Deprecate(address newAddress);
408 }
409 
410 /**
411  * @title SafeMath
412  * @dev Math operations with safety checks that throw on error
413  */
414 library SafeMath {
415 
416     /**
417     * @dev Multiplies two numbers, throws on overflow.
418     */
419     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
420         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
421         // benefit is lost if 'b' is also tested.
422         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
423         if (a == 0) {
424             return 0;
425         }
426 
427         c = a * b;
428         assert(c / a == b);
429         return c;
430     }
431 
432     /**
433     * @dev Integer division of two numbers, truncating the quotient.
434     */
435     function div(uint256 a, uint256 b) internal pure returns (uint256) {
436         // assert(b > 0); // Solidity automatically throws when dividing by 0
437         // uint256 c = a / b;
438         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
439         return a / b;
440     }
441 
442     /**
443     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
444     */
445     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
446         assert(b <= a);
447         return a - b;
448     }
449 
450     /**
451     * @dev Adds two numbers, throws on overflow.
452     */
453     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
454         c = a + b;
455         assert(c >= a);
456         return c;
457     }
458 }