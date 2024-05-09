1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-08
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 
8 library SafeMathUint256 {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a);
30         return c;
31     }
32 }
33 
34 contract owned {
35     address public owner;
36 
37     constructor () public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address newOwner) onlyOwner public {
47         require(newOwner != address(0));
48         owner = newOwner;
49     }
50 }
51 
52 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)  external; }
53 
54 contract TokenERC20 {
55     
56      mapping (address => bool) public frozenAccount;
57     // Public variables of the token
58     using SafeMathUint256 for uint256;
59     string public name;
60     string public symbol;
61     uint8 public decimals = 18;
62     // 18 decimals is the strongly suggested default, avoid changing it
63     uint256 public totalSupply;
64 
65     // This creates an array with all balances
66     mapping (address => uint256) public balanceOf;
67     mapping (address => mapping (address => uint256)) public allowance;
68 
69     // This generates a public event on the blockchain that will notify clients
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72 
73     /**
74      * Constrctor function
75      *
76      * Initializes contract with initial supply tokens to the creator of the contract
77      */
78      
79     constructor (
80         uint256 initialSupply,
81         string tokenName,
82         string tokenSymbol
83     ) public {
84         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
85         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
86         name = tokenName;                                   // Set the name for display purposes
87         symbol = tokenSymbol;                               // Set the symbol for display purposes
88     }
89 
90     /**
91      * Internal transfer, only can be called by this contract
92      */
93     function _transfer(address _from, address _to, uint _value) internal {
94         // Prevent transfer to 0x0 address. Use burn() instead
95         require(_to != 0x0);
96         // Check if the sender has enough
97         require(balanceOf[_from] >= _value);
98         // Check for overflows
99         require(balanceOf[_to] + _value > balanceOf[_to]);
100         // Save this for an assertion in the future
101         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
102         // Subtract from the sender
103         balanceOf[_from] = balanceOf[_from].sub(_value);
104         // Add the same to the recipient
105         balanceOf[_to] = balanceOf[_to].add(_value);
106         emit Transfer(_from, _to, _value);
107         // Asserts are used to use static analysis to find bugs in your code. They should never fail
108         require((balanceOf[_from] + balanceOf[_to]) == previousBalances);
109     }
110 
111     /**
112      * Transfer tokens
113      *
114      * Send `_value` tokens to `_to` from your account
115      *
116      * @param _to The address of the recipient
117      * @param _value the amount to send
118      */
119     function transfer(address _to, uint256 _value) public returns (bool success) {
120         require(!frozenAccount[msg.sender]);   
121         require(!frozenAccount[_to]);   
122         _transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     /**
127      * Transfer tokens from other address
128      *
129      * Send `_value` tokens to `_to` in behalf of `_from`
130      *
131      * @param _from The address of the sender
132      * @param _to The address of the recipient
133      * @param _value the amount to send
134      */
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
136         require(!frozenAccount[_from]);
137         require(!frozenAccount[msg.sender]);   
138         require(!frozenAccount[_to]);   
139         require(_value <= allowance[_from][msg.sender]);     // Check allowance
140         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
141         _transfer(_from, _to, _value);
142         return true;
143     }
144 
145     /**
146      * Set allowance for other address
147      *
148      * Allows `_spender` to spend no more than `_value` tokens in your behalf
149      *
150      * @param _spender The address authorized to spend
151      * @param _value the max amount they can spend
152      */
153     function approve(address _spender, uint256 _value) public
154         returns (bool success) {
155         allowance[msg.sender][_spender] = _value;
156         return true;
157     }
158 
159     /**
160      * Set allowance for other address and notify
161      *
162      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
163      *
164      * @param _spender The address authorized to spend
165      * @param _value the max amount they can spend
166      * @param _extraData some extra information to send to the approved contract
167      */
168     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
169         public
170         returns (bool success) {
171         tokenRecipient spender = tokenRecipient(_spender);
172         require(approve(_spender, _value));
173         spender.receiveApproval(msg.sender, _value, this, _extraData);
174         return true;
175         
176     }
177 }
178 
179 /******************************************/
180 /*       ADVANCED TOKEN STARTS HERE       */
181 /******************************************/
182 
183 contract MyAdvancedToken is owned, TokenERC20 {
184 
185     uint256 public sellPrice;
186     uint256 public buyPrice;
187 
188    
189 
190     /* This generates a public event on the blockchain that will notify clients */
191     event FrozenFunds(address target, bool frozen);
192     
193     event Price(uint256 newSellPrice, uint256 newBuyPrice);
194 
195     /* Initializes contract with initial supply tokens to the creator of the contract */
196     constructor (
197         uint256 initialSupply,
198         string tokenName,
199         string tokenSymbol
200     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
201 
202     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
203     /// @param target Address to be frozen
204     /// @param freeze either to freeze it or not
205     function freezeAccount(address target, bool freeze) onlyOwner public {
206         frozenAccount[target] = freeze;
207         emit FrozenFunds(target, freeze);
208     }
209 
210     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
211     /// @param newSellPrice Price the users can sell to the contract
212     /// @param newBuyPrice Price users can buy from the contract
213     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
214         sellPrice = newSellPrice;
215         buyPrice = newBuyPrice;
216         emit Price(sellPrice,buyPrice);
217     }
218 
219     /// @notice Buy tokens from contract by sending ether
220     function buy() payable public {
221         uint amount = msg.value / buyPrice;               // calculates the amount
222         _transfer(this, msg.sender, amount);              // makes the transfers
223     }
224 
225     /// @notice Sell `amount` tokens to contract
226     /// @param amount amount of tokens to be sold
227     function sell(uint256 amount) public {
228         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
229         _transfer(msg.sender, this, amount);              // makes the transfers
230         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
231     }
232 }