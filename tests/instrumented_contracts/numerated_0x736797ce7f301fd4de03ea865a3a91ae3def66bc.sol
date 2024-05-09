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
50 contract Ownable {
51     address public owner;
52     address public newOwner;
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56     function Ownable() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner {
66         newOwner = _newOwner;
67     }
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = address(0);
73     }
74 }
75 
76 
77 contract Pausable is Ownable {
78 	event Pause();
79 	event Unpause();
80 
81 	bool public paused = false;
82 
83 
84 	/**
85 	 * @dev modifier to allow actions only when the contract IS paused
86 	 */
87 	modifier whenNotPaused() {
88 		require(!paused);
89 		_;
90 	}
91 
92 	/**
93 	 * @dev modifier to allow actions only when the contract IS NOT paused
94 	 */
95 	modifier whenPaused {
96 		require(paused);
97 		_;
98 	}
99 
100 	/**
101 	 * @dev called by the owner to pause, triggers stopped state
102 	 */
103 	function pause() onlyOwner whenNotPaused public returns (bool) {
104 		paused = true;
105 		emit Pause();
106 		return true;
107 	}
108 
109 	/**
110 	 * @dev called by the owner to unpause, returns to normal state
111 	 */
112 	function unpause() onlyOwner whenPaused public returns (bool) {
113 		paused = false;
114 		emit Unpause();
115 		return true;
116 	}
117 }
118 
119 
120 
121 // ----------------------------------------------------------------------------
122 // ERC Token Standard #20 Interface
123 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
124 // ----------------------------------------------------------------------------
125 contract ERC20Interface {
126     function totalSupply() public constant returns (uint);
127     function balanceOf(address tokenOwner) public constant returns (uint balance);
128     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
129     function transfer(address to, uint tokens) public returns (bool success);
130     function approve(address spender, uint tokens) public returns (bool success);
131     function transferFrom(address from, address to, uint tokens) public returns (bool success);
132 
133     event Transfer(address indexed from, address indexed to, uint tokens);
134     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
135 }
136 
137 
138 // ----------------------------------------------------------------------------
139 // Contract function to receive approval and execute function in one call
140 //
141 // Borrowed from MiniMeToken
142 // ----------------------------------------------------------------------------
143 contract ApproveAndCallFallBack {
144     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
145 }
146 
147 
148 // ----------------------------------------------------------------------------
149 // ERC20 Token, with the addition of symbol, name and decimals and an
150 // initial fixed supply
151 // ----------------------------------------------------------------------------
152 contract ROD is ERC20Interface, Pausable {
153     using SafeMath for uint;
154 
155     string public symbol;
156     string public  name;
157     uint8 public decimals;
158     uint public _totalSupply;
159 
160     mapping(address => uint) balances;
161     mapping(address => mapping(address => uint)) allowed;
162 
163     event Burn(address indexed from, uint256 value);
164 
165     // ------------------------------------------------------------------------
166     // Constructor
167     // ------------------------------------------------------------------------
168     function ROD() public {
169         symbol = "ROD";
170         name = "NeoWorld Rare Ore D";
171         decimals = 18;
172         _totalSupply = 10000000 * 10**uint(decimals);
173         balances[owner] = _totalSupply;
174         emit Transfer(address(0), owner, _totalSupply);
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Total supply
180     // ------------------------------------------------------------------------
181     function totalSupply() public constant returns (uint) {
182         return _totalSupply  - balances[address(0)];
183     }
184 
185     // ------------------------------------------------------------------------
186     // Get the token balance for account `tokenOwner`
187     // ------------------------------------------------------------------------
188     function balanceOf(address tokenOwner) public constant returns (uint balance) {
189         return balances[tokenOwner];
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Transfer the balance from token owner's account to `to` account
195     // - Owner's account must have sufficient balance to transfer
196     // - 0 value transfers are allowed
197     // ------------------------------------------------------------------------
198     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
199         balances[msg.sender] = balances[msg.sender].sub(tokens);
200         balances[to] = balances[to].add(tokens);
201         emit Transfer(msg.sender, to, tokens);
202         return true;
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Token owner can approve for `spender` to transferFrom(...) `tokens`
208     // from the token owner's account
209     //
210     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
211     // recommends that there are no checks for the approval double-spend attack
212     // as this should be implemented in user interfaces 
213     // ------------------------------------------------------------------------
214     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
215         allowed[msg.sender][spender] = tokens;
216         emit Approval(msg.sender, spender, tokens);
217         return true;
218     }
219 
220     function increaseApproval (address _spender, uint _addedValue) public whenNotPaused
221         returns (bool success) {
222         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
223         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 
227     function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused
228         returns (bool success) {
229         uint oldValue = allowed[msg.sender][_spender];
230         if (_subtractedValue > oldValue) {
231           allowed[msg.sender][_spender] = 0;
232         } else {
233           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234         }
235         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236         return true;
237     }
238 
239     // ------------------------------------------------------------------------
240     // Transfer `tokens` from the `from` account to the `to` account
241     // 
242     // The calling account must already have sufficient tokens approve(...)-d
243     // for spending from the `from` account and
244     // - From account must have sufficient balance to transfer
245     // - Spender must have sufficient allowance to transfer
246     // - 0 value transfers are allowed
247     // ------------------------------------------------------------------------
248     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
249         balances[from] = balances[from].sub(tokens);
250         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
251         balances[to] = balances[to].add(tokens);
252         emit Transfer(from, to, tokens);
253         return true;
254     }
255 
256 
257     // ------------------------------------------------------------------------
258     // Returns the amount of tokens approved by the owner that can be
259     // transferred to the spender's account
260     // ------------------------------------------------------------------------
261     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
262         return allowed[tokenOwner][spender];
263     }
264 
265 
266     // ------------------------------------------------------------------------
267     // Token owner can approve for `spender` to transferFrom(...) `tokens`
268     // from the token owner's account. The `spender` contract function
269     // `receiveApproval(...)` is then executed
270     // ------------------------------------------------------------------------
271     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
272         allowed[msg.sender][spender] = tokens;
273         emit Approval(msg.sender, spender, tokens);
274         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
275         return true;
276     }
277 
278 
279     // ------------------------------------------------------------------------
280     // Don't accept ETH
281     // ------------------------------------------------------------------------
282     function () public payable {
283         revert();
284     }
285 
286 
287     // ------------------------------------------------------------------------
288     // Owner can transfer out any accidentally sent ERC20 tokens
289     // ------------------------------------------------------------------------
290     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
291         return ERC20Interface(tokenAddress).transfer(owner, tokens);
292     }
293 
294     function burn(uint256 _value) public onlyOwner returns (bool) {
295         require (_value > 0); 
296         require (balanceOf(msg.sender) >= _value);            // Check if the sender has enough
297         balances[msg.sender] = balanceOf(msg.sender).sub(_value);                      // Subtract from the sender
298         _totalSupply = _totalSupply.sub(_value);                                // Updates totalSupply
299         emit Burn(msg.sender, _value);
300         return true;
301     }    
302 }