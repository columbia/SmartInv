1 pragma solidity ^0.4.16;
2      
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract owned {
6         address public owner;
7 
8         function owned() public{
9             owner = msg.sender;
10         }
11 
12         modifier onlyOwner {
13             require(msg.sender == owner);
14             _;
15         }
16 
17         function transferOwnership(address newOwner) onlyOwner public{
18             owner = newOwner;
19         }
20     }
21 
22 
23 contract GPN is owned {
24     // Public variables of the token
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;
28     // 18 decimals is the strongly suggested default, avoid changing it
29     uint256 public totalSupply;
30     address public centralMinter;
31     uint public minBalanceForAccounts;
32     uint minimumBalanceInFinney=1;
33     uint256 public sellPrice;
34     uint256 public buyPrice;
35      uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
36     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
37     address public fundsWallet;    
38 
39    
40     // This creates an array with all balances
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43      mapping (address => bool) public approvedAccount;
44 
45     // This generates a public event on the blockchain that will notify clients
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 event FrozenFunds(address target, bool frozen);
48     
49     // This notifies clients about the amount burnt
50     event Burn(address indexed from, uint256 value);
51 
52     /**
53      * Constrctor function
54      *
55      * Initializes contract with initial supply tokens to the creator of the contract
56      */
57     function GPN(
58         uint256 initialSupply,
59         string tokenName,
60         string tokenSymbol,
61         address tokenCentralMinter
62         ) 
63         public {
64         if(tokenCentralMinter!=0)owner=tokenCentralMinter;
65         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
66         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
67         name = tokenName;                                   // Set the name for display purposes
68         symbol = tokenSymbol;                               // Set the symbol for display purposes
69         setMinBalance();
70         unitsOneEthCanBuy = 960;                                      // Set the price of your token for the ICO (CHANGE THIS)
71         fundsWallet = msg.sender;   
72     }
73    function()public payable{
74         totalEthInWei = totalEthInWei + msg.value;
75         uint256 amount = msg.value * unitsOneEthCanBuy;
76         if (balanceOf[fundsWallet] < amount) {
77             return;
78         }
79 
80         balanceOf[fundsWallet] = balanceOf[fundsWallet] - amount;
81         balanceOf[msg.sender] = balanceOf[msg.sender] + amount;
82 
83         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
84 
85         //Transfer ether to fundsWallet
86         fundsWallet.transfer(msg.value);                               
87     }
88 
89      function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public{
90         sellPrice = newSellPrice;
91         buyPrice = newBuyPrice;
92     }
93     function buy()public payable returns (uint amount) {
94         amount = msg.value / buyPrice;                    // calculates the amount
95         require(balanceOf[this] >= amount);               // checks if it has enough to sell
96         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
97         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
98         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
99         return amount;                                    // ends function and returns
100     }
101 
102     function sell(uint amount)public returns (uint revenue){
103         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
104         balanceOf[this] += amount;                        // adds the amount to owner's balance
105         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
106         revenue = amount * sellPrice;
107         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
108         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
109         return revenue;                                   // ends function and returns
110     }
111     
112     function freezeAccount(address target, bool freeze) onlyOwner public{
113         approvedAccount[target] = freeze;
114         FrozenFunds(target, freeze);
115     }
116     function mintToken(address target, uint256 mintedAmount) onlyOwner public{
117         balanceOf[target] += mintedAmount;
118         totalSupply += mintedAmount;
119         Transfer(0, owner, mintedAmount);
120         Transfer(owner, target, mintedAmount);
121     }
122 
123 
124     function setMinBalance() onlyOwner public{
125          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
126     }
127     /**
128      * Internal transfer, only can be called by this contract
129      */
130     function _transfer(address _from, address _to, uint _value) internal {
131         // Prevent transfer to 0x0 address. Use burn() instead
132         require(_to != 0x0);
133         // Check if the sender has enough
134         require(balanceOf[_from] >= _value);
135         // Check for overflows
136         require(balanceOf[_to] + _value > balanceOf[_to]);
137         // Save this for an assertion in the future
138         uint previousBalances = balanceOf[_from] + balanceOf[_to];
139         // Subtract from the sender
140         balanceOf[_from] -= _value;
141         // Add the same to the recipient
142         balanceOf[_to] += _value;
143         Transfer(_from, _to, _value);
144         // Asserts are used to use static analysis to find bugs in your code. They should never fail
145         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
146     }
147 
148     /**
149      * Transfer tokens
150      *
151      * Send `_value` tokens to `_to` from your account
152      *
153      * @param _to The address of the recipient
154      * @param _value the amount to send
155      */
156     function transfer(address _to, uint256 _value) public {
157             
158         require(!approvedAccount[msg.sender]);
159             /* Send coins */
160     
161         if(msg.sender.balance < minBalanceForAccounts)
162             sell((minBalanceForAccounts - msg.sender.balance)/sellPrice);
163         else
164         _transfer(msg.sender, _to, _value);
165             /* Send coins */
166     
167      
168     }
169 
170     /**
171      * Transfer tokens from other address
172      *
173      * Send `_value` tokens to `_to` on behalf of `_from`
174      *
175      * @param _from The address of the sender
176      * @param _to The address of the recipient
177      * @param _value the amount to send
178      */
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
180         require(_value <= allowance[_from][msg.sender]);     // Check allowance
181         allowance[_from][msg.sender] -= _value;
182         _transfer(_from, _to, _value);
183         return true;
184     }
185 
186     /**
187      * Set allowance for other address
188      *
189      * Allows `_spender` to spend no more than `_value` tokens on your behalf
190      *
191      * @param _spender The address authorized to spend
192      * @param _value the max amount they can spend
193      */
194     function approve(address _spender, uint256 _value) public
195         returns (bool success) {
196         allowance[msg.sender][_spender] = _value;
197         return true;
198     }
199 
200     /**
201      * Set allowance for other address and notify
202      *
203      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
204      *
205      * @param _spender The address authorized to spend
206      * @param _value the max amount they can spend
207      * @param _extraData some extra information to send to the approved contract
208      */
209     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
210         public
211         returns (bool success) {
212         tokenRecipient spender = tokenRecipient(_spender);
213         if (approve(_spender, _value)) {
214             spender.receiveApproval(msg.sender, _value, this, _extraData);
215             return true;
216         }
217     }
218 
219     /**
220      * Destroy tokens
221      *
222      * Remove `_value` tokens from the system irreversibly
223      *
224      * @param _value the amount of money to burn
225      */
226     function burn(uint256 _value) public returns (bool success) {
227         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
228         balanceOf[msg.sender] -= _value;            // Subtract from the sender
229         totalSupply -= _value;                      // Updates totalSupply
230         Burn(msg.sender, _value);
231         return true;
232     }
233 
234     /**
235      * Destroy tokens from other account
236      *
237      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
238      *
239      * @param _from the address of the sender
240      * @param _value the amount of money to burn
241      */
242     function burnFrom(address _from, uint256 _value) public returns (bool success) {
243         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
244         require(_value <= allowance[_from][msg.sender]);    // Check allowance
245         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
246         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
247         totalSupply -= _value;                              // Update totalSupply
248         Burn(_from, _value);
249         return true;
250     }
251 }