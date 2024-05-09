1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'XGGM'  token contract
5 //
6 // Symbol        : XGGM
7 // Name          : XGGM Token
8 // Total supply  : 1000000000
9 // Decimals      : 18
10 // POWERED BY GATEWAY GOLD & MINERALS, INC.
11 
12 // (c) by Team @ GATEWAY GOLD & MINERALS, INC 2019.
13 // ----------------------------------------------------------------------------
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18 */
19 
20 library SafeMath {
21     
22     /**
23     * @dev Multiplies two numbers, throws on overflow.
24     */
25     
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30     }
31     
32     /**
33     * @dev Integer division of two numbers, truncating the quotient.
34     */
35     
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41     }
42     
43      /**
44     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50     }
51     
52     /**
53     * @dev Adds two numbers, throws on overflow.
54     */
55     
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         assert(c >= a);
59         return c;
60     }
61 }
62 
63 
64 /**
65  * @title Ownable
66  * @dev The Ownable contract has an owner address, and provides basic authorization control
67  * functions, this simplifies the implementation of "user permissions".
68  */
69 
70 contract owned {
71     address public owner;
72 
73     constructor () public {
74         owner = msg.sender;
75     }
76 
77     modifier onlyOwner {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     function transferOwnership(address newOwner) onlyOwner public {
83         owner = newOwner;
84     }
85 }
86 
87 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
88 
89 contract ERC20 is owned {
90     // Public variables of the token
91     string public name = "XGGM Token";
92     string public symbol = "XGGM";
93     uint8 public decimals = 18;
94     uint256 public totalSupply = 1000000000 * 10 ** uint256(decimals);
95 
96     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
97     address public ICO_Contract;
98 
99     // This creates an array with all balances
100     mapping (address => uint256) public balanceOf;
101     mapping (address => mapping (address => uint256)) public allowance;
102     mapping (address => bool) public frozenAccount;
103    
104     // This generates a public event on the blockchain that will notify clients
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /* This generates a public event on the blockchain that will notify clients */
108     event FrozenFunds(address target, bool frozen);
109     
110      // This notifies clients about the amount burnt
111        event Burn(address indexed from, uint256 value);
112 
113     /**
114      * Constrctor function
115      *
116      * Initializes contract with initial supply tokens to the creator of the contract
117      */
118     constructor () public {
119         balanceOf[owner] = totalSupply;
120     }
121     
122     /**
123      * Internal transfer, only can be called by this contract
124      */
125     function _transfer(address _from, address _to, uint256 _value)  internal {
126         // Prevent transfer to 0x0 address. Use burn() instead
127         require(_to != 0x0);
128         // Check if the sender has enough
129         require(balanceOf[_from] >= _value);
130         // Check for overflows
131         require(balanceOf[_to] + _value > balanceOf[_to]);
132         // Check if sender is frozen
133         require(!frozenAccount[_from]);
134         // Check if recipient is frozen
135         require(!frozenAccount[_to]);
136         // Save this for an assertion in the future
137         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
138         // Subtract from the sender
139         balanceOf[_from] -= _value;
140         // Add the same to the recipient
141         balanceOf[_to] += _value;
142         emit Transfer(_from, _to, _value);
143         // Asserts are used to use static analysis to find bugs in your code. They should never fail
144         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
145     }
146 
147     /**
148      * Transfer tokens
149      *
150      * Send `_value` tokens to `_to` from your account
151      *
152      * @param _to The address of the recipient
153      * @param _value the amount to send
154      */
155     function transfer(address _to, uint256 _value) public {
156         _transfer(msg.sender, _to, _value);
157     }
158 
159     /**
160      * Transfer tokens from other address
161      *
162      * Send `_value` tokens to `_to` in behalf of `_from`
163      *
164      * @param _from The address of the sender
165      * @param _to The address of the recipient
166      * @param _value the amount to send
167      */
168     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
169         require(_value <= allowance[_from][msg.sender]);     // Check allowance
170         allowance[_from][msg.sender] -= _value;
171         _transfer(_from, _to, _value);
172         return true;
173     }
174 
175     /**
176      * Set allowance for other address
177      *
178      * Allows `_spender` to spend no more than `_value` tokens in your behalf
179      *
180      * @param _spender The address authorized to spend
181      * @param _value the max amount they can spend
182      */
183     function approve(address _spender, uint256 _value) public
184         returns (bool success) {
185         allowance[msg.sender][_spender] = _value;
186         return true;
187     }
188 
189     /**
190      * Set allowance for other address and notify
191      *
192      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
193      *
194      * @param _spender The address authorized to spend
195      * @param _value the max amount they can spend
196      * @param _extraData some extra information to send to the approved contract
197      */
198     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
199         public
200         returns (bool success) {
201         tokenRecipient spender = tokenRecipient(_spender);
202         if (approve(_spender, _value)) {
203             spender.receiveApproval(msg.sender, _value, this, _extraData);
204             return true;
205         }
206     }
207 
208     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
209     /// @param target Address to be frozen
210     /// @param freeze either to freeze it or not
211     function freezeAccount(address target, bool freeze) onlyOwner public {
212         frozenAccount[target] = freeze;
213         emit FrozenFunds(target, freeze);
214     }
215     
216     /// @notice Create `mintedAmount` tokens and send it to `target`
217     /// @param target Address to receive the tokens
218     /// @param mintedAmount the amount of tokens it will receive
219     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
220         balanceOf[target] += mintedAmount;
221         totalSupply += mintedAmount;
222         emit Transfer(this, target, mintedAmount);
223     }
224      /**
225      * Destroy tokens
226      *
227      * Remove `_value` tokens from the system irreversibly
228      *
229      * @param _value the amount of money to burn
230      */
231     function burn(uint256 _value) public returns (bool success) {
232         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
233         balanceOf[msg.sender] -= _value;            // Subtract from the sender
234         totalSupply -= _value;                      // Updates totalSupply
235         emit Burn(msg.sender, _value);
236         return true;
237     }
238 
239     /**
240      * Destroy tokens from other account
241      *
242      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
243      *
244      * @param _from the address of the sender
245      * @param _value the amount of money to burn
246      */
247     function burnFrom(address _from, uint256 _value) public returns (bool success) {
248         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
249         require(_value <= allowance[_from][msg.sender]);    // Check allowance
250         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
251         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
252         totalSupply -= _value;                              // Update totalSupply
253         emit Burn(_from, _value);
254         return true;
255     }
256     
257     /// @dev Set the ICO_Contract.
258     /// @param _ICO_Contract crowdsale contract address
259     function setICO_Contract(address _ICO_Contract) onlyOwner public {
260         ICO_Contract = _ICO_Contract;
261     }
262 }