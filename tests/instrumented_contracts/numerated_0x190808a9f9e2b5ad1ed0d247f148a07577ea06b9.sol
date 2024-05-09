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
108 
109 contract owned {
110     address public owner;
111 
112     constructor() public {
113         owner = msg.sender;
114     }
115 
116     modifier onlyOwner {
117         require(msg.sender == owner);
118         _;
119     }
120 
121     function transferOwnership(address newOwner) onlyOwner public {
122         owner = newOwner;
123     }
124 }
125 
126 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
127 
128 contract TokenERC20 {
129     using SafeMath for uint256;
130 
131     // Public variables of the token
132     string public name;
133     string public symbol;
134     uint8 public decimals = 18;
135     // 18 decimals is the strongly suggested default, avoid changing it
136     uint256 public totalSupply;
137 
138     // This creates an array with all balances
139     mapping (address => uint256) public balanceOf;
140     mapping (address => mapping (address => uint256)) public allowance;
141 
142     // This generates a public event on the blockchain that will notify clients
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 
145     // This generates a public event on the blockchain that will notify clients
146     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
147 
148     // This notifies clients about the amount burnt
149     event Burn(address indexed from, uint256 value);
150 
151     /**
152      * Constrctor function
153      *
154      * Initializes contract with initial supply tokens to the creator of the contract
155      */
156     constructor(
157         uint256 initialSupply,
158         string memory tokenName,
159         string memory tokenSymbol
160     ) public {
161         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
162         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
163         name = tokenName;                                       // Set the name for display purposes
164         symbol = tokenSymbol;                                   // Set the symbol for display purposes
165     }
166 
167     /**
168      * Internal transfer, only can be called by this contract
169      */
170     function _transfer(address _from, address _to, uint _value) internal {
171         // Prevent transfer to 0x0 address. Use burn() instead
172         require(_to != address(0x0));
173         // Check if the sender has enough
174         require(balanceOf[_from] >= _value);
175         // Check for overflows
176         require(balanceOf[_to] + _value > balanceOf[_to]);
177         // Save this for an assertion in the future
178         uint previousBalances = balanceOf[_from] + balanceOf[_to];
179         // Subtract from the sender
180         balanceOf[_from] = balanceOf[_from].sub(_value);
181         // Add the same to the recipient
182         balanceOf[_to] = balanceOf[_to].add(_value);
183         emit Transfer(_from, _to, _value);
184         // Asserts are used to use static analysis to find bugs in your code. They should never fail
185         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
186     }
187 
188     /**
189      * Transfer tokens
190      *
191      * Send `_value` tokens to `_to` from your account
192      *
193      * @param _to The address of the recipient
194      * @param _value the amount to send
195      */
196     function transfer(address _to, uint256 _value) public returns (bool success) {
197         _transfer(msg.sender, _to, _value);
198         return true;
199     }
200 
201     /**
202      * Transfer tokens from other address
203      *
204      * Send `_value` tokens to `_to` in behalf of `_from`
205      *
206      * @param _from The address of the sender
207      * @param _to The address of the recipient
208      * @param _value the amount to send
209      */
210     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
211         require(_value <= allowance[_from][msg.sender]);     // Check allowance
212         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
213         _transfer(_from, _to, _value);
214         return true;
215     }
216 
217     /**
218      * Set allowance for other address
219      *
220      * Allows `_spender` to spend no more than `_value` tokens in your behalf
221      *
222      * @param _spender The address authorized to spend
223      * @param _value the max amount they can spend
224      */
225     function approve(address _spender, uint256 _value) public
226         returns (bool success) {
227         allowance[msg.sender][_spender] = _value;
228         emit Approval(msg.sender, _spender, _value);
229         return true;
230     }
231 
232     /**
233      * Set allowance for other address and notify
234      *
235      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
236      *
237      * @param _spender The address authorized to spend
238      * @param _value the max amount they can spend
239      * @param _extraData some extra information to send to the approved contract
240      */
241     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
242         public
243         returns (bool success) {
244         tokenRecipient spender = tokenRecipient(_spender);
245         if (approve(_spender, _value)) {
246             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
247             return true;
248         }
249     }
250 
251     /**
252      * Destroy tokens
253      *
254      * Remove `_value` tokens from the system irreversibly
255      *
256      * @param _value the amount of money to burn
257      */
258     function burn(uint256 _value) public returns (bool success) {
259         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
260         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
261         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
262         emit Burn(msg.sender, _value);
263         return true;
264     }
265 
266     /**
267      * Destroy tokens from other account
268      *
269      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
270      *
271      * @param _from the address of the sender
272      * @param _value the amount of money to burn
273      */
274     function burnFrom(address _from, uint256 _value) public returns (bool success) {
275         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
276         require(_value <= allowance[_from][msg.sender]);    // Check allowance
277         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
278         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
279         totalSupply = totalSupply.sub(_value);
280         emit Burn(_from, _value);
281         return true;
282     }
283 }
284 
285 /******************************************/
286 /*       ADVANCED TOKEN STARTS HERE       */
287 /******************************************/
288 
289 contract ERC20ext is owned, TokenERC20 {
290     using SafeMath for uint256;
291     
292     mapping (address => bool) public frozenAccount;
293     mapping (address => uint256) public lockedAccount;
294     mapping (address => uint256) public lockedAmount;
295 
296     /* This generates a public event on the blockchain that will notify clients */
297     event FrozenFunds(address target, bool frozen);
298 
299     /* Initializes contract with initial supply tokens to the creator of the contract */
300     constructor(
301         uint256 initialSupply,
302         string memory tokenName,
303         string memory tokenSymbol
304     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
305 
306     /* Internal transfer, only can be called by this contract */
307     function _transfer(address _from, address _to, uint _value) internal {
308         require ((block.timestamp > lockedAccount[_from]) || lockedAmount[_from] + _value < balanceOf[_from]);
309         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
310         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
311         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
312         require(!frozenAccount[_from]);                         // Check if sender is frozen
313         require(!frozenAccount[_to]);                           // Check if recipient is frozen
314         balanceOf[_from] = balanceOf[_from].sub(_value);
315         balanceOf[_to] = balanceOf[_to].add(_value); // Add the same to the recipient
316         emit Transfer(_from, _to, _value);
317     }
318 
319     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
320     /// @param target Address to be frozen
321     /// @param freeze either to freeze it or not
322     function freezeAccount(address target, bool freeze) onlyOwner public returns (bool success){
323         frozenAccount[target] = freeze;
324         emit FrozenFunds(target, freeze);
325         return true;
326     }
327 
328     function lock(address target, uint256 time, uint256 amount) onlyOwner public returns (bool success){
329         lockedAccount[target] = time;
330         lockedAmount[target] = amount;
331         return true;
332     }
333 }