1 pragma solidity ^0.4.25;
2 
3 
4 library SafeMathUint256 {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         require(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a);
26         return c;
27     }
28 }
29 
30 contract owned {
31     address public owner;
32 
33     constructor () public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address newOwner) onlyOwner public {
43         require(newOwner != address(0));
44         owner = newOwner;
45     }
46 }
47 
48 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)  external; }
49 
50 contract TokenERC20 {
51     
52      mapping (address => bool) public frozenAccount;
53     // Public variables of the token
54     using SafeMathUint256 for uint256;
55     string public name;
56     string public symbol;
57     uint8 public decimals = 18;
58     // 18 decimals is the strongly suggested default, avoid changing it
59     uint256 public totalSupply;
60 
61     // This creates an array with all balances
62     mapping (address => uint256) public balanceOf;
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65     // This generates a public event on the blockchain that will notify clients
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68 
69     /**
70      * Constrctor function
71      *
72      * Initializes contract with initial supply tokens to the creator of the contract
73      */
74      
75     constructor (
76         uint256 initialSupply,
77         string tokenName,
78         string tokenSymbol
79     ) public {
80         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
81         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
82         name = tokenName;                                   // Set the name for display purposes
83         symbol = tokenSymbol;                               // Set the symbol for display purposes
84     }
85 
86     /**
87      * Internal transfer, only can be called by this contract
88      */
89     function _transfer(address _from, address _to, uint _value) internal {
90         // Prevent transfer to 0x0 address. Use burn() instead
91         require(_to != 0x0);
92         // Check if the sender has enough
93         require(balanceOf[_from] >= _value);
94         // Check for overflows
95         require(balanceOf[_to] + _value > balanceOf[_to]);
96         // Save this for an assertion in the future
97         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
98         // Subtract from the sender
99         balanceOf[_from] = balanceOf[_from].sub(_value);
100         // Add the same to the recipient
101         balanceOf[_to] = balanceOf[_to].add(_value);
102         emit Transfer(_from, _to, _value);
103         // Asserts are used to use static analysis to find bugs in your code. They should never fail
104         require((balanceOf[_from] + balanceOf[_to]) == previousBalances);
105     }
106 
107     /**
108      * Transfer tokens
109      *
110      * Send `_value` tokens to `_to` from your account
111      *
112      * @param _to The address of the recipient
113      * @param _value the amount to send
114      */
115     function transfer(address _to, uint256 _value) public returns (bool success) {
116         require(!frozenAccount[msg.sender]);   
117         require(!frozenAccount[_to]);   
118         _transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     /**
123      * Transfer tokens from other address
124      *
125      * Send `_value` tokens to `_to` in behalf of `_from`
126      *
127      * @param _from The address of the sender
128      * @param _to The address of the recipient
129      * @param _value the amount to send
130      */
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132         require(!frozenAccount[_from]);
133         require(!frozenAccount[msg.sender]);   
134         require(!frozenAccount[_to]);   
135         require(_value <= allowance[_from][msg.sender]);     // Check allowance
136         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
137         _transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /**
142      * Set allowance for other address
143      *
144      * Allows `_spender` to spend no more than `_value` tokens in your behalf
145      *
146      * @param _spender The address authorized to spend
147      * @param _value the max amount they can spend
148      */
149     function approve(address _spender, uint256 _value) public
150         returns (bool success) {
151         allowance[msg.sender][_spender] = _value;
152         return true;
153     }
154 
155     /**
156      * Set allowance for other address and notify
157      *
158      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
159      *
160      * @param _spender The address authorized to spend
161      * @param _value the max amount they can spend
162      * @param _extraData some extra information to send to the approved contract
163      */
164     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
165         public
166         returns (bool success) {
167         tokenRecipient spender = tokenRecipient(_spender);
168         require(approve(_spender, _value));
169         spender.receiveApproval(msg.sender, _value, this, _extraData);
170         return true;
171         
172     }
173 }
174 
175 /******************************************/
176 /*       ADVANCED TOKEN STARTS HERE       */
177 /******************************************/
178 
179 contract MyAdvancedToken is owned, TokenERC20 {
180 
181     uint256 public sellPrice;
182     uint256 public buyPrice;
183 
184    
185 
186     /* This generates a public event on the blockchain that will notify clients */
187     event FrozenFunds(address target, bool frozen);
188     
189     event Price(uint256 newSellPrice, uint256 newBuyPrice);
190 
191     /* Initializes contract with initial supply tokens to the creator of the contract */
192     constructor (
193         uint256 initialSupply,
194         string tokenName,
195         string tokenSymbol
196     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
197 
198     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
199     /// @param target Address to be frozen
200     /// @param freeze either to freeze it or not
201     function freezeAccount(address target, bool freeze) onlyOwner public {
202         frozenAccount[target] = freeze;
203         emit FrozenFunds(target, freeze);
204     }
205 
206     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
207     /// @param newSellPrice Price the users can sell to the contract
208     /// @param newBuyPrice Price users can buy from the contract
209     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
210         sellPrice = newSellPrice;
211         buyPrice = newBuyPrice;
212         emit Price(sellPrice,buyPrice);
213     }
214 
215     /// @notice Buy tokens from contract by sending ether
216     function buy() payable public {
217         uint amount = msg.value / buyPrice;               // calculates the amount
218         _transfer(this, msg.sender, amount);              // makes the transfers
219     }
220 
221     /// @notice Sell `amount` tokens to contract
222     /// @param amount amount of tokens to be sold
223     function sell(uint256 amount) public {
224         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
225         _transfer(msg.sender, this, amount);              // makes the transfers
226         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
227     }
228 }