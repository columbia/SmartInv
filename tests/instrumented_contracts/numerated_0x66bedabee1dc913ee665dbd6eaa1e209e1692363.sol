1 pragma solidity >=0.5.2 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     int256 constant private INT256_MIN = -2**255;
9 
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Multiplies two signed integers, reverts on overflow.
29     */
30     function mul(int256 a, int256 b) internal pure returns (int256) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34         if (a == 0) {
35             return 0;
36         }
37 
38         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
39 
40         int256 c = a * b;
41         require(c / a == b);
42 
43         return c;
44     }
45 
46     /**
47     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
48     */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
60     */
61     function div(int256 a, int256 b) internal pure returns (int256) {
62         require(b != 0); // Solidity only automatically asserts when dividing by 0
63         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
64 
65         int256 c = a / b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72     */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b <= a);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81     * @dev Subtracts two signed integers, reverts on overflow.
82     */
83     function sub(int256 a, int256 b) internal pure returns (int256) {
84         int256 c = a - b;
85         require((b >= 0 && c <= a) || (b < 0 && c > a));
86 
87         return c;
88     }
89 
90     /**
91     * @dev Adds two unsigned integers, reverts on overflow.
92     */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a);
96 
97         return c;
98     }
99 
100     /**
101     * @dev Adds two signed integers, reverts on overflow.
102     */
103     function add(int256 a, int256 b) internal pure returns (int256) {
104         int256 c = a + b;
105         require((b >= 0 && c >= a) || (b < 0 && c < a));
106 
107         return c;
108     }
109 
110     /**
111     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
112     * reverts when dividing by zero.
113     */
114     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b != 0);
116         return a % b;
117     }
118 }
119 
120 contract owned {
121     address public owner;
122 
123     constructor() public {
124         owner = msg.sender;
125     }
126 
127     modifier onlyOwner {
128         require(msg.sender == owner);
129         _;
130     }
131 
132     function transferOwnership(address newOwner) onlyOwner public {
133         owner = newOwner;
134     }
135 }
136 
137 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
138 
139 contract TokenERC20 {
140     using SafeMath for uint256;
141     
142     // Public variables of the token
143     string public name;
144     string public symbol;
145     uint8 public decimals = 18;
146     // 18 decimals is the strongly suggested default, avoid changing it
147     uint256 public totalSupply;
148 
149     // This creates an array with all balances
150     mapping (address => uint256) public balanceOf;
151     mapping (address => mapping (address => uint256)) public allowance;
152 
153     // This generates a public event on the blockchain that will notify clients
154     event Transfer(address indexed from, address indexed to, uint256 value);
155     
156     // This generates a public event on the blockchain that will notify clients
157     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
158 
159     // This notifies clients about the amount burnt
160     event Burn(address indexed from, uint256 value);
161 
162     /**
163      * Constrctor function
164      *
165      * Initializes contract with initial supply tokens to the creator of the contract
166      */
167     constructor(
168         uint256 initialSupply,
169         string memory tokenName,
170         string memory tokenSymbol
171     ) public {
172         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
173         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
174         name = tokenName;                                       // Set the name for display purposes
175         symbol = tokenSymbol;                                   // Set the symbol for display purposes
176     }
177 
178     /**
179      * Internal transfer, only can be called by this contract
180      */
181     function _transfer(address _from, address _to, uint _value) internal {
182         // Prevent transfer to 0x0 address. Use burn() instead
183         require(_to != address(0x0));
184         // Check if the sender has enough
185         require(balanceOf[_from] >= _value);
186         // Check for overflows
187         require(balanceOf[_to] + _value > balanceOf[_to]);
188         // Subtract from the sender
189         balanceOf[_from] -= _value;
190         // Add the same to the recipient
191         balanceOf[_to] += _value;
192         emit Transfer(_from, _to, _value);
193     }
194 
195     /**
196      * Transfer tokens
197      *
198      * Send `_value` tokens to `_to` from your account
199      *
200      * @param _to The address of the recipient
201      * @param _value the amount to send
202      */
203     function transfer(address _to, uint256 _value) public returns (bool success) {
204         _transfer(msg.sender, _to, _value);
205         return true;
206     }
207 
208     /**
209      * Transfer tokens from other address
210      *
211      * Send `_value` tokens to `_to` in behalf of `_from`
212      *
213      * @param _from The address of the sender
214      * @param _to The address of the recipient
215      * @param _value the amount to send
216      */
217     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
218         require(_value <= allowance[_from][msg.sender]);     // Check allowance
219         allowance[_from][msg.sender] -= _value;
220         _transfer(_from, _to, _value);
221         return true;
222     }
223 
224     /**
225      * Set allowance for other address
226      *
227      * Allows `_spender` to spend no more than `_value` tokens in your behalf
228      *
229      * @param _spender The address authorized to spend
230      * @param _value the max amount they can spend
231      */
232     function approve(address _spender, uint256 _value) public
233         returns (bool success) {
234         allowance[msg.sender][_spender] = _value;
235         emit Approval(msg.sender, _spender, _value);
236         return true;
237     }
238 
239     /**
240      * Set allowance for other address and notify
241      *
242      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
243      *
244      * @param _spender The address authorized to spend
245      * @param _value the max amount they can spend
246      * @param _extraData some extra information to send to the approved contract
247      */
248     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
249         public
250         returns (bool success) {
251         tokenRecipient spender = tokenRecipient(_spender);
252         if (approve(_spender, _value)) {
253             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
254             return true;
255         }
256     }
257 
258     /**
259      * Destroy tokens
260      *
261      * Remove `_value` tokens from the system irreversibly
262      *
263      * @param _value the amount of money to burn
264      */
265     function burn(uint256 _value) public returns (bool success) {
266         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
267         balanceOf[msg.sender] -= _value;            // Subtract from the sender
268         totalSupply -= _value;                      // Updates totalSupply
269         emit Burn(msg.sender, _value);
270         return true;
271     }
272 
273     /**
274      * Destroy tokens from other account
275      *
276      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
277      *
278      * @param _from the address of the sender
279      * @param _value the amount of money to burn
280      */
281     function burnFrom(address _from, uint256 _value) public returns (bool success) {
282         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
283         require(_value <= allowance[_from][msg.sender]);    // Check allowance
284         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
285         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
286         totalSupply -= _value;                              // Update totalSupply
287         emit Burn(_from, _value);
288         return true;
289     }
290 }
291 
292 /******************************************/
293 /*       ADVANCED TOKEN STARTS HERE       */
294 /******************************************/
295 
296 contract IUToken is owned, TokenERC20 {
297 
298     uint256 public sellPrice;
299     uint256 public buyPrice;
300 
301     mapping (address => bool) public frozenAccount;
302 
303     /* This generates a public event on the blockchain that will notify clients */
304     event FrozenFunds(address target, bool frozen);
305 
306     /* Initializes contract with initial supply tokens to the creator of the contract */
307     constructor(
308         uint256 initialSupply,
309         string memory tokenName,
310         string memory tokenSymbol
311     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
312         buyPrice = 10 ** uint256(decimals) / 100000;
313     }
314 
315     /* Internal transfer, only can be called by this contract */
316     function _transfer(address _from, address _to, uint _value) internal {
317         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
318         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
319         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
320         require(!frozenAccount[_from]);                         // Check if sender is frozen
321         require(!frozenAccount[_to]);                           // Check if recipient is frozen
322         balanceOf[_from] -= _value;                             // Subtract from the sender
323         balanceOf[_to] += _value;                               // Add the same to the recipient
324         emit Transfer(_from, _to, _value);
325     }
326 
327     /// @notice Create `mintedAmount` tokens and send it to `target`
328     /// @param target Address to receive the tokens
329     /// @param mintedAmount the amount of tokens it will receive
330     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
331         balanceOf[target] += mintedAmount;
332         totalSupply += mintedAmount;
333         emit Transfer(address(0), address(this), mintedAmount);
334         emit Transfer(address(this), target, mintedAmount);
335     }
336 
337     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
338     /// @param target Address to be frozen
339     /// @param freeze either to freeze it or not
340     function freezeAccount(address target, bool freeze) onlyOwner public {
341         frozenAccount[target] = freeze;
342         emit FrozenFunds(target, freeze);
343     }
344 
345     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
346     /// @param newSellPrice Price the users can sell to the contract
347     /// @param newBuyPrice Price users can buy from the contract
348     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
349         sellPrice = newSellPrice;
350         buyPrice = newBuyPrice;
351     }
352 
353     /// @notice Buy tokens from contract by sending ether
354     function buy() payable public {
355         uint amount = msg.value / buyPrice;                 // calculates the amount
356         _transfer(address(this), msg.sender, amount);       // makes the transfers
357     }
358 
359     /// @notice Sell `amount` tokens to contract
360     /// @param amount amount of tokens to be sold
361     function sell(uint256 amount) public {
362         address myAddress = address(this);
363         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
364         _transfer(msg.sender, address(this), amount);       // makes the transfers
365         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
366     }
367 }