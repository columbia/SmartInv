1 pragma solidity 0.5.4;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65     address public owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71      * account.
72      */
73     constructor () public {
74         owner = msg.sender;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     /**
86      * @dev Allows the current owner to transfer control of the contract to a newOwner.
87      * @param newOwner The address to transfer ownership to.
88      */
89     function transferOwnership(address newOwner) public onlyOwner {
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers control of the contract to a newOwner.
95      * @param newOwner The address to transfer ownership to.
96      */
97     function _transferOwnership(address newOwner) internal {
98         require(newOwner != address(0));
99         emit OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101     }
102 }
103 
104 
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
136      * @dev called by the owner to unpause, returns to normal state
137      */
138     function unpause() public onlyOwner whenPaused {
139         paused = false;
140         emit Unpause();
141     }
142 }
143 
144 
145 contract StandardToken {
146     using SafeMath for uint256;
147 
148     mapping(address => uint256) internal balances;
149 
150     mapping(address => mapping(address => uint256)) internal allowed;
151 
152     uint256 public totalSupply;
153 
154     event Transfer(address indexed from, address indexed to, uint256 value);
155     event Burn(address indexed owner,uint256 amount);
156     event Approval(address indexed owner, address indexed spender, uint256 vaule);
157 
158     /**
159      * @dev Gets the balance of the specified address.
160      * @param _owner The address to query the the balance of.
161      * @return An uint256 representing the amount owned by the passed address.
162      */
163     function balanceOf(address _owner) public view returns(uint256) {
164         return balances[_owner];
165     }
166 
167     /**
168      * @dev Function to check the amount of tokens that an owner allowed to a spender.
169      * @param _owner address The address which owns the funds.
170      * @param _spender address The address which will spend the funds.
171      * @return A uint256 specifying the amount of tokens still available for the spender.
172      */
173     function allowance(address _owner, address _spender) public view returns(uint256) {
174         return allowed[_owner][_spender];
175     }
176 
177     /**
178      * @dev Transfer token for a specified address
179      * @param _to The address to transfer to.
180      * @param _value The amount to be transferred.
181      */
182     function transfer(address _to, uint256 _value) public returns(bool) {
183         require(_to != address(0));
184         require(_value <= balances[msg.sender]);
185 
186         balances[msg.sender] = balances[msg.sender].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         emit Transfer(msg.sender, _to, _value);
189         return true;
190     }
191 
192     /**
193      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194      * Beware that changing an allowance with this method brings the risk that someone may use both the old
195      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      * @param _spender The address which will spend the funds.
199      * @param _value The amount of tokens to be spent.
200      */
201     function approve(address _spender, uint256 _value) public returns(bool) {
202         allowed[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208      * @dev Transfer tokens from one address to another
209      * @param _from address The address which you want to send tokens from
210      * @param _to address The address which you want to transfer to
211      * @param _value uint256 the amount of tokens to be transferred
212      */
213     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
214         require(_to != address(0));
215         require(_value <= balances[_from]);
216         require(_value <= allowed[_from][msg.sender]);
217 
218         balances[_from] = balances[_from].sub(_value);
219         balances[_to] = balances[_to].add(_value);
220         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221         emit Transfer(_from, _to, _value);
222         return true;
223     }
224 
225     /**
226      * @dev Increase the amount of tokens that an owner allowed to a spender.
227      * approve should be called when allowed[_spender] == 0. To increment
228      * allowed value is better to use this function to avoid 2 calls (and wait until
229      * the first transaction is mined)
230      * From MonolithDAO Token.sol
231      * @param _spender The address which will spend the funds.
232      * @param _addedValue The amount of tokens to increase the allowance by.
233      */
234     function increaseApproval(address _spender, uint256 _addedValue) public returns(bool) {
235         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237         return true;
238     }
239 
240     /**
241      * @dev Decrease the amount of tokens that an owner allowed to a spender.
242      * approve should be called when allowed[_spender] == 0. To decrement
243      * allowed value is better to use this function to avoid 2 calls (and wait until
244      * the first transaction is mined)
245      * From MonolithDAO Token.sol
246      * @param _spender The address which will spend the funds.
247      * @param _subtractedValue The amount of tokens to decrease the allowance by.
248      */
249     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns(bool) {
250         uint256 oldValue = allowed[msg.sender][_spender];
251         if (_subtractedValue >= oldValue) {
252             allowed[msg.sender][_spender] = 0;
253         } else {
254             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255         }
256         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257         return true;
258     }
259 
260     function _burn(address account, uint256 value) internal {
261         require(account != address(0));
262         totalSupply = totalSupply.sub(value);
263         balances[account] = balances[account].sub(value);
264         emit Transfer(account, address(0), value);
265         emit Burn(account, value);
266     }
267 
268     /**
269      * @dev Internal function that burns an amount of the token of a given
270      * account, deducting from the sender's allowance for said account. Uses the
271      * internal burn function.
272      * @param account The account whose tokens will be burnt.
273      * @param value The amount that will be burnt.
274      */
275     function _burnFrom(address account, uint256 value) internal {
276         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
277         // this function needs to emit an event with the updated approval.
278         allowed[account][msg.sender] = allowed[account][msg.sender].sub(value);
279         _burn(account, value);
280     }
281 
282 }
283 
284 
285 contract BurnableToken is StandardToken {
286 
287     /**
288      * @dev Burns a specific amount of tokens.
289      * @param value The amount of token to be burned.
290      */
291     function burn(uint256 value) public {
292         _burn(msg.sender, value);
293     }
294 
295     /**
296      * @dev Burns a specific amount of tokens from the target address and decrements allowance
297      * @param from address The address which you want to send tokens from
298      * @param value uint256 The amount of token to be burned
299      */
300     function burnFrom(address from, uint256 value) public {
301         _burnFrom(from, value);
302     }
303 }
304 
305 
306 /**
307  * @title Pausable token
308  * @dev ERC20 modified with pausable transfers.
309  */
310 contract PausableToken is StandardToken, Pausable {
311     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
312         return super.transfer(to, value);
313     }
314 
315     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
316         return super.transferFrom(from, to, value);
317     }
318 
319     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
320         return super.approve(spender, value);
321     }
322 
323     function increaseApproval(address spender, uint256 addedValue) public whenNotPaused returns (bool success) {
324         return super.increaseApproval(spender, addedValue);
325     }
326 
327     function decreaseApproval(address spender, uint256 subtractedValue) public whenNotPaused returns (bool success) {
328         return super.decreaseApproval(spender, subtractedValue);
329     }
330 }
331 
332 contract Token is PausableToken, BurnableToken {
333     string public constant name = "Global Trading System"; // name of Token 
334     string public constant symbol = "GTS"; // symbol of Token 
335     uint8 public constant decimals = 18;
336 
337     uint256 internal constant INIT_TOTALSUPPLY = 1000000000; // Total amount of tokens
338 
339     constructor() public {
340         totalSupply = INIT_TOTALSUPPLY * 10 ** uint256(decimals);
341         balances[msg.sender] = totalSupply;
342     }
343 }
344 
345 /**
346  * @dev Interface of Pair contract
347  */
348 interface PairContract {
349     function tokenFallback(address _from, uint256 _value, bytes calldata _data) external;
350     function transfer(address _to, uint256 _value) external returns (bool);
351     function decimals() external returns (uint8);
352 }
353 
354 contract GTS is Token {
355     // The address of Pair contract
356     PairContract public pairInstance;
357     /// @notice revoking rate precise
358     /// @notice for example: RATE_PRECISE is 3, meaning that the revoking fee ratio is 3/10000
359     uint public rate = 10000;  // default rate is 1:1
360     uint public constant RATE_PRECISE = 10000;
361 
362     // events
363     event ExchangePair(address indexed from, uint256 value);
364     event SetPairContract(address PairToken);
365     event RateChanged(uint256 previousOwner,uint256 newRate);
366 
367     /**
368      * @dev Throws if called by any account other than the Pair contract
369      */
370     modifier onlyPairContract() {
371         require(msg.sender == address(pairInstance));
372         _;
373     }
374 
375     /**
376      * @dev Sets the address of pair contract
377      */
378     function setPairContract(address pairAddress) public onlyOwner {
379         require(pairAddress != address(0));
380         pairInstance = PairContract(pairAddress);
381         emit SetPairContract(pairAddress);
382     }
383 
384     /**
385      * @dev Function Set the exchange rate of pair token.
386      * for example: RATE_PRECISE is 300, means that the rate is 300/10000: 1 PT = 0.003 GTS
387      * for example: RATE_PRECISE is 30000, means that the rate is 30000/10000: 1 PT = 3 GTS
388      */
389      function setRate(uint256 _newRate) public onlyOwner {
390         require(_newRate > 0);
391         emit RateChanged(rate,_newRate);
392         rate = _newRate;
393      }
394 
395     /**
396      * @dev Transfers token to a specified address.
397      *      If the target address of transferring is Pair contract, the operation of changing Pair tokens will be executed.
398      * @param to The target address of transfer, which may be the  contract
399      * @param value The amount of tokens transferred
400      */
401     function transfer(address to, uint value) public returns (bool) {
402         super.transfer(to, value); // Transfers tokens to address 'to'
403         if(to == address(pairInstance)) {
404             pairInstance.tokenFallback(msg.sender, value, bytes("")); // Calls 'tokenFallback' function in Pair contract to exchange tokens
405             emit ExchangePair(msg.sender, value);
406         }
407         return true;
408     }
409 
410     /**
411      * @dev Transfers tokens from one address to another.
412      *      If the target address of transferring is  Pair contract, the operation of changing Pair tokens will be executed.
413      * @param from The address which you want to send tokens from
414      * @param to The address which you want to transfer to
415      * @param value The amount of tokens to be transferred
416      */
417     function transferFrom(address from, address to, uint value) public returns (bool) {
418         super.transferFrom(from, to, value); // Transfers token to address 'to'
419         if(to == address(pairInstance)) {
420             pairInstance.tokenFallback(from, value, bytes("")); // Calls 'tokenFallback' function in Pair contract to exchange tokens
421             emit ExchangePair(from, value);
422         }
423         return true;
424     }
425 
426     /**
427      * @dev Function that is called by the Pair contract to exchange 'GTS' tokens
428      */
429     function tokenFallback(address from, uint256 value, bytes calldata) external onlyPairContract {
430         require(from != address(0));
431         require(value != uint256(0));
432         require(pairInstance.transfer(owner,value)); // Transfers Pair tokens belonging to this contract to 'owner'
433         uint256 GTSValue = value.mul(10**uint256(decimals)).mul(rate).div(RATE_PRECISE).div(10**uint256(pairInstance.decimals())); // Calculates the number of 'GTS' tokens that can be exchanged
434         require(GTSValue <= balances[owner]);
435         balances[owner] = balances[owner].sub(GTSValue);
436         balances[from] = balances[from].add(GTSValue); 
437         emit Transfer(owner, from, GTSValue);
438     }
439     
440     /**
441      * @dev Function that is used to withdraw the 'Pair' tokens in this contract
442      */
443     function withdrawToken(uint256 value) public onlyOwner {
444         require(pairInstance.transfer(owner,value));
445     }    
446 }