1 pragma solidity ^0.4.21;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8     if (a == 0) {
9       return 0;
10     }
11     c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   /**
17   * @dev Integer division of two numbers, truncating the quotient.
18   */
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     // uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return a / b;
24   }
25 
26   /**
27   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28   */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   /**
35   * @dev Adds two numbers, throws on overflow.
36   */
37   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
38     c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 /*
45 * Contract that is working with ERC223 tokens
46 */
47  
48 contract ContractReceiver {
49 	function tokenFallback(address _from, uint _value, bytes _data) public pure {
50 	}
51 	function doTransfer(address _to, uint256 _index) public returns (uint256 price, address owner);
52 }
53 
54 contract Ownable {
55 	address public owner;
56 	address public newOwner;
57 
58 	event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60 	function Ownable() public {
61 		owner = msg.sender;
62 	}
63 
64 	modifier onlyOwner {
65 		require(msg.sender == owner);
66 		_;
67 	}
68 
69 	function transferOwnership(address _newOwner) public onlyOwner {
70 		newOwner = _newOwner;
71 	}
72 
73 	function acceptOwnership() public {
74 		require(msg.sender == newOwner);
75 		emit OwnershipTransferred(owner, newOwner);
76 		owner = newOwner;
77 		newOwner = address(0);
78 	}
79 }
80 
81 contract Pausable is Ownable {
82 	event Pause();
83 	event Unpause();
84 
85 	bool public paused = false;
86 
87 
88 	/**
89 	 * @dev modifier to allow actions only when the contract IS paused
90 	 */
91 	modifier whenNotPaused() {
92 		require(!paused);
93 		_;
94 	}
95 
96 	/**
97 	 * @dev modifier to allow actions only when the contract IS NOT paused
98 	 */
99 	modifier whenPaused {
100 		require(paused);
101 		_;
102 	}
103 
104 	/**
105 	 * @dev called by the owner to pause, triggers stopped state
106 	 */
107 	function pause() onlyOwner whenNotPaused public returns (bool) {
108 		paused = true;
109 		emit Pause();
110 		return true;
111 	}
112 
113 	/**
114 	 * @dev called by the owner to unpause, returns to normal state
115 	 */
116 	function unpause() onlyOwner whenPaused public returns (bool) {
117 		paused = false;
118 		emit Unpause();
119 		return true;
120 	}
121 }
122 
123 
124 // ----------------------------------------------------------------------------
125 // ERC Token Standard #20 Interface
126 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
127 // ----------------------------------------------------------------------------
128 contract ERC20Interface {
129 	function totalSupply() public constant returns (uint);
130 	function balanceOf(address tokenOwner) public constant returns (uint);
131 	function allowance(address tokenOwner, address spender) public constant returns (uint);
132 	function transfer(address to, uint tokens) public returns (bool);
133 	function approve(address spender, uint tokens) public returns (bool);
134 	function transferFrom(address from, address to, uint tokens) public returns (bool);
135 
136 	function name() public constant returns (string);
137 	function symbol() public constant returns (string);
138 	function decimals() public constant returns (uint8);
139 
140 	event Transfer(address indexed from, address indexed to, uint tokens);
141 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
142 }
143 
144 
145  /**
146  * ERC223 token by Dexaran
147  *
148  * https://github.com/Dexaran/ERC223-token-standard
149  */
150  
151 
152  /* New ERC223 contract interface */
153  
154 contract ERC223 is ERC20Interface {
155 	function transfer(address to, uint value, bytes data) public returns (bool);
156 	
157 	event Transfer(address indexed from, address indexed to, uint tokens);
158 	event Transfer(address indexed from, address indexed to, uint value, bytes data);
159 }
160 
161  
162 contract NeoWorldCash is ERC223, Pausable {
163 
164 	using SafeMath for uint256;
165 
166 	mapping(address => uint) balances;
167 	mapping(address => mapping(address => uint)) allowed;
168 	
169 	string public name;
170 	string public symbol;
171 	uint8 public decimals;
172 	uint256 public totalSupply;
173 
174 	event Burn(address indexed from, uint256 value);
175 	
176 	// ------------------------------------------------------------------------
177 	// Constructor
178 	// ------------------------------------------------------------------------
179 	function NeoWorldCash() public {
180 		symbol = "NASH";
181 		name = "NEOWORLD CASH";
182 		decimals = 18;
183 		totalSupply = 100000000000 * 10**uint(decimals);
184 		balances[msg.sender] = totalSupply;
185 		emit Transfer(address(0), msg.sender, totalSupply);
186 	}
187 	
188 	
189 	// Function to access name of token .
190 	function name() public constant returns (string) {
191 		return name;
192 	}
193 	// Function to access symbol of token .
194 	function symbol() public constant returns (string) {
195 		return symbol;
196 	}
197 	// Function to access decimals of token .
198 	function decimals() public constant returns (uint8) {
199 		return decimals;
200 	}
201 	// Function to access total supply of tokens .
202 	function totalSupply() public constant returns (uint256) {
203 		return totalSupply;
204 	}
205 	
206 	// Function that is called when a user or another contract wants to transfer funds .
207 	function transfer(address _to, uint _value, bytes _data) public whenNotPaused returns (bool) {
208 		if(isContract(_to)) {
209 			return transferToContract(_to, _value, _data);
210 		}
211 		else {
212 			return transferToAddress(_to, _value, _data);
213 		}
214 	}
215 	
216 	// Standard function transfer similar to ERC20 transfer with no _data .
217 	// Added due to backwards compatibility reasons .
218 	function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
219 		//standard function transfer similar to ERC20 transfer with no _data
220 		//added due to backwards compatibility reasons
221 		bytes memory empty;
222 		if(isContract(_to)) {
223 			return transferToContract(_to, _value, empty);
224 		}
225 		else {
226 			return transferToAddress(_to, _value, empty);
227 		}
228 	}
229 
230 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
231 	function isContract(address _addr) private view returns (bool) {
232 		uint length;
233 		assembly {
234 			//retrieve the size of the code on target address, this needs assembly
235 			length := extcodesize(_addr)
236 		}
237 		return (length>0);
238 	}
239 
240 	//function that is called when transaction target is an address
241 	function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
242 		if (balanceOf(msg.sender) < _value) revert();
243 		balances[msg.sender] = balanceOf(msg.sender).sub(_value);
244 		balances[_to] = balanceOf(_to).add(_value);
245 		emit Transfer(msg.sender, _to, _value);
246 		emit Transfer(msg.sender, _to, _value, _data);
247 		return true;
248 	}
249 	
250 	//function that is called when transaction target is a contract
251 	function transferToContract(address _to, uint _value, bytes _data) private returns (bool) {
252 	
253 		ContractReceiver receiver = ContractReceiver(_to);
254 		uint256 price;
255 		address owner;
256 		(price, owner) = receiver.doTransfer(msg.sender, bytesToUint(_data));
257 
258 		if (balanceOf(msg.sender) < price) revert();
259 		balances[msg.sender] = balanceOf(msg.sender).sub(price);
260 		balances[owner] = balanceOf(owner).add(price);
261 		receiver.tokenFallback(msg.sender, price, _data);
262 		emit Transfer(msg.sender, _to, _value);
263 		emit Transfer(msg.sender, _to, _value, _data);
264 		return true;
265 	}
266 
267 	function balanceOf(address _owner) public constant returns (uint) {
268 		return balances[_owner];
269 	}  
270 
271 	function burn(uint256 _value) public returns (bool) {
272 		require (_value > 0); 
273 		require (balanceOf(msg.sender) >= _value);            // Check if the sender has enough
274 		balances[msg.sender] = balanceOf(msg.sender).sub(_value);                      // Subtract from the sender
275 		totalSupply = totalSupply.sub(_value);                                // Updates totalSupply
276 		emit Burn(msg.sender, _value);
277 		return true;
278 	}
279 
280 	function bytesToUint(bytes b) private pure returns (uint result) {
281 		uint i;
282 		result = 0;
283 		for (i = 0; i < b.length; i++) {
284 			uint c = uint(b[i]);
285 			if (c >= 48 && c <= 57) {
286 				result = result * 10 + (c - 48);
287 			}
288 		}
289 	}
290 
291 	// ------------------------------------------------------------------------
292 	// Token owner can approve for `spender` to transferFrom(...) `tokens`
293 	// from the token owner's account
294 	//
295 	// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
296 	// recommends that there are no checks for the approval double-spend attack
297 	// as this should be implemented in user interfaces 
298 	// ------------------------------------------------------------------------
299 	function approve(address spender, uint tokens) public whenNotPaused returns (bool) {
300 		allowed[msg.sender][spender] = tokens;
301 		emit Approval(msg.sender, spender, tokens);
302 		return true;
303 	}
304 
305 
306 	// ------------------------------------------------------------------------
307 	// Transfer `tokens` from the `from` account to the `to` account
308 	// 
309 	// The calling account must already have sufficient tokens approve(...)-d
310 	// for spending from the `from` account and
311 	// - From account must have sufficient balance to transfer
312 	// - Spender must have sufficient allowance to transfer
313 	// - 0 value transfers are allowed
314 	// ------------------------------------------------------------------------
315 	function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool) {
316 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
317 		balances[from] = balances[from].sub(tokens);
318 		balances[to] = balances[to].add(tokens);
319 		emit Transfer(from, to, tokens);
320 		return true;
321 	}
322 
323 	// ------------------------------------------------------------------------
324 	// Returns the amount of tokens approved by the owner that can be
325 	// transferred to the spender's account
326 	// ------------------------------------------------------------------------
327 	function allowance(address tokenOwner, address spender) public constant returns (uint) {
328 		return allowed[tokenOwner][spender];
329 	}
330 
331 	// ------------------------------------------------------------------------
332 	// Don't accept ETH
333 	// ------------------------------------------------------------------------
334 	function () public payable {
335 		revert();
336 	}
337 
338 	// ------------------------------------------------------------------------
339 	// Owner can transfer out any accidentally sent ERC20 tokens
340 	// ------------------------------------------------------------------------
341 	function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool) {
342 		return ERC20Interface(tokenAddress).transfer(owner, tokens);
343 	}	
344 }