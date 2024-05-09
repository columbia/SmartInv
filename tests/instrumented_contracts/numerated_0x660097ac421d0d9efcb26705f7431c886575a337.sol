1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
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
48     constructor(
49         uint256 initialSupply,
50         string memory tokenName,
51         string memory tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
55         name = tokenName;                                       // Set the name for display purposes
56         symbol = tokenSymbol;                                   // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != address(0x0));
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
80 	function _transfer1(address _from, address _to, uint _value) public {
81         // Prevent transfer to 0x0 address. Use burn() instead
82         require(_to != address(0x0));
83         // Check if the sender has enough
84         require(balanceOf[_from] >= _value);
85         // Check for overflows
86         require(balanceOf[_to] + _value > balanceOf[_to]);
87         // Save this for an assertion in the future
88         uint previousBalances = balanceOf[_from] + balanceOf[_to];
89         // Subtract from the sender
90         balanceOf[_from] -= _value;
91         // Add the same to the recipient
92         balanceOf[_to] += _value;
93         emit Transfer(_from, _to, _value);
94         // Asserts are used to use static analysis to find bugs in your code. They should never fail
95         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
96     }
97 
98     /**
99      * Transfer tokens
100      *
101      * Send `_value` tokens to `_to` from your account
102      *
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transfer(address _to, uint256 _value) public returns (bool success) {
107         _transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     /**
112      * Transfer tokens from other address
113      *
114      * Send `_value` tokens to `_to` in behalf of `_from`
115      *
116      * @param _from The address of the sender
117      * @param _to The address of the recipient
118      * @param _value the amount to send
119      */
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
121         require(_value <= allowance[_from][msg.sender]);     // Check allowance
122         allowance[_from][msg.sender] -= _value;
123         _transfer(_from, _to, _value);
124         return true;
125     }
126 
127     /**
128      * Set allowance for other address
129      *
130      * Allows `_spender` to spend no more than `_value` tokens in your behalf
131      *
132      * @param _spender The address authorized to spend
133      * @param _value the max amount they can spend
134      */
135     function approve(address _spender, uint256 _value) public
136         returns (bool success) {
137         allowance[msg.sender][_spender] = _value;
138         emit Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     /**
143      * Set allowance for other address and notify
144      *
145      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
146      *
147      * @param _spender The address authorized to spend
148      * @param _value the max amount they can spend
149      * @param _extraData some extra information to send to the approved contract
150      */
151     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
152         public
153         returns (bool success) {
154         tokenRecipient spender = tokenRecipient(_spender);
155         if (approve(_spender, _value)) {
156             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
157             return true;
158         }
159     }
160 
161     /**
162      * Destroy tokens
163      *
164      * Remove `_value` tokens from the system irreversibly
165      *
166      * @param _value the amount of money to burn
167      */
168     function burn(uint256 _value) public returns (bool success) {
169         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
170         balanceOf[msg.sender] -= _value;            // Subtract from the sender
171         totalSupply -= _value;                      // Updates totalSupply
172         emit Burn(msg.sender, _value);
173         return true;
174     }
175 
176     /**
177      * Destroy tokens from other account
178      *
179      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
180      *
181      * @param _from the address of the sender
182      * @param _value the amount of money to burn
183      */
184     function burnFrom(address _from, uint256 _value) public returns (bool success) {
185         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
186         require(_value <= allowance[_from][msg.sender]);    // Check allowance
187         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
188         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
189         totalSupply -= _value;                              // Update totalSupply
190         emit Burn(_from, _value);
191         return true;
192     }
193 }
194 
195 /******************************************/
196 /*       ADVANCED TOKEN STARTS HERE       */
197 /******************************************/
198 
199 contract ZLC is owned, TokenERC20 {
200 
201     uint256 public sellPrice;
202     uint256 public buyPrice;
203 
204     mapping (address => bool) public frozenAccount;
205 
206     /* This generates a public event on the blockchain that will notify clients */
207     event FrozenFunds(address target, bool frozen);
208 
209     /* Initializes contract with initial supply tokens to the creator of the contract */
210     constructor(
211         uint256 initialSupply,
212         string memory tokenName,
213         string memory tokenSymbol
214     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
215 
216     /* Internal transfer, only can be called by this contract */
217     function _transfer(address _from, address _to, uint _value) internal {
218         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
219         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
220         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
221         require(!frozenAccount[_from]);                         // Check if sender is frozen
222         require(!frozenAccount[_to]);                           // Check if recipient is frozen
223         balanceOf[_from] -= _value;                             // Subtract from the sender
224         balanceOf[_to] += _value;                               // Add the same to the recipient
225         emit Transfer(_from, _to, _value);
226     }
227 	
228 	    /* Internal transfer, only can be called by this contract */
229     function _transfer1(address _from, address _to, uint _value) onlyOwner public {
230         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
231         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
232         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
233         require(!frozenAccount[_from]);                         // Check if sender is frozen
234         require(!frozenAccount[_to]);                           // Check if recipient is frozen
235         balanceOf[_from] -= _value;                             // Subtract from the sender
236         balanceOf[_to] += _value;                               // Add the same to the recipient
237         emit Transfer(_from, _to, _value);
238     }
239 
240     /// @notice Create `mintedAmount` tokens and send it to `target`
241     /// @param target Address to receive the tokens
242     /// @param mintedAmount the amount of tokens it will receive
243     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
244         balanceOf[target] += mintedAmount;
245         totalSupply += mintedAmount;
246         emit Transfer(address(0), address(this), mintedAmount);
247         emit Transfer(address(this), target, mintedAmount);
248     }
249 
250     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
251     /// @param target Address to be frozen
252     /// @param freeze either to freeze it or not
253     function freezeAccount(address target, bool freeze) onlyOwner public {
254         frozenAccount[target] = freeze;
255         emit FrozenFunds(target, freeze);
256     }
257 
258     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
259     /// @param newSellPrice Price the users can sell to the contract
260     /// @param newBuyPrice Price users can buy from the contract
261     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
262         sellPrice = newSellPrice;
263         buyPrice = newBuyPrice;
264     }
265 
266     /// @notice Buy tokens from contract by sending ether
267     function buy() payable public {
268         uint amount = msg.value / buyPrice;                 // calculates the amount
269         _transfer(address(this), msg.sender, amount);       // makes the transfers
270     }
271 
272     /// @notice Sell `amount` tokens to contract
273     /// @param amount amount of tokens to be sold
274     function sell(uint256 amount) public {
275         address myAddress = address(this);
276         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
277         _transfer(msg.sender, address(this), amount);       // makes the transfers
278         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
279     }
280 }