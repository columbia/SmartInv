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
120 // ----------------------------------------------------------------------------
121 // ERC Token Standard #20 Interface
122 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
123 // ----------------------------------------------------------------------------
124 contract ERC20Interface {
125     function totalSupply() public constant returns (uint);
126     function balanceOf(address tokenOwner) public constant returns (uint balance);
127     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
128     function transfer(address to, uint tokens) public returns (bool success);
129     function approve(address spender, uint tokens) public returns (bool success);
130     function transferFrom(address from, address to, uint tokens) public returns (bool success);
131 
132     event Transfer(address indexed from, address indexed to, uint tokens);
133     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
134 }
135 
136 
137 // ----------------------------------------------------------------------------
138 // Contract function to receive approval and execute function in one call
139 //
140 // Borrowed from MiniMeToken
141 // ----------------------------------------------------------------------------
142 contract ApproveAndCallFallBack {
143     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
144 }
145 
146 
147 // ----------------------------------------------------------------------------
148 // ERC20 Token, with the addition of symbol, name and decimals and an
149 // initial fixed supply
150 // ----------------------------------------------------------------------------
151 contract ROB is ERC20Interface, Pausable {
152     using SafeMath for uint;
153 
154     string public symbol;
155     string public  name;
156     uint8 public decimals;
157     uint public _totalSupply;
158 
159     mapping(address => uint) balances;
160     mapping(address => mapping(address => uint)) allowed;
161 
162     event Burn(address indexed from, uint256 value);
163 
164     // ------------------------------------------------------------------------
165     // Constructor
166     // ------------------------------------------------------------------------
167     function ROB() public {
168         symbol = "ROB";
169         name = "NeoWorld Rare Ore B";
170         decimals = 18;
171         _totalSupply = 10000000 * 10**uint(decimals);
172         balances[owner] = _totalSupply;
173         emit Transfer(address(0), owner, _totalSupply);
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Total supply
179     // ------------------------------------------------------------------------
180     function totalSupply() public constant returns (uint) {
181         return _totalSupply  - balances[address(0)];
182     }
183 
184     // ------------------------------------------------------------------------
185     // Get the token balance for account `tokenOwner`
186     // ------------------------------------------------------------------------
187     function balanceOf(address tokenOwner) public constant returns (uint balance) {
188         return balances[tokenOwner];
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Transfer the balance from token owner's account to `to` account
194     // - Owner's account must have sufficient balance to transfer
195     // - 0 value transfers are allowed
196     // ------------------------------------------------------------------------
197     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
198         balances[msg.sender] = balances[msg.sender].sub(tokens);
199         balances[to] = balances[to].add(tokens);
200         emit Transfer(msg.sender, to, tokens);
201         return true;
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Token owner can approve for `spender` to transferFrom(...) `tokens`
207     // from the token owner's account
208     //
209     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
210     // recommends that there are no checks for the approval double-spend attack
211     // as this should be implemented in user interfaces 
212     // ------------------------------------------------------------------------
213     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
214         allowed[msg.sender][spender] = tokens;
215         emit Approval(msg.sender, spender, tokens);
216         return true;
217     }
218 
219     function increaseApproval (address _spender, uint _addedValue) public whenNotPaused
220         returns (bool success) {
221         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused
227         returns (bool success) {
228         uint oldValue = allowed[msg.sender][_spender];
229         if (_subtractedValue > oldValue) {
230           allowed[msg.sender][_spender] = 0;
231         } else {
232           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233         }
234         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235         return true;
236     }
237 
238     // ------------------------------------------------------------------------
239     // Transfer `tokens` from the `from` account to the `to` account
240     // 
241     // The calling account must already have sufficient tokens approve(...)-d
242     // for spending from the `from` account and
243     // - From account must have sufficient balance to transfer
244     // - Spender must have sufficient allowance to transfer
245     // - 0 value transfers are allowed
246     // ------------------------------------------------------------------------
247     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
248         balances[from] = balances[from].sub(tokens);
249         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
250         balances[to] = balances[to].add(tokens);
251         emit Transfer(from, to, tokens);
252         return true;
253     }
254 
255 
256     // ------------------------------------------------------------------------
257     // Returns the amount of tokens approved by the owner that can be
258     // transferred to the spender's account
259     // ------------------------------------------------------------------------
260     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
261         return allowed[tokenOwner][spender];
262     }
263 
264 
265     // ------------------------------------------------------------------------
266     // Token owner can approve for `spender` to transferFrom(...) `tokens`
267     // from the token owner's account. The `spender` contract function
268     // `receiveApproval(...)` is then executed
269     // ------------------------------------------------------------------------
270     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
271         allowed[msg.sender][spender] = tokens;
272         emit Approval(msg.sender, spender, tokens);
273         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
274         return true;
275     }
276 
277 
278     // ------------------------------------------------------------------------
279     // Don't accept ETH
280     // ------------------------------------------------------------------------
281     function () public payable {
282         revert();
283     }
284 
285 
286     // ------------------------------------------------------------------------
287     // Owner can transfer out any accidentally sent ERC20 tokens
288     // ------------------------------------------------------------------------
289     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
290         return ERC20Interface(tokenAddress).transfer(owner, tokens);
291     }
292     
293     function burn(uint256 _value) public onlyOwner returns (bool) {
294         require (_value > 0); 
295         require (balanceOf(msg.sender) >= _value);            // Check if the sender has enough
296         balances[msg.sender] = balanceOf(msg.sender).sub(_value);                      // Subtract from the sender
297         _totalSupply = _totalSupply.sub(_value);                                // Updates totalSupply
298         emit Burn(msg.sender, _value);
299         return true;
300     }    
301 }