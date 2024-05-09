1 pragma solidity ^0.4.13;
2 
3 contract owned {
4     /* Owner definition. */
5     address public owner; // Owner address.
6     function owned() internal {
7         owner = msg.sender;
8     }
9     modifier onlyOwner {
10         require(msg.sender == owner); _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public{
13         owner = newOwner;
14     }
15 }
16 
17 contract token { 
18     /* Base token definition. */
19     string  public name;        // Name for the token.
20     string  public symbol;      // Symbol for the token.
21     uint8   public decimals;    // Number of decimals of the token.
22     uint256 public totalSupply; // Total of tokens created.
23 
24     // Array containing the balance foreach address.
25     mapping (address => uint256) public balanceOf;
26     // Array containing foreach address, an array containing each approved address and the amount of tokens it can spend.
27     mapping (address => mapping (address => uint256)) public allowance;
28 
29     /* This generates a public event on the blockchain that will notify about a transfer done. */
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     /* Initializes the contract */
33     function token(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) internal {
34         balanceOf[msg.sender] = initialSupply; // Gives the creator all initial tokens.
35         totalSupply           = initialSupply; // Update total supply.
36         name                  = tokenName;     // Set the name for display purposes.
37         symbol                = tokenSymbol;   // Set the symbol for display purposes.
38         decimals              = decimalUnits;  // Amount of decimals for display purposes.
39     }
40 
41     /* Internal transfer, only can be called by this contract. */
42     function _transfer(address _from, address _to, uint _value) internal {
43         require(_to != 0x0);                               // Prevent transfer to 0x0 address.
44         require(balanceOf[_from] > _value);                // Check if the sender has enough.
45         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows.
46         balanceOf[_from] -= _value; // Subtract from the sender.
47         balanceOf[_to]   += _value; // Add the same to the recipient.
48         Transfer(_from, _to, _value); // Notifies the blockchain about the transfer.
49     }
50 
51     /// @notice Send `_value` tokens to `_to` from your account.
52     /// @param _to The address of the recipient.
53     /// @param _value The amount to send.
54     function transfer(address _to, uint256 _value) public {
55         _transfer(msg.sender, _to, _value);
56     }
57 
58     /// @notice Send `_value` tokens to `_to` in behalf of `_from`.
59     /// @param _from The address of the sender.
60     /// @param _to The address of the recipient.
61     /// @param _value The amount to send.
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         require(_value <= allowance[_from][msg.sender]); // Check allowance.
64         allowance[_from][msg.sender] -= _value; // Updates the allowance array, substracting the amount sent.
65         _transfer(_from, _to, _value); // Makes the transfer.
66         return true;
67     }
68 
69     /// @notice Allows `_spender` to spend a maximum of `_value` tokens in your behalf.
70     /// @param _spender The address authorized to spend.
71     /// @param _value The max amount they can spend.
72     function approve(address _spender, uint256 _value) public returns (bool success) {
73         allowance[msg.sender][_spender] = _value; // Adds a new register to allowance, permiting _spender to use _value of your tokens.
74         return true;
75     }
76 }
77 
78 contract HormitechToken is owned, token {
79     /* Specific token definition for -HormitechToken-. */
80     uint256 public sellPrice         = 5000000000000000;  // Price applied if someone wants to sell a token.
81     uint256 public buyPrice          = 10000000000000000; // Price applied if someone wants to buy a token.
82     bool    public closeBuy          = false;             // If true, nobody will be able to buy.
83     bool    public closeSell         = false;             // If true, nobody will be able to sell.
84     uint256 public tokensAvailable   = balanceOf[this];   // Number of tokens available for sell.
85     uint256 public solvency          = this.balance;      // Amount of Ether available to pay sales.
86     uint256 public profit            = 0;                 // Shows the actual profit for the company.
87     address public comisionGetter = 0xCd8bf69ad65c5158F0cfAA599bBF90d7f4b52Bb0; // The address that gets the comisions paid.
88     mapping (address => bool) public frozenAccount; // Array containing foreach address if it's frozen or not.
89 
90     /* This generates a public event on the blockchain that will notify about an address being freezed. */
91     event FrozenFunds(address target, bool frozen);
92     /* This generates a public event on the blockchain that will notify about an addition of Ether to the contract. */
93     event LogDeposit(address sender, uint amount);
94     /* This generates a public event on the blockchain that will notify about a Withdrawal of Ether from the contract. */
95     event LogWithdrawal(address receiver, uint amount);
96 
97     /* Initializes the contract */
98     function HormitechToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) public token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
99 
100     /* Internal transfer, only can be called by this contract */
101     function _transfer(address _from, address _to, uint _value) internal {
102         require(_to != 0x0);                               // Prevent transfer to 0x0 address.
103         require(balanceOf[_from] >= _value);               // Check if the sender has enough.
104         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows.
105         require(!frozenAccount[_from]);                    // Check if sender is frozen.
106         require(!frozenAccount[_to]);                      // Check if recipient is frozen.
107 		balanceOf[_from] -= _value; // Subtracts _value tokens from the sender.
108         balanceOf[_to]   += _value; // Adds the same amount to the recipient.
109         _updateTokensAvailable(balanceOf[this]); // Update the balance of tokens available if necessary.
110         Transfer(_from, _to, _value); // Notifies the blockchain about the transfer.
111     }
112 
113     function refillTokens(uint256 _value) public onlyOwner{
114         // Owner sends tokens to the contract.
115         _transfer(msg.sender, this, _value);
116     }
117 
118     /* Overrides basic transfer function due to comision value */
119     function transfer(address _to, uint256 _value) public {
120     	// This function requires a comision value of 0.4% of the market value.
121         uint market_value = _value * sellPrice;
122         uint comision = market_value * 4 / 1000;
123         // The token smart-contract pays comision, else the transfer is not possible.
124         require(this.balance >= comision);
125         comisionGetter.transfer(comision); // Transfers comision to the comisionGetter.
126         _transfer(msg.sender, _to, _value);
127     }
128 
129     /* Overrides basic transferFrom function due to comision value */
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
131         require(_value <= allowance[_from][msg.sender]); // Check allowance.
132         // This function requires a comision value of 0.4% of the market value.
133         uint market_value = _value * sellPrice;
134         uint comision = market_value * 4 / 1000;
135         // The token smart-contract pays comision, else the transfer is not possible.
136         require(this.balance >= comision);
137         comisionGetter.transfer(comision); // Transfers comision to the comisionGetter.
138         allowance[_from][msg.sender] -= _value; // Updates the allowance array, substracting the amount sent.
139         _transfer(_from, _to, _value); // Makes the transfer.
140         return true;
141     }
142 
143     /* Internal, updates the balance of tokens available. */
144     function _updateTokensAvailable(uint256 _tokensAvailable) internal { tokensAvailable = _tokensAvailable; }
145 
146     /* Internal, updates the balance of Ether available in order to cover potential sales. */
147     function _updateSolvency(uint256 _solvency) internal { solvency = _solvency; }
148 
149     /* Internal, updates the profit value */
150     function _updateProfit(uint256 _increment, bool add) internal{
151         if (add){
152             // Increase the profit value
153             profit = profit + _increment;
154         }else{
155             // Decrease the profit value
156             if(_increment > profit){ profit = 0; }
157             else{ profit = profit - _increment; }
158         }
159     }
160 
161     /// @notice Create `mintedAmount` tokens and send it to `target`.
162     /// @param target Address to receive the tokens.
163     /// @param mintedAmount The amount of tokens target will receive.
164     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
165         balanceOf[target] += mintedAmount; // Updates target's balance.
166         totalSupply       += mintedAmount; // Updates totalSupply.
167         _updateTokensAvailable(balanceOf[this]); // Update the balance of tokens available if necessary.
168         Transfer(0, this, mintedAmount);      // Notifies the blockchain about the tokens created.
169         Transfer(this, target, mintedAmount); // Notifies the blockchain about the transfer to target.
170     }
171 
172     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens.
173     /// @param target Address to be frozen.
174     /// @param freeze Either to freeze target or not.
175     function freezeAccount(address target, bool freeze) onlyOwner public {
176         frozenAccount[target] = freeze; // Sets the target status. True if it's frozen, False if it's not.
177         FrozenFunds(target, freeze); // Notifies the blockchain about the change of state.
178     }
179 
180     /// @notice Allow addresses to pay `newBuyPrice`ETH when buying and receive `newSellPrice`ETH when selling, foreach token bought/sold.
181     /// @param newSellPrice Price applied when an address sells its tokens, amount in WEI (1ETH = 10¹⁸WEI).
182     /// @param newBuyPrice Price applied when an address buys tokens, amount in WEI (1ETH = 10¹⁸WEI).
183     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
184         sellPrice = newSellPrice; // Updates the buying price.
185         buyPrice = newBuyPrice;   // Updates the selling price.
186     }
187 
188     /// @notice Sets the state of buy and sell operations
189     /// @param isClosedBuy True if buy operations are closed, False if opened.
190     /// @param isClosedSell True if sell operations are closed, False if opened.
191     function setStatus(bool isClosedBuy, bool isClosedSell) onlyOwner public {
192         closeBuy = isClosedBuy;   // Updates the state of buy operations.
193         closeSell = isClosedSell; // Updates the state of sell operations.
194     }
195 
196     /// @notice Deposits Ether to the contract
197     function deposit() payable public returns(bool success) {
198         require((this.balance + msg.value) > this.balance); // Checks for overflows.
199         //Contract has already received the Ether when this function is executed.
200         _updateSolvency(this.balance);   // Updates the solvency value of the contract.
201         _updateProfit(msg.value, false); // Decrease profit value.
202         // Decrease because deposits will be done mostly by the owner.
203         // Possible donations won't count as profit for the company, but in favor of the investors.
204         LogDeposit(msg.sender, msg.value); // Notifies the blockchain about the Ether received.
205         return true;
206     }
207 
208     /// @notice The owner withdraws Ether from the contract.
209     /// @param amountInWeis Amount of ETH in WEI which will be withdrawed.
210     function withdraw(uint amountInWeis) onlyOwner public {
211         LogWithdrawal(msg.sender, amountInWeis); // Notifies the blockchain about the withdrawal.
212         _updateSolvency( (this.balance - amountInWeis) ); // Updates the solvency value of the contract.
213         _updateProfit(amountInWeis, true);                // Increase the profit value.
214         owner.transfer(amountInWeis); // Sends the Ether to owner address.
215     }
216 
217     /// @notice Buy tokens from contract by sending Ether.
218     function buy() public payable {
219         require(!closeBuy); //Buy operations must be opened
220         uint amount = msg.value / buyPrice; //Calculates the amount of tokens to be sent
221         uint market_value = amount * buyPrice; //Market value for this amount
222         uint comision = market_value * 4 / 1000; //Calculates the comision for this transaction
223         uint profit_in_transaction = market_value - (amount * sellPrice) - comision; //Calculates the relative profit for this transaction
224         require(this.balance >= comision); //The token smart-contract pays comision, else the operation is not possible.
225         comisionGetter.transfer(comision); //Transfers comision to the comisionGetter.
226         _transfer(this, msg.sender, amount); //Makes the transfer of tokens.
227         _updateSolvency((this.balance - profit_in_transaction)); //Updates the solvency value of the contract.
228         _updateProfit(profit_in_transaction, true); //Increase the profit value.
229         owner.transfer(profit_in_transaction); //Sends profit to the owner of the contract.
230     }
231 
232     /// @notice Sell `amount` tokens to the contract.
233     /// @param amount amount of tokens to be sold.
234     function sell(uint256 amount) public {
235         require(!closeSell); //Sell operations must be opened
236         uint market_value = amount * sellPrice; //Market value for this amount
237         uint comision = market_value * 4 / 1000; //Calculates the comision for this transaction
238         uint amount_weis = market_value + comision; //Total in weis that must be paid
239         require(this.balance >= amount_weis); //Contract must have enough weis
240         comisionGetter.transfer(comision); //Transfers comision to the comisionGetter
241         _transfer(msg.sender, this, amount); //Makes the transfer of tokens, the contract receives the tokens.
242         _updateSolvency( (this.balance - amount_weis) ); //Updates the solvency value of the contract.
243         msg.sender.transfer(market_value); //Sends Ether to the seller.
244     }
245 
246     /// Default function, sender buys tokens by sending ether to the contract:
247     function () public payable { buy(); }
248 }