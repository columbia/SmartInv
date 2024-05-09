1 pragma solidity ^0.4.11;
2 
3 // 要件
4 // ・PosTokenをベース
5 // ・ERC20（元から）
6 // ・ownerの変更が出来るように（元から）
7 // ・初期発行量：150億枚
8 // ・最大発行量：330億枚
9 // ・オーナーアドレスを指定
10 // ・利子：年4%
11 // ・coin ageの増加を1日⇒1分単位に変更
12 // ・最小・最大保有日数：なし
13 // ・初年度・2年目優遇：なし
14 // ・エアドロップの追加
15 // ・burnの最大発行量の削除は比率で行う
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22     function mul(uint256 a, uint256 b) internal returns (uint256) {
23         uint256 c = a * b;
24         assert(a == 0 || c / a == b);
25         return c;
26     }
27 
28     function div(uint256 a, uint256 b) internal returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function add(uint256 a, uint256 b) internal returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54     address public owner;
55 
56 
57     /**
58      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59      * account.
60      */
61     function Ownable() public {
62         owner = 0xF773323FF8ae778E361dCdECCE61c08abfDF2A71;
63     }
64 
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74 
75     /**
76      * @dev Allows the current owner to transfer control of the contract to a newOwner.
77      * @param newOwner The address to transfer ownership to.
78      */
79     function transferOwnership(address newOwner) public onlyOwner {
80         require(newOwner != address(0));
81         owner = newOwner;
82     }
83 
84 }
85 
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93     uint256 public totalSupply;
94     function balanceOf(address who) public constant returns (uint256);
95     function transfer(address to, uint256 value) public returns (bool);
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105     function allowance(address owner, address spender) public constant returns (uint256);
106     function transferFrom(address from, address to, uint256 value) public returns (bool);
107     function approve(address spender, uint256 value) public returns (bool);
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 /**
113  * @title PoSTokenStandard
114  * @dev the interface of PoSTokenStandard
115  */
116 contract PoSTokenStandard {
117     uint256 public stakeStartTime;
118     function mint() public returns (bool);
119     function coinAge() public constant returns (uint256);
120     event Mint(address indexed _address, uint _reward);
121 }
122 
123 
124 contract YokochoCoin is ERC20,PoSTokenStandard,Ownable {
125     using SafeMath for uint256;
126 
127     string public name = "Yokocho coin";
128     string public symbol = "YOKOCHO";
129     uint public decimals = 18;
130 
131     uint public chainStartTime; //chain start time
132     uint public chainStartBlockNumber; //chain start block number
133     uint public stakeStartTime; //stake start time
134     uint public interest = 4; // 利率４％
135 
136     uint public totalSupply;
137     uint public maxTotalSupply;
138     uint public totalInitialSupply;
139 
140     struct transferInStruct{
141     uint128 amount;
142     uint64 time;
143     }
144 
145     mapping(address => uint256) balances;
146     mapping(address => mapping (address => uint256)) allowed;
147     mapping(address => transferInStruct[]) transferIns;
148 
149     event Burn(address indexed burner, uint256 value);
150 
151     /**
152      * @dev Fix for the ERC20 short address attack.
153      */
154     modifier onlyPayloadSize(uint size) {
155         require(msg.data.length >= size + 4);
156         _;
157     }
158 
159     modifier canPoSMint() {
160         require(totalSupply < maxTotalSupply);
161         _;
162     }
163 
164     function YokochoCoin() public {
165         totalInitialSupply = 15e9 * 10**uint(decimals);  // 発行量。150億枚
166         maxTotalSupply = 33e9 * 10**uint(decimals); // 最大発行量。330億枚。
167 
168         chainStartTime = now;
169         chainStartBlockNumber = block.number;
170 
171         balances[0xF773323FF8ae778E361dCdECCE61c08abfDF2A71] = totalInitialSupply;
172         totalSupply = totalInitialSupply;
173     }
174 
175     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
176         if(msg.sender == _to) return mint();
177         balances[msg.sender] = balances[msg.sender].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         Transfer(msg.sender, _to, _value);
180         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
181         uint64 _now = uint64(now);
182         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
183         transferIns[_to].push(transferInStruct(uint128(_value),_now));
184         return true;
185     }
186 
187     function balanceOf(address _owner) public constant returns (uint256 balance) {
188         return balances[_owner];
189     }
190 
191     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
192         require(_to != address(0));
193 
194         var _allowance = allowed[_from][msg.sender];
195 
196         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
197         // require (_value <= _allowance);
198 
199         balances[_from] = balances[_from].sub(_value);
200         balances[_to] = balances[_to].add(_value);
201         allowed[_from][msg.sender] = _allowance.sub(_value);
202         Transfer(_from, _to, _value);
203         if(transferIns[_from].length > 0) delete transferIns[_from];
204         uint64 _now = uint64(now);
205         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
206         transferIns[_to].push(transferInStruct(uint128(_value),_now));
207         return true;
208     }
209 
210     function approve(address _spender, uint256 _value) public returns (bool) {
211         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
212 
213         allowed[msg.sender][_spender] = _value;
214         Approval(msg.sender, _spender, _value);
215         return true;
216     }
217 
218     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
219         return allowed[_owner][_spender];
220     }
221 
222     function mint() public canPoSMint returns (bool) {
223         if(balances[msg.sender] <= 0) return false;
224         if(transferIns[msg.sender].length <= 0) return false;
225 
226         uint reward = getProofOfStakeReward(msg.sender);
227         if(reward <= 0) return false;
228 
229         totalSupply = totalSupply.add(reward);
230         balances[msg.sender] = balances[msg.sender].add(reward);
231         delete transferIns[msg.sender];
232         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
233 
234         Mint(msg.sender, reward);
235         return true;
236     }
237 
238     function getBlockNumber() public returns (uint blockNumber) {
239         blockNumber = block.number.sub(chainStartBlockNumber);
240     }
241 
242     function coinAge() public constant returns (uint myCoinAge) {
243         myCoinAge = getCoinAge(msg.sender,now);
244     }
245 
246     function getProofOfStakeReward(address _address) internal returns (uint) {
247         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
248 
249         uint _now = now;
250         uint _coinAge_minutes = getCoinAge(_address, _now);
251         if(_coinAge_minutes <= 0) return 0;
252 
253         // 分単位⇒年単位、小数点の考慮
254         uint _coinAge = _coinAge_minutes.div(60 * 24 * 365);
255 
256         // 利率の考慮
257         // interest.div(100)としてしまうとinterestはuintなので小数部を持てないので0扱いになるのでこうしている
258         return ((_coinAge * interest).div(100));
259     }
260 
261     function getCoinAge(address _address, uint _now) internal returns (uint _total_coinAge) {
262         if(transferIns[_address].length <= 0) return 0;
263 
264         // 一度でも送金したらtransferIns[_address].lengthは1に戻るが、送金を受ける度に別途増える
265         for (uint i = 0; i < transferIns[_address].length; i++){
266 
267             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
268 
269             uint _coinAge = transferIns[_address][i].amount * nCoinSeconds.div(1 minutes);
270 
271             _total_coinAge = _total_coinAge.add(_coinAge);
272         }
273     }
274 
275     function ownerSetStakeStartTime(uint timestamp) public onlyOwner {
276         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
277         stakeStartTime = timestamp;
278     }
279 
280     function ownerBurnToken(uint _value) public onlyOwner {
281         require(_value > 0);
282 
283         balances[msg.sender] = balances[msg.sender].sub(_value);
284         delete transferIns[msg.sender];
285         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
286 
287         totalSupply = totalSupply.sub(_value);
288         totalInitialSupply = totalInitialSupply.sub(_value);
289         maxTotalSupply = maxTotalSupply.sub(_value.mul(maxTotalSupply).div(totalSupply));
290 
291 
292         Burn(msg.sender, _value);
293     }
294     
295     // 追加。エアドロ。引数はリストで渡すこと
296     function airdrop(address[] addresses, uint[] amounts) public returns (bool) {
297         require(addresses.length > 0
298                 && addresses.length == amounts.length);
299 
300         uint _totalAmount = 0;
301 
302         for(uint j = 0; j < addresses.length; j++){
303             require(amounts[j] > 0
304                     && addresses[j] != 0x0);
305 
306             _totalAmount = _totalAmount.add(amounts[j]);
307         }
308         require(balances[msg.sender] >= _totalAmount);
309 
310         for (j = 0; j < amounts.length; j++) {
311             balances[addresses[j]] = balances[addresses[j]].add(amounts[j]);
312             Transfer(msg.sender, addresses[j], amounts[j]);
313         }
314         balances[msg.sender] = balances[msg.sender].sub(_totalAmount);
315         return true;
316     }
317 }