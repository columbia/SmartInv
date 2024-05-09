1 pragma solidity ^0.4.21;
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
22 // ----------------------------------------------------------------------------
23 // ERC Token Standard #20 Interface
24 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
25 // ----------------------------------------------------------------------------
26 contract ERC20Interface {
27     function totalSupply() public constant returns (uint);
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 contract TokenERC20 {
39     // Public variables of the token
40     string public name;
41     string public symbol;
42     uint8 public decimals = 18;
43     // 18 decimals is the strongly suggested default, avoid changing it
44     uint256 public totalSupply;
45 
46     // This creates an array with all balances
47     mapping (address => uint256) public balanceOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     // This generates a public event on the blockchain that will notify clients
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     // This notifies clients about the amount burnt
54     event Burn(address indexed from, uint256 value);
55 
56     /**
57      * Constrctor function
58      *
59      * Initializes contract with initial supply tokens to the creator of the contract
60      */
61     function TokenERC20() public {
62         totalSupply = 80000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
63         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
64         name = 'LEXIT';                                   // Set the name for display purposes
65         symbol = 'LXT';                               // Set the symbol for display purposes
66     }
67 
68     /**
69      * Internal transfer, only can be called by this contract
70      */
71     function _transfer(address _from, address _to, uint _value) internal {
72         // Prevent transfer to 0x0 address. Use burn() instead
73         require(_to != 0x0);
74         // Check if the sender has enough
75         require(balanceOf[_from] >= _value);
76         // Check for overflows
77         require(balanceOf[_to] + _value > balanceOf[_to]);
78         // Save this for an assertion in the future
79         uint previousBalances = balanceOf[_from] + balanceOf[_to];
80         // Subtract from the sender
81         balanceOf[_from] -= _value;
82         // Add the same to the recipient
83         balanceOf[_to] += _value;
84         Transfer(_from, _to, _value);
85         // Asserts are used to use static analysis to find bugs in your code. They should never fail
86         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
87     }
88 
89     /**
90      * Transfer tokens
91      *
92      * Send `_value` tokens to `_to` from your account
93      *
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transfer(address _to, uint256 _value) public {
98         _transfer(msg.sender, _to, _value);
99     }
100 
101     /**
102      * Transfer tokens from other address
103      *
104      * Send `_value` tokens to `_to` in behalf of `_from`
105      *
106      * @param _from The address of the sender
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         require(_value <= allowance[_from][msg.sender]);     // Check allowance
112         allowance[_from][msg.sender] -= _value;
113         _transfer(_from, _to, _value);
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      */
125     function approve(address _spender, uint256 _value) public
126         returns (bool success) {
127         allowance[msg.sender][_spender] = _value;
128         return true;
129     }
130 
131     /**
132      * Set allowance for other address and notify
133      *
134      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
135      *
136      * @param _spender The address authorized to spend
137      * @param _value the max amount they can spend
138      * @param _extraData some extra information to send to the approved contract
139      */
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
141         public
142         returns (bool success) {
143         tokenRecipient spender = tokenRecipient(_spender);
144         if (approve(_spender, _value)) {
145             spender.receiveApproval(msg.sender, _value, this, _extraData);
146             return true;
147         }
148     }
149 
150     /**
151      * Destroy tokens
152      *
153      * Remove `_value` tokens from the system irreversibly
154      *
155      * @param _value the amount of money to burn
156      */
157     function burn(uint256 _value) public returns (bool success) {
158         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
159         balanceOf[msg.sender] -= _value;            // Subtract from the sender
160         totalSupply -= _value;                      // Updates totalSupply
161         Burn(msg.sender, _value);
162         return true;
163     }
164 
165     /**
166      * Destroy tokens from other account
167      *
168      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
169      *
170      * @param _from the address of the sender
171      * @param _value the amount of money to burn
172      */
173     function burnFrom(address _from, uint256 _value) public returns (bool success) {
174         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
175         require(_value <= allowance[_from][msg.sender]);    // Check allowance
176         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
177         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
178         totalSupply -= _value;                              // Update totalSupply
179         Burn(_from, _value);
180         return true;
181     }
182 }
183 
184 /******************************************/
185 /*       LEXIT TOKEN STARTS HERE       */
186 /******************************************/
187 
188 contract LexitToken is owned, TokenERC20 {
189 
190     uint256 public sellPrice;
191     uint256 public buyPrice;
192 
193     mapping (address => bool) public frozenAccount;
194 
195     /* This generates a public event on the blockchain that will notify clients */
196     event FrozenFunds(address target, bool frozen);
197 
198     /* Initializes contract with initial supply tokens to the creator of the contract */
199     function LexitToken() TokenERC20() public {
200         
201     }
202 
203     /* Internal transfer, only can be called by this contract */
204     function _transfer(address _from, address _to, uint _value) internal {
205         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
206         require (balanceOf[_from] >= _value);               // Check if the sender has enough
207         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
208         require(!frozenAccount[_from]);                     // Check if sender is frozen
209         require(!frozenAccount[_to]);                       // Check if recipient is frozen
210         balanceOf[_from] -= _value;                         // Subtract from the sender
211         balanceOf[_to] += _value;                           // Add the same to the recipient
212         Transfer(_from, _to, _value);
213     }
214 
215     /// @notice Create `mintedAmount` tokens and send it to `target`
216     /// @param target Address to receive the tokens
217     /// @param mintedAmount the amount of tokens it will receive
218     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
219         balanceOf[target] += mintedAmount;
220         totalSupply += mintedAmount;
221         Transfer(0, this, mintedAmount);
222         Transfer(this, target, mintedAmount);
223     }
224 
225     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
226     /// @param target Address to be frozen
227     /// @param freeze either to freeze it or not
228     function freezeAccount(address target, bool freeze) onlyOwner public {
229         frozenAccount[target] = freeze;
230         FrozenFunds(target, freeze);
231     }
232 
233     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
234     /// @param newSellPrice Price the users can sell to the contract
235     /// @param newBuyPrice Price users can buy from the contract
236     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
237         sellPrice = newSellPrice;
238         buyPrice = newBuyPrice;
239     }
240 
241     /// @notice Buy tokens from contract by sending ether
242     function buy() payable public {
243         uint amount = msg.value / buyPrice;               // calculates the amount
244         _transfer(this, msg.sender, amount);              // makes the transfers
245     }
246 
247     /// @notice Sell `amount` tokens to contract
248     /// @param amount amount of tokens to be sold
249     function sell(uint256 amount) public {
250         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
251         _transfer(msg.sender, this, amount);              // makes the transfers
252         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
253     }
254     
255     // ------------------------------------------------------------------------
256     // Owner can transfer out any accidentally sent ERC20 tokens
257     // ------------------------------------------------------------------------
258     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
259         return ERC20Interface(tokenAddress).transfer(owner, tokens);
260     }
261 }