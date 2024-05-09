1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Ownable {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     function Ownable() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72     function acceptOwnership() public {
73         require(msg.sender == newOwner);
74         emit OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 contract Pausable is Ownable {
81 	event Pause();
82 	event Unpause();
83 
84 	bool public paused = false;
85 
86 
87 	/**
88 	 * @dev modifier to allow actions only when the contract IS paused
89 	 */
90 	modifier whenNotPaused() {
91 		require(!paused);
92 		_;
93 	}
94 
95 	/**
96 	 * @dev modifier to allow actions only when the contract IS NOT paused
97 	 */
98 	modifier whenPaused {
99 		require(paused);
100 		_;
101 	}
102 
103 	/**
104 	 * @dev called by the owner to pause, triggers stopped state
105 	 */
106 	function pause() onlyOwner whenNotPaused public returns (bool) {
107 		paused = true;
108 		emit Pause();
109 		return true;
110 	}
111 
112 	/**
113 	 * @dev called by the owner to unpause, returns to normal state
114 	 */
115 	function unpause() onlyOwner whenPaused public returns (bool) {
116 		paused = false;
117 		emit Unpause();
118 		return true;
119 	}
120 }
121 
122 
123 
124 // ----------------------------------------------------------------------------
125 // ERC Token Standard #20 Interface
126 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
127 // ----------------------------------------------------------------------------
128 contract ERC20Interface {
129     function totalSupply() public constant returns (uint);
130     function balanceOf(address tokenOwner) public constant returns (uint balance);
131     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
132     function transfer(address to, uint tokens) public returns (bool success);
133     function approve(address spender, uint tokens) public returns (bool success);
134     function transferFrom(address from, address to, uint tokens) public returns (bool success);
135 
136     event Transfer(address indexed from, address indexed to, uint tokens);
137     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
138 }
139 
140 
141 // ----------------------------------------------------------------------------
142 // Contract function to receive approval and execute function in one call
143 //
144 // Borrowed from MiniMeToken
145 // ----------------------------------------------------------------------------
146 contract ApproveAndCallFallBack {
147     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
148 }
149 
150 
151 // ----------------------------------------------------------------------------
152 // ERC20 Token, with the addition of symbol, name and decimals and an
153 // initial fixed supply
154 // ----------------------------------------------------------------------------
155 contract HBL is ERC20Interface, Pausable {
156     using SafeMath for uint;
157 
158     string public symbol;
159     string public  name;
160     uint8 public decimals;
161     uint public _totalSupply;
162 
163     mapping(address => uint) balances;
164     mapping(address => mapping(address => uint)) allowed;
165 
166 
167     // ------------------------------------------------------------------------
168     // Constructor
169     // ------------------------------------------------------------------------
170     function HBL() public {
171         symbol = "HBL";
172         name = "HBLife";
173         decimals = 18;
174         _totalSupply = 7700000000 * 10**uint(decimals);
175         balances[owner] = _totalSupply;
176         emit Transfer(address(0), owner, _totalSupply);
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Total supply
182     // ------------------------------------------------------------------------
183     function totalSupply() public constant returns (uint) {
184         return _totalSupply  - balances[address(0)];
185     }
186 
187     // ------------------------------------------------------------------------
188     // Get the token balance for account `tokenOwner`
189     // ------------------------------------------------------------------------
190     function balanceOf(address tokenOwner) public constant returns (uint balance) {
191         return balances[tokenOwner];
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Transfer the balance from token owner's account to `to` account
197     // - Owner's account must have sufficient balance to transfer
198     // - 0 value transfers are allowed
199     // ------------------------------------------------------------------------
200     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
201         balances[msg.sender] = balances[msg.sender].sub(tokens);
202         balances[to] = balances[to].add(tokens);
203         emit Transfer(msg.sender, to, tokens);
204         return true;
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Token owner can approve for `spender` to transferFrom(...) `tokens`
210     // from the token owner's account
211     //
212     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
213     // recommends that there are no checks for the approval double-spend attack
214     // as this should be implemented in user interfaces 
215     // ------------------------------------------------------------------------
216     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
217         allowed[msg.sender][spender] = tokens;
218         emit Approval(msg.sender, spender, tokens);
219         return true;
220     }
221 
222     function increaseApproval (address _spender, uint _addedValue) public whenNotPaused
223         returns (bool success) {
224         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 
229     function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused
230         returns (bool success) {
231         uint oldValue = allowed[msg.sender][_spender];
232         if (_subtractedValue > oldValue) {
233           allowed[msg.sender][_spender] = 0;
234         } else {
235           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236         }
237         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238         return true;
239     }
240 
241     // ------------------------------------------------------------------------
242     // Transfer `tokens` from the `from` account to the `to` account
243     // 
244     // The calling account must already have sufficient tokens approve(...)-d
245     // for spending from the `from` account and
246     // - From account must have sufficient balance to transfer
247     // - Spender must have sufficient allowance to transfer
248     // - 0 value transfers are allowed
249     // ------------------------------------------------------------------------
250     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
251         balances[from] = balances[from].sub(tokens);
252         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
253         balances[to] = balances[to].add(tokens);
254         emit Transfer(from, to, tokens);
255         return true;
256     }
257 
258 
259     // ------------------------------------------------------------------------
260     // Returns the amount of tokens approved by the owner that can be
261     // transferred to the spender's account
262     // ------------------------------------------------------------------------
263     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
264         return allowed[tokenOwner][spender];
265     }
266 
267 
268     // ------------------------------------------------------------------------
269     // Token owner can approve for `spender` to transferFrom(...) `tokens`
270     // from the token owner's account. The `spender` contract function
271     // `receiveApproval(...)` is then executed
272     // ------------------------------------------------------------------------
273     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
274         allowed[msg.sender][spender] = tokens;
275         emit Approval(msg.sender, spender, tokens);
276         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
277         return true;
278     }
279 
280 
281     // ------------------------------------------------------------------------
282     // Don't accept ETH
283     // ------------------------------------------------------------------------
284     function () public payable {
285         revert();
286     }
287 
288 
289     // ------------------------------------------------------------------------
290     // Owner can transfer out any accidentally sent ERC20 tokens
291     // ------------------------------------------------------------------------
292     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
293         return ERC20Interface(tokenAddress).transfer(owner, tokens);
294     }
295 }