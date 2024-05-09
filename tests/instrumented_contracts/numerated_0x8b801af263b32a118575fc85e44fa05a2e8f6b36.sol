1 /** 官方高級token */
2 
3 
4 pragma solidity ^0.4.18;
5 
6 contract owned {
7     address public owner;
8 
9     function owned() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) onlyOwner public {
19         owner = newOwner;
20     }
21 
22     function destruct() public onlyOwner {
23         selfdestruct(owner);
24     }
25 }
26 
27 
28 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
29 
30 
31 contract TokenERC20 {
32     // Public variables of the token
33     string public name;
34     string public symbol;
35     uint8 public decimals = 18;
36     // 18 decimals is the strongly suggested default, avoid changing it
37     uint256 public totalSupply;
38 
39     // This creates an array with all balances
40     mapping (address => uint256) public balanceOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42 
43     // This generates a public event on the blockchain that will notify clients
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     // This notifies clients about the amount burnt
47     event Burn(address indexed from, uint256 value);
48 
49     /**
50      * Constrctor function
51      *
52      * Initializes contract with initial supply tokens to the creator of the contract
53      */
54     function TokenERC20() public {
55         totalSupply = 500000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
56         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
57         name = "CIBN Live Token";                                   // Set the name for display purposes
58         symbol = "CIBN";                               // Set the symbol for display purposes
59     }
60 
61     /**
62      * Internal transfer, only can be called by this contract
63      */
64     function _transfer(address _from, address _to, uint _value) internal {
65         // Prevent transfer to 0x0 address. Use burn() instead
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balanceOf[_from] >= _value);
69         // Check for overflows
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71         // Save this for an assertion in the future
72         uint previousBalances = balanceOf[_from] + balanceOf[_to];
73         // Subtract from the sender
74         balanceOf[_from] -= _value;
75         // Add the same to the recipient
76         balanceOf[_to] += _value;
77         emit Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public {
91         _transfer(msg.sender, _to, _value);
92     }
93 
94     /**
95      * Transfer tokens from other address
96      *
97      * Send `_value` tokens to `_to` in behalf of `_from`
98      *
99      * @param _from The address of the sender
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         require(_value <= allowance[_from][msg.sender]);     // Check allowance
105         allowance[_from][msg.sender] -= _value;
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address
112      *
113      * Allows `_spender` to spend no more than `_value` tokens in your behalf
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      */
118     function approve(address _spender, uint256 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
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
181 contract CIBNLiveInteractiveToken is owned, TokenERC20 {
182 
183     uint256 public sellPrice;
184     uint256 public buyPrice;
185 	uint256 public decimals = 18;
186 	string  public tokenName;
187 	string  public tokenSymbol;
188 	uint minBalanceForAccounts ;                                         //threshold amount
189 
190     mapping (address => bool) public frozenAccount;
191 
192     /* This generates a public event on the blockchain that will notify clients */
193     event FrozenFunds(address target, bool frozen);
194 
195     /* Initializes contract with initial supply tokens to the creator of the contract */
196 
197 	
198 	function CIBNLiveInteractiveToken() public {
199 		owner = msg.sender;
200 		totalSupply = 50000000000000000000000000;
201 		balanceOf[owner]=totalSupply;
202 		tokenName="CIBN Live Token";
203 		tokenSymbol="CIBN";
204 	}
205 
206 
207     /* Internal transfer, only can be called by this contract */
208     function _transfer(address _from, address _to, uint _value) internal {
209         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
210         require (balanceOf[_from] >= _value);               // Check if the sender has enough
211         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
212         require(!frozenAccount[_from]);                     // Check if sender is frozen
213         require(!frozenAccount[_to]);                       // Check if recipient is frozen
214         balanceOf[_from] -= _value;                         // Subtract from the sender
215         balanceOf[_to] += _value;                           // Add the same to the recipient
216         emit Transfer(_from, _to, _value);
217     }
218 
219     /// @notice Create `mintedAmount` tokens and send it to `target`
220     /// @param target Address to receive the tokens
221     /// @param mintedAmount the amount of tokens it will receive
222     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
223         balanceOf[target] += mintedAmount;
224         totalSupply += mintedAmount;
225         emit Transfer(0, this, mintedAmount);
226         emit Transfer(this, target, mintedAmount);
227     }
228 
229     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
230     /// @param target Address to be frozen
231     /// @param freeze either to freeze it or not
232     function freezeAccount(address target, bool freeze) onlyOwner public {
233         frozenAccount[target] = freeze;
234         emit FrozenFunds(target, freeze);
235     }
236 
237     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
238     /// @param newSellPrice Price the users can sell to the contract
239     /// @param newBuyPrice Price users can buy from the contract
240     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
241         sellPrice = newSellPrice;
242         buyPrice = newBuyPrice;
243     }
244 
245     /// @notice Buy tokens from contract by sending ether
246     function buy() payable public {
247         uint amount = msg.value / buyPrice;               // calculates the amount
248         _transfer(this, msg.sender, amount);              // makes the transfers
249     }
250 
251     /// @notice Sell `amount` tokens to contract
252     ///@param amount amount of tokens to be sold
253     function sell(uint256 amount) public {
254         //require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
255         require(balanceOf[msg.sender] >= amount * sellPrice);      // checks if the contract has enough ether to buy
256         _transfer(msg.sender, this, amount);              // makes the transfers
257         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
258     }
259 
260 
261 	/* 设置自动补充gas的阈值信息 201803202232  james */ 
262 	function setMinBalance(uint minimumBalanceInFinney) public onlyOwner {
263 		minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
264 	}
265 
266 	/* 设置tokenname */
267 	function setTokenName(string newTokenName) public onlyOwner{
268 		tokenName = newTokenName;
269 		name	= newTokenName;
270 	}
271 	/* 设置tokenSymbol */
272 	function setTokenSymbol(string newTokenSymbol) public onlyOwner{
273 		tokenSymbol = newTokenSymbol;
274 		symbol = newTokenSymbol;
275 	}
276 	/* 空投 */
277     function AirDrop(address[] dests, uint256[] values) public onlyOwner returns(uint256) {
278         uint256 i = 0;
279         while (i < dests.length) {
280 			_transfer(this,dests[i], values[i]);
281             i += 1;
282         }
283         return i;
284         
285     }
286 
287 }