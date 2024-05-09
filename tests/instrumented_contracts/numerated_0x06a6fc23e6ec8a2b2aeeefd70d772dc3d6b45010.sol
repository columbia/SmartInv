1 pragma solidity ^0.5.2;
2 
3 // ----------------------------------------------------------------------------
4 // CryptoProfile Token Contract
5 // ----------------------------------------------------------------------------
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that revert on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, reverts on overflow.
16   */
17   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
18     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (_a == 0) {
22       return 0;
23     }
24 
25     uint256 c = _a * _b;
26     require(c / _a == _b);
27 
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
33   */
34   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     require(_b > 0); // Solidity only automatically asserts when dividing by 0
36     uint256 c = _a / _b;
37     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
38 
39     return c;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     require(_b <= _a);
47     uint256 c = _a - _b;
48 
49     return c;
50   }
51 
52   /**
53   * @dev Adds two numbers, reverts on overflow.
54   */
55   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
56     uint256 c = _a + _b;
57     require(c >= _a);
58 
59     return c;
60   }
61 
62   /**
63   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
64   * reverts when dividing by zero.
65   */
66   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b != 0);
68     return a % b;
69   }
70 }
71 
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 {
78   function totalSupply() public view returns (uint256);
79 
80   function balanceOf(address _who) public view returns (uint256);
81 
82   function allowance(address _owner, address _spender) public view returns (uint256);
83 
84   function transfer(address _to, uint256 _value) public returns (bool);
85 
86   function approve(address _spender, uint256 _value) public returns (bool);
87 
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
89 
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // Contract function to receive approval and execute function in one call
98 //
99 // Borrowed from MiniMeToken
100 // ----------------------------------------------------------------------------
101 contract ApproveAndCallFallBack {
102     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
103 }
104 
105 
106 // ----------------------------------------------------------------------------
107 // Owned contract
108 // ----------------------------------------------------------------------------
109 contract Owned {
110     address public owner;
111     address public newOwner;
112 
113     event OwnershipTransferred(address indexed _from, address indexed _to);
114 
115     constructor() public {
116         owner = msg.sender;
117     }
118 
119     modifier onlyOwner {
120         require(msg.sender == owner);
121         _;
122     }
123 
124     function transferOwnership(address _newOwner) public onlyOwner {
125         newOwner = _newOwner;
126     }
127 
128     function acceptOwnership() public {
129         require(msg.sender == newOwner);
130         emit OwnershipTransferred(owner, newOwner);
131         owner = newOwner;
132         newOwner = address(0);
133     }
134 }
135 
136 
137 // ----------------------------------------------------------------------------
138 //  Detailed ERC20 Token with a fixed supply
139 // ----------------------------------------------------------------------------
140 contract Cryptoprofile is ERC20, Owned {
141     using SafeMath for uint256;
142 
143     string public symbol = "CP";
144     string public  name = "Cryptoprofile";
145     uint8 public decimals = 18;
146     uint256 _totalSupply = 753471015000000000000000000;
147 
148     mapping(address => uint256) balances;
149     mapping(address => mapping(address => uint256)) internal allowed;
150 
151 	
152 	// ------------------------------------------------------------------------
153     // Constructor
154     // ------------------------------------------------------------------------
155     constructor() public {
156         balances[owner] = _totalSupply;
157         emit Transfer(address(0), owner, _totalSupply);
158     }
159 	
160 
161     // ------------------------------------------------------------------------
162     // Total supply
163     // ------------------------------------------------------------------------
164     function totalSupply() public view returns (uint256) {
165         return _totalSupply.sub(balances[address(0)]);
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Get the token balance for account `tokenOwner`
171     // ------------------------------------------------------------------------
172     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
173         return balances[tokenOwner];
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Transfer the balance from token owner's account to `to` account
179     // - Owner's account must have sufficient balance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transfer(address to, uint256 tokens) public returns (bool success) {
183         require(to != address(0));
184         require(tokens <= balances[msg.sender]);
185 
186         balances[msg.sender] = balances[msg.sender].sub(tokens);
187         balances[to] = balances[to].add(tokens);
188         emit Transfer(msg.sender, to, tokens);
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Token owner can approve for `spender` to transferFrom(...) `tokens`
195     // from the token owner's account
196     //
197     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
198     // recommends that there are no checks for the approval double-spend attack
199     // as this should be implemented in user interfaces
200     // ------------------------------------------------------------------------
201     function approve(address spender, uint256 tokens) public returns (bool success) {
202         allowed[msg.sender][spender] = tokens;
203         emit Approval(msg.sender, spender, tokens);
204         return true;
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Token owner can increase the allowance amount that was approved
210     // for `spender` to transferFrom(...) `tokens` from the token owner's account
211     // ------------------------------------------------------------------------
212     function increaseApproval(address spender, uint256 addedValue) public returns (bool success){
213         allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
214         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
215         return true;
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Token owner can decrease the allowance amount that was approved
221     // for `spender` to transferFrom(...) `tokens` from the token owner's account
222     // ------------------------------------------------------------------------
223     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool success)
224     {
225         uint256 oldValue = allowed[msg.sender][spender];
226         if (subtractedValue > oldValue) {
227             allowed[msg.sender][spender] = 0;
228         } else {
229             allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
230         }
231         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
232         return true;
233     }
234 
235 
236     // ------------------------------------------------------------------------
237     // Transfer `tokens` from the `from` account to the `to` account
238     //
239     // The calling account must already have sufficient tokens approve(...)-d
240     // for spending from the `from` account and
241     // - From account must have sufficient balance to transfer
242     // - Spender must have sufficient allowance to transfer
243     // - 0 value transfers are allowed
244     // ------------------------------------------------------------------------
245     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
246         require(to != address(0));
247         require(tokens <= balances[from]);
248         require(tokens <= allowed[from][msg.sender]);
249 
250         balances[from] = balances[from].sub(tokens);
251         balances[to] = balances[to].add(tokens);
252         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
253         emit Transfer(from, to, tokens);
254         return true;
255     }
256 
257 
258     // ------------------------------------------------------------------------
259     // Returns the amount of tokens approved by the owner that can be
260     // transferred to the spender's account
261     // ------------------------------------------------------------------------
262     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
263         return allowed[tokenOwner][spender];
264     }
265 
266 
267     // ------------------------------------------------------------------------
268     // Token owner can approve for `spender` to transferFrom(...) `tokens`
269     // from the token owner's account. The `spender` contract function
270     // `receiveApproval(...)` is then executed
271     // ------------------------------------------------------------------------
272     function approveAndCall(address spender, uint256 tokens, bytes memory data) public returns (bool success) {
273         allowed[msg.sender][spender] = tokens;
274         emit Approval(msg.sender, spender, tokens);
275         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
276         return true;
277     }
278 
279 
280     // ------------------------------------------------------------------------
281     // Don't accept ETH
282     // ------------------------------------------------------------------------
283     function() external payable {
284         revert();
285     }
286 
287 
288     // ------------------------------------------------------------------------
289     // Owner can transfer out any accidentally sent ERC20 tokens
290     // ------------------------------------------------------------------------
291     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
292         return ERC20(tokenAddress).transfer(owner, tokens);
293     }
294 }