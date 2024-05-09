1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 8;
27     uint256 public totalSupply;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     
36     // This generates a public event on the blockchain that will notify clients
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39     // This notifies clients about the amount burnt
40     event Burn(address indexed from, uint256 value);
41 
42     /**
43      * Constrctor function
44      *
45      * Initializes contract with initial supply tokens to the creator of the contract
46      */
47     constructor(
48         uint256 initialSupply,
49         string memory tokenName,
50         string memory tokenSymbol
51     ) public {
52         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
54         name = tokenName;                                       // Set the name for display purposes
55         symbol = tokenSymbol;                                   // Set the symbol for display purposes
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) internal {
62         // Prevent transfer to 0x0 address. Use burn() instead
63         require(_to != address(0x0));
64         // Check if the sender has enough
65         require(balanceOf[_from] >= _value);
66         // Check for overflows
67         require(balanceOf[_to] + _value > balanceOf[_to]);
68         // Save this for an assertion in the future
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70         // Subtract from the sender
71         balanceOf[_from] -= _value;
72         // Add the same to the recipient
73         balanceOf[_to] += _value;
74         emit Transfer(_from, _to, _value);
75         // Asserts are used to use static analysis to find bugs in your code. They should never fail
76         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
77     }
78 
79     /**
80      * Transfer tokens
81      *
82      * Send `_value` tokens to `_to` from your account
83      *
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transfer(address _to, uint256 _value) public returns (bool success) {
88         _transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     /**
93      * Transfer tokens from other address
94      *
95      * Send `_value` tokens to `_to` in behalf of `_from`
96      *
97      * @param _from The address of the sender
98      * @param _to The address of the recipient
99      * @param _value the amount to send
100      */
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
102         require(_value <= allowance[_from][msg.sender]);     // Check allowance
103         allowance[_from][msg.sender] -= _value;
104         _transfer(_from, _to, _value);
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address
110      *
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      */
116     function approve(address _spender, uint256 _value) public
117         returns (bool success) {
118         allowance[msg.sender][_spender] = _value;
119         emit Approval(msg.sender, _spender, _value);
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
133         public
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
138             return true;
139         }
140     }
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly
146      *
147      * @param _value the amount of money to burn
148      */
149     function burn(uint256 _value) public returns (bool success) {
150         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
151         balanceOf[msg.sender] -= _value;            // Subtract from the sender
152         totalSupply -= _value;                      // Updates totalSupply
153         emit Burn(msg.sender, _value);
154         return true;
155     }
156 
157     /**
158      * Destroy tokens from other account
159      *
160      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
161      *
162      * @param _from the address of the sender
163      * @param _value the amount of money to burn
164      */
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
167         require(_value <= allowance[_from][msg.sender]);    // Check allowance
168         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
169         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
170         totalSupply -= _value;                              // Update totalSupply
171         emit Burn(_from, _value);
172         return true;
173     }
174 }
175 
176 /******************************************/
177 /*       ADVANCED TOKEN STARTS HERE       */
178 /******************************************/
179 
180 contract TRDXToken is owned, TokenERC20 {
181 
182     uint256 public sellPrice;
183     uint256 public buyPrice;
184 
185     mapping (address => bool) public frozenAccount;
186 
187     /* This generates a public event on the blockchain that will notify clients */
188     event FrozenFunds(address target, bool frozen);
189 
190     /* Initializes contract with initial supply tokens to the creator of the contract */
191     constructor(
192         uint256 initialSupply,
193         string memory tokenName,
194         string memory tokenSymbol
195     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
196 
197     /* Internal transfer, only can be called by this contract */
198     function _transfer(address _from, address _to, uint _value) internal {
199         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
200         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
201         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
202         require(!frozenAccount[_from]);                         // Check if sender is frozen
203         require(!frozenAccount[_to]);                           // Check if recipient is frozen
204         balanceOf[_from] -= _value;                             // Subtract from the sender
205         balanceOf[_to] += _value;                               // Add the same to the recipient
206         emit Transfer(_from, _to, _value);
207     }
208 
209     /// @notice Create `mintedAmount` tokens and send it to `target`
210     /// @param target Address to receive the tokens
211     /// @param mintedAmount the amount of tokens it will receive
212     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
213         balanceOf[target] += mintedAmount;
214         totalSupply += mintedAmount;
215         emit Transfer(address(0), address(this), mintedAmount);
216         emit Transfer(address(this), target, mintedAmount);
217     }
218 
219     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
220     /// @param target Address to be frozen
221     /// @param freeze either to freeze it or not
222     function freezeAccount(address target, bool freeze) onlyOwner public {
223         frozenAccount[target] = freeze;
224         emit FrozenFunds(target, freeze);
225     }
226 
227     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
228     /// @param newSellPrice Price the users can sell to the contract
229     /// @param newBuyPrice Price users can buy from the contract
230     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
231         sellPrice = newSellPrice;
232         buyPrice = newBuyPrice;
233     }
234 
235     /// @notice Buy tokens from contract by sending ether
236     function buy() payable public {
237         uint amount = msg.value / buyPrice;                 // calculates the amount
238         _transfer(address(this), msg.sender, amount);       // makes the transfers
239     }
240 
241     /// @notice Sell `amount` tokens to contract
242     /// @param amount amount of tokens to be sold
243     function sell(uint256 amount) public {
244         address myAddress = address(this);
245         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
246         _transfer(msg.sender, address(this), amount);       // makes the transfers
247         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
248     }
249 }