1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address payable public owner;
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
15     function transferOwnership(address payable newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18     
19     function kill() public {
20         if(msg.sender == owner){
21             selfdestruct(owner);
22         }
23     }
24 }
25 
26 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
27 
28 contract TokenERC20 {
29     // Public variables of the token
30     string public name;
31     string public symbol;
32     uint8 public decimals = 18;
33     // 18 decimals is the strongly suggested default, avoid changing it
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
54     constructor(
55         uint256 initialSupply,
56         string memory tokenName,
57         string memory tokenSymbol
58     ) public {
59         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
60         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
61         name = tokenName;                                       // Set the name for display purposes
62         symbol = tokenSymbol;                                   // Set the symbol for display purposes
63     }
64 
65     /**
66      * Internal transfer, only can be called by this contract
67      */
68     function _transfer(address _from, address _to, uint _value) internal {
69         // Prevent transfer to 0x0 address. Use burn() instead
70         require(_to != address(0x0));
71         // Check if the sender has enough
72         require(balanceOf[_from] >= _value);
73         // Check for overflows
74         require(balanceOf[_to] + _value > balanceOf[_to]);
75         // Save this for an assertion in the future
76         uint previousBalances = balanceOf[_from] + balanceOf[_to];
77         // Subtract from the sender
78         balanceOf[_from] -= _value;
79         // Add the same to the recipient
80         balanceOf[_to] += _value;
81         emit Transfer(_from, _to, _value);
82         // Asserts are used to use static analysis to find bugs in your code. They should never fail
83         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
84     }
85 
86     /**
87      * Transfer tokens
88      *
89      * Send `_value` tokens to `_to` from your account
90      *
91      * @param _to The address of the recipient
92      * @param _value the amount to send
93      */
94     function transfer(address _to, uint256 _value) public returns (bool success) {
95         _transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     /**
100      * Transfer tokens from other address
101      *
102      * Send `_value` tokens to `_to` in behalf of `_from`
103      *
104      * @param _from The address of the sender
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
109         require(_value <= allowance[_from][msg.sender]);     // Check allowance
110         allowance[_from][msg.sender] -= _value;
111         _transfer(_from, _to, _value);
112         return true;
113     }
114 
115     /**
116      * Set allowance for other address
117      *
118      * Allows `_spender` to spend no more than `_value` tokens in your behalf
119      *
120      * @param _spender The address authorized to spend
121      * @param _value the max amount they can spend
122      */
123     function approve(address _spender, uint256 _value) public
124         returns (bool success) {
125         allowance[msg.sender][_spender] = _value;
126         emit Approval(msg.sender, _spender, _value);
127         return true;
128     }
129 
130     /**
131      * Set allowance for other address and notify
132      *
133      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
134      *
135      * @param _spender The address authorized to spend
136      * @param _value the max amount they can spend
137      * @param _extraData some extra information to send to the approved contract
138      */
139     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
140         public
141         returns (bool success) {
142         tokenRecipient spender = tokenRecipient(_spender);
143         if (approve(_spender, _value)) {
144             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
145             return true;
146         }
147     }
148 
149     /**
150      * Destroy tokens
151      *
152      * Remove `_value` tokens from the system irreversibly
153      *
154      * @param _value the amount of money to burn
155      */
156     function burn(uint256 _value) public returns (bool success) {
157         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
158         balanceOf[msg.sender] -= _value;            // Subtract from the sender
159         totalSupply -= _value;                      // Updates totalSupply
160         emit Burn(msg.sender, _value);
161         return true;
162     }
163 
164     /**
165      * Destroy tokens from other account
166      *
167      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
168      *
169      * @param _from the address of the sender
170      * @param _value the amount of money to burn
171      */
172     function burnFrom(address _from, uint256 _value) public returns (bool success) {
173         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
174         require(_value <= allowance[_from][msg.sender]);    // Check allowance
175         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
176         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
177         totalSupply -= _value;                              // Update totalSupply
178         emit Burn(_from, _value);
179         return true;
180     }
181 }
182 
183 /******************************************/
184 /*       ADVANCED TOKEN STARTS HERE       */
185 /******************************************/
186 
187 contract TracetotheDNA  is owned, TokenERC20 {
188 
189     uint256 public sellPrice;
190     uint256 public buyPrice;
191 
192     mapping (address => bool) public frozenAccount;
193 
194     /* This generates a public event on the blockchain that will notify clients */
195     event FrozenFunds(address target, bool frozen);
196 
197     /* Initializes contract with initial supply tokens to the creator of the contract */
198     constructor(
199         uint256 initialSupply,
200         string memory tokenName,
201         string memory tokenSymbol
202     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
203 
204     /* Internal transfer, only can be called by this contract */
205     function _transfer(address _from, address _to, uint _value) internal {
206         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
207         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
208         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
209         require(!frozenAccount[_from]);                         // Check if sender is frozen
210         require(!frozenAccount[_to]);                           // Check if recipient is frozen
211         balanceOf[_from] -= _value;                             // Subtract from the sender
212         balanceOf[_to] += _value;                               // Add the same to the recipient
213         emit Transfer(_from, _to, _value);
214     }
215 
216     /// @notice Create `mintedAmount` tokens and send it to `target`
217     /// @param target Address to receive the tokens
218     /// @param mintedAmount the amount of tokens it will receive
219     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
220         balanceOf[target] += mintedAmount;
221         totalSupply += mintedAmount;
222         emit Transfer(address(0), address(this), mintedAmount);
223         emit Transfer(address(this), target, mintedAmount);
224     }
225 
226     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
227     /// @param target Address to be frozen
228     /// @param freeze either to freeze it or not
229     function freezeAccount(address target, bool freeze) onlyOwner public {
230         frozenAccount[target] = freeze;
231         emit FrozenFunds(target, freeze);
232     }
233 
234     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
235     /// @param newSellPrice Price the users can sell to the contract
236     /// @param newBuyPrice Price users can buy from the contract
237     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
238         sellPrice = newSellPrice;
239         buyPrice = newBuyPrice;
240     }
241 
242     /// @notice Buy tokens from contract by sending ether
243     function buy() payable public {
244         uint amount = msg.value / buyPrice;                 // calculates the amount
245         _transfer(address(this), msg.sender, amount);       // makes the transfers
246     }
247 
248     /// @notice Sell `amount` tokens to contract
249     /// @param amount amount of tokens to be sold
250     function sell(uint256 amount) public {
251         address myAddress = address(this);
252         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
253         _transfer(msg.sender, address(this), amount);       // makes the transfers
254         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
255     }
256 }