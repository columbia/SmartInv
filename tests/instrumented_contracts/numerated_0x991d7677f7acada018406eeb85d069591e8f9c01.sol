1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 
26 contract Distributable {
27 
28   /**
29   Some addresses are still subject to change
30   **/
31   address[] public partners = [
32   0x0acc23Af96F4c43cf61E639cFc5C0937b9E07E7C,
33   0xcB4b6B7c4a72754dEb99bB72F1274129D9C0A109, //T1
34   0x7BF84E0244c05A11c57984e8dF7CC6481b8f4258, //T2
35   0x20D2F4Be237F4320386AaaefD42f68495C6A3E81, //T3
36   0x12BEA633B83aA15EfF99F68C2E7e14f2709802A9, //T4
37   0xC1a29a165faD532520204B480D519686B8CB845B, //T5
38   0xf5f5Eb6Ab1411935b321042Fa02a433FcbD029AC, //T6
39   0xaBff978f03d5ca81B089C5A2Fc321fB8152DC8f1]; //T7
40 
41   mapping(address => uint256) public tokenAmounts;
42 
43   constructor() public{
44     tokenAmounts[0x0acc23Af96F4c43cf61E639cFc5C0937b9E07E7C] = 3200000; //Solidified Wallet - 3.2MM
45 
46     // Team Vesting - total 800k
47     tokenAmounts[0xcB4b6B7c4a72754dEb99bB72F1274129D9C0A109] = 80000; //T1
48     tokenAmounts[0x7BF84E0244c05A11c57984e8dF7CC6481b8f4258] = 80000; //T2
49     tokenAmounts[0x20D2F4Be237F4320386AaaefD42f68495C6A3E81] = 80000; //T3
50     tokenAmounts[0x12BEA633B83aA15EfF99F68C2E7e14f2709802A9] = 80000; //T4
51     tokenAmounts[0xC1a29a165faD532520204B480D519686B8CB845B] = 120000; //T5
52     tokenAmounts[0xf5f5Eb6Ab1411935b321042Fa02a433FcbD029AC] = 120000; //T6
53     tokenAmounts[0xaBff978f03d5ca81B089C5A2Fc321fB8152DC8f1] = 240000; //T7
54 
55   }
56 }
57 
58 
59 
60 
61 
62 
63 
64 /**
65  * @title SafeMath
66  * @dev Unsigned math operations with safety checks that revert on error
67  */
68 library SafeMath {
69     /**
70     * @dev Multiplies two unsigned integers, reverts on overflow.
71     */
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
74         // benefit is lost if 'b' is also tested.
75         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
76         if (a == 0) {
77             return 0;
78         }
79 
80         uint256 c = a * b;
81         require(c / a == b);
82 
83         return c;
84     }
85 
86     /**
87     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
88     */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Solidity only automatically asserts when dividing by 0
91         require(b > 0);
92         uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94 
95         return c;
96     }
97 
98     /**
99     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
100     */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b <= a);
103         uint256 c = a - b;
104 
105         return c;
106     }
107 
108     /**
109     * @dev Adds two unsigned integers, reverts on overflow.
110     */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a);
114 
115         return c;
116     }
117 
118     /**
119     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
120     * reverts when dividing by zero.
121     */
122     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
123         require(b != 0);
124         return a % b;
125     }
126 }
127 
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
134  * Originally based on code by FirstBlood:
135  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  *
137  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
138  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
139  * compliant implementations may not do it.
140  */
141 contract ERC20 is IERC20 {
142     using SafeMath for uint256;
143 
144     mapping (address => uint256) private _balances;
145 
146     mapping (address => mapping (address => uint256)) private _allowed;
147 
148     uint256 private _totalSupply;
149 
150     /**
151     * @dev Total number of tokens in existence
152     */
153     function totalSupply() public view returns (uint256) {
154         return _totalSupply;
155     }
156 
157     /**
158     * @dev Gets the balance of the specified address.
159     * @param owner The address to query the balance of.
160     * @return An uint256 representing the amount owned by the passed address.
161     */
162     function balanceOf(address owner) public view returns (uint256) {
163         return _balances[owner];
164     }
165 
166     /**
167      * @dev Function to check the amount of tokens that an owner allowed to a spender.
168      * @param owner address The address which owns the funds.
169      * @param spender address The address which will spend the funds.
170      * @return A uint256 specifying the amount of tokens still available for the spender.
171      */
172     function allowance(address owner, address spender) public view returns (uint256) {
173         return _allowed[owner][spender];
174     }
175 
176     /**
177     * @dev Transfer token for a specified address
178     * @param to The address to transfer to.
179     * @param value The amount to be transferred.
180     */
181     function transfer(address to, uint256 value) public returns (bool) {
182         _transfer(msg.sender, to, value);
183         return true;
184     }
185 
186     /**
187      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188      * Beware that changing an allowance with this method brings the risk that someone may use both the old
189      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      * @param spender The address which will spend the funds.
193      * @param value The amount of tokens to be spent.
194      */
195     function approve(address spender, uint256 value) public returns (bool) {
196         require(spender != address(0));
197 
198         _allowed[msg.sender][spender] = value;
199         emit Approval(msg.sender, spender, value);
200         return true;
201     }
202 
203     /**
204      * @dev Transfer tokens from one address to another.
205      * Note that while this function emits an Approval event, this is not required as per the specification,
206      * and other compliant implementations may not emit the event.
207      * @param from address The address which you want to send tokens from
208      * @param to address The address which you want to transfer to
209      * @param value uint256 the amount of tokens to be transferred
210      */
211     function transferFrom(address from, address to, uint256 value) public returns (bool) {
212         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
213         _transfer(from, to, value);
214         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
215         return true;
216     }
217 
218     /**
219      * @dev Increase the amount of tokens that an owner allowed to a spender.
220      * approve should be called when allowed_[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * Emits an Approval event.
225      * @param spender The address which will spend the funds.
226      * @param addedValue The amount of tokens to increase the allowance by.
227      */
228     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
229         require(spender != address(0));
230 
231         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
232         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
233         return true;
234     }
235 
236     /**
237      * @dev Decrease the amount of tokens that an owner allowed to a spender.
238      * approve should be called when allowed_[_spender] == 0. To decrement
239      * allowed value is better to use this function to avoid 2 calls (and wait until
240      * the first transaction is mined)
241      * From MonolithDAO Token.sol
242      * Emits an Approval event.
243      * @param spender The address which will spend the funds.
244      * @param subtractedValue The amount of tokens to decrease the allowance by.
245      */
246     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
247         require(spender != address(0));
248 
249         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
250         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
251         return true;
252     }
253 
254     /**
255     * @dev Transfer token for a specified addresses
256     * @param from The address to transfer from.
257     * @param to The address to transfer to.
258     * @param value The amount to be transferred.
259     */
260     function _transfer(address from, address to, uint256 value) internal {
261         require(to != address(0));
262 
263         _balances[from] = _balances[from].sub(value);
264         _balances[to] = _balances[to].add(value);
265         emit Transfer(from, to, value);
266     }
267 
268     /**
269      * @dev Internal function that mints an amount of the token and assigns it to
270      * an account. This encapsulates the modification of balances such that the
271      * proper events are emitted.
272      * @param account The account that will receive the created tokens.
273      * @param value The amount that will be created.
274      */
275     function _mint(address account, uint256 value) internal {
276         require(account != address(0));
277 
278         _totalSupply = _totalSupply.add(value);
279         _balances[account] = _balances[account].add(value);
280         emit Transfer(address(0), account, value);
281     }
282 
283     /**
284      * @dev Internal function that burns an amount of the token of a given
285      * account.
286      * @param account The account whose tokens will be burnt.
287      * @param value The amount that will be burnt.
288      */
289     function _burn(address account, uint256 value) internal {
290         require(account != address(0));
291 
292         _totalSupply = _totalSupply.sub(value);
293         _balances[account] = _balances[account].sub(value);
294         emit Transfer(account, address(0), value);
295     }
296 
297     /**
298      * @dev Internal function that burns an amount of the token of a given
299      * account, deducting from the sender's allowance for said account. Uses the
300      * internal burn function.
301      * Emits an Approval event (reflecting the reduced allowance).
302      * @param account The account whose tokens will be burnt.
303      * @param value The amount that will be burnt.
304      */
305     function _burnFrom(address account, uint256 value) internal {
306         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
307         _burn(account, value);
308         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
309     }
310 }
311 
312 
313 
314 /**
315  * @title Ownable
316  * @dev The Ownable contract has an owner address, and provides basic authorization control
317  * functions, this simplifies the implementation of "user permissions".
318  */
319 contract Ownable {
320     address private _owner;
321 
322     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
323 
324     /**
325      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
326      * account.
327      */
328     constructor () internal {
329         _owner = msg.sender;
330         emit OwnershipTransferred(address(0), _owner);
331     }
332 
333     /**
334      * @return the address of the owner.
335      */
336     function owner() public view returns (address) {
337         return _owner;
338     }
339 
340     /**
341      * @dev Throws if called by any account other than the owner.
342      */
343     modifier onlyOwner() {
344         require(isOwner());
345         _;
346     }
347 
348     /**
349      * @return true if `msg.sender` is the owner of the contract.
350      */
351     function isOwner() public view returns (bool) {
352         return msg.sender == _owner;
353     }
354 
355     /**
356      * @dev Allows the current owner to relinquish control of the contract.
357      * @notice Renouncing to ownership will leave the contract without an owner.
358      * It will not be possible to call the functions with the `onlyOwner`
359      * modifier anymore.
360      */
361     function renounceOwnership() public onlyOwner {
362         emit OwnershipTransferred(_owner, address(0));
363         _owner = address(0);
364     }
365 
366     /**
367      * @dev Allows the current owner to transfer control of the contract to a newOwner.
368      * @param newOwner The address to transfer ownership to.
369      */
370     function transferOwnership(address newOwner) public onlyOwner {
371         _transferOwnership(newOwner);
372     }
373 
374     /**
375      * @dev Transfers control of the contract to a newOwner.
376      * @param newOwner The address to transfer ownership to.
377      */
378     function _transferOwnership(address newOwner) internal {
379         require(newOwner != address(0));
380         emit OwnershipTransferred(_owner, newOwner);
381         _owner = newOwner;
382     }
383 }
384 
385 
386 
387 contract SolidToken is ERC20, Distributable, Ownable {
388 
389   string public constant name = "SolidToken";
390   string public constant symbol = "SOLID";
391   uint8  public constant decimals = 18;
392   uint256 constant private DECIMAL_PLACES = 10 ** 18;
393   uint256 constant SUPPLY_CAP = 4000000 * DECIMAL_PLACES;
394   uint256 constant transferEnablingDate = 1555977600; //23-04-2019
395 
396   mapping(address => bool) public superusers;
397 
398   event SuperuserModified(address superuser, bool status);
399 
400 
401   /**
402    * @dev Enables the token transfer
403    */
404   modifier transfersAllowed() {
405     require(now >= transferEnablingDate || superusers[msg.sender]);
406     _;
407   }
408 
409 
410     constructor() public {
411     //Mint tokens
412     for(uint i = 0; i < partners.length; i++){
413       uint256 amount = tokenAmounts[partners[i]].mul(DECIMAL_PLACES);
414       _mint(partners[i], amount);
415     }
416     //Add Solidified Wallet as a superuser
417     superusers[0x0acc23Af96F4c43cf61E639cFc5C0937b9E07E7C] = true;
418   }
419 
420 
421   function addSuperUser(address user, bool status) public onlyOwner {
422     superusers[user] = status;
423     emit SuperuserModified(user, status);
424   }
425 
426 
427 
428   /**
429   * @dev transfer token for a specified address
430   * @param _to The address to transfer to.
431   * @param _value The amount to be transferred.
432   */
433   function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
434     require(super.transfer(_to, _value));
435     return true;
436   }
437 
438 
439   /**
440    * @dev Transfer tokens from one address to another
441    * @param _from address The address which you want to send tokens from
442    * @param _to address The address which you want to transfer to
443    * @param _value uint256 the amount of tokens to be transferred
444    */
445   function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed  returns (bool) {
446     require(super.transferFrom(_from, _to, _value));
447     return true;
448   }
449 
450 }