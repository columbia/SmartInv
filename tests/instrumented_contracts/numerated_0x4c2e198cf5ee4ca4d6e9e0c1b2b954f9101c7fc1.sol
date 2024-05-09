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
19     string public name; // Name for the token.
20     string public symbol; // Symbol for the token.
21     uint8 public decimals; // Number of decimals of the token.
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
35         totalSupply = initialSupply; // Update total supply.
36         name = tokenName; // Set the name for display purposes.
37         symbol = tokenSymbol; // Set the symbol for display purposes.
38         decimals = decimalUnits; // Amount of decimals for display purposes.
39     }
40 
41     /* Internal transfer, only can be called by this contract. */
42     function _transfer(address _from, address _to, uint _value) internal {
43         require(_to != 0x0); // Prevent transfer to 0x0 address.
44         require(balanceOf[_from] > _value); // Check if the sender has enough.
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
64         allowance[_from][msg.sender] -= _value; // Update the allowance array, substracting the amount sent.
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
78 contract GFCToken is owned, token {
79     /* Specific token definition for -GFC Token- company. */
80     uint256 public sellPrice = 1; // Price applied when selling a token.
81     uint256 public buyPrice = 1; // Price applied when buying a token.
82     bool public closeBuy = false; // If true, nobody will be able to buy.
83     bool public closeSell = false; // If true, nobody will be able to sell.
84     address public commissionGetter = 0xCd8bf69ad65c5158F0cfAA599bBF90d7f4b52Bb0; // The address that gets the commissions paid.
85     mapping (address => bool) public frozenAccount; // Array containing foreach address if it's frozen or not.
86 
87     /* This generates a public event on the blockchain that will notify about an address being freezed. */
88     event FrozenFunds(address target, bool frozen);
89     /* This generates a public event on the blockchain that will notify about an addition of Ether to the contract. */
90     event LogDeposit(address sender, uint amount);
91     /* This generates a public event on the blockchain that will notify about a Withdrawal of Ether from the contract. */
92     event LogWithdrawal(address receiver, uint amount);
93 
94     /* Initializes the contract */
95     function GFCToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) public token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
96 
97     /* Overrides Internal transfer due to frozen accounts check */
98     function _transfer(address _from, address _to, uint _value) internal {
99         require(_to != 0x0); // Prevent transfer to 0x0 address.
100         require(balanceOf[_from] >= _value); // Check if the sender has enough.
101         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows.
102         require(!frozenAccount[_from]); // Check if sender is frozen.
103         require(!frozenAccount[_to]); // Check if recipient is frozen.
104 		balanceOf[_from] -= _value; // Subtracts _value tokens from the sender.
105         balanceOf[_to] += _value; // Adds the same amount to the recipient.
106         Transfer(_from, _to, _value); // Notifies the blockchain about the transfer.
107     }
108 
109     /* Sends GFC from the owner to the smart-contract */
110     function refillTokens(uint256 _value) public onlyOwner{
111         _transfer(msg.sender, this, _value);
112     }
113 
114     /* Overrides basic transfer function due to commission value */
115     function transfer(address _to, uint256 _value) public {
116         uint market_value = _value * sellPrice; //Market value for this amount
117         uint commission = market_value * 1 / 100; //Calculates the commission for this transaction
118         require(this.balance >= commission); // The smart-contract pays commission, else the transfer is not possible.
119         commissionGetter.transfer(commission); // Transfers commission to the commissionGetter.
120         _transfer(msg.sender, _to, _value); // Makes the transfer of tokens.
121     }
122 
123     /* Overrides basic transferFrom function due to commission value */
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
125         require(_value <= allowance[_from][msg.sender]); // Check allowance.
126         uint market_value = _value * sellPrice; //Market value for this amount
127         uint commission = market_value * 1 / 100; //Calculates the commission for this transaction
128         require(this.balance >= commission); // The smart-contract pays commission, else the transfer is not possible.
129         commissionGetter.transfer(commission); // Transfers commission to the commissionGetter.
130         allowance[_from][msg.sender] -= _value; // Update the allowance array, substracting the amount sent.
131         _transfer(_from, _to, _value); // Makes the transfer of tokens.
132         return true;
133     }
134 
135     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens.
136     /// @param target Address to be frozen.
137     /// @param freeze Either to freeze target or not.
138     function freezeAccount(address target, bool freeze) onlyOwner public {
139         frozenAccount[target] = freeze; // Sets the target status. True if it's frozen, False if it's not.
140         FrozenFunds(target, freeze); // Notifies the blockchain about the change of state.
141     }
142 
143     /// @notice Allow addresses to pay `newBuyPrice`ETH when buying and receive `newSellPrice`ETH when selling, foreach token bought/sold.
144     /// @param newSellPrice Price applied when an address sells its tokens, amount in WEI (1ETH = 10¹⁸WEI).
145     /// @param newBuyPrice Price applied when an address buys tokens, amount in WEI (1ETH = 10¹⁸WEI).
146     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
147         sellPrice = newSellPrice; // Update the buying price.
148         buyPrice = newBuyPrice; // Update the selling price.
149     }
150 
151     /// @notice Sets the state of buy and sell operations
152     /// @param isClosedBuy True if buy operations are closed, False if opened.
153     /// @param isClosedSell True if sell operations are closed, False if opened.
154     function setStatus(bool isClosedBuy, bool isClosedSell) onlyOwner public {
155         closeBuy = isClosedBuy; // Update the state of buy operations.
156         closeSell = isClosedSell; // Update the state of sell operations.
157     }
158 
159     /// @notice Deposits Ether to the contract
160     function deposit() payable public returns(bool success) {
161         require((this.balance + msg.value) > this.balance); // Checks for overflows.
162         LogDeposit(msg.sender, msg.value); // Notifies the blockchain about the Ether received.
163         return true;
164     }
165 
166     /// @notice The owner withdraws Ether from the contract.
167     /// @param amountInWeis Amount of ETH in WEI which will be withdrawed.
168     function withdraw(uint amountInWeis) onlyOwner public {
169         LogWithdrawal(msg.sender, amountInWeis); // Notifies the blockchain about the withdrawal.
170         owner.transfer(amountInWeis); // Sends the Ether to owner address.
171     }
172 
173     /// @notice Buy tokens from contract by sending Ether.
174     function buy() public payable {
175         require(!closeBuy); //Buy operations must be opened
176         uint amount = msg.value / buyPrice; //Calculates the amount of tokens to be sent
177         uint market_value = amount * buyPrice; //Market value for this amount
178         uint commission = market_value * 1 / 100; //Calculates the commission for this transaction
179         require(this.balance >= commission); //The token smart-contract pays commission, else the operation is not possible.
180         commissionGetter.transfer(commission); //Transfers commission to the commissionGetter.
181         _transfer(this, msg.sender, amount); //Makes the transfer of tokens.
182     }
183 
184     /// @notice Sell `amount` tokens to the contract.
185     /// @param amount amount of tokens to be sold.
186     function sell(uint256 amount) public {
187         require(!closeSell); //Sell operations must be opened
188         uint market_value = amount * sellPrice; //Market value for this amount
189         uint commission = market_value * 1 / 100; //Calculates the commission for this transaction
190         uint amount_weis = market_value + commission; //Total in weis that must be paid
191         require(this.balance >= amount_weis); //Contract must have enough weis
192         commissionGetter.transfer(commission); //Transfers commission to the commissionGetter
193         _transfer(msg.sender, this, amount); //Makes the transfer of tokens, the contract receives the tokens.
194         msg.sender.transfer(market_value); //Sends Ether to the seller.
195     }
196 
197     /// Default function, sender buys tokens by sending ether to the contract
198     function () public payable { buy(); }
199 }