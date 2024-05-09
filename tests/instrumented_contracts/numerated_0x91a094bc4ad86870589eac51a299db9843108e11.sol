1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8 
9   /**
10    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11    * account.
12    */
13   constructor () public {
14     owner = msg.sender;
15   }
16 
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) public onlyOwner {
30     require(newOwner != address(0));
31     emit OwnershipTransferred(owner, newOwner);
32     owner = newOwner;
33   }
34 
35 }
36 
37 contract TokenERC20 {
38     // Public variables of the token
39     string public name;
40     string public symbol;
41     uint8 public decimals = 18;
42     // 18 decimals is the strongly suggested default, avoid changing it
43     uint256 public totalSupply;
44 
45     // This creates an array with all balances
46     mapping (address => uint256) public balanceOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49     // This generates a public event on the blockchain that will notify clients
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     
52     // This generates a public event on the blockchain that will notify clients
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 
55     // This notifies clients about the amount burnt
56     event Burn(address indexed from, uint256 value);
57 
58     /**
59      * Constrctor function
60      *
61      * Initializes contract with initial supply tokens to the creator of the contract
62      */
63     constructor(
64         uint256 initialSupply,
65         string memory tokenName,
66         string memory tokenSymbol
67     ) public {
68         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
69         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
70         name = tokenName;                                       // Set the name for display purposes
71         symbol = tokenSymbol;                                   // Set the symbol for display purposes
72     }
73 
74     /**
75      * Internal transfer, only can be called by this contract
76      */
77     function _transfer(address _from, address _to, uint _value) internal {
78         // Prevent transfer to 0x0 address. Use burn() instead
79         require(_to != address(0x0));
80         // Check if the sender has enough
81         require(balanceOf[_from] >= _value);
82         // Check for overflows
83         require(balanceOf[_to] + _value > balanceOf[_to]);
84         // Save this for an assertion in the future
85         uint previousBalances = balanceOf[_from] + balanceOf[_to];
86         // Subtract from the sender
87         balanceOf[_from] -= _value;
88         // Add the same to the recipient
89         balanceOf[_to] += _value;
90         emit Transfer(_from, _to, _value);
91         // Asserts are used to use static analysis to find bugs in your code. They should never fail
92         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
93     }
94 
95     /**
96      * Transfer tokens
97      *
98      * Send `_value` tokens to `_to` from your account
99      *
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transfer(address _to, uint256 _value) public returns (bool success) {
104         _transfer(msg.sender, _to, _value);
105         return true;
106     }
107 
108     /**
109      * Transfer tokens from other address
110      *
111      * Send `_value` tokens to `_to` in behalf of `_from`
112      *
113      * @param _from The address of the sender
114      * @param _to The address of the recipient
115      * @param _value the amount to send
116      */
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
118         require(_value <= allowance[_from][msg.sender]);     // Check allowance
119         allowance[_from][msg.sender] -= _value;
120         _transfer(_from, _to, _value);
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address
126      *
127      * Allows `_spender` to spend no more than `_value` tokens in your behalf
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      */
132     function approve(address _spender, uint256 _value) public
133         returns (bool success) {
134         allowance[msg.sender][_spender] = _value;
135         emit Approval(msg.sender, _spender, _value);
136         return true;
137     }
138 
139     /**
140      * Set allowance for other address and notify
141      
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
181 contract YFT is Ownable, TokenERC20 {
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
192     constructor(
193         uint256 initialSupply,
194         string memory tokenName,
195         string memory tokenSymbol
196     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
197 
198     /* Internal transfer, only can be called by this contract */
199     function _transfer(address _from, address _to, uint _value) internal {
200         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
201         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
202         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
203         require(!frozenAccount[_from]);                         // Check if sender is frozen
204         require(!frozenAccount[_to]);                           // Check if recipient is frozen
205         balanceOf[_from] -= _value;                             // Subtract from the sender
206         balanceOf[_to] += _value;                               // Add the same to the recipient
207         emit Transfer(_from, _to, _value);
208     }
209 
210     /// @notice Create `mintedAmount` tokens and send it to `target`
211     /// @param target Address to receive the tokens
212     /// @param mintedAmount the amount of tokens it will receive
213     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
214         balanceOf[target] += mintedAmount;
215         totalSupply += mintedAmount;
216         emit Transfer(address(0), address(this), mintedAmount);
217         emit Transfer(address(this), target, mintedAmount);
218     }
219 
220     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
221     /// @param target Address to be frozen
222     /// @param freeze either to freeze it or not
223     function freezeAccount(address target, bool freeze) onlyOwner public {
224         frozenAccount[target] = freeze;
225         emit FrozenFunds(target, freeze);
226     }
227 
228     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
229     /// @param newSellPrice Price the users can sell to the contract
230     /// @param newBuyPrice Price users can buy from the contract
231     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
232         sellPrice = newSellPrice;
233         buyPrice = newBuyPrice;
234     }
235 
236     /// @notice Buy tokens from contract by sending ether
237     function buy() payable public {
238         uint amount = msg.value / buyPrice;                 // calculates the amount
239         _transfer(address(this), msg.sender, amount);       // makes the transfers
240     }
241 
242     /// @notice Sell `amount` tokens to contract
243     /// @param amount amount of tokens to be sold
244     function sell(uint256 amount) public {
245         address myAddress = address(this);
246         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
247         _transfer(msg.sender, address(this), amount);       // makes the transfers
248         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
249     }
250 }