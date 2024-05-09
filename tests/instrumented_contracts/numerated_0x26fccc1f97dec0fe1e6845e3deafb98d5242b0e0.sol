1 pragma solidity 0.4.24;
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
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipRenounced(address indexed previousOwner);
60   event OwnershipTransferred(
61     address indexed previousOwner,
62     address indexed newOwner
63   );
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   constructor() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92   /**
93    * @dev Allows the current owner to relinquish control of the contract.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 }
100 
101 /**
102  * @title ERC20Basic
103  * @dev Simpler version of ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/179
105  */
106 contract ERC20Basic {
107     uint256 public totalSupply;
108     function balanceOf(address who) public constant returns (uint256);
109     function transfer(address to, uint256 value) public returns (bool);
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119     function allowance(address owner, address spender) public constant returns (uint256);
120     function transferFrom(address from, address to, uint256 value) public returns (bool);
121     function approve(address spender, uint256 value) public returns (bool);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 /**
127  * @title StakeItStandard
128  * @dev the interface of StakeItStandard
129  */
130 contract StakeItStandard {
131     uint256 public stakeStartTime;
132     uint256 public stakeMinAge;
133     uint256 public stakeMaxAge;
134     function mint() public returns (bool);
135     function coinAge() public constant returns (uint256);
136     function annualInterest() public constant returns (uint256);
137     event Mint(address indexed _address, uint _reward);
138 }
139 
140 
141 contract StakeIt is ERC20, StakeItStandard, Ownable {
142     using SafeMath for uint256;
143 
144     string public name = "StakeIt";
145     string public symbol = "STAKE";
146     uint public decimals = 8;
147 
148     uint public chainStartTime; // chain start time
149     uint public chainStartBlockNumber; // chain start block number
150     uint public stakeStartTime; // stake start time
151     uint public stakeMinAge = 1 days; // minimum age for coin age: 1 Day
152     uint public stakeMaxAge = 90 days; // stake age of full weight: 90 Days
153     uint public MintProofOfStake = 100 * 10 ** uint256(decimals); // default 100% annual interest
154 
155     uint public totalSupply;
156     uint public maxTotalSupply;
157     uint public totalInitialSupply;
158 
159     struct transferInStruct{
160     uint128 amount;
161     uint64 time;
162     }
163 
164     mapping(address => uint256) balances;
165     mapping(address => mapping (address => uint256)) allowed;
166     mapping(address => transferInStruct[]) transferIns;
167 
168     event Burn(address indexed burner, uint256 value);
169 
170     /**
171      * @dev Fix for the ERC20 short address attack.
172      */
173     modifier onlyPayloadSize(uint size) {
174         require(msg.data.length >= size + 4);
175         _;
176     }
177 
178     modifier canPoSMint() {
179         require(totalSupply < maxTotalSupply);
180         _;
181     }
182 
183     constructor() public {
184         maxTotalSupply = 100000000 * 10 ** uint256(decimals); // 100,000,000
185         totalInitialSupply = 5000000 * 10 ** uint256(decimals); // 5,000,000
186 
187         chainStartTime = now;
188         chainStartBlockNumber = block.number;
189 
190         balances[msg.sender] = totalInitialSupply;
191         totalSupply = totalInitialSupply;
192     }
193 
194     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
195         if(msg.sender == _to) return mint();
196         balances[msg.sender] = balances[msg.sender].sub(_value);
197         balances[_to] = balances[_to].add(_value);
198         emit Transfer(msg.sender, _to, _value);
199         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
200         uint64 _now = uint64(now);
201         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
202         transferIns[_to].push(transferInStruct(uint128(_value),_now));
203         return true;
204     }
205 
206     function balanceOf(address _owner) public constant returns (uint256 balance) {
207         return balances[_owner];
208     }
209 
210     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) {
211         require(_to != address(0));
212 
213         uint _allowance = allowed[_from][msg.sender];
214 
215         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
216         // require (_value <= _allowance);
217 
218         balances[_from] = balances[_from].sub(_value);
219         balances[_to] = balances[_to].add(_value);
220         allowed[_from][msg.sender] = _allowance.sub(_value);
221         emit Transfer(_from, _to, _value);
222         if(transferIns[_from].length > 0) delete transferIns[_from];
223         uint64 _now = uint64(now);
224         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
225         transferIns[_to].push(transferInStruct(uint128(_value),_now));
226         return true;
227     }
228 
229     function approve(address _spender, uint256 _value) public returns (bool) {
230         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
231 
232         allowed[msg.sender][_spender] = _value;
233         emit Approval(msg.sender, _spender, _value);
234         return true;
235     }
236 
237     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
238         return allowed[_owner][_spender];
239     }
240     
241     function changeRate(uint _rate) public onlyOwner {
242         MintProofOfStake = _rate * 10 ** uint256(decimals);
243     }
244 
245     function mint() canPoSMint public returns (bool) {
246         if(balances[msg.sender] <= 0) return false;
247         if(transferIns[msg.sender].length <= 0) return false;
248 
249         uint reward = getProofOfStakeReward(msg.sender);
250         if(reward <= 0) return false;
251 
252         totalSupply = totalSupply.add(reward);
253         balances[msg.sender] = balances[msg.sender].add(reward);
254         delete transferIns[msg.sender];
255         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
256 
257         emit Mint(msg.sender, reward);
258         return true;
259     }
260 
261     function getBlockNumber() public view returns (uint blockNumber) {
262         blockNumber = block.number.sub(chainStartBlockNumber);
263     }
264 
265     function coinAge() public constant returns (uint myCoinAge) {
266         myCoinAge = getCoinAge(msg.sender, now);
267     }
268 
269     function annualInterest() public constant returns(uint interest) {
270         interest = MintProofOfStake;
271     }
272 
273     function getProofOfStakeReward(address _address) internal view returns (uint) {
274         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
275 
276         uint _now = now;
277         uint _coinAge = getCoinAge(_address, _now);
278         if(_coinAge <= 0) return 0;
279 
280         uint interest = MintProofOfStake;
281 
282         return (_coinAge * interest).div(365 * (10**uint256(decimals)));
283     }
284 
285     function getCoinAge(address _address, uint _now) internal view returns (uint _coinAge) {
286         if(transferIns[_address].length <= 0) return 0;
287 
288         for (uint i = 0; i < transferIns[_address].length; i++){
289             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
290 
291             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
292             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
293 
294             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
295         }
296     }
297 
298     function ownerSetStakeStartTime(uint timestamp) public onlyOwner {
299         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
300         stakeStartTime = timestamp;
301     }
302 
303     function ownerBurnToken(uint _value) public onlyOwner {
304         require(_value > 0);
305 
306         balances[msg.sender] = balances[msg.sender].sub(_value);
307         delete transferIns[msg.sender];
308         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
309 
310         totalSupply = totalSupply.sub(_value);
311         totalInitialSupply = totalInitialSupply.sub(_value);
312         maxTotalSupply = maxTotalSupply.sub(_value*10);
313 
314         emit Burn(msg.sender, _value);
315     }
316 
317     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
318     function batchTransfer(address[] _recipients, uint[] _values) public onlyOwner returns (bool) {
319         require( _recipients.length > 0 && _recipients.length == _values.length);
320 
321         uint total = 0;
322         for(uint i = 0; i < _values.length; i++){
323             total = total.add(_values[i]);
324         }
325         require(total <= balances[msg.sender]);
326 
327         uint64 _now = uint64(now);
328         for(uint j = 0; j < _recipients.length; j++){
329             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
330             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
331             emit Transfer(msg.sender, _recipients[j], _values[j]);
332         }
333 
334         balances[msg.sender] = balances[msg.sender].sub(total);
335         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
336         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
337 
338         return true;
339     }
340 }