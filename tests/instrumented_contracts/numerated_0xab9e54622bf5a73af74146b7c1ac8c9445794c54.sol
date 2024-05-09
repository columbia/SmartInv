1 pragma solidity 0.4.21;
2 
3 contract Ownable {
4     address public owner;
5     address public newOwner;
6 
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     function Ownable() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) public onlyOwner {
19         newOwner = _newOwner;
20     }
21     function acceptOwnership() public {
22         require(msg.sender == newOwner);
23         emit OwnershipTransferred(owner, newOwner);
24         owner = newOwner;
25         newOwner = address(0);
26     }
27 }
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
38     if (a == 0) {
39       return 0;
40     }
41     c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     // uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return a / b;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
68     c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 contract Pausable is Ownable {
75 	event Pause();
76 	event Unpause();
77 
78 	bool public paused = false;
79 
80 
81 	/**
82 	 * @dev modifier to allow actions only when the contract IS paused
83 	 */
84 	modifier whenNotPaused() {
85 		require(!paused);
86 		_;
87 	}
88 
89 	/**
90 	 * @dev modifier to allow actions only when the contract IS NOT paused
91 	 */
92 	modifier whenPaused {
93 		require(paused);
94 		_;
95 	}
96 
97 	/**
98 	 * @dev called by the owner to pause, triggers stopped state
99 	 */
100 	function pause() onlyOwner whenNotPaused public returns (bool) {
101 		paused = true;
102 		emit Pause();
103 		return true;
104 	}
105 
106 	/**
107 	 * @dev called by the owner to unpause, returns to normal state
108 	 */
109 	function unpause() onlyOwner whenPaused public returns (bool) {
110 		paused = false;
111 		emit Unpause();
112 		return true;
113 	}
114 }
115 
116 
117 
118 // ----------------------------------------------------------------------------
119 // ERC Token Standard #20 Interface
120 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
121 // ----------------------------------------------------------------------------
122 contract ERC20Interface {
123     function totalSupply() public constant returns (uint);
124     function balanceOf(address tokenOwner) public constant returns (uint balance);
125     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
126     function transfer(address to, uint tokens) public returns (bool success);
127     function approve(address spender, uint tokens) public returns (bool success);
128     function transferFrom(address from, address to, uint tokens) public returns (bool success);
129 
130     event Transfer(address indexed from, address indexed to, uint tokens);
131     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
132 }
133 
134 
135 // ----------------------------------------------------------------------------
136 // Contract function to receive approval and execute function in one call
137 //
138 // Borrowed from MiniMeToken
139 // ----------------------------------------------------------------------------
140 contract ApproveAndCallFallBack {
141     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
142 }
143 
144 
145 // ----------------------------------------------------------------------------
146 // ERC20 Token, with the addition of symbol, name and decimals and an
147 // initial fixed supply
148 // ----------------------------------------------------------------------------
149 contract ROD is ERC20Interface, Pausable {
150     using SafeMath for uint;
151 
152     string public symbol;
153     string public  name;
154     uint8 public decimals;
155     uint public _totalSupply;
156 
157     mapping(address => uint) balances;
158     mapping(address => mapping(address => uint)) allowed;
159 
160 
161     // ------------------------------------------------------------------------
162     // Constructor
163     // ------------------------------------------------------------------------
164     function ROD() public {
165         symbol = "ROD";
166         name = "NeoWorld Rare Ore D";
167         decimals = 18;
168         _totalSupply = 10000000 * 10**uint(decimals);
169         balances[owner] = _totalSupply;
170         emit Transfer(address(0), owner, _totalSupply);
171     }
172 
173     // ------------------------------------------------------------------------
174     // Total supply
175     // ------------------------------------------------------------------------
176     function totalSupply() public constant returns (uint) {
177         return _totalSupply  - balances[address(0)];
178     }
179 
180     // ------------------------------------------------------------------------
181     // Get the token balance for account `tokenOwner`
182     // ------------------------------------------------------------------------
183     function balanceOf(address tokenOwner) public constant returns (uint balance) {
184         return balances[tokenOwner];
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Transfer the balance from token owner's account to `to` account
190     // - Owner's account must have sufficient balance to transfer
191     // - 0 value transfers are allowed
192     // ------------------------------------------------------------------------
193     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
194         balances[msg.sender] = balances[msg.sender].sub(tokens);
195         balances[to] = balances[to].add(tokens);
196         emit Transfer(msg.sender, to, tokens);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for `spender` to transferFrom(...) `tokens`
203     // from the token owner's account
204     //
205     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
206     // recommends that there are no checks for the approval double-spend attack
207     // as this should be implemented in user interfaces 
208     // ------------------------------------------------------------------------
209     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
210         allowed[msg.sender][spender] = tokens;
211         emit Approval(msg.sender, spender, tokens);
212         return true;
213     }
214 
215     function increaseApproval (address _spender, uint _addedValue) public whenNotPaused
216         returns (bool success) {
217         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
218         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219         return true;
220     }
221 
222     function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused
223         returns (bool success) {
224         uint oldValue = allowed[msg.sender][_spender];
225         if (_subtractedValue > oldValue) {
226           allowed[msg.sender][_spender] = 0;
227         } else {
228           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
229         }
230         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231         return true;
232     }
233 
234     // ------------------------------------------------------------------------
235     // Transfer `tokens` from the `from` account to the `to` account
236     // 
237     // The calling account must already have sufficient tokens approve(...)-d
238     // for spending from the `from` account and
239     // - From account must have sufficient balance to transfer
240     // - Spender must have sufficient allowance to transfer
241     // - 0 value transfers are allowed
242     // ------------------------------------------------------------------------
243     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
244         balances[from] = balances[from].sub(tokens);
245         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
246         balances[to] = balances[to].add(tokens);
247         emit Transfer(from, to, tokens);
248         return true;
249     }
250 
251 
252     // ------------------------------------------------------------------------
253     // Returns the amount of tokens approved by the owner that can be
254     // transferred to the spender's account
255     // ------------------------------------------------------------------------
256     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
257         return allowed[tokenOwner][spender];
258     }
259 
260 
261     // ------------------------------------------------------------------------
262     // Token owner can approve for `spender` to transferFrom(...) `tokens`
263     // from the token owner's account. The `spender` contract function
264     // `receiveApproval(...)` is then executed
265     // ------------------------------------------------------------------------
266     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
267         allowed[msg.sender][spender] = tokens;
268         emit Approval(msg.sender, spender, tokens);
269         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
270         return true;
271     }
272 
273 
274     // ------------------------------------------------------------------------
275     // Don't accept ETH
276     // ------------------------------------------------------------------------
277     function () public payable {
278         revert();
279     }
280 
281 
282     // ------------------------------------------------------------------------
283     // Owner can transfer out any accidentally sent ERC20 tokens
284     // ------------------------------------------------------------------------
285     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
286         return ERC20Interface(tokenAddress).transfer(owner, tokens);
287     }
288 }