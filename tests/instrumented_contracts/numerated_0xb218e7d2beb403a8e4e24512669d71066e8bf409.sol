1 pragma solidity ^0.4.23;
2 /**
3  * Devron Kim's research purose token.
4  * Do not send Ether unless necessary.
5 **/
6 
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
25 
26 /**
27 * Using SafeMath Library to avoid overflow/underflow
28 */
29 
30 library SafeMath {
31 
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     if (a == 0) {
34       return 0;
35     }
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 contract Token {
60     string public name = "DevronKim's Research Purpose";
61     string public constant symbol = "DRP";
62     uint8 public constant decimals = 18;
63     uint256 public totalSupply = 100000000 * 10 ** uint256(decimals);
64 
65     using SafeMath for uint256;
66 
67     mapping (address => uint256) public balanceOf;
68     mapping (address => mapping (address => uint256)) public allowance;
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     event Burn(address indexed from, uint256 value);
73 
74     constructor() public {
75 
76         balanceOf[msg.sender] = totalSupply;
77     }
78 
79     /**
80      * Internal transfer, only can be called by this contract
81      */
82     function _transfer(address _from, address _to, uint _value) internal {
83         require(_to != 0x0);
84         require(balanceOf[_from] >= _value);
85         require(balanceOf[_to].add(_value) > balanceOf[_to]);
86         uint256 previousBalances = balanceOf[_to].add(balanceOf[_from]);
87         balanceOf[_from] = balanceOf[_from].sub(_value);
88         balanceOf[_to] = balanceOf[_to].add(_value);
89         emit Transfer(_from, _to, _value);
90         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
91     }
92 
93     /**
94      * Transfer tokens
95      *
96      * Send `_value` tokens to `_to` from your account
97      *
98      * @param _to The address of the recipient
99      * @param _value the amount to send
100      */
101     function transfer(address _to, uint256 _value) public {
102         _transfer(msg.sender, _to, _value);
103     }
104 
105     /**
106      * Transfer tokens from other address
107      *
108      * Send `_value` tokens to `_to` in behalf of `_from`
109      *
110      * @param _from The address of the sender
111      * @param _to The address of the recipient
112      * @param _value the amount to send
113      */
114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
115         require(_value <= allowance[_from][msg.sender]);     // Check allowance
116         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
117         _transfer(_from, _to, _value);
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      */
129     function approve(address _spender, uint256 _value) public
130         returns (bool success) {
131         allowance[msg.sender][_spender] = _value;
132         return true;
133     }
134 
135     /**
136      * Set allowance for other address and notify
137      *
138      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
139      *
140      * @param _spender The address authorized to spend
141      * @param _value the max amount they can spend
142      * @param _extraData some extra information to send to the approved contract
143      */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
145         public
146         returns (bool success) {
147         tokenRecipient spender = tokenRecipient(_spender);
148         if (approve(_spender, _value)) {
149             spender.receiveApproval(msg.sender, _value, this, _extraData);
150             return true;
151         }
152     }
153 
154     /**
155      * Destroy tokens
156      *
157      * Remove `_value` tokens from the system irreversibly
158      *
159      * @param _value the amount of money to burn
160      */
161     function burn(uint256 _value) public returns (bool success) {
162         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
163         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value) ;            // Subtract from the sender
164         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
165         emit Burn(msg.sender, _value);
166         return true;
167     }
168 
169     /**
170      * Destroy tokens from other account
171      *
172      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
173      *
174      * @param _from the address of the sender
175      * @param _value the amount of money to burn
176      */
177     function burnFrom(address _from, uint256 _value) public returns (bool success) {
178         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
179         require(_value <= allowance[_from][msg.sender]);    // Check allowance
180         balanceOf[_from] = balanceOf[_from].sub(_value);                           // Subtract from the targeted balance
181         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);   // Subtract from the sender's allowance
182         totalSupply = totalSupply.sub(_value);                                     // Update totalSupply
183         emit Burn(_from, _value);
184         return true;
185     }
186 }
187 
188 contract DRPtoken is owned, Token {
189 
190     uint256 public sellPrice;
191     uint256 public buyPrice;
192 
193     using SafeMath for uint256;
194 
195     mapping (address => bool) public frozenAccount;
196 
197     /* This generates a public event on the blockchain that will notify clients */
198     event FrozenFunds(address target, bool frozen);
199 
200     /* Initializes contract with initial supply tokens to the creator of the contract */
201     constructor() Token() public {}
202 
203     /* Internal transfer, only can be called by this contract */
204     function _transfer(address _from, address _to, uint _value) internal {
205         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
206         require (balanceOf[_from] >= _value);               // Check if the sender has enough
207         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
208         require(!frozenAccount[_from]);                     // Check if sender is frozen
209         require(!frozenAccount[_to]);                       // Check if recipient is frozen
210         balanceOf[_from] = balanceOf[_from].sub(_value);
211         balanceOf[_to] = balanceOf[_to].add(_value);
212         emit Transfer(_from, _to, _value);
213     }
214 
215     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
216     /// @param target Address to be frozen
217     /// @param freeze either to freeze it or not
218     function freezeAccount(address target, bool freeze) onlyOwner public {
219         frozenAccount[target] = freeze;
220         emit FrozenFunds(target, freeze);
221     }
222 
223     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
224     /// @param newSellPrice Price the users can sell to the contract
225     /// @param newBuyPrice Price users can buy from the contract
226     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
227         sellPrice = newSellPrice;
228         buyPrice = newBuyPrice;
229     }
230 
231     /// @notice Buy tokens from contract by sending ether
232     function buy() payable public {
233         uint amount = msg.value.div(buyPrice);               // calculates the amount
234         _transfer(this, msg.sender, amount);              // makes the transfers
235     }
236 
237     /// @notice Sell `amount` tokens to contract
238     /// @param amount amount of tokens to be sold
239     function sell(uint256 amount) public {
240         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
241         _transfer(msg.sender, this, amount);              // makes the transfers
242         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
243     }
244 }