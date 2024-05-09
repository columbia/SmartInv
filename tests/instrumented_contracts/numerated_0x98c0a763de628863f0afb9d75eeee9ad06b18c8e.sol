1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     
5     address public owner;
6 
7 	constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
22 
23 contract TokenERC20 {
24 
25     string public name; 
26     string public symbol; 
27     uint8 public decimals = 18; 
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     
37     // This generates a public event on the blockchain that will notify clients
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     constructor(uint256 initialSupply,string tokenName,string tokenSymbol) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
50         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
51         name = tokenName;                                   // Set the name for display purposes
52         symbol = tokenSymbol;                               // Set the symbol for display purposes
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // Prevent transfer to 0x0 address. Use burn() instead
60         require(_to != 0x0);
61         // Check if the sender has enough
62         require(balanceOf[_from] >= _value);
63         // Check for overflows
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         emit Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public returns (bool success) {
85         _transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     /**
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` in behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);     // Check allowance
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * Set allowance for other address
107      *
108      * Allows `_spender` to spend no more than `_value` tokens in your behalf
109      *
110      * @param _spender The address authorized to spend
111      * @param _value the max amount they can spend
112      */
113     function approve(address _spender, uint256 _value) public
114         returns (bool success) {
115         allowance[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     /**
121      * Set allowance for other address and notify
122      *
123      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
124      *
125      * @param _spender The address authorized to spend
126      * @param _value the max amount they can spend
127      * @param _extraData some extra information to send to the approved contract
128      */
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
130         tokenRecipient spender = tokenRecipient(_spender);
131         if (approve(_spender, _value)) {
132             spender.receiveApproval(msg.sender, _value, this, _extraData);
133             return true;
134         }
135     }
136 
137     /**
138      * Destroy tokens
139      *
140      * Remove `_value` tokens from the system irreversibly
141      *
142      * @param _value the amount of money to burn
143      */
144     function burn(uint256 _value) public returns (bool success) {
145         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
146         balanceOf[msg.sender] -= _value;            // Subtract from the sender
147         totalSupply -= _value;                      // Updates totalSupply
148         emit Burn(msg.sender, _value);
149         return true;
150     }
151 
152     /**
153      * Destroy tokens from other account
154      *
155      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
156      *
157      * @param _from the address of the sender
158      * @param _value the amount of money to burn
159      */
160     function burnFrom(address _from, uint256 _value) public returns (bool success) {
161         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
162         require(_value <= allowance[_from][msg.sender]);    // Check allowance
163         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
164         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
165         totalSupply -= _value;                              // Update totalSupply
166         emit Burn(_from, _value);
167         return true;
168     }
169 }
170 
171 /******************************************/
172 /*       ADVANCED TOKEN STARTS HERE       */
173 /******************************************/
174 
175 contract MyToken is owned, TokenERC20 {
176 
177     uint256 public sellPrice;
178     uint256 public buyPrice;
179 
180     mapping (address => bool) public frozenAccount;
181 
182     /* This generates a public event on the blockchain that will notify clients */
183     event FrozenFunds(address target, bool frozen);
184 
185     /* Initializes contract with initial supply tokens to the creator of the contract */
186     constructor(uint256 initialSupply,string tokenName,string tokenSymbol) 
187         TokenERC20(initialSupply, tokenName, tokenSymbol)   public {
188     }
189 
190     /* Internal transfer, only can be called by this contract */
191     function _transfer(address _from, address _to, uint _value) internal {
192         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
193         require (balanceOf[_from] >= _value);               // Check if the sender has enough
194         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
195         require(!frozenAccount[_from]);                     // Check if sender is frozen
196         require(!frozenAccount[_to]);                       // Check if recipient is frozen
197         balanceOf[_from] -= _value;                         // Subtract from the sender
198         balanceOf[_to] += _value;                           // Add the same to the recipient
199         emit Transfer(_from, _to, _value);
200     }
201 
202     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
203     /// @param target Address to be frozen
204     /// @param freeze either to freeze it or not
205     function freezeAccount(address target, bool freeze) onlyOwner public {
206         frozenAccount[target] = freeze;
207         emit FrozenFunds(target, freeze);
208     }
209 
210     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
211     /// @param newSellPrice Price the users can sell to the contract
212     /// @param newBuyPrice Price users can buy from the contract
213     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
214         sellPrice = newSellPrice;
215         buyPrice = newBuyPrice;
216     }
217 
218     /// @notice Buy tokens from contract by sending ether
219     function buy() payable public {
220         uint amount = msg.value / buyPrice;               // calculates the amount
221         _transfer(this, msg.sender, amount);              // makes the transfers
222     }
223 
224     /// @notice Sell `amount` tokens to contract
225     /// @param amount amount of tokens to be sold
226     function sell(uint256 amount) public {
227         address myAddress = this;
228         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
229         _transfer(msg.sender, this, amount);              // makes the transfers
230         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
231     }
232 }