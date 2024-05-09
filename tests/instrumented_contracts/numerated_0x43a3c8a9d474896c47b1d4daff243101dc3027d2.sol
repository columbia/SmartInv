1 pragma solidity ^0.4.24;
2 
3 /**
4  ** media spread blockchain
5  ** MSCT 201807(The media spread blockchain)
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a / b;
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 
51 }
52 
53 /**
54  * @title owned
55  * @dev The owned contract has an owner address, and provides basic authorization
56  *      control functions, this simplifies the implementation of "user permissions".
57  */
58 contract owned {
59     address public owner;
60     /**
61      * @dev The owned constructor sets the original `owner` of the contract to the sender
62      * account.
63      */
64     function owned() public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      */
79     function transferOwnership(address newOwner) onlyOwner public {
80         require(newOwner != address(0));
81         owner = newOwner;
82     }
83 }
84 
85 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
86 
87 contract TokenERC20 {
88     using SafeMath for uint;
89     // Public variables of the token
90     string public name = "media spread blockchain";
91     string public symbol = "MSCT";
92     uint8 public decimals = 18;
93     // 18 decimals is the strongly suggested default, avoid changing it
94     uint256 public totalSupply = 5000000000 * 10 ** uint256(decimals);
95 
96     // This creates an array with all balances
97     mapping (address => uint256) public balanceOf;
98     mapping (address => mapping (address => uint256)) public allowance;
99 
100     // This generates a public event on the blockchain that will notify clients
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     // This notifies clients about the amount burnt
104     event Burn(address indexed from, uint256 value);
105 
106     /**
107      * Constrctor function
108      *
109      * Initializes contract with initial supply tokens to the creator of the contract
110      */
111     function TokenERC20(
112         uint256 initialSupply,
113         string tokenName,
114         string tokenSymbol
115     ) public {
116         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
117         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
118         name = tokenName;                                   // Set the name for display purposes
119         symbol = tokenSymbol;                               // Set the symbol for display purposes
120     }
121 
122     /**
123      * Internal transfer, only can be called by this contract
124      */
125     function _transfer(address _from, address _to, uint _value) internal {
126         // Prevent transfer to 0x0 address. Use burn() instead
127         require(_to != 0x0);
128         // Check if the sender has enough
129         require(balanceOf[_from] >= _value);
130         // Check for overflows
131         require(balanceOf[_to] + _value > balanceOf[_to]);
132         // Save this for an assertion in the future
133         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
134         // Subtract from the sender
135         balanceOf[_from] = balanceOf[_from].sub(_value);
136         // Add the same to the recipient
137         balanceOf[_to] = balanceOf[_to].add(_value);
138         emit Transfer(_from, _to, _value);
139         // Asserts are used to use static analysis to find bugs in your code. They should never fail
140         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
141     }
142 
143     /**
144      * Transfer tokens
145      *
146      * Send `_value` tokens to `_to` from your account
147      *
148      * @param _to The address of the recipient
149      * @param _value the amount to send
150      */
151     function transfer(address _to, uint256 _value) public returns (bool success) {
152         _transfer(msg.sender, _to, _value);
153         return true;
154     }
155 
156     /**
157      * Transfer tokens from other address
158      *
159      * Send `_value` tokens to `_to` in behalf of `_from`
160      *
161      * @param _from The address of the sender
162      * @param _to The address of the recipient
163      * @param _value the amount to send
164      */
165     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
166         require(_value <= allowance[_from][msg.sender]);     // Check allowance
167         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
168         _transfer(_from, _to, _value);
169         return true;
170     }
171 
172     /**
173      * Set allowance for other address
174      *
175      * Allows `_spender` to spend no more than `_value` tokens in your behalf
176      *
177      * @param _spender The address authorized to spend
178      * @param _value the max amount they can spend
179      */
180     function approve(address _spender, uint256 _value) public
181         returns (bool success) {
182         allowance[msg.sender][_spender] = _value;
183         return true;
184     }
185 
186     /**
187      * Set allowance for other address and notify
188      *
189      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
190      *
191      * @param _spender The address authorized to spend
192      * @param _value the max amount they can spend
193      * @param _extraData some extra information to send to the approved contract
194      */
195     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
196         public
197         returns (bool success) {
198         tokenRecipient spender = tokenRecipient(_spender);
199         if (approve(_spender, _value)) {
200             spender.receiveApproval(msg.sender, _value, this, _extraData);
201             return true;
202         }
203     }
204 
205     /**
206      * Destroy tokens
207      *
208      * Remove `_value` tokens from the system irreversibly
209      *
210      * @param _value the amount of money to burn
211      */
212     function burn(uint256 _value) public returns (bool success) {
213         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
214         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
215         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
216         emit Burn(msg.sender, _value);
217         return true;
218     }
219 
220     /**
221      * Destroy tokens from other account
222      *
223      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
224      *
225      * @param _from the address of the sender
226      * @param _value the amount of money to burn
227      */
228     function burnFrom(address _from, uint256 _value) public returns (bool success) {
229         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
230         require(_value <= allowance[_from][msg.sender]);    // Check allowance
231         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
232         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
233         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
234         emit Burn(_from, _value);
235         return true;
236     }
237 }
238 
239 /******************************************/
240 /*       ADVANCED TOKEN STARTS HERE       */
241 /******************************************/
242 
243 contract MSCTToken is owned, TokenERC20 {
244     using SafeMath for uint;
245     uint256 public sellPrice;
246     uint256 public buyPrice;
247 
248     mapping (address => bool) public frozenAccount;
249 
250     /* This generates a public event on the blockchain that will notify clients */
251     event FrozenFunds(address target, bool frozen);
252 
253     /* Initializes contract with initial supply tokens to the creator of the contract */
254     function MSCTToken(
255         uint256 initialSupply,
256         string tokenName,
257         string tokenSymbol
258     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
259 
260     /* Internal transfer, only can be called by this contract */
261     function _transfer(address _from, address _to, uint _value) internal {
262         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
263         require (balanceOf[_from] >= _value);               // Check if the sender has enough
264         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
265         require(!frozenAccount[_from]);                     // Check if sender is frozen
266         require(!frozenAccount[_to]);                       // Check if recipient is frozen
267         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
268         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
269         emit Transfer(_from, _to, _value);
270     }
271 
272     /// @notice Create `mintedAmount` tokens and send it to `target`
273     /// @param target Address to receive the tokens
274     /// @param mintedAmount the amount of tokens it will receive
275     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
276         balanceOf[target] = balanceOf[target].add(mintedAmount);
277         totalSupply = totalSupply.add(mintedAmount);
278         emit Transfer(0, this, mintedAmount);
279         emit Transfer(this, target, mintedAmount);
280     }
281 
282     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
283     /// @param target Address to be frozen
284     /// @param freeze either to freeze it or not
285     function freezeAccount(address target, bool freeze) onlyOwner public {
286         frozenAccount[target] = freeze;
287         emit FrozenFunds(target, freeze);
288     }
289 
290     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
291     /// @param newSellPrice Price the users can sell to the contract
292     /// @param newBuyPrice Price users can buy from the contract
293     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
294         sellPrice = newSellPrice;
295         buyPrice = newBuyPrice;
296     }
297 
298     /// @notice Buy tokens from contract by sending ether
299     function buy() payable public {
300         uint amount = msg.value / buyPrice;               // calculates the amount
301         _transfer(this, msg.sender, amount);              // makes the transfers
302     }
303 
304     /// @notice Sell `amount` tokens to contract
305     /// @param amount amount of tokens to be sold
306     function sell(uint256 amount) public {
307         address myAddress = this;
308         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
309         _transfer(msg.sender, this, amount);              // makes the transfers
310         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
311     }
312 }