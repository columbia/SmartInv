1 library SafeMath {
2 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3 		uint256 c = a * b;
4 		assert(a == 0 || c / a == b);
5 		return c;
6 	}
7 
8 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
9 		assert(b > 0); // Solidity automatically throws when dividing by 0
10 		uint256 c = a / b;
11 		assert(a == b * c + a % b); // There is no case in which this doesn't hold
12 		return c;
13 	}
14 
15 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16 		assert(b <= a);
17 		return a - b;
18 	}
19 
20 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
21 		uint256 c = a + b;
22 		assert(c >= a);
23 		return c;
24 	}
25 }
26 
27 contract Ownable {
28 	address public owner;
29 
30 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32 	modifier onlyOwner() {
33 		require(msg.sender == owner);
34 		_;
35 	}
36 	
37 	function transferOwnership(address newOwner) public onlyOwner {
38 		require(newOwner != address(0));
39 		OwnershipTransferred(owner, newOwner);
40 		owner = newOwner;
41 	}
42 }
43 
44 contract ERC20 {
45 	uint public totalSupply;
46 	function balanceOf(address _owner) public constant returns (uint balance);
47 	function transfer(address _to,uint _value) public returns (bool success);
48 	function transferFrom(address _from,address _to,uint _value) public returns (bool success);
49 	function approve(address _spender,uint _value) public returns (bool success);
50 	function allownce(address _owner,address _spender) public constant returns (uint remaining);
51 	event Transfer(address indexed _from,address indexed _to,uint _value);
52 	event Approval(address indexed _owner,address indexed _spender,uint _value);
53 }
54 
55 contract Option is ERC20,Ownable {
56 	using SafeMath for uint8;
57 	using SafeMath for uint256;
58 	
59 	event Burn(address indexed _from,uint256 _value);
60 	event Increase(address indexed _to, uint256 _value);
61 	event SetItemOption(address _to, uint256 _amount, uint256 _releaseTime);
62 	
63 	struct ItemAccount {
64 		address fromAccount;
65 		address toAccount;
66 	}
67 	struct ItemOption {
68 		uint256 releaseAmount;
69 		uint256 releaseTime;
70 	}
71 	struct listOption {
72 	    uint256 offset;
73 	    address fromAccount;
74 		address toAccount;
75 		uint256 releaseAmount;
76 		uint256 releaseTime;
77 	}
78 
79 	string public name;
80 	string public symbol;
81 	uint8 public decimals;
82 	uint256 public initial_supply;
83 	mapping (address => uint256) public balances;
84 	mapping (address => mapping (address => uint256)) allowed;
85 	uint256 private offset;
86 	mapping (address => uint256[]) fromOption;
87 	mapping (address => uint256[]) toOption;
88 	mapping (uint256 => ItemAccount) itemAccount;
89 	mapping (uint256 => ItemOption[]) mapOption;
90 	
91 	function Option (
92 		string Name,
93 		string Symbol,
94 		uint8 Decimals,
95 		uint256 initialSupply,
96 		address initOwner
97 	) public {
98 		require(initOwner != address(0));
99 		owner = initOwner;
100 		name = Name;
101 		symbol = Symbol;
102 		decimals = Decimals;
103 		initial_supply = initialSupply * (10 ** uint256(decimals));
104 		totalSupply = initial_supply;
105 		balances[initOwner] = totalSupply;
106 		offset = 0;
107 	}
108 	
109 	function itemBalance(address _to) public view returns (uint256 amount) {
110 		require(_to != address(0));
111 		amount = 0;
112 		uint256 nowtime = now;
113 		for(uint256 i = 0; i < toOption[_to].length; i++) {
114 		    for(uint256 j = 0; j < mapOption[toOption[_to][i]].length; j++) {
115 		        if(mapOption[toOption[_to][i]][j].releaseAmount > 0 && nowtime >= mapOption[toOption[_to][i]][j].releaseTime) {
116 		            amount = amount.add(mapOption[toOption[_to][i]][j].releaseAmount);
117 		        }
118 		    }
119 		}
120 		return amount;
121 	}
122 	
123 	function balanceOf(address _owner) public view returns (uint256 balance) {
124 		return balances[_owner].add(itemBalance(_owner));
125 	}
126 	
127 	function itemTransfer(address _to) public returns (bool success) {
128 		require(_to != address(0));
129 		uint256 nowtime = now;
130 		for(uint256 i = 0; i < toOption[_to].length; i++) {
131 		    for(uint256 j = 0; j < mapOption[toOption[_to][i]].length; j++) {
132 		        if(mapOption[toOption[_to][i]][j].releaseAmount > 0 && nowtime >= mapOption[toOption[_to][i]][j].releaseTime) {
133     		        balances[_to] = balances[_to].add(mapOption[toOption[_to][i]][j].releaseAmount);
134     		        mapOption[toOption[_to][i]][j].releaseAmount = 0;
135     		    }
136 		    }
137 		}
138 		return true;
139 	}
140 	
141 	function transfer(address _to,uint _value) public returns (bool success) {
142 		itemTransfer(_to);
143 		if(balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]){
144 			balances[msg.sender] = balances[msg.sender].sub(_value);
145 			balances[_to] = balances[_to].add(_value);
146 			Transfer(msg.sender,_to,_value);
147 			return true;
148 		} else {
149 			return false;
150 		}
151 	}
152 
153 	function transferFrom(address _from,address _to,uint _value) public returns (bool success) {
154 		itemTransfer(_from);
155 		if(balances[_from] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
156 			if(_from != msg.sender) {
157 				require(allowed[_from][msg.sender] > _value);
158 				allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159 			}
160 			balances[_from] = balances[_from].sub(_value);
161 			balances[_to] = balances[_to].add(_value);
162 			Transfer(_from,_to,_value);
163 			return true;
164 		} else {
165 			return false;
166 		}
167 	}
168 
169 	function approve(address _spender, uint _value) public returns (bool success) {
170 		allowed[msg.sender][_spender] = _value;
171 		Approval(msg.sender,_spender,_value);
172 		return true;
173 	}
174 	
175 	function allownce(address _owner,address _spender) public constant returns (uint remaining) {
176 		return allowed[_owner][_spender];
177 	}
178 	
179 	function burn(uint256 _value) public returns (bool success) {
180 		require(balances[msg.sender] >= _value);
181 		balances[msg.sender] = balances[msg.sender].sub(_value);
182 		totalSupply = totalSupply.sub(_value);
183 		Burn(msg.sender,_value);
184 		return true;
185 	}
186 
187 	function increase(uint256 _value) public onlyOwner returns (bool success) {
188 		if(balances[msg.sender] + _value > balances[msg.sender]) {
189 			totalSupply = totalSupply.add(_value);
190 			balances[msg.sender] = balances[msg.sender].add(_value);
191 			Increase(msg.sender, _value);
192 			return true;
193 		}
194 	}
195 	
196 	function setItemOptions(address _to, uint256 _amount, uint256 _startTime, uint8 _count) public returns (bool success) {
197 	    require(_to != address(0));
198 		require(_amount > 0);
199 		require(_count > 0);
200 		
201 		uint256 total = _amount.mul(_count);
202 		require(total > 0 && balances[msg.sender].sub(total) >= 0 && balances[_to].add(total) > balances[_to]);
203 		
204 		fromOption[msg.sender].push(offset);
205 		toOption[_to].push(offset);
206 		itemAccount[offset] = ItemAccount(msg.sender, _to);
207 		
208 		balances[msg.sender] = balances[msg.sender].sub(total);
209 		
210 		uint256 releaseTime = _startTime;
211 		for(uint8 i = 0; i < _count; i++) {
212 		    releaseTime = releaseTime.add(1 years);
213 		    mapOption[offset].push(ItemOption(_amount, releaseTime));
214 		}
215 		offset++;
216 		
217 		return true;
218 	}
219 	
220 	function fromListOptions() public view returns (uint256[] offset_s) {
221 	    uint256 nowtime = now;
222 	    uint8 k = 0;
223 	    for(uint256 i = 0; i < fromOption[msg.sender].length; i++) {
224 	        for(uint256 j = 0; j < mapOption[fromOption[msg.sender][i]].length; j++) {
225 	            if(mapOption[fromOption[msg.sender][i]][j].releaseAmount > 0 && mapOption[fromOption[msg.sender][i]][j].releaseTime > nowtime) {
226                     offset_s[k] = fromOption[msg.sender][i];
227                     k++;
228 	                break;
229 	            }
230 	        }
231 	    }
232 	}
233 	
234 	function toListOptions() public view returns (uint256[] offset_s) {
235 	    uint256 nowtime = now;
236 	    uint8 k = 0;
237 	    for(uint256 i = 0; i < toOption[msg.sender].length; i++) {
238 	        for(uint256 j = 0; j < mapOption[toOption[msg.sender][i]].length; j++) {
239 	            if(mapOption[toOption[msg.sender][i]][j].releaseAmount > 0 && mapOption[toOption[msg.sender][i]][j].releaseTime > nowtime) {
240 	                offset_s[k] = toOption[msg.sender][i];
241 	                k++;
242 	                break;
243 	            }
244 	        }
245 	    }
246 	}
247 	
248 	function getOption(uint256 _offset) public view returns (address fromAccount, address toAccount, uint8 count, uint256 totalAmount) {
249 	    require(_offset >= 0);
250 	    require(itemAccount[_offset].fromAccount == msg.sender || itemAccount[_offset].toAccount == msg.sender);
251 	    
252 	    fromAccount = itemAccount[_offset].fromAccount;
253 	    toAccount = itemAccount[_offset].toAccount;
254 	    count = 0;
255 	    totalAmount = 0;
256 	    uint256 nowtime = now;
257 	    for(uint256 i = 0; i < mapOption[_offset].length; i++) {
258 	        if(mapOption[_offset][i].releaseAmount > 0 && mapOption[_offset][i].releaseTime > nowtime && totalAmount.add(mapOption[_offset][i].releaseAmount) > totalAmount) {
259 	            count++;
260 	            totalAmount = totalAmount.add(mapOption[_offset][i].releaseAmount);
261 	        }
262 	    }
263 	}
264 	
265 	function getOptionOnce(uint256 _offset, uint8 _id) public view returns (address fromAccount, address toAccount, uint256 releaseAmount, uint256 releaseTime) {
266 	    require(_offset >= 0);
267 	    require(_id >= 0);
268 	    require(itemAccount[_offset].fromAccount == msg.sender || itemAccount[_offset].toAccount == msg.sender);
269 	    require(mapOption[_offset][_id].releaseAmount > 0);
270 	    
271 	    fromAccount = itemAccount[_offset].fromAccount;
272 	    toAccount = itemAccount[_offset].toAccount;
273 	    releaseAmount = mapOption[_offset][_id].releaseAmount;
274 	    releaseTime = mapOption[_offset][_id].releaseTime;
275 	}
276 	
277 	function burnOptions(address _to, uint256 _offset) public returns (bool success) {
278 	    require(_to != address(0));
279 	    require(_offset >= 0);
280 	    uint256 nowtime = now;
281 	    for(uint256 i = 0; i < toOption[_to].length; i++) {
282 	        if(toOption[_to][i] == _offset && itemAccount[toOption[_to][i]].fromAccount == msg.sender) {
283 	            for(uint256 j = 0; j < mapOption[_offset].length; j++) {
284 	                if(mapOption[_offset][j].releaseAmount > 0 && mapOption[_offset][j].releaseTime > nowtime && balances[msg.sender].add(mapOption[_offset][j].releaseAmount) > balances[msg.sender]) {
285 	                    balances[msg.sender] = balances[msg.sender].add(mapOption[_offset][j].releaseAmount);
286 	                    mapOption[_offset][j].releaseAmount = 0;
287 	                }
288 	            }
289 	            return true;
290 	        }
291 	    }
292 	    
293 	    return false;
294 	}
295 }