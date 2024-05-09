1 pragma solidity ^0.4.16;
2 
3 //Manage
4 contract owned {
5     address public owner;
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
19 }
20 
21 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
22 
23 contract TokenERC20 {
24     // Public variables of the token
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;
28     // 18 decimals is the strongly suggested default, avoid changing it
29     uint256 public totalSupply;
30 
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => uint256) public frozenOf;//Frozen token
34     mapping (address => bool) public isfrozenOf;//Limited or not
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     function TokenERC20(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = tokenName;                                   // Set the name for display purposes
56         symbol = tokenSymbol;                               // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75         Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80     /**
81      * Transfer tokens
82      *
83      * Send `_value` tokens to `_to` from your account
84      *
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transfer(address _to, uint256 _value) public {
89         _transfer(msg.sender, _to, _value);
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
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address and notify
124      *
125      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      * @param _extraData some extra information to send to the approved contract
130      */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
132         public
133         returns (bool success) {
134         tokenRecipient spender = tokenRecipient(_spender);
135         if (approve(_spender, _value)) {
136             spender.receiveApproval(msg.sender, _value, this, _extraData);
137             return true;
138         }
139     }
140 
141     /**
142      * Destroy tokens
143      *
144      * Remove `_value` tokens from the system irreversibly
145      *
146      * @param _value the amount of money to burn
147      */
148     function burn(uint256 _value) public returns (bool success) {
149         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
150         balanceOf[msg.sender] -= _value;            // Subtract from the sender
151         totalSupply -= _value;                      // Updates totalSupply
152         Burn(msg.sender, _value);
153         return true;
154     }
155 
156     /**
157      * Destroy tokens from other account
158      *
159      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
160      *
161      * @param _from the address of the sender
162      * @param _value the amount of money to burn
163      */
164     function burnFrom(address _from, uint256 _value) public returns (bool success) {
165         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
166         require(_value <= allowance[_from][msg.sender]);    // Check allowance
167         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
168         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
169         totalSupply -= _value;                              // Update totalSupply
170         Burn(_from, _value);
171         return true;
172     }
173 }
174 
175 /******************************************/
176 /*       ADVANCED TOKEN STARTS HERE       */
177 /******************************************/
178 
179 contract MedicayunLink is owned, TokenERC20 {
180 
181     uint256 public sellPrice;
182     uint256 public buyPrice;
183 
184     mapping (address => bool) public frozenAccount;
185 
186 
187     /* This generates a public event on the blockchain that will notify clients */
188     //Freeze
189     event FrozenFunds(address target, bool frozen);
190     //Amount Locked 
191     event ClosedPeriod(address target,uint256 _value); 
192     
193     //Amount Release 
194     event ReleaseQuantity(address target,uint256 _value);
195     
196     /* Initializes contract with initial supply tokens to the creator of the contract */
197     function MedicayunLink(
198         uint256 initialSupply,
199         string tokenName,
200         string tokenSymbol
201     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
202 
203     /* Internal transfer, only can be called by this contract */
204     function _transfer(address _from, address _to, uint _value) internal {
205         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
206         require (balanceOf[_from] >= _value);               // Check if the sender has enough
207         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
208         require(!frozenAccount[_from]);                     // Check if sender is frozen
209         require(!frozenAccount[_to]);                       // Check if recipient is frozen
210         balanceOf[_from] -= _value;                         // Subtract from the sender
211         balanceOf[_to] += _value;                           // Add the same to the recipient
212         Transfer(_from, _to, _value);
213     }
214 
215     /// @notice Create `mintedAmount` tokens and send it to `target`
216     /// @param target Address to receive the tokens
217     /// @param mintedAmount the amount of tokens it will receive
218     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
219         balanceOf[target] += mintedAmount;
220         totalSupply += mintedAmount;
221         Transfer(0, this, mintedAmount);
222         Transfer(this, target, mintedAmount);
223     }
224 
225     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
226     /// @param target Address to be frozen
227     /// @param freeze either to freeze it or not
228     function freezeAccount(address target, bool freeze) onlyOwner public {
229         frozenAccount[target] = freeze;
230         FrozenFunds(target, freeze);
231     }
232     
233     //Amount Locked 
234     function PeriodOfAccount(address target,uint256 _value) onlyOwner public{
235          require (balanceOf[target] < _value);   
236          require(_value < 0);
237          balanceOf[target] = balanceOf[target] - _value;
238          frozenOf[target] = frozenOf[target] + _value;
239          ClosedPeriod(target,_value);
240     }
241     
242     //Amount Release
243     function ReleaseOfAccount(address target,uint256 _value) onlyOwner public{
244          require (frozenOf[target] < _value);
245          require(_value < 0);
246          frozenOf[target] = frozenOf[target] - _value;
247          balanceOf[target] = balanceOf[target] + _value;
248          ReleaseQuantity(target,_value);
249     }
250     
251     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
252     /// @param newSellPrice Price the users can sell to the contract
253     /// @param newBuyPrice Price users can buy from the contract
254     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
255         sellPrice = newSellPrice;
256         buyPrice = newBuyPrice;
257     }
258     /// @notice Buy tokens from contract by sending ether
259     function buy() payable public {
260         uint amount = msg.value / buyPrice;               // calculates the amount
261         _transfer(this, msg.sender, amount);              // makes the transfers
262     }
263 
264     /// @notice Sell `amount` tokens to contract
265     /// @param amount amount of tokens to be sold
266     function sell(uint256 amount) public {
267         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
268         _transfer(msg.sender, this, amount);              // makes the transfers
269         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
270     }
271 }