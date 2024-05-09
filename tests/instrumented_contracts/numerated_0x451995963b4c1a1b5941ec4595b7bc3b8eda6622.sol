1 pragma solidity ^0.4.11;
2 
3 
4 contract Token {
5 
6     /// @return total amount of tokens
7     function totalSupply() constant returns (uint256 supply) {}
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) constant returns (uint256 balance) {}
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) returns (bool success) {}
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
25 
26     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) returns (bool success) {}
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40 }
41 
42 
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
50         uint256 c = a * b;
51         assert(a == 0 || c / a == b);
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal constant returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
63         assert(b <= a);
64         return a - b;
65     }
66 
67     function add(uint256 a, uint256 b) internal constant returns (uint256) {
68         uint256 c = a + b;
69         assert(c >= a);
70         return c;
71     }
72 }
73 
74 contract StandardToken is Token {
75 
76     function transfer(address _to, uint256 _value) returns (bool success) {
77         //Default assumes totalSupply can't be over max (2^256 - 1).
78         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
79         //Replace the if with this one instead.
80         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
81         if (balances[msg.sender] >= _value && _value > 0) {
82             balances[msg.sender] -= _value;
83             balances[_to] += _value;
84             Transfer(msg.sender, _to, _value);
85             return true;
86         } else { return false; }
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
90         //same as above. Replace this line with the following if you want to protect against wrapping uints.
91         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
92         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
93             balances[_to] += _value;
94             balances[_from] -= _value;
95             allowed[_from][msg.sender] -= _value;
96             Transfer(_from, _to, _value);
97             return true;
98         } else { return false; }
99     }
100 
101      function balanceOf(address _owner) constant returns (uint256 balance) {
102         return balances[_owner];
103     }
104 
105     function approve(address _spender, uint256 _value) returns (bool success) {
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
112       return allowed[_owner][_spender];
113     }
114 
115     mapping (address => uint256) balances;
116     mapping (address => mapping (address => uint256)) allowed;
117     uint256 public totalSupply;
118 }
119 
120 
121 
122 /**
123  * @title Ownable
124  * @dev The Ownable contract has an owner address, and provides basic authorization control
125  * functions, this simplifies the implementation of "user permissions".
126  */
127 contract Ownable {
128     address public owner;
129 
130 
131     /**
132      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133      * account.
134      */
135     function Ownable() {
136         owner = msg.sender;
137     }
138 
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(msg.sender == owner);
145         _;
146     }
147 
148 
149     /**
150      * @dev Allows the current owner to transfer control of the contract to a newOwner.
151      * @param newOwner The address to transfer ownership to.
152      */
153     function transferOwnership(address newOwner) onlyOwner {
154         require(newOwner != address(0));
155         owner = newOwner;
156     }
157 
158 }
159 
160 
161 /**
162  * @title ERC20Basic
163  * @dev Simpler version of ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/179
165  */
166 contract ERC20Basic {
167     uint256 public totalSupply;
168     function balanceOf(address who) constant returns (uint256);
169     function transfer(address to, uint256 value) returns (bool);
170     event Transfer(address indexed from, address indexed to, uint256 value);
171 }
172 
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179     function allowance(address owner, address spender) constant returns (uint256);
180     function transferFrom(address from, address to, uint256 value) returns (bool);
181     function approve(address spender, uint256 value) returns (bool);
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 
186 /**
187  * @title Bitstocksmarket token
188  * @dev the interface of Bitstocksmarket token
189  */
190 contract Bitstocksmarkettoken{
191     uint256 public stakeStartTime;
192     uint256 public stakeMinAge;
193     uint256 public stakeMaxAge;
194     function mint() returns (bool);
195     function coinAge() constant returns (uint256);
196     function annualInterest() constant returns (uint256);
197     event Mint(address indexed _address, uint _reward);
198 }
199 
200 
201 contract Bitstocksmarket is ERC20,Bitstocksmarkettoken,Ownable {
202     using SafeMath for uint256;
203 
204     string public name = "Bitstocksmarket Token";
205     string public symbol = "BSM";
206     uint public decimals = 10;
207     uint256 public unitsOneEthCanBuy = 1700;
208     uint256 public totalEthInWei;
209     address public fundsWallet = msg.sender;
210 
211 
212     uint public chainStartTime; //chain start time
213     uint public chainStartBlockNumber; //chain start block number
214     uint public stakeStartTime; //stake start time
215     uint public stakeMinAge = 3 days; // minimum age for coin age: 3D
216     uint public stakeMaxAge = 90 days; // stake age of full weight: 90D
217     uint public maxMintProofOfStake = 10**16; // default 10% annual interest
218 
219     uint public totalSupply;
220     uint public maxTotalSupply;
221     uint public totalInitialSupply;
222 
223     struct transferInStruct{
224     uint128 amount;
225     uint64 time;
226     }
227 
228     mapping(address => uint256) balances;
229     mapping(address => mapping (address => uint256)) allowed;
230     mapping(address => transferInStruct[]) transferIns;
231 
232     event Burn(address indexed burner, uint256 value);
233 
234 
235 
236     /**
237      * @dev Fix for the ERC20 short address attack.
238      */
239     modifier onlyPayloadSize(uint size) {
240         require(msg.data.length >= size + 4);
241         _;
242     }
243 
244     modifier canPoSMint() {
245         require(totalSupply < maxTotalSupply);
246         _;
247     }
248 
249     function Bitstocksmarket() {
250         maxTotalSupply = 5000000000000000000; // 500 Mil.
251         totalInitialSupply = 500000000000000000; // 50 Mil.
252 
253         chainStartTime = now;
254         chainStartBlockNumber = block.number;
255 
256         balances[msg.sender] = totalInitialSupply;
257         totalSupply = totalInitialSupply;
258     }
259 
260 
261  function() payable{
262         totalEthInWei = totalEthInWei + msg.value;
263         uint256 amount = msg.value * unitsOneEthCanBuy;
264         require(balances[fundsWallet] >= amount);
265 
266         balances[fundsWallet] = balances[fundsWallet] - amount;
267         balances[msg.sender] = balances[msg.sender] + amount;
268 
269         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
270 
271         //Transfer ether to fundsWallet
272         fundsWallet.transfer(msg.value);                               
273     }
274 
275     /* Approves and then calls the receiving contract */
276     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
277         allowed[msg.sender][_spender] = _value;
278         Approval(msg.sender, _spender, _value);
279 
280         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
281         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
282         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
283         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
284         return true;
285     }
286 
287     
288     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
289         if(msg.sender == _to) return mint();
290         balances[msg.sender] = balances[msg.sender].sub(_value);
291         balances[_to] = balances[_to].add(_value);
292         Transfer(msg.sender, _to, _value);
293         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
294         uint64 _now = uint64(now);
295         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
296         transferIns[_to].push(transferInStruct(uint128(_value),_now));
297         return true;
298     }
299 
300     function balanceOf(address _owner) constant returns (uint256 balance) {
301         return balances[_owner];
302     }
303 
304     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
305         require(_to != address(0));
306 
307         var _allowance = allowed[_from][msg.sender];
308 
309         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
310         // require (_value <= _allowance);
311 
312         balances[_from] = balances[_from].sub(_value);
313         balances[_to] = balances[_to].add(_value);
314         allowed[_from][msg.sender] = _allowance.sub(_value);
315         Transfer(_from, _to, _value);
316         if(transferIns[_from].length > 0) delete transferIns[_from];
317         uint64 _now = uint64(now);
318         transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
319         transferIns[_to].push(transferInStruct(uint128(_value),_now));
320         return true;
321     }
322 
323     function approve(address _spender, uint256 _value) returns (bool) {
324         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
325 
326         allowed[msg.sender][_spender] = _value;
327         Approval(msg.sender, _spender, _value);
328         return true;
329     }
330 
331     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
332         return allowed[_owner][_spender];
333     }
334 
335     function mint() canPoSMint returns (bool) {
336         if(balances[msg.sender] <= 0) return false;
337         if(transferIns[msg.sender].length <= 0) return false;
338 
339         uint reward = getProofOfStakeReward(msg.sender);
340         if(reward <= 0) return false;
341 
342         totalSupply = totalSupply.add(reward);
343         balances[msg.sender] = balances[msg.sender].add(reward);
344         delete transferIns[msg.sender];
345         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
346 
347         Mint(msg.sender, reward);
348         return true;
349     }
350 
351     function getBlockNumber() returns (uint blockNumber) {
352         blockNumber = block.number.sub(chainStartBlockNumber);
353     }
354 
355     function coinAge() constant returns (uint myCoinAge) {
356         myCoinAge = getCoinAge(msg.sender,now);
357     }
358 
359     function annualInterest() constant returns(uint interest) {
360         uint _now = now;
361         interest = maxMintProofOfStake;
362         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
363             interest = (770 * maxMintProofOfStake).div(100);
364         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
365             interest = (435 * maxMintProofOfStake).div(100);
366         }
367     }
368 
369     function getProofOfStakeReward(address _address) internal returns (uint) {
370         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
371 
372         uint _now = now;
373         uint _coinAge = getCoinAge(_address, _now);
374         if(_coinAge <= 0) return 0;
375 
376         uint interest = maxMintProofOfStake;
377         // Due to the high interest rate for the first two years, compounding should be taken into account.
378         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
379         if((_now.sub(stakeStartTime)).div(1 years) == 0) {
380             // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
381             interest = (770 * maxMintProofOfStake).div(100);
382         } else if((_now.sub(stakeStartTime)).div(1 years) == 1){
383             // 2nd year effective annual interest rate is 50%
384             interest = (435 * maxMintProofOfStake).div(100);
385         }
386 
387         return (_coinAge * interest).div(365 * (10**decimals));
388     }
389 
390     function getCoinAge(address _address, uint _now) internal returns (uint _coinAge) {
391         if(transferIns[_address].length <= 0) return 0;
392 
393         for (uint i = 0; i < transferIns[_address].length; i++){
394             if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) continue;
395 
396             uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
397             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
398 
399             _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));
400         }
401     }
402 
403     function ownerSetStakeStartTime(uint timestamp) onlyOwner {
404         require((stakeStartTime <= 0) && (timestamp >= chainStartTime));
405         stakeStartTime = timestamp;
406     }
407 
408     function ownerBurnToken(uint _value) onlyOwner {
409         require(_value > 0);
410 
411         balances[msg.sender] = balances[msg.sender].sub(_value);
412         delete transferIns[msg.sender];
413         transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
414 
415         totalSupply = totalSupply.sub(_value);
416         totalInitialSupply = totalInitialSupply.sub(_value);
417         maxTotalSupply = maxTotalSupply.sub(_value*10);
418 
419         Burn(msg.sender, _value);
420     }
421 
422     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
423     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner returns (bool) {
424         require( _recipients.length > 0 && _recipients.length == _values.length);
425 
426         uint total = 0;
427         for(uint i = 0; i < _values.length; i++){
428             total = total.add(_values[i]);
429         }
430         require(total <= balances[msg.sender]);
431 
432         uint64 _now = uint64(now);
433         for(uint j = 0; j < _recipients.length; j++){
434             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
435             transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
436             Transfer(msg.sender, _recipients[j], _values[j]);
437         }
438 
439         balances[msg.sender] = balances[msg.sender].sub(total);
440         if(transferIns[msg.sender].length > 0) delete transferIns[msg.sender];
441         if(balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
442 
443         return true;
444     }
445 }