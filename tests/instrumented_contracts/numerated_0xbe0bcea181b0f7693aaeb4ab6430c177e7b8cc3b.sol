1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'WRC'  token contract
5 //
6 // Owner Address : 0xB95E9dd364B904Ea03b1995B52d76922A7dc6a5e
7 // Symbol        : WRC
8 // Name          : WorkCoin Token
9 // Total supply  : 2000000000
10 // Decimals      : 18
11 // POWERED BY WorkCoin.
12 
13 // (c) by Team @ WorkCoin 2019.
14 // ----------------------------------------------------------------------------
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19 */
20 
21 library SafeMath {
22     
23     /**
24     * @dev Multiplies two numbers, throws on overflow.
25     */
26     
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31     }
32     
33     /**
34     * @dev Integer division of two numbers, truncating the quotient.
35     */
36     
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42     }
43     
44      /**
45     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46     */
47     
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51     }
52     
53     /**
54     * @dev Adds two numbers, throws on overflow.
55     */
56     
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 }
63 
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 
71 contract owned {
72     address public owner;
73 
74     constructor () public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address newOwner) onlyOwner public {
84         owner = newOwner;
85     }
86 }
87 
88 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
89 
90 contract ERC20 is owned {
91     // Public variables of the token
92     string public name = "WorkCoin Token";
93     string public symbol = "WRC";
94     uint8 public decimals = 18;
95     uint256 public totalSupply = 2000000000 * 10 ** uint256(decimals);
96 
97     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
98     address public ICO_Contract;
99 
100     // This creates an array with all balances
101     mapping (address => uint256) public balanceOf;
102     mapping (address => mapping (address => uint256)) public allowance;
103     mapping (address => bool) public frozenAccount;
104    
105     // This generates a public event on the blockchain that will notify clients
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /* This generates a public event on the blockchain that will notify clients */
109     event FrozenFunds(address target, bool frozen);
110     
111      // This notifies clients about the amount burnt
112        event Burn(address indexed from, uint256 value);
113 
114     /**
115      * Constrctor function
116      *
117      * Initializes contract with initial supply tokens to the creator of the contract
118      */
119     constructor () public {
120         balanceOf[owner] = totalSupply;
121     }
122     
123     /**
124      * Internal transfer, only can be called by this contract
125      */
126     function _transfer(address _from, address _to, uint256 _value)  internal {
127         // Prevent transfer to 0x0 address. Use burn() instead
128         require(_to != 0x0);
129         // Check if the sender has enough
130         require(balanceOf[_from] >= _value);
131         // Check for overflows
132         require(balanceOf[_to] + _value > balanceOf[_to]);
133         // Check if sender is frozen
134         require(!frozenAccount[_from]);
135         // Check if recipient is frozen
136         require(!frozenAccount[_to]);
137         // Save this for an assertion in the future
138         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
139         // Subtract from the sender
140         balanceOf[_from] -= _value;
141         // Add the same to the recipient
142         balanceOf[_to] += _value;
143         emit Transfer(_from, _to, _value);
144         // Asserts are used to use static analysis to find bugs in your code. They should never fail
145         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
146     }
147 
148     /**
149      * Transfer tokens
150      *
151      * Send `_value` tokens to `_to` from your account
152      *
153      * @param _to The address of the recipient
154      * @param _value the amount to send
155      */
156     function transfer(address _to, uint256 _value) public {
157         _transfer(msg.sender, _to, _value);
158     }
159 
160     /**
161      * Transfer tokens from other address
162      *
163      * Send `_value` tokens to `_to` in behalf of `_from`
164      *
165      * @param _from The address of the sender
166      * @param _to The address of the recipient
167      * @param _value the amount to send
168      */
169     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
170         require(_value <= allowance[_from][msg.sender]);     // Check allowance
171         allowance[_from][msg.sender] -= _value;
172         _transfer(_from, _to, _value);
173         return true;
174     }
175 
176     /**
177      * Set allowance for other address
178      *
179      * Allows `_spender` to spend no more than `_value` tokens in your behalf
180      *
181      * @param _spender The address authorized to spend
182      * @param _value the max amount they can spend
183      */
184     function approve(address _spender, uint256 _value) public
185         returns (bool success) {
186         allowance[msg.sender][_spender] = _value;
187         return true;
188     }
189 
190     /**
191      * Set allowance for other address and notify
192      *
193      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
194      *
195      * @param _spender The address authorized to spend
196      * @param _value the max amount they can spend
197      * @param _extraData some extra information to send to the approved contract
198      */
199     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
200         public
201         returns (bool success) {
202         tokenRecipient spender = tokenRecipient(_spender);
203         if (approve(_spender, _value)) {
204             spender.receiveApproval(msg.sender, _value, this, _extraData);
205             return true;
206         }
207     }
208 
209     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
210     /// @param target Address to be frozen
211     /// @param freeze either to freeze it or not
212     function freezeAccount(address target, bool freeze) onlyOwner public {
213         frozenAccount[target] = freeze;
214         emit FrozenFunds(target, freeze);
215     }
216     
217     /// @notice Create `mintedAmount` tokens and send it to `target`
218     /// @param target Address to receive the tokens
219     /// @param mintedAmount the amount of tokens it will receive
220     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
221         balanceOf[target] += mintedAmount;
222         totalSupply += mintedAmount;
223         emit Transfer(this, target, mintedAmount);
224     }
225      /**
226      * Destroy tokens
227      *
228      * Remove `_value` tokens from the system irreversibly
229      *
230      * @param _value the amount of money to burn
231      */
232     function burn(uint256 _value) public returns (bool success) {
233         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
234         balanceOf[msg.sender] -= _value;            // Subtract from the sender
235         totalSupply -= _value;                      // Updates totalSupply
236         emit Burn(msg.sender, _value);
237         return true;
238     }
239 
240     /**
241      * Destroy tokens from other account
242      *
243      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
244      *
245      * @param _from the address of the sender
246      * @param _value the amount of money to burn
247      */
248     function burnFrom(address _from, uint256 _value) public returns (bool success) {
249         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
250         require(_value <= allowance[_from][msg.sender]);    // Check allowance
251         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
252         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
253         totalSupply -= _value;                              // Update totalSupply
254         emit Burn(_from, _value);
255         return true;
256     }
257     
258     /// @dev Set the ICO_Contract.
259     /// @param _ICO_Contract crowdsale contract address
260     function setICO_Contract(address _ICO_Contract) onlyOwner public {
261         ICO_Contract = _ICO_Contract;
262     }
263 }