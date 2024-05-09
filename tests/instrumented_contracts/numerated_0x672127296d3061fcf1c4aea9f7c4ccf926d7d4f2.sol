1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 pragma solidity ^0.4.23;
50 
51 
52 contract Ownable {
53   address public owner;
54 
55 
56   event OwnershipRenounced(address indexed previousOwner);
57   event OwnershipTransferred(
58     address indexed previousOwner,
59     address indexed newOwner
60   );
61 
62 
63   constructor() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     emit OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 }
93 
94 /**
95  * @title ERC20Basic
96  * @dev Simpler version of ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/179
98  */
99 contract ERC20Basic {
100     uint256 public totalSupply;
101     function balanceOf(address who) public constant returns (uint256);
102     function transfer(address to, uint256 value) public returns (bool);
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112     function allowance(address owner, address spender) public constant returns (uint256);
113     function transferFrom(address from, address to, uint256 value) public returns (bool);
114     function approve(address spender, uint256 value) public returns (bool);
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 
120 contract StakerStandard {
121     uint256 public stakeStartTime;
122     uint256 public stakeMinAge;
123     uint256 public stakeMaxAge;
124     function mint() public returns (bool);
125     function coinAge() public constant returns (uint256);
126     function annualInterest() public constant returns (uint256);
127     event Mint(address indexed _address, uint _reward);
128 }
129 
130 
131 contract Staker is ERC20, StakerStandard, Ownable {
132     using SafeMath for uint256;
133 
134     string public name = "Staker";
135     string public symbol = "STR";
136     uint public decimals = 18;
137 
138     uint public chainStartTime; 
139     uint public chainStartBlockNumber; 
140     uint public stakeStartTime; 
141     uint public stakeMinAge = 3 days; 
142     uint public stakeMaxAge = 90 days; 
143     uint public MintProofOfStake = 10**17; 
144 
145     uint public totalSupply;
146     uint public maxTotalSupply;
147     uint public totalInitialSupply;
148 
149     struct transferInStruct{
150     uint128 amount;
151     uint64 time;
152     }
153 
154     mapping(address => uint256) balances;
155     mapping(address => mapping (address => uint256)) allowed;
156     mapping(address => transferInStruct[]) transferIns;
157 
158     event Burn(address indexed burner, uint256 value);
159 
160     /**
161      * @dev Fix for the ERC20 short address attack.
162      */
163     modifier onlyPayloadSize(uint size) {
164         require(msg.data.length >= size + 4);
165         _;
166     }
167 
168     modifier canPoSMint() {
169         require(totalSupply < maxTotalSupply);
170         _;
171     }
172 
173     constructor() public {
174         maxTotalSupply = 7000000000000000000000000; 
175         totalInitialSupply = 1000000000000000000000000; 
176 
177         chainStartTime = now;
178         chainStartBlockNumber = block.number;
179 
180         balances[msg.sender] = totalInitialSupply;
181         totalSupply = totalInitialSupply;
182     }
183 
184     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
185         if(msg.sender == _to) return mint();
186         balances[msg.sender] = balances[msg.sender].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         emit Transfer(msg.sender, _to, _value);
189         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
190         uint64 _now = uint64(now);
191         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
192         transferIns[_to].push(transferInStruct(uint128(_value),_now));
193         return true;
194     }
195 
196     function balanceOf(address _owner) public constant returns (uint256 balance) {
197         return balances[_owner];
198     }
199 
200     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
201         require(_to != address(0));
202 
203         var _allowance = allowed[_from][msg.sender];
204 
205     
206 
207         balances[_from] = balances[_from].sub(_value);
208         balances[_to] = balances[_to].add(_value);
209         allowed[_from][msg.sender] = _allowance.sub(_value);
210         emit Transfer(_from, _to, _value);
211         if(transferIns[_from].length > 0) delete transferIns[_from];
212         uint64 _now = uint64(now);
213         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
214         transferIns[_to].push(transferInStruct(uint128(_value),_now));
215         return true;
216     }
217 
218     function approve(address _spender, uint256 _value) public returns (bool) {
219         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
220 
221         allowed[msg.sender][_spender] = _value;
222         emit Approval(msg.sender, _spender, _value);
223         return true;
224     }
225 
226     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
227         return allowed[_owner][_spender];
228     }
229     
230     function changeRate(uint _rate) public onlyOwner {
231         MintProofOfStake = _rate * 10 ** uint256(decimals);
232     }
233 
234     function mint() canPoSMint public returns (bool) {
235         if(balances[msg.sender] <= 0) return false;
236         if(transferIns[msg.sender].length <= 0) return false;
237 
238         uint reward = getProofOfStakeReward(msg.sender);
239         if(reward <= 0) return false;
240 
241         totalSupply = totalSupply.add(reward);
242         balances[msg.sender] = balances[msg.sender].add(reward);
243         delete transferIns[msg.sender];
244         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
245 
246         emit Mint(msg.sender, reward);
247         return true;
248     }
249 
250     function getBlockNumber() public view returns (uint blockNumber) {
251         blockNumber = block.number.sub(chainStartBlockNumber);
252     }
253 
254     function coinAge() public constant returns (uint myCoinAge) {
255         myCoinAge = getCoinAge(msg.sender, now);
256     }
257 
258     function annualInterest() public constant returns(uint interest) {
259         interest = MintProofOfStake;
260     }
261 
262     function getProofOfStakeReward(address _address) internal view returns (uint) {
263         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
264 
265         uint _now = now;
266         uint _coinAge = getCoinAge(_address, _now);
267         if(_coinAge <= 0) return 0;
268 
269         uint interest = MintProofOfStake;
270 
271         return (_coinAge * interest).div(365 * (10**uint256(decimals)));
272     }
273 
274     function getCoinAge(address _address, uint _now) internal view returns (uint _coinAge) {
275         if(transferIns[_address].length <= 0) return 0;
276 
277         for (uint i = 0; i < transferIns[_address].length; i++){
278             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
279 
280             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
281             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
282 
283             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
284         }
285     }
286 
287     function ownerSetStakeStartTime(uint timestamp) public onlyOwner {
288         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
289         stakeStartTime = timestamp;
290     }
291 
292     function ownerBurnToken(uint _value) public onlyOwner {
293         require(_value > 0);
294 
295         balances[msg.sender] = balances[msg.sender].sub(_value);
296         delete transferIns[msg.sender];
297         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
298 
299         totalSupply = totalSupply.sub(_value);
300         totalInitialSupply = totalInitialSupply.sub(_value);
301         maxTotalSupply = maxTotalSupply.sub(_value*10);
302 
303         emit Burn(msg.sender, _value);
304     }
305 
306     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
307     function batchTransfer(address[] _recipients, uint[] _values) public onlyOwner returns (bool) {
308         require( _recipients.length > 0 && _recipients.length == _values.length);
309 
310         uint total = 0;
311         for(uint i = 0; i < _values.length; i++){
312             total = total.add(_values[i]);
313         }
314         require(total <= balances[msg.sender]);
315 
316         uint64 _now = uint64(now);
317         for(uint j = 0; j < _recipients.length; j++){
318             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
319             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
320             emit Transfer(msg.sender, _recipients[j], _values[j]);
321         }
322 
323         balances[msg.sender] = balances[msg.sender].sub(total);
324         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
325         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
326 
327         return true;
328     }
329 }