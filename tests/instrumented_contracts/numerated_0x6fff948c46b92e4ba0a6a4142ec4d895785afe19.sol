1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract YOI {
4     // Track how many tokens are owned by each address.
5     mapping (address => uint256) public balanceOf;
6 
7     string public name = "Yoi Crypto";
8     string public symbol = "YOI";
9     uint8 public decimals = 18;
10 
11     uint256 public totalSupply = 1000000000 * (uint256(10) ** decimals);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     constructor() public {
16         // Initially assign all tokens to the contract's creator.
17         balanceOf[msg.sender] = totalSupply;
18         emit Transfer(address(0), msg.sender, totalSupply);
19     }
20 
21     function transfer(address to, uint256 value) public returns (bool success) {
22         require(balanceOf[msg.sender] >= value);
23 
24         balanceOf[msg.sender] -= value;  // deduct from sender's balance
25         balanceOf[to] += value;          // add to recipient's balance
26         emit Transfer(msg.sender, to, value);
27         return true;
28     }
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 
32     mapping(address => mapping(address => uint256)) public allowance;
33 
34     function approve(address spender, uint256 value)
35         public
36         returns (bool success)
37     {
38         allowance[msg.sender][spender] = value;
39         emit Approval(msg.sender, spender, value);
40         return true;
41     }
42 
43     function transferFrom(address from, address to, uint256 value)
44         public
45         returns (bool success)
46     {
47         require(value <= balanceOf[from]);
48         require(value <= allowance[from][msg.sender]);
49 
50         balanceOf[from] -= value;
51         balanceOf[to] += value;
52         allowance[from][msg.sender] -= value;
53         emit Transfer(from, to, value);
54         return true;
55     }
56 }
57 contract owned {
58     address public owner;
59 
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address newOwner) onlyOwner public {
70         owner = newOwner;
71     }
72 }
73 
74 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
75 
76 contract TokenERC20 {
77     // Public variables of the token
78     string public name;
79     string public symbol;
80     uint8 public decimals = 18;
81     // 18 decimals is the strongly suggested default, avoid changing it
82     uint256 public totalSupply;
83 
84     // This creates an array with all balances
85     mapping (address => uint256) public balanceOf;
86     mapping (address => mapping (address => uint256)) public allowance;
87 
88     // This generates a public event on the blockchain that will notify clients
89     event Transfer(address indexed from, address indexed to, uint256 value);
90     
91     // This generates a public event on the blockchain that will notify clients
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 
94     // This notifies clients about the amount burnt
95     event Burn(address indexed from, uint256 value);
96 
97     /**
98      * Constrctor function
99      *
100      * Initializes contract with initial supply tokens to the creator of the contract
101      */
102     constructor(
103         uint256 initialSupply,
104         string memory tokenName,
105         string memory tokenSymbol
106     ) public {
107         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
108         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
109         name = tokenName;                                       // Set the name for display purposes
110         symbol = tokenSymbol;                                   // Set the symbol for display purposes
111     }
112 
113     /**
114      * Internal transfer, only can be called by this contract
115      */
116     function _transfer(address _from, address _to, uint _value) internal {
117         // Prevent transfer to 0x0 address. Use burn() instead
118         require(_to != address(0x0));
119         // Check if the sender has enough
120         require(balanceOf[_from] >= _value);
121         // Check for overflows
122         require(balanceOf[_to] + _value > balanceOf[_to]);
123         // Save this for an assertion in the future
124         uint previousBalances = balanceOf[_from] + balanceOf[_to];
125         // Subtract from the sender
126         balanceOf[_from] -= _value;
127         // Add the same to the recipient
128         balanceOf[_to] += _value;
129         emit Transfer(_from, _to, _value);
130         // Asserts are used to use static analysis to find bugs in your code. They should never fail
131         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
132     }
133 
134     /**
135      * Transfer tokens
136      *
137      * Send `_value` tokens to `_to` from your account
138      *
139      * @param _to The address of the recipient
140      * @param _value the amount to send
141      */
142     function transfer(address _to, uint256 _value) public returns (bool success) {
143         _transfer(msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148      * Transfer tokens from other address
149      *
150      * Send `_value` tokens to `_to` in behalf of `_from`
151      *
152      * @param _from The address of the sender
153      * @param _to The address of the recipient
154      * @param _value the amount to send
155      */
156     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
157         require(_value <= allowance[_from][msg.sender]);     // Check allowance
158         allowance[_from][msg.sender] -= _value;
159         _transfer(_from, _to, _value);
160         return true;
161     }
162 
163     /**
164      * Set allowance for other address
165      *
166      * Allows `_spender` to spend no more than `_value` tokens in your behalf
167      *
168      * @param _spender The address authorized to spend
169      * @param _value the max amount they can spend
170      */
171     function approve(address _spender, uint256 _value) public
172         returns (bool success) {
173         allowance[msg.sender][_spender] = _value;
174         emit Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179      * Set allowance for other address and notify
180      *
181      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
182      *
183      * @param _spender The address authorized to spend
184      * @param _value the max amount they can spend
185      * @param _extraData some extra information to send to the approved contract
186      */
187     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
188         public
189         returns (bool success) {
190         tokenRecipient spender = tokenRecipient(_spender);
191         if (approve(_spender, _value)) {
192             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
193             return true;
194         }
195     }
196 
197     /**
198      * Destroy tokens
199      *
200      * Remove `_value` tokens from the system irreversibly
201      *
202      * @param _value the amount of money to burn
203      */
204     function burn(uint256 _value) public returns (bool success) {
205         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
206         balanceOf[msg.sender] -= _value;            // Subtract from the sender
207         totalSupply -= _value;                      // Updates totalSupply
208         emit Burn(msg.sender, _value);
209         return true;
210     }
211 
212     /**
213      * Destroy tokens from other account
214      *
215      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
216      *
217      * @param _from the address of the sender
218      * @param _value the amount of money to burn
219      */
220     function burnFrom(address _from, uint256 _value) public returns (bool success) {
221         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
222         require(_value <= allowance[_from][msg.sender]);    // Check allowance
223         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
224         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
225         totalSupply -= _value;                              // Update totalSupply
226         emit Burn(_from, _value);
227         return true;
228     }
229 }
230 
231 /******************************************/
232 /*       ADVANCED TOKEN STARTS HERE       */
233 /******************************************/
234 
235 contract MyAdvancedToken is owned, TokenERC20 {
236 
237     uint256 public sellPrice;
238     uint256 public buyPrice;
239 
240     mapping (address => bool) public frozenAccount;
241 
242     /* This generates a public event on the blockchain that will notify clients */
243     event FrozenFunds(address target, bool frozen);
244 
245     /* Initializes contract with initial supply tokens to the creator of the contract */
246     constructor(
247         uint256 initialSupply,
248         string memory tokenName,
249         string memory tokenSymbol
250     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
251 
252     /* Internal transfer, only can be called by this contract */
253     function _transfer(address _from, address _to, uint _value) internal {
254         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
255         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
256         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
257         require(!frozenAccount[_from]);                         // Check if sender is frozen
258         require(!frozenAccount[_to]);                           // Check if recipient is frozen
259         balanceOf[_from] -= _value;                             // Subtract from the sender
260         balanceOf[_to] += _value;                               // Add the same to the recipient
261         emit Transfer(_from, _to, _value);
262     }
263 
264     /// @notice Create `mintedAmount` tokens and send it to `target`
265     /// @param target Address to receive the tokens
266     /// @param mintedAmount the amount of tokens it will receive
267     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
268         balanceOf[target] += mintedAmount;
269         totalSupply += mintedAmount;
270         emit Transfer(address(0), address(this), mintedAmount);
271         emit Transfer(address(this), target, mintedAmount);
272     }
273 
274     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
275     /// @param target Address to be frozen
276     /// @param freeze either to freeze it or not
277     function freezeAccount(address target, bool freeze) onlyOwner public {
278         frozenAccount[target] = freeze;
279         emit FrozenFunds(target, freeze);
280     }
281 
282     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
283     /// @param newSellPrice Price the users can sell to the contract
284     /// @param newBuyPrice Price users can buy from the contract
285     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
286         sellPrice = newSellPrice;
287         buyPrice = newBuyPrice;
288     }
289 
290     /// @notice Buy tokens from contract by sending ether
291     function buy() payable public {
292         uint amount = msg.value / buyPrice;                 // calculates the amount
293         _transfer(address(this), msg.sender, amount);       // makes the transfers
294     }
295 
296     /// @notice Sell `amount` tokens to contract
297     /// @param amount amount of tokens to be sold
298     function sell(uint256 amount) public {
299         address myAddress = address(this);
300         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
301         _transfer(msg.sender, address(this), amount);       // makes the transfers
302         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
303     }
304 }