1 /*
2 1. deploy contract
3 2. post code
4 3. transfer coins to contract
5 4. mint new coins with 18 0's at the end e.g. 100 new coins would be 100000000000000000000
6 */
7 pragma solidity ^0.4.16;
8 
9 contract owned {
10     address public owner;
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner public {
22         owner = newOwner;
23     }
24 }
25 
26 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
27 
28 contract TokenERC20 {
29     // Public variables of the token
30     string public name;
31     string public symbol;
32     uint8 public decimals = 18;    // 18 decimals is the strongly suggested default, avoid changing it
33     uint256 public totalSupply;
34     uint256 public hardCap;
35 
36     // This creates an array with all balances
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     // This generates a public event on the blockchain that will notify clients
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     
43     // This generates a public event on the blockchain that will notify clients
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46     // This notifies clients about the amount burnt
47     event Burn(address indexed from, uint256 value);
48 
49     /**
50      * Constrctor function
51      *
52      * Initializes contract with initial supply tokens to the creator of the contract
53      */
54     constructor(
55         uint256 initialSupply,
56         uint256 maxSupply,
57         string tokenName,
58         string tokenSymbol
59     ) public {
60         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
61         hardCap = maxSupply * 10 ** uint256(decimals);      // set the maximum nbr of coins  
62         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
63         name = tokenName;                                   // Set the name for display purposes
64         symbol = tokenSymbol;                               // Set the symbol for display purposes
65     }
66 
67     /**
68      * Internal transfer, only can be called by this contract
69      */
70     function _transfer(address _from, address _to, uint _value) internal {
71         // Prevent transfer to 0x0 address. Use burn() instead
72         require(_to != 0x0);
73         // Check if the sender has enough
74         require(balanceOf[_from] >= _value);
75         // Check for overflows
76         require(balanceOf[_to] + _value > balanceOf[_to]);
77         // Save this for an assertion in the future
78         uint previousBalances = balanceOf[_from] + balanceOf[_to];
79         // Subtract from the sender
80         balanceOf[_from] -= _value;
81         // Add the same to the recipient
82         balanceOf[_to] += _value;
83         emit Transfer(_from, _to, _value);
84         // Asserts are used to use static analysis to find bugs in your code. They should never fail
85         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
86     }
87 
88     /**
89      * Transfer tokens
90      *
91      * Send `_value` tokens to `_to` from your account
92      *
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transfer(address _to, uint256 _value) public returns (bool success) {
97         _transfer(msg.sender, _to, _value);
98         return true;
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
128         emit Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     /**
133      * Set allowance for other address and notify
134      *
135      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
136      *
137      * @param _spender The address authorized to spend
138      * @param _value the max amount they can spend
139      * @param _extraData some extra information to send to the approved contract
140      */
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
142         public
143         returns (bool success) {
144         tokenRecipient spender = tokenRecipient(_spender);
145         if (approve(_spender, _value)) {
146             spender.receiveApproval(msg.sender, _value, this, _extraData);
147             return true;
148         }
149     }
150 
151     /**
152      * Destroy tokens
153      *
154      * Remove `_value` tokens from the system irreversibly
155      *
156      * @param _value the amount of money to burn
157      */
158     function burn(uint256 _value) public returns (bool success) {
159         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
160         balanceOf[msg.sender] -= _value;            // Subtract from the sender
161         totalSupply -= _value;                      // Updates totalSupply
162         emit Burn(msg.sender, _value);
163         return true;
164     }
165 
166     /**
167      * Destroy tokens from other account
168      *
169      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
170      *
171      * @param _from the address of the sender
172      * @param _value the amount of money to burn
173      */
174     function burnFrom(address _from, uint256 _value) public returns (bool success) {
175         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
176         require(_value <= allowance[_from][msg.sender]);    // Check allowance
177         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
178         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
179         totalSupply -= _value;                              // Update totalSupply
180         emit Burn(_from, _value);
181         return true;
182     }
183 }
184 
185 /******************************************/
186 /*       ADVANCED TOKEN STARTS HERE       */
187 /******************************************/
188 
189 contract MyAdvancedToken is owned, TokenERC20 {
190 
191     uint256 public sellPrice;
192     uint256 public buyPrice;
193 
194     mapping (address => bool) public frozenAccount;
195 
196     /* This generates a public event on the blockchain that will notify clients */
197     event FrozenFunds(address target, bool frozen);
198 
199     /* Initializes contract with initial supply tokens to the creator of the contract */
200     constructor (
201         uint256 initialSupply,   // 250,000,000
202         uint256 hardCap,     // 350,000,000
203         string tokenName,        // bitbox
204         string tokenSymbol       // box
205     ) TokenERC20(initialSupply, hardCap, tokenName, tokenSymbol) public {}
206 
207     /* Internal transfer, only can be called by this contract */
208     function _transfer(address _from, address _to, uint _value) internal {
209         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
210         require (balanceOf[_from] >= _value);               // Check if the sender has enough
211         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
212         require(!frozenAccount[_from]);                     // Check if sender is frozen
213         require(!frozenAccount[_to]);                       // Check if recipient is frozen
214         balanceOf[_from] -= _value;                         // Subtract from the sender
215         balanceOf[_to] += _value;                           // Add the same to the recipient
216         emit Transfer(_from, _to, _value);
217     }
218 
219     /// @notice Create `mintedAmount` tokens and send it to `target`
220     /// @param target Address to receive the tokens
221     /// @param mintedAmount the amount of tokens it will receive
222     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
223         // only mint if under hardcap
224         require (totalSupply + mintedAmount <= hardCap);
225         balanceOf[target] += mintedAmount;
226         totalSupply += mintedAmount;
227         emit Transfer(0, this, mintedAmount);
228         emit Transfer(this, target, mintedAmount);
229     }
230 
231     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
232     /// @param target Address to be frozen
233     /// @param freeze either to freeze it or not
234     function freezeAccount(address target, bool freeze) onlyOwner public {
235         frozenAccount[target] = freeze;
236         emit FrozenFunds(target, freeze);
237     }
238 
239     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
240     /// @param newSellPrice Price the users can sell to the contract
241     /// @param newBuyPrice Price users can buy from the contract
242     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
243         sellPrice = newSellPrice;
244         buyPrice = newBuyPrice;
245     }
246 
247     /// @notice Buy tokens from contract by sending ether
248     function buy() payable public {
249         uint amount = msg.value * buyPrice;               // calculates the amount
250         _transfer(this, msg.sender, amount);              // makes the transfers
251     }
252 
253     function () payable public {
254         buy();
255     }
256 
257     /// @notice Sell `amount` tokens to contract
258     /// @param amount amount of tokens to be sold, 1 x 10^18 = 1.0 bbx
259     function sell(uint256 amount) public {
260         address myAddress = this;
261         require(myAddress.balance >= amount / sellPrice);   // checks if the contract has enough ether to buy
262         _transfer(msg.sender, this, amount);                // makes the transfers
263         msg.sender.transfer(amount / sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
264     }
265 
266     // Crowdsale owners can collect ETH any number of times
267     function collect() onlyOwner public {
268         msg.sender.transfer(address(this).balance);
269     }
270 
271 }