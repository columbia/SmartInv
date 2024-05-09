1 pragma solidity 0.4.20;
2 
3 
4 contract WhoVote {
5 
6     mapping (address => bytes32) public voteHash;
7     address public parentContract;
8     uint public deadline;
9 
10     modifier isActive {
11         require(now < deadline);
12         _;
13     }
14 
15     modifier isParent {
16         require(msg.sender == parentContract);
17         _;
18     }
19 
20     function WhoVote(address _parentContract, uint timespan) public {
21         parentContract = _parentContract;
22         deadline = now + timespan;
23     }
24 
25     /**
26     * @dev Recieve Vote from Who-Token-Contract
27     * @param _sender Contest-participant
28     * @param _hash Hash of the JSON-Parameter
29     */
30     function recieveVote(address _sender, bytes32 _hash) public isActive isParent returns (bool) {
31         require(voteHash[_sender] == 0);
32         voteHash[_sender] = _hash;
33         return true;
34     }
35 
36 
37 }
38 
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         assert(c / a == b);
55         return c;
56     }
57 
58     /**
59     * @dev Integer division of two numbers, truncating the quotient.
60     */
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62       // assert(b > 0); // Solidity automatically throws when dividing by 0
63         uint256 c = a / b;
64       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65         return c;
66     }
67 
68     /**
69     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
70     */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         assert(b <= a);
73         return a - b;
74     }
75 
76     /**
77     * @dev Adds two numbers, throws on overflow.
78     */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         assert(c >= a);
82         return c;
83     }
84 }
85 /**
86  * @title ERC20Basic
87  * @dev Simpler version of ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/179
89  */
90 contract ERC20Interface {
91     function circulatingSupply() public view returns (uint);
92     function balanceOf(address who) public view returns (uint);
93     function transfer(address to, uint value) public returns (bool);
94     event TransferEvent(address indexed from, address indexed to, uint value);
95 }
96 
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract StandardToken is ERC20Interface {
103     using SafeMath for uint;
104 
105     uint public maxSupply;
106     uint public totalSupply;
107     uint public timestampMint;
108     uint public timestampRelease;
109     uint8 public decimals;
110 
111     string public symbol;
112     string public  name;
113 
114     address public owner;
115 
116     bool public stopped;
117 
118     mapping(address => uint) public balanceOf;
119     mapping (address => uint) public permissonedAccounts;
120 
121     /**
122     * @dev Checks if last mint is 3 weeks in past
123     */
124     modifier onlyAfter() {
125         require(now >= timestampMint + 3 weeks);
126         _;
127     }
128 
129     /**
130     * @dev Checks if last mint is 3 weeks in past
131     */
132     modifier isActive() {
133         require(!stopped);
134         _;
135     }
136 
137     /**
138     * @dev Checks if account has staff-level
139     */
140     modifier hasPermission(uint _level) {
141         require(permissonedAccounts[msg.sender] > 0);
142         require(permissonedAccounts[msg.sender] <= _level);
143         _;
144     }
145 
146     /**
147     * @dev total number of tokens in existence
148     */
149     function circulatingSupply() public view returns (uint) {
150         return totalSupply;
151     }
152 
153     /**
154     * @dev Gets balance of address
155     * @param _owner The address to query the the balance of.
156     * @return An uint representing the amount owned by the passed address.
157     */
158     function balanceOf(address _owner) public view returns (uint balance) {
159         return balanceOf[_owner];
160     }
161 
162     /**
163     * @dev Token-transfer from msg.sender to address
164     * @param _to target-address
165     * @param _value amount of WHO transfered
166     */
167     function transfer(address _to, uint _value) public isActive returns (bool) {
168         require(_to != address(0));
169         require(_value <= balanceOf[msg.sender]);
170         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
171         balanceOf[_to] = balanceOf[_to].add(_value);
172         TransferEvent(msg.sender, _to, _value);
173         return true;
174     }
175 }
176 
177 
178 /**
179  * @title The Who-Token by WhoHas v1.2
180  * @author Felix Leber, Christian Siegert
181  * @dev Special version of the ERC20 Token
182  */
183 contract Who is StandardToken {
184 
185     mapping (address => uint) public votings_;
186     mapping (address => uint8) public icoAccounts;
187     address public prizePool;
188     uint public icoPool;
189     uint public raisedIcoValue;
190     uint public maxMint;
191 
192 
193     event WinningEvent(address[] winner, address contest, uint payoutValue);
194     event VotingStarted(address _voting, uint _duration, uint _costPerVote);
195     event ParticipatedInVoting(address _sender, address _votingContract, bytes32 _hash, uint _voteAmount);
196 
197     modifier icoPhase() {
198         require(now >= timestampRelease);
199         require(now <= 3 weeks + timestampRelease);
200         require(msg.value >= 2*(10**16));
201         _;
202 
203     }
204 
205     function Who() public {
206         owner = 0x4c556b28A7D62D3b7A84481521308fbb9687f38F;
207 
208         name = "WhoHas";
209         symbol = "WHO";
210         decimals = 18;
211 
212         permissonedAccounts[owner] = 1;
213         permissonedAccounts[0x3090Ee894719222DCE4d231d735741B2d44f30ba] = 1;
214         timestampRelease = now + 6 hours + 40 minutes;
215 
216         balanceOf[owner] = 150000000*(10**18); //150 Millionen
217         icoPool = 100000000*(10**18); //100 Millionen
218         maxSupply = 1500000000*(10**18); //1,5 Billion
219         maxMint = 150000*(10**18); //150 k
220         totalSupply = totalSupply.add(balanceOf[owner]); //250 Million
221 
222         stopped = false;
223     }
224 
225     /**
226     * @dev Buy option during ICO, payable
227     * @notice Please make sure that ICO Pool is at least equal to your bid
228     */
229     function icoBuy() public icoPhase() payable isActive {
230         prizePool.transfer(msg.value);
231         raisedIcoValue = raisedIcoValue.add(msg.value);
232         uint256 tokenAmount = calculateTokenAmountICO(msg.value);
233 
234         require(icoPool >= tokenAmount);
235 
236         icoPool = icoPool.sub(tokenAmount);
237         balanceOf[msg.sender] += tokenAmount;
238         TransferEvent(prizePool, msg.sender, tokenAmount);
239         totalSupply = totalSupply.add(tokenAmount);
240     }
241 
242     /**
243     * @dev Calculation of Token Ratio in ICO
244     * @param _etherAmount Amount in Ether in order to be spent on WHO Token
245     */
246     function calculateTokenAmountICO(uint256 _etherAmount) public icoPhase constant returns(uint256) {
247           // ICO standard rate: 1 ETH : 3315 WHO - 0,20 Euro
248           // ICO Phase 1:   1 ETH : 4420 WHO - 0,15 Euro
249         if (now <= 10 days + timestampRelease) {
250             require(icoAccounts[msg.sender] == 1);
251             return _etherAmount.mul(4420);
252         } else {
253             require(icoAccounts[msg.sender] == 2);
254             return _etherAmount.mul(3315);
255         }
256     }
257 
258     /**
259     * @dev Set/Unset address as permissioned
260     */
261     function killToken() public isActive hasPermission(1) {
262         stopped = true;
263     }
264 
265     /**
266     * @dev Set/Unset address as permissioned
267     * @param _account The address to give/take away the permissiones.
268     * @param _level Permission-Level: 7:none, 1: owner, 2: admin, 3: pyFactory
269     */
270     function updatePermissions(address _account, uint _level) public isActive hasPermission(1) {
271         require(_level != 1 && msg.sender != _account);
272         permissonedAccounts[_account] = _level;
273     }
274 
275     /**
276     * @dev Update Address recieving & distributing tokens in votings
277     * @param _account Address of the new prize Pool
278     */
279     function updatePrizePool(address _account) public isActive hasPermission(1) {
280         prizePool = _account;
281     }
282 
283     /**
284     * @dev Increases totalSupply by specified amount. Available every three weeks until maxSupply is reached.
285     * @param _mintAmount Amount of increase, must be smaller than 100000000
286     */
287     function mint(uint _mintAmount) public onlyAfter isActive hasPermission(2) {
288         require(_mintAmount <= maxMint);
289         require(totalSupply + _mintAmount <= maxSupply);
290         balanceOf[owner] = balanceOf[owner].add(_mintAmount);
291         totalSupply = totalSupply.add(_mintAmount);
292         timestampMint = now;
293     }
294 
295     function registerForICO(address[] _icoAddresses, uint8 _level) public isActive hasPermission(3) {
296         for (uint i = 0; i < _icoAddresses.length; i++) {
297             icoAccounts[_icoAddresses[i]] = _level;
298         }
299     }
300 
301     /**
302     * @dev Manually add an existing WhoVote contract
303     * @param _timespan Amount of time the contract is valid
304     * @param _votePrice Price in Who(x10^18) per Vote
305     */
306     function gernerateVoting(uint _timespan, uint _votePrice) public isActive hasPermission(3) {
307         require(_votePrice > 0 && _timespan > 0);
308         address generatedVoting = new WhoVote(this, _timespan);
309         votings_[generatedVoting] = _votePrice;
310         VotingStarted(generatedVoting, _timespan, _votePrice);
311     }
312 
313     /**
314     * @dev Manually add an existing WhoVote contract
315     * @param _votingContract Adress of Voting-Contrac
316     * @param _votePrice Price in Who(x10^18) per Vote
317     */
318     function addVoting(address _votingContract, uint _votePrice) public isActive hasPermission(3) {
319         votings_[_votingContract] = _votePrice;
320     }
321 
322     /**
323     * @dev Disable voting
324     * @param _votingContract Adress of Voting-Contract
325     */
326     function finalizeVoting(address _votingContract) public isActive hasPermission(3) {
327         votings_[_votingContract] = 0;
328     }
329 
330     /**
331     * @dev PyFactory payout of winner
332     * @param _winner Account which paricipated in the voting
333     * @param _payoutValue Amount of Who payed to the winning account
334     * @param _votingAddress Address of the Voting-Contract
335     */
336     function payout(address[] _winner, uint _payoutValue, address _votingAddress) public isActive hasPermission(3) {
337         for (uint i = 0; i < _winner.length; i++) {
338             transfer(_winner[i], _payoutValue);
339         }
340         WinningEvent(_winner, _votingAddress, _payoutValue);
341     }
342 
343     /**
344     * @dev Participating in a Voting
345     * @param _votingContract Adress of Voting-Contract
346     * @param _hash Hash of the JSON-Parameter
347     * @param _quantity Quantity of Votes
348     */
349     function payForVote(address _votingContract, bytes32 _hash, uint _quantity) public isActive {
350         require(_quantity >= 1 && _quantity <= 5);
351         uint votePrice = votings_[_votingContract];
352         require(votePrice > 0);
353         transfer(prizePool, _quantity.mul(votePrice));
354         sendVote(_votingContract, msg.sender, _hash);
355         ParticipatedInVoting(msg.sender, _votingContract, _hash, _quantity);
356     }
357 
358     /**
359     * @dev [Internal] Send vote to Voting-Contract
360     * @param _contract Address of Voting-Contract
361     * @param _sender Sender of Votes
362     * @param _hash Hash of the JSON-Parameter
363     */
364     function sendVote(address _contract, address _sender, bytes32 _hash) private returns (bool) {
365         return WhoVote(_contract).recieveVote(_sender, _hash);
366     }
367 
368 }