1 pragma solidity >=0.4.22 <0.6.0;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 
37 
38 interface tokenRecipient {
39     //function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
40     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
41 
42 }
43 
44 
45 contract TokenERC20 {
46     // Public variables of the token
47     string public name;
48     string public symbol;
49     uint8 public decimals = 18;
50     // 18 decimals is the strongly suggested default, avoid changing it
51     uint256 public totalSupply;
52 
53     // This creates an array with all balances
54     mapping (address => uint256) public balanceOf;
55     mapping (address => mapping (address => uint256)) public allowance;
56 
57     // This generates a public event on the blockchain that will notify clients
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 
60     // This generates a public event on the blockchain that will notify clients
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 
63     // This notifies clients about the amount burnt
64     event Burn(address indexed from, uint256 value);
65 
66     /**
67      * Constrctor function
68      *
69      * Initializes contract with initial supply tokens to the creator of the contract
70      */
71     constructor(
72         uint256 initialSupply,
73         string memory tokenName,
74         string memory tokenSymbol
75     ) public {
76         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
77         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
78         name = tokenName;                                       // Set the name for display purposes
79         symbol = tokenSymbol;                                   // Set the symbol for display purposes
80     }
81 
82     /**
83      * Internal transfer, only can be called by this contract
84      */
85     function _transfer(address _from, address _to, uint _value) internal {
86         // Prevent transfer to 0x0 address. Use burn() instead
87         require(_to != address(0x0));
88         // Check if the sender has enough
89         require(balanceOf[_from] >= _value);
90         // Check for overflows
91         require(balanceOf[_to] + _value > balanceOf[_to]);
92         // Save this for an assertion in the future
93         uint previousBalances = balanceOf[_from] + balanceOf[_to];
94         // Subtract from the sender
95         balanceOf[_from] -= _value;
96         // Add the same to the recipient
97         balanceOf[_to] += _value;
98         emit Transfer(_from, _to, _value);
99         // Asserts are used to use static analysis to find bugs in your code. They should never fail
100         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
101     }
102 
103     /**
104      * Transfer tokens
105      *
106      * Send `_value` tokens to `_to` from your account
107      *
108      * @param _to The address of the recipient
109      * @param _value the amount to send
110      */
111     function transfer(address _to, uint256 _value) public returns (bool success) {
112         _transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     /**
117      * Transfer tokens from other address
118      *
119      * Send `_value` tokens to `_to` in behalf of `_from`
120      *
121      * @param _from The address of the sender
122      * @param _to The address of the recipient
123      * @param _value the amount to send
124      */
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
126         require(_value <= allowance[_from][msg.sender]);     // Check allowance
127         allowance[_from][msg.sender] -= _value;
128         _transfer(_from, _to, _value);
129         return true;
130     }
131 
132     /**
133      * Set allowance for other address
134      *
135      * Allows `_spender` to spend no more than `_value` tokens in your behalf
136      *
137      * @param _spender The address authorized to spend
138      * @param _value the max amount they can spend
139      */
140     function approve(address _spender, uint256 _value) public
141         returns (bool success) {
142         allowance[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     /**
148      * Set allowance for other address and notify
149      *
150      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
151      *
152      * @param _spender The address authorized to spend
153      * @param _value the max amount they can spend
154      * @param _extraData some extra information to send to the approved contract
155      */
156     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
157         public
158         returns (bool success) {
159         tokenRecipient spender = tokenRecipient(_spender);
160         if (approve(_spender, _value)) {
161             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
162             return true;
163         }
164     }
165 
166     /**
167      * Destroy tokens
168      *
169      * Remove `_value` tokens from the system irreversibly
170      *
171      * @param _value the amount of money to burn
172      */
173     function burn(uint256 _value) public returns (bool success) {
174         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
175         balanceOf[msg.sender] -= _value;            // Subtract from the sender
176         totalSupply -= _value;                      // Updates totalSupply
177         emit Burn(msg.sender, _value);
178         return true;
179     }
180 
181     /**
182      * Destroy tokens from other account
183      *
184      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
185      *
186      * @param _from the address of the sender
187      * @param _value the amount of money to burn
188      */
189     function burnFrom(address _from, uint256 _value) public returns (bool success) {
190         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
191         require(_value <= allowance[_from][msg.sender]);    // Check allowance
192         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
193         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
194         totalSupply -= _value;                              // Update totalSupply
195         emit Burn(_from, _value);
196         return true;
197     }
198 }
199 
200 
201 contract owned {
202     address public owner;
203 
204     constructor() public {
205         owner = msg.sender;
206     }
207 
208     modifier onlyOwner {
209         require(msg.sender == owner);
210         _;
211     }
212 
213     function transferOwnership(address newOwner) onlyOwner public {
214         owner = newOwner;
215     }
216 }
217 /******************************************/
218 /*       ADVANCED TOKEN STARTS HERE       */
219 /******************************************/
220 
221 contract GOLDEnterainmentToken is owned, TokenERC20 {
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
232     constructor(
233         uint256 initialSupply,
234         string memory tokenName,
235         string memory tokenSymbol
236     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
237 
238     /* Internal transfer, only can be called by this contract */
239     function _transfer(address _from, address _to, uint _value) internal {
240         require (_to != address(0x0));                          // Prevent transfer to 0x0 address. Use burn() instead
241         require (balanceOf[_from] >= _value);                   // Check if the sender has enough
242         require (balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
243         require(!frozenAccount[_from]);                         // Check if sender is frozen
244         require(!frozenAccount[_to]);                           // Check if recipient is frozen
245         balanceOf[_from] -= _value;                             // Subtract from the sender
246         balanceOf[_to] += _value;                               // Add the same to the recipient
247         emit Transfer(_from, _to, _value);
248     }
249 
250     /// @notice Create `mintedAmount` tokens and send it to `target`
251     /// @param target Address to receive the tokens
252     /// @param mintedAmount the amount of tokens it will receive
253     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
254         balanceOf[target] += mintedAmount;
255         totalSupply += mintedAmount;
256         emit Transfer(address(0), address(this), mintedAmount);
257         emit Transfer(address(this), target, mintedAmount);
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
278         uint amount = msg.value / buyPrice;                 // calculates the amount
279         _transfer(address(this), msg.sender, amount);       // makes the transfers
280     }
281 
282     /// @notice Sell `amount` tokens to contract
283     /// @param amount amount of tokens to be sold
284     function sell(uint256 amount) public {
285         address myAddress = address(this);
286         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
287         _transfer(msg.sender, address(this), amount);       // makes the transfers
288         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
289     }
290 }