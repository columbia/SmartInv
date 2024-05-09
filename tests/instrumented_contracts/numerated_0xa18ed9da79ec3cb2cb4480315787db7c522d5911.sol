1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a / b;
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 
46 }
47 
48 /**
49  * @title owned
50  * @dev The owned contract has an owner address, and provides basic authorization
51  *      control functions, this simplifies the implementation of "user permissions".
52  */
53 contract owned {
54     address public owner;
55     /**
56      * @dev The owned constructor sets the original `owner` of the contract to the sender
57      * account.
58      */
59     function owned() public {
60         owner = msg.sender;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     /**
72      * @dev Allows the current owner to transfer control of the contract to a newOwner.
73      */
74     function transferOwnership(address newOwner) onlyOwner public {
75         require(newOwner != address(0));
76         owner = newOwner;
77     }
78 }
79 
80 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
81 
82 contract TokenERC20 {
83     using SafeMath for uint;
84     // Public variables of the token
85     string public name = "KeyToken";
86     string public symbol = "KEYT";
87     uint8 public decimals = 18;
88     // 18 decimals is the strongly suggested default, avoid changing it
89     uint256 public totalSupply = 2000000000 * 10 ** uint256(decimals);
90 
91     // This creates an array with all balances
92     mapping (address => uint256) public balanceOf;
93     mapping (address => mapping (address => uint256)) public allowance;
94 
95     // This generates a public event on the blockchain that will notify clients
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     // This notifies clients about the amount burnt
99     event Burn(address indexed from, uint256 value);
100 
101     /**
102      * Constrctor function
103      *
104      * Initializes contract with initial supply tokens to the creator of the contract
105      */
106     function TokenERC20(
107         uint256 initialSupply,
108         string tokenName,
109         string tokenSymbol
110     ) public {
111         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
112         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
113         name = tokenName;                                   // Set the name for display purposes
114         symbol = tokenSymbol;                               // Set the symbol for display purposes
115     }
116 
117     /**
118      * Internal transfer, only can be called by this contract
119      */
120     function _transfer(address _from, address _to, uint _value) internal {
121         // Prevent transfer to 0x0 address. Use burn() instead
122         require(_to != 0x0);
123         // Check if the sender has enough
124         require(balanceOf[_from] >= _value);
125         // Check for overflows
126         require(balanceOf[_to] + _value > balanceOf[_to]);
127         // Save this for an assertion in the future
128         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
129         // Subtract from the sender
130         balanceOf[_from] = balanceOf[_from].sub(_value);
131         // Add the same to the recipient
132         balanceOf[_to] = balanceOf[_to].add(_value);
133         emit Transfer(_from, _to, _value);
134         // Asserts are used to use static analysis to find bugs in your code. They should never fail
135         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
136     }
137 
138     /**
139      * Transfer tokens
140      *
141      * Send `_value` tokens to `_to` from your account
142      *
143      * @param _to The address of the recipient
144      * @param _value the amount to send
145      */
146     function transfer(address _to, uint256 _value) public returns (bool success) {
147         _transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151     /**
152      * Transfer tokens from other address
153      *
154      * Send `_value` tokens to `_to` in behalf of `_from`
155      *
156      * @param _from The address of the sender
157      * @param _to The address of the recipient
158      * @param _value the amount to send
159      */
160     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
161         require(_value <= allowance[_from][msg.sender]);     // Check allowance
162         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
163         _transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168      * Set allowance for other address
169      *
170      * Allows `_spender` to spend no more than `_value` tokens in your behalf
171      *
172      * @param _spender The address authorized to spend
173      * @param _value the max amount they can spend
174      */
175     function approve(address _spender, uint256 _value) public
176         returns (bool success) {
177         allowance[msg.sender][_spender] = _value;
178         return true;
179     }
180 
181     /**
182      * Set allowance for other address and notify
183      *
184      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
185      *
186      * @param _spender The address authorized to spend
187      * @param _value the max amount they can spend
188      * @param _extraData some extra information to send to the approved contract
189      */
190     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
191         public
192         returns (bool success) {
193         tokenRecipient spender = tokenRecipient(_spender);
194         if (approve(_spender, _value)) {
195             spender.receiveApproval(msg.sender, _value, this, _extraData);
196             return true;
197         }
198     }
199 
200     /**
201      * Destroy tokens
202      *
203      * Remove `_value` tokens from the system irreversibly
204      *
205      * @param _value the amount of money to burn
206      */
207     function burn(uint256 _value) public returns (bool success) {
208         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
209         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
210         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
211         emit Burn(msg.sender, _value);
212         return true;
213     }
214 
215     /**
216      * Destroy tokens from other account
217      *
218      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
219      *
220      * @param _from the address of the sender
221      * @param _value the amount of money to burn
222      */
223     function burnFrom(address _from, uint256 _value) public returns (bool success) {
224         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
225         require(_value <= allowance[_from][msg.sender]);    // Check allowance
226         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
227         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
228         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
229         emit Burn(_from, _value);
230         return true;
231     }
232 }
233 
234 /******************************************/
235 /*       ADVANCED TOKEN STARTS HERE       */
236 /******************************************/
237 
238 contract KEYT is owned, TokenERC20 {
239     using SafeMath for uint;
240     uint256 public sellPrice;
241     uint256 public buyPrice;
242 
243     mapping (address => bool) public frozenAccount;
244 
245     /* This generates a public event on the blockchain that will notify clients */
246     event FrozenFunds(address target, bool frozen);
247 
248     /* Initializes contract with initial supply tokens to the creator of the contract */
249     function KEYT(
250         uint256 initialSupply,
251         string tokenName,
252         string tokenSymbol
253     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
254 
255     /* Internal transfer, only can be called by this contract */
256     function _transfer(address _from, address _to, uint _value) internal {
257         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
258         require (balanceOf[_from] >= _value);               // Check if the sender has enough
259         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
260         require(!frozenAccount[_from]);                     // Check if sender is frozen
261         require(!frozenAccount[_to]);                       // Check if recipient is frozen
262         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
263         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
264         emit Transfer(_from, _to, _value);
265     }
266 
267     /// @notice Create `mintedAmount` tokens and send it to `target`
268     /// @param target Address to receive the tokens
269     /// @param mintedAmount the amount of tokens it will receive
270     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
271         balanceOf[target] = balanceOf[target].add(mintedAmount);
272         totalSupply = totalSupply.add(mintedAmount);
273         emit Transfer(0, this, mintedAmount);
274         emit Transfer(this, target, mintedAmount);
275     }
276 
277     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
278     /// @param target Address to be frozen
279     /// @param freeze either to freeze it or not
280     function freezeAccount(address target, bool freeze) onlyOwner public {
281         frozenAccount[target] = freeze;
282         emit FrozenFunds(target, freeze);
283     }
284 
285     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
286     /// @param newSellPrice Price the users can sell to the contract
287     /// @param newBuyPrice Price users can buy from the contract
288     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
289         sellPrice = newSellPrice;
290         buyPrice = newBuyPrice;
291     }
292 
293     /// @notice Buy tokens from contract by sending ether
294     function buy() payable public {
295         uint amount = msg.value / buyPrice;               // calculates the amount
296         _transfer(this, msg.sender, amount);              // makes the transfers
297     }
298 
299     /// @notice Sell `amount` tokens to contract
300     /// @param amount amount of tokens to be sold
301     function sell(uint256 amount) public {
302         address myAddress = this;
303         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
304         _transfer(msg.sender, this, amount);              // makes the transfers
305         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
306     }
307 }