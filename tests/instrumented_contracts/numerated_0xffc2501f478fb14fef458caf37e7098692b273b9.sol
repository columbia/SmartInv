1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Ownable {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     function Ownable() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner {
22         newOwner = _newOwner;
23     }
24     function acceptOwnership() public {
25         require(msg.sender == newOwner);
26         emit OwnershipTransferred(owner, newOwner);
27         owner = newOwner;
28         newOwner = address(0);
29     }
30 }
31 
32 contract Pausable is Ownable {
33 	event Pause();
34 	event Unpause();
35 
36 	bool public paused = false;
37 
38 
39 	/**
40 	 * @dev modifier to allow actions only when the contract IS paused
41 	 */
42 	modifier whenNotPaused() {
43 		require(!paused);
44 		_;
45 	}
46 
47 	/**
48 	 * @dev modifier to allow actions only when the contract IS NOT paused
49 	 */
50 	modifier whenPaused {
51 		require(paused);
52 		_;
53 	}
54 
55 	/**
56 	 * @dev called by the owner to pause, triggers stopped state
57 	 */
58 	function pause() onlyOwner whenNotPaused public returns (bool) {
59 		paused = true;
60 		emit Pause();
61 		return true;
62 	}
63 
64 	/**
65 	 * @dev called by the owner to unpause, returns to normal state
66 	 */
67 	function unpause() onlyOwner whenPaused public returns (bool) {
68 		paused = false;
69 		emit Unpause();
70 		return true;
71 	}
72 }
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79   /**
80   * @dev Multiplies two numbers, throws on overflow.
81   */
82   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     if (a == 0) {
84       return 0;
85     }
86     c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     // assert(b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     return a / b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113     c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 // ----------------------------------------------------------------------------
120 // ERC Token Standard #20 Interface
121 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
122 // ----------------------------------------------------------------------------
123 contract ERC20Interface {
124     function totalSupply() public constant returns (uint);
125     function balanceOf(address tokenOwner) public constant returns (uint balance);
126     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
127     function transfer(address to, uint tokens) public returns (bool success);
128     function approve(address spender, uint tokens) public returns (bool success);
129     function transferFrom(address from, address to, uint tokens) public returns (bool success);
130 
131     event Transfer(address indexed from, address indexed to, uint tokens);
132     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
133 }
134 
135 
136 // ----------------------------------------------------------------------------
137 // Contract function to receive approval and execute function in one call
138 //
139 // Borrowed from MiniMeToken
140 // ----------------------------------------------------------------------------
141 contract ApproveAndCallFallBack {
142     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
143 }
144 
145 
146 // ----------------------------------------------------------------------------
147 // ERC20 Token, with the addition of symbol, name and decimals and an
148 // initial fixed supply
149 // ----------------------------------------------------------------------------
150 contract COS is ERC20Interface, Pausable {
151     using SafeMath for uint;
152 
153     string public symbol;
154     string public  name;
155     uint8 public decimals;
156     uint public _totalSupply;
157 
158     mapping(address => uint) balances;
159     mapping(address => mapping(address => uint)) allowed;
160 
161 
162     // ------------------------------------------------------------------------
163     // Constructor
164     // ------------------------------------------------------------------------
165     function COS() public {
166         symbol = "COS";
167         name = "COS";
168         decimals = 18;
169         _totalSupply = 999999999 * 10**uint(decimals);
170         balances[owner] = _totalSupply;
171         emit Transfer(address(0), owner, _totalSupply);
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Total supply
177     // ------------------------------------------------------------------------
178     function totalSupply() public constant returns (uint) {
179         return _totalSupply  - balances[address(0)];
180     }
181 
182     // ------------------------------------------------------------------------
183     // Get the token balance for account `tokenOwner`
184     // ------------------------------------------------------------------------
185     function balanceOf(address tokenOwner) public constant returns (uint balance) {
186         return balances[tokenOwner];
187     }
188 
189 
190     // ------------------------------------------------------------------------
191     // Transfer the balance from token owner's account to `to` account
192     // - Owner's account must have sufficient balance to transfer
193     // - 0 value transfers are allowed
194     // ------------------------------------------------------------------------
195     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
196         balances[msg.sender] = balances[msg.sender].sub(tokens);
197         balances[to] = balances[to].add(tokens);
198         emit Transfer(msg.sender, to, tokens);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Token owner can approve for `spender` to transferFrom(...) `tokens`
205     // from the token owner's account
206     //
207     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
208     // recommends that there are no checks for the approval double-spend attack
209     // as this should be implemented in user interfaces 
210     // ------------------------------------------------------------------------
211     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
212         allowed[msg.sender][spender] = tokens;
213         emit Approval(msg.sender, spender, tokens);
214         return true;
215     }
216 
217     function increaseApproval (address _spender, uint _addedValue) public whenNotPaused
218         returns (bool success) {
219         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
220         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221         return true;
222     }
223 
224     function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused
225         returns (bool success) {
226         uint oldValue = allowed[msg.sender][_spender];
227         if (_subtractedValue > oldValue) {
228           allowed[msg.sender][_spender] = 0;
229         } else {
230           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231         }
232         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233         return true;
234     }
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
245     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
246         balances[from] = balances[from].sub(tokens);
247         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
248         balances[to] = balances[to].add(tokens);
249         emit Transfer(from, to, tokens);
250         return true;
251     }
252 
253 
254     // ------------------------------------------------------------------------
255     // Returns the amount of tokens approved by the owner that can be
256     // transferred to the spender's account
257     // ------------------------------------------------------------------------
258     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
259         return allowed[tokenOwner][spender];
260     }
261 
262 
263     // ------------------------------------------------------------------------
264     // Token owner can approve for `spender` to transferFrom(...) `tokens`
265     // from the token owner's account. The `spender` contract function
266     // `receiveApproval(...)` is then executed
267     // ------------------------------------------------------------------------
268     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
269         allowed[msg.sender][spender] = tokens;
270         emit Approval(msg.sender, spender, tokens);
271         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
272         return true;
273     }
274 
275 
276     // ------------------------------------------------------------------------
277     // Don't accept ETH
278     // ------------------------------------------------------------------------
279     function () public payable {
280         revert();
281     }
282 
283 
284     // ------------------------------------------------------------------------
285     // Owner can transfer out any accidentally sent ERC20 tokens
286     // ------------------------------------------------------------------------
287     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
288         return ERC20Interface(tokenAddress).transfer(owner, tokens);
289     }
290 }