1 pragma solidity 0.5.8;
2 
3 /**
4  * @title SafeMath 
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplie two unsigned integers, revert on overflow.
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
26      * @dev Integer division of two unsigned integers truncating the quotient, revert on division by zero.
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
38      * @dev Subtract two unsigned integers, revert on underflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Add two unsigned integers, revert on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 /**
59  * @title ERC20 interface
60  * @dev See https://eips.ethereum.org/EIPS/eip-20
61  */
62 interface IERC20 {
63     function transfer(address to, uint256 value) external returns (bool); 
64 
65     function approve(address spender, uint256 value) external returns (bool); 
66 
67     function transferFrom(address from, address to, uint256 value) external returns (bool); 
68 
69     function totalSupply() external view returns (uint256); 
70 
71     function balanceOf(address who) external view returns (uint256);
72 
73     function allowance(address owner, address spender) external view returns (uint256); 
74 
75     event Transfer(address indexed from, address indexed to, uint256 value); 
76 
77     event Approval(address indexed owner, address indexed spender, uint256 value); 
78 }
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86     address internal _owner; 
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); 
89 
90     /**
91      * @return the address of the owner.
92      */
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     /**
98      * @dev Revert if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(isOwner(), "The caller must be owner");
102         _;
103     }
104 
105     /**
106      * @return true if `msg.sender` is the owner of the contract.
107      */
108     function isOwner() public view returns (bool) {
109         return msg.sender == _owner;
110     }
111 
112     /**
113      * @dev Allow the current owner to relinquish control of the contract.
114      * It will not be possible to call the functions with the `onlyOwner`
115      * modifier anymore.
116      * @notice Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public onlyOwner {
120         emit OwnershipTransferred(_owner, address(0));
121         _owner = address(0);
122     }
123 
124     /**
125      * @dev Allow the current owner to transfer control of the contract to a newOwner.
126      * @param newOwner The address to transfer ownership to.
127      */
128     function transferOwnership(address newOwner) public onlyOwner {
129         _transferOwnership(newOwner); 
130     }
131 
132     /**
133      * @dev Transfer control of the contract to a newOwner.
134      * @param newOwner The address to transfer ownership to.
135      */
136     function _transferOwnership(address newOwner) internal {
137         require(newOwner != address(0), "Cannot transfer control of the contract to the zero address");
138         emit OwnershipTransferred(_owner, newOwner); 
139         _owner = newOwner; 
140     }
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  * @dev Implementation of the basic standard token.
146  */
147 contract StandardToken is IERC20 {
148     using SafeMath for uint256; 
149     
150     mapping (address => uint256) internal _balances; 
151     mapping (address => mapping (address => uint256)) internal _allowed; 
152     
153     uint256 internal _totalSupply; 
154     
155     /**
156      * @dev Total number of tokens in existence.
157      */
158     function totalSupply() public view returns (uint256) {
159         return _totalSupply; 
160     }
161 
162     /**
163      * @dev Get the balance of the specified address.
164      * @param owner The address to query the balance of.
165      * @return A uint256 representing the amount owned by the passed address.
166      */
167     function balanceOf(address owner) public view returns (uint256) {
168         return _balances[owner];
169     }
170 
171     /**
172      * @dev Function to check the amount of tokens that an owner allowed to a spender.
173      * @param owner The address which owns the funds.
174      * @param spender The address which will spend the funds.
175      * @return A uint256 specifying the amount of tokens still available for the spender.
176      */
177     function allowance(address owner, address spender) public view returns (uint256) {
178         return _allowed[owner][spender];
179     }
180 
181     /**
182      * @dev Transfer tokens to a specified address.
183      * @param to The address to transfer to.
184      * @param value The amount to be transferred.
185      */
186     function transfer(address to, uint256 value) public returns (bool) {
187         _transfer(msg.sender, to, value);
188         return true;
189     }
190 
191     /**
192      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193      * Beware that changing an allowance with this method brings the risk that someone may use both the old
194      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      * @param spender The address which will spend the funds.
198      * @param value The amount of tokens to be spent.
199      */
200     function approve(address spender, uint256 value) public returns (bool) {
201         _approve(msg.sender, spender, value); 
202         return true;
203     }
204 
205     /**
206      * @dev Transfer tokens from one address to another.
207      * Note that while this function emits an Approval event, this is not required as per the specification,
208      * and other compliant implementations may not emit the event.
209      * @param from The address which you want to send tokens from.
210      * @param to The address which you want to transfer to.
211      * @param value The amount of tokens to be transferred.
212      */
213     function transferFrom(address from, address to, uint256 value) public returns (bool) {
214         _transfer(from, to, value); 
215         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value)); 
216         return true;
217     }
218 
219     /**
220      * @dev Increase the amount of tokens that an owner allowed to a spender.
221      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * Emits an Approval event.
226      * @param spender The address which will spend the funds.
227      * @param addedValue The amount of tokens to increase the allowance by.
228      */
229     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
230         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue)); 
231         return true;
232     }
233 
234     /**
235      * @dev Decrease the amount of tokens that an owner allowed to a spender.
236      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      * Emits an Approval event.
241      * @param spender The address which will spend the funds.
242      * @param subtractedValue The amount of tokens to decrease the allowance by.
243      */
244     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
245         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
246         return true;
247     }
248 
249     /**
250      * @dev Transfer tokens for a specified address.
251      * @param from The address to transfer from.
252      * @param to The address to transfer to.
253      * @param value The amount to be transferred.
254      */
255     function _transfer(address from, address to, uint256 value) internal {
256         require(to != address(0), "Cannot transfer to the zero address"); 
257         _balances[from] = _balances[from].sub(value); 
258         _balances[to] = _balances[to].add(value); 
259         emit Transfer(from, to, value); 
260     }
261 
262     /**
263      * @dev Approve an address to spend another addresses' tokens.
264      * @param owner The address that owns the tokens.
265      * @param spender The address that will spend the tokens.
266      * @param value The number of tokens that can be spent.
267      */
268     function _approve(address owner, address spender, uint256 value) internal {
269         require(spender != address(0), "Cannot approve to the zero address"); 
270         require(owner != address(0), "Setter cannot be the zero address"); 
271 	    _allowed[owner][spender] = value;
272         emit Approval(owner, spender, value); 
273     }
274 
275 }
276 
277 /**
278  * @title Pausable
279  * @dev Base contract which allows children to implement an emergency stop mechanism.
280  */
281 contract Pausable is Ownable {
282     event Pause(); 
283     event Unpause(); 
284     
285     bool public paused = false; 
286     
287 
288 
289     /**
290      * @dev Modifier to make a function callable only when the contract is not paused.
291      */
292     modifier whenNotPaused() {
293         require(!paused, "Only when the contract is not paused"); 
294         _;
295     }
296 
297     /**
298      * @dev Modifier to make a function callable only when the contract is paused.
299      */
300     modifier whenPaused() {
301         require(paused, "Only when the contract is paused"); 
302         _;
303     }
304 
305     /**
306      * @dev Called by the owner to pause, trigger stopped state.
307      */
308     function pause() public onlyOwner whenNotPaused {
309         paused = true; 
310         emit Pause(); 
311     }
312 
313     /**
314      * @dev Called by the owner to unpause, return to normal state.
315      */
316     function unpause() public onlyOwner whenPaused {
317         paused = false; 
318         emit Unpause(); 
319     }
320 }
321 
322 /**
323  * @title PausableToken
324  * @dev ERC20 modified with pausable transfers.
325  */
326 contract PausableToken is StandardToken, Pausable {
327     
328     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
329         return super.transfer(_to, _value); 
330     }
331     
332     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
333         return super.transferFrom(_from, _to, _value); 
334     }
335     
336     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
337         return super.approve(_spender, _value); 
338     }
339     
340     function increaseAllowance(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
341         return super.increaseAllowance(_spender, _addedValue); 
342     }
343     
344     function decreaseAllowance(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
345         return super.decreaseAllowance(_spender, _subtractedValue); 
346     }
347 }
348 
349 /**
350  * @title BurnableToken
351  * @dev Implement the function of ERC20 token burning.
352  */
353 contract BurnableToken is StandardToken {
354 
355     /**
356     * @dev Burn a specific amount of tokens.
357     * @param _value The amount of token to be burned.
358     */
359     function burn(uint256 _value) public {
360         _burn(msg.sender, _value);
361     }
362 
363     /**
364     * @dev Burn a specific amount of tokens from the target address and decrements allowance
365     * @param _from address The address which you want to send tokens from
366     * @param _value uint256 The amount of token to be burned
367     */
368     function burnFrom(address _from, uint256 _value) public {
369         _approve(_from, msg.sender, _allowed[_from][msg.sender].sub(_value));
370         _burn(_from, _value);
371     }
372 
373     function _burn(address _who, uint256 _value) internal {
374         require(_value <= _balances[_who], "Not enough token balance");
375         // no need to require value <= totalSupply, since that would imply the
376         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
377         _balances[_who] = _balances[_who].sub(_value);
378         _totalSupply = _totalSupply.sub(_value);
379         emit Transfer(_who, address(0), _value);
380     }
381 }
382 
383 contract VFDToken is BurnableToken, PausableToken {
384     string public constant name = "Micro Payment Shield";  
385     string public constant symbol = "VFD";  
386     uint8 public constant decimals = 18;
387     uint256 internal constant INIT_TOTALSUPPLY = 65000000; 
388     
389     /**
390      * @dev Constructor, initialize the basic information of contract.
391      */
392     constructor() public {
393         _owner = 0x2CcaFDD16aA603Bbc8026711dd2E838616c010c3;
394         emit OwnershipTransferred(address(0), _owner);
395         _totalSupply = INIT_TOTALSUPPLY * 10 ** uint256(decimals);
396         _balances[_owner] = _totalSupply;
397         emit Transfer(address(0), _owner, _totalSupply);
398     }
399 }