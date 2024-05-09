1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 is owned {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 2;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply ;  // Update total supply
51         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != 0x0);
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /**
78      * Transfer tokens
79      *
80      * Send `_value` tokens to `_to` from your account
81      *
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transfer(address _to, uint256 _value) public {
86         _transfer(msg.sender, _to, _value);
87     }
88 
89     /**
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` in behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);     // Check allowance
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * Set allowance for other address
107      *
108      * Allows `_spender` to spend no more than `_value` tokens in your behalf
109      *
110      * @param _spender The address authorized to spend
111      * @param _value the max amount they can spend
112      */
113 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
114 	
115 	function approve(address _spender, uint256 _value) public
116         returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118 		Approval(owner, _spender, _value);
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address and notify
124      *
125      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      * @param _extraData some extra information to send to the approved contract
130      */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
132         public
133         returns (bool success) {
134         tokenRecipient spender = tokenRecipient(_spender);
135         if (approve(_spender, _value)) {
136             spender.receiveApproval(msg.sender, _value, this, _extraData);
137             return true;
138         }
139     }
140 
141     /**
142      * Destroy tokens
143      *
144      * Remove `_value` tokens from the system irreversibly
145      *
146      * @param _value the amount of money to burn
147      */
148     function burn(uint256 _value) public returns (bool success) {
149         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
150         balanceOf[msg.sender] -= _value;            // Subtract from the sender
151         totalSupply -= _value;                      // Updates totalSupply
152         Burn(msg.sender, _value);
153         return true;
154     }
155 
156     /**
157      * Destroy tokens from other account
158      *
159      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
160      *
161      * @param _from the address of the sender
162      * @param _value the amount of money to burn
163      */
164     function burnFrom(address _from, uint256 _value) public returns (bool success) {
165         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
166         require(_value <= allowance[_from][msg.sender]);    // Check allowance
167         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
168         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
169         totalSupply -= _value;                              // Update totalSupply
170         Burn(_from, _value);
171         return true;
172     }
173 }
174 
175 /**
176  * @title Pausable
177  * @dev Base contract which allows children to implement an emergency stop mechanism.
178  */
179 contract Pausable is owned {
180   event Pause();
181   event Unpause();
182 
183   bool public paused = true;
184 
185 
186   /**
187    * @dev Modifier to make a function callable only when the contract is not paused.
188    */
189   modifier whenNotPaused() {
190     require(!paused);
191     _;
192   }
193 
194   /**
195    * @dev Modifier to make a function callable only when the contract is paused.
196    */
197   modifier whenPaused() {
198     require(paused);
199     _;
200   }
201 
202   /**
203    * @dev called by the owner to pause, triggers stopped state
204    */
205   function pause() onlyOwner whenNotPaused public {
206     paused = true;
207     Pause();
208   }
209 
210   /**
211    * @dev called by the owner to unpause, returns to normal state
212    */
213   function unpause() onlyOwner whenPaused public {
214     paused = false;
215     Unpause();
216   }
217 }
218 
219 /******************************************/
220 /*       CryptoLeu TOKEN STARTS HERE       */
221 /******************************************/
222 
223 contract CryptoLeu is owned, TokenERC20, Pausable {
224 
225     uint256 public sellPrice;
226     uint256 public buyPrice;
227 
228     mapping (address => bool) public frozenAccount;
229 
230     /* This generates a public event on the blockchain that will notify clients */
231     event FrozenFunds(address target, bool frozen);
232 
233     /* Initializes contract with initial supply tokens to the creator of the contract */
234     function CryptoLeu() TokenERC20(60000000, "CryptoLeu", "LEU") public {}
235 
236     /* Internal transfer, only can be called by this contract */
237     function _transfer(address _from, address _to, uint _value) internal {
238         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
239         require (balanceOf[_from] >= _value);               // Check if the sender has enough
240         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
241         require(!frozenAccount[_from]);                     // Check if sender is frozen
242         require(!frozenAccount[_to]);                       // Check if recipient is frozen
243         balanceOf[_from] -= _value;                         // Subtract from the sender
244         balanceOf[_to] += _value;                           // Add the same to the recipient
245         Transfer(_from, _to, _value);
246     }
247 
248     /// @notice Create `mintedAmount` tokens and send it to `target`
249     /// @param target Address to receive the tokens
250     /// @param mintedAmount the amount of tokens it will receive
251     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
252         balanceOf[target] += mintedAmount;
253         totalSupply += mintedAmount;
254         Transfer(0, this, mintedAmount);
255         Transfer(this, target, mintedAmount);
256     }
257 
258     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
259     /// @param target Address to be frozen
260     /// @param freeze either to freeze it or not
261     function freezeAccount(address target, bool freeze) onlyOwner public {
262         frozenAccount[target] = freeze;
263         FrozenFunds(target, freeze);
264     }
265 
266     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
267     /// @param newSellPrice Price the users can sell to the contract
268     /// @param newBuyPrice Price users can buy from the contract
269     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
270         sellPrice = newSellPrice;
271         buyPrice = newBuyPrice;
272     }
273 
274     /// @notice Buy tokens from contract by sending ether
275     function buy() whenNotPaused payable public {
276         uint amount = msg.value / buyPrice;               // calculates the amount
277         _transfer(this, msg.sender, amount);              // makes the transfers
278     }
279 
280     /// @notice Sell `amount` tokens to contract
281     /// @param amount amount of tokens to be sold
282     function sell(uint256 amount) whenNotPaused public {
283         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
284         _transfer(msg.sender, this, amount);              // makes the transfers
285         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
286     }
287 }