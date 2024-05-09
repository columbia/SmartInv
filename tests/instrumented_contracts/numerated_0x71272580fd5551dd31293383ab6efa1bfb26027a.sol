1 pragma solidity ^0.4.10;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 pragma solidity ^0.4.18;
38 
39 contract owned {
40     address public owner;
41 
42 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 	
44     function owned() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwnership(address newOwner) onlyOwner public {
54         require(newOwner != address(0));
55 		emit OwnershipTransferred(owner, newOwner);
56 		owner = newOwner;
57     }
58 }
59 
60 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
61 
62 contract TokenERC20 {
63 	using SafeMath for uint256;
64     // Public variables of the token
65     string public name;
66     string public symbol;
67     uint8 public decimals = 3;
68     uint256 public totalSupply;
69 
70     // This creates an array with all balances
71     mapping (address => uint256) public balanceOf;
72     mapping (address => mapping (address => uint256)) public allowance;
73 
74     // This generates a public event on the blockchain that will notify clients
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     // This notifies clients about the amount burnt
78     event Burn(address indexed from, uint256 value);
79 
80     /**
81      * Constructor function
82      *
83      * Initializes contract with initial supply tokens to the creator of the contract
84      */
85     function TokenERC20(
86         uint256 initialSupply,
87         string tokenName,
88         string tokenSymbol
89     ) public {
90         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
91         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
92         name = tokenName;                                   // Set the name for display purposes
93         symbol = tokenSymbol;                               // Set the symbol for display purposes
94     }
95 
96     /**
97      * Transfer tokens
98      *
99      * Send `_value` tokens to `_to` from your account
100      *
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transfer(address _to, uint256 _value) public returns (bool);
105     
106     /**
107      * Transfer tokens from other address
108      *
109      * Send `_value` tokens to `_to` in behalf of `_from`
110      *
111      * @param _from The address of the sender
112      * @param _to The address of the recipient
113      * @param _value the amount to send
114      */
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
116     
117     /**
118      * Set allowance for other address
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      */
125     function approve(address _spender, uint256 _value) public
126         returns (bool success) {
127         allowance[msg.sender][_spender] = _value;
128         return true;
129     }
130 
131     /**
132      * Set allowance for other address and notify
133      *
134      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
135      *
136      * @param _spender The address authorized to spend
137      * @param _value the max amount they can spend
138      * @param _extraData some extra information to send to the approved contract
139      */
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
141         public
142         returns (bool success) {
143         tokenRecipient spender = tokenRecipient(_spender);
144         if (approve(_spender, _value)) {
145             spender.receiveApproval(msg.sender, _value, this, _extraData);
146             return true;
147         }
148     }
149 
150     /**
151      * Destroy tokens
152      *
153      * Remove `_value` tokens from the system irreversibly
154      *
155      * @param _value the amount of money to burn
156      */
157     function burn(uint256 _value) public returns (bool success) {
158         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
159         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
160         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
161         emit Burn(msg.sender, _value);
162 		emit Transfer(msg.sender, address(0), _value);
163         return true;
164     }
165 }
166 
167 /******************************************/
168 /*       ADVANCED TOKEN STARTS HERE       */
169 /******************************************/
170 
171 contract MyAdvancedToken is owned, TokenERC20 {
172 
173     uint256 public sellPrice = 1 finney;      // 10 ** 15
174     uint256 public buyPrice = 1 finney;       // 10 ** 15
175 
176     mapping (address => bool) public frozenAccount;
177 
178     /* This generates a public event on the blockchain that will notify clients */
179     event FrozenFunds(address target, bool frozen);
180 
181     /* Initializes contract with initial supply tokens to the creator of the contract */
182     function MyAdvancedToken(
183         uint256 initialSupply,
184         string tokenName,
185         string tokenSymbol
186     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
187 
188     /* Internal transfer, only can be called by this contract */
189     function _transferadvanced(address _from, address _to, uint _value) internal returns (bool) {
190         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
191         require (balanceOf[_from] >= _value);               // Check if the sender has enough
192         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
193         require(!frozenAccount[_from]);                     // Check if sender is frozen
194         require(!frozenAccount[_to]);                       // Check if recipient is frozen
195         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
196         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
197         emit Transfer(_from, _to, _value);
198 		return true;
199     }
200 
201 	/**
202      * Transfer tokens
203      *
204      * Send `_value` tokens to `_to` from your account
205      *
206      * @param _to The address of the recipient
207      * @param _value the amount to send
208      */
209     function transfer(address _to, uint256 _value) public returns (bool) {
210         return _transferadvanced(msg.sender, _to, _value);
211     }
212 	
213 	/**
214      * Transfer tokens from other address
215      *
216      * Send `_value` tokens to `_to` in behalf of `_from`
217      *
218      * @param _from The address of the sender
219      * @param _to The address of the recipient
220      * @param _value the amount to send
221      */
222     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
223         require(_value <= allowance[_from][msg.sender]);     // Check allowance
224         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
225         _transferadvanced(_from, _to, _value);
226         return true;
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
245 	/// @dev fallback function ***DO NOT OVERRIDE***
246     function () external payable {
247 		buy(msg.sender);
248 	}
249 	
250     /// @notice Buy tokens from contract by sending ether
251     function buy(address _buyer) payable public {
252         uint amount = msg.value / buyPrice;               // calculates the amount
253         _transferadvanced(this, _buyer, amount);              // makes the transfers
254     }
255 
256     /// @notice Sell `amount` tokens to contract
257     /// @param amount amount of tokens to be sold
258     function sell(uint256 amount) public {
259         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
260         _transferadvanced(msg.sender, this, amount);              // makes the transfers
261         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
262     }
263 }