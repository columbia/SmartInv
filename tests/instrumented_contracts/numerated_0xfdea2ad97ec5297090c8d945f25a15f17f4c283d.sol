1 /**
2 ----------------------------------------------------------------------------------------------
3 FreeCoin Token Contract, version 3.01
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
39     uint public free = 100 * 10 ** uint256(decimals);
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
53     function changeFree(uint newFree) public {
54         free = newFree;
55     }
56 
57 
58     function balanceOf(address _owner) public constant returns (uint balance) {
59 		//if (!created[_owner] ) {
60 		if (!created[_owner] && balances[_owner] == 0) {
61 			return free;
62 		}
63 		else
64 		{
65 			return balances[_owner];
66 		}
67 	}
68 
69 
70 
71     /**
72      * Constructor function
73      *
74      * Initializes contract with initial supply tokens to the creator of the contract
75      */
76     function TokenERC20(
77         uint256 initialSupply,
78         string tokenName,
79         string tokenSymbol
80     ) public {
81         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
82         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
83         name = tokenName;                                   // Set the name for display purposes
84         symbol = tokenSymbol;                               // Set the symbol for display purposes
85    		created[msg.sender] = true;
86     }
87 
88     /**
89      * Internal transfer, only can be called by this contract
90      */
91     function _transfer(address _from, address _to, uint _value) internal {
92         // Prevent transfer to 0x0 address. Use burn() instead
93         require(_to != 0x0);
94         
95         if (!created[_from]) {
96 			balances[_from] = free;
97 			created[_from] = true;
98 		}
99 
100         if (!created[_to]) {
101 			created[_to] = true;
102 		}
103 
104 
105         // Check if the sender has enough
106         require(balances[_from] >= _value);
107         // Check for overflows
108         require(balances[_to] + _value >= balances[_to]);
109         // Save this for an assertion in the future
110         uint previousBalances = balances[_from] + balances[_to];
111         // Subtract from the sender
112         balances[_from] -= _value;
113         // Add the same to the recipient
114         balances[_to] += _value;
115 
116         emit Transfer(_from, _to, _value);
117         // Asserts are used to use static analysis to find bugs in your code. They should never fail
118         assert(balances[_from] + balances[_to] == previousBalances);
119     }
120 
121     /**
122      * Transfer tokens
123      *
124      * Send `_value` tokens to `_to` from your account
125      *
126      * @param _to The address of the recipient
127      * @param _value the amount to send
128      */
129     function transfer(address _to, uint256 _value) public {
130         _transfer(msg.sender, _to, _value);
131     }
132 
133     /**
134      * Transfer tokens from other address
135      *
136      * Send `_value` tokens to `_to` on behalf of `_from`
137      *
138      * @param _from The address of the sender
139      * @param _to The address of the recipient
140      * @param _value the amount to send
141      */
142     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
143         require(_value <= allowance[_from][msg.sender]);     // Check allowance
144         allowance[_from][msg.sender] -= _value;
145         _transfer(_from, _to, _value);
146         return true;
147     }
148 
149     /**
150      * Set allowance for other address
151      *
152      * Allows `_spender` to spend no more than `_value` tokens on your behalf
153      *
154      * @param _spender The address authorized to spend
155      * @param _value the max amount they can spend
156      */
157     function approve(address _spender, uint256 _value) public
158         returns (bool success) {
159         allowance[msg.sender][_spender] = _value;
160         return true;
161     }
162 
163     /**
164      * Set allowance for other address and notify
165      *
166      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
167      *
168      * @param _spender The address authorized to spend
169      * @param _value the max amount they can spend
170      * @param _extraData some extra information to send to the approved contract
171      */
172     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
173         public
174         returns (bool success) {
175         tokenRecipient spender = tokenRecipient(_spender);
176         if (approve(_spender, _value)) {
177             spender.receiveApproval(msg.sender, _value, this, _extraData);
178             return true;
179         }
180     }
181 
182     /**
183      * Destroy tokens
184      *
185      * Remove `_value` tokens from the system irreversibly
186      *
187      * @param _value the amount of money to burn
188      */
189     function burn(uint256 _value) public returns (bool success) {
190         require(balances[msg.sender] >= _value);   // Check if the sender has enough
191         balances[msg.sender] -= _value;            // Subtract from the sender
192         totalSupply -= _value;                      // Updates totalSupply
193         emit Burn(msg.sender, _value);
194         return true;
195     }
196 
197     /**
198      * Destroy tokens from other account
199      *
200      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
201      *
202      * @param _from the address of the sender
203      * @param _value the amount of money to burn
204      */
205     function burnFrom(address _from, uint256 _value) public returns (bool success) {
206         require(balances[_from] >= _value);                // Check if the targeted balance is enough
207         require(_value <= allowance[_from][msg.sender]);    // Check allowance
208         balances[_from] -= _value;                         // Subtract from the targeted balance
209         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
210         totalSupply -= _value;                              // Update totalSupply
211         emit Burn(_from, _value);
212         return true;
213     }
214 }
215 
216 
217 /******************************************/
218 /*       ADVANCED TOKEN STARTS HERE       */
219 /******************************************/
220 
221 contract FreeCoin is owned, TokenERC20 {
222 
223     uint256 public sellPrice;
224     uint256 public buyPrice;
225 
226     mapping (address => bool) public frozenAccount;
227 
228     /* This generates a public event on the blockchain that will notify clients */
229     event FrozenFunds(address target, bool frozen);
230 
231     /* Initializes contract with initial supply tokens to the creator of the contract */
232     function FreeCoin(
233         uint256 initialSupply,
234         string tokenName ,
235         string tokenSymbol
236     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
237 
238     /* Internal transfer, only can be called by this contract */
239     /**
240    function _transfer(address _from, address _to, uint _value) internal {
241         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
242         require (balances[_from] >= _value);               // Check if the sender has enough
243         require (balances[_to] + _value >= balances[_to]); // Check for overflows
244         require(!frozenAccount[_from]);                     // Check if sender is frozen
245         require(!frozenAccount[_to]);                       // Check if recipient is frozen
246         balances[_from] -= _value;                         // Subtract from the sender
247         balances[_to] += _value;                           // Add the same to the recipient
248         emit Transfer(_from, _to, _value);
249     }
250     **/
251 
252     /// @notice Create `mintedAmount` tokens and send it to `target`
253     /// @param target Address to receive the tokens
254     /// @param mintedAmount the amount of tokens it will receive
255     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
256         balances[target] += mintedAmount;
257         totalSupply += mintedAmount;
258         emit Transfer(0, this, mintedAmount);
259         emit Transfer(this, target, mintedAmount);
260     }
261 
262     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
263     /// @param target Address to be frozen
264     /// @param freeze either to freeze it or not
265     function freezeAccount(address target, bool freeze) onlyOwner public {
266         frozenAccount[target] = freeze;
267         emit FrozenFunds(target, freeze);
268     }
269 
270     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
271     /// @param newSellPrice Price the users can sell to the contract
272     /// @param newBuyPrice Price users can buy from the contract
273     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
274         sellPrice = newSellPrice;
275         buyPrice = newBuyPrice;
276     }
277 
278     /// @notice Buy tokens from contract by sending ether
279     function buy() payable public {
280         uint amount = msg.value / buyPrice;               // calculates the amount
281         _transfer(this, msg.sender, amount);              // makes the transfers
282     }
283 
284     /// @notice Sell `amount` tokens to contract
285     /// @param amount amount of tokens to be sold
286     function sell(uint256 amount) public {
287         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
288         _transfer(msg.sender, this, amount);              // makes the transfers
289         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
290     }
291 }