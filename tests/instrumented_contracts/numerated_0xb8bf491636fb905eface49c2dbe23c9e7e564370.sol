1 pragma solidity 0.4.23;
2     
3 	/**
4 	 * @title SafeMath
5 	 * @dev Math operations with safety checks that throw on error
6 	 */
7 	library SafeMath {
8 	  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9 		if (a == 0) {
10 		  return 0;
11 		}
12 		uint256 c = a * b;
13 		assert(c / a == b);
14 		return c;
15 	  }
16 
17 	  function div(uint256 a, uint256 b) internal pure returns (uint256) {
18 		// assert(b > 0); // Solidity automatically throws when dividing by 0
19 		uint256 c = a / b;
20 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
21 		return c;
22 	  }
23 
24 	  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25 		assert(b <= a);
26 		return a - b;
27 	  }
28 
29 	  function add(uint256 a, uint256 b) internal pure returns (uint256) {
30 		uint256 c = a + b;
31 		assert(c >= a);
32 		return c;
33 	  }
34 	}
35 contract owned {
36     address public owner;
37 
38     function owned() public {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     function transferOwnership(address newOwner) onlyOwner public {
48         owner = newOwner;
49     }
50 }
51 
52 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
53 
54 contract TokenERC20 {
55     // Public variables of the token
56     string public name;
57     string public symbol;
58     uint8 public decimals = 18;
59     // 18 decimals is the strongly suggested default, avoid changing it
60     uint256 public totalSupply;
61 	using SafeMath for uint256;
62 	
63     // This creates an array with all balances
64     mapping (address => uint256) public balanceOf;
65     mapping (address => mapping (address => uint256)) public allowance;
66 
67     // This generates a public event on the blockchain that will notify clients
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     // This notifies clients about the amount burnt
71     event Burn(address indexed from, uint256 value);
72 
73     /**
74      * Constrctor function
75      *
76      * Initializes contract with initial supply tokens to the creator of the contract
77      */
78     function TokenERC20(
79         uint256 initialSupply,
80         string tokenName,
81         string tokenSymbol
82     ) public {
83         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
84         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
85         name = tokenName;                                   // Set the name for display purposes
86         symbol = tokenSymbol;                               // Set the symbol for display purposes
87     }
88 
89     /**
90      * Internal transfer, only can be called by this contract
91      */
92     function _transfer(address _from, address _to, uint _value) internal {
93         // Prevent transfer to 0x0 address. Use burn() instead
94         require(_to != 0x0);
95         // Check if the sender has enough
96         require(balanceOf[_from] >= _value);
97         // Check for overflows
98         require(balanceOf[_to].add(_value) > balanceOf[_to]);
99         // Save this for an assertion in the future
100         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
101         // Subtract from the sender
102         balanceOf[_from] = balanceOf[_from].sub(_value);
103         // Add the same to the recipient
104         balanceOf[_to] = balanceOf[_to].add(_value);
105         Transfer(_from, _to, _value);
106         // Asserts are used to use static analysis to find bugs in your code. They should never fail
107         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
108     }
109 
110     /**
111      * Transfer tokens
112      *
113      * Send `_value` tokens to `_to` from your account
114      *
115      * @param _to The address of the recipient
116      * @param _value the amount to send
117      */
118     function transfer(address _to, uint256 _value) public {
119         _transfer(msg.sender, _to, _value);
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
132         require(_value <= allowance[_from][msg.sender]);     // Check allowance
133         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
134         _transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139      * Set allowance for other address
140      *
141      * Allows `_spender` to spend no more than `_value` tokens in your behalf
142      *
143      * @param _spender The address authorized to spend
144      * @param _value the max amount they can spend
145      */
146     function approve(address _spender, uint256 _value) public
147         returns (bool success) {
148         allowance[msg.sender][_spender] = _value;
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address and notify
154      *
155      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      * @param _extraData some extra information to send to the approved contract
160      */
161     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
162         public
163         returns (bool success) {
164         tokenRecipient spender = tokenRecipient(_spender);
165         if (approve(_spender, _value)) {
166             spender.receiveApproval(msg.sender, _value, this, _extraData);
167             return true;
168         }
169     }
170 
171     /**
172      * Destroy tokens
173      *
174      * Remove `_value` tokens from the system irreversibly
175      *
176      * @param _value the amount of money to burn
177      */
178     function burn(uint256 _value) public returns (bool success) {
179         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
180         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
181         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
182         Burn(msg.sender, _value);
183         return true;
184     }
185 
186     /**
187      * Destroy tokens from other account
188      *
189      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
190      *
191      * @param _from the address of the sender
192      * @param _value the amount of money to burn
193      */
194     function burnFrom(address _from, uint256 _value) public returns (bool success) {
195         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
196         require(_value <= allowance[_from][msg.sender]);    // Check allowance
197         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
198         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
199         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
200         Burn(_from, _value);
201         return true;
202     }
203 }
204 
205 /******************************************/
206 /*       ADVANCED TOKEN STARTS HERE       */
207 /******************************************/
208 
209 contract CRYPTOBITECOIN is owned, TokenERC20 {
210 
211     uint256 public sellPrice;
212     uint256 public buyPrice;
213 	using SafeMath for uint256;
214 
215     mapping (address => bool) public frozenAccount;
216 
217     /* This generates a public event on the blockchain that will notify clients */
218     event FrozenFunds(address target, bool frozen);
219 
220     /* Initializes contract with initial supply tokens to the creator of the contract */
221     function CRYPTOBITECOIN(
222         uint256 initialSupply,
223         string tokenName,
224         string tokenSymbol
225     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
226 
227     /* Internal transfer, only can be called by this contract */
228     function _transfer(address _from, address _to, uint _value) internal {
229         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
230         require (balanceOf[_from] >= _value);               // Check if the sender has enough
231         require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
232         require(!frozenAccount[_from]);                     // Check if sender is frozen
233         require(!frozenAccount[_to]);                       // Check if recipient is frozen
234         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
235         balanceOf[_to] = balanceOf[_from].add(_value);                           // Add the same to the recipient
236         Transfer(_from, _to, _value);
237     }
238 
239     /// @notice Create `mintedAmount` tokens and send it to `target`
240     /// @param target Address to receive the tokens
241     /// @param mintedAmount the amount of tokens it will receive
242     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
243         balanceOf[target] = balanceOf[target].add(mintedAmount);
244         totalSupply = totalSupply.add(mintedAmount);
245         Transfer(0, this, mintedAmount);
246         Transfer(this, target, mintedAmount);
247     }
248 
249     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
250     /// @param target Address to be frozen
251     /// @param freeze either to freeze it or not
252     function freezeAccount(address target, bool freeze) onlyOwner public {
253         frozenAccount[target] = freeze;
254         FrozenFunds(target, freeze);
255     }
256 
257     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
258     /// @param newSellPrice Price the users can sell to the contract
259     /// @param newBuyPrice Price users can buy from the contract
260     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
261         sellPrice = newSellPrice;
262         buyPrice = newBuyPrice;
263     }
264 
265     /// @notice Buy tokens from contract by sending ether
266     function buy() payable public {
267         uint amount = msg.value.div(buyPrice);               // calculates the amount
268         _transfer(this, msg.sender, amount);              // makes the transfers
269     }
270 
271     /// @notice Sell `amount` tokens to contract
272     /// @param amount amount of tokens to be sold
273     function sell(uint256 amount) public {
274         require(this.balance >= amount.mul(sellPrice));      // checks if the contract has enough ether to buy
275         _transfer(msg.sender, this, amount);              // makes the transfers
276         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
277     }
278 }