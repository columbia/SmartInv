1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address tokenOwner) external view returns (uint256);
10     function allowance(address tokenOwner, address spender) external view returns (uint256);
11     function transfer(address to, uint256 tokenAmount) external returns (bool);
12     function approve(address spender, uint256 tokenAmount) external returns (bool);
13     function transferFrom(address from, address to, uint256 tokenAmount) external returns (bool);
14     function burn(uint256 tokenAmount) external returns (bool success);
15     function burnFrom(address from, uint256 tokenAmount) external returns (bool success);
16 
17     event Transfer(address indexed from, address indexed to, uint256 tokenAmount);
18     event Approval(address indexed tokenHolder, address indexed spender, uint256 tokenAmount);
19     event Burn(address indexed from, uint256 tokenAmount);
20 }
21 
22 interface tokenRecipient {
23     function receiveApproval(address from, uint256 tokenAmount, address token, bytes extraData) external;
24 }
25 
26 
27 contract owned {
28     address public owner;
29 
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address newOwner) onlyOwner public {
40         owner = newOwner;
41     }
42 }
43 
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that revert on error
49  */
50 library SafeMath {
51 
52     /**
53      * @dev Multiplies two numbers, reverts on overflow.
54      */
55     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
56         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
57         // benefit is lost if 'b' is also tested.
58         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
59         if (_a == 0) {
60             return 0;
61         }
62 
63         uint256 c = _a * _b;
64         require(c / _a == _b, "Multiplication overflow");
65 
66         return c;
67     }
68 
69     /**
70      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
71      */
72     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
73         require(_b > 0, "Division by 0"); // Solidity only automatically requires when dividing by 0
74         uint256 c = _a / _b;
75         // require(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79 
80     /**
81      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
82      */
83     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
84         require(_b <= _a, "Subtraction overflow");
85         uint256 c = _a - _b;
86 
87         return c;
88     }
89 
90     /**
91      * @dev Adds two numbers, reverts on overflow.
92      */
93     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
94         uint256 c = _a + _b;
95         require(c >= _a, "Addition overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
102      * reverts when dividing by zero.
103      */
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         require(b != 0, "Dividing by 0");
106         return a % b;
107     }
108 }
109 
110 
111 
112 
113 
114 
115 
116 contract BrewerscoinToken is owned, IERC20 {
117 
118     using SafeMath for uint256;
119 
120     uint256 private constant base = 1e18;
121     uint256 constant MAX_UINT = 2**256 - 1;
122 
123     // Public variables of the token
124     string public constant name = "Brewer's coin";
125     string public constant symbol = "BREW";
126     uint8 public constant decimals = 18;
127     uint256 public totalSupply = 1e26;              // 100 million
128 
129     // This creates an array with all balances
130     mapping (address => uint256) public balances;
131     mapping (address => mapping (address => uint256)) public allowance;
132 
133     // This generates a public event on the blockchain that will notify clients
134     event Transfer(address indexed from, address indexed to, uint256 tokenAmount);
135     event Approval(address indexed tokenHolder, address indexed spender, uint256 tokenAmount);
136     event Burn(address indexed from, uint256 tokenAmount);
137 
138     // Error messages
139     string private constant NOT_ENOUGH_TOKENS = "Not enough tokens";
140     string private constant NOT_ENOUGH_ETHER = "Not enough ether";
141     string private constant NOT_ENOUGH_ALLOWANCE = "Not enough allowance";
142     string private constant ADDRESS_0_NOT_ALLOWED = "Address 0 not allowed";
143 
144     /**
145      * Constructor function
146      *
147      * Initializes contract with initial supply tokens to the creator of the contract
148      */
149     constructor() public {
150 
151         // put all tokens on owner balance
152         balances[msg.sender] = totalSupply;
153 
154         // allow owner 2^256-1 tokens of this contract, the fee of buyBeer will be transfered to this contract
155         allowance[this][msg.sender] = MAX_UINT;
156     }
157 
158     /**
159      * Total Supply
160      *
161      * Get the total supply of tokens
162      */
163     function totalSupply() external view returns (uint256) {
164         return totalSupply;
165     }
166 
167     /**
168      * Function to check the amount of tokens that an tokenOwner allowed to a spender
169      *
170      * @param tokenOwner address The address which owns the funds
171      * @param spender address The address which will spend the funds
172      */
173     function allowance(address tokenOwner, address spender) external view returns (uint256) {
174         return allowance[tokenOwner][spender];
175     }
176 
177     /**
178      * Function to get the amount of tokens that an address contains
179      *
180      * @param tokenOwner address The address which owns the funds
181      */
182     function balanceOf(address tokenOwner) external view returns (uint256) {
183         return balances[tokenOwner];
184     }
185 
186     /**
187      * Transfer tokens
188      *
189      * Send `tokenAmount` tokens to `to` from your account
190      *
191      * @param to the address of the recipient
192      * @param tokenAmount the amount to send
193      */
194     function transfer(address to, uint256 tokenAmount) external returns (bool) {
195         _transfer(msg.sender, to, tokenAmount);
196 
197         return true;
198     }
199 
200     /**
201      * Transfer tokens from other address if allowed
202      *
203      * Send `tokenAmount` tokens to `to` in behalf of `from`
204      *
205      * @param from The address of the sender
206      * @param to The address of the recipient
207      * @param tokenAmount the amount to send
208      */
209     function transferFrom(address from, address to, uint256 tokenAmount) external returns (bool) {
210 
211         // Check allowance
212         require(tokenAmount <= allowance[from][msg.sender], NOT_ENOUGH_ALLOWANCE);
213 
214         // transfer
215         _transfer(from, to, tokenAmount);
216 
217         // Subtract allowance
218         allowance[from][msg.sender] = allowance[from][msg.sender].sub(tokenAmount);
219 
220         return true;
221     }
222 
223     /**
224      * Internal method for transferring tokens from one address to the other
225      *
226      * Send `tokenAmount` tokens to `to` in behalf of `from`
227      *
228      * @param from the address of the sender
229      * @param to the address of the recipient
230      * @param tokenAmount the amount of tokens to transfer
231      */
232     function _transfer(address from, address to, uint256 tokenAmount) internal {
233 
234         // Check if the sender has enough tokens
235         require(tokenAmount <= balances[from], NOT_ENOUGH_TOKENS);
236 
237         // Prevent transfer to 0x0 address. Use burn() instead
238         require(to != address(0), ADDRESS_0_NOT_ALLOWED);
239 
240         // Subtract tokens from sender
241         balances[from] = balances[from].sub(tokenAmount);
242 
243         // Add the tokens to the recipient
244         balances[to] = balances[to].add(tokenAmount);
245 
246         // Trigger event
247         emit Transfer(from, to, tokenAmount);
248     }
249 
250     /**
251      * Set allowance for other address
252      *
253      * Allows `spender` to spend no more than `tokenAmount` tokens in your behalf
254      *
255      * @param spender The address authorized to spend
256      * @param tokenAmount the max amount they can spend
257      */
258     function approve(address spender, uint256 tokenAmount) external returns (bool success) {
259         return _approve(spender, tokenAmount);
260     }
261 
262     /**
263      * Set allowance for other address and notify
264      *
265      * Allows `spender` to spend no more than `tokenAmount` tokens in your behalf, and then ping the contract about it
266      *
267      * @param spender the address authorised to spend
268      * @param tokenAmount the max amount they can spend
269      * @param extraData some extra information to send to the approved contract
270      */
271     function approveAndCall(address spender, uint256 tokenAmount, bytes extraData) external returns (bool success) {
272         tokenRecipient _spender = tokenRecipient(spender);
273         if (_approve(spender, tokenAmount)) {
274             _spender.receiveApproval(msg.sender, tokenAmount, this, extraData);
275             return true;
276         }
277         return false;
278     }
279 
280     /**
281      * Set allowance for other address
282      *
283      * Allows `spender` to spend no more than `tokenAmount` tokens in your behalf
284      *
285      * @param spender The address authorized to spend
286      * @param tokenAmount the max amount they can spend
287      */
288     function _approve(address spender, uint256 tokenAmount) internal returns (bool success) {
289         allowance[msg.sender][spender] = tokenAmount;
290         emit Approval(msg.sender, spender, tokenAmount);
291         return true;
292     }
293 
294     /**
295      * Destroy tokens
296      *
297      * Remove `tokenAmount` tokens from the system irreversibly
298      *
299      * @param tokenAmount the amount of tokens to burn
300      */
301     function burn(uint256 tokenAmount) external returns (bool success) {
302 
303         _burn(msg.sender, tokenAmount);
304 
305         return true;
306     }
307 
308     /**
309      * Destroy tokens from other account
310      *
311      * Remove `tokenAmount` tokens from the system irreversibly on behalf of `from`.
312      *
313      * @param from the address of the sender
314      * @param tokenAmount the amount of tokens to burn
315      */
316     function burnFrom(address from, uint256 tokenAmount) public returns (bool success) {
317 
318         // Check allowance
319         require(tokenAmount <= allowance[from][msg.sender], NOT_ENOUGH_ALLOWANCE);
320 
321         // Burn
322         _burn(from, tokenAmount);
323 
324         // Subtract from the sender's allowance
325         allowance[from][msg.sender] = allowance[from][msg.sender].sub(tokenAmount);
326 
327         return true;
328     }
329 
330     /**
331      * Destroy tokens
332      *
333      * Remove `tokenAmount` tokens from the system irreversibly
334      *
335      * @param from the address to burn tokens from
336      * @param tokenAmount the amount of tokens to burn
337      */
338     function _burn(address from, uint256 tokenAmount) internal {
339 
340         // Check if the sender has enough
341         require(tokenAmount <= balances[from], NOT_ENOUGH_TOKENS);
342 
343         // Subtract from the sender
344         balances[from] = balances[from].sub(tokenAmount);
345 
346         // Updates totalSupply
347         totalSupply = totalSupply.sub(tokenAmount);
348 
349         // Burn tokens
350         emit Burn(from, tokenAmount);
351     }
352 }