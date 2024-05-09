1 pragma solidity ^0.4.18;
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
22 contract TokenERC20 {
23     // Public variables of the token
24     string  public name;
25     string  public symbol;
26     uint8   public decimals = 18;     // 18 decimals is the strongly suggested default, avoid changing it
27     uint256 public totalSupply;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     // This notifies clients about the amount burnt
37     event Burn(address indexed from, uint256 value);
38 
39     // Constructor function.  Initializes contract with initial supply tokens to the creator of the contract
40     function TokenERC20(
41         uint256 initialSupply,
42         string tokenName,
43         string tokenSymbol
44     ) public {
45         totalSupply             = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
46         balanceOf[msg.sender]   = totalSupply;                              // Give the creator all initial tokens
47         name                    = tokenName;                                // Set the name for display purposes
48         symbol                  = tokenSymbol;                              // Set the symbol for display purposes
49     }
50 
51     // Internal transfer, only can be called by this contract
52     function _transfer(address _from, address _to, uint _value) internal {
53         require(_to != 0x0);                                                // Prevent transfer to 0x0 address. Use burn() instead
54         require(balanceOf[_from] >= _value);                                // Check if the sender has enough
55         require(balanceOf[_to] + _value > balanceOf[_to]);                  // Check for overflows
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];          // Save this for an assertion in the future
57         balanceOf[_from] -= _value;                                         // Subtract from the sender
58         balanceOf[_to] += _value;                                           // Add the same to the recipient
59         Transfer(_from, _to, _value);
60         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);      // Asserts are used to use static analysis to find bugs in your code. They should never fail
61     }
62 
63 
64     /// @notice Send `_value` (in wei, with 18 zeros) tokens to `_to` from msg.sender's account
65     /// @param _to The address of the recipient
66     /// @param _value the amount to send 
67     function transfer(address _to, uint256 _value) public {
68         _transfer(msg.sender, _to, _value);
69     }
70 
71 
72     /// @notice Transfer tokens from another address. Send `_value` (in wei, with 18 zeros) tokens to `_to` in behalf of `_from`.  `_from` must have already approved `msg.sender`
73     /// @param _from The address of the sender
74     /// @param _to The address of the recipient
75     /// @param _value the amount to send
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_value <= allowance[_from][msg.sender]);                    // Check allowance (array[approver][approvee])
78         allowance[_from][msg.sender] -= _value;                             // deduct _value from allowance
79         _transfer(_from, _to, _value);                                      // transfer
80         return true;
81     }
82 
83     /// @notice Set allowance for other address.  Allow `_spender` to spend no more than `_value` (in wei, with 18 zeros) tokens on `msg.sender` behalf
84     /// @param _spender The address authorized to spend
85     /// @param _value the max amount they can spend
86     function approve(address _spender, uint256 _value) public returns (bool success) {
87         allowance[msg.sender][_spender] = _value;                           // Create allowance (array[approver][approvee])
88         return true;
89     }
90 
91     /// @notice Set allowance for other address,then notify  Allow `_spender` to spend no more than `_value` (in wei, with 18 zeros) tokens on `msg.sender` behalf, then ping the contract about it
92     /// @param _spender The address authorized to spend
93     /// @param _value the max amount they can spend
94     /// @param _extraData some extra information to send to the approved contract
95     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
96         tokenRecipient spender = tokenRecipient(_spender);
97         if (approve(_spender, _value)) {
98             spender.receiveApproval(msg.sender, _value, this, _extraData);
99             return true;
100         }
101     }
102 
103     /// @notice Destroy tokens.  Remove `_value` (in wei, with 18 zeros) tokens from the system irreversibly
104     /// @param _value the amount of money to burn
105     function burn(uint256 _value) public returns (bool success) {
106         require(balanceOf[msg.sender] >= _value);                           // Check if the sender has enough
107         balanceOf[msg.sender] -= _value;                                    // Subtract from the sender
108         totalSupply -= _value;                                              // Updates totalSupply
109         Burn(msg.sender, _value);
110         return true;
111     }
112 
113 
114     /// @notice Destroy tokens in another account.  Remove `_value` (in wei, with 18 zeros) tokens from the system irreversibly, on behalf of `_from`. `_from` must have already approved `msg.sender`
115     /// @param _from the address of the sender
116     /// @param _value the amount of money to burn
117     function burnFrom(address _from, uint256 _value) public returns (bool success) {
118         require(balanceOf[_from] >= _value);                                // Check if the targeted balance is enough
119         require(_value <= allowance[_from][msg.sender]);                    // Check allowance.  `_from` must have already approved `msg.sender`
120         balanceOf[_from] -= _value;                                         // Subtract from the targeted balance
121         allowance[_from][msg.sender] -= _value;                             // Subtract from the sender's allowance
122         totalSupply -= _value;                                              // Update totalSupply
123         Burn(_from, _value);
124         return true;
125     }
126 }
127 
128 /******************************************/
129 /*       TRADESMAN TOKEN STARTS HERE      */
130 /******************************************/
131 
132 contract Tradesman is owned, TokenERC20 {
133 
134     uint256 public sellPrice;
135     uint256 public sellMultiplier;  // allows token to be valued at < 1 ETH
136     uint256 public buyPrice;
137     uint256 public buyMultiplier;   // allows token to be valued at < 1 ETH
138 
139     mapping (address => bool) public frozenAccount;
140 
141     // This generates a public event on the blockchain that will notify clients
142     event FrozenFunds(address target, bool frozen);
143 
144     // Initializes contract with initial supply tokens to the creator of the contract
145     function Tradesman(
146         uint256 initialSupply,
147         string tokenName,
148         string tokenSymbol
149     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
150 
151     // Internal transfer, only can be called by this contract
152     // value in wei, with 18 zeros
153     function _transfer(address _from, address _to, uint _value) internal {
154         require (_to != 0x0);                                               // Prevent transfer to 0x0 address. Use burn() instead
155         require (balanceOf[_from] >= _value);                               // Check if the sender has enough
156         require (balanceOf[_to] + _value > balanceOf[_to]);                 // Check for overflows
157         require (!frozenAccount[_from]);                                    // Check if sender is frozen
158         require (!frozenAccount[_to]);                                      // Check if recipient is frozen
159         balanceOf[_from] -= _value;                                         // Subtract from the sender
160         balanceOf[_to] += _value;                                           // Add the same to the recipient
161         Transfer(_from, _to, _value);
162     }
163 
164     /* we disable minting.  Fixed supply.
165     
166     /// @notice Create `mintedAmount` tokens and send it to `target`
167     /// @param target Address to receive the tokens
168     /// @param mintedAmount the amount of tokens (in wei, with 18 zeros) it will receive
169     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
170         balanceOf[target] += mintedAmount;
171         totalSupply += mintedAmount;
172         Transfer(0, this, mintedAmount);
173         Transfer(this, target, mintedAmount);
174     }
175     */
176 
177     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens, if ordered by law
178     /// @param target Address to be frozen
179     /// @param freeze either to freeze it or not
180     function freezeAccount(address target, bool freeze) onlyOwner public {
181         frozenAccount[target] = freeze;
182         FrozenFunds(target, freeze);
183     }
184 
185     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth. Multipliers allow for token value < 1 ETH
186     /// @param newSellPrice Price the users can sell to the contract
187     /// @param newBuyPrice Price users can buy from the contract
188     /// @param newSellMultiplier Allows token value < 1 ETH. num_eth = num_tokens * (sellPrice / sellMultiplier)
189     /// @param newBuyMultiplier Allows token value < 1 ETH.  num_tokens = num_eth * (buyMultiplier / buyPrice)
190     function setPrices(uint256 newSellPrice, uint256 newSellMultiplier, uint256 newBuyPrice, uint256 newBuyMultiplier) onlyOwner public {
191         sellPrice       = newSellPrice;                                     // sellPrice should be less than buyPrice
192         sellMultiplier  = newSellMultiplier;                                // so buyPrice cannot be 1 if also selling
193         buyPrice        = newBuyPrice;                                      // Suggest buyPrice = 10, buyMultiplier = 100000, for 10000:1 TRD:ETH
194         buyMultiplier   = newBuyMultiplier;                                 // then    sellPrice = 5, sellMultiplier = 100000
195     }
196 
197     //  Set `buyMultiplier` = 0 after all tokens sold.  We can still accept donations.
198     /// @notice Automatically buy tokens from contract by sending ether (no `data` required).
199     function () payable public {
200         uint amount = msg.value * buyMultiplier / buyPrice;                 // calculates the amount.  Multiplier allows token value < 1 ETH
201         _transfer(this, msg.sender, amount);                                // makes the transfers
202     }
203     
204     //  Set `buyMultiplier` = 0 after all tokens sold.
205     /// @notice Buy tokens from contract by sending ether, with `data` = `0xa6f2ae3a`. 
206     function buy() payable public {
207         require (buyMultiplier > 0);                                        // if no more tokens, make Tx fail.
208         uint amount = msg.value * buyMultiplier / buyPrice;                 // calculates the amount.  Multiplier allows token value < 1 ETH
209         _transfer(this, msg.sender, amount);                                // makes the transfers
210     }
211     
212     //  Set `sellMultiplier` = 0 after all tokens sold.
213     /// @notice Sell `amount` tokens to contract
214     /// @param amount amount of tokens to be sold
215     function sell(uint256 amount) public {
216         require (sellMultiplier > 0);                                       // if not buying back tokens, make Tx fail.
217         require(this.balance >= amount * sellPrice / sellMultiplier);       // checks if the contract has enough ether to buy.    Multiplier allows token value < 1 ETH
218         _transfer(msg.sender, this, amount);                                // makes the transfers
219         msg.sender.transfer(amount * sellPrice / sellMultiplier);           // sends ether to the seller. It's important to do this last to avoid recursion attacks
220     }
221     
222     /// @notice Allow contract to transfer ether directly
223     /// @param _to address of destination
224     /// @param _value amount of ETH to transfer
225     function etherTransfer(address _to, uint _value) onlyOwner public {
226         _to.transfer(_value);
227     }
228     
229     /// @notice generic transfer function can interact with contracts by supplying data / function calls
230     /// @param _to address of destination
231     /// @param _value amount of ETH to transfer
232     /// @param _data data bytes
233     function genericTransfer(address _to, uint _value, bytes _data) onlyOwner public {
234          require(_to.call.value(_value)(_data));
235     }
236 
237     //  transfer out tokens (can be done with the generic transfer function by supplying the function signature and parameters)
238     /// @notice Allow contract to transfer tokens directly
239     /// @param _to address of destination
240     /// @param _value amount of ETH to transfer
241     function tokenTransfer(address _to, uint _value) onlyOwner public {
242          _transfer(this, _to, _value);                               // makes the transfers
243     }
244         
245 }