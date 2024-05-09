1 pragma solidity ^0.5.13;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18         return c;
19     }
20 
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b, "SafeMath: multiplication overflow");
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         return div(a, b, "SafeMath: division by zero");
33     }
34 
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b > 0, errorMessage);
37         uint256 c = a / b;
38         return c;
39     }
40 
41     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
42         return mod(a, b, "SafeMath: modulo by zero");
43     }
44 
45     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b != 0, errorMessage);
47         return a % b;
48     }
49 }
50 
51 
52 pragma solidity ^0.5.13;
53 
54 interface Callable {
55 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
56 }
57 
58 contract BerserkToken {
59 
60 	uint256 constant private FLOAT_SCALAR = 2**64;
61 	uint256 constant private INITIAL_SUPPLY = 10000 ether; 
62 	uint256 public BURN_RATE = 5;
63 	
64 	address public burnPoolAddress= address(0x0);
65 	uint256 public burnPoolAmount=0;
66 	uint256 public burnPoolAmountPrevious=0;
67 	bool public berserkSwapBool= false;
68 
69 	string constant public name = "Berserk";
70 	string constant public symbol = "BER";
71 	uint8 constant public decimals = 18;
72 	
73 	mapping (address => bool) public minters;
74 	address public governance;
75 	address public burnOwner;
76 	address public berserkSwapOwner;
77 	address public berserkSwapAddress = address(0x0);
78 	
79     mapping(address => bool) public isAdmin;
80 
81 	struct User {
82 		bool whitelisted;
83 		uint256 balance;
84 		mapping(address => uint256) allowance;
85 	}
86 
87 	struct Info {
88 		uint256 totalSupply;
89 		uint256 burnedSupply;
90 		mapping(address => User) users;
91 	}
92 	Info private info;
93 
94 	event Transfer(address indexed from, address indexed to, uint256 tokens);
95 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
96 	event Burn(uint256 tokens);
97 	event Mint(uint256 amount);
98 
99 	constructor() public {
100 		info.totalSupply = INITIAL_SUPPLY;
101 		info.users[msg.sender].balance = INITIAL_SUPPLY;
102 		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
103 		info.burnedSupply = 0;
104         governance = msg.sender;
105         burnOwner= msg.sender;
106         isAdmin[msg.sender]=true;
107         berserkSwapOwner = msg.sender;
108 	}
109 
110 	function burn(uint256 _tokens) external {
111 		require(balanceOf(msg.sender) >= _tokens);
112 		info.users[msg.sender].balance -= _tokens;
113 		uint256 _burnedAmount = _tokens;
114 		info.totalSupply -= _burnedAmount;
115 		emit Transfer(msg.sender, address(0x0), _burnedAmount);
116 		info.burnedSupply= info.burnedSupply + _tokens;
117 		emit Burn(_burnedAmount);
118 	}
119     
120 	function transfer(address _to, uint256 _tokens) external returns (bool) {
121 		_transfer(msg.sender, _to, _tokens);
122 		return true;
123 	}
124 
125 	function approve(address _spender, uint256 _tokens) external returns (bool) {
126 		info.users[msg.sender].allowance[_spender] = _tokens;
127 		emit Approval(msg.sender, _spender, _tokens);
128 		return true;
129 	}
130 
131 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
132 		require(info.users[_from].allowance[msg.sender] >= _tokens);
133 		info.users[_from].allowance[msg.sender] -= _tokens;
134 		_transfer(_from, _to, _tokens);
135 		return true;
136 	}
137 	
138 	 function setGovernance(address _governance) public {
139         require(msg.sender == governance, "!governance");
140         governance = _governance;
141     }
142 	
143 	 function addMinter(address _minter) public {
144         require(msg.sender == governance, "!governance");
145         minters[_minter] = true;
146     }
147 
148     function removeMinter(address _minter) public {
149         require(msg.sender == governance, "!governance");
150         minters[_minter] = false;
151     }
152     
153     function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
154 		require(_receivers.length == _amounts.length);
155 		for (uint256 i = 0; i < _receivers.length; i++) {
156 			_transfer(msg.sender, _receivers[i], _amounts[i]);
157 		}
158 	}
159     
160     function mint(address account, uint256 amount) public {
161         require(minters[msg.sender], "!minter");
162         _mint(account, amount);
163     }
164     
165     function _mint(address account, uint amount) internal {
166         require(account != address(0), "ERC20: mint to the zero address");
167         info.totalSupply = info.totalSupply+amount;
168         info.users[msg.sender].balance = info.users[msg.sender].balance+amount;
169         emit Transfer(address(0), account, amount);
170     }
171     
172     function renounceBurnOwnership () external {
173         require (msg.sender == burnOwner);
174         burnOwner= address(0x0);
175     }
176     
177     function setBurnAmount(uint256 _burnAmount) public{
178         require(msg.sender == burnOwner, "Not authorized!");
179         BURN_RATE= _burnAmount;
180     }
181     
182     function setBurnPoolAddress(address _burnPoolAddress) public{
183         require(msg.sender == burnOwner, "Not authorized!");
184         burnPoolAddress= _burnPoolAddress;
185     }
186 
187 	function totalSupply() public view returns (uint256) {
188 		return info.totalSupply;
189 	}
190 	
191 	function burnedSupply() public view returns (uint256){
192 	    return info.burnedSupply;
193 	}
194 	
195 	function resetBurnAmount() public {
196 	    require(isAdmin[msg.sender]==true);
197 	    burnPoolAmountPrevious= burnPoolAmount;
198 	    burnPoolAmount= 0;
199 	}
200 	
201 	function getBurnAmount() public view returns (uint256){
202 	    return burnPoolAmount;
203 	}
204 	
205 	function getBurnAmountPrevious() public view returns (uint256){
206 	    return burnPoolAmountPrevious;
207 	}
208     
209     function getBurnPoolAddress() public view returns (address){
210         return burnPoolAddress;
211     }
212 	
213 	function setAdminStatus(address _admin) external {
214 	    require (msg.sender == governance);
215         isAdmin[_admin] = true;
216     }
217     
218     function setBerserkSwapAddress (address _berserkSwapAddress) external {
219         require (msg.sender == berserkSwapOwner);
220         berserkSwapAddress = _berserkSwapAddress;
221     }
222     
223     function setBerserkSwapBool () external {
224         require (msg.sender == berserkSwapOwner);
225         berserkSwapBool = true;
226     }
227 
228 	function balanceOf(address _user) public view returns (uint256) {
229 		return info.users[_user].balance ;
230 	}
231 
232 	function allowance(address _user, address _spender) public view returns (uint256) {
233 		return info.users[_user].allowance[_spender];
234 	}
235 
236 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 userBalance, uint256 totalBurnedSupply) {
237 		return (totalSupply(), balanceOf(_user), burnedSupply());
238 	}
239 	
240 	function allInfoBurned() public view returns (uint256, uint256){
241 	    return (burnPoolAmount, burnPoolAmountPrevious);
242 	}
243 
244 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
245 		require(balanceOf(_from) >= _tokens);
246 		info.users[_from].balance -= _tokens;
247 		uint256 _burnedAmount = _tokens * BURN_RATE;
248 		_burnedAmount= _burnedAmount / 100;
249 		uint256 _transferred = _tokens - _burnedAmount;
250 
251         if (berserkSwapBool == true) {
252             if (_from == berserkSwapAddress || _to == berserkSwapAddress)
253                 {
254                 _burnedAmount = _tokens * BURN_RATE ;
255                 _burnedAmount= _burnedAmount / 200;
256                 _transferred = _tokens - _burnedAmount;
257                 
258                 info.users[_to].balance += _transferred;
259     	    	emit Transfer(_from, _to, _transferred);
260     			_burnedAmount /= 2;
261     			
262     			emit Transfer(_from, burnPoolAddress, _burnedAmount);
263     			burnPoolAmount= burnPoolAmount+ _burnedAmount;
264     			
265     			info.users[burnPoolAddress].balance =  info.users[burnPoolAddress].balance+ _burnedAmount;
266     			info.totalSupply= info.totalSupply - _burnedAmount;
267     			
268     			emit Transfer(_from, address(0x0), _burnedAmount);
269     			info.burnedSupply= info.burnedSupply + _burnedAmount;
270     			emit Burn(_burnedAmount);
271                 }
272                 
273             else {
274                 info.users[_to].balance += _transferred;
275     	    	emit Transfer(_from, _to, _transferred);
276     			_burnedAmount /= 2;
277     			emit Transfer(_from, burnPoolAddress, _burnedAmount);
278     			burnPoolAmount= burnPoolAmount+ _burnedAmount;
279     			
280     			info.users[burnPoolAddress].balance =  info.users[burnPoolAddress].balance+ _burnedAmount;
281     			info.totalSupply= info.totalSupply - _burnedAmount;
282     			
283     			emit Transfer(_from, address(0x0), _burnedAmount);
284     			info.burnedSupply= info.burnedSupply + _burnedAmount;
285     			emit Burn(_burnedAmount);
286             }
287         }
288 
289         else {
290     		if (burnPoolAddress != address(0x0)) {
291     	    	info.users[_to].balance = info.users[_to].balance + _transferred;
292     	    	emit Transfer(_from, _to, _transferred);
293     			_burnedAmount /= 2;
294     			emit Transfer(_from, burnPoolAddress, _burnedAmount);
295     			burnPoolAmount= burnPoolAmount+ _burnedAmount;
296     			
297     			info.users[burnPoolAddress].balance =  info.users[burnPoolAddress].balance+ _burnedAmount;
298     			info.totalSupply= info.totalSupply - _burnedAmount;
299     			
300     			emit Transfer(_from, address(0x0), _burnedAmount);
301     			info.burnedSupply= info.burnedSupply + _burnedAmount;
302     			emit Burn(_burnedAmount);
303     		}
304     		
305     		else {
306     		    _transferred= _tokens;
307     		    info.users[_to].balance = info.users[_to].balance + _tokens;
308     		    emit Transfer(_from, _to, _tokens);
309     		}
310         }
311 		
312 		return _transferred;
313 	}
314 
315 	 modifier onlyAdmin {
316         require(isAdmin[msg.sender], "OnlyAdmin methods called by non-admin.");
317         _;
318     }
319 }