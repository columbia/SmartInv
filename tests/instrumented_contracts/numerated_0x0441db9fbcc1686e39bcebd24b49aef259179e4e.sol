1 pragma solidity ^0.4.21;
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
18 
19     function destruct() public onlyOwner {
20         selfdestruct(owner);
21     }
22 }
23 
24 
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
26 
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
43     // This notifies clients about the amount burnt
44     event Burn(address indexed from, uint256 value);
45 
46     /**
47      * Constrctor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     function TokenERC20() public {
52         totalSupply = 10000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54         name = "World Safety Security Token";                                   // Set the name for display purposes
55         symbol = "WSS";                               // Set the symbol for display purposes
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
74         emit Transfer(_from, _to, _value);
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
151         emit Burn(msg.sender, _value);
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
169         emit Burn(_from, _value);
170         return true;
171     }
172 }
173 
174 /******************************************/
175 /*       ADVANCED TOKEN STARTS HERE       */
176 /******************************************/
177 
178 contract WorldSafetySecurityToken is owned, TokenERC20 {
179 
180     uint256 public sellPrice;
181     uint256 public buyPrice;
182 	uint256 public decimals = 18;
183 	string  public tokenName;
184 	string  public tokenSymbol;
185 	string  public PartnerUrl;
186 	uint minBalanceForAccounts;                                         //threshold amount
187 
188     mapping (address => bool) public frozenAccount;
189 
190     /* This generates a public event on the blockchain that will notify clients */
191     event FrozenFunds(address target, bool frozen);
192 
193     /* Initializes contract with initial supply tokens to the creator of the contract */
194 
195 	
196 	function WorldSafetySecurityToken() public {
197 		owner = msg.sender;
198 		totalSupply = 10000000000000000000000000000;
199 		balanceOf[owner]=totalSupply;
200 		tokenName="World Safety Security Token";
201 		tokenSymbol="WSS";
202 	}
203 
204 
205     /* Internal transfer, only can be called by this contract */
206     function _transfer(address _from, address _to, uint _value) internal {
207         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
208         require (balanceOf[_from] >= _value);               // Check if the sender has enough
209         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
210         require(!frozenAccount[_from]);                     // Check if sender is frozen
211         require(!frozenAccount[_to]);                       // Check if recipient is frozen
212         balanceOf[_from] -= _value;                         // Subtract from the sender
213         balanceOf[_to] += _value;                           // Add the same to the recipient
214         emit Transfer(_from, _to, _value);
215     }
216 
217     /// @notice Create `mintedAmount` tokens and send it to `target`
218     /// @param target Address to receive the tokens
219     /// @param mintedAmount the amount of tokens it will receive
220     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
221         balanceOf[target] += mintedAmount;
222         totalSupply += mintedAmount;
223         emit Transfer(0, this, mintedAmount);
224         emit Transfer(this, target, mintedAmount);
225     }
226 
227     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
228     /// @param target Address to be frozen
229     /// @param freeze either to freeze it or not
230     function freezeAccount(address target, bool freeze) onlyOwner public {
231         frozenAccount[target] = freeze;
232         emit FrozenFunds(target, freeze);
233     }
234 
235     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
236     /// @param newSellPrice Price the users can sell to the contract
237     /// @param newBuyPrice Price users can buy from the contract
238     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
239         sellPrice = newSellPrice;
240         buyPrice = newBuyPrice;
241     }
242 
243     /// @notice Buy tokens from contract by sending ether
244     function buy() payable public {
245         uint amount = msg.value / buyPrice;               // calculates the amount
246         _transfer(this, msg.sender, amount);              // makes the transfers
247     }
248 
249     /// @notice Sell `amount` tokens to contract
250     ///@param amount amount of tokens to be sold
251     function sell(uint256 amount) public {
252         //require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
253         require(balanceOf[msg.sender] >= amount * sellPrice);      // checks if the contract has enough ether to buy
254         _transfer(msg.sender, this, amount);              // makes the transfers
255         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
256     }
257 
258 
259 	/* 设置自动补充gas的阈值信息 201803202232  james */ 
260 	function setMinBalance(uint minimumBalanceInFinney) public onlyOwner {
261 		minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
262 	}
263 
264 	/* 设置tokenname */
265 	function setTokenName(string newTokenName) public onlyOwner{
266 		tokenName = newTokenName;
267 		name	= newTokenName;
268 	}
269 	/* 设置tokenSymbol */
270 	function setTokenSymbol(string newTokenSymbol) public onlyOwner{
271 		tokenSymbol = newTokenSymbol;
272 		symbol = newTokenSymbol;
273 	}
274 	/* 空投 */
275     function AirDrop(address[] dests, uint256[] values) public onlyOwner returns(uint256) {
276         uint256 i = 0;
277         while (i < dests.length) {
278 			_transfer(this,dests[i], values[i]);
279             i += 1;
280         }
281         return i;
282         
283     }
284 
285 
286 }