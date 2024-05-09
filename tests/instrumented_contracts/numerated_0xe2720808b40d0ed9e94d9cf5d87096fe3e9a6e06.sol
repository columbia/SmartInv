1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public constant returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract Ownable {
47 	address public owner;
48 
49 	constructor() public{
50 		owner = msg.sender;
51 	}
52 
53 	modifier onlyOwner() {
54 		require(msg.sender == owner);
55 		_;
56 	}
57 }
58 
59 
60 contract Pausable is Ownable {
61 	event Pause();
62 	event Unpause();
63 
64 	bool public paused = false;
65 
66 	modifier whenNotPaused() {
67 		require(!paused);
68 		_;
69 	}
70 
71 	modifier whenPaused() {
72 		require(paused);
73 		_;
74 	}
75 
76 	function pause() onlyOwner whenNotPaused public {
77 		paused = true;
78 		emit Pause();
79 	}
80 
81 	function unpause() onlyOwner whenPaused public {
82 		paused = false;
83 		emit Unpause();
84 	}
85 }
86 
87 contract CARLO is ERC20,Pausable {
88     
89     using SafeMath for uint256;
90 
91     mapping (address => uint256) balances;
92     mapping (address => mapping (address => uint256)) allowed;
93     mapping (address => bool) public blacklist;
94 
95     string public constant name = "CARLO";
96     string public constant symbol = "CARLO";
97     uint8 public constant decimals = 18; 
98 
99 	uint256 public foundationDistributed = 100000000e18;
100 	uint256 public marketDistributed = 360000000e18;
101 	uint256 public devDistributed = 240000000e18;
102 	uint256 public labDistributed = 300000000e18;
103 	
104 	uint256 public devLockFirstDistributed = 300000000e18;
105 	uint256 public devLockSecondDistributed = 300000000e18;
106 	uint256 public devLockThirdDistributed = 400000000e18; 
107 
108     uint256 public totalRemaining; 
109 	
110 	address private devLockFirstBeneficiary = 0x9E01714A3700168E82b898618C6181Eb6abF7cff;
111 	address private devLockSecondBeneficiary = 0x20986b25C551f7944cEbF500F6C950229865FAae;
112 	address private devLockThirdBeneficiary = 0x3cD928a432c9666be26fE82480A8a77dA33b2B42;
113 	address private foundationBeneficiary = 0xCCF02CC2fF5e896fF3D7D6aDC59bAbe514EBb64C;
114 	address private marketBeneficiary = 0xC9b66dC5A27d94F9ab804dF98437945700b93555;
115 	address private devBeneficiary = 0xf89fdcca528e1E82da8dee643b38e693AebB6F45;
116 	address private labBeneficiary = 0x239d10c737E26cB85746426313aCF167b564eDB8;
117 
118 	uint256 private _releaseTimeFirst = now + 365 days; 
119 	uint256 private _releaseTimeSecond = now + 365 days + 365 days; 
120 	uint256 private _releaseTimeThird = now + 365 days + 365 days + 365 days; 	
121 	
122 	bool public devLockFirstReleased = true;
123 	bool public devLockSecondReleased = true;
124 	bool public devLockThirdReleased = true;
125     
126     event Burn(address indexed burner, uint256 value);
127 	event OwnershipTransferred(address indexed perviousOwner, address indexed newOwner);
128     
129     constructor() public {  
130 		owner = msg.sender;
131 		totalSupply = 2000000000e18;
132 		totalRemaining = totalSupply.sub(foundationDistributed).sub(marketDistributed).sub(labDistributed).sub(devDistributed);
133         balances[owner] = totalRemaining;
134 		balances[foundationBeneficiary] = foundationDistributed;
135 		balances[marketBeneficiary] = marketDistributed;
136 		balances[labBeneficiary] = labDistributed;
137 		balances[devBeneficiary] = devDistributed;
138     }
139     
140     function transferOwnership(address newOwner) onlyOwner public {
141 		require(newOwner != address(0));
142 		emit OwnershipTransferred(owner, newOwner);
143 		balances[owner] = balances[owner].sub(totalRemaining);
144 		balances[newOwner] = balances[newOwner].add(totalRemaining);
145 		emit Transfer(owner, newOwner, totalRemaining);
146 		owner = newOwner;		
147     }
148 
149     function balanceOf(address _owner) constant public returns (uint256) {
150         return balances[_owner];
151     }
152 
153     modifier onlyPayloadSize(uint size) {
154         require(msg.data.length >= size + 4);  
155         _;
156     }
157 	
158 	function isPayLockFirst() public view returns (bool) { 
159 		if (now >= _releaseTimeFirst) {
160 			return true;
161 		} else {
162 			return false;
163 		}
164 	}
165 	function isPayLockSecond() public view returns (bool) { 
166 		if (now >= _releaseTimeSecond) {
167 			return true;
168 		} else {
169 			return false;
170 		}
171 	}
172 	function isPayLockThird() public view returns (bool) { 		
173 		if (now >= _releaseTimeThird) {
174 			return true;
175 		} else {
176 			return false;
177 		}
178 	}
179 	function releaseFirst()internal {
180 		balances[owner] = balances[owner].sub(devLockFirstDistributed);
181 		balances[devLockFirstBeneficiary] = balances[devLockFirstBeneficiary].add(devLockFirstDistributed);
182 		emit Transfer(owner, devLockFirstBeneficiary, devLockFirstDistributed);
183 		totalRemaining = totalRemaining.sub(devLockFirstDistributed);
184 		devLockFirstReleased = false;
185 	}
186 	function releaseSecond() internal {
187 		balances[owner] = balances[owner].sub(devLockSecondDistributed);
188 		balances[devLockSecondBeneficiary] = balances[devLockSecondBeneficiary].add(devLockSecondDistributed);
189 		emit Transfer(owner, devLockSecondBeneficiary, devLockSecondDistributed);
190 		totalRemaining = totalRemaining.sub(devLockSecondDistributed);
191 		devLockSecondReleased = false;
192 	}
193 	function releaseThird() internal {
194 		balances[owner] = balances[owner].sub(devLockThirdDistributed);
195 		balances[devLockThirdBeneficiary] = balances[devLockThirdBeneficiary].add(devLockThirdDistributed);
196 		emit Transfer(owner, devLockThirdBeneficiary, devLockThirdDistributed);
197 		totalRemaining = totalRemaining.sub(devLockThirdDistributed);
198 		devLockThirdReleased = false;
199 	}
200 	
201 	function release(address from) internal {
202 		if (from == devLockFirstBeneficiary) {
203 			if (isPayLockFirst()) {
204 				if (devLockFirstReleased) {
205 					releaseFirst();
206 				}
207 			}
208 		}
209 		if (from == devLockSecondBeneficiary) {
210 			if (isPayLockSecond()) {
211 				if (devLockSecondReleased) {
212 					releaseSecond();
213 				}
214 			}
215 		}
216 		if (from == devLockThirdBeneficiary) {
217 			if (isPayLockThird()) {
218 				if (devLockThirdReleased) {
219 					releaseThird();
220 				}
221 			}
222 		}
223 		
224 	}
225     
226     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public whenNotPaused returns (bool success) {
227         require(blacklist[msg.sender] == false);
228 		require(blacklist[_to] == false);
229 		require(_to != address(0));
230 		if (msg.sender == owner) {
231 			require(balances[msg.sender] >= (totalRemaining.add(_amount)));
232 		}
233 		release(msg.sender);
234         require(_amount <= balances[msg.sender]);		
235         balances[msg.sender] = balances[msg.sender].sub(_amount);
236         balances[_to] = balances[_to].add(_amount);		
237         emit Transfer(msg.sender, _to, _amount);
238         return true;
239     }
240     
241     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public whenNotPaused returns (bool success) {
242         require(blacklist[msg.sender] == false);
243 		require(blacklist[_to] == false);
244 		require(blacklist[_from] == false);
245 		require(_to != address(0));
246 		if (_from == owner) {
247 			require(balances[_from] >= (totalRemaining.add(_amount)));
248 		}
249 		release(_from);
250         require(_amount <= balances[_from]);
251         require(_amount <= allowed[_from][msg.sender]);		
252         balances[_from] = balances[_from].sub(_amount);
253         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
254         balances[_to] = balances[_to].add(_amount);
255         emit Transfer(_from, _to, _amount);
256         return true;
257     }
258 
259     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
260 		require(_value == 0 || allowed[msg.sender][_spender] == 0);
261         allowed[msg.sender][_spender] = _value;
262         emit Approval(msg.sender, _spender, _value);
263         return true;
264     }
265 	
266 	function addOrRemoveBlackList(address _addr, bool action) onlyOwner public returns (bool success) {
267 		require(_addr != address(0));
268 		blacklist[_addr] = action;
269 		return true;
270 	}
271     
272     function allowance(address _owner, address _spender) constant public returns (uint256) {
273         return allowed[_owner][_spender];
274     }
275     
276     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
277         ForeignToken t = ForeignToken(tokenAddress);
278         uint bal = t.balanceOf(who);
279         return bal;
280     }
281     
282     function withdraw() onlyOwner public {
283         uint256 etherBalance = address(this).balance;
284         owner.transfer(etherBalance);
285     }
286     
287     function burn(uint256 _value) onlyOwner public {
288 		require(balances[msg.sender] >= totalRemaining.add(_value));
289         address burner = msg.sender;
290         balances[burner] = balances[burner].sub(_value);
291         totalSupply = totalSupply.sub(_value);
292         emit Burn(burner, _value);
293     }
294     
295     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
296         ForeignToken token = ForeignToken(_tokenContract);
297         uint256 amount = token.balanceOf(address(this));
298         return token.transfer(owner, amount);
299     }
300 }