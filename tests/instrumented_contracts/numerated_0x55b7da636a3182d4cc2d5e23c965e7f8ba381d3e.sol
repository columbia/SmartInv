1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-23
3 */
4 
5 pragma solidity >=0.4.22 <0.6.0;
6 
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { 
25     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
26     
27 }
28 
29 contract TokenERC20 {
30     // Public variables of the token
31     string public name;
32     string public symbol;
33     uint8 public decimals = 18;
34     // 18 decimals is the strongly suggested default, avoid changing it
35     uint256 public totalSupply;
36 
37     // This creates an array with all balances
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     
44     // This generates a public event on the blockchain that will notify clients
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47     // This notifies clients about the amount burnt
48     event Burn(address indexed from, uint256 value);
49 
50     /**
51      * Constrctor function
52      *
53      * Initializes contract with initial supply tokens to the creator of the contract
54      */
55     constructor(
56         uint256 initialSupply,
57         string memory tokenName,
58         string memory tokenSymbol
59     ) public {
60         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
61         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
62         name = tokenName;                                       // Set the name for display purposes
63         symbol = tokenSymbol;                                   // Set the symbol for display purposes
64     }
65 
66     /**
67      * Internal transfer, only can be called by this contract
68      */
69     function _transfer(address _from, address _to, uint _value) internal {
70         // Prevent transfer to 0x0 address. Use burn() instead
71         require(_to != address(0x0));
72         // Check if the sender has enough
73         require(balanceOf[_from] >= _value);
74         // Check for overflows
75         require(balanceOf[_to] + _value > balanceOf[_to]);
76         // Save this for an assertion in the future
77         uint previousBalances = balanceOf[_from] + balanceOf[_to];
78         // Subtract from the sender
79         balanceOf[_from] -= _value;
80         // Add the same to the recipient
81         balanceOf[_to] += _value;
82         emit Transfer(_from, _to, _value);
83         // Asserts are used to use static analysis to find bugs in your code. They should never fail
84         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
85     }
86 
87     /**
88      * Transfer tokens
89      *
90      * Send `_value` tokens to `_to` from your account
91      *
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transfer(address _to, uint256 _value) public returns (bool success) {
96         _transfer(msg.sender, _to, _value);
97         return true;
98     }
99 
100     /**
101      * Transfer tokens from other address
102      *
103      * Send `_value` tokens to `_to` in behalf of `_from`
104      *
105      * @param _from The address of the sender
106      * @param _to The address of the recipient
107      * @param _value the amount to send
108      */
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
110         require(_value <= allowance[_from][msg.sender]);     // Check allowance
111         allowance[_from][msg.sender] -= _value;
112         _transfer(_from, _to, _value);
113         return true;
114     }
115 
116     /**
117      * Set allowance for other address
118      *
119      * Allows `_spender` to spend no more than `_value` tokens in your behalf
120      *
121      * @param _spender The address authorized to spend
122      * @param _value the max amount they can spend
123      */
124     function approve(address _spender, uint256 _value) public
125         returns (bool success) {
126         allowance[msg.sender][_spender] = _value;
127         emit Approval(msg.sender, _spender, _value);
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
140     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
141         public
142         returns (bool success) {
143         tokenRecipient spender = tokenRecipient(_spender);
144         if (approve(_spender, _value)) {
145             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
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
161         emit Burn(msg.sender, _value);
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
179         emit Burn(_from, _value);
180         return true;
181     }
182 }
183 
184 /******************************************/
185 /*       ADVANCED TOKEN STARTS HERE       */
186 /******************************************/
187 
188 contract MyAdvancedToken is owned, TokenERC20 {
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
199     constructor(
200         uint256 initialSupply,
201         string memory tokenName,
202         string memory tokenSymbol
203     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
204 
205     /* Internal transfer, only can be called by this contract */
206     function _transfer(address _from, address _to, uint _value) internal {
207         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
208         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
209         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
210         require(!frozenAccount[_from]);                         // Check if sender is frozen
211         require(!frozenAccount[_to]);                           // Check if recipient is frozen
212         balanceOf[_from] -= _value;                             // Subtract from the sender
213         balanceOf[_to] += _value;                               // Add the same to the recipient
214         emit Transfer(_from, _to, _value);
215     }
216 
217     /// @notice Create `mintedAmount` tokens and send it to `target`
218     /// @param target Address to receive the tokens
219     /// @param mintedAmount the amount of tokens it will receive
220     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
221         balanceOf[target] += mintedAmount;
222         totalSupply += mintedAmount;
223         emit Transfer(address(0), address(this), mintedAmount);
224         emit Transfer(address(this), target, mintedAmount);
225     }
226 
227     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
228     /// @param target Address to be frozen
229     /// @param freeze either to freeze it or not
230     function freezeAccount(address target, bool freeze) onlyOwner public {
231         frozenAccount[target] = freeze;
232         emit FrozenFunds(target, freeze);
233     }
234 
235     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
236     /// @param newSellPrice Price the users can sell to the contract
237     /// @param newBuyPrice Price users can buy from the contract
238     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
239         sellPrice = newSellPrice;
240         buyPrice = newBuyPrice;
241     }
242 
243     /// @notice Buy tokens from contract by sending ether
244     function buy() payable public {
245         uint amount = msg.value / buyPrice;                 // calculates the amount
246         _transfer(address(this), msg.sender, amount);       // makes the transfers
247     }
248 
249     /// @notice Sell `amount` tokens to contract
250     /// @param amount amount of tokens to be sold
251     function sell(uint256 amount) public {
252         address myAddress = address(this);
253         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
254         _transfer(msg.sender, address(this), amount);       // makes the transfers
255         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
256     }
257 }