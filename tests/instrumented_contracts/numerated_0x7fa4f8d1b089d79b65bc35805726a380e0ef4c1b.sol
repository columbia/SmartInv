1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     
5     address public owner;
6 
7     //The Ownable constructor sets the original `owner` of the contract to the sender account.
8 	constructor() public {
9         owner = msg.sender;
10     }
11 
12     //Throws if called by any account other than the owner.
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /**
19      * Allows the current owner to transfer control of the contract to a newOwner.
20      * @param newOwner The address to transfer ownership to.
21      */
22     function transferOwnership(address newOwner) onlyOwner public {
23         owner = newOwner;
24     }
25 }
26 
27 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
28 
29 contract TokenERC20 {
30 
31     string public name; 
32     string public symbol; 
33     uint8 public decimals = 18; 
34     uint256 public totalSupply;
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
54     constructor(uint256 initialSupply,string tokenName,string tokenSymbol) public {
55         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
56         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
57         name = tokenName;                                   // Set the name for display purposes
58         symbol = tokenSymbol;                               // Set the symbol for display purposes
59     }
60 
61     /**
62      * Internal transfer, only can be called by this contract
63      */
64     function _transfer(address _from, address _to, uint _value) internal {
65         // Prevent transfer to 0x0 address. Use burn() instead
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balanceOf[_from] >= _value);
69         // Check for overflows
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71         // Save this for an assertion in the future
72         uint previousBalances = balanceOf[_from] + balanceOf[_to];
73         // Subtract from the sender
74         balanceOf[_from] -= _value;
75         // Add the same to the recipient
76         balanceOf[_to] += _value;
77         emit Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public returns (bool success) {
91         _transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     /**
96      * Transfer tokens from other address
97      *
98      * Send `_value` tokens to `_to` in behalf of `_from`
99      *
100      * @param _from The address of the sender
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender]);     // Check allowance
106         allowance[_from][msg.sender] -= _value;
107         _transfer(_from, _to, _value);
108         return true;
109     }
110 
111     /**
112      * Set allowance for other address
113      *
114      * Allows `_spender` to spend no more than `_value` tokens in your behalf
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      */
119     function approve(address _spender, uint256 _value) public
120         returns (bool success) {
121         allowance[msg.sender][_spender] = _value;
122         emit Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address and notify
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
130      *
131      * @param _spender The address authorized to spend
132      * @param _value the max amount they can spend
133      * @param _extraData some extra information to send to the approved contract
134      */
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143     /**
144      * Destroy tokens
145      *
146      * Remove `_value` tokens from the system irreversibly
147      *
148      * @param _value the amount of money to burn
149      */
150     function burn(uint256 _value) public returns (bool success) {
151         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
152         balanceOf[msg.sender] -= _value;            // Subtract from the sender
153         totalSupply -= _value;                      // Updates totalSupply
154         emit Burn(msg.sender, _value);
155         return true;
156     }
157 
158     /**
159      * Destroy tokens from other account
160      *
161      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
162      *
163      * @param _from the address of the sender
164      * @param _value the amount of money to burn
165      */
166     function burnFrom(address _from, uint256 _value) public returns (bool success) {
167         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
168         require(_value <= allowance[_from][msg.sender]);    // Check allowance
169         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
170         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
171         totalSupply -= _value;                              // Update totalSupply
172         emit Burn(_from, _value);
173         return true;
174     }
175 }
176 
177 /******************************************/
178 /*       ADVANCED TOKEN STARTS HERE       */
179 /******************************************/
180 
181 contract MyToken is owned, TokenERC20 {
182 
183     uint256 public sellPrice;
184     uint256 public buyPrice;
185 
186     mapping (address => bool) public frozenAccount;
187 
188     /* This generates a public event on the blockchain that will notify clients */
189     event FrozenFunds(address target, bool frozen);
190 
191     /* Initializes contract with initial supply tokens to the creator of the contract */
192     constructor(uint256 initialSupply,string tokenName,string tokenSymbol) 
193         TokenERC20(initialSupply, tokenName, tokenSymbol)   public {
194     }
195 
196     /* Internal transfer, only can be called by this contract */
197     function _transfer(address _from, address _to, uint _value) internal {
198         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
199         require (balanceOf[_from] >= _value);               // Check if the sender has enough
200         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
201         require(!frozenAccount[_from]);                     // Check if sender is frozen
202         require(!frozenAccount[_to]);                       // Check if recipient is frozen
203         balanceOf[_from] -= _value;                         // Subtract from the sender
204         balanceOf[_to] += _value;                           // Add the same to the recipient
205         emit Transfer(_from, _to, _value);
206     }
207 
208     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
209     /// @param target Address to be frozen
210     /// @param freeze either to freeze it or not
211     function freezeAccount(address target, bool freeze) onlyOwner public {
212         frozenAccount[target] = freeze;
213         emit FrozenFunds(target, freeze);
214     }
215 
216     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
217     /// @param newSellPrice Price the users can sell to the contract
218     /// @param newBuyPrice Price users can buy from the contract
219     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
220         sellPrice = newSellPrice;
221         buyPrice = newBuyPrice;
222     }
223 
224     /// @notice Buy tokens from contract by sending ether
225     function buy() payable public {
226         uint amount = msg.value / buyPrice;               // calculates the amount
227         _transfer(this, msg.sender, amount);              // makes the transfers
228     }
229 
230     /// @notice Sell `amount` tokens to contract
231     /// @param amount amount of tokens to be sold
232     function sell(uint256 amount) public {
233         address myAddress = this;
234         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
235         _transfer(msg.sender, this, amount);              // makes the transfers
236         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
237     }
238 }