1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract PLATPriceOracle {
50 
51   mapping (address => bool) admins;
52 
53   // How much PLAT you get for 1 ETH, multiplied by 10^18
54   uint256 public ETHPrice = 60000000000000000000000;
55 
56   event PriceChanged(uint256 newPrice);
57 
58   constructor() public {
59     admins[msg.sender] = true;
60   }
61 
62   function updatePrice(uint256 _newPrice) public {
63     require(_newPrice > 0);
64     require(admins[msg.sender] == true);
65     ETHPrice = _newPrice;
66     emit PriceChanged(_newPrice);
67   }
68 
69   function setAdmin(address _newAdmin, bool _value) public {
70     require(admins[msg.sender] == true);
71     admins[_newAdmin] = _value;
72   }
73 }
74 
75 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
76 
77 contract BitGuildToken {
78     // Public variables of the token
79     string public name = "BitGuild PLAT";
80     string public symbol = "PLAT";
81     uint8 public decimals = 18;
82     uint256 public totalSupply = 10000000000 * 10 ** uint256(decimals); // 10 billion tokens;
83 
84     // This creates an array with all balances
85     mapping (address => uint256) public balanceOf;
86     mapping (address => mapping (address => uint256)) public allowance;
87 
88     // This generates a public event on the blockchain that will notify clients
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     // This notifies clients about the amount burnt
92     event Burn(address indexed from, uint256 value);
93 
94     /**
95      * Constructor function
96      * Initializes contract with initial supply tokens to the creator of the contract
97      */
98     function BitGuildToken() public {
99         balanceOf[msg.sender] = totalSupply;
100     }
101 
102     /**
103      * Internal transfer, only can be called by this contract
104      */
105     function _transfer(address _from, address _to, uint _value) internal {
106         // Prevent transfer to 0x0 address. Use burn() instead
107         require(_to != 0x0);
108         // Check if the sender has enough
109         require(balanceOf[_from] >= _value);
110         // Check for overflows
111         require(balanceOf[_to] + _value > balanceOf[_to]);
112         // Save this for an assertion in the future
113         uint previousBalances = balanceOf[_from] + balanceOf[_to];
114         // Subtract from the sender
115         balanceOf[_from] -= _value;
116         // Add the same to the recipient
117         balanceOf[_to] += _value;
118         Transfer(_from, _to, _value);
119         // Asserts are used to use static analysis to find bugs in your code. They should never fail
120         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
121     }
122 
123     /**
124      * Transfer tokens
125      *
126      * Send `_value` tokens to `_to` from your account
127      *
128      * @param _to The address of the recipient
129      * @param _value the amount to send
130      */
131     function transfer(address _to, uint256 _value) public {
132         _transfer(msg.sender, _to, _value);
133     }
134 
135     /**
136      * Transfer tokens from other address
137      *
138      * Send `_value` tokens to `_to` on behalf of `_from`
139      *
140      * @param _from The address of the sender
141      * @param _to The address of the recipient
142      * @param _value the amount to send
143      */
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
145         require(_value <= allowance[_from][msg.sender]);     // Check allowance
146         allowance[_from][msg.sender] -= _value;
147         _transfer(_from, _to, _value);
148         return true;
149     }
150 
151     /**
152      * Set allowance for other address
153      *
154      * Allows `_spender` to spend no more than `_value` tokens on your behalf
155      *
156      * @param _spender The address authorized to spend
157      * @param _value the max amount they can spend
158      */
159     function approve(address _spender, uint256 _value) public
160         returns (bool success) {
161         allowance[msg.sender][_spender] = _value;
162         return true;
163     }
164 
165     /**
166      * Set allowance for other address and notify
167      *
168      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
169      *
170      * @param _spender The address authorized to spend
171      * @param _value the max amount they can spend
172      * @param _extraData some extra information to send to the approved contract
173      */
174     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
175         public
176         returns (bool success) {
177         tokenRecipient spender = tokenRecipient(_spender);
178         if (approve(_spender, _value)) {
179             spender.receiveApproval(msg.sender, _value, this, _extraData);
180             return true;
181         }
182     }
183 
184     /**
185      * Destroy tokens
186      *
187      * Remove `_value` tokens from the system irreversibly
188      *
189      * @param _value the amount of money to burn
190      */
191     function burn(uint256 _value) public returns (bool success) {
192         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
193         balanceOf[msg.sender] -= _value;            // Subtract from the sender
194         totalSupply -= _value;                      // Updates totalSupply
195         Burn(msg.sender, _value);
196         return true;
197     }
198 
199     /**
200      * Destroy tokens from other account
201      *
202      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
203      *
204      * @param _from the address of the sender
205      * @param _value the amount of money to burn
206      */
207     function burnFrom(address _from, uint256 _value) public returns (bool success) {
208         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
209         require(_value <= allowance[_from][msg.sender]);    // Check allowance
210         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
211         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
212         totalSupply -= _value;                              // Update totalSupply
213         Burn(_from, _value);
214         return true;
215     }
216 }
217 
218 
219 contract BitGuildTopUp {
220   using SafeMath for uint256;
221 
222   // Token contract
223   BitGuildToken public token;
224 
225   // Oracle contract
226   PLATPriceOracle public oracle;
227 
228   // Address where funds are collected
229   address public wallet;
230 
231   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
232 
233   constructor(address _token, address _oracle, address _wallet) public {
234     require(_token != address(0));
235     require(_oracle != address(0));
236     require(_wallet != address(0));
237 
238     token = BitGuildToken(_token);
239     oracle = PLATPriceOracle(_oracle);
240     wallet = _wallet;
241   }
242 
243   // low level token purchase function
244   function buyTokens() public payable {
245     // calculate token amount to be created
246     uint256 tokens = getTokenAmount(msg.value, oracle.ETHPrice());
247 
248     // Send tokens
249     token.transfer(msg.sender, tokens);
250     emit TokenPurchase(msg.sender, msg.value, tokens);
251 
252     // Send funds
253     wallet.transfer(msg.value);
254   }
255 
256   // Returns you how much tokens do you get for the wei passed
257   function getTokenAmount(uint256 weiAmount, uint256 price) internal pure returns (uint256) {
258     uint256 tokens = weiAmount.mul(price).div(1 ether);
259     return tokens;
260   }
261 
262   // Fallback function
263   function () external payable {
264     buyTokens();
265   }
266 
267   // Retrieve locked tokens (for when this contract is not needed anymore)
268   function retrieveTokens() public {
269     require(msg.sender == wallet);
270     uint256 tokensLeft = token.balanceOf(this);
271     token.transfer(wallet, tokensLeft);
272   }
273 }