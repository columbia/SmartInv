1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal returns (uint256) {
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
40 
41 
42 contract Ownable {
43     address public owner;
44 
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48      * account.
49      */
50     function Ownable() public {
51         owner = msg.sender;
52     }
53 
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63 
64     /**
65      * @dev Allows the current owner to transfer control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address newOwner) onlyOwner external {
69         require(newOwner != address(0));
70         owner = newOwner;
71     }
72 
73 }
74 
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82     uint256 public totalSupply;
83     function balanceOf(address who) external constant returns (uint256);
84     function transfer(address to, uint256 value) external returns (bool);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) external constant returns (uint256);
95     function transferFrom(address from, address to, uint256 value) external returns (bool);
96     function approve(address spender, uint256 value) external returns (bool);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 /**
102  * @title GameGoldTokenStandard
103  * @dev the interface of GameGoldTokenStandard
104  */
105 contract GameGoldTokenStandard {
106     uint256 public stakeStartTime;
107     uint256 public stakeMinAge;
108     uint256 public stakeMaxAge;
109     function mint() public returns (bool);
110     function coinAge() external constant returns (uint256);
111     function annualInterest() external constant returns (uint256);
112     event Mint(address indexed _address, uint _reward);
113 }
114 
115 
116 contract GameGoldToken is ERC20,GameGoldTokenStandard,Ownable {
117     using SafeMath for uint256;
118 
119     string constant name = "Game Gold Token";
120     string constant symbol = "GGT";
121     uint constant decimals = 18;
122 
123     uint public chainStartTime; //chain start time
124     uint public chainStartBlockNumber; //chain start block number
125     uint public stakeStartTime; //stake start time
126     uint constant stakeMinAge = 3 days; // minimum age for coin age: 3D
127     uint constant stakeMaxAge = 90 days; // stake age of full weight: 90D
128     uint public maxMintProofOfStake;
129 
130     uint public totalSupply;
131     uint public saleSupply; //founders initial supply 53%
132     uint public tokenPrice;
133     uint public alreadySold;
134 
135     /*
136     uint public foundersAmountSupply = 83250000; //founders initial supply 15%
137     uint public teamAmountSupply = 27750000; //team initial supply 5%
138     uint public advisorsAmountSupply = 44400000; //advisors initial supply 8%
139     uint public gameFundAmountSupply = 83250000; //game ICO Fund initial supply 15
140     uint public airdropAmountSupply = 11100000; //airdrop initial supply 2%
141     uint public bountyAmountSupply = 11100000; //bounty initial supply 2%
142     */
143 
144     bool public saleIsGoing;
145 
146 
147     struct transferInStruct {
148         uint128 amount;
149         uint64 time;
150     }
151 
152     mapping(address => uint256) balances;
153     mapping(address => mapping (address => uint256)) allowed;
154     mapping(address => transferInStruct[]) transferIns;
155 
156     event Burn(address indexed burner, uint256 value);
157 
158     /**
159      * @dev Fix for the ERC20 short address attack.
160      */
161     modifier onlyPayloadSize(uint size) {
162         require(msg.data.length >= size + 4);
163         _;
164     }
165 
166     modifier onlyIfSaleIsGoing() {
167         require(saleIsGoing);
168         _;
169     }
170 
171 
172     function GameGoldToken() public {
173         chainStartTime = now;
174         chainStartBlockNumber = block.number;
175         totalSupply = 555000000*10**decimals; // 555 Millions;
176         saleSupply = 294150000*10**decimals; //53%
177 	    tokenPrice = 0.00035 ether;
178         alreadySold = 0;
179         balances[owner] = totalSupply;
180         Transfer(address(0), owner, totalSupply);
181 	    maxMintProofOfStake = 138750000*10**decimals; // 25% annual interest
182         saleIsGoing = true;
183     }
184 
185     function updateSaleStatus() external onlyOwner returns(bool) {
186         saleIsGoing = !saleIsGoing;
187         return true;
188     }
189 
190     function setPrice(uint _newPrice) external onlyOwner returns(bool) {
191         require(_newPrice >= 0);
192         tokenPrice = _newPrice;
193         return true;
194     }
195 
196     function balanceOf(address _owner) constant external returns (uint256 balance) {
197         return balances[_owner];
198     }
199     
200     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) external returns (bool) {
201         if(msg.sender == _to) return mint();
202         balances[msg.sender] = balances[msg.sender].sub(_value);
203         balances[_to] = balances[_to].add(_value);
204         Transfer(msg.sender, _to, _value);
205         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
206         uint64 _now = uint64(now);
207         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
208         transferIns[_to].push(transferInStruct(uint128(_value),_now));
209         return true;
210     }
211 
212     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) external returns (bool) {
213         require(_to != address(0));
214 
215         uint _allowance = uint(allowed[_from][msg.sender]);
216 
217         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
218         // require (_value <= _allowance);
219 
220         balances[_from] = balances[_from].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         allowed[_from][msg.sender] = _allowance.sub(_value);
223         Transfer(_from, _to, _value);
224         if(transferIns[_from].length > 0) delete transferIns[_from];
225         uint64 _now = uint64(now);
226         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
227         transferIns[_to].push(transferInStruct(uint128(_value),_now));
228         return true;
229     }
230 
231     function approve(address _spender, uint256 _value) external returns (bool) {
232         require(_value == 0 || allowed[msg.sender][_spender] == 0);
233 
234         allowed[msg.sender][_spender] = _value;
235         Approval(msg.sender, _spender, _value);
236         return true;
237     }
238 
239     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
240         return allowed[_owner][_spender];
241     }
242     
243     function withdraw(uint amount) public onlyOwner returns(bool) {
244         require(amount <= address(this).balance);
245         owner.transfer(address(this).balance);
246         return true;
247     }
248     
249     function ownerMint(uint _amount) public onlyOwner returns (bool) {
250         uint amount = _amount * 10**decimals;
251         require(totalSupply.add(amount) <= 2**256 - 1 && balances[owner].add(amount) <= 2**256 - 1);
252         totalSupply = totalSupply.add(amount);
253         balances[owner] = balances[owner].add(amount);
254         Transfer(address(0), owner, amount);
255         return true;
256     }
257 
258     function mint() public returns (bool) {
259         if(balances[msg.sender] <= 0 || transferIns[msg.sender].length <= 0) return false;
260 
261         uint reward = getProofOfStakeReward(msg.sender);
262         if(reward <= 0) return false;
263 
264         totalSupply = totalSupply.add(reward);
265         balances[msg.sender] = balances[msg.sender].add(reward);
266         delete transferIns[msg.sender];
267         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
268 
269         Mint(msg.sender, reward);
270         return true;
271     }
272 
273     function getBlockNumber() external constant returns (uint blockNumber) {
274         blockNumber = block.number.sub(chainStartBlockNumber);
275     }
276 
277     function coinAge() external constant returns (uint myCoinAge) {
278         myCoinAge = getCoinAge(msg.sender,now);
279     }
280 
281     function annualInterest() external constant returns(uint) {
282         return maxMintProofOfStake;
283     }
284 
285     function getProofOfStakeReward(address _address) internal constant returns (uint) {
286         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
287 
288         uint _now = now;
289         uint _coinAge = getCoinAge(_address, _now);
290         if(_coinAge <= 0) return 0;
291 
292         uint interest = maxMintProofOfStake;
293 
294         return (_coinAge * interest).div(365 * (10**decimals));
295     }
296 
297     function getCoinAge(address _address, uint _now) internal constant returns (uint _coinAge) {
298         if(transferIns[_address].length <= 0) return 0;
299 
300         for (uint i = 0; i < transferIns[_address].length; i++){
301             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
302 
303             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
304             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
305 
306             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
307         }
308     }
309 
310     function ownerSetStakeStartTime(uint timestamp) onlyOwner external {
311         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
312         stakeStartTime = timestamp;
313     }
314 
315     function ownerBurnToken(uint _value) onlyOwner external {
316         require(_value > 0);
317 
318         balances[msg.sender] = balances[msg.sender].sub(_value);
319         delete transferIns[msg.sender];
320         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
321 
322         totalSupply = totalSupply.sub(_value);
323 
324         Burn(msg.sender, _value);
325     }
326 
327     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
328     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (uint) {
329         require( _recipients.length > 0 && _recipients.length == _values.length);
330         uint total = 0;
331         assembly {
332             let len := mload(_values)
333             for { let i := 0 } lt(i, len) { i := add(i, 1) } {
334                 total := add(total, mload(add(add(_values, 0x20), mul(i, 0x20))))
335             }
336         }
337         require(total <= balances[msg.sender]);
338         uint64 _now = uint64(now);
339         
340         for(uint j = 0; j < _recipients.length; j++){
341             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
342             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
343             Transfer(msg.sender, _recipients[j], _values[j]);
344         }
345 
346         balances[msg.sender] = balances[msg.sender].sub(total);
347         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
348         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
349 
350         return total;
351     }
352 
353 
354     /* buying tokens function */
355     function() public onlyIfSaleIsGoing payable {
356     	 require(msg.value >= tokenPrice);
357     	 uint tokenAmount = (msg.value / tokenPrice) * 10 ** decimals;
358     	 require(alreadySold.add(tokenAmount) <= saleSupply);
359 
360     	 balances[owner] = balances[owner].sub(tokenAmount);
361     	 balances[msg.sender] = balances[msg.sender].add(tokenAmount);
362     	 alreadySold = alreadySold.add(tokenAmount);
363     	 Transfer(owner, msg.sender, tokenAmount);
364     }
365 
366 }