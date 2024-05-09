1 pragma solidity ^0.4.23;
2 
3 // SafeMath
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 
32 // Ownable
33 contract Ownable {
34     address public owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     constructor() public {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     function transferOwnership(address newOwner) onlyOwner public {
48         require(newOwner != address(0));
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51     }
52 }
53 
54 
55 // ERC223
56 contract ERC223 {
57     uint public totalSupply;
58 
59     function balanceOf(address who) public view returns (uint);
60     function totalSupply() public view returns (uint256 _supply);
61     function transfer(address to, uint value) public returns (bool ok);
62     function transfer(address to, uint value, bytes data) public returns (bool ok);
63     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
64     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
65 
66     function name() public view returns (string _name);
67     function symbol() public view returns (string _symbol);
68     function decimals() public view returns (uint8 _decimals);
69 
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
71     function approve(address _spender, uint256 _value) public returns (bool success);
72     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint _value);
75 }
76 
77 
78  // ContractReceiver
79  contract ContractReceiver {
80 
81     struct TKN {
82         address sender;
83         uint value;
84         bytes data;
85         bytes4 sig;
86     }
87 
88     function tokenFallback(address _from, uint _value, bytes _data) public pure {
89         TKN memory tkn;
90         tkn.sender = _from;
91         tkn.value = _value;
92         tkn.data = _data;
93         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
94         tkn.sig = bytes4(u);
95 
96         /*
97          * tkn variable is analogue of msg variable of Ether transaction
98          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
99          * tkn.value the number of tokens that were sent   (analogue of msg.value)
100          * tkn.data is data of token transaction   (analogue of msg.data)
101          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
102          */
103     }
104 }
105 
106 
107 // SOCCERCOIN
108 contract SOCCERCOIN is ERC223, Ownable {
109     using SafeMath for uint256;
110 
111     string public name = "SOCCER COIN";
112     string public symbol = "SOCCER";
113     uint8 public decimals = 16;
114     uint256 public totalSupply;
115 
116     uint public chainStartTime; //chain start time
117     uint public chainStartBlockNumber; //chain start block number
118     uint public stakeStartTime; //stake start time
119     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
120     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
121 
122     uint256 public maxTotalSupply = 45e9 * 1e16;
123     uint256 public initialTotalSupply = 20e9 * 1e16;
124 
125     struct transferInStruct{
126       uint256 amount;
127       uint64 time;
128     }
129 
130     address public admin = 0x166A52e2f21b36522Bfcf6e940AD17E2649424b0;
131     address public presale = 0x652b861c0021D854f1A1240d4Ff468f4EE14B89E;
132     address public develop = 0x6C0689664E1c9f228EEb87088c4F3eA6244d6Cc3;
133     address public pr = 0xFB432Ac2F5fb98312264df7965E2Ca062C856150;
134     address public manage = 0x282117F44Be63192Fc05C6Ccce748E3618aceCD8;
135 
136     mapping(address => uint256) public balanceOf;
137     mapping(address => mapping (address => uint256)) public allowance;
138     mapping(address => transferInStruct[]) public transferIns;
139 
140     event Burn(address indexed burner, uint256 value);
141     event PosMint(address indexed _address, uint _reward);
142 
143     constructor () public {
144         owner = admin;
145         totalSupply = initialTotalSupply;
146         balanceOf[owner] = totalSupply;
147 
148         chainStartTime = now;
149         chainStartBlockNumber = block.number;
150     }
151 
152     function name() public view returns (string _name) {
153         return name;
154     }
155 
156     function symbol() public view returns (string _symbol) {
157         return symbol;
158     }
159 
160     function decimals() public view returns (uint8 _decimals) {
161         return decimals;
162     }
163 
164     function totalSupply() public view returns (uint256 _totalSupply) {
165         return totalSupply;
166     }
167 
168     function balanceOf(address _owner) public view returns (uint256 balance) {
169         return balanceOf[_owner];
170     }
171 
172     // transfer
173     function transfer(address _to, uint _value) public returns (bool success) {
174         require(_value > 0);
175 
176         bytes memory empty;
177         if (isContract(_to)) {
178             return transferToContract(_to, _value, empty);
179         } else {
180             return transferToAddress(_to, _value, empty);
181         }
182     }
183 
184     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
185         require(_value > 0);
186 
187         if (isContract(_to)) {
188             return transferToContract(_to, _value, _data);
189         } else {
190             return transferToAddress(_to, _value, _data);
191         }
192     }
193 
194     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
195         require(_value > 0);
196 
197         if (isContract(_to)) {
198             require(balanceOf[msg.sender] >= _value);
199             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
200             balanceOf[_to] = balanceOf[_to].add(_value);
201             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
202             emit Transfer(msg.sender, _to, _value, _data);
203             emit Transfer(msg.sender, _to, _value);
204 
205             if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
206             uint64 _now = uint64(now);
207             transferIns[msg.sender].push(transferInStruct(uint256(balanceOf[msg.sender]),_now));
208             transferIns[_to].push(transferInStruct(uint256(_value),_now));
209 
210             return true;
211         } else {
212             return transferToAddress(_to, _value, _data);
213         }
214     }
215 
216     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
217     function isContract(address _addr) private view returns (bool is_contract) {
218         uint length;
219         assembly {
220             //retrieve the size of the code on target address, this needs assembly
221             length := extcodesize(_addr)
222         }
223         return (length > 0);
224     }
225 
226     // function that is called when transaction target is an address
227     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
228         require(balanceOf[msg.sender] >= _value);
229         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
230         balanceOf[_to] = balanceOf[_to].add(_value);
231         emit Transfer(msg.sender, _to, _value, _data);
232         emit Transfer(msg.sender, _to, _value);
233 
234         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
235         uint64 _now = uint64(now);
236         transferIns[msg.sender].push(transferInStruct(uint256(balanceOf[msg.sender]),_now));
237         transferIns[_to].push(transferInStruct(uint256(_value),_now));
238 
239         return true;
240     }
241 
242     // function that is called when transaction target is a contract
243     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
244         require(balanceOf[msg.sender] >= _value);
245         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
246         balanceOf[_to] = balanceOf[_to].add(_value);
247         ContractReceiver receiver = ContractReceiver(_to);
248         receiver.tokenFallback(msg.sender, _value, _data);
249         emit Transfer(msg.sender, _to, _value, _data);
250         emit Transfer(msg.sender, _to, _value);
251 
252         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
253         uint64 _now = uint64(now);
254         transferIns[msg.sender].push(transferInStruct(uint256(balanceOf[msg.sender]),_now));
255         transferIns[_to].push(transferInStruct(uint256(_value),_now));
256 
257         return true;
258     }
259 
260     // transferFrom
261     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
262         require(_to != address(0)
263                 && _value > 0
264                 && balanceOf[_from] >= _value
265                 && allowance[_from][msg.sender] >= _value);
266 
267         balanceOf[_from] = balanceOf[_from].sub(_value);
268         balanceOf[_to] = balanceOf[_to].add(_value);
269         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
270         emit Transfer(_from, _to, _value);
271 
272         if(transferIns[_from].length > 0) delete transferIns[_from];
273         uint64 _now = uint64(now);
274         transferIns[_from].push(transferInStruct(uint256(balanceOf[_from]),_now));
275         transferIns[_to].push(transferInStruct(uint256(_value),_now));
276 
277         return true;
278     }
279 
280     // approve
281     function approve(address _spender, uint256 _value) public returns (bool success) {
282         allowance[msg.sender][_spender] = _value;
283         emit Approval(msg.sender, _spender, _value);
284         return true;
285     }
286 
287     // allowance
288     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
289         return allowance[_owner][_spender];
290     }
291 
292     // airdrop
293     function airdrop(address[] addresses, uint[] amounts) public returns (bool) {
294         require(addresses.length > 0
295                 && addresses.length == amounts.length);
296 
297         uint256 totalAmount = 0;
298 
299         for(uint j = 0; j < addresses.length; j++){
300             require(amounts[j] > 0
301                     && addresses[j] != 0x0);
302 
303             amounts[j] = amounts[j].mul(1e16);
304             totalAmount = totalAmount.add(amounts[j]);
305         }
306         require(balanceOf[msg.sender] >= totalAmount);
307 
308         uint64 _now = uint64(now);
309         for (j = 0; j < addresses.length; j++) {
310             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
311             emit Transfer(msg.sender, addresses[j], amounts[j]);
312 
313             transferIns[addresses[j]].push(transferInStruct(uint256(amounts[j]),_now));
314         }
315         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
316 
317         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
318         if(balanceOf[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint256(balanceOf[msg.sender]),_now));
319 
320         return true;
321     }
322 
323     function setStakeStartTime(uint timestamp) onlyOwner public {
324         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
325         stakeStartTime = timestamp;
326     }
327 
328     function ownerBurnToken(uint _value) onlyOwner public {
329         require(_value > 0);
330 
331         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
332         delete transferIns[msg.sender];
333         transferIns[msg.sender].push(transferInStruct(uint128(balanceOf[msg.sender]),uint64(now)));
334 
335         totalSupply = totalSupply.sub(_value);
336         initialTotalSupply = initialTotalSupply.sub(_value);
337         maxTotalSupply = maxTotalSupply.sub(_value*10);
338 
339         emit Burn(msg.sender, _value);
340     }
341 
342     function getBlockNumber() constant public returns (uint blockNumber) {
343         blockNumber = block.number.sub(chainStartBlockNumber);
344     }
345 
346     modifier canPoSMint() {
347         require(totalSupply < maxTotalSupply);
348         _;
349     }
350 
351     function posMint() canPoSMint public returns (bool) {
352         if(balanceOf[msg.sender] <= 0) return false;
353         if(transferIns[msg.sender].length <= 0) return false;
354 
355         uint reward = getReward(msg.sender);
356         if(reward <= 0) return false;
357 
358         totalSupply = totalSupply.add(reward);
359         balanceOf[msg.sender] = balanceOf[msg.sender].add(reward);
360         delete transferIns[msg.sender];
361         transferIns[msg.sender].push(transferInStruct(uint256(balanceOf[msg.sender]),uint64(now)));
362 
363         emit PosMint(msg.sender, reward);
364         return true;
365     }
366 
367     function coinAge() constant public returns (uint myCoinAge) {
368         myCoinAge = getCoinAge(msg.sender,now);
369     }
370 
371     function getCoinAge(address _address, uint _now) internal view returns (uint _coinAge) {
372         if(transferIns[_address].length <= 0) return 0;
373 
374         for (uint i = 0; i < transferIns[_address].length; i++){
375             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
376 
377             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
378             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
379 
380             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount).mul(nCoinSeconds).div(1 days));
381         }
382     }
383 
384     function getReward(address _address) internal view returns (uint reward) {
385         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
386 
387         uint64 _now = uint64(now);
388         uint _coinAge = getCoinAge(_address, _now);
389         if(_coinAge <= 0) return 0;
390 
391         reward = _coinAge.mul(45).div(1000).div(365);
392         return reward;
393     }
394 
395 }