1 pragma solidity ^0.4.0;
2 contract owned {
3     address public owner;
4     address public ownerCandidate;
5     event OwnerTransfer(address originalOwner, address currentOwner);
6 
7     function owned() public {
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
19 
20    function proposeNewOwner(address newOwner) public onlyOwner {
21         require(newOwner != address(0) && newOwner != owner);
22         ownerCandidate = newOwner;
23     }
24 
25     function acceptOwnerTransfer() public {
26         require(msg.sender == ownerCandidate);
27         OwnerTransfer(owner, ownerCandidate);
28         owner = ownerCandidate;
29     }
30 
31 }
32 
33 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
34 
35 contract TokenERC20 {
36     // Public variables of the token
37     string public name;
38     string public symbol;
39     uint8 public decimals = 18;
40     uint256 initialSupply=4000000000;
41     uint256 MAX_CAP = 4000000000;
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
63         name = "Ldt";                                   // Set the name for display purposes
64         symbol = "LDT";                               // Set the symbol for display purposes
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
96     function transfer(address _to, uint256 _value) public returns (bool success){
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
161         Burn(msg.sender, _value);
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
179         Burn(_from, _value);
180         return true;
181     }
182 }
183 
184 /******************************************/
185 /*       Ldt TOKEN STARTS HERE       */
186 /******************************************/
187 
188 contract Ldt is owned, TokenERC20 {
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
199     function Ldt() TokenERC20() public {}
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
210         Transfer(_from, _to, _value);
211     }
212 
213     /// @notice Create `mintedAmount` tokens and send it to `target`
214     /// @param target Address to receive the tokens
215     /// @param mintedAmount the amount of tokens it will receive
216     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
217         uint256 newTotalSuply = totalSupply + mintedAmount;
218         require(newTotalSuply>totalSupply && newTotalSuply <= MAX_CAP );
219 
220         balanceOf[target] += mintedAmount;
221         totalSupply += mintedAmount;
222         Transfer(0, this, mintedAmount);
223         Transfer(this, target, mintedAmount);
224     }
225 
226     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
227     /// @param target Address to be frozen
228     /// @param freeze either to freeze it or not
229     function freezeAccount(address target, bool freeze) onlyOwner public {
230         frozenAccount[target] = freeze;
231         FrozenFunds(target, freeze);
232     }
233 
234     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
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
248         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
249         _transfer(msg.sender, this, amount);              // makes the transfers
250         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
251     }
252 }