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
54 contract Owned {
55 	address public owner;
56 	address public newOwner;
57 
58 	event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60 	function Owned() public {
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
81 // ----------------------------------------------------------------------------
82 // ERC Token Standard #20 Interface
83 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
84 // ----------------------------------------------------------------------------
85 contract ERC20Interface {
86     function totalSupply() public view returns (uint);
87     function balanceOf(address tokenOwner) public constant returns (uint);
88     function allowance(address tokenOwner, address spender) public constant returns (uint);
89     function transfer(address to, uint tokens) public returns (bool);
90     function approve(address spender, uint tokens) public returns (bool);
91     function transferFrom(address from, address to, uint tokens) public returns (bool);
92 
93 	function name() public view returns (string);
94 	function symbol() public view returns (string);
95 	function decimals() public view returns (uint8);
96 
97     event Transfer(address indexed from, address indexed to, uint tokens);
98     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
99 }
100 
101 
102  /**
103  * ERC223 token by Dexaran
104  *
105  * https://github.com/Dexaran/ERC223-token-standard
106  */
107  
108 
109  /* New ERC223 contract interface */
110  
111 contract ERC223 is ERC20Interface {
112 	function transfer(address to, uint value, bytes data) public returns (bool);
113 	
114 	event Transfer(address indexed from, address indexed to, uint tokens);
115 	event Transfer(address indexed from, address indexed to, uint value, bytes data);
116 }
117 
118  
119 contract NeoWorldCash is ERC223, Owned {
120 
121 	using SafeMath for uint256;
122 
123 	mapping(address => uint) balances;
124     mapping(address => mapping(address => uint)) allowed;
125 	
126 	string public name;
127 	string public symbol;
128 	uint8 public decimals;
129 	uint256 public totalSupply;
130 
131     event Burn(address indexed from, uint256 value);
132 	
133 	// ------------------------------------------------------------------------
134 	// Constructor
135 	// ------------------------------------------------------------------------
136 	function NeoWorldCash() public {
137 		symbol = "NASH";
138 		name = "NEOWORLD CASH";
139 		decimals = 18;
140 		totalSupply = 100000000000 * 10**uint(decimals);
141 		balances[msg.sender] = totalSupply;
142 		emit Transfer(address(0), msg.sender, totalSupply, "");
143 	}
144 	
145 	
146 	// Function to access name of token .
147 	function name() public view returns (string) {
148 		return name;
149 	}
150 	// Function to access symbol of token .
151 	function symbol() public view returns (string) {
152 		return symbol;
153 	}
154 	// Function to access decimals of token .
155 	function decimals() public view returns (uint8) {
156 		return decimals;
157 	}
158 	// Function to access total supply of tokens .
159 	function totalSupply() public view returns (uint256) {
160 		return totalSupply;
161 	}
162 	
163 	// Function that is called when a user or another contract wants to transfer funds .
164 	function transfer(address _to, uint _value, bytes _data) public returns (bool) {
165 		if(isContract(_to)) {
166 			return transferToContract(_to, _value, _data);
167 		}
168 		else {
169 			return transferToAddress(_to, _value, _data);
170 		}
171 	}
172 	
173 	// Standard function transfer similar to ERC20 transfer with no _data .
174 	// Added due to backwards compatibility reasons .
175 	function transfer(address _to, uint _value) public returns (bool) {
176 		//standard function transfer similar to ERC20 transfer with no _data
177 		//added due to backwards compatibility reasons
178 		bytes memory empty;
179 		if(isContract(_to)) {
180 			return transferToContract(_to, _value, empty);
181 		}
182 		else {
183 			return transferToAddress(_to, _value, empty);
184 		}
185 	}
186 
187 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
188 	function isContract(address _addr) private view returns (bool) {
189 		uint length;
190 		assembly {
191 			//retrieve the size of the code on target address, this needs assembly
192 			length := extcodesize(_addr)
193 		}
194 		return (length>0);
195 	}
196 
197 	//function that is called when transaction target is an address
198 	function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
199 		if (balanceOf(msg.sender) < _value) revert();
200 		balances[msg.sender] = balanceOf(msg.sender).sub(_value);
201 		balances[_to] = balanceOf(_to).add(_value);
202 		emit Transfer(msg.sender, _to, _value);
203 		emit Transfer(msg.sender, _to, _value, _data);
204 		return true;
205 	}
206 	
207 	//function that is called when transaction target is a contract
208 	function transferToContract(address _to, uint _value, bytes _data) private returns (bool) {
209 	
210 		ContractReceiver receiver = ContractReceiver(_to);
211 		uint256 price;
212 		address owner;
213 		(price, owner) = receiver.doTransfer(msg.sender, bytesToUint(_data));
214 
215 		if (balanceOf(msg.sender) < price) revert();
216 		balances[msg.sender] = balanceOf(msg.sender).sub(price);
217 		balances[owner] = balanceOf(owner).add(price);
218 		receiver.tokenFallback(msg.sender, price, _data);
219 		emit Transfer(msg.sender, _to, _value);
220 		emit Transfer(msg.sender, _to, _value, _data);
221 		return true;
222 	}
223 
224 	function balanceOf(address _owner) public view returns (uint) {
225 		return balances[_owner];
226 	}  
227 
228 	function burn(uint256 _value) public returns (bool) {
229 		require (_value > 0); 
230 		require (balanceOf(msg.sender) >= _value);            // Check if the sender has enough
231 		balances[msg.sender] = balanceOf(msg.sender).sub(_value);                      // Subtract from the sender
232 		totalSupply = totalSupply.sub(_value);                                // Updates totalSupply
233 		emit Burn(msg.sender, _value);
234 		return true;
235 	}
236 
237 	function bytesToUint(bytes b) private pure returns (uint result) {
238 		uint i;
239 		result = 0;
240 		for (i = 0; i < b.length; i++) {
241 			uint c = uint(b[i]);
242 			if (c >= 48 && c <= 57) {
243 				result = result * 10 + (c - 48);
244 			}
245 		}
246 	}
247 
248     // ------------------------------------------------------------------------
249     // Token owner can approve for `spender` to transferFrom(...) `tokens`
250     // from the token owner's account
251     //
252     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
253     // recommends that there are no checks for the approval double-spend attack
254     // as this should be implemented in user interfaces 
255     // ------------------------------------------------------------------------
256     function approve(address spender, uint tokens) public returns (bool) {
257         allowed[msg.sender][spender] = tokens;
258         emit Approval(msg.sender, spender, tokens);
259         return true;
260     }
261 
262 
263     // ------------------------------------------------------------------------
264     // Transfer `tokens` from the `from` account to the `to` account
265     // 
266     // The calling account must already have sufficient tokens approve(...)-d
267     // for spending from the `from` account and
268     // - From account must have sufficient balance to transfer
269     // - Spender must have sufficient allowance to transfer
270     // - 0 value transfers are allowed
271     // ------------------------------------------------------------------------
272     function transferFrom(address from, address to, uint tokens) public returns (bool) {
273         balances[from] = balances[from].sub(tokens);
274         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
275         balances[to] = balances[to].add(tokens);
276         emit Transfer(from, to, tokens);
277         return true;
278     }
279 
280     // ------------------------------------------------------------------------
281     // Returns the amount of tokens approved by the owner that can be
282     // transferred to the spender's account
283     // ------------------------------------------------------------------------
284     function allowance(address tokenOwner, address spender) public constant returns (uint) {
285         return allowed[tokenOwner][spender];
286     }
287 
288     // ------------------------------------------------------------------------
289     // Don't accept ETH
290     // ------------------------------------------------------------------------
291     function () public payable {
292         revert();
293     }
294 
295     // ------------------------------------------------------------------------
296     // Owner can transfer out any accidentally sent ERC20 tokens
297     // ------------------------------------------------------------------------
298     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool) {
299         return ERC20Interface(tokenAddress).transfer(owner, tokens);
300     }	
301 }