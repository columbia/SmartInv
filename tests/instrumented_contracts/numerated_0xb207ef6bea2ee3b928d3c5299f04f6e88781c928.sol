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
22 contract SilvrTokenERC20 {
23     string public constant _myTokeName = 'Silvrcoin Token';
24     string public constant _mySymbol = 'Silvr';
25     uint public constant _myinitialSupply = 100000;
26     uint8 public constant _myDecimal = 18;
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     // This generates a public event on the blockchain that will notify clients
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     
41     // This generates a public event on the blockchain that will notify clients
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44     // This notifies clients about the amount burnt
45     event Burn(address indexed from, uint256 value);
46 
47     /**
48      * Constrctor function
49      *
50      * Initializes contract with initial supply tokens to the creator of the contract
51      */
52     constructor(
53         uint256 initialSupply,
54         string memory tokenName,
55         string memory tokenSymbol
56     ) public {
57         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
58         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
59         name = tokenName;                                       // Set the name for display purposes
60         symbol = tokenSymbol;                                   // Set the symbol for display purposes
61     }
62 
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         // Prevent transfer to 0x0 address. Use burn() instead
68         require(_to != address(0x0));
69         // Check if the sender has enough
70         require(balanceOf[_from] >= _value);
71         // Check for overflows
72         require(balanceOf[_to] + _value > balanceOf[_to]);
73         // Save this for an assertion in the future
74         uint previousBalances = balanceOf[_from] + balanceOf[_to];
75         // Subtract from the sender
76         balanceOf[_from] -= _value;
77         // Add the same to the recipient
78         balanceOf[_to] += _value;
79         emit Transfer(_from, _to, _value);
80         // Asserts are used to use static analysis to find bugs in your code. They should never fail
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public returns (bool success) {
93         _transfer(msg.sender, _to, _value);
94         return true;
95     }
96 
97     /**
98      * Transfer tokens from other address
99      *
100      * Send `_value` tokens to `_to` in behalf of `_from`
101      *
102      * @param _from The address of the sender
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         require(_value <= allowance[_from][msg.sender]);     // Check allowance
108         allowance[_from][msg.sender] -= _value;
109         _transfer(_from, _to, _value);
110         return true;
111     }
112 
113     /**
114      * Set allowance for other address
115      *
116      * Allows `_spender` to spend no more than `_value` tokens in your behalf
117      *
118      * @param _spender The address authorized to spend
119      * @param _value the max amount they can spend
120      */
121     function approve(address _spender, uint256 _value) public
122         returns (bool success) {
123         allowance[msg.sender][_spender] = _value;
124         emit Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128     /**
129      * Set allowance for other address and notify
130      *
131      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
132      *
133      * @param _spender The address authorized to spend
134      * @param _value the max amount they can spend
135      * @param _extraData some extra information to send to the approved contract
136      */
137     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
138         public
139         returns (bool success) {
140         tokenRecipient spender = tokenRecipient(_spender);
141         if (approve(_spender, _value)) {
142             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
143             return true;
144         }
145     }
146 
147     /**
148      * Destroy tokens
149      *
150      * Remove `_value` tokens from the system irreversibly
151      *
152      * @param _value the amount of money to burn
153      */
154     function burn(uint256 _value) public returns (bool success) {
155         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
156         balanceOf[msg.sender] -= _value;            // Subtract from the sender
157         totalSupply -= _value;                      // Updates totalSupply
158         emit Burn(msg.sender, _value);
159         return true;
160     }
161 
162     /**
163      * Destroy tokens from other account
164      *
165      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
166      *
167      * @param _from the address of the sender
168      * @param _value the amount of money to burn
169      */
170     function burnFrom(address _from, uint256 _value) public returns (bool success) {
171         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
172         require(_value <= allowance[_from][msg.sender]);    // Check allowance
173         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
174         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
175         totalSupply -= _value;                              // Update totalSupply
176         emit Burn(_from, _value);
177         return true;
178     }
179 }
180 
181 /******************************************/
182 /*       ADVANCED TOKEN STARTS HERE       */
183 /******************************************/
184 
185 contract MyAdvancedToken is owned, SilvrTokenERC20 {
186 
187     uint256 public sellPrice;
188     uint256 public buyPrice;
189 
190     mapping (address => bool) public frozenAccount;
191 
192     /* This generates a public event on the blockchain that will notify clients */
193     event FrozenFunds(address target, bool frozen);
194 
195     /* Initializes contract with initial supply tokens to the creator of the contract */
196     constructor(
197         uint256 initialSupply,
198         string memory tokenName,
199         string memory tokenSymbol
200     ) SilvrTokenERC20(initialSupply, tokenName, tokenSymbol) public {}
201 
202     /* Internal transfer, only can be called by this contract */
203     function _transfer(address _from, address _to, uint _value) internal {
204         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
205         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
206         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
207         require(!frozenAccount[_from]);                         // Check if sender is frozen
208         require(!frozenAccount[_to]);                           // Check if recipient is frozen
209         balanceOf[_from] -= _value;                             // Subtract from the sender
210         balanceOf[_to] += _value;                               // Add the same to the recipient
211         emit Transfer(_from, _to, _value);
212     }
213 
214     /// @notice Create `mintedAmount` tokens and send it to `target`
215     /// @param target Address to receive the tokens
216     /// @param mintedAmount the amount of tokens it will receive
217     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
218         balanceOf[target] += mintedAmount;
219         totalSupply += mintedAmount;
220         emit Transfer(address(0), address(this), mintedAmount);
221         emit Transfer(address(this), target, mintedAmount);
222     }
223 
224     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
225     /// @param target Address to be frozen
226     /// @param freeze either to freeze it or not
227     function freezeAccount(address target, bool freeze) onlyOwner public {
228         frozenAccount[target] = freeze;
229         emit FrozenFunds(target, freeze);
230     }
231 
232     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
233     /// @param newSellPrice Price the users can sell to the contract
234     /// @param newBuyPrice Price users can buy from the contract
235     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
236         sellPrice = newSellPrice;
237         buyPrice = newBuyPrice;
238     }
239 
240     /// @notice Buy tokens from contract by sending ether
241     function buy() payable public {
242         uint amount = msg.value / buyPrice;                 // calculates the amount
243         _transfer(address(this), msg.sender, amount);       // makes the transfers
244     }
245 
246     /// @notice Sell `amount` tokens to contract
247     /// @param amount amount of tokens to be sold
248     function sell(uint256 amount) public {
249         address myAddress = address(this);
250         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
251         _transfer(msg.sender, address(this), amount);       // makes the transfers
252         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
253     }
254 }