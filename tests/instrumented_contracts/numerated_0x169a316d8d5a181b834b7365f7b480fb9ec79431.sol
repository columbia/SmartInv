1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract owned {
34     address public owner;
35 
36     function owned() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) onlyOwner public {
46         owner = newOwner;
47     }
48 }
49 
50 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
51 
52 contract TokenERC20 {
53     // Public variables of the token
54     string public name;
55     string public symbol;
56     uint8 public decimals = 0;
57     // 18 decimals is the strongly suggested default, avoid changing it
58     uint256 public totalSupply;
59     using SafeMath for uint;
60 
61     // This creates an array with all balances
62     mapping (address => uint256) public balanceOf;
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65     // This generates a public event on the blockchain that will notify clients
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     // This notifies clients about the amount burnt
69     event Burn(address indexed from, uint256 value);
70 
71     /**
72      * Constrctor function
73      *
74      * Initializes contract with initial supply tokens to the creator of the contract
75      */
76     function TokenERC20(
77         uint256 initialSupply,
78         string tokenName,
79         string tokenSymbol
80     ) public {
81         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
82         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
83         name = tokenName;                                   // Set the name for display purposes
84         symbol = tokenSymbol;                               // Set the symbol for display purposes
85     }
86 
87     /**
88      * Internal transfer, only can be called by this contract
89      */
90     function _transfer(address _from, address _to, uint _value) internal {
91         // Prevent transfer to 0x0 address. Use burn() instead
92         require(_to != 0x0);
93         // Check if the sender has enough
94         require(balanceOf[_from] >= _value);
95         // Check for overflows
96         require(balanceOf[_to] + _value > balanceOf[_to]);
97         // Save this for an assertion in the future
98         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
99         // Subtract from the sender
100         balanceOf[_from] = balanceOf[_from].sub(_value);
101         // Add the same to the recipient
102         balanceOf[_to] = balanceOf[_to].add(_value);
103         Transfer(_from, _to, _value);
104         // Asserts are used to use static analysis to find bugs in your code. They should never fail
105         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
106     }
107 
108     /**
109      * Transfer tokens
110      *
111      * Send `_value` tokens to `_to` from your account
112      *
113      * @param _to The address of the recipient
114      * @param _value the amount to send
115      */
116     function transfer(address _to, uint256 _value) public {
117         _transfer(msg.sender, _to, _value);
118     }
119 
120     /**
121      * Transfer tokens from other address
122      *
123      * Send `_value` tokens to `_to` in behalf of `_from`
124      *
125      * @param _from The address of the sender
126      * @param _to The address of the recipient
127      * @param _value the amount to send
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
130         require(_value <= allowance[_from][msg.sender]);     // Check allowance
131         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
132         _transfer(_from, _to, _value);
133         return true;
134     }
135 
136     /**
137      * Set allowance for other address
138      *
139      * Allows `_spender` to spend no more than `_value` tokens in your behalf
140      *
141      * @param _spender The address authorized to spend
142      * @param _value the max amount they can spend
143      */
144     function approve(address _spender, uint256 _value) public
145         returns (bool success) {
146         allowance[msg.sender][_spender] = _value;
147         return true;
148     }
149 
150     /**
151      * Set allowance for other address and notify
152      *
153      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
154      *
155      * @param _spender The address authorized to spend
156      * @param _value the max amount they can spend
157      * @param _extraData some extra information to send to the approved contract
158      */
159     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
160         public
161         returns (bool success) {
162         tokenRecipient spender = tokenRecipient(_spender);
163         if (approve(_spender, _value)) {
164             spender.receiveApproval(msg.sender, _value, this, _extraData);
165             return true;
166         }
167     }
168 
169     /**
170      * Destroy tokens
171      *
172      * Remove `_value` tokens from the system irreversibly
173      *
174      * @param _value the amount of money to burn
175      */
176     // function burn(uint256 _value) public returns (bool success) {
177     //     require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
178     //     balanceOf[msg.sender] -= _value;            // Subtract from the sender
179     //     totalSupply -= _value;                      // Updates totalSupply
180     //     Burn(msg.sender, _value);
181     //     return true;
182     // }
183 
184     /**
185      * Destroy tokens from other account
186      *
187      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
188      *
189      * @param _from the address of the sender
190      * @param _value the amount of money to burn
191      */
192     // function burnFrom(address _from, uint256 _value) public returns (bool success) {
193     //     require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
194     //     require(_value <= allowance[_from][msg.sender]);    // Check allowance
195     //     balanceOf[_from] -= _value;                         // Subtract from the targeted balance
196     //     allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
197     //     totalSupply -= _value;                              // Update totalSupply
198     //     Burn(_from, _value);
199     //     return true;
200     // }
201 }
202 
203 /******************************************/
204 /*       ADVANCED TOKEN STARTS HERE       */
205 /******************************************/
206 
207 contract MyAdvancedToken is owned, TokenERC20 {
208 
209     uint256 public sellPrice;
210     uint256 public buyPrice;
211 
212     using SafeMath for uint;
213 
214     mapping (address => bool) public frozenAccount;
215 
216     /* This generates a public event on the blockchain that will notify clients */
217     event FrozenFunds(address target, bool frozen);
218 
219     /* Initializes contract with initial supply tokens to the creator of the contract */
220     function MyAdvancedToken(
221         uint256 initialSupply,
222         string tokenName,
223         string tokenSymbol
224     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
225 
226     /* Internal transfer, only can be called by this contract */
227     function _transfer(address _from, address _to, uint _value) internal {
228         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
229         require (balanceOf[_from] >= _value);               // Check if the sender has enough
230         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
231         require(!frozenAccount[_from]);                     // Check if sender is frozen
232         require(!frozenAccount[_to]);                       // Check if recipient is frozen
233         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
234         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
235         Transfer(_from, _to, _value);
236     }
237 
238     /// @notice Create `mintedAmount` tokens and send it to `target`
239     /// @param target Address to receive the tokens
240     /// @param mintedAmount the amount of tokens it will receive
241     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
242         balanceOf[target] = balanceOf[target].add(mintedAmount);
243         totalSupply = totalSupply.add(mintedAmount);
244         Transfer(0, this, mintedAmount);
245         Transfer(this, target, mintedAmount);
246     }
247 
248     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
249     /// @param target Address to be frozen
250     /// @param freeze either to freeze it or not
251     function freezeAccount(address target, bool freeze) onlyOwner public {
252         frozenAccount[target] = freeze;
253         FrozenFunds(target, freeze);
254     }
255 
256     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
257     /// @param newSellPrice Price the users can sell to the contract
258     /// @param newBuyPrice Price users can buy from the contract
259     // function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
260     //     sellPrice = newSellPrice;
261     //     buyPrice = newBuyPrice;
262     // }
263 
264     /// @notice Buy tokens from contract by sending ether
265     // function buy() payable public {
266     //     uint amount = msg.value / buyPrice;               // calculates the amount
267     //     _transfer(this, msg.sender, amount);              // makes the transfers
268     // }
269 
270     /// @notice Sell `amount` tokens to contract
271     /// @param amount amount of tokens to be sold
272     // function sell(uint256 amount) public {
273     //     require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
274     //     _transfer(msg.sender, this, amount);              // makes the transfers
275     //     msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
276     // }
277 }