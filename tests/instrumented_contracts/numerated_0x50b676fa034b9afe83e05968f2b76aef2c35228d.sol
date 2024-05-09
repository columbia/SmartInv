1 pragma solidity >=0.4.22 <0.6.0;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      * - Addition cannot overflow.
12      */
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19 
20     /**
21      * @dev Returns the subtraction of two unsigned integers, reverting on
22      * overflow (when the result is negative).
23      *
24      * Counterpart to Solidity's `-` operator.
25      *
26      * Requirements:
27      * - Subtraction cannot overflow.
28      */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      *
42      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
43      * @dev Get it via `npm install @openzeppelin/contracts@next`.
44      */
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `*` operator.
57      *
58      * Requirements:
59      * - Multiplication cannot overflow.
60      */
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63         // benefit is lost if 'b' is also tested.
64         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
65         if (a == 0) {
66             return 0;
67         }
68 
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the integer division of two unsigned integers. Reverts on
77      * division by zero. The result is rounded towards zero.
78      *
79      * Counterpart to Solidity's `/` operator. Note: this function uses a
80      * `revert` opcode (which leaves remaining gas untouched) while Solidity
81      * uses an invalid opcode to revert (consuming all remaining gas).
82      *
83      * Requirements:
84      * - The divisor cannot be zero.
85      */
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      * - The divisor cannot be zero.
100      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
101      * @dev Get it via `npm install @openzeppelin/contracts@next`.
102      */
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         // Solidity only automatically asserts when dividing by 0
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
114      * Reverts when dividing by zero.
115      *
116      * Counterpart to Solidity's `%` operator. This function uses a `revert`
117      * opcode (which leaves remaining gas untouched) while Solidity uses an
118      * invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         return mod(a, b, "SafeMath: modulo by zero");
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts with custom message when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      *
138      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
139      * @dev Get it via `npm install @openzeppelin/contracts@next`.
140      */
141     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b != 0, errorMessage);
143         return a % b;
144     }
145 }
146 
147 contract owned {
148     address public owner;
149 
150     constructor() public {
151         owner = msg.sender;
152     }
153 
154     modifier onlyOwner {
155         require(msg.sender == owner);
156         _;
157     }
158 
159     function transferOwnership(address newOwner) onlyOwner public {
160         owner = newOwner;
161     }
162 }
163 
164 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token) external; }
165 
166 contract TokenERC20 {
167     using SafeMath for uint256;
168     // Public variables of the token
169     string public name;
170     string public symbol;
171     uint8 public decimals = 18;
172     // 18 decimals is the strongly suggested default, avoid changing it
173     uint256 public totalSupply;
174 
175     // This creates an array with all balances
176     mapping (address => uint256) public balanceOf;
177     mapping (address => mapping (address => uint256)) public allowance;
178 
179     // This generates a public event on the blockchain that will notify clients
180     event Transfer(address indexed from, address indexed to, uint256 value);
181     
182     // This generates a public event on the blockchain that will notify clients
183     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
184 
185     // This notifies clients about the amount burnt
186     event Burn(address indexed from, uint256 value);
187 
188     /**
189      * Constrctor function
190      *
191      * Initializes contract with initial supply tokens to the creator of the contract
192      */
193     constructor(
194         uint256 initialSupply,
195         string memory tokenName,
196         string memory tokenSymbol
197     ) public {
198         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
199         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
200         name = tokenName;                                       // Set the name for display purposes
201         symbol = tokenSymbol;                                   // Set the symbol for display purposes
202     }
203 
204     /**
205      * Internal transfer, only can be called by this contract
206      */
207     function _transfer(address _from, address _to, uint _value) internal {
208         // Prevent transfer to 0x0 address. Use burn() instead
209         require(_to != address(0x0));
210         // Check if the sender has enough
211         require(balanceOf[_from] >= _value);
212         // Check for overflows
213         require(balanceOf[_to] + _value > balanceOf[_to]);
214         // Save this for an assertion in the future
215         uint previousBalances = balanceOf[_from] + balanceOf[_to];
216         // Subtract from the sender
217         balanceOf[_from] -= _value;
218         // Add the same to the recipient
219         balanceOf[_to] += _value;
220         emit Transfer(_from, _to, _value);
221         // Asserts are used to use static analysis to find bugs in your code. They should never fail
222         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
223     }
224 
225     /**
226      * Transfer tokens
227      *
228      * Send `_value` tokens to `_to` from your account
229      *
230      * @param _to The address of the recipient
231      * @param _value the amount to send
232      */
233     function transfer(address _to, uint256 _value) public returns (bool success) {
234         _transfer(msg.sender, _to, _value);
235         return true;
236     }
237 
238     /**
239      * Transfer tokens from other address
240      *
241      * Send `_value` tokens to `_to` in behalf of `_from`
242      *
243      * @param _from The address of the sender
244      * @param _to The address of the recipient
245      * @param _value the amount to send
246      */
247     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
248         require(_value <= allowance[_from][msg.sender]);     // Check allowance
249         allowance[_from][msg.sender] -= _value;
250         _transfer(_from, _to, _value);
251         return true;
252     }
253 
254     /**
255      * Set allowance for other address
256      *
257      * Allows `_spender` to spend no more than `_value` tokens in your behalf
258      *
259      * @param _spender The address authorized to spend
260      * @param _value the max amount they can spend
261      */
262     function approve(address _spender, uint256 _value) public
263         returns (bool success) {
264         allowance[msg.sender][_spender] = _value;
265         emit Approval(msg.sender, _spender, _value);
266         return true;
267     }
268 
269     /**
270      * Set allowance for other address and notify
271      *
272      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
273      *
274      * @param _spender The address authorized to spend
275      * @param _value the max amount they can spend
276      */
277     function approveAndCall(address _spender, uint256 _value)
278         public
279         returns (bool success) {
280         tokenRecipient spender = tokenRecipient(_spender);
281         if (approve(_spender, _value)) {
282             spender.receiveApproval(msg.sender, _value, address(this));
283             return true;
284         }
285     }
286 
287     /**
288      * Destroy tokens
289      *
290      * Remove `_value` tokens from the system irreversibly
291      *
292      * @param _value the amount of money to burn
293      */
294     function burn(uint256 _value) public returns (bool success) {
295         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
296         balanceOf[msg.sender] -= _value;            // Subtract from the sender
297         totalSupply -= _value;                      // Updates totalSupply
298         emit Burn(msg.sender, _value);
299         return true;
300     }
301 
302     /**
303      * Destroy tokens from other account
304      *
305      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
306      *
307      * @param _from the address of the sender
308      * @param _value the amount of money to burn
309      */
310     function burnFrom(address _from, uint256 _value) public returns (bool success) {
311         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
312         require(_value <= allowance[_from][msg.sender]);    // Check allowance
313         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
314         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
315         totalSupply -= _value;                              // Update totalSupply
316         emit Burn(_from, _value);
317         return true;
318     }
319 }
320 
321 /******************************************/
322 /*       ADVANCED TOKEN STARTS HERE       */
323 /******************************************/
324 
325 contract TWQToken is owned, TokenERC20 {
326     using SafeMath for uint256;
327     uint256 public sellPrice;
328     uint256 public buyPrice;
329 
330     mapping (address => bool) public frozenAccount;
331 
332     /* This generates a public event on the blockchain that will notify clients */
333     event FrozenFunds(address target, bool frozen);
334 
335     /* Initializes contract with initial supply tokens to the creator of the contract */
336     constructor(
337         uint256 initialSupply,
338         string memory tokenName,
339         string memory tokenSymbol
340     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
341 
342     /* Internal transfer, only can be called by this contract */
343     function _transfer(address _from, address _to, uint _value) internal {
344         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
345         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
346         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
347         require(!frozenAccount[_from]);                         // Check if sender is frozen
348         require(!frozenAccount[_to]);                           // Check if recipient is frozen
349         balanceOf[_from] -= _value;                             // Subtract from the sender
350         balanceOf[_to] += _value;                               // Add the same to the recipient
351         emit Transfer(_from, _to, _value);
352     }
353 
354     /// @notice Create `mintedAmount` tokens and send it to `target`
355     /// @param target Address to receive the tokens
356     /// @param mintedAmount the amount of tokens it will receive
357     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
358         balanceOf[target] += mintedAmount;
359         totalSupply += mintedAmount;
360         emit Transfer(address(0), address(this), mintedAmount);
361         emit Transfer(address(this), target, mintedAmount);
362     }
363 
364     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
365     /// @param target Address to be frozen
366     /// @param freeze either to freeze it or not
367     function freezeAccount(address target, bool freeze) onlyOwner public {
368         frozenAccount[target] = freeze;
369         emit FrozenFunds(target, freeze);
370     }
371 
372     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
373     /// @param newSellPrice Price the users can sell to the contract
374     /// @param newBuyPrice Price users can buy from the contract
375     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
376         sellPrice = newSellPrice;
377         buyPrice = newBuyPrice;
378     }
379 
380     /// @notice Buy tokens from contract by sending ether
381     function buy() payable public {
382         uint amount = msg.value / buyPrice;                 // calculates the amount
383         _transfer(address(this), msg.sender, amount);       // makes the transfers
384     }
385 
386     /// @notice Sell `amount` tokens to contract
387     /// @param amount amount of tokens to be sold
388     function sell(uint256 amount) public {
389         address myAddress = address(this);
390         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
391         _transfer(msg.sender, address(this), amount);       // makes the transfers
392         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
393     }
394 }