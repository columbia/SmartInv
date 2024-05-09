1 pragma solidity ^0.4.20;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
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
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
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
75         emit Transfer(_from, _to, _value);
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
88     function transfer(address _to, uint256 _value) public returns (bool success) {
89         _transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     /**
94      * Transfer tokens from other address
95      *
96      * Send `_value` tokens to `_to` in behalf of `_from`
97      *
98      * @param _from The address of the sender
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);     // Check allowance
104         allowance[_from][msg.sender] -= _value;
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      */
117     function approve(address _spender, uint256 _value) public
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         emit Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address and notify
126      *
127      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      * @param _extraData some extra information to send to the approved contract
132      */
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
134         public
135         returns (bool success) {
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
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
181 contract BECToken is owned, TokenERC20 {
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
192     function BECToken(
193         uint256 initialSupply,
194         string tokenName,
195         string tokenSymbol
196     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
197 
198     /* Internal transfer, only can be called by this contract */
199     function _transfer(address _from, address _to, uint _value) internal {
200         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
201         require (balanceOf[_from] >= _value);               // Check if the sender has enough
202         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
203         require(!frozenAccount[_from]);                     // Check if sender is frozen
204         require(!frozenAccount[_to]);                       // Check if recipient is frozen
205         
206         // LOCK COINS
207         uint start = 1532964203;
208         
209         address peAccount = 0xb04905C01A755c97224Cf89be52364DD8B0b72A6;
210         address fundAccount = 0x0816b3Cb8aB12A2960200f30c92cE52d385acb7A;
211         address bizAccount = 0x44E108CFB3E0b353C946833eCDb157459EDb2002;
212         address teamAccount = 0xbF1485d55BCEeEbB116C2Cf31c7a12Ef342cAceC;
213         address partnerAccount = 0x9507Af24075c780024C48638C355ba5100Df3976;
214 
215         uint256 amount = _value;
216         address sender = _from;
217         uint256 balance = balanceOf[_from];
218 
219 
220         if (peAccount == sender) {
221             require((balance - amount) >= totalSupply * 65/100);
222         } else if (fundAccount == sender) {
223             if (now < start + 365 * 1 days) {
224                 require((balance - amount) >= totalSupply * 3/20 * 3/4);
225             } else if (now < start + (2*365+1) * 1 days){
226                 require((balance - amount) >= totalSupply * 3/20 * 2/4);
227             }else if (now < start + (3*365+1) * 1 days){
228                 require((balance - amount) >= totalSupply * 3/20 * 1/4);
229             }
230         } else if (bizAccount == sender) {
231             require((balance - amount) >= totalSupply * 4/5);
232         } else if (teamAccount == sender) {
233             if (now < start + 365 * 1 days) {
234                 require((balance - amount) >= totalSupply/10 * 3/4);
235             } else if (now < start + (2*365+1) * 1 days){
236                 require((balance - amount) >= totalSupply/10 * 2/4);
237             }else if (now < start + (3*365+1) * 1 days){
238                 require((balance - amount) >= totalSupply/10 * 1/4);
239             }
240         } else if (partnerAccount == sender) {
241             require((balance - amount) >= totalSupply * 4/5);
242         }
243 
244 
245         balanceOf[_from] -= _value;                         // Subtract from the sender
246         balanceOf[_to] += _value;                           // Add the same to the recipient
247         emit Transfer(_from, _to, _value);
248     }
249 
250     /// @notice Create `mintedAmount` tokens and send it to `target`
251     /// @param target Address to receive the tokens
252     /// @param mintedAmount the amount of tokens it will receive
253     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
254         balanceOf[target] += mintedAmount;
255         totalSupply += mintedAmount;
256         emit Transfer(0, this, mintedAmount);
257         emit Transfer(this, target, mintedAmount);
258     }
259 
260     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
261     /// @param target Address to be frozen
262     /// @param freeze either to freeze it or not
263     function freezeAccount(address target, bool freeze) onlyOwner public {
264         frozenAccount[target] = freeze;
265         emit FrozenFunds(target, freeze);
266     }
267 
268     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
269     /// @param newSellPrice Price the users can sell to the contract
270     /// @param newBuyPrice Price users can buy from the contract
271     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
272         sellPrice = newSellPrice;
273         buyPrice = newBuyPrice;
274     }
275 
276     /// @notice Buy tokens from contract by sending ether
277     function buy() payable public {
278         uint amount = msg.value / buyPrice;               // calculates the amount
279         _transfer(this, msg.sender, amount);              // makes the transfers
280     }
281 
282     /// @notice Sell `amount` tokens to contract
283     /// @param amount amount of tokens to be sold
284     function sell(uint256 amount) public {
285         address myAddress = this;
286         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
287         _transfer(msg.sender, this, amount);              // makes the transfers
288         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
289     }
290 }