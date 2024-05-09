1 pragma solidity ^0.4.22;
2 
3 contract owned {
4     address public owner;
5     constructor() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that revert on error
20  */
21 library SafeMath {
22   /**
23   * @dev Multiplies two numbers, reverts on overflow.
24   */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27     // benefit is lost if 'b' is also tested.
28     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b);
35 
36         return c;
37     }
38 
39   /**
40   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
41   */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b > 0); // Solidity only automatically asserts when dividing by 0
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 
50   /**
51   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
52   */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         require(b <= a);
55         uint256 c = a - b;
56 
57         return c;
58     }
59 
60   /**
61   * @dev Adds two numbers, reverts on overflow.
62   */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a);
66 
67         return c;
68     }
69 
70   /**
71   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
72   * reverts when dividing by zero.
73   */
74     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b != 0);
76         return a % b;
77     }
78 }
79 
80 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
81 
82 contract TokenERC20 {
83     using SafeMath for uint256;
84     // Public variables of the token
85     string public name;
86     string public symbol;
87     uint8 public decimals = 18;
88     // 18 decimals is the strongly suggested default, avoid changing it
89     uint256 public _totalSupply;
90 
91     // This creates an array with all balances
92     mapping (address => uint256) public _balanceOf;
93     mapping (address => mapping (address => uint256)) public allowance;
94 
95     // This generates a public event on the blockchain that will notify clients
96     event Transfer(address indexed from, address indexed to, uint256 value);
97     // This generates a public event on the blockchain that will notify clients
98     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
99     /**
100      * Constrctor function
101      *
102      * Initializes contract with initial supply tokens to the creator of the contract
103      */
104     constructor(
105         uint256 initialSupply,
106         string tokenName,
107         string tokenSymbol
108     ) public {
109         _totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
110         _balanceOf[msg.sender] = _totalSupply;                // Give the creator all initial tokens
111         name = tokenName;                                   // Set the name for display purposes
112         symbol = tokenSymbol;                               // Set the symbol for display purposes
113     }
114 
115     function balanceOf(address _addr) public view returns (uint256) {
116         return _balanceOf[_addr];
117     }
118 
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122     /**
123      * Internal transfer, only can be called by this contract
124      */
125     function _transfer(address _from, address _to, uint256 _value) internal {
126         // Prevent transfer to 0x0 address. Use burn() instead
127         require(_to != 0x0);
128         // Check if the sender has enough
129         require(_balanceOf[_from] >= _value);
130         // Check for overflows
131         require(_balanceOf[_to].add(_value) > _balanceOf[_to]);
132         // Save this for an assertion in the future
133         uint previousBalances = _balanceOf[_from].add(_balanceOf[_to]);
134         _balanceOf[_from] = _balanceOf[_from].sub(_value);
135         _balanceOf[_to] = _balanceOf[_to].add(_value);
136         emit Transfer(_from, _to, _value);
137         // Asserts are used to use static analysis to find bugs in your code. They should never fail
138         assert(_balanceOf[_from].add(_balanceOf[_to]) == previousBalances);
139     }
140     /**
141      * Send `_value` tokens to `_to` in behalf of `_from`
142      * @param _from The address of the sender
143      * @param _to The address of the recipient
144      * @param _value the amount to send
145      */
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
147         require(_value <= allowance[_from][msg.sender]);     // Check allowance
148         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
149         _transfer(_from, _to, _value);
150         return true;
151     }
152     /**
153      * Set allowance for other address
154      * Allows `_spender` to spend no more than `_value` tokens in your behalf
155      * @param _spender The address authorized to spend
156      * @param _value the max amount they can spend
157      */
158     function approve(address _spender, uint256 _value) public returns (bool success) {
159         allowance[msg.sender][_spender] = _value;
160         emit Approval(msg.sender, _spender, _value);
161         return true;
162     }
163     /**
164      * Set allowance for other address and notify
165      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
166      * @param _spender The address authorized to spend
167      * @param _value the max amount they can spend
168      * @param _extraData some extra information to send to the approved contract
169      */
170     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
171         tokenRecipient spender = tokenRecipient(_spender);
172         if (approve(_spender, _value)) {
173             spender.receiveApproval(msg.sender, _value, this, _extraData);
174             return true;
175         }
176     }
177 }
178 
179 /******************************************/
180 /*       ADVANCED TOKEN STARTS HERE       */
181 /******************************************/
182 
183 contract MGT is owned, TokenERC20 {
184     using SafeMath for uint256;
185     mapping (address => uint256) private _frozenOf;
186     event FrozenFunds(address _taget,  uint256 _value);
187     /* Initializes contract with initial supply tokens to the creator of the contract */
188     constructor(
189         uint256 initialSupply,
190         string tokenName,
191         string tokenSymbol
192     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
193 
194     }
195     function transfer(address _to, uint256 _value)  public returns (bool) {
196         if (_value > 0 && _balanceOf[msg.sender].sub(_frozenOf[msg.sender]) >= _value) {
197             _transfer(msg.sender, _to, _value);
198             return true;
199         } else {
200             return false;
201         }
202     }
203 
204     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205         if (_value > 0 && allowance[_from][msg.sender] > 0 &&
206             allowance[_from][msg.sender] >= _value &&
207             _balanceOf[_from].sub(_frozenOf[_from]) >= _value
208             ) {
209             _transfer(_from, _to, _value);
210             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
211             emit Transfer(_from, _to, _value);
212             return true;
213         } else {
214             return false;
215         }
216     }
217     
218     
219     function frozen(address _frozenaddress, uint256 _value) onlyOwner public returns (bool) {
220         if (_value >= 0 && _balanceOf[_frozenaddress] >= _value) {
221             _frozenOf[_frozenaddress] = _value;
222             emit FrozenFunds(_frozenaddress, _value);
223             return true;
224         } else {
225             return false;
226         }
227     }
228 
229     
230     function frozenOf(address _frozenaddress) public view returns (uint256) {
231         return _frozenOf[_frozenaddress];
232     }
233 
234     /**
235      * Set allowance for candy airdrop
236      * Allows `_spender` to spend no more than `_value` tokens in token owner behalf
237      *
238      * @param _owner the address of token owner
239      * @param _spender the address authorized to spend
240      * @param _value the max amount they can spend
241      */
242     function approveAirdrop(address _owner, address _spender, uint256 _value) public returns (bool success) {
243         allowance[_owner][_spender] = _value;
244         emit Approval(_owner, _spender, _value);
245         return true;
246     }
247 
248     /**
249      * Transfer tokens from other address by airdrop
250      *
251      * Send `_value` tokens to `_to` in behalf of `_from` from '_owner'
252      *
253      * @param _owner The address of the token owner
254      * @param _from The address of the sender
255      * @param _to The address of the recipient
256      * @param _value the amount to send
257      */
258     function transferAirdrop(address _owner, address _from, address _to, uint256 _value) public returns (bool success) {
259         require(_value <= allowance[_from][_owner]);
260         allowance[_from][_owner] = allowance[_from][_owner].sub(_value);
261         _transfer(_from, _to, _value);
262         return true;
263     }
264 
265     /**
266      * destruct contract 
267      */
268     function kill() onlyOwner public {
269         selfdestruct(owner);
270     }
271 }