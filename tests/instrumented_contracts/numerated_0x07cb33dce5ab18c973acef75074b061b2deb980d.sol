1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor (GlobalARQ) public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract GlobalARQ {
23     string public constant _myTokeName = 'GlobalARQ';//change here
24     string public constant _mySymbol = 'ARQ';//change here
25     uint public constant _myinitialSupply = 100000000;//leave it
26     uint8 public constant _myDecimal =18;//leave it
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals;
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
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44 
45     constructor (
46         uint256 initialSupply,
47         string TokeName,
48         string tokenSymbol
49     )    public {
50         
51         decimals = _myDecimal;
52         totalSupply = _myinitialSupply * (10 ** uint256(_myDecimal));  // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54         name = _myTokeName;                                   // Set the name for display purposes
55         symbol = _mySymbol;                               // Set the symbol for display purposes
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) internal {
62         // Prevent transfer to 0x0 address. Use burn() instead
63         require(_to != 0x0);
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
74         Transfer (_from, _to, _value);
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
87     function transfer(address _to, uint256 _value) public {
88         _transfer(msg.sender, _to, _value);
89     }
90 
91     /**
92      * Transfer tokens from other address
93      *
94      * Send `_value` tokens to `_to` in behalf of `_from`
95      *
96      * @param _from The address of the sender
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         require(_value <= allowance[_from][msg.sender]);     // Check allowance
102         allowance[_from][msg.sender] -= _value;
103         _transfer(_from, _to, _value);
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      */
115     function approve(address _spender, uint256 _value) public
116         returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 
140     /**
141      * Destroy tokens
142      *
143      * Remove `_value` tokens from the system irreversibly
144      *
145      * @param _value the amount of money to burn
146      */
147     function burn(uint256 _value) public returns (bool success) {
148         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
149         balanceOf[msg.sender] -= _value;            // Subtract from the sender
150         totalSupply -= _value;                      // Updates totalSupply
151         Burn(msg.sender, _value);
152         return true;
153     }
154 
155     /**
156      * Destroy tokens from other account
157      *
158      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
159      *
160      * @param _from the address of the sender
161      * @param _value the amount of money to burn
162      */
163     function burnFrom(address _from, uint256 _value) public returns (bool success) {
164         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
165         require(_value <= allowance[_from][msg.sender]);    // Check allowance
166         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
167         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
168         totalSupply -= _value;                              // Update totalSupply
169         Burn(_from, _value);
170         return true;
171     }
172 }
173 
174 /******************************************/
175 /*       ADVANCED TOKEN STARTS HERE       */
176 /******************************************/
177 
178 contract constructor is owned, GlobalARQ {
179 
180 
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
191     constructor (
192         uint256 initialSupply,
193         string tokenName,
194         string tokenSymbol
195     ) GlobalARQ (initialSupply, tokenName, tokenSymbol) public {}
196 
197     /* Internal transfer, only can be called by this contract */
198     function _transfer(address _from, address _to, uint _value) internal {
199         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
200         require (balanceOf[_from] >= _value);               // Check if the sender has enough
201         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
202         require(!frozenAccount[_from]);                     // Check if sender is frozen
203         require(!frozenAccount[_to]);                       // Check if recipient is frozen
204         balanceOf[_from] -= _value;                         // Subtract from the sender
205         balanceOf[_to] += _value;                           // Add the same to the recipient
206         Transfer(_from, _to, _value);
207     }
208 
209     /// @notice Create `mintedAmount` tokens and send it to `target`
210     /// @param target Address to receive the tokens
211     /// @param mintedAmount the amount of tokens it will receive
212     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
213         balanceOf[target] += mintedAmount;
214         totalSupply += mintedAmount;
215         Transfer(0, this, mintedAmount);
216         Transfer(this, target, mintedAmount);
217     }
218 
219     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
220     /// @param target Address to be frozen
221     /// @param freeze either to freeze it or not
222     function freezeAccount(address target, bool freeze) onlyOwner public {
223         frozenAccount[target] = freeze;
224         FrozenFunds(target, freeze);
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
237         uint amount = msg.value / buyPrice;               // calculates the amount
238         _transfer(this, msg.sender, amount);              // makes the transfers
239     }
240 
241     /// @notice Sell `amount` tokens to contract
242     /// @param amount amount of tokens to be sold
243     function sell(uint256 amount) public {
244         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
245         _transfer(msg.sender, this, amount);              // makes the transfers
246         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
247     }
248 }