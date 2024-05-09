1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18 
19     /**
20     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21     * account.
22     */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28     * @dev Throws if called by any account other than the owner.
29     */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36     * @dev Allows the current owner to transfer control of the contract to a newOwner.
37     * @param _newOwner The address to transfer ownership to.
38     */
39     function transferOwnership(address _newOwner) public onlyOwner {
40         _transferOwnership(_newOwner);
41     }
42 
43     /**
44     * @dev Transfers control of the contract to a newOwner.
45     * @param _newOwner The address to transfer ownership to.
46     */
47     function _transferOwnership(address _newOwner) internal {
48         require(_newOwner != address(0));
49         emit OwnershipTransferred(owner, _newOwner);
50         owner = _newOwner;
51     }
52 }
53 
54 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
55 
56 /**
57  * @title Pausable
58  * @dev Base contract which allows children to implement an emergency stop mechanism.
59  */
60 contract Pausable is Ownable {
61     event Pause();
62     event Unpause();
63 
64     bool public paused = false;
65 
66 
67     /**
68     * @dev Modifier to make a function callable only when the contract is not paused.
69     */
70     modifier whenNotPaused() {
71         require(!paused);
72         _;
73     }
74 
75     /**
76     * @dev Modifier to make a function callable only when the contract is paused.
77     */
78     modifier whenPaused() {
79         require(paused);
80         _;
81     }
82 
83     /**
84     * @dev called by the owner to pause, triggers stopped state
85     */
86     function pause() public onlyOwner whenNotPaused {
87         paused = true;
88         emit Pause();
89     }
90 
91     /**
92     * @dev called by the owner to unpause, returns to normal state
93     */
94     function unpause() public onlyOwner whenPaused {
95         paused = false;
96         emit Unpause();
97     }
98 }
99 
100 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
101 
102 /**
103  * @title Claimable
104  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
105  * This allows the new owner to accept the transfer.
106  */
107 contract Claimable is Ownable {
108     address public pendingOwner;
109 
110     /**
111     * @dev Modifier throws if called by any account other than the pendingOwner.
112     */
113     modifier onlyPendingOwner() {
114         require(msg.sender == pendingOwner);
115         _;
116     }
117 
118     /**
119     * @dev Allows the current owner to set the pendingOwner address.
120     * @param newOwner The address to transfer ownership to.
121     */
122     function transferOwnership(address newOwner) public onlyOwner {
123         pendingOwner = newOwner;
124     }
125 
126     /**
127     * @dev Allows the pendingOwner address to finalize the transfer.
128     */
129     function claimOwnership() public onlyPendingOwner {
130         emit OwnershipTransferred(owner, pendingOwner);
131         owner = pendingOwner;
132         pendingOwner = address(0);
133     }
134 }
135 
136 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
137 
138 pragma solidity ^0.4.24;
139 
140 
141 /**
142  * @title SafeMath
143  * @dev Math operations with safety checks that throw on error
144  */
145 library SafeMath {
146 
147     /**
148     * @dev Multiplies two numbers, throws on overflow.
149     */
150     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
151         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
154         if (_a == 0) {
155             return 0;
156         }
157 
158         c = _a * _b;
159         assert(c / _a == _b);
160         return c;
161     }
162 
163     /**
164     * @dev Integer division of two numbers, truncating the quotient.
165     */
166     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
167         // assert(_b > 0); // Solidity automatically throws when dividing by 0
168         // uint256 c = _a / _b;
169         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
170         return _a / _b;
171     }
172 
173     /**
174     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
175     */
176     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
177         assert(_b <= _a);
178         return _a - _b;
179     }
180 
181     /**
182     * @dev Adds two numbers, throws on overflow.
183     */
184     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
185         c = _a + _b;
186         assert(c >= _a);
187         return c;
188     }
189 }
190 
191 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
192 
193 /**
194  * @title ERC20Basic
195  * @dev Simpler version of ERC20 interface
196  * See https://github.com/ethereum/EIPs/issues/179
197  */
198 contract ERC20Basic {
199     function totalSupply() public view returns (uint256);
200     function balanceOf(address _who) public view returns (uint256);
201     function transfer(address _to, uint256 _value) public returns (bool);
202     event Transfer(address indexed from, address indexed to, uint256 value);
203 }
204 
205 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
206 
207 /**
208  * @title Basic token
209  * @dev Basic version of StandardToken, with no allowances.
210  */
211 contract BasicToken is ERC20Basic {
212     using SafeMath for uint256;
213 
214     mapping(address => uint256) internal balances;
215 
216     uint256 internal totalSupply_;
217 
218     /**
219     * @dev Total number of tokens in existence
220     */
221     function totalSupply() public view returns (uint256) {
222         return totalSupply_;
223     }
224 
225     /**
226     * @dev Transfer token for a specified address
227     * @param _to The address to transfer to.
228     * @param _value The amount to be transferred.
229     */
230     function transfer(address _to, uint256 _value) public returns (bool) {
231         require(_value <= balances[msg.sender]);
232         require(_to != address(0));
233 
234         balances[msg.sender] = balances[msg.sender].sub(_value);
235         balances[_to] = balances[_to].add(_value);
236         emit Transfer(msg.sender, _to, _value);
237         return true;
238     }
239 
240     /**
241     * @dev Gets the balance of the specified address.
242     * @param _owner The address to query the the balance of.
243     * @return An uint256 representing the amount owned by the passed address.
244     */
245     function balanceOf(address _owner) public view returns (uint256) {
246         return balances[_owner];
247     }
248 
249 }
250 
251 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
252 
253 /**
254  * @title ERC20 interface
255  * @dev see https://github.com/ethereum/EIPs/issues/20
256  */
257 contract ERC20 is ERC20Basic {
258     function allowance(address _owner, address _spender) public view returns (uint256);
259     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
260     function approve(address _spender, uint256 _value) public returns (bool);
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
265 
266 /**
267  * @title Standard ERC20 token
268  *
269  * @dev Implementation of the basic standard token.
270  * https://github.com/ethereum/EIPs/issues/20
271  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
272  */
273 contract StandardToken is ERC20, BasicToken {
274 
275     mapping (address => mapping (address => uint256)) internal allowed;
276 
277 
278     /**
279     * @dev Transfer tokens from one address to another
280     * @param _from address The address which you want to send tokens from
281     * @param _to address The address which you want to transfer to
282     * @param _value uint256 the amount of tokens to be transferred
283     */
284     function transferFrom(
285         address _from,
286         address _to,
287         uint256 _value
288     )
289         public
290         returns (bool)
291     {
292         require(_value <= balances[_from]);
293         require(_value <= allowed[_from][msg.sender]);
294         require(_to != address(0));
295 
296         balances[_from] = balances[_from].sub(_value);
297         balances[_to] = balances[_to].add(_value);
298         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
299         emit Transfer(_from, _to, _value);
300         return true;
301     }
302 
303     /**
304     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
305     * Beware that changing an allowance with this method brings the risk that someone may use both the old
306     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
307     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
308     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
309     * @param _spender The address which will spend the funds.
310     * @param _value The amount of tokens to be spent.
311     */
312     function approve(address _spender, uint256 _value) public returns (bool) {
313         allowed[msg.sender][_spender] = _value;
314         emit Approval(msg.sender, _spender, _value);
315         return true;
316     }
317 
318     /**
319     * @dev Function to check the amount of tokens that an owner allowed to a spender.
320     * @param _owner address The address which owns the funds.
321     * @param _spender address The address which will spend the funds.
322     * @return A uint256 specifying the amount of tokens still available for the spender.
323     */
324     function allowance(
325         address _owner,
326         address _spender
327     )
328         public
329         view
330         returns (uint256)
331     {
332         return allowed[_owner][_spender];
333     }
334 
335     /**
336     * @dev Increase the amount of tokens that an owner allowed to a spender.
337     * approve should be called when allowed[_spender] == 0. To increment
338     * allowed value is better to use this function to avoid 2 calls (and wait until
339     * the first transaction is mined)
340     * From MonolithDAO Token.sol
341     * @param _spender The address which will spend the funds.
342     * @param _addedValue The amount of tokens to increase the allowance by.
343     */
344     function increaseApproval(
345         address _spender,
346         uint256 _addedValue
347     )
348         public
349         returns (bool)
350     {
351         allowed[msg.sender][_spender] = (
352         allowed[msg.sender][_spender].add(_addedValue));
353         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
354         return true;
355     }
356 
357     /**
358     * @dev Decrease the amount of tokens that an owner allowed to a spender.
359     * approve should be called when allowed[_spender] == 0. To decrement
360     * allowed value is better to use this function to avoid 2 calls (and wait until
361     * the first transaction is mined)
362     * From MonolithDAO Token.sol
363     * @param _spender The address which will spend the funds.
364     * @param _subtractedValue The amount of tokens to decrease the allowance by.
365     */
366     function decreaseApproval(
367         address _spender,
368         uint256 _subtractedValue
369     )
370         public
371         returns (bool)
372     {
373         uint256 oldValue = allowed[msg.sender][_spender];
374         if (_subtractedValue >= oldValue) {
375             allowed[msg.sender][_spender] = 0;
376         } else {
377             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
378         }
379         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
380         return true;
381     }
382 
383 }
384 
385 
386 // File: contracts/LucisDollar.sol
387 
388 contract LucisDollar is StandardToken, Pausable, Claimable {
389     string public constant name = "Lucis Dollar";
390     string public constant symbol = "LUCD";
391     uint8  public constant decimals = 4;
392     address public distributor;
393 
394     modifier validDestination(address to) {
395         require(to != address(this));
396         _;
397     }
398 
399     modifier isTradeable() {
400         require(
401             !paused || msg.sender == owner || msg.sender == distributor
402         );
403         _;
404     }
405 
406     constructor() public {
407         totalSupply_ = 25000000 * (10 ** uint256(decimals)); // 25 million
408         balances[msg.sender] = totalSupply_;
409         emit Transfer(address(0x0), msg.sender, totalSupply_);
410     }
411 
412     // ERC20 Methods
413 
414     function transfer(address to, uint256 value) public validDestination(to) isTradeable returns (bool) {
415         return super.transfer(to, value);
416     }
417 
418     function transferFrom(address from, address to, uint256 value) public validDestination(to) isTradeable returns (bool) {
419         return super.transferFrom(from, to, value);
420     }
421 
422     function approve(address spender, uint256 value) public isTradeable returns (bool) {
423         return super.approve(spender, value);
424     }
425 
426     function increaseApproval(address spender, uint addedValue) public isTradeable returns (bool) {
427         return super.increaseApproval(spender, addedValue);
428     }
429 
430     function decreaseApproval(address spender, uint subtractedValue) public isTradeable returns (bool) {
431         return super.decreaseApproval(spender, subtractedValue);
432     }
433 
434     //CORP Distributor
435     function setDistributor(address newDistributor) external onlyOwner {
436         distributor = newDistributor;
437     }
438     // Token Drain
439     function emergencyERC20Drain(ERC20 token, uint256 amount) external onlyOwner {
440         token.transfer(owner, amount);
441     }
442 
443     /**
444         * @dev Distribute tokens to multiple addresses in a single transaction
445         *
446         * @param addresses A list of addresses to distribute to
447         * @param values A corresponding list of amounts to distribute to each address
448         */
449     function batchTransfer(address[] addresses, uint[] values) onlyOwner external {
450         require(addresses.length == values.length);
451         for(uint i = 0; i < addresses.length; i++) {
452             if(values[i] > 0) {
453                 transfer(addresses[i], values[i]);
454             }
455         }
456     }
457 
458 }