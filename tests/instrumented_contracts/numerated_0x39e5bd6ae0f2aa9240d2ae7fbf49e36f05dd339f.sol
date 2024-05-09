1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41     address public owner;
42 
43 
44     /**
45      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46      * account.
47      */
48     function Ownable() {
49         owner = msg.sender;
50     }
51 
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) onlyOwner {
67         require(newOwner != address(0));
68         owner = newOwner;
69     }
70 
71 }
72 
73 
74 /**
75  * @title ERC20Basic
76  * @dev Simpler version of ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/179
78  */
79 contract ERC20Basic {
80     uint256 public totalSupply;
81     function balanceOf(address who) constant returns (uint256);
82     function transfer(address to, uint256 value) returns (bool);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92     function allowance(address owner, address spender) constant returns (uint256);
93     function transferFrom(address from, address to, uint256 value) returns (bool);
94     function approve(address spender, uint256 value) returns (bool);
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 /**
100  * @title PoSTokenStandard
101  * @dev the interface of PoSTokenStandard
102  */
103 contract PoSTokenStandard {
104     uint256 public stakeStartTime;
105     uint256 public stakeMinAge;
106     uint256 public stakeMaxAge;
107     function mint() returns (bool);
108     function getAirdrop() returns (bool);
109     function coinAge() constant returns (uint256);
110     function checkPos() constant returns (uint256);
111     function annualInterest() constant returns (uint256);
112     event Mint(address indexed _address, uint _reward);
113     event AirdropMined(address indexed to, uint256 amount);
114     
115 }
116 
117 
118 contract EthereumUnlimited is ERC20,PoSTokenStandard,Ownable {
119     using SafeMath for uint256;
120 
121     string public name = "Ethereum Unlimited";
122     string public symbol = "ETHU";
123     uint public decimals = 18;
124 
125     uint public chainStartTime; //chain start time
126     uint public chainStartBlockNumber; //chain start block number
127     uint public stakeStartTime; //stake start time
128     uint public stakeMinAge = 1 days; // minimum age for coin age: 1D
129     uint public stakeMaxAge = 365 days; // stake age of full weight: 365D
130     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
131     
132 
133     uint public totalSupply;
134     uint public maxTotalSupply;
135     uint public totalInitialSupply;
136     uint public AirdropReward;
137     uint public AirRewardmaxTotalSupply;
138     uint public AirRewardTotalSupply;
139         
140 
141     struct transferInStruct{
142     uint128 amount;
143     uint64 time;
144     }
145     
146     
147     mapping (address => bool) isAirdropAddress;
148     mapping(address => uint256) balances;
149     mapping(address => mapping (address => uint256)) allowed;
150     mapping(address => transferInStruct[]) transferIns;
151     
152 
153     event Burn(address indexed burner, uint256 value);
154     
155 
156     /**
157      * @dev Fix for the ERC20 short address attack.
158      */
159     modifier onlyPayloadSize(uint size) {
160         require(msg.data.length >= size + 4);
161         _;
162     }
163 
164     modifier canPoSMint() {
165         require(totalSupply < maxTotalSupply);
166         _;
167     }
168 
169 
170     modifier canGetAirdrop() {
171         require(AirRewardTotalSupply < AirRewardmaxTotalSupply);
172         _;
173     }
174     
175     function EthereumUnlimited() {
176         maxTotalSupply = 100000000000000 * 1 ether; // unlimited.
177         totalInitialSupply = 10000000 * 1 ether; // 1 Mil.
178         AirdropReward = 10 * 1 ether;
179         AirRewardmaxTotalSupply = 10000 * 1 ether;
180         AirRewardTotalSupply = 0;
181         
182         chainStartTime = now;
183         chainStartBlockNumber = block.number;
184 
185         balances[msg.sender] = totalInitialSupply;
186         totalSupply = totalInitialSupply;
187     }
188 
189     
190     
191     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
192         if(msg.sender == _to) return mint();
193         balances[msg.sender] = balances[msg.sender].sub(_value);
194         balances[_to] = balances[_to].add(_value);
195         Transfer(msg.sender, _to, _value);
196         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
197         uint64 _now = uint64(now);
198         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
199         transferIns[_to].push(transferInStruct(uint128(_value),_now));
200         return true;
201     }
202 
203     function balanceOf(address _owner) constant returns (uint256 balance) {
204         return balances[_owner];
205     }
206 
207     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
208         require(_to != address(0));
209 
210         var _allowance = allowed[_from][msg.sender];
211 
212         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
213         // require (_value <= _allowance);
214 
215         balances[_from] = balances[_from].sub(_value);
216         balances[_to] = balances[_to].add(_value);
217         allowed[_from][msg.sender] = _allowance.sub(_value);
218         Transfer(_from, _to, _value);
219         if(transferIns[_from].length > 0) delete transferIns[_from];
220         uint64 _now = uint64(now);
221         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
222         transferIns[_to].push(transferInStruct(uint128(_value),_now));
223         return true;
224     }
225 
226     function approve(address _spender, uint256 _value) returns (bool) {
227         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
228 
229         allowed[msg.sender][_spender] = _value;
230         Approval(msg.sender, _spender, _value);
231         return true;
232     }
233 
234     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
235         return allowed[_owner][_spender];
236     }
237 
238     function mint() canPoSMint returns (bool) {
239         if(balances[msg.sender] <= 0) return false;
240         if(transferIns[msg.sender].length <= 0) return false;
241 
242         uint reward = getProofOfStakeReward(msg.sender);
243         if(reward <= 0) return false;
244 
245         totalSupply = totalSupply.add(reward);
246         balances[msg.sender] = balances[msg.sender].add(reward);
247         delete transferIns[msg.sender];
248         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
249 
250         Mint(msg.sender, reward);
251         return true;
252     }
253     
254     function getAirdrop() canGetAirdrop returns (bool) {
255         if (isAirdropAddress[msg.sender]) revert();
256         if (AirdropReward < 10000)	AirdropReward = 10000;
257         isAirdropAddress[msg.sender] = true;
258         balances[msg.sender] += AirdropReward;
259 	    AirRewardTotalSupply += AirdropReward;
260 	    Transfer(this, msg.sender, AirdropReward);
261 	    delete transferIns[msg.sender];
262         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
263 
264 	    AirdropMined(msg.sender, AirdropReward);
265 	    AirdropReward -=10000;
266 	    return true;
267     }
268 
269     function getBlockNumber() returns (uint blockNumber) {
270         blockNumber = block.number.sub(chainStartBlockNumber);
271     }
272 
273     function coinAge() constant returns (uint myCoinAge) {
274         myCoinAge = getCoinAge(msg.sender,now);
275     }
276     
277     function checkPos() constant returns (uint reward) {
278         
279         reward = getProofOfStakeReward(msg.sender);
280         
281     }
282     
283     
284 
285     function annualInterest() constant returns(uint interest) {
286         uint _now = now;
287         interest = maxMintProofOfStake;
288         interest = (4000 * maxMintProofOfStake).div(100);
289     }
290 
291     function getProofOfStakeReward(address _address) internal returns (uint) {
292         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
293 
294         uint _now = now;
295         uint _coinAge = getCoinAge(_address, _now);
296         if(_coinAge <= 0) return 0;
297 
298         uint interest = maxMintProofOfStake;
299         //Aannual interest rate is 400%.
300         interest = (4000 * maxMintProofOfStake).div(100);
301         
302         return (_coinAge * interest).div(365 * (10**decimals));
303     }
304 
305     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
306         if(transferIns[_address].length <= 0) return 0;
307 
308         for (uint i = 0; i < transferIns[_address].length; i++){
309             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
310 
311             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
312             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
313 
314             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
315         }
316     }
317 
318     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
319         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
320         stakeStartTime = timestamp;
321     }
322     
323     function ResetAirdrop(uint _value) onlyOwner {
324         AirRewardTotalSupply=_value;
325     }
326 
327     function ownerBurnToken(uint _value) onlyOwner {
328         require(_value > 0);
329 
330         balances[msg.sender] = balances[msg.sender].sub(_value);
331         delete transferIns[msg.sender];
332         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
333 
334         totalSupply = totalSupply.sub(_value);
335         totalInitialSupply = totalInitialSupply.sub(_value);
336         maxTotalSupply = maxTotalSupply.sub(_value*10);
337 
338         Burn(msg.sender, _value);
339     }
340 
341     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
342     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
343         require( _recipients.length > 0 && _recipients.length == _values.length);
344 
345         uint total = 0;
346         for(uint i = 0; i < _values.length; i++){
347             total = total.add(_values[i]);
348         }
349         require(total <= balances[msg.sender]);
350 
351         uint64 _now = uint64(now);
352         for(uint j = 0; j < _recipients.length; j++){
353             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
354             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
355             Transfer(msg.sender, _recipients[j], _values[j]);
356         }
357 
358         balances[msg.sender] = balances[msg.sender].sub(total);
359         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
360         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
361 
362         return true;
363     }
364 }