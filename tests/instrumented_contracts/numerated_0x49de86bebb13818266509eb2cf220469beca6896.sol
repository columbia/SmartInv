1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63      * account.
64      */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96     function totalSupply() public view returns (uint256);
97     function balanceOf(address who) public view returns (uint256);
98     function transfer(address to, uint256 value) public returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108     using SafeMath for uint256;
109 
110     mapping(address => uint256) balances;
111 
112     uint256 totalSupply_;
113 
114     /**
115     * @dev total number of tokens in existence
116     */
117     function totalSupply() public view returns (uint256) {
118         return totalSupply_;
119     }
120 
121     /**
122     * @dev transfer token for a specified address
123     * @param _to The address to transfer to.
124     * @param _value The amount to be transferred.
125     */
126     function transfer(address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[msg.sender]);
129 
130         // SafeMath.sub will throw if there is not enough balance.
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         Transfer(msg.sender, _to, _value);
134         return true;
135     }
136 
137     /**
138     * @dev Gets the balance of the specified address.
139     * @param _owner The address to query the the balance of.
140     * @return An uint256 representing the amount owned by the passed address.
141     */
142     function balanceOf(address _owner) public view returns (uint256 balance) {
143         return balances[_owner];
144     }
145 
146 }
147 
148 
149 /**
150  * @title Burnable Token
151  * @dev Token that can be irreversibly burned (destroyed).
152  */
153 contract BurnableToken is BasicToken {
154 
155     event Burn(address indexed burner, uint256 value);
156 
157     /**
158      * @dev Burns a specific amount of tokens.
159      * @param _value The amount of token to be burned.
160      */
161     function burn(uint256 _value) public {
162         require(_value <= balances[msg.sender]);
163         // no need to require value <= totalSupply, since that would imply the
164         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
165 
166         address burner = msg.sender;
167         balances[burner] = balances[burner].sub(_value);
168         totalSupply_ = totalSupply_.sub(_value);
169         Burn(burner, _value);
170     }
171 }
172 
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179     function allowance(address owner, address spender) public view returns (uint256);
180     function transferFrom(address from, address to, uint256 value) public returns (bool);
181     function approve(address spender, uint256 value) public returns (bool);
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195     mapping (address => mapping (address => uint256)) internal allowed;
196 
197     /**
198      * @dev Transfer tokens from one address to another
199      * @param _from address The address which you want to send tokens from
200      * @param _to address The address which you want to transfer to
201      * @param _value uint256 the amount of tokens to be transferred
202      */
203     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204         require(_to != address(0));
205         require(_value <= balances[_from]);
206         require(_value <= allowed[_from][msg.sender]);
207        
208         
209         balances[_from] = balances[_from].sub(_value);
210         balances[_to] = balances[_to].add(_value);
211         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212         Transfer(_from, _to, _value);
213         return true;
214     }
215 
216     /**
217      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218      *
219      * Beware that changing an allowance with this method brings the risk that someone may use both the old
220      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      * @param _spender The address which will spend the funds.
224      * @param _value The amount of tokens to be spent.
225      */
226     function approve(address _spender, uint256 _value) public returns (bool) {
227         allowed[msg.sender][_spender] = _value;
228         Approval(msg.sender, _spender, _value);
229         return true;
230     }
231 
232     /**
233      * @dev Function to check the amount of tokens that an owner allowed to a spender.
234      * @param _owner address The address which owns the funds.
235      * @param _spender address The address which will spend the funds.
236      * @return A uint256 specifying the amount of tokens still available for the spender.
237      */
238     function allowance(address _owner, address _spender) public view returns (uint256) {
239         return allowed[_owner][_spender];
240     }
241 
242     /**
243      * @dev Increase the amount of tokens that an owner allowed to a spender.
244      *
245      * approve should be called when allowed[_spender] == 0. To increment
246      * allowed value is better to use this function to avoid 2 calls (and wait until
247      * the first transaction is mined)
248      * From MonolithDAO Token.sol
249      * @param _spender The address which will spend the funds.
250      * @param _addedValue The amount of tokens to increase the allowance by.
251      */
252     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
253         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 
258     /**
259      * @dev Decrease the amount of tokens that an owner allowed to a spender.
260      *
261      * approve should be called when allowed[_spender] == 0. To decrement
262      * allowed value is better to use this function to avoid 2 calls (and wait until
263      * the first transaction is mined)
264      * From MonolithDAO Token.sol
265      * @param _spender The address which will spend the funds.
266      * @param _subtractedValue The amount of tokens to decrease the allowance by.
267      */
268     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
269         uint oldValue = allowed[msg.sender][_spender];
270         if (_subtractedValue > oldValue) {
271             allowed[msg.sender][_spender] = 0;
272         } else {
273             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274         }
275         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276         return true;
277     }
278 
279 }
280 
281 
282 /**
283  * @title Pausable
284  * @dev Base contract which allows children to implement an emergency stop mechanism.
285  */
286 contract Pausable is Ownable {
287     event Pause();
288     event Unpause();
289 
290     address public distributionContract;
291 
292     bool distributionContractAdded;
293     bool public paused = false;
294 
295     /**
296      * @dev Add distribution smart contract address
297     */
298     function addDistributionContract(address _contract) external {
299         require(_contract != address(0));
300         require(distributionContractAdded == false);
301 
302         distributionContract = _contract;
303         distributionContractAdded = true;
304     }
305 
306     /**
307      * @dev Modifier to make a function callable only when the contract is not paused.
308      */
309     modifier whenNotPaused() {
310         if(msg.sender != distributionContract) {
311             require(!paused);
312         }
313         _;
314     }
315 
316     /**
317      * @dev Modifier to make a function callable only when the contract is paused.
318      */
319     modifier whenPaused() {
320         require(paused);
321         _;
322     }
323 
324     /**
325      * @dev called by the owner to pause, triggers stopped state
326      */
327     function pause() onlyOwner whenNotPaused public {
328         paused = true;
329         Pause();
330     }
331 
332     /**
333      * @dev called by the owner to unpause, returns to normal state
334      */
335     function unpause() onlyOwner whenPaused public {
336         paused = false;
337         Unpause();
338     }
339 }
340 
341 
342 /**
343  * @title Pausable token
344  * @dev StandardToken modified with pausable transfers.
345  **/
346 contract PausableToken is StandardToken, Pausable {
347 
348     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
349         return super.transfer(_to, _value);
350     }
351 
352     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
353         return super.transferFrom(_from, _to, _value);
354     }
355 
356     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
357         return super.approve(_spender, _value);
358     }
359 
360     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
361         return super.increaseApproval(_spender, _addedValue);
362     }
363 
364     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
365         return super.decreaseApproval(_spender, _subtractedValue);
366     }
367 }
368 
369 
370 /**
371  * @title FreezableToken
372  */
373 contract FreezableToken is StandardToken, Ownable {
374     mapping (address => bool) public frozenAccounts;
375     event FrozenFunds(address target, bool frozen);
376 
377     function freezeAccount(address target) public onlyOwner {
378         frozenAccounts[target] = true;
379         FrozenFunds(target, true);
380     }
381 
382     function unFreezeAccount(address target) public onlyOwner {
383         frozenAccounts[target] = false;
384         FrozenFunds(target, false);
385     }
386 
387     function frozen(address _target) constant public returns (bool){
388         return frozenAccounts[_target];
389     }
390 
391     // @dev Limit token transfer if _sender is frozen.
392     modifier canTransfer(address _sender) {
393         require(!frozenAccounts[_sender]);
394         _;
395     }
396 
397     function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool success) {
398         // Call StandardToken.transfer()
399         
400         return super.transfer(_to, _value);
401     }
402 
403     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns (bool success) {
404         // Call StandardToken.transferForm()
405         return super.transferFrom(_from, _to, _value);
406     }
407 }
408 
409 
410 
411 contract DIOCtoken is FreezableToken, PausableToken, BurnableToken {
412     string public constant name = "DIOC";
413     string public constant symbol = "DIO";
414     uint8 public constant decimals = 18;
415 
416     uint256 public constant INITIAL_SUPPLY =8880000000000000000000000000; //To change
417 
418     /**
419      * @dev Constructor that gives msg.sender all of existing tokens.
420      */
421     function DIOCtoken() public {
422         totalSupply_ = INITIAL_SUPPLY;
423         balances[msg.sender] = totalSupply_;
424         Transfer(0x0, msg.sender, totalSupply_);
425     }
426 }