1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      */
11     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
12         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (_a == 0) {
16             return 0;
17         }
18 
19         c = _a * _b;
20         assert(c / _a == _b);
21         return c;
22     }
23 
24     /**
25      * @dev Integer division of two numbers, truncating the quotient.
26      */
27     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
28         // assert(_b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = _a / _b;
30         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
31         return _a / _b;
32     }
33 
34     /**
35      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36      */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43      * @dev Adds two numbers, throws on overflow.
44      */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipRenounced(address indexed previousOwner);
61     event OwnershipTransferred(
62         address indexed previousOwner,
63         address indexed newOwner
64     );
65 
66     /**
67      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68      * account.
69      */
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     /**
83      * @dev Allows the current owner to transfer control of the contract to a newOwner.
84      * @param _newOwner The address to transfer ownership to.
85      */
86     function transferOwnership(address _newOwner) public onlyOwner {
87         _transferOwnership(_newOwner);
88     }
89 
90     /**
91      * @dev Transfers control of the contract to a newOwner.
92      * @param _newOwner The address to transfer ownership to.
93      */
94     function _transferOwnership(address _newOwner) internal {
95         require(_newOwner != address(0));
96         emit OwnershipTransferred(owner, _newOwner);
97         owner = _newOwner;
98     }
99 }
100 
101 /**
102  * @title Pausable
103  * @dev Base contract which allows children to implement an emergency stop mechanism.
104  */
105 contract Pausable is Ownable {
106     event Pause();
107     event Unpause();
108 
109     bool public paused = false;
110 
111     /**
112      * @dev Modifier to make a function callable only when the contract is not paused.
113      */
114     modifier whenNotPaused() {
115         require(!paused);
116         _;
117     }
118 
119     /**
120      * @dev Modifier to make a function callable only when the contract is paused.
121      */
122     modifier whenPaused() {
123         require(paused);
124         _;
125     }
126 
127     /**
128      * @dev called by the owner to pause, triggers stopped state
129      */
130     function pause() public onlyOwner whenNotPaused {
131         paused = true;
132         emit Pause();
133     }
134 
135     /**
136      * @dev called by the owner to unpauseunpause, returns to normal state
137      */
138     function unpause() public onlyOwner whenPaused {
139         paused = false;
140         emit Unpause();
141     }
142 }
143 
144 /**
145  * @title ERC20Basic
146  * @dev Simpler version of ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/179
148  */
149 contract ERC20Basic {
150     function totalSupply() public view returns (uint256);
151 
152     function balanceOf(address who) public view returns (uint256);
153 
154     function transfer(address to, uint256 value) public returns (bool);
155 
156     event Transfer(address indexed from, address indexed to, uint256 value);
157 }
158 
159 /**
160  * @title ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/20
162  */
163 contract ERC20 is ERC20Basic {
164     function allowance(address owner, address spender)
165         public
166         view
167         returns (uint256);
168 
169     function transferFrom(
170         address from,
171         address to,
172         uint256 value
173     ) public returns (bool);
174 
175     function approve(address spender, uint256 value) public returns (bool);
176 
177     event Approval(
178         address indexed owner,
179         address indexed spender,
180         uint256 value
181     );
182 }
183 
184 /**
185  * @title Basic token
186  * @dev Basic version of StandardToken, with no allowances.
187  */
188 contract BasicToken is ERC20Basic {
189     using SafeMath for uint256;
190 
191     mapping(address => uint256) balances;
192 
193     uint256 totalSupply_;
194 
195     /**
196      * @dev total number of tokens in existence
197      */
198     function totalSupply() public view returns (uint256) {
199         return totalSupply_;
200     }
201 
202     /**
203      * @dev transfer token for a specified address
204      * @param _to The address to transfer to.
205      * @param _value The amount to be transferred.
206      */
207     function transfer(address _to, uint256 _value) public returns (bool) {
208         require(_to != address(0));
209         require(_value <= balances[msg.sender]);
210 
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         emit Transfer(msg.sender, _to, _value);
214         return true;
215     }
216 
217     /**
218      * @dev transfer token for a specified address
219      * @param _to The address to transfer to.
220      * @param _value The amount to be transferred.
221      */
222     function transferFrom(
223         address _from,
224         address _to,
225         uint256 _value
226     ) public returns (bool) {
227         require(_to != address(0));
228         require(_value <= balances[_from]);
229 
230         balances[_from] = balances[_from].sub(_value);
231         balances[_to] = balances[_to].add(_value);
232         emit Transfer(_from, _to, _value);
233         return true;
234     }
235 
236     /**
237      * @dev Gets the balance of the specified address.
238      * @param _owner The address to query the the balance of.
239      * @return An uint256 representing the amount owned by the passed address.
240      */
241     function balanceOf(address _owner) public view returns (uint256) {
242         return balances[_owner];
243     }
244 }
245 
246 /**
247  * @title Standard ERC20 token
248  * @dev Implementation of the basic standard token.
249  * @dev https://github.com/ethereum/EIPs/issues/20
250  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
251  */
252 contract StandardToken is ERC20, BasicToken {
253     mapping(address => mapping(address => uint256)) internal allowed;
254 
255     /**
256      * @dev Transfer tokens from one address to another
257      * @param _from address The address which you want to send tokens from
258      * @param _to address The address which you want to transfer to
259      * @param _value uint256 the amount of tokens to be transferred
260      */
261     function transferFrom(
262         address _from,
263         address _to,
264         uint256 _value
265     ) public returns (bool) {
266         require(_to != address(0));
267         require(_value <= balances[_from]);
268         require(_value <= allowed[_from][msg.sender]);
269 
270         balances[_from] = balances[_from].sub(_value);
271         balances[_to] = balances[_to].add(_value);
272         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
273         emit Transfer(_from, _to, _value);
274         return true;
275     }
276 
277     /**
278      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
279      *
280      * Beware that changing an allowance with this method brings the risk that someone may use both the old
281      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
282      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
283      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284      * @param _spender The address which will spend the funds.
285      * @param _value The amount of tokens to be spent.
286      */
287     function approve(address _spender, uint256 _value) public returns (bool) {
288         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
289         allowed[msg.sender][_spender] = _value;
290         emit Approval(msg.sender, _spender, _value);
291         return true;
292     }
293 
294     /**
295      * @dev Function to check the amount of tokens that an owner allowed to a spender.
296      * @param _owner address The address which owns the funds.
297      * @param _spender address The address which will spend the funds.
298      * @return A uint256 specifying the amount of tokens still available for the spender.
299      */
300     function allowance(address _owner, address _spender)
301         public
302         view
303         returns (uint256)
304     {
305         return allowed[_owner][_spender];
306     }
307 
308     /**
309      * @dev Increase the amount of tokens that an owner allowed to a spender.
310      *
311      * approve should be called when allowed[_spender] == 0. To increment
312      * allowed value is better to use this function to avoid 2 calls (and wait until
313      * the first transaction is mined)
314      * From MonolithDAO Token.sol
315      * @param _spender The address which will spend the funds.
316      * @param _addedValue The amount of tokens to increase the allowance by.
317      */
318     function increaseApproval(address _spender, uint256 _addedValue)
319         public
320         returns (bool)
321     {
322         allowed[msg.sender][_spender] = (
323             allowed[msg.sender][_spender].add(_addedValue)
324         );
325         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326         return true;
327     }
328 
329     /**
330      * @dev Decrease the amount of tokens that an owner allowed to a spender.
331      *
332      * approve should be called when allowed[_spender] == 0. To decrement
333      * allowed value is better to use this function to avoid 2 calls (and wait until
334      * the first transaction is mined)
335      * From MonolithDAO Token.sol
336      * @param _spender The address which will spend the funds.
337      * @param _subtractedValue The amount of tokens to decrease the allowance by.
338      */
339     function decreaseApproval(address _spender, uint256 _subtractedValue)
340         public
341         returns (bool)
342     {
343         uint256 oldValue = allowed[msg.sender][_spender];
344         if (_subtractedValue > oldValue) {
345             allowed[msg.sender][_spender] = 0;
346         } else {
347             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348         }
349         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350         return true;
351     }
352 }
353 
354 /**
355  * @title Pausable token
356  * @dev StandardToken modified with pausable transfers.
357  **/
358 contract PausableToken is StandardToken, Pausable {
359     function transfer(address _to, uint256 _value)
360         public
361         whenNotPaused
362         returns (bool)
363     {
364         return super.transfer(_to, _value);
365     }
366 
367     function transferFrom(
368         address _from,
369         address _to,
370         uint256 _value
371     ) public whenNotPaused returns (bool) {
372         return super.transferFrom(_from, _to, _value);
373     }
374 
375     function approve(address _spender, uint256 _value)
376         public
377         whenNotPaused
378         returns (bool)
379     {
380         return super.approve(_spender, _value);
381     }
382 
383     function increaseApproval(address _spender, uint256 _addedValue)
384         public
385         whenNotPaused
386         returns (bool success)
387     {
388         return super.increaseApproval(_spender, _addedValue);
389     }
390 
391     function decreaseApproval(address _spender, uint256 _subtractedValue)
392         public
393         whenNotPaused
394         returns (bool success)
395     {
396         return super.decreaseApproval(_spender, _subtractedValue);
397     }
398 }
399 
400 /**
401  * @title Frozenable Token
402  * @dev Illegal address that can be frozened.
403  */
404 contract FrozenableToken is Ownable {
405     mapping(address => bool) public frozenAccount;
406 
407     event FrozenFunds(address indexed to, bool frozen);
408 
409     modifier whenNotFrozen(address _who) {
410         require(!frozenAccount[msg.sender] && !frozenAccount[_who]);
411         _;
412     }
413 
414     function freezeAccount(address _to, bool _freeze) public onlyOwner {
415         require(_to != address(0));
416         frozenAccount[_to] = _freeze;
417         emit FrozenFunds(_to, _freeze);
418     }
419 }
420 
421 /**
422  * @title HS Token
423  * @dev HS digital painting asset platform token.
424  * @author HS.org
425  */
426 contract TLGToken is PausableToken, FrozenableToken {
427     string public name = "TLG";
428     string public symbol = "TLG";
429     uint256 public decimals = 18;
430     uint256 INITIAL_SUPPLY = 15000000 * (10**uint256(decimals));
431 
432     // owner address
433     address private _ownerAddress; // initial, Owner address
434 
435     /**
436      * @dev Initializes the total release
437      */
438     constructor() public {
439         totalSupply_ = INITIAL_SUPPLY;
440         _ownerAddress = msg.sender;
441         balances[msg.sender] = totalSupply_;
442         emit Transfer(address(0), msg.sender, totalSupply_);
443     }
444 
445     /**
446      * if ether is sent to this address, send it back.
447      */
448     function() public payable {
449         revert();
450     }
451 
452     /**
453      * @dev transfer token for a specified address
454      * @param _to The address to transfer to.
455      * @param _value The amount to be transferred.
456      */
457     function transfer(address _to, uint256 _value)
458         public
459         whenNotFrozen(_to)
460         returns (bool)
461     {
462         return super.transfer(_to, _value);
463     }
464 
465     /**
466      * @dev Transfer tokens from one address to another
467      * @param _from address The address which you want to send tokens from
468      * @param _to address The address which you want to transfer to
469      * @param _value uint256 the amount of tokens to be transferred
470      */
471     function transferFrom(
472         address _from,
473         address _to,
474         uint256 _value
475     ) public whenNotFrozen(_from) returns (bool) {
476         return super.transferFrom(_from, _to, _value);
477     }
478 }