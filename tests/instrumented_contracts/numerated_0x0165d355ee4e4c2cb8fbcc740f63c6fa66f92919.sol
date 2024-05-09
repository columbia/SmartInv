1 pragma solidity ^0.4.16;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 contract owned {
35     address public owner;
36 
37     function owned() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address newOwner) onlyOwner public {
47         owner = newOwner;
48     }
49 }
50 
51 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
52 
53 contract TokenERC20 {
54     using SafeMath for uint256;
55     // Public variables of the token
56     string public name;
57     string public symbol;
58     uint8 public decimals = 18;
59     // 18 decimals is the strongly suggested default, avoid changing it
60     uint256 public totalSupply;
61 
62     // This creates an array with all balances
63     mapping (address => uint256) public balanceOf;
64     mapping (address => mapping (address => uint256)) public allowance;
65 
66     // This generates a public event on the blockchain that will notify clients
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     // This notifies clients about the amount burnt
70     event Burn(address indexed from, uint256 value);
71     // address crowdsale
72     address addressCrowdSale = 0xc699d90671Cb8373F21060592D41A7c92280adc4;
73     /**
74      * Constructor function
75      *
76      * Initializes contract with initial supply tokens to the creator of the contract
77      */
78     function TokenERC20(
79         uint256 initialSupply,
80         string tokenName,
81         string tokenSymbol
82         
83     ) public {
84         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
85         balanceOf[msg.sender] = totalSupply.mul(11).div(18);                // Give the creator all initial tokens
86         balanceOf[addressCrowdSale] = totalSupply.sub(balanceOf[msg.sender]);  
87         name = tokenName;                                   // Set the name for display purposes
88         symbol = tokenSymbol;                               // Set the symbol for display purposes
89     }
90 
91     /**
92      * Internal transfer, only can be called by this contract
93      */
94     function _transfer(address _from, address _to, uint _value) internal {
95         // Prevent transfer to 0x0 address. Use burn() instead
96         require(_to != 0x0);
97         // Check if the sender has enough
98         require(balanceOf[_from] >= _value);
99         // Check for overflows
100         require(balanceOf[_to].add(_value) > balanceOf[_to]);
101         // Save this for an assertion in the future
102         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
103         // Subtract from the sender
104         balanceOf[_from] = balanceOf[_from].sub(_value);
105         // Add the same to the recipient
106         balanceOf[_to] = balanceOf[_to].add(_value);
107         emit Transfer(_from, _to, _value);
108         // Asserts are used to use static analysis to find bugs in your code. They should never fail
109         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
110     }
111 
112     /**
113      * Transfer tokens
114      *
115      * Send `_value` tokens to `_to` from your account
116      *
117      * @param _to The address of the recipient
118      * @param _value the amount to send
119      */
120     function transfer(address _to, uint256 _value) public {
121         _transfer(msg.sender, _to, _value);
122     }
123 
124     /**
125      * Transfer tokens from other address
126      *
127      * Send `_value` tokens to `_to` in behalf of `_from`
128      *
129      * @param _from The address of the sender
130      * @param _to The address of the recipient
131      * @param _value the amount to send
132      */
133     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
134         require(_value <= allowance[_from][msg.sender]);     // Check allowance
135         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
136         _transfer(_from, _to, _value);
137         return true;
138     }
139 
140     /**
141      * Set allowance for other address
142      *
143      * Allows `_spender` to spend no more than `_value` tokens in your behalf
144      *
145      * @param _spender The address authorized to spend
146      * @param _value the max amount they can spend
147      */
148     function approve(address _spender, uint256 _value) public
149         returns (bool success) {
150         allowance[msg.sender][_spender] = _value;
151         return true;
152     }
153 
154     /**
155      * Set allowance for other address and notify
156      *
157      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
158      *
159      * @param _spender The address authorized to spend
160      * @param _value the max amount they can spend
161      * @param _extraData some extra information to send to the approved contract
162      */
163     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
164         public
165         returns (bool success) {
166         tokenRecipient spender = tokenRecipient(_spender);
167         if (approve(_spender, _value)) {
168             spender.receiveApproval(msg.sender, _value, this, _extraData);
169             return true;
170         }
171     }
172 
173     /**
174      * Destroy tokens
175      *
176      * Remove `_value` tokens from the system irreversibly
177      *
178      * @param _value the amount of money to burn
179      */
180     function burn(uint256 _value) public returns (bool success) {
181         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
182         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
183         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
184         emit Burn(msg.sender, _value);
185         return true;
186     }
187 
188     /**
189      * Destroy tokens from other account
190      *
191      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
192      *
193      * @param _from the address of the sender
194      * @param _value the amount of money to burn
195      */
196     function burnFrom(address _from, uint256 _value) public returns (bool success) {
197         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
198         require(_value <= allowance[_from][msg.sender]);    // Check allowance
199         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
200         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
201         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
202         emit Burn(_from, _value);
203         return true;
204     }
205 }
206 
207 /******************************************/
208 /*       ADVANCED TOKEN STARTS HERE       */
209 /******************************************/
210 
211 contract MahalaToken is owned, TokenERC20 {
212     using SafeMath for uint256;  
213     uint256 public sellPrice;
214     uint256 public buyPrice;
215 
216     mapping (address => bool) public frozenAccount;
217 
218     /* This generates a public event on the blockchain that will notify clients */
219     event FrozenFunds(address target, bool frozen);
220 
221     /* Initializes contract with initial supply tokens to the creator of the contract */
222     function MahalaToken() TokenERC20(180000000, "Mahala Coin", "MHC") public {}
223 
224     /* Internal transfer, only can be called by this contract */
225     function _transfer(address _from, address _to, uint _value) internal {
226         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
227         require (balanceOf[_from] >= _value);               // Check if the sender has enough
228         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
229         require(!frozenAccount[_from]);                     // Check if sender is frozen
230         require(!frozenAccount[_to]);                       // Check if recipient is frozen
231         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
232         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
233         emit Transfer(_from, _to, _value);
234     }
235 
236     /// @notice Create `mintedAmount` tokens and send it to `target`
237     /// @param target Address to receive the tokens
238     /// @param mintedAmount the amount of tokens it will receive
239     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
240         balanceOf[target] = balanceOf[target].add(mintedAmount);
241         totalSupply = totalSupply.add(mintedAmount);
242         emit Transfer(0, this, mintedAmount);
243         emit Transfer(this, target, mintedAmount);
244     }
245 
246     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
247     /// @param target Address to be frozen
248     /// @param freeze either to freeze it or not
249     function freezeAccount(address target, bool freeze) onlyOwner public {
250         frozenAccount[target] = freeze;
251         emit FrozenFunds(target, freeze);
252     }
253 
254     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
255     /// @param newSellPrice Price the users can sell to the contract
256     /// @param newBuyPrice Price users can buy from the contract
257     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
258         sellPrice = newSellPrice;
259         buyPrice = newBuyPrice;
260     }
261 
262     /// @notice Buy tokens from contract by sending ether
263     function buy() payable public {
264         uint amount = msg.value.mul(buyPrice).div(10 ** uint256(decimals));               // calculates the amount
265         _transfer(this, msg.sender, amount);              // makes the transfers
266     }
267 
268     /// @notice Sell `amount` tokens to contract
269     /// @param amount amount of tokens to be sold
270     function sell(uint256 amount) public {
271         address _this = this;
272         require(_this.balance >= amount.div(sellPrice).mul(10 ** uint256(decimals)));      // checks if the contract has enough ether to buy
273         _transfer(msg.sender, this, amount);              // makes the transfers
274         msg.sender.transfer(amount.div(sellPrice).mul(10 ** uint256(decimals)));          // sends ether to the seller. It's important to do this last to avoid recursion attacks
275     }
276 }