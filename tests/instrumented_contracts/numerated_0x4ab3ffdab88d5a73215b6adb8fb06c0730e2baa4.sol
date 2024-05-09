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
28         OwnerTransfer(owner, ownerCandidate);
29         owner = ownerCandidate;
30     }
31 
32 }
33 
34 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
35 
36 contract TokenERC20 {
37     // Public variables of the token
38     string public name;
39     string public symbol;
40     uint8 public decimals = 18;
41     uint256 initialSupply=20000000000;
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
52     // This notifies clients about the amount burnt
53     event Burn(address indexed from, uint256 value);
54 
55     /**
56      * Constrctor function
57      *
58      * Initializes contract with initial supply tokens to the creator of the contract
59      */
60     function TokenERC20() public {
61         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
62         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
63         name = "Tube";                                   // Set the name for display purposes
64         symbol = "TUBE";                               // Set the symbol for display purposes
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
83         Transfer(_from, _to, _value);
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
96     function transfer(address _to, uint256 _value) public {
97         _transfer(msg.sender, _to, _value);
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
139     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
140         public
141         returns (bool success) {
142         tokenRecipient spender = tokenRecipient(_spender);
143         if (approve(_spender, _value)) {
144             spender.receiveApproval(msg.sender, _value, this, _extraData);
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
160         Burn(msg.sender, _value);
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
178         Burn(_from, _value);
179         return true;
180     }
181 }
182 
183 /******************************************/
184 /*       TUBE TOKEN STARTS HERE       */
185 /******************************************/
186 
187 contract Tube is owned, TokenERC20 {
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
198     function Tube() TokenERC20() public {}
199 
200     /* Internal transfer, only can be called by this contract */
201     function _transfer(address _from, address _to, uint _value) internal {
202         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
203         require (balanceOf[_from] >= _value);               // Check if the sender has enough
204         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
205         require(!frozenAccount[_from]);                     // Check if sender is frozen
206         require(!frozenAccount[_to]);                       // Check if recipient is frozen
207         balanceOf[_from] -= _value;                         // Subtract from the sender
208         balanceOf[_to] += _value;                           // Add the same to the recipient
209         Transfer(_from, _to, _value);
210     }
211 
212     /// @notice Create `mintedAmount` tokens and send it to `target`
213     /// @param target Address to receive the tokens
214     /// @param mintedAmount the amount of tokens it will receive
215     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
216         balanceOf[target] += mintedAmount;
217         totalSupply += mintedAmount;
218         Transfer(0, this, mintedAmount);
219         Transfer(this, target, mintedAmount);
220     }
221 
222     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
223     /// @param target Address to be frozen
224     /// @param freeze either to freeze it or not
225     function freezeAccount(address target, bool freeze) onlyOwner public {
226         frozenAccount[target] = freeze;
227         FrozenFunds(target, freeze);
228     }
229 
230     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
231     /// @param newSellPrice Price the users can sell to the contract
232     /// @param newBuyPrice Price users can buy from the contract
233     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
234         sellPrice = newSellPrice;
235         buyPrice = newBuyPrice;
236     }
237 
238     /// @notice Buy tokens from contract by sending ether
239     function buy() payable public {
240         uint amount = msg.value / buyPrice;               // calculates the amount
241         _transfer(this, msg.sender, amount);              // makes the transfers
242     }
243 
244     /// @notice Sell `amount` tokens to contract
245     /// @param amount amount of tokens to be sold
246     function sell(uint256 amount) public {
247         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
248         _transfer(msg.sender, this, amount);              // makes the transfers
249         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
250     }
251 }