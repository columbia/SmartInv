1 pragma solidity 0.4.24;
2 // ----------------------------------------------------------------------------
3 // 'Gamma Token' token contract
4 //
5 // Deployed to : 0x1275Cf2D18dC290aF80EeD32ba1110f1b0d2b2BB
6 // Symbol      : GAMA
7 // Name        : Gamma Token
8 // Total supply: 750,000,000
9 // Decimals    : 18
10 //
11 // Copyright(c) 2018 onwards VFTech, Inc. Australia (www.ExToke.com) 
12 // Contract Designed with care by GDO Infotech Pvt Ltd, India (www.GDO.co.in)
13 // ----------------------------------------------------------------------------
14     /**
15      * @title SafeMath
16      * @dev Math operations with safety checks that throw on error
17      */
18     library SafeMath {
19       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21           return 0;
22         }
23         uint256 c = a * b;
24         assert(c / a == b);
25         return c;
26       }
27     
28       function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33       }
34     
35       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38       }
39     
40       function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44       }
45     }
46     
47     contract owned {
48         address public owner;
49     	using SafeMath for uint256;
50     	
51          function Constrctor() public {
52             owner = msg.sender;
53         }
54     
55         modifier onlyOwner {
56             require(msg.sender == owner);
57             _;
58         }
59     
60         function transferOwnership(address newOwner) onlyOwner public {
61             owner = newOwner;
62         }
63     }
64     
65     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
66     
67     contract TokenERC20 {
68         // Public variables of the token
69         using SafeMath for uint256;
70     	string public name;
71         string public symbol;
72         uint8 public decimals = 18;
73         // 18 decimals is the strongly suggested default, avoid changing it
74         uint256 public totalSupply;
75     
76         // This creates an array with all balances
77         mapping (address => uint256) public balanceOf;
78         mapping (address => mapping (address => uint256)) public allowance;
79     
80         // This generates a public event on the blockchain that will notify clients
81         event Transfer(address indexed from, address indexed to, uint256 value);
82     
83         // This notifies clients about the amount burnt
84         event Burn(address indexed from, uint256 value);
85     
86         /**
87          * Constrctor function
88          *
89          * Initializes contract with initial supply tokens to the creator of the contract
90          */
91         constructor (
92             uint256 initialSupply,
93             string tokenName,
94             string tokenSymbol
95         ) public {
96             totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
97             balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
98             name = tokenName;                                   // Set the name for display purposes
99             symbol = tokenSymbol;                               // Set the symbol for display purposes
100         }
101     
102         /**
103          * Internal transfer, only can be called by this contract
104          */
105         function _transfer(address _from, address _to, uint _value) internal {
106             // Prevent transfer to 0x0 address. Use burn() instead
107             require(_to != 0x0);
108             // Check if the sender has enough
109             require(balanceOf[_from] >= _value);
110             // Check for overflows
111             require(balanceOf[_to].add(_value) > balanceOf[_to]);
112             // Save this for an assertion in the future
113             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
114             // Subtract from the sender
115             balanceOf[_from] = balanceOf[_from].sub(_value);
116             // Add the same to the recipient
117             balanceOf[_to] = balanceOf[_to].add(_value);
118             emit Transfer(_from, _to, _value);
119             // Asserts are used to use static analysis to find bugs in your code. They should never fail
120             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
121         }
122     
123         /**
124          * Transfer tokens
125          *
126          * Send `_value` tokens to `_to` from your account
127          *
128          * @param _to The address of the recipient
129          * @param _value the amount to send
130          */
131         function transfer(address _to, uint256 _value) public {
132             _transfer(msg.sender, _to, _value);
133         }
134     
135         /**
136          * Transfer tokens from other address
137          *
138          * Send `_value` tokens to `_to` in behalf of `_from`
139          *
140          * @param _from The address of the sender
141          * @param _to The address of the recipient
142          * @param _value the amount to send
143          */
144         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
145             require(_value <= allowance[_from][msg.sender]);     // Check allowance
146             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
147             _transfer(_from, _to, _value);
148             return true;
149         }
150     
151         /**
152          * Set allowance for other address
153          *
154          * Allows `_spender` to spend no more than `_value` tokens in your behalf
155          *
156          * @param _spender The address authorized to spend
157          * @param _value the max amount they can spend
158          */
159         function approve(address _spender, uint256 _value) public
160             returns (bool success) {
161             allowance[msg.sender][_spender] = _value;
162             return true;
163         }
164     
165         /**
166          * Set allowance for other address and notify
167          *
168          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
169          *
170          * @param _spender The address authorized to spend
171          * @param _value the max amount they can spend
172          * @param _extraData some extra information to send to the approved contract
173          */
174         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
175             public
176             returns (bool success) {
177             tokenRecipient spender = tokenRecipient(_spender);
178             if (approve(_spender, _value)) {
179                 spender.receiveApproval(msg.sender, _value, this, _extraData);
180                 return true;
181             }
182         }
183     
184         /**
185          * Destroy tokens
186          *
187          * Remove `_value` tokens from the system irreversibly
188          *
189          * @param _value the amount of money to burn
190          */
191         function burn(uint256 _value) public returns (bool success) {
192             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
193             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
194             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
195            emit Burn(msg.sender, _value);
196             return true;
197         }
198     
199         /**
200          * Destroy tokens from other account
201          *
202          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
203          *
204          * @param _from the address of the sender
205          * @param _value the amount of money to burn
206          */
207         function burnFrom(address _from, uint256 _value) public returns (bool success) {
208             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
209             require(_value <= allowance[_from][msg.sender]);    // Check allowance
210             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
211             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
212             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
213           emit  Burn(_from, _value);
214             return true;
215         }
216     }
217     
218     /******************************************/
219     /*       ADVANCED TOKEN STARTS HERE       */
220     /******************************************/
221     
222     contract GammaToken is owned, TokenERC20 {
223     
224         uint256 public sellPrice;
225         uint256 public buyPrice;
226     	using SafeMath for uint256;
227     	
228         mapping (address => bool) public frozenAccount;
229     
230         /* This generates a public event on the blockchain that will notify clients */
231         event FrozenFunds(address target, bool frozen);
232     
233         /* Initializes contract with initial supply tokens to the creator of the contract */
234          constructor (
235             uint256 initialSupply,
236             string tokenName,
237             string tokenSymbol
238         ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
239     
240         /* Internal transfer, only can be called by this contract */
241         function _transfer(address _from, address _to, uint _value) internal {
242             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
243             require (balanceOf[_from] >= _value);               // Check if the sender has enough
244             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
245             require(!frozenAccount[_from]);                     // Check if sender is frozen
246             require(!frozenAccount[_to]);                       // Check if recipient is frozen
247             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
248             balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
249            emit Transfer(_from, _to, _value);
250         }
251 		     	
252     	
253         /// @notice Create `mintedAmount` tokens and send it to `target`
254         /// @param target Address to receive the tokens
255         /// @param mintedAmount the amount of tokens it will receive
256         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
257             balanceOf[target] = balanceOf[target].add(mintedAmount);
258             totalSupply = totalSupply.add(mintedAmount);
259            emit Transfer(0, this, mintedAmount);
260            emit Transfer(this, target, mintedAmount);
261         }
262     
263         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
264         /// @param target Address to be frozen
265         /// @param freeze either to freeze it or not
266         function freezeAccount(address target, bool freeze) onlyOwner public {
267             frozenAccount[target] = freeze;
268           emit  FrozenFunds(target, freeze);
269         }
270     
271         /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
272         /// @param newSellPrice Price the users can sell to the contract
273         /// @param newBuyPrice Price users can buy from the contract
274         function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
275             sellPrice = newSellPrice;
276             buyPrice = newBuyPrice;
277         }
278     
279         /// @notice Buy tokens from contract by sending ether
280         function buy() payable public {
281             uint amount = msg.value.div(buyPrice);               // calculates the amount
282             _transfer(this, msg.sender, amount);              // makes the transfers
283         }
284     
285         /// @notice Sell `amount` tokens to contract
286         /// @param amount amount of tokens to be sold
287         function sell(uint256 amount) public {
288             require(address(this).balance >= amount.mul(sellPrice));      // checks if the contract has enough ether to buy
289             _transfer(msg.sender, this, amount);              // makes the transfers
290             msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
291         }
292     }