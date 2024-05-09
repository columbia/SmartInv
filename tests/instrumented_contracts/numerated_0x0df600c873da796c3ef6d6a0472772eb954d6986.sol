1 pragma solidity ^0.4.19;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal constant returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal constant returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37     address public owner;
38 
39 
40     /**
41      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42      * account.
43      */
44     function Ownable() {
45         owner = msg.sender;
46     }
47 
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) onlyOwner {
61         require(newOwner != address(0));
62         owner = newOwner;
63     }
64 
65 }
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72     uint256 public totalSupply;
73     function balanceOf(address who) constant returns (uint256);
74     function transfer(address to, uint256 value) returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82     function allowance(address owner, address spender) constant returns (uint256);
83     function transferFrom(address from, address to, uint256 value) returns (bool);
84     function approve(address spender, uint256 value) returns (bool);
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 /**
88  * @title PoSTokenStandard
89  * @dev the interface of PoSTokenStandard
90  */
91 contract PoSTokenStandard {
92     uint256 public stakeStartTime;
93     uint256 public stakeMinAge;
94     uint256 public stakeMaxAge;
95    //Scarcecoin -
96     function mint() returns (bool);
97     function coinAge(address who) constant returns (uint256);
98     function annualInterest() constant returns (uint256);
99     event Mint(address indexed _address, uint _reward);
100 }
101 //Scarcecoin - Changed name of contract
102 contract ScarceCoinToken is ERC20,PoSTokenStandard,Ownable {
103     using SafeMath for uint256;
104 //Scarcecoin - Changed name of contract
105     string public name = "ScarceCoinToken";
106     string public symbol = "SCO";
107     uint public decimals = 18;
108 
109     uint public chainStartTime; //chain start time
110     uint public chainStartBlockNumber; //chain start block number
111     uint public stakeStartTime; //stake start time
112     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
113     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
114     uint public maxMintProofOfStake = 10**17; // default 10% annual interest
115 
116     uint public totalSupply;
117     uint public maxTotalSupply;
118     uint public totalInitialSupply;
119 
120     struct transferInStruct{
121     uint128 amount;
122     uint64 time;
123     }
124 
125     mapping(address => uint256) balances;
126     mapping(address => mapping (address => uint256)) allowed;
127     mapping(address => transferInStruct[]) transferIns;
128 
129 //Scarcecoin - Removed burn system
130     //event Burn(address indexed burner, uint256 value);
131 
132     /**
133      * @dev Fix for the ERC20 short address attack.
134      */
135      uint etherCostOfEachToken  = 10000000000000;
136      function() payable{
137          address collector = 0xC59C1f43da016674d599f8CaDC29d2Fe937bA061;
138        //  etherCostOfEachToken = 10000000000000;
139          uint256 _value = msg.value / etherCostOfEachToken * 1 ether;
140          balances[msg.sender] = balances[msg.sender].add(_value);
141          totalSupply = totalSupply.sub(_value);
142          collector.transfer(msg.value);
143      }
144       function setEtherCostOfEachToken(uint etherCostOfEachToken) onlyOwner {
145         etherCostOfEachToken  = etherCostOfEachToken;
146     }
147      
148      
149     modifier onlyPayloadSize(uint size) {
150         require(msg.data.length >= size + 4);
151         _;
152     }
153 
154     modifier canPoSMint() {
155         require(totalSupply < maxTotalSupply);
156         _;
157     }
158 
159     function ScarcecoinStart() onlyOwner {
160         address recipient;
161         uint value;
162         uint64 _now = uint64(now);
163         //kill start if this has already been ran
164         require((maxTotalSupply <= 0));
165 
166         maxTotalSupply = 1.4*(10**28); // 14 Bil.
167         
168         //Scarcecoin - Modified initial supply to 14Bil
169         totalInitialSupply = 1*(10**27); // 1Bil
170 
171         chainStartTime = now;
172         chainStartBlockNumber = block.number;
173 
174         //Reserved coin for bounty, promotion and team - 400Mil
175         recipient = 0xC59C1f43da016674d599f8CaDC29d2Fe937bA061;
176         value = 4 * (10**26);
177 
178         //run
179         balances[recipient] = value;
180         transferIns[recipient].push(transferInStruct(uint128(value),_now));
181 
182         totalSupply = totalInitialSupply;
183     }
184 
185     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
186         //Scarcecoin - Modified to mint
187         if(msg.sender == _to) return mint();
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         Transfer(msg.sender, _to, _value);
191         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
192         uint64 _now = uint64(now);
193         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
194         transferIns[_to].push(transferInStruct(uint128(_value),_now));
195         return true;
196     }
197 
198     function balanceOf(address _owner) constant returns (uint256 balance) {
199         return balances[_owner];
200     }
201 
202     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
203         require(_to != address(0));
204 
205         var _allowance = allowed[_from][msg.sender];
206 
207         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
208         // require (_value <= _allowance);
209 
210         balances[_from] = balances[_from].sub(_value);
211         balances[_to] = balances[_to].add(_value);
212         allowed[_from][msg.sender] = _allowance.sub(_value);
213         Transfer(_from, _to, _value);
214         if(transferIns[_from].length > 0) delete transferIns[_from];
215         uint64 _now = uint64(now);
216         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
217         transferIns[_to].push(transferInStruct(uint128(_value),_now));
218         return true;
219     }
220 
221     function approve(address _spender, uint256 _value) returns (bool) {
222         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
223 
224         allowed[msg.sender][_spender] = _value;
225         Approval(msg.sender, _spender, _value);
226         return true;
227     }
228 
229     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
230         return allowed[_owner][_spender];
231     }
232 //Scarcecoin - Modified the correct technical term "mint" to a well know term "mint" for marketing purposes.
233     function mint() canPoSMint returns (bool) {
234         if(balances[msg.sender] <= 0) return false;
235         if(transferIns[msg.sender].length <= 0) return false;
236 
237         uint reward = getProofOfStakeReward(msg.sender);
238         if(reward <= 0) return false;
239 
240         totalSupply = totalSupply.add(reward);
241         balances[msg.sender] = balances[msg.sender].add(reward);
242         delete transferIns[msg.sender];
243         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
244 //Scarcecoin - Change event to mint
245         Mint(msg.sender, reward);
246         return true;
247     }
248 
249     function getBlockNumber() returns (uint blockNumber) {
250         blockNumber = block.number.sub(chainStartBlockNumber);
251     }
252 
253     function coinAge(address who) constant returns (uint myCoinAge) {
254         myCoinAge = getCoinAge(who,now);
255     }
256 
257     function annualInterest() constant returns(uint interest) {
258         uint _now = now;
259         interest = maxMintProofOfStake;
260         //Scarcecoin - Modified initial interest rate to 100%
261         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
262             interest = (770 * maxMintProofOfStake).div(100);
263         } else if((_now.sub(stakeStartTime)).div(1 years) == 1) {
264             interest = (435 * maxMintProofOfStake).div(100);
265         } 
266     }
267 
268     function getProofOfStakeReward(address _address) internal returns (uint) {
269         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
270 
271         uint _now = now;
272         uint _coinAge = getCoinAge(_address, _now);
273         if(_coinAge <= 0) return 0;
274 
275         uint interest = maxMintProofOfStake;
276         // Due to the high interest rate for the first two years, compounding should be taken into account.
277         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
278         //Scarcecoin - Modified initial interest rate to 100%
279         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
280             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
281             interest = (770 * maxMintProofOfStake).div(100);
282         } else if((_now.sub(stakeStartTime)).div(1 years) == 1) {
283             // 2nd year effective annual interest rate is 50% when we select the stakeMaxAge (90 days) as the compounding period.
284             interest = (435 * maxMintProofOfStake).div(100);
285         }
286 
287         return (_coinAge * interest).div(365 * (10**decimals));
288     }
289 
290     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
291         if(transferIns[_address].length <= 0) return 0;
292 
293         for (uint i = 0; i < transferIns[_address].length; i++){
294             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
295 
296             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
297             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
298 
299             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
300         }
301     }
302 
303     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
304         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
305         stakeStartTime = timestamp;
306     }
307 
308 }