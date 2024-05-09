1 //Ionixx Token
2 pragma solidity ^0.4.24;
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         assert(c >= a);
17         return c;
18     }
19     /**
20     * @dev Integer division of two numbers, truncating the quotient.
21     */
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return c;
27     }
28 }
29 
30 contract owned {
31     address public owner;
32 
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address newOwner) onlyOwner public {
43         owner = newOwner;
44     }
45 }
46 
47 interface tokenRecipient  {  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}
48 
49 contract TokenERC20 is owned {
50 
51     string public name;
52     string public symbol;
53     uint8 public decimals = 18;
54     uint256 public totalSupply;
55 
56 
57     mapping(address => uint256) public balanceOf;
58     mapping(address => mapping(address => uint256)) public allowance;
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 
62     event Burn(address indexed from, uint256 value);
63 
64     /**
65      * Constrctor function
66      *
67      * Initializes contract with initial supply tokens to the creator of the contract
68      */
69      constructor(
70         uint256 initialSupply,
71         string tokenName,
72         string tokenSymbol
73     ) public {
74         totalSupply = initialSupply * 10 ** uint256(decimals);
75         balanceOf[msg.sender] = totalSupply;
76         name = tokenName;
77         symbol = tokenSymbol;
78     }
79 
80     /**
81      * Internal transfer, only can be called by this contract
82      */
83     function _transfer(address _from, address _to, uint _value) internal {
84         // Prevent transfer to 0x0 address. Use burn() instead
85         require(_to != 0x0);
86         // Check if the sender has enough
87         require(balanceOf[_from] >= _value);
88         // Check for overflows
89         require(balanceOf[_to] + _value > balanceOf[_to]);
90         // Save this for an assertion in the future
91         uint previousBalances = balanceOf[_from] + balanceOf[_to];
92         // Subtract from the sender
93         balanceOf[_from] -= _value;
94         // Add the same to the recipient
95         balanceOf[_to] += _value;
96         emit Transfer(_from, _to, _value);
97         // Asserts are used to use static analysis to find bugs in your code. They should never fail
98         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
99     }
100 
101     /**
102      * Transfer tokens
103      *
104      * Send `_value` tokens to `_to` from your account
105      *
106      * @param _to The address of the recipient
107      * @param _value the amount to send
108      */
109     function transfer(address _to, uint256 _value) public {
110         uint256 val = _value * 10 ** uint256(decimals);
111         _transfer(msg.sender, _to, val);
112     }
113     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
114     /// @param newSellPrice Price the users can sell to the contract
115     /// @param newBuyPrice Price users can buy from the contract
116 
117 
118 
119 
120     /**
121      * Transfer tokens from other address
122      *
123      * Send `_value` tokens to `_to` in behalf of `_from`
124      *
125      * @param _from The address of the sender
126      * @param _to The address of the recipient
127      * @param _value the amount to send
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
130         require(_value <= allowance[_from][msg.sender]);
131         // Check allowance
132         allowance[_from][msg.sender] -= _value;
133         _transfer(_from, _to, _value);
134         return true;
135     }
136 
137     /**
138      * Set allowance for other address
139      *
140      * Allows `_spender` to spend no more than `_value` tokens in your behalf
141      *
142      * @param _spender The address authorized to spend
143      * @param _value the max amount they can spend
144      */
145     function approve(address _spender, uint256 _value) public
146     returns (bool success) {
147         allowance[msg.sender][_spender] = _value;
148         return true;
149     }
150 
151     /**
152      * Set allowance for other address and notify
153      *
154      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
155      *
156      * @param _spender The address authorized to spend
157      * @param _value the max amount they can spend
158      * @param _extraData some extra information to send to the approved contract
159      */
160     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
161     public
162     returns (bool success) {
163         tokenRecipient spender = tokenRecipient(_spender);
164         if (approve(_spender, _value)) {
165             spender.receiveApproval(msg.sender, _value, this, _extraData);
166             return true;
167         }
168     }
169 
170     /**
171      * Destroy tokens
172      *
173      * Remove `_value` tokens from the system irreversibly
174      *
175      * @param _value the amount of money to burn
176      */
177     function burn(uint256 _value) public returns (bool success) {
178         require(balanceOf[msg.sender] >= _value);
179         // Check if the sender has enough
180         balanceOf[msg.sender] -= _value;
181         // Subtract from the sender
182         totalSupply -= _value;
183         // Updates totalSupply
184         emit Burn(msg.sender, _value);
185         return true;
186     }
187 
188     /**
189      * Destroy tokens from other ccount
190      *
191      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
192      *
193      * @param _from the address of the sender
194      * @param _value the amount of money to burn
195      */
196     function burnFrom(address _from, uint256 _value) public returns (bool success) {
197         require(balanceOf[_from] >= _value);
198         // Check if the targeted balance is enough
199         require(_value <= allowance[_from][msg.sender]);
200         // Check allowance
201         balanceOf[_from] -= _value;
202         // Subtract from the targeted balance
203         allowance[_from][msg.sender] -= _value;
204         // Subtract from the sender's allowance
205         totalSupply -= _value;
206         // Update totalSupply
207         emit Burn(_from, _value);
208         return true;
209     }
210 }
211 
212 contract IonixxToken is owned, TokenERC20 {
213 
214     mapping(address => bool) public frozenAccount;
215     address contract_address;
216     /* This generates a public event on the blockchain that will notify clients */
217     event FrozenFunds(address target, bool frozen);
218 
219     /* Initializes contract with initial supply tokens to the creator of the contract */
220     constructor(
221         uint256 initialSupply,
222         string tokenName,
223         string tokenSymbol
224     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
225         owner = msg.sender;
226         contract_address = this;
227     }
228 
229     /* Internal transfer, only can be called by this contract */
230     function _transfer(address _from, address _to, uint _value) internal {
231         require(_to != 0x0);
232         // Prevent transfer to 0x0 address. Use burn() instead
233         require(balanceOf[_from] >= _value);
234         // Check if the sender has enough
235         require(balanceOf[_to] + _value > balanceOf[_to]);
236         // Check for overflows
237         require(!frozenAccount[_from]);
238         // Check if sender is frozen
239         require(!frozenAccount[_to]);
240         // Check if recipient is frozen
241         balanceOf[_from] -= _value;
242         // Subtract from the sender
243         balanceOf[_to] += _value;
244         // Add the same to the recipient
245         emit Transfer(_from, _to, _value);
246     }
247 
248     /// @notice Create `mintedAmount` tokens and send it to `target`
249     /// @param target Address to receive the tokens
250     /// @param mintedAmount the amount of tokens it will receive
251     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
252         balanceOf[target] += mintedAmount;
253         totalSupply += mintedAmount;
254         emit Transfer(0, this, mintedAmount);
255         emit Transfer(this, target, mintedAmount);
256     }
257 
258     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
259     /// @param target Address to be frozen
260     /// @param freeze either to freeze it or not
261     function freezeAccount(address target, bool freeze) onlyOwner public {
262         frozenAccount[target] = freeze;
263         emit FrozenFunds(target, freeze);
264     }
265 
266     
267 
268 }