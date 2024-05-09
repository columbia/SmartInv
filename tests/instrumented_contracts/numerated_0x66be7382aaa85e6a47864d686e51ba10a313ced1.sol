1 /**
2 ----------------------------------------------------------------------------------------------
3 FreeCoin Token Contract, version 3.00
4 
5 Interwave Global
6 www.iw-global.com
7 ----------------------------------------------------------------------------------------------
8 **/
9  
10 pragma solidity ^0.4.16;
11 
12 contract owned {
13     address public owner;
14 
15     function owned() public {
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     function transferOwnership(address newOwner) onlyOwner public {
25         owner = newOwner;
26     }
27 }
28 
29 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
30 
31 contract TokenERC20 {
32     // Public variables of the token
33     string public name;
34     string public symbol;
35     uint8 public decimals = 18;
36     // 18 decimals is the strongly suggested default, avoid changing it
37     uint256 public totalSupply;
38     
39     uint public free = 100;
40 
41     // This creates an array with all balances
42     mapping (address => uint256) public balances;
43     mapping (address => mapping (address => uint256)) public allowance;
44     mapping (address => bool) public created;
45 
46     // This generates a public event on the blockchain that will notify clients
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     // This notifies clients about the amount burnt
50     event Burn(address indexed from, uint256 value);
51 
52 
53     function balanceOf(address _owner) public constant returns (uint balance) {
54 		//if (!created[_owner] ) {
55 		if (!created[_owner] && balances[_owner] == 0) {
56 			return free;
57 		}
58 		else
59 		{
60 			return balances[_owner];
61 		}
62 	}
63 
64 
65 
66     /**
67      * Constructor function
68      *
69      * Initializes contract with initial supply tokens to the creator of the contract
70      */
71     function TokenERC20(
72         uint256 initialSupply,
73         string tokenName,
74         string tokenSymbol
75     ) public {
76         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
77         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
78         name = tokenName;                                   // Set the name for display purposes
79         symbol = tokenSymbol;                               // Set the symbol for display purposes
80    		created[msg.sender] = true;
81     }
82 
83     /**
84      * Internal transfer, only can be called by this contract
85      */
86     function _transfer(address _from, address _to, uint _value) internal {
87         // Prevent transfer to 0x0 address. Use burn() instead
88         require(_to != 0x0);
89         
90         if (!created[_from]) {
91 			balances[_from] = free;
92 			created[_from] = true;
93 		}
94 
95         if (!created[_to]) {
96 			created[_to] = true;
97 		}
98 
99 
100         // Check if the sender has enough
101         require(balances[_from] >= _value);
102         // Check for overflows
103         require(balances[_to] + _value >= balances[_to]);
104         // Save this for an assertion in the future
105         uint previousBalances = balances[_from] + balances[_to];
106         // Subtract from the sender
107         balances[_from] -= _value;
108         // Add the same to the recipient
109         balances[_to] += _value;
110 
111         emit Transfer(_from, _to, _value);
112         // Asserts are used to use static analysis to find bugs in your code. They should never fail
113         assert(balances[_from] + balances[_to] == previousBalances);
114     }
115 
116     /**
117      * Transfer tokens
118      *
119      * Send `_value` tokens to `_to` from your account
120      *
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transfer(address _to, uint256 _value) public {
125         _transfer(msg.sender, _to, _value);
126     }
127 
128     /**
129      * Transfer tokens from other address
130      *
131      * Send `_value` tokens to `_to` on behalf of `_from`
132      *
133      * @param _from The address of the sender
134      * @param _to The address of the recipient
135      * @param _value the amount to send
136      */
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
138         require(_value <= allowance[_from][msg.sender]);     // Check allowance
139         allowance[_from][msg.sender] -= _value;
140         _transfer(_from, _to, _value);
141         return true;
142     }
143 
144     /**
145      * Set allowance for other address
146      *
147      * Allows `_spender` to spend no more than `_value` tokens on your behalf
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      */
152     function approve(address _spender, uint256 _value) public
153         returns (bool success) {
154         allowance[msg.sender][_spender] = _value;
155         return true;
156     }
157 
158     /**
159      * Set allowance for other address and notify
160      *
161      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
162      *
163      * @param _spender The address authorized to spend
164      * @param _value the max amount they can spend
165      * @param _extraData some extra information to send to the approved contract
166      */
167     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
168         public
169         returns (bool success) {
170         tokenRecipient spender = tokenRecipient(_spender);
171         if (approve(_spender, _value)) {
172             spender.receiveApproval(msg.sender, _value, this, _extraData);
173             return true;
174         }
175     }
176 
177     /**
178      * Destroy tokens
179      *
180      * Remove `_value` tokens from the system irreversibly
181      *
182      * @param _value the amount of money to burn
183      */
184     function burn(uint256 _value) public returns (bool success) {
185         require(balances[msg.sender] >= _value);   // Check if the sender has enough
186         balances[msg.sender] -= _value;            // Subtract from the sender
187         totalSupply -= _value;                      // Updates totalSupply
188         emit Burn(msg.sender, _value);
189         return true;
190     }
191 
192     /**
193      * Destroy tokens from other account
194      *
195      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
196      *
197      * @param _from the address of the sender
198      * @param _value the amount of money to burn
199      */
200     function burnFrom(address _from, uint256 _value) public returns (bool success) {
201         require(balances[_from] >= _value);                // Check if the targeted balance is enough
202         require(_value <= allowance[_from][msg.sender]);    // Check allowance
203         balances[_from] -= _value;                         // Subtract from the targeted balance
204         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
205         totalSupply -= _value;                              // Update totalSupply
206         emit Burn(_from, _value);
207         return true;
208     }
209 }
210 
211 
212 /******************************************/
213 /*       ADVANCED TOKEN STARTS HERE       */
214 /******************************************/
215 
216 contract FreeCoin is owned, TokenERC20 {
217 
218     uint256 public sellPrice;
219     uint256 public buyPrice;
220 
221     mapping (address => bool) public frozenAccount;
222 
223     /* This generates a public event on the blockchain that will notify clients */
224     event FrozenFunds(address target, bool frozen);
225 
226     /* Initializes contract with initial supply tokens to the creator of the contract */
227     function FreeCoin(
228         uint256 initialSupply,
229         string tokenName ,
230         string tokenSymbol
231     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
232 
233     /* Internal transfer, only can be called by this contract */
234     /**
235    function _transfer(address _from, address _to, uint _value) internal {
236         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
237         require (balances[_from] >= _value);               // Check if the sender has enough
238         require (balances[_to] + _value >= balances[_to]); // Check for overflows
239         require(!frozenAccount[_from]);                     // Check if sender is frozen
240         require(!frozenAccount[_to]);                       // Check if recipient is frozen
241         balances[_from] -= _value;                         // Subtract from the sender
242         balances[_to] += _value;                           // Add the same to the recipient
243         emit Transfer(_from, _to, _value);
244     }
245     **/
246 
247     /// @notice Create `mintedAmount` tokens and send it to `target`
248     /// @param target Address to receive the tokens
249     /// @param mintedAmount the amount of tokens it will receive
250     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
251         balances[target] += mintedAmount;
252         totalSupply += mintedAmount;
253         emit Transfer(0, this, mintedAmount);
254         emit Transfer(this, target, mintedAmount);
255     }
256 
257     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
258     /// @param target Address to be frozen
259     /// @param freeze either to freeze it or not
260     function freezeAccount(address target, bool freeze) onlyOwner public {
261         frozenAccount[target] = freeze;
262         emit FrozenFunds(target, freeze);
263     }
264 
265     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
266     /// @param newSellPrice Price the users can sell to the contract
267     /// @param newBuyPrice Price users can buy from the contract
268     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
269         sellPrice = newSellPrice;
270         buyPrice = newBuyPrice;
271     }
272 
273     /// @notice Buy tokens from contract by sending ether
274     function buy() payable public {
275         uint amount = msg.value / buyPrice;               // calculates the amount
276         _transfer(this, msg.sender, amount);              // makes the transfers
277     }
278 
279     /// @notice Sell `amount` tokens to contract
280     /// @param amount amount of tokens to be sold
281     function sell(uint256 amount) public {
282         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
283         _transfer(msg.sender, this, amount);              // makes the transfers
284         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
285     }
286 }