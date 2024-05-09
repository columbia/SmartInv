1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5     address public ownerCandidate;
6     event OwnerTransfer(address originalOwner, address currentOwner);
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 
21    function proposeNewOwner(address newOwner) public onlyOwner {
22         require(newOwner != address(0) && newOwner != owner);
23         ownerCandidate = newOwner;
24     }
25 
26     function acceptOwnerTransfer() public {
27         require(msg.sender == ownerCandidate);
28         emit OwnerTransfer(owner, ownerCandidate);
29         owner = ownerCandidate;
30     }
31 
32 }
33 
34 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
35 
36 
37 contract TokenERC20 {
38     // Public variables of the token
39     string public name;
40     string public symbol;
41     uint8 public decimals = 18;
42     uint256 initialSupply=5000000000;
43     // 18 decimals is the strongly suggested default, avoid changing it
44     uint256 public totalSupply;
45 
46     // This creates an array with all balances
47     mapping (address => uint256) public balanceOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     // This generates a public event on the blockchain that will notify clients
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     // This notifies clients about the amount burnt
54     event Burn(address indexed from, uint256 value);
55 
56     /**
57      * Constrctor function
58      *
59      * Initializes contract with initial supply tokens to the creator of the contract
60      */
61     function TokenERC20() public {
62         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
63         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
64         name = "Zmbc";                                   // Set the name for display purposes
65         symbol = "ZMB";                               // Set the symbol for display purposes
66     }
67 
68     /**
69      * Internal transfer, only can be called by this contract
70      */
71     function _transfer(address _from, address _to, uint _value) internal {
72         // Prevent transfer to 0x0 address. Use burn() instead
73         require(_to != 0x0);
74         // Check if the sender has enough
75         require(balanceOf[_from] >= _value);
76         // Check for overflows
77         require(balanceOf[_to] + _value > balanceOf[_to]);
78         // Save this for an assertion in the future
79         uint previousBalances = balanceOf[_from] + balanceOf[_to];
80         // Subtract from the sender
81         balanceOf[_from] -= _value;
82         // Add the same to the recipient
83         balanceOf[_to] += _value;
84         emit Transfer(_from, _to, _value);
85         // Asserts are used to use static analysis to find bugs in your code. They should never fail
86         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
87     }
88 
89     /**
90      * Transfer tokens
91      *
92      * Send `_value` tokens to `_to` from your account
93      *
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transfer(address _to, uint256 _value) public {
98         _transfer(msg.sender, _to, _value);
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
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
141         public
142         returns (bool success) {
143         tokenRecipient spender = tokenRecipient(_spender);
144         if (approve(_spender, _value)) {
145             spender.receiveApproval(msg.sender, _value, this, _extraData);
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
185 /*       Zmbc TOKEN STARTS HERE       */
186 /******************************************/
187 
188 contract Zmbc is owned, TokenERC20 {
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
199     function Zmbc() TokenERC20() public {}
200 
201     /* Internal transfer, only can be called by this contract */
202     function _transfer(address _from, address _to, uint _value) internal {
203         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
204         require (balanceOf[_from] >= _value);               // Check if the sender has enough
205         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
206         require(!frozenAccount[_from]);                     // Check if sender is frozen
207         require(!frozenAccount[_to]);                       // Check if recipient is frozen
208         balanceOf[_from] -= _value;                         // Subtract from the sender
209         balanceOf[_to] += _value;                           // Add the same to the recipient
210         emit Transfer(_from, _to, _value);
211     }
212 
213     /// @notice Create `mintedAmount` tokens and send it to `target`
214     /// @param target Address to receive the tokens
215     /// @param mintedAmount the amount of tokens it will receive
216     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
217         balanceOf[target] += mintedAmount;
218         totalSupply += mintedAmount;
219         emit Transfer(0, this, mintedAmount);
220         emit Transfer(this, target, mintedAmount);
221     }
222 
223     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
224     /// @param target Address to be frozen
225     /// @param freeze either to freeze it or not
226     function freezeAccount(address target, bool freeze) onlyOwner public {
227         frozenAccount[target] = freeze;
228         emit FrozenFunds(target, freeze);
229     }
230 
231     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
232     /// @param newSellPrice Price the users can sell to the contract
233     /// @param newBuyPrice Price users can buy from the contract
234     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
235         sellPrice = newSellPrice;
236         buyPrice = newBuyPrice;
237     }
238 
239     /// @notice Buy tokens from contract by sending ether
240     function buy() payable public {
241         uint amount = msg.value / buyPrice;               // calculates the amount
242         _transfer(this, msg.sender, amount);              // makes the transfers
243     }
244 
245     /// @notice Sell `amount` tokens to contract
246     /// @param amount amount of tokens to be sold
247     function sell(uint256 amount) public {
248 
249         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
250         _transfer(msg.sender, this, amount);              // makes the transfers
251         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
252     }
253 }