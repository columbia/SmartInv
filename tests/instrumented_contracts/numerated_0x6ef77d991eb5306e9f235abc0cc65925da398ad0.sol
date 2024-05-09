1 /**
2  *Submitted for verification at Etherscan.io on 2019-02-22
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
71 
72 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
73 
74 /**
75  * @title Ownable
76  * @dev The Ownable contract has an owner address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Ownable {
80     address private _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     /**
85      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86      * account.
87      */
88     constructor () internal {
89         _owner = msg.sender;
90         emit OwnershipTransferred(address(0), _owner);
91     }
92 
93     /**
94      * @return the address of the owner.
95      */
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(isOwner());
105         _;
106     }
107 
108     /**
109      * @return true if `msg.sender` is the owner of the contract.
110      */
111     function isOwner() public view returns (bool) {
112         return msg.sender == _owner;
113     }
114 
115     /**
116      * @dev Allows the current owner to relinquish control of the contract.
117      * @notice Renouncing to ownership will leave the contract without an owner.
118      * It will not be possible to call the functions with the `onlyOwner`
119      * modifier anymore.
120      */
121     function renounceOwnership() public onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 
126     /**
127      * @dev Allows the current owner to transfer control of the contract to a newOwner.
128      * @param newOwner The address to transfer ownership to.
129      */
130     function transferOwnership(address newOwner) public onlyOwner {
131         _transferOwnership(newOwner);
132     }
133 
134     /**
135      * @dev Transfers control of the contract to a newOwner.
136      * @param newOwner The address to transfer ownership to.
137      */
138     function _transferOwnership(address newOwner) internal {
139         require(newOwner != address(0));
140         emit OwnershipTransferred(_owner, newOwner);
141         _owner = newOwner;
142     }
143 }
144 
145 
146 /**
147  * @title Pausable
148  * @dev Base contract which allows children to implement an emergency stop mechanism.
149  */
150 contract Pausable is Ownable{
151     event Paused(address account);
152     event Unpaused(address account);
153 
154     bool private _paused;
155 
156     constructor () internal {
157         _paused = false;
158     }
159 
160     /**
161      * @return true if the contract is paused, false otherwise.
162      */
163     function paused() public view returns (bool) {
164         return _paused;
165     }
166 
167     /**
168      * @dev Modifier to make a function callable only when the contract is not paused.
169      */
170     modifier whenNotPaused() {
171         require(!_paused);
172         _;
173     }
174 
175     /**
176      * @dev Modifier to make a function callable only when the contract is paused.
177      */
178     modifier whenPaused() {
179         require(_paused);
180         _;
181     }
182 
183     /**
184      * @dev called by the owner to pause, triggers stopped state
185      */
186     function pause() public onlyOwner whenNotPaused {
187         _paused = true;
188         emit Paused(msg.sender);
189     }
190 
191     /**
192      * @dev called by the owner to unpause, returns to normal state
193      */
194     function unpause() public onlyOwner whenPaused {
195         _paused = false;
196         emit Unpaused(msg.sender);
197     }
198 }
199 
200 
201 contract TokenERC20{
202     using SafeMath for uint256;
203 
204     // Public variables of the token
205     string public name;
206     string public symbol;
207     uint8 public decimals = 18;
208     // 18 decimals is the strongly suggested default, avoid changing it
209     uint256 public totalSupply;
210 
211     // This creates an array with all balances
212     mapping (address => uint256) public balanceOf;
213     mapping (address => mapping (address => uint256)) public allowance;
214 
215     // This generates a public event on the blockchain that will notify clients
216     event Transfer(address indexed from, address indexed to, uint256 value);
217     
218     // This generates a public event on the blockchain that will notify clients
219     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
220 
221     // This notifies clients about the amount burnt
222     event Burn(address indexed from, uint256 value);
223 
224     /**
225      * Constructor function
226      *
227      * Initializes contract with initial supply tokens to the creator of the contract
228      */
229     constructor(uint256 initialSupply,string memory tokenName,string memory tokenSymbol) public {
230         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
231         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
232         name = tokenName;                                   // Set the name for display purposes
233         symbol = tokenSymbol;                               // Set the symbol for display purposes
234     }
235 
236     /**
237      * Internal transfer, only can be called by this contract
238      */
239     function _transfer(address _from, address _to, uint _value) internal {
240         // Prevent transfer to 0x0 address. Use burn() instead
241         require(_to != address(0x0));
242 
243         balanceOf[_from] = balanceOf[_from].sub(_value);
244         balanceOf[_to] = balanceOf[_to].add(_value);
245 
246         emit Transfer(_from, _to, _value);
247     }
248 
249     /**
250      * Transfer tokens
251      *
252      * Send `_value` tokens to `_to` from your account
253      *
254      * @param _to The address of the recipient
255      * @param _value the amount to send
256      */
257     function transfer(address _to, uint256 _value) public returns (bool success) {
258         _transfer(msg.sender, _to, _value);
259         return true;
260     }
261 
262     /**
263      * Transfer tokens from other address
264      *
265      * Send `_value` tokens to `_to` on behalf of `_from`
266      *
267      * @param _from The address of the sender
268      * @param _to The address of the recipient
269      * @param _value the amount to send
270      */
271     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
272         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
273         _transfer(_from, _to, _value);
274         return true;
275     }
276 
277     /**
278      * Set allowance for other address
279      *
280      * Allows `_spender` to spend no more than `_value` tokens on your behalf
281      *
282      * @param _spender The address authorized to spend
283      * @param _value the max amount they can spend
284      */
285     function approve(address _spender, uint256 _value) public
286         returns (bool success) {
287         allowance[msg.sender][_spender] = _value;
288         emit Approval(msg.sender, _spender, _value);
289         return true;
290     }
291 
292     /**
293      * Set allowance for other address and notify
294      *
295      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
296      *
297      * @param _spender The address authorized to spend
298      * @param _value the max amount they can spend
299      * @param _extraData some extra information to send to the approved contract
300      */
301     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
302         public
303         returns (bool success) {
304         tokenRecipient spender = tokenRecipient(_spender);
305         if (approve(_spender, _value)) {
306             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
307             return true;
308         }
309     }
310 
311     /**
312      * Destroy tokens
313      *
314      * Remove `_value` tokens from the system irreversibly
315      *
316      * @param _value the amount of money to burn
317      */
318     function burn(uint256 _value) public returns (bool success) {
319         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);              // Subtract from the sender
320         totalSupply = totalSupply.sub(_value);                                  // Updates totalSupply
321         emit Burn(msg.sender, _value);
322         return true;
323     }
324 
325     /**
326      * Destroy tokens from other account
327      *
328      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
329      *
330      * @param _from the address of the sender
331      * @param _value the amount of money to burn
332      */
333     function burnFrom(address _from, uint256 _value) public returns (bool success) {
334         balanceOf[_from] = balanceOf[_from].sub(_value);                                        // Subtract from the targeted balance
335         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);                // Subtract from the sender's allowance
336         totalSupply = totalSupply.sub(_value);                                                  // Update totalSupply
337         emit Burn(_from, _value);
338         return true;
339     }
340 
341 }
342 
343 
344 contract MMTToken is TokenERC20, Ownable,Pausable{
345 
346     mapping (address => bool) public frozenAccount;
347 
348     event FrozenFunds(address target, bool frozen);
349 
350     constructor() TokenERC20(2000000000,"Master Mix Token","MMT") public {
351     }
352 
353     function freezeAccount(address account, bool freeze) onlyOwner public {
354         frozenAccount[account] = freeze;
355         emit FrozenFunds(account, freeze);
356     }
357 
358     function changeName(string memory newName) public onlyOwner {
359         name = newName;
360     }
361 
362     function changeSymbol(string memory newSymbol) public onlyOwner{
363         symbol = newSymbol;
364     }
365 
366     /**
367     * Internal transfer, only can be called by this contract
368     */
369     function _transfer(address _from, address _to, uint _value) internal whenNotPaused {
370         // Prevent transfer to 0x0 address. Use burn() instead
371         require(_to != address(0x0));
372 
373         require(!frozenAccount[_from]);
374         require(!frozenAccount[_to]);
375 
376         balanceOf[_from] = balanceOf[_from].sub(_value);
377         balanceOf[_to] = balanceOf[_to].add(_value);
378 
379         emit Transfer(_from, _to, _value);
380     }
381 }