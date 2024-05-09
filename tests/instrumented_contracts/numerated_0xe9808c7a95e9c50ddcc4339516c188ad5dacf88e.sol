1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74   address private _owner;
75 
76   event OwnershipTransferred(
77     address indexed previousOwner,
78     address indexed newOwner
79   );
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   constructor() internal {
86     _owner = msg.sender;
87     emit OwnershipTransferred(address(0), _owner);
88   }
89 
90   /**
91    * @return the address of the owner.
92    */
93   function owner() public view returns(address) {
94     return _owner;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(isOwner());
102     _;
103   }
104 
105   /**
106    * @return true if `msg.sender` is the owner of the contract.
107    */
108   function isOwner() public view returns(bool) {
109     return msg.sender == _owner;
110   }
111 
112   /**
113    * @dev Allows the current owner to relinquish control of the contract.
114    * @notice Renouncing to ownership will leave the contract without an owner.
115    * It will not be possible to call the functions with the `onlyOwner`
116    * modifier anymore.
117    */
118   function renounceOwnership() public onlyOwner {
119     emit OwnershipTransferred(_owner, address(0));
120     _owner = address(0);
121   }
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address newOwner) public onlyOwner {
128     _transferOwnership(newOwner);
129   }
130 
131   /**
132    * @dev Transfers control of the contract to a newOwner.
133    * @param newOwner The address to transfer ownership to.
134    */
135   function _transferOwnership(address newOwner) internal {
136     require(newOwner != address(0));
137     emit OwnershipTransferred(_owner, newOwner);
138     _owner = newOwner;
139   }
140 }
141 
142 
143 interface IJoycoinToken  {
144 	function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
145 	function approve(address _spender, uint256 _value) external returns (bool);
146 	function allowance(address _owner, address _spender) external view returns (uint256);
147 	function balanceOf(address who) external view returns (uint256);
148 	function transfer(address to, uint256 value) external returns (bool);
149 	function burnUnsold() external returns (bool);
150 }
151 
152 
153 contract JoycoinSale is Ownable {
154 	using SafeMath for uint256;
155 
156 	event NewRound(uint256 round, uint256 at);
157 	event Finish(uint256 at);
158 
159 	uint256 constant round3Duration = 90 days;
160 	uint256 constant softCap = 140000000 * 10 ** 8; // $ 2.100.000
161 
162 	IJoycoinToken public token;
163 
164 	uint256 public round; // 1, 2 or 3. Rounds 1 and 3 are whitelisted. 
165 	uint256 public round3StartAt;
166 	uint256 public tokensSold;
167 	
168 	bool isFinished;
169 	uint256 finishedAt;
170 
171 	mapping(address => bool) public whiteListedWallets;
172 
173 	constructor(address _token) public {
174 		require(_token != address(0));
175 		token = IJoycoinToken(_token);
176 		round = 1;
177 		emit NewRound(1, now);
178 	}
179 
180 	function addWalletToWhitelist(address _wallet) public onlyOwner returns (bool) {
181 		whiteListedWallets[_wallet] = true;
182 		return true;
183 	}
184 
185 	function removeWalletFromWhitelist(address _wallet) public onlyOwner returns (bool) {
186 		whiteListedWallets[_wallet] = false;
187 		return true;
188 	}
189 
190 	function addWalletsToWhitelist(address[] _wallets) public onlyOwner returns (bool) {
191 		uint256 i = 0;
192 		while (i < _wallets.length) {
193 			whiteListedWallets[_wallets[i]] = true;
194 			i += 1;
195 		}
196 		return true;
197 	}
198 
199 	function removeWalletsFromWhitelist(address[] _wallets) public onlyOwner returns (bool) {
200 		uint256 i = 0;
201 		while (i < _wallets.length) {
202 			whiteListedWallets[_wallets[i]] = false;
203 			i += 1;
204 		}
205 		return true;
206 	}
207 
208 	function finishSale() public onlyOwner returns (bool) {
209 		require ( (round3StartAt > 0 && now > (round3StartAt + round3Duration)) || token.balanceOf(address(this)) == 0);
210 		require (!isFinished);
211 		require (tokensSold >= softCap);
212 		isFinished = true;
213 		finishedAt = now;
214 		if (token.balanceOf(address(this)) > 0) {
215 			token.burnUnsold();
216 		}
217 		emit Finish(now);
218 		return true;
219 	}
220 
221 	function getEndDate() public view returns (uint256) {
222 		return finishedAt;
223 
224 	}
225 
226 	function setRound(uint256 _round) public onlyOwner returns (bool) {
227 		require (_round == 2 || _round == 3);
228 		require (_round == round + 1);
229 
230 		round = _round;
231 		if (_round == 3) {
232 			round3StartAt = now;
233 		}
234 		emit NewRound(_round, now);
235 		return true;
236 	}
237 
238 	function sendTokens(address[] _recipients, uint256[] _values) onlyOwner public returns (bool) {
239 	 	require(_recipients.length == _values.length);
240 	 	require(!isFinished);
241 	 	uint256 i = 0;
242 	 	while (i < _recipients.length) {
243 	 		if (round == 1 || round == 3) {
244 	 			require(whiteListedWallets[_recipients[i]]);
245 	 		}
246 
247 	 		if (_values[i] > 0) {
248 	 			token.transfer(_recipients[i], _values[i]);
249 	 			tokensSold = tokensSold.add(_values[i]);
250 	 		}
251 
252 	 		i += 1;
253 	 	}
254 	 	return true;
255 	}
256 
257 	function sendBonusTokens(address[] _recipients, uint256[] _values) onlyOwner public returns (bool) {
258 	 	require(_recipients.length == _values.length);
259 	 	require(!isFinished);
260 	 	uint256 i = 0;
261 	 	while (i < _recipients.length) {
262 	 		if (round == 1 || round == 3) {
263 	 			require(whiteListedWallets[_recipients[i]]);
264 	 		}
265 
266 	 		if (_values[i] > 0) {
267 	 			token.transfer(_recipients[i], _values[i]);
268 	 		}
269 
270 	 		i += 1;
271 	 	}
272 	 	return true;
273 	}
274 }