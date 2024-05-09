1 /**
2  *Submitted for verification at Etherscan.io on 2019-03-21
3 */
4 
5 pragma solidity >=0.4.22 <0.6.0;
6 
7 /**
8  * @title SafeMath
9  * @dev Unsigned math operations with safety checks that revert on error
10  */
11 library SafeMath {
12     /**
13     * @dev Multiplies two unsigned integers, reverts on overflow.
14     */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43     */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52     * @dev Adds two unsigned integers, reverts on overflow.
53     */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
63     * reverts when dividing by zero.
64     */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79     address private _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor (address _myOwner) internal {
88         _owner = _myOwner;
89         emit OwnershipTransferred(address(0), _owner);
90     }
91 
92     /**
93      * @return the address of the owner.
94      */
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(isOwner());
104         _;
105     }
106 
107     /**
108      * @return true if `msg.sender` is the owner of the contract.
109      */
110     function isOwner() public view returns (bool) {
111         return msg.sender == _owner;
112     }
113 
114     /**
115      * @dev Allows the current owner to relinquish control of the contract.
116      * @notice Renouncing to ownership will leave the contract without an owner.
117      * It will not be possible to call the functions with the `onlyOwner`
118      * modifier anymore.
119      */
120     function renounceOwnership() public onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124 
125     /**
126      * @dev Allows the current owner to transfer control of the contract to a newOwner.
127      * @param newOwner The address to transfer ownership to.
128      */
129     function transferOwnership(address newOwner) public onlyOwner {
130         _transferOwnership(newOwner);
131     }
132 
133     /**
134      * @dev Transfers control of the contract to a newOwner.
135      * @param newOwner The address to transfer ownership to.
136      */
137     function _transferOwnership(address newOwner) internal {
138         require(newOwner != address(0));
139         emit OwnershipTransferred(_owner, newOwner);
140         _owner = newOwner;
141     }
142 }
143 
144 
145 /**
146  * @title Pausable
147  * @dev Base contract which allows children to implement an emergency stop mechanism.
148  */
149 contract Pausable is Ownable{
150     event Paused(address account);
151     event Unpaused(address account);
152 
153     bool private _paused;
154 
155     constructor () internal {
156         _paused = false;
157     }
158 
159     /**
160      * @return true if the contract is paused, false otherwise.
161      */
162     function paused() public view returns (bool) {
163         return _paused;
164     }
165 
166     /**
167      * @dev Modifier to make a function callable only when the contract is not paused.
168      */
169     modifier whenNotPaused() {
170         require(!_paused);
171         _;
172     }
173 
174     /**
175      * @dev Modifier to make a function callable only when the contract is paused.
176      */
177     modifier whenPaused() {
178         require(_paused);
179         _;
180     }
181 
182     /**
183      * @dev called by the owner to pause, triggers stopped state
184      */
185     function pause() public onlyOwner whenNotPaused {
186         _paused = true;
187         emit Paused(msg.sender);
188     }
189 
190     /**
191      * @dev called by the owner to unpause, returns to normal state
192      */
193     function unpause() public onlyOwner whenPaused {
194         _paused = false;
195         emit Unpaused(msg.sender);
196     }
197 }
198 
199 
200 contract ERC20Token{
201     using SafeMath for uint256;
202 
203     // Public variables of the token
204     string public name;
205     string public symbol;
206     uint8 public decimals = 18;
207     // 18 decimals is the strongly suggested default, avoid changing it
208     uint256 public totalSupply;
209 
210     // This creates an array with all balances
211     mapping (address => uint256) public balanceOf;
212     mapping (address => mapping (address => uint256)) public allowance;
213 
214     // This generates a public event on the blockchain that will notify clients
215     event Transfer(address indexed from, address indexed to, uint256 value);
216     
217     // This generates a public event on the blockchain that will notify clients
218     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
219 
220     // This notifies clients about the amount burnt
221     event Burn(address indexed from, uint256 value);
222 
223     /**
224      * Constructor function
225      *
226      * Initializes contract with initial supply tokens to the creator of the contract
227      */
228     constructor(address _mywallet, uint256 initialSupply,string memory tokenName,string memory tokenSymbol) public {
229         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
230         balanceOf[_mywallet] = totalSupply;                // Give the creator all initial tokens
231         name = tokenName;                                   // Set the name for display purposes
232         symbol = tokenSymbol;                               // Set the symbol for display purposes
233     }
234 
235     /**
236      * Internal transfer, only can be called by this contract
237      */
238     function _transfer(address _from, address _to, uint _value) internal {
239         // Prevent transfer to 0x0 address. Use burn() instead
240         require(_to != address(0x0));
241 
242         balanceOf[_from] = balanceOf[_from].sub(_value);
243         balanceOf[_to] = balanceOf[_to].add(_value);
244 
245         emit Transfer(_from, _to, _value);
246     }
247 
248     /**
249      * Transfer tokens
250      *
251      * Send `_value` tokens to `_to` from your account
252      *
253      * @param _to The address of the recipient
254      * @param _value the amount to send
255      */
256     function transfer(address _to, uint256 _value) public returns (bool success) {
257         _transfer(msg.sender, _to, _value);
258         return true;
259     }
260 
261     /**
262      * Transfer tokens from other address
263      *
264      * Send `_value` tokens to `_to` on behalf of `_from`
265      *
266      * @param _from The address of the sender
267      * @param _to The address of the recipient
268      * @param _value the amount to send
269      */
270     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
271         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
272         _transfer(_from, _to, _value);
273         return true;
274     }
275 
276     /**
277      * Set allowance for other address
278      *
279      * Allows `_spender` to spend no more than `_value` tokens on your behalf
280      *
281      * @param _spender The address authorized to spend
282      * @param _value the max amount they can spend
283      */
284     function approve(address _spender, uint256 _value) public
285         returns (bool success) {
286         allowance[msg.sender][_spender] = _value;
287         emit Approval(msg.sender, _spender, _value);
288         return true;
289     }
290 
291         /**
292      * Set allowance for other address and notify
293      *
294      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
295      *
296      * @param _spender The address authorized to spend
297      * @param _value the max amount they can spend
298      * @param _extraData some extra information to send to the approved contract
299      */
300     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
301         public
302         returns (bool success) {
303         tokenRecipient spender = tokenRecipient(_spender);
304         if (approve(_spender, _value)) {
305             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
306             return true;
307         }
308     }
309 
310     /**
311      * Destroy tokens
312      *
313      * Remove `_value` tokens from the system irreversibly
314      *
315      * @param _value the amount of money to burn
316      */
317     function burn(uint256 _value) public returns (bool success) {
318         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);              // Subtract from the sender
319         totalSupply = totalSupply.sub(_value);                                  // Updates totalSupply
320         emit Burn(msg.sender, _value);
321         return true;
322     }
323 
324     /**
325      * Destroy tokens from other account
326      *
327      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
328      *
329      * @param _from the address of the sender
330      * @param _value the amount of money to burn
331      */
332     function burnFrom(address _from, uint256 _value) public returns (bool success) {
333         balanceOf[_from] = balanceOf[_from].sub(_value);                                        // Subtract from the targeted balance
334         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);                // Subtract from the sender's allowance
335         totalSupply = totalSupply.sub(_value);                                                  // Update totalSupply
336         emit Burn(_from, _value);
337         return true;
338     }
339 
340 }
341 
342 
343 contract BAMToken is ERC20Token, Ownable,Pausable{
344 
345     mapping (address => bool) public frozenAccount;
346 
347     mapping(address => uint256) public lockedAccount;
348 
349     event FreezeAccount(address account, bool frozen);
350 
351     event LockAccount(address account,uint256 unlockTime);
352 
353     address myWallet = address(0xB35Df32e9B80aB3E0B9Ef8058fCE4aEA370610d7);
354 
355     constructor()Ownable(myWallet) ERC20Token(myWallet, 10000000000,"BAMONG COIN","BAM") public {
356     }
357 
358 
359     /**
360     * Freeze Account
361     */
362     function freezeAccount(address account) onlyOwner public {
363         frozenAccount[account] = true;
364         emit FreezeAccount(account, true);
365     }
366 
367 
368     /**
369     * unFreeze Account
370     */
371     function unFreezeAccount(address account) onlyOwner public{
372         frozenAccount[account] = false;
373         emit FreezeAccount(account, false);
374     }
375 
376     /**
377     * lock Account, if account is locked, fund can only transfer in but not transfer out.
378     * Can not unlockAccount, if need unlock account , pls call unlockAccount interface
379      */
380     function lockAccount(address account, uint256 unlockTime) onlyOwner public{
381         require(unlockTime > now);
382         lockedAccount[account] = unlockTime;
383         emit LockAccount(account,unlockTime);
384     }
385 
386    /**
387     * unlock Account
388      */
389     function unlockAccount(address account) onlyOwner public{
390         lockedAccount[account] = 0;
391         emit LockAccount(account,0);
392     }
393 
394 
395     function changeName(string memory newName) public onlyOwner {
396         name = newName;
397     }
398 
399     function changeSymbol(string memory newSymbol) public onlyOwner{
400         symbol = newSymbol;
401     }
402 
403     /**
404     * Internal transfer, only can be called by this contract
405     */
406     function _transfer(address _from, address _to, uint _value) internal whenNotPaused {
407         // Prevent transfer to 0x0 address. Use burn() instead
408         require(_to != address(0x0));
409 
410         //if account is frozen, then fund can not be transfer in or out.
411         require(!frozenAccount[_from]);
412         require(!frozenAccount[_to]);
413 
414         //if account is locked, then fund can only transfer in but can not transfer out.
415         require(!isAccountLocked(_from));
416 
417         balanceOf[_from] = balanceOf[_from].sub(_value);
418         balanceOf[_to] = balanceOf[_to].add(_value);
419 
420         emit Transfer(_from, _to, _value);
421     }
422 
423 
424     function isAccountLocked(address account) public view returns (bool) {
425         return lockedAccount[account] > now;
426     }
427 
428     function isAccountFrozen(address account) public view returns (bool){
429         return frozenAccount[account];
430     }
431 }