1 pragma solidity ^0.4.16;
2 
3 contract Owned {
4     address public owner;
5 
6     function Owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 // Abstract contract for the full ERC 20 Token standard
23 // https://github.com/ethereum/EIPs/issues/20
24 contract TokenERC20 {
25     // Public variables of the token
26     string public name;
27     string public symbol;
28     uint8 public decimals = 18;
29     // 18 decimals is the strongly suggested default, avoid changing it
30     uint256 public constant TOKEN_UNIT = 10 ** 18;
31 
32     uint256 internal _totalSupply;
33     mapping (address => uint256) internal _balanceOf;
34     mapping (address => mapping (address => uint256)) internal _allowance;
35 
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     function TokenERC20(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public 
53     {
54         _totalSupply = initialSupply * TOKEN_UNIT;  // Update total supply with the decimal amount
55         _balanceOf[msg.sender] = _totalSupply;                // Give the creator all initial tokens
56         name = tokenName;                                   // Set the name for display purposes
57         symbol = tokenSymbol;                               // Set the symbol for display purposes
58     }
59 
60 
61     function totalSupply() constant public returns (uint256) {
62         return _totalSupply;
63     }
64     function balanceOf(address src) constant public returns (uint256) {
65         return _balanceOf[src];
66     }
67     function allowance(address src, address guy) constant public returns (uint256) {
68         return _allowance[src][guy];
69     }
70 
71 
72     /**
73      * Internal transfer, only can be called by this contract
74      */
75     function _transfer(address _from, address _to, uint _value) internal {
76         // Prevent transfer to 0x0 address. Use burn() instead
77         require(_to != 0x0);
78         // Check if the sender has enough
79         require(_balanceOf[_from] >= _value);
80         // Check for overflows
81         require(_balanceOf[_to] + _value > _balanceOf[_to]);
82         // Save this for an assertion in the future
83         uint previousBalances = _balanceOf[_from] + _balanceOf[_to];
84         // Subtract from the sender
85         _balanceOf[_from] -= _value;
86         // Add the same to the recipient
87         _balanceOf[_to] += _value;
88         Transfer(_from, _to, _value);
89         // Asserts are used to use static analysis to find bugs in your code. They should never fail
90         assert(_balanceOf[_from] + _balanceOf[_to] == previousBalances);
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
115         require(_value <= _allowance[_from][msg.sender]);     // Check allowance
116         _allowance[_from][msg.sender] -= _value;
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
130         returns (bool success) 
131     {
132         _allowance[msg.sender][_spender] = _value;
133         return true;
134     }
135 
136     /**
137      * Set allowance for other address and notify
138      *
139      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
140      *
141      * @param _spender The address authorized to spend
142      * @param _value the max amount they can spend
143      * @param _extraData some extra information to send to the approved contract
144      */
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
146         public
147         returns (bool success) 
148     {
149         tokenRecipient spender = tokenRecipient(_spender);
150         if (approve(_spender, _value)) {
151             spender.receiveApproval(msg.sender, _value, this, _extraData);
152             return true;
153         }
154     }
155 
156     /**
157      * Destroy tokens
158      *
159      * Remove `_value` tokens from the system irreversibly
160      *
161      * @param _value the amount of money to burn
162      */
163     function burn(uint256 _value) public returns (bool success) {
164         require(_balanceOf[msg.sender] >= _value);   // Check if the sender has enough
165         _balanceOf[msg.sender] -= _value;            // Subtract from the sender
166         _totalSupply -= _value;                      // Updates totalSupply
167         Burn(msg.sender, _value);
168         return true;
169     }
170 
171     /**
172      * Destroy tokens from other account
173      *
174      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
175      *
176      * @param _from the address of the sender
177      * @param _value the amount of money to burn
178      */
179     function burnFrom(address _from, uint256 _value) public returns (bool success) {
180         require(_balanceOf[_from] >= _value);                // Check if the targeted balance is enough
181         require(_value <= _allowance[_from][msg.sender]);    // Check allowance
182         _balanceOf[_from] -= _value;                         // Subtract from the targeted balance
183         _allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
184         _totalSupply -= _value;                              // Update totalSupply
185         Burn(_from, _value);
186         return true;
187     }
188 }
189 
190 
191 /**
192  * Math operations with safety checks
193  */
194 library SafeMath {
195   function mul(uint a, uint b) internal pure returns (uint) {
196     uint c = a * b;
197     assert(a == 0 || c / a == b);
198     return c;
199   }
200 
201   function div(uint a, uint b) internal pure returns (uint) {
202     // assert(b > 0); // Solidity automatically throws when dividing by 0
203     uint c = a / b;
204     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205     return c;
206   }
207 
208   function sub(uint a, uint b) internal pure returns (uint) {
209     assert(b <= a);
210     return a - b;
211   }
212 
213   function add(uint a, uint b) internal pure returns (uint) {
214     uint c = a + b;
215     assert(c >= a);
216     return c;
217   }
218 
219   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
220     return a >= b ? a : b;
221   }
222 
223   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
224     return a < b ? a : b;
225   }
226 
227   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
228     return a >= b ? a : b;
229   }
230 
231   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
232     return a < b ? a : b;
233   }
234 }
235 
236 
237 contract PeralToken is Owned, TokenERC20 {
238     using SafeMath for uint256;
239 
240     /* This generates a public event on the blockchain that will notify clients */
241     event FrozenFunds(address target, bool frozen);
242     
243     mapping (address => bool) public frozenAccount;
244     mapping (address => bool) private allowMint;
245     bool _closeSale = false;
246 
247     /* Initializes contract with initial supply tokens to the creator of the contract */
248     function PeralToken(uint remainAmount,string tokenName,string tokenSymbol) TokenERC20(remainAmount, tokenName, tokenSymbol) public {
249         
250     }
251 
252     /* Internal transfer, only can be called by this contract */
253     function _transfer(address _from, address _to, uint _value) internal {
254         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
255         require (_balanceOf[_from] >= _value);               // Check if the sender has enough
256         require (_balanceOf[_to].add(_value) > _balanceOf[_to]); // Check for overflows
257         require(_closeSale);
258         require(!frozenAccount[_from]);                     // Check if sender is frozen
259         require(!frozenAccount[_to]);                       // Check if recipient is frozen
260         _balanceOf[_from] = _balanceOf[_from].sub(_value);                         // Subtract from the sender
261         _balanceOf[_to] = _balanceOf[_to].add(_value);                           // Add the same to the recipient
262         Transfer(_from, _to, _value);
263     }
264 
265     /// @notice Create `mintedAmount` tokens and send it to `target`
266     /// @param target Address to receive the tokens
267     /// @param mintedAmount the amount of tokens it will receive
268     function mintToken(address target, uint256 mintedAmount) public {
269         require(allowMint[msg.sender]);
270         _balanceOf[target] = _balanceOf[target].add(mintedAmount);
271         _totalSupply = _totalSupply.add(mintedAmount);
272         Transfer(0, this, mintedAmount);
273         Transfer(this, target, mintedAmount);
274     }
275 
276     /// @notice Create `mintedAmount` tokens and send it to `target`
277     /// @param target Address to receive the tokens
278     /// @param mintedAmount the amount of tokens it will receive
279     function mintTokenWithUnit(address target, uint256 mintedAmount) public {
280         require(allowMint[msg.sender]);
281         uint256 amount = mintedAmount.mul(TOKEN_UNIT);
282         _balanceOf[target] = _balanceOf[target].add(amount);
283         _totalSupply = _totalSupply.add(amount);
284         Transfer(0, this, mintedAmount);
285         Transfer(this, target, mintedAmount);
286     }
287 
288 
289 
290     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
291     /// @param target Address to be frozen
292     /// @param freeze either to freeze it or not
293     function freezeAccount(address target, bool freeze) onlyOwner public {
294         frozenAccount[target] = freeze;
295         FrozenFunds(target, freeze);
296     }
297 
298      function setMintContactAddress(address _contactAddress) onlyOwner public {
299         allowMint[_contactAddress] = true;
300     }
301 
302     function disableContactMint(address _contactAddress) onlyOwner public {
303         allowMint[_contactAddress] = false;
304     }
305 
306     function closeSale(bool close) onlyOwner public {
307         _closeSale = close;
308     }
309 
310 }