1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 // I HATE SafeMath
109 
110 contract owned {
111     address public owner;
112 
113     constructor() public {
114         owner = msg.sender;
115     }
116 
117     modifier onlyOwner {
118         require(msg.sender == owner);
119         _;
120     }
121 
122     function transferOwnership(address newOwner) onlyOwner public {
123         owner = newOwner;
124     }
125 }
126 
127 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
128 
129 contract TokenERC20 {
130     using SafeMath for uint256;
131 
132     // Public variables of the token
133     string public name;
134     string public symbol;
135     uint8 public decimals = 18;
136     // 18 decimals is the strongly suggested default, avoid changing it
137     uint256 public totalSupply;
138 
139     // This creates an array with all balances
140     mapping (address => uint256) public balanceOf;
141     mapping (address => mapping (address => uint256)) public allowance;
142 
143     // This generates a public event on the blockchain that will notify clients
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     // This generates a public event on the blockchain that will notify clients
147     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
148 
149     // This notifies clients about the amount burnt
150     event Burn(address indexed from, uint256 value);
151 
152     /**
153      * Constrctor function
154      *
155      * Initializes contract with initial supply tokens to the creator of the contract
156      */
157     constructor(
158         uint256 initialSupply,
159         string memory tokenName,
160         string memory tokenSymbol
161     ) public {
162         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
163         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
164         name = tokenName;                                       // Set the name for display purposes
165         symbol = tokenSymbol;                                   // Set the symbol for display purposes
166     }
167 
168     /**
169      * Internal transfer, only can be called by this contract
170      */
171     function _transfer(address _from, address _to, uint _value) internal {
172         // Prevent transfer to 0x0 address. Use burn() instead
173         require(_to != address(0x0));
174         // Check if the sender has enough
175         require(balanceOf[_from] >= _value);
176         // Check for overflows
177         require(balanceOf[_to] + _value > balanceOf[_to]);
178         // Save this for an assertion in the future
179         uint previousBalances = balanceOf[_from] + balanceOf[_to];
180         // Subtract from the sender
181         balanceOf[_from] = balanceOf[_from].sub(_value);
182         // Add the same to the recipient
183         balanceOf[_to] = balanceOf[_to].add(_value);
184         emit Transfer(_from, _to, _value);
185         // Asserts are used to use static analysis to find bugs in your code. They should never fail
186         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
187     }
188 
189     /**
190      * Transfer tokens
191      *
192      * Send `_value` tokens to `_to` from your account
193      *
194      * @param _to The address of the recipient
195      * @param _value the amount to send
196      */
197     function transfer(address _to, uint256 _value) public returns (bool success) {
198         _transfer(msg.sender, _to, _value);
199         return true;
200     }
201 
202     /**
203      * Transfer tokens from other address
204      *
205      * Send `_value` tokens to `_to` in behalf of `_from`
206      *
207      * @param _from The address of the sender
208      * @param _to The address of the recipient
209      * @param _value the amount to send
210      */
211     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
212         require(_value <= allowance[_from][msg.sender]);     // Check allowance
213         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
214         _transfer(_from, _to, _value);
215         return true;
216     }
217 
218     /**
219      * Set allowance for other address
220      *
221      * Allows `_spender` to spend no more than `_value` tokens in your behalf
222      *
223      * @param _spender The address authorized to spend
224      * @param _value the max amount they can spend
225      */
226     function approve(address _spender, uint256 _value) public
227         returns (bool success) {
228         allowance[msg.sender][_spender] = _value;
229         emit Approval(msg.sender, _spender, _value);
230         return true;
231     }
232 
233     /**
234      * Set allowance for other address and notify
235      *
236      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
237      *
238      * @param _spender The address authorized to spend
239      * @param _value the max amount they can spend
240      * @param _extraData some extra information to send to the approved contract
241      */
242     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
243         public
244         returns (bool success) {
245         tokenRecipient spender = tokenRecipient(_spender);
246         if (approve(_spender, _value)) {
247             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
248             return true;
249         }
250     }
251 
252     /**
253      * Destroy tokens
254      *
255      * Remove `_value` tokens from the system irreversibly
256      *
257      * @param _value the amount of money to burn
258      */
259     function burn(uint256 _value) public returns (bool success) {
260         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
261         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
262         totalSupply = balanceOf[msg.sender].sub(_value);                      // Updates totalSupply
263         emit Burn(msg.sender, _value);
264         return true;
265     }
266 
267     /**
268      * Destroy tokens from other account
269      *
270      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
271      *
272      * @param _from the address of the sender
273      * @param _value the amount of money to burn
274      */
275     function burnFrom(address _from, uint256 _value) public returns (bool success) {
276         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
277         require(_value <= allowance[_from][msg.sender]);    // Check allowance
278         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
279         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
280         totalSupply = totalSupply.sub(_value);
281         emit Burn(_from, _value);
282         return true;
283     }
284 }
285 
286 /******************************************/
287 /*       ADVANCED TOKEN STARTS HERE       */
288 /******************************************/
289 
290 contract ERC20ext is owned, TokenERC20 {
291     using SafeMath for uint256;
292     
293     mapping (address => bool) public frozenAccount;
294     mapping (address => uint256) public lockedAccount;
295     mapping (address => uint256) public lockedAmount;
296 
297     /* This generates a public event on the blockchain that will notify clients */
298     event FrozenFunds(address target, bool frozen);
299 
300     /* Initializes contract with initial supply tokens to the creator of the contract */
301     constructor(
302         uint256 initialSupply,
303         string memory tokenName,
304         string memory tokenSymbol
305     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
306 
307     /* Internal transfer, only can be called by this contract */
308     function _transfer(address _from, address _to, uint _value) internal {
309         require ((block.timestamp > lockedAccount[_from]) || lockedAmount[_from] + _value < balanceOf[_from]);
310         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
311         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
312         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
313         require(!frozenAccount[_from]);                         // Check if sender is frozen
314         require(!frozenAccount[_to]);                           // Check if recipient is frozen
315         balanceOf[_from] = balanceOf[_from].sub(_value);
316         balanceOf[_to] = balanceOf[_to].add(_value);// Add the same to the recipient
317         emit Transfer(_from, _to, _value);
318     }
319 
320     /// @notice Create `mintedAmount` tokens and send it to `target`
321     /// @param target Address to receive the tokens
322     /// @param mintedAmount the amount of tokens it will receive
323     function mintToken(address target, uint256 mintedAmount) onlyOwner public returns (bool success){
324         balanceOf[target] = balanceOf[target].add(mintedAmount);
325         totalSupply = totalSupply.add(mintedAmount);
326         // emit Transfer(address(0), address(this), mintedAmount);
327         emit Transfer(address(0), target, mintedAmount);
328         return true;
329     }
330 
331     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
332     /// @param target Address to be frozen
333     /// @param freeze either to freeze it or not
334     function freezeAccount(address target, bool freeze) onlyOwner public returns (bool success){
335         frozenAccount[target] = freeze;
336         emit FrozenFunds(target, freeze);
337         return true;
338     }
339 
340     /*
341     function harvest(address _from, address _to, uint256 _value) onlyOwner public returns (bool success){
342         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
343         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
344         balanceOf[_from] = balanceOf[_from].sub(_value);                             // Subtract from the sender
345         balanceOf[_to] = balanceOf[_to].add(_value);                               // Add the same to the recipient
346         emit Transfer(_from, _to, _value);
347         return true;
348     }
349     */
350 
351     function lock(address target, uint256 time, uint256 amount) onlyOwner public returns (bool success){
352         lockedAccount[target] = time;
353         lockedAmount[target] = amount;
354         return true;
355     }
356 }