1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract owned {
6     /* Owner definition. */
7     address public owner; // Owner address.
8     function owned() internal {
9         owner = msg.sender ;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner); _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 contract token { 
22     /* Base token definition. */
23     string  public name;        // Name for the token.
24     string  public symbol;      // Symbol for the token.
25     uint8   public decimals;    // Number of decimals of the token.
26     uint256 public totalSupply; // Total of tokens created.
27 
28     // Array containing the balance foreach address.
29     mapping (address => uint256) public balanceOf;
30     // Array containing foreach address, an array containing each approved address and the amount of tokens it can spend.
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     /* This generates a public event on the blockchain that will notify about a transfer done. */
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     /* Initializes the contract */
37     function token(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) internal {
38         balanceOf[msg.sender] = initialSupply; // Gives the creator all initial tokens.
39         totalSupply           = initialSupply; // Update total supply.
40         name                  = tokenName;     // Set the name for display purposes.
41         symbol                = tokenSymbol;   // Set the symbol for display purposes.
42         decimals              = decimalUnits;  // Amount of decimals for display purposes.
43     }
44 
45     /* Internal transfer, only can be called by this contract. */
46     function _transfer(address _from, address _to, uint _value) internal {
47         require(_to != 0x0);                               // Prevent transfer to 0x0 address.
48         require(balanceOf[_from] > _value);                // Check if the sender has enough.
49         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows.
50         balanceOf[_from] -= _value; // Subtract from the sender.
51         balanceOf[_to]   += _value; // Add the same to the recipient.
52         Transfer(_from, _to, _value); // Notifies the blockchain about the transfer.
53     }
54 
55     /// @notice Send `_value` tokens to `_to` from your account.
56     /// @param _to The address of the recipient.
57     /// @param _value The amount to send.
58     function transfer(address _to, uint256 _value) public {
59         _transfer(msg.sender, _to, _value);
60     }
61 
62     /// @notice Send `_value` tokens to `_to` in behalf of `_from`.
63     /// @param _from The address of the sender.
64     /// @param _to The address of the recipient.
65     /// @param _value The amount to send.
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
67         require(_value <= allowance[_from][msg.sender]); // Check allowance.
68         allowance[_from][msg.sender] -= _value; // Updates the allowance array, substracting the amount sent.
69         _transfer(_from, _to, _value); // Makes the transfer.
70         return true;
71     }
72 
73     /// @notice Allows `_spender` to spend a maximum of `_value` tokens in your behalf.
74     /// @param _spender The address authorized to spend.
75     /// @param _value The max amount they can spend.
76     function approve(address _spender, uint256 _value) public returns (bool success) {
77         allowance[msg.sender][_spender] = _value; // Adds a new register to allowance, permiting _spender to use _value of your tokens.
78         return true;
79     }
80 }
81 
82 contract PMHToken is owned, token {
83     /* Specific token definition for -HormitechToken-. */
84     uint256 public sellPrice         = 5000000000000000;  // Price applied if someone wants to sell a token.
85     uint256 public buyPrice          = 10000000000000000; // Price applied if someone wants to buy a token.
86     bool    public closeBuy          = false;             // If true, nobody will be able to buy.
87     bool    public closeSell         = false;             // If true, nobody will be able to sell.
88     uint256 public tokensAvailable   = balanceOf[this];   // Number of tokens available for sell.
89     uint256 public solvency          = this.balance;      // Amount of Ether available to pay sales.
90     uint256 public profit            = 0;                 // Shows the actual profit for the company.
91     address public comisionGetter = 0x70B593f89DaCF6e3BD3e5bD867113FEF0B2ee7aD ; // The address that gets the comisions paid.
92 
93 // added MAR 2018
94     mapping (address => string ) public emails ;   // Array containing the e-mail addresses of the token holders 
95     mapping (uint => uint) public dividends ; // for each period in the index, how many weis set for dividends distribution
96 
97     mapping (address => uint[]) public paidDividends ; // for each address, if the period dividend was paid or not and the amount 
98 // added MAR 2018
99 
100     mapping (address => bool) public frozenAccount; // Array containing foreach address if it's frozen or not.
101 
102     /* This generates a public event on the blockchain that will notify about an address being freezed. */
103     event FrozenFunds(address target, bool frozen);
104     /* This generates a public event on the blockchain that will notify about an addition of Ether to the contract. */
105     event LogDeposit(address sender, uint amount);
106     /* This generates a public event on the blockchain that will notify about a Withdrawal of Ether from the contract. */
107     event LogWithdrawal(address receiver, uint amount);
108 
109     /* Initializes the contract */
110     function PMHToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) public 
111     token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
112 
113     /* Internal transfer, only can be called by this contract */
114     function _transfer(address _from, address _to, uint _value) internal {
115         require(_to != 0x0);                               // Prevent transfer to 0x0 address.
116         require(balanceOf[_from] >= _value);               // Check if the sender has enough.
117         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows.
118         require(!frozenAccount[_from]);                    // Check if sender is frozen.
119         require(!frozenAccount[_to]);                      // Check if recipient is frozen.
120 		balanceOf[_from] -= _value; // Subtracts _value tokens from the sender.
121         balanceOf[_to]   += _value; // Adds the same amount to the recipient.
122 
123         _updateTokensAvailable(balanceOf[this]); // Update the balance of tokens available if necessary.
124         Transfer(_from, _to, _value); // Notifies the blockchain about the transfer.
125     }
126 
127     function refillTokens(uint256 _value) public onlyOwner{
128         // Owner sends tokens to the contract.
129         _transfer(msg.sender, this, _value);
130     }
131 
132     /* Overrides basic transfer function due to comision value */
133     function transfer(address _to, uint256 _value) public {
134     	// This function requires a comision value of 0.4% of the market value.
135         uint market_value = _value * sellPrice;
136         uint comision = market_value * 4 / 1000;
137         // The token smart-contract pays comision, else the transfer is not possible.
138         require(this.balance >= comision);
139         comisionGetter.transfer(comision); // Transfers comision to the comisionGetter.
140         _transfer(msg.sender, _to, _value);
141     }
142 
143     /* Overrides basic transferFrom function due to comision value */
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
145         require(_value <= allowance[_from][msg.sender]); // Check allowance.
146         // This function requires a comision value of 0.4% of the market value.
147         uint market_value = _value * sellPrice;
148         uint comision = market_value * 4 / 1000;
149         // The token smart-contract pays comision, else the transfer is not possible.
150         require(this.balance >= comision);
151         comisionGetter.transfer(comision); // Transfers comision to the comisionGetter.
152         allowance[_from][msg.sender] -= _value; // Updates the allowance array, substracting the amount sent.
153         _transfer(_from, _to, _value); // Makes the transfer.
154         return true;
155     }
156 
157     /* Internal, updates the balance of tokens available. */
158     function _updateTokensAvailable(uint256 _tokensAvailable) internal { tokensAvailable = _tokensAvailable; }
159 
160     /* Internal, updates the balance of Ether available in order to cover potential sales. */
161     function _updateSolvency(uint256 _solvency) internal { solvency = _solvency; }
162 
163     /* Internal, updates the profit value */
164     function _updateProfit(uint256 _increment, bool add) internal{
165         if (add){
166             // Increase the profit value
167             profit = profit + _increment;
168         }else{
169             // Decrease the profit value
170             if(_increment > profit){ profit = 0; }
171             else{ profit = profit - _increment; }
172         }
173     }
174 
175     /// @notice Create `mintedAmount` tokens and send it to `target`.
176     /// @param target Address to receive the tokens.
177     /// @param mintedAmount The amount of tokens target will receive.
178     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
179         balanceOf[target] += mintedAmount; // Updates target's balance.
180         totalSupply       += mintedAmount; // Updates totalSupply.
181         _updateTokensAvailable(balanceOf[this]); // Update the balance of tokens available if necessary.
182         Transfer(0, this, mintedAmount);      // Notifies the blockchain about the tokens created.
183         Transfer(this, target, mintedAmount); // Notifies the blockchain about the transfer to target.
184     }
185 
186     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens.
187     /// @param target Address to be frozen.
188     /// @param freeze Either to freeze target or not.
189     function freezeAccount(address target, bool freeze) onlyOwner public {
190         frozenAccount[target] = freeze; // Sets the target status. True if it's frozen, False if it's not.
191         FrozenFunds(target, freeze); // Notifies the blockchain about the change of state.
192     }
193 
194     /// @notice Allow addresses to pay `newBuyPrice`ETH when buying and receive `newSellPrice`ETH when selling, foreach token bought/sold.
195     /// @param newSellPrice Price applied when an address sells its tokens, amount in WEI (1ETH = 10¹⁸WEI).
196     /// @param newBuyPrice Price applied when an address buys tokens, amount in WEI (1ETH = 10¹⁸WEI).
197     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
198         sellPrice = newSellPrice; // Updates the buying price.
199         buyPrice = newBuyPrice;   // Updates the selling price.
200     }
201 
202     /// @notice Sets the state of buy and sell operations
203     /// @param isClosedBuy True if buy operations are closed, False if opened.
204     /// @param isClosedSell True if sell operations are closed, False if opened.
205     function setStatus(bool isClosedBuy, bool isClosedSell) onlyOwner public {
206         closeBuy = isClosedBuy;   // Updates the state of buy operations.
207         closeSell = isClosedSell; // Updates the state of sell operations.
208     }
209 
210     /// @notice Deposits Ether to the contract
211     function deposit() payable public returns(bool success) {
212         require((this.balance + msg.value) > this.balance); // Checks for overflows.
213         //Contract has already received the Ether when this function is executed.
214         _updateSolvency(this.balance);   // Updates the solvency value of the contract.
215         _updateProfit(msg.value, false); // Decrease profit value.
216         // Decrease because deposits will be done mostly by the owner.
217         // Possible donations won't count as profit for the company, but in favor of the investors.
218         LogDeposit(msg.sender, msg.value); // Notifies the blockchain about the Ether received.
219         return true;
220     }
221 
222     /// @notice The owner withdraws Ether from the contract.
223     /// @param amountInWeis Amount of ETH in WEI which will be withdrawed.
224     function withdraw(uint amountInWeis) onlyOwner public {
225         LogWithdrawal(msg.sender, amountInWeis); // Notifies the blockchain about the withdrawal.
226         _updateSolvency( (this.balance - amountInWeis) ); // Updates the solvency value of the contract.
227         _updateProfit(amountInWeis, true);                // Increase the profit value.
228         owner.transfer(amountInWeis); // Sends the Ether to owner address.
229     }
230 
231     function withdrawDividends(uint amountInWeis) internal returns(bool success) {
232         LogWithdrawal(msg.sender, amountInWeis); // Notifies the blockchain about the withdrawal.
233         _updateSolvency( (this.balance - amountInWeis) ); // Updates the solvency value of the contract.
234         msg.sender.transfer(amountInWeis); // Sends the Ether to owner address.
235         return true ; 
236     }
237 
238     /// @notice Buy tokens from contract by sending Ether.
239     function buy() public payable {
240         require(!closeBuy); //Buy operations must be opened
241         uint amount = msg.value / buyPrice; //Calculates the amount of tokens to be sent
242         uint market_value = amount * buyPrice; //Market value for this amount
243         uint comision = market_value * 4 / 1000; //Calculates the comision for this transaction
244         uint profit_in_transaction = market_value - (amount * sellPrice) - comision; //Calculates the relative profit for this transaction
245         require(this.balance >= comision); //The token smart-contract pays comision, else the operation is not possible.
246         comisionGetter.transfer(comision); //Transfers comision to the comisionGetter.
247         _transfer(this, msg.sender, amount); //Makes the transfer of tokens.
248         _updateSolvency((this.balance - profit_in_transaction)); //Updates the solvency value of the contract.
249         _updateProfit(profit_in_transaction, true); //Increase the profit value.
250         owner.transfer(profit_in_transaction); //Sends profit to the owner of the contract.
251     }
252 
253     /// @notice Sell `amount` tokens to the contract.
254     /// @param amount amount of tokens to be sold.
255     function sell(uint256 amount) public {
256         require(!closeSell); //Sell operations must be opened
257         uint market_value = amount * sellPrice; //Market value for this amount
258         uint comision = market_value * 4 / 1000; //Calculates the comision for this transaction
259         uint amount_weis = market_value + comision; //Total in weis that must be paid
260         require(this.balance >= amount_weis); //Contract must have enough weis
261         comisionGetter.transfer(comision); //Transfers comision to the comisionGetter
262         _transfer(msg.sender, this, amount); //Makes the transfer of tokens, the contract receives the tokens.
263         _updateSolvency( (this.balance - amount_weis) ); //Updates the solvency value of the contract.
264         msg.sender.transfer(market_value); //Sends Ether to the seller.
265     }
266 
267     /// Default function, sender buys tokens by sending ether to the contract:
268     function () public payable { buy(); }
269 
270 
271     function setDividends(uint _period, uint _totalAmount) onlyOwner public returns (bool success) {
272         require(this.balance >= _totalAmount ) ; 
273 // period is 201801 201802 etc. yyyymm - no more than 1 dividend distribution per month
274         dividends[_period] = _totalAmount ; 
275         return true ; 
276     } 
277 
278 
279 function setEmail(string _email ) public returns (bool success) {
280     require(balanceOf[msg.sender] > 0 ) ;
281    // require(emails[msg.sender] == "" ) ; // checks the e-mail for this address was not already set
282     emails[msg.sender] = _email ; 
283     return true ; 
284     } 
285 
286 
287     function dividendsGetPaid(uint _period) public returns (bool success) {
288      uint percentageDividends ; 
289      uint qtyDividends ; 
290 
291      require(!frozenAccount[msg.sender]); // frozen accounts are not allowed to withdraw ether 
292      require(balanceOf[msg.sender] > 0 ) ; // sender has a positive balance of tokens to get paid 
293      require(dividends[_period] > 0) ; // there is an active dividend period  
294      require(paidDividends[msg.sender][_period] == 0) ;  // the dividend for this token holder was not yet paid
295 
296     // using here a 10000 (ten thousand) arbitrary multiplying factor for floating point precision
297      percentageDividends = (balanceOf[msg.sender] / totalSupply  ) * 10000 ; 
298      qtyDividends = ( percentageDividends * dividends[_period] ) / 10000  ;
299      require(this.balance >= qtyDividends) ; // contract has enough ether to pay this dividend 
300      paidDividends[msg.sender][_period] = qtyDividends ;  // record the dividend was paid 
301      require(withdrawDividends(qtyDividends)); 
302      return true ; 
303 
304     }
305 
306 
307 function adminResetEmail(address _address, string _newEmail ) public onlyOwner  {
308     require(balanceOf[_address] > 0 ) ;
309     emails[_address] = _newEmail ; 
310     
311     } 
312 
313 
314 
315 }