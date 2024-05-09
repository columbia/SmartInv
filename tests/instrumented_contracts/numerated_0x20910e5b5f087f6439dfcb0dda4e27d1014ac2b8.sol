1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
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
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
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
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76     address private _owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     /**
81      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82      * account.
83      */
84     constructor () internal {
85         _owner = msg.sender;
86         emit OwnershipTransferred(address(0), _owner);
87     }
88 
89     /**
90      * @return the address of the owner.
91      */
92     function owner() public view returns (address) {
93         return _owner;
94     }
95 
96     /**
97      * @dev Throws if called by any account other than the owner.
98      */
99     modifier onlyOwner() {
100         require(isOwner());
101         _;
102     }
103 
104     /**
105      * @return true if `msg.sender` is the owner of the contract.
106      */
107     function isOwner() public view returns (bool) {
108         return msg.sender == _owner;
109     }
110 
111     /**
112      * @dev Allows the current owner to relinquish control of the contract.
113      * @notice Renouncing to ownership will leave the contract without an owner.
114      * It will not be possible to call the functions with the `onlyOwner`
115      * modifier anymore.
116      */
117     function renounceOwnership() public onlyOwner {
118         emit OwnershipTransferred(_owner, address(0));
119         _owner = address(0);
120     }
121 
122     /**
123      * @dev Allows the current owner to transfer control of the contract to a newOwner.
124      * @param newOwner The address to transfer ownership to.
125      */
126     function transferOwnership(address newOwner) public onlyOwner {
127         _transferOwnership(newOwner);
128     }
129 
130     /**
131      * @dev Transfers control of the contract to a newOwner.
132      * @param newOwner The address to transfer ownership to.
133      */
134     function _transferOwnership(address newOwner) internal {
135         require(newOwner != address(0));
136         emit OwnershipTransferred(_owner, newOwner);
137         _owner = newOwner;
138     }
139 }
140 
141 
142 /**
143  * @title Pausable
144  * @dev Base contract which allows children to implement an emergency stop mechanism.
145  */
146 contract Pausable is Ownable{
147     event Paused(address account);
148     event Unpaused(address account);
149 
150     bool private _paused;
151 
152     constructor () internal {
153         _paused = false;
154     }
155 
156     /**
157      * @return true if the contract is paused, false otherwise.
158      */
159     function paused() public view returns (bool) {
160         return _paused;
161     }
162 
163     /**
164      * @dev Modifier to make a function callable only when the contract is not paused.
165      */
166     modifier whenNotPaused() {
167         require(!_paused);
168         _;
169     }
170 
171     /**
172      * @dev Modifier to make a function callable only when the contract is paused.
173      */
174     modifier whenPaused() {
175         require(_paused);
176         _;
177     }
178 
179     /**
180      * @dev called by the owner to pause, triggers stopped state
181      */
182     function pause() public onlyOwner whenNotPaused {
183         _paused = true;
184         emit Paused(msg.sender);
185     }
186 
187     /**
188      * @dev called by the owner to unpause, returns to normal state
189      */
190     function unpause() public onlyOwner whenPaused {
191         _paused = false;
192         emit Unpaused(msg.sender);
193     }
194 }
195 
196 
197 contract ERC20Token{
198     using SafeMath for uint256;
199 
200     // Public variables of the token
201     string public name;
202     string public symbol;
203     uint8 public decimals = 18;
204     // 18 decimals is the strongly suggested default, avoid changing it
205     uint256 public totalSupply;
206 
207     // This creates an array with all balances
208     mapping (address => uint256) public balanceOf;
209     mapping (address => mapping (address => uint256)) public allowance;
210 
211     // This generates a public event on the blockchain that will notify clients
212     event Transfer(address indexed from, address indexed to, uint256 value);
213     
214     // This generates a public event on the blockchain that will notify clients
215     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
216 
217     // This notifies clients about the amount burnt
218     event Burn(address indexed from, uint256 value);
219 
220     /**
221      * Constructor function
222      *
223      * Initializes contract with initial supply tokens to the creator of the contract
224      */
225     constructor(uint256 initialSupply,string memory tokenName,string memory tokenSymbol) public {
226         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
227         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
228         name = tokenName;                                   // Set the name for display purposes
229         symbol = tokenSymbol;                               // Set the symbol for display purposes
230     }
231 
232     /**
233      * Internal transfer, only can be called by this contract
234      */
235     function _transfer(address _from, address _to, uint _value) internal {
236         // Prevent transfer to 0x0 address. Use burn() instead
237         require(_to != address(0x0));
238 
239         balanceOf[_from] = balanceOf[_from].sub(_value);
240         balanceOf[_to] = balanceOf[_to].add(_value);
241 
242         emit Transfer(_from, _to, _value);
243     }
244 
245     /**
246      * Transfer tokens
247      *
248      * Send `_value` tokens to `_to` from your account
249      *
250      * @param _to The address of the recipient
251      * @param _value the amount to send
252      */
253     function transfer(address _to, uint256 _value) public returns (bool success) {
254         _transfer(msg.sender, _to, _value);
255         return true;
256     }
257 
258     /**
259      * Transfer tokens from other address
260      *
261      * Send `_value` tokens to `_to` on behalf of `_from`
262      *
263      * @param _from The address of the sender
264      * @param _to The address of the recipient
265      * @param _value the amount to send
266      */
267     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
268         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
269         _transfer(_from, _to, _value);
270         return true;
271     }
272 
273     /**
274      * Set allowance for other address
275      *
276      * Allows `_spender` to spend no more than `_value` tokens on your behalf
277      *
278      * @param _spender The address authorized to spend
279      * @param _value the max amount they can spend
280      */
281     function approve(address _spender, uint256 _value) public
282         returns (bool success) {
283         allowance[msg.sender][_spender] = _value;
284         emit Approval(msg.sender, _spender, _value);
285         return true;
286     }
287 
288     /**
289      * Set allowance for other address and notify
290      *
291      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
292      *
293      * @param _spender The address authorized to spend
294      * @param _value the max amount they can spend
295      * @param _extraData some extra information to send to the approved contract
296      */
297     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
298         public
299         returns (bool success) {
300         tokenRecipient spender = tokenRecipient(_spender);
301         if (approve(_spender, _value)) {
302             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
303             return true;
304         }
305     }
306 
307     /**
308      * Destroy tokens
309      *
310      * Remove `_value` tokens from the system irreversibly
311      *
312      * @param _value the amount of money to burn
313      */
314     function burn(uint256 _value) public returns (bool success) {
315         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);              // Subtract from the sender
316         totalSupply = totalSupply.sub(_value);                                  // Updates totalSupply
317         emit Burn(msg.sender, _value);
318         return true;
319     }
320 
321     /**
322      * Destroy tokens from other account
323      *
324      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
325      *
326      * @param _from the address of the sender
327      * @param _value the amount of money to burn
328      */
329     function burnFrom(address _from, uint256 _value) public returns (bool success) {
330         balanceOf[_from] = balanceOf[_from].sub(_value);                                        // Subtract from the targeted balance
331         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);                // Subtract from the sender's allowance
332         totalSupply = totalSupply.sub(_value);                                                  // Update totalSupply
333         emit Burn(_from, _value);
334         return true;
335     }
336 
337 }
338 
339 
340 contract BananaToken is ERC20Token, Ownable,Pausable{
341 
342     mapping (address => bool) public frozenAccount;
343 
344     mapping(address => uint256) public lockedAccount;
345 
346     event FreezeAccount(address account, bool frozen);
347 
348     event LockAccount(address account,uint256 unlockTime);
349 
350     constructor() ERC20Token(5000000000,"Banana","BNA") public {
351     }
352 
353 
354     /**
355     * Freeze Account
356     */
357     function freezeAccount(address account) onlyOwner public {
358         frozenAccount[account] = true;
359         emit FreezeAccount(account, true);
360     }
361 
362 
363     /**
364     * unFreeze Account
365     */
366     function unFreezeAccount(address account) onlyOwner public{
367         frozenAccount[account] = false;
368         emit FreezeAccount(account, false);
369     }
370 
371     /**
372     * lock Account, if account is locked, fund can only transfer in but not transfer out.
373     * Can not unlockAccount, if need unlock account , pls call unlockAccount interface
374      */
375     function lockAccount(address account, uint256 unlockTime) onlyOwner public{
376         require(unlockTime > now);
377         lockedAccount[account] = unlockTime;
378         emit LockAccount(account,unlockTime);
379     }
380 
381    /**
382     * unlock Account
383      */
384     function unlockAccount(address account) onlyOwner public{
385         lockedAccount[account] = 0;
386         emit LockAccount(account,0);
387     }
388 
389 
390     function changeName(string memory newName) public onlyOwner {
391         name = newName;
392     }
393 
394     function changeSymbol(string memory newSymbol) public onlyOwner{
395         symbol = newSymbol;
396     }
397 
398     /**
399     * Internal transfer, only can be called by this contract
400     */
401     function _transfer(address _from, address _to, uint _value) internal whenNotPaused {
402         // Prevent transfer to 0x0 address. Use burn() instead
403         require(_to != address(0x0));
404 
405         //if account is frozen, then fund can not be transfer in or out.
406         require(!frozenAccount[_from]);
407         require(!frozenAccount[_to]);
408 
409         //if account is locked, then fund can only transfer in but can not transfer out.
410         require(!isAccountLocked(_from));
411 
412         balanceOf[_from] = balanceOf[_from].sub(_value);
413         balanceOf[_to] = balanceOf[_to].add(_value);
414 
415         emit Transfer(_from, _to, _value);
416     }
417 
418 
419     function isAccountLocked(address account) public view returns (bool) {
420         return lockedAccount[account] > now;
421     }
422 
423     function isAccountFrozen(address account) public view returns (bool){
424         return frozenAccount[account];
425     }
426 }