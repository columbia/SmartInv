1 pragma solidity ^0.4.13;
2 contract owned {
3     /* Owner definition. */
4     address public owner; // Owner address.
5     function owned() { owner = msg.sender; }
6     modifier onlyOwner { require(msg.sender == owner); _; }
7     function transferOwnership(address newOwner) onlyOwner { owner = newOwner; }
8 }
9 contract token { 
10     /* Base token definition. */
11     string  public name;        // Name for the token.
12     string  public symbol;      // Symbol for the token.
13     uint8   public decimals;    // Number of decimals of the token.
14     uint256 public totalSupply; // Total of tokens created.
15 
16     // Array containing the balance foreach address.
17     mapping (address => uint256) public balanceOf;
18     // Array containing foreach address, an array containing each approved address and the amount of tokens it can spend.
19     mapping (address => mapping (address => uint256)) public allowance;
20 
21     /* This generates a public event on the blockchain that will notify about a transfer done. */
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     /* Initializes the contract */
25     function token(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {
26         balanceOf[msg.sender] = initialSupply; // Gives the creator all initial tokens.
27         totalSupply           = initialSupply; // Update total supply.
28         name                  = tokenName;     // Set the name for display purposes.
29         symbol                = tokenSymbol;   // Set the symbol for display purposes.
30         decimals              = decimalUnits;  // Amount of decimals for display purposes.
31     }
32 
33     /* Internal transfer, only can be called by this contract. */
34     function _transfer(address _from, address _to, uint _value) internal {
35         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead.
36         require(balanceOf[_from] > _value);                // Check if the sender has enough.
37         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows.
38         balanceOf[_from] -= _value; // Subtract from the sender.
39         balanceOf[_to]   += _value; // Add the same to the recipient.
40         Transfer(_from, _to, _value); // Notifies the blockchain about the transfer.
41     }
42 
43     /// @notice Send `_value` tokens to `_to` from your account.
44     /// @param _to The address of the recipient.
45     /// @param _value The amount to send.
46     function transfer(address _to, uint256 _value) {
47         _transfer(msg.sender, _to, _value);
48     }
49 
50     /// @notice Send `_value` tokens to `_to` in behalf of `_from`.
51     /// @param _from The address of the sender.
52     /// @param _to The address of the recipient.
53     /// @param _value The amount to send.
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
55         require(_value <= allowance[_from][msg.sender]); // Check allowance.
56         allowance[_from][msg.sender] -= _value; // Updates the allowance array, substracting the amount sent.
57         _transfer(_from, _to, _value); // Makes the transfer.
58         return true;
59     }
60 
61     /// @notice Allows `_spender` to spend a maximum of `_value` tokens in your behalf.
62     /// @param _spender The address authorized to spend.
63     /// @param _value The max amount they can spend.
64     function approve(address _spender, uint256 _value) returns (bool success) {
65         allowance[msg.sender][_spender] = _value; // Adds a new register to allowance, permiting _spender to use _value of your tokens.
66         return true;
67     }
68 }
69 
70 contract BSCToken is owned, token {
71     /* Specific token definition for -Bitcoin StartUp Capital S.A.- company. */
72     uint256 public sellPrice         = 5000000000000000;  // Price applied if someone wants to sell a token.
73     uint256 public buyPrice          = 10000000000000000; // Price applied if someone wants to buy a token.
74     bool    public closeBuy          = false;             // If true, nobody will be able to buy.
75     bool    public closeSell         = false;             // If true, nobody will be able to sell.
76     uint256 public tokensAvailable   = balanceOf[this];   // Number of tokens available for sell.
77     uint256 public distributedTokens = 0;                 // Number of tokens distributed.
78     uint256 public solvency          = this.balance;      // Amount of Ether available to pay sales.
79     uint256 public profit            = 0;                 // Shows the actual profit for the company.
80 
81     // Array containing foreach address if it's frozen or not.
82     mapping (address => bool) public frozenAccount;
83 
84     /* This generates a public event on the blockchain that will notify about an address being freezed. */
85     event FrozenFunds(address target, bool frozen);
86     /* This generates a public event on the blockchain that will notify about an addition of Ether to the contract. */
87     event LogDeposit(address sender, uint amount);
88     /* This generates a public event on the blockchain that will notify about a migration has been completed. */
89     event LogMigration(address receiver, uint amount);
90     /* This generates a public event on the blockchain that will notify about a Withdrawal of Ether from the contract. */
91     event LogWithdrawal(address receiver, uint amount);
92 
93     /* Initializes the contract */
94     function BSCToken( uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
95 
96     /* Internal transfer, only can be called by this contract */
97     function _transfer(address _from, address _to, uint _value) internal {
98         require(_to != 0x0);                               // Prevent transfer to 0x0 address. User should use burn() instead.
99         require(balanceOf[_from] >= _value);               // Check if the sender has enough.
100         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows.
101         require(!frozenAccount[_from]);                    // Check if sender is frozen.
102         require(!frozenAccount[_to]);                      // Check if recipient is frozen.
103         
104         balanceOf[_from] -= _value; // Subtracts from the sender.
105         balanceOf[_to]   += _value; // Adds the same to the recipient.
106 
107         _updateTokensAvailable(balanceOf[this]); // Update the balance of tokens available if necessary.
108         
109         Transfer(_from, _to, _value); // Notifies the blockchain about the transfer.
110     }
111 
112     /* Internal, updates the balance of tokens available. */
113     function _updateTokensAvailable(uint256 _tokensAvailable) internal {
114         tokensAvailable = _tokensAvailable;
115     }
116 
117     /* Internal, updates the balance of Ether available in order to cover potential sales. */
118     function _updateSolvency(uint256 _solvency) internal {
119         solvency = _solvency;
120     }
121 
122     /* Internal, updates the profit value */
123     function _updateProfit(uint256 _increment, bool add) internal{
124         if (add){
125             // Increase the profit value
126             profit = profit + _increment;
127         }else{
128             // Decrease the profit value
129             if(_increment > profit){
130                 profit = 0;
131             }else{
132                 profit = profit - _increment;
133             }
134         }
135     }
136 
137     /// @notice The owner sends `_value` tokens to `_to`, because `_to` have the right. The tokens migrated count as pre-distributed ones.
138     /// @param _to The address of the recipient.
139     /// @param _value The amount to send.
140     function completeMigration(address _to, uint256 _value) onlyOwner payable{
141         require( msg.value >= (_value * sellPrice) );       // Owner has to send enough ETH to proceed.
142         require((this.balance + msg.value) > this.balance); // Checks for overflows.
143         
144         //Contract has already received the Ether when this function is executed.
145         _updateSolvency(this.balance);   // Updates the value of solvency of the contract.
146         _updateProfit(msg.value, false); // Decrease profit value.
147         // Decrease because the owner invests his own Ether in order to guarantee the solvency.
148 
149         _transfer(msg.sender, _to, _value); // Transfers the tokens to the investor's address.
150         distributedTokens = distributedTokens + _value; // Increase the number of tokens distributed.
151 
152         LogMigration( _to, _value); // Notifies the blockchain about the migration taking place.
153     }
154 
155     /// @notice Create `mintedAmount` tokens and send it to `target`.
156     /// @param target Address to receive the tokens.
157     /// @param mintedAmount The amount of tokens target will receive.
158     function mintToken(address target, uint256 mintedAmount) onlyOwner {
159         balanceOf[target] += mintedAmount; // Updates target's balance.
160         totalSupply       += mintedAmount; // Updates totalSupply.
161 
162         _updateTokensAvailable(balanceOf[this]); // Update the balance of tokens available if necessary.
163         
164         Transfer(0, this, mintedAmount);      // Notifies the blockchain about the tokens created.
165         Transfer(this, target, mintedAmount); // Notifies the blockchain about the transfer to target.
166     }
167 
168     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens.
169     /// @param target Address to be frozen.
170     /// @param freeze Either to freeze target or not.
171     function freezeAccount(address target, bool freeze) onlyOwner {
172         frozenAccount[target] = freeze; // Sets the target status. True if it's frozen, False if it's not.
173         FrozenFunds(target, freeze); // Notifies the blockchain about the change of state.
174     }
175 
176     /// @notice Allow addresses to pay `newBuyPrice`ETH when buying and receive `newSellPrice`ETH when selling, foreach token bought/sold.
177     /// @param newSellPrice Price applied when an address sells its tokens, amount in WEI (1ETH = 10¹⁸WEI).
178     /// @param newBuyPrice Price applied when an address buys tokens, amount in WEI (1ETH = 10¹⁸WEI).
179     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
180         sellPrice = newSellPrice; // Updates the buying price.
181         buyPrice = newBuyPrice;   // Updates the selling price.
182     }
183 
184     /// @notice Sets the state of buy and sell operations
185     /// @param isClosedBuy True if buy operations are closed, False if opened.
186     /// @param isClosedSell True if sell operations are closed, False if opened.
187     function setStatus(bool isClosedBuy, bool isClosedSell) onlyOwner {
188         closeBuy = isClosedBuy;   // Updates the state of buy operations.
189         closeSell = isClosedSell; // Updates the state of sell operations.
190     }
191 
192     /// @notice Deposits Ether to the contract
193     function deposit() payable returns(bool success) {
194         require((this.balance + msg.value) > this.balance); // Checks for overflows.
195         
196         //Contract has already received the Ether when this function is executed.
197         _updateSolvency(this.balance);   // Updates the value of solvency of the contract.
198         _updateProfit(msg.value, false); // Decrease profit value.
199         // Decrease because deposits will be done mostly by the owner.
200         // Possible donations won't count as profit. Atleast not for the company, but in favor of the investors.
201 
202         LogDeposit(msg.sender, msg.value); // Notifies the blockchain about the Ether received.
203         return true;
204     }
205 
206     /// @notice The owner withdraws Ether from the contract.
207     /// @param amountInWeis Amount of ETH in WEI which will be withdrawed.
208     function withdraw(uint amountInWeis) onlyOwner {
209         LogWithdrawal(msg.sender, amountInWeis); // Notifies the blockchain about the withdrawal.
210         _updateSolvency( (this.balance - amountInWeis) ); // Updates the value of solvency of the contract.
211         _updateProfit(amountInWeis, true);                // Increase the profit value.
212         owner.transfer(amountInWeis); // Sends the Ether to owner address.
213     }
214 
215     /// @notice Buy tokens from contract by sending Ether.
216     function buy() payable {
217         require(!closeBuy); // Buy operations must be opened.
218         uint amount = msg.value / buyPrice; // Calculates the amount of tokens to be sent.
219         uint256 profit_in_transaction = msg.value - (amount * sellPrice); // Calculates the relative profit for this transaction.
220         require( profit_in_transaction > 0 );
221 
222         //Contract has already received the Ether when this function is executed.
223         _transfer(this, msg.sender, amount); // Makes the transfer of tokens.
224         distributedTokens = distributedTokens + amount; // Increase the number of tokens distributed.
225         _updateSolvency(this.balance - profit_in_transaction);   // Updates the value of solvency of the contract.
226         _updateProfit(profit_in_transaction, true);              // Increase the profit value.
227         owner.transfer(profit_in_transaction); // Sends profit to the owner of the contract.
228     }
229 
230     /// @notice Sell `amount` tokens to the contract.
231     /// @param amount amount of tokens to be sold.
232     function sell(uint256 amount) {
233         require(!closeSell); // Sell operations must be opened.
234         require(this.balance >= amount * sellPrice); // Checks if the contract has enough Ether to buy.
235         
236         _transfer(msg.sender, this, amount); // Makes the transfer of tokens, the contract receives the tokens.
237         distributedTokens = distributedTokens - amount; // Decrease the number of tokens distributed.
238         _updateSolvency( (this.balance - (amount * sellPrice)) ); // Updates the value of solvency of the contract.
239         msg.sender.transfer(amount * sellPrice); // Sends Ether to the seller.
240     }
241 }