1 pragma solidity ^0.5.1;
2 
3 library IterableMapping {
4     struct itmap {
5         mapping(address => IndexValue) data;
6         KeyFlag[] keys;
7         uint256 size;
8     }
9     struct IndexValue {
10         uint256 keyIndex;
11         uint256 value;
12     }
13     struct KeyFlag {
14         address key;
15         bool deleted;
16     }
17     function insert(itmap storage self, address key, uint256 value)
18         public
19         returns (bool replaced)
20     {
21         uint256 keyIndex = self.data[key].keyIndex;
22         self.data[key].value = value;
23         if (keyIndex > 0) return true;
24         else {
25             keyIndex = self.keys.length++;
26             self.data[key].keyIndex = keyIndex + 1;
27             self.keys[keyIndex].key = key;
28             self.size++;
29             return false;
30         }
31     }
32     function iterate_start(itmap storage self)
33         public
34         view
35         returns (uint256 keyIndex)
36     {
37         return iterate_next(self, uint256(-1));
38     }
39     function iterate_valid(itmap storage self, uint256 keyIndex)
40         public
41         view
42         returns (bool)
43     {
44         return keyIndex < self.keys.length;
45     }
46     function iterate_next(itmap storage self, uint256 keyIndex)
47         public
48         view
49         returns (uint256)
50     {
51         uint256 _tmpKeyIndex = keyIndex;
52         _tmpKeyIndex++;
53         while (
54             _tmpKeyIndex < self.keys.length && self.keys[_tmpKeyIndex].deleted
55         ) _tmpKeyIndex++;
56         return _tmpKeyIndex;
57     }
58     function iterate_get(itmap storage self, uint256 keyIndex)
59         public
60         view
61         returns (address key, uint256 value)
62     {
63         key = self.keys[keyIndex].key;
64         value = self.data[key].value;
65     }
66     function iterate_getValue(itmap storage self, address key)
67         public
68         view
69         returns (uint256 value)
70     {
71         return self.data[key].value;
72     }
73 }
74 
75 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
76 
77 /**
78  * @title Ownable
79  * @dev The Ownable contract has an owner address, and provides basic authorization control
80  * functions, this simplifies the implementation of "user permissions".
81  */
82 contract Ownable {
83     address public owner;
84 
85     event OwnershipTransferred(
86         address indexed previousOwner,
87         address indexed newOwner
88     );
89 
90     /**
91    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92    * account.
93    */
94     constructor() public {
95         owner = msg.sender;
96     }
97 
98     /**
99    * @dev Throws if called by any account other than the owner.
100    */
101     modifier onlyOwner() {
102         require(
103             msg.sender == owner,
104             "called by any account other than the owner"
105         );
106         _;
107     }
108 
109     /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param newOwner The address to transfer ownership to.
112    */
113     function transferOwnership(address newOwner) public onlyOwner {
114         require(newOwner != address(0), "owner address should not 0");
115         emit OwnershipTransferred(owner, newOwner);
116         owner = newOwner;
117     }
118 
119 }
120 
121 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
122 
123 /**
124  * @title Pausable
125  * @dev Base contract which allows children to implement an emergency stop mechanism.
126  */
127 contract Pausable is Ownable {
128     event Pause();
129     event Unpause();
130 
131     bool public paused = false;
132 
133     /**
134    * @dev Modifier to make a function callable only when the contract is not paused.
135    */
136     modifier whenNotPaused() {
137         require(!paused, "callable when the contract is not paused");
138         _;
139     }
140 
141     /**
142    * @dev Modifier to make a function callable only when the contract is paused.
143    */
144     modifier whenPaused() {
145         require(paused, "callable when the contract is paused");
146         _;
147     }
148 
149     /**
150    * @dev called by the owner to pause, triggers stopped state
151    */
152     function pause() public onlyOwner whenNotPaused {
153         paused = true;
154         emit Pause();
155     }
156 
157     /**
158    * @dev called by the owner to unpause, returns to normal state
159    */
160     function unpause() public onlyOwner whenPaused {
161         paused = false;
162         emit Unpause();
163     }
164 }
165 
166 /**
167  * @title SafeMath
168  * @dev Math operations with safety checks that throw on error
169  */
170 library SafeMath {
171     /**
172   * @dev Multiplies two numbers, throws on overflow.
173   */
174     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
175         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
178         if (_a == 0) {
179             return 0;
180         }
181 
182         c = _a * _b;
183         assert(c / _a == _b);
184         return c;
185     }
186 
187     /**
188   * @dev Integer division of two numbers, truncating the quotient.
189   */
190     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
191         assert(_b > 0); // Solidity automatically throws when dividing by 0
192         uint256 c = _a / _b;
193         assert(_a == _b * c + (_a % _b)); // There is no case in which this doesn't hold
194         return _a / _b;
195     }
196 
197     /**
198   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
199   */
200     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
201         assert(_b <= _a);
202         return _a - _b;
203     }
204 
205     /**
206   * @dev Adds two numbers, throws on overflow.
207   */
208     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
209         c = _a + _b;
210         assert(c >= _a);
211         return c;
212     }
213 }
214 
215 /**
216  * @title ERC20Basic
217  * @dev Simpler version of ERC20 interface
218  * See https://github.com/ethereum/EIPs/issues/179
219  */
220 contract ERC20Basic {
221     function totalSupply() public view returns (uint256);
222     function balanceOf(address _who) public view returns (uint256);
223     function transfer(address _to, uint256 _value) public returns (bool);
224     event Transfer(address indexed from, address indexed to, uint256 value);
225 }
226 
227 /**
228  * @title Basic token
229  * @dev Basic version of StandardToken, with no allowances.
230  */
231 contract BasicToken is ERC20Basic {
232     using SafeMath for uint256;
233     IterableMapping.itmap balances;
234 
235     uint256 internal totalSupply_;
236 
237     /**
238   * @dev Total number of tokens in existence
239   */
240     function totalSupply() public view returns (uint256) {
241         return totalSupply_;
242     }
243 
244     /**
245   * @dev Transfer token for a specified address
246   * @param _to The address to transfer to.
247   * @param _value The amount to be transferred.
248   */
249     function transfer(address _to, uint256 _value) public returns (bool) {
250         require(
251             _value <= IterableMapping.iterate_getValue(balances, msg.sender),
252             "not enough balances"
253         );
254         require(_to != address(0), "0 address not allow");
255 
256         IterableMapping.insert(
257             balances,
258             msg.sender,
259             IterableMapping.iterate_getValue(balances, msg.sender).sub(_value)
260         );
261         IterableMapping.insert(
262             balances,
263             _to,
264             IterableMapping.iterate_getValue(balances, _to).add(_value)
265         );
266         emit Transfer(msg.sender, _to, _value);
267         return true;
268     }
269 
270     /**
271   * @dev Gets the balance of the specified address.
272   * @param _owner The address to query the the balance of.
273   * @return An uint256 representing the amount owned by the passed address.
274   */
275     function balanceOf(address _owner) public view returns (uint256) {
276         return IterableMapping.iterate_getValue(balances, _owner);
277     }
278 
279 }
280 
281 /**
282  * @title ERC20 interface
283  * @dev see https://github.com/ethereum/EIPs/issues/20
284  */
285 contract ERC20 is ERC20Basic {
286     function allowance(address _owner, address _spender)
287         public
288         view
289         returns (uint256);
290 
291     function transferFrom(address _from, address _to, uint256 _value)
292         public
293         returns (bool);
294 
295     function approve(address _spender, uint256 _value) public returns (bool);
296     event Approval(
297         address indexed owner,
298         address indexed spender,
299         uint256 value
300     );
301 }
302 
303 /**
304  * @title Standard ERC20 token
305  *
306  * @dev Implementation of the basic standard token.
307  * https://github.com/ethereum/EIPs/issues/20
308  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
309  */
310 contract StandardToken is ERC20, BasicToken {
311     mapping(address => mapping(address => uint256)) internal allowed;
312 
313     /**
314    * @dev Transfer tokens from one address to another
315    * @param _from address The address which you want to send tokens from
316    * @param _to address The address which you want to transfer to
317    * @param _value uint256 the amount of tokens to be transferred
318    */
319     function transferFrom(address _from, address _to, uint256 _value)
320         public
321         returns (bool)
322     {
323         require(
324             _value <= IterableMapping.iterate_getValue(balances, _from),
325             "balance not enough"
326         );
327         require(_value <= allowed[_from][msg.sender], "balance not enough");
328         require(_to != address(0), "0 address not allow");
329 
330         IterableMapping.insert(
331             balances,
332             _from,
333             IterableMapping.iterate_getValue(balances, _from).sub(_value)
334         );
335         IterableMapping.insert(
336             balances,
337             _to,
338             IterableMapping.iterate_getValue(balances, _to).add(_value)
339         );
340         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
341         emit Transfer(_from, _to, _value);
342         return true;
343     }
344 
345     /**
346    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
347    * Beware that changing an allowance with this method brings the risk that someone may use both the old
348    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
349    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
350    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
351    * @param _spender The address which will spend the funds.
352    * @param _value The amount of tokens to be spent.
353    */
354     function approve(address _spender, uint256 _value) public returns (bool) {
355         allowed[msg.sender][_spender] = _value;
356         emit Approval(msg.sender, _spender, _value);
357         return true;
358     }
359 
360     /**
361    * @dev Function to check the amount of tokens that an owner allowed to a spender.
362    * @param _owner address The address which owns the funds.
363    * @param _spender address The address which will spend the funds.
364    * @return A uint256 specifying the amount of tokens still available for the spender.
365    */
366     function allowance(address _owner, address _spender)
367         public
368         view
369         returns (uint256)
370     {
371         return allowed[_owner][_spender];
372     }
373 
374     /**
375    * @dev Increase the amount of tokens that an owner allowed to a spender.
376    * approve should be called when allowed[_spender] == 0. To increment
377    * allowed value is better to use this function to avoid 2 calls (and wait until
378    * the first transaction is mined)
379    * From MonolithDAO Token.sol
380    * @param _spender The address which will spend the funds.
381    * @param _addedValue The amount of tokens to increase the allowance by.
382    */
383     function increaseApproval(address _spender, uint256 _addedValue)
384         public
385         returns (bool)
386     {
387         allowed[msg.sender][_spender] = (
388             allowed[msg.sender][_spender].add(_addedValue)
389         );
390         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
391         return true;
392     }
393 
394     /**
395    * @dev Decrease the amount of tokens that an owner allowed to a spender.
396    * approve should be called when allowed[_spender] == 0. To decrement
397    * allowed value is better to use this function to avoid 2 calls (and wait until
398    * the first transaction is mined)
399    * From MonolithDAO Token.sol
400    * @param _spender The address which will spend the funds.
401    * @param _subtractedValue The amount of tokens to decrease the allowance by.
402    */
403     function decreaseApproval(address _spender, uint256 _subtractedValue)
404         public
405         returns (bool)
406     {
407         uint256 oldValue = allowed[msg.sender][_spender];
408         if (_subtractedValue >= oldValue) {
409             allowed[msg.sender][_spender] = 0;
410         } else {
411             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
412         }
413         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
414         return true;
415     }
416 
417 }
418 
419 /**
420  * @title Pausable token
421  *
422  * @dev StandardToken modified with pausable transfers.
423  **/
424 
425 contract PausableToken is StandardToken, Pausable {
426     function transfer(address _to, uint256 _value)
427         public
428         whenNotPaused
429         returns (bool)
430     {
431         return super.transfer(_to, _value);
432     }
433 
434     function transferFrom(address _from, address _to, uint256 _value)
435         public
436         whenNotPaused
437         returns (bool)
438     {
439         return super.transferFrom(_from, _to, _value);
440     }
441 
442     function approve(address _spender, uint256 _value)
443         public
444         whenNotPaused
445         returns (bool)
446     {
447         return super.approve(_spender, _value);
448     }
449 
450     function increaseApproval(address _spender, uint256 _addedValue)
451         public
452         whenNotPaused
453         returns (bool success)
454     {
455         return super.increaseApproval(_spender, _addedValue);
456     }
457 
458     function decreaseApproval(address _spender, uint256 _subtractedValue)
459         public
460         whenNotPaused
461         returns (bool success)
462     {
463         return super.decreaseApproval(_spender, _subtractedValue);
464     }
465 }
466 
467 contract Seele is PausableToken {
468     string public name = "Seele Token";
469     string public symbol = "Seele";
470     uint8 public decimals = 18;
471     uint256 public INITIAL_SUPPLY = 30000000000 ether;
472 
473     constructor() public {
474         totalSupply_ = INITIAL_SUPPLY;
475         IterableMapping.insert(balances, msg.sender, INITIAL_SUPPLY);
476     }
477 
478     function balancesStart() public view returns (uint256) {
479         return IterableMapping.iterate_start(balances);
480     }
481 
482     function balancesGetBool(uint256 num) public view returns (bool) {
483         return IterableMapping.iterate_valid(balances, num);
484     }
485 
486     function balancesGetNext(uint256 num) public view returns (uint256) {
487         return IterableMapping.iterate_next(balances, num);
488     }
489     function balancesGetValue(uint256 num)
490         public
491         view
492         returns (address, uint256)
493     {
494         address key;
495         uint256 value;
496         (key, value) = IterableMapping.iterate_get(balances, num);
497         return (key, value);
498     }
499 }