1 pragma solidity ^0.4.21;
2 
3 /*
4 * Team Proof of Long Hodl presents V2 the rebirth...
5 * All the goodness of POLH, now with 1% of deposits & withdrawals go into the weekly lottery.
6 * https://polh.net/
7 */
8 
9 
10 contract ProofOfLongHodlV2 {
11     using SafeMath for uint256;
12 
13     event Deposit(address user, uint amount);
14     event Withdraw(address user, uint amount);
15     event Claim(address user, uint dividends);
16     event Reinvest(address user, uint dividends);
17 
18     address owner;
19     mapping(address => bool) preauthorized;
20     bool gameStarted = true;
21 
22     uint constant depositTaxDivisor = 25;		// 25% of  deposits goes to  divs
23     uint constant withdrawalTaxDivisor = 25;	// 25% of  withdrawals goes to  divs
24     uint constant lotteryFee = 25; 				// 4% of deposits and withdrawals goes to lotteryPool
25     uint constant weeklyLotteryFee = 1; 		// 1% of deposits and withdrawals goes to weekly lotteryPool
26     
27     mapping(address => uint) public investment;
28 
29     mapping(address => uint) public stake;
30     uint public totalStake;
31     uint stakeValue;
32 
33     mapping(address => uint) dividendCredit;
34     mapping(address => uint) dividendDebit;
35 
36     function ProofOfLongHodlV2() public {
37         owner = msg.sender;
38         preauthorized[owner] = true;
39     }
40 
41     function preauthorize(address _user) public {
42         require(msg.sender == owner);
43         preauthorized[_user] = true;
44     }
45 
46     function startGame() public {
47         require(msg.sender == owner);
48         gameStarted = true;
49     }
50 
51     function depositHelper(uint _amount) private {
52     	require(_amount > 0);
53         uint _tax = _amount.mul(depositTaxDivisor).div(100);
54         uint _lotteryPool = _amount.div(lotteryFee); // add to lottery fee
55         uint _amountAfterTax = _amount.sub(_tax).sub(_lotteryPool);
56 
57         lotteryPool = lotteryPool.add(_lotteryPool);
58 
59         // check if first deposit, and greater than and make user eligable for lottery
60         if (isEligable[msg.sender] == false &&  _amount > 0.1 ether) {
61         	isEligable[msg.sender] = true;
62         	hasWithdrawed[msg.sender] = false;
63 
64         	lotteryAddresses.push(msg.sender);
65         	eligableIndex[msg.sender] = lotteryAddresses.length - 1;      	
66         }
67 
68         if (totalStake > 0)
69             stakeValue = stakeValue.add(_tax.div(totalStake));
70         uint _stakeIncrement = sqrt(totalStake.mul(totalStake).add(_amountAfterTax)).sub(totalStake);
71         investment[msg.sender] = investment[msg.sender].add(_amountAfterTax);
72         stake[msg.sender] = stake[msg.sender].add(_stakeIncrement);
73         totalStake = totalStake.add(_stakeIncrement);
74         dividendDebit[msg.sender] = dividendDebit[msg.sender].add(_stakeIncrement.mul(stakeValue));
75     }
76 
77     function deposit() public payable {
78         require(preauthorized[msg.sender] || gameStarted);
79         depositHelper(msg.value);
80         emit Deposit(msg.sender, msg.value);
81     }
82 
83     function withdraw(uint _amount) public {
84         require(_amount > 0);
85         require(_amount <= investment[msg.sender]);
86         uint _tax = _amount.mul(withdrawalTaxDivisor).div(100);
87         uint _lotteryPool = _amount.div(lotteryFee); // add to lottery fee
88         uint _amountAfterTax = _amount.sub(_tax).sub(_lotteryPool);
89 
90         lotteryPool = lotteryPool.add(_lotteryPool);
91 
92         // removing user from lotteryAddresses if it is first withdraw
93         if (lotteryAddresses.length != 0 && !hasWithdrawed[msg.sender] ) {
94         	hasWithdrawed[msg.sender] = true;
95         	isEligable[msg.sender] = false;
96         	totalWithdrawals = totalWithdrawals.add(_amountAfterTax);
97         	withdrawalsCTR++;
98 
99         	// delete user from lottery addresses index to delete
100         	uint indexToDelete = eligableIndex[msg.sender]; 
101         	address lastAddress = lotteryAddresses[lotteryAddresses.length - 1];
102         	lotteryAddresses[indexToDelete] = lastAddress;
103         	lotteryAddresses.length--;
104 
105         	eligableIndex[lastAddress] = indexToDelete;
106         	eligableIndex[msg.sender] = 0;
107 
108         	if (withdrawalsCTR > 9 && totalWithdrawals > 1 ether) {
109         		// pick lottery winner and sent reward
110 			    uint256 winnerIndex = rand(lotteryAddresses.length);
111 			    address winner = lotteryAddresses[winnerIndex];
112 
113 			    winner.transfer(lotteryPool);
114 			    totalWithdrawals = 0;
115 			    withdrawalsCTR = 0;
116 			    lotteryPool = 0;
117 			    lotteryRound++;
118 			    lastWinner = winner;
119         	}
120         }
121 
122         uint _stakeDecrement = stake[msg.sender].mul(_amount).div(investment[msg.sender]);
123         uint _dividendCredit = _stakeDecrement.mul(stakeValue);
124         investment[msg.sender] = investment[msg.sender].sub(_amount);
125         stake[msg.sender] = stake[msg.sender].sub(_stakeDecrement);
126         totalStake = totalStake.sub(_stakeDecrement);
127         if (totalStake > 0)
128             stakeValue = stakeValue.add(_tax.div(totalStake));
129         dividendCredit[msg.sender] = dividendCredit[msg.sender].add(_dividendCredit);
130         uint _creditDebitCancellation = min(dividendCredit[msg.sender], dividendDebit[msg.sender]);
131         dividendCredit[msg.sender] = dividendCredit[msg.sender].sub(_creditDebitCancellation);
132         dividendDebit[msg.sender] = dividendDebit[msg.sender].sub(_creditDebitCancellation);
133 
134         msg.sender.transfer(_amountAfterTax);
135         emit Withdraw(msg.sender, _amount);
136     }
137 
138     function claimHelper() private returns(uint) {
139         uint _dividendsForStake = stake[msg.sender].mul(stakeValue);
140         uint _dividends = _dividendsForStake.add(dividendCredit[msg.sender]).sub(dividendDebit[msg.sender]);
141         dividendCredit[msg.sender] = 0;
142         dividendDebit[msg.sender] = _dividendsForStake;
143 
144         return _dividends;
145     }
146 
147     function claim() public {
148         uint _dividends = claimHelper();
149         msg.sender.transfer(_dividends);
150 
151         emit Claim(msg.sender, _dividends);
152     }
153 
154     function reinvest() public {
155         uint _dividends = claimHelper();
156         depositHelper(_dividends);
157 
158         emit Reinvest(msg.sender, _dividends);
159     }
160 
161     function dividendsForUser(address _user) public view returns (uint) {
162         return stake[_user].mul(stakeValue).add(dividendCredit[_user]).sub(dividendDebit[_user]);
163     }
164 
165     function min(uint x, uint y) private pure returns (uint) {
166         return x <= y ? x : y;
167     }
168 
169     function sqrt(uint x) private pure returns (uint y) {
170         uint z = (x + 1) / 2;
171         y = x;
172         while (z < y) {
173             y = z;
174             z = (x / z + z) / 2;
175         }
176     }
177 
178     // LOTTERY MODULE
179     uint private lotteryPool = 0;
180     uint private lotteryRound = 1;
181     address private lastWinner;
182 
183     uint public withdrawalsCTR = 0;
184     uint public totalWithdrawals = 0;
185 
186     mapping(address => uint256) internal eligableIndex; // 
187     mapping(address => bool) internal isEligable; // for first deposit check
188     mapping(address => bool) internal hasWithdrawed; // check if user already withdrawed
189 
190     address[] public lotteryAddresses;
191 
192     // Generate random number between 0 & max
193     uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;
194     function rand(uint max) constant public returns (uint256 result){
195         uint256 factor = FACTOR * 100 / max;
196         uint256 lastBlockNumber = block.number - 1;
197         uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
198     
199         return uint256((uint256(hashVal) / factor)) % max;
200     }
201 
202     // check if address is withdrawed
203     function checkIfEligable(address _address) public view returns (bool) {
204     	return (isEligable[_address] && !hasWithdrawed[_address]) ;
205     }
206 
207     function getLotteryData() public view returns( uint256, uint256, address) {
208     	return (lotteryPool, lotteryRound, lastWinner);
209     }
210 
211     function lotteryParticipants() public view returns(uint256) {
212     	return lotteryAddresses.length;
213     }
214         modifier onlyOwner() {
215         require(msg.sender == owner);
216         _;
217     }
218     
219     function closeGame() onlyOwner public {
220         uint256 etherBalance = this.balance;
221         owner.transfer(etherBalance);
222     }
223     
224 }
225 
226 /**
227  * @title SafeMath
228  * @dev Math operations with safety checks that throw on error
229  */
230 library SafeMath {
231 
232     /**
233     * @dev Multiplies two numbers, throws on overflow.
234     */
235     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
236         if (a == 0) {
237             return 0;                                                                                                                                                                                       
238         }
239         uint256 c = a * b;                                                                                                                                                                                  
240         assert(c / a == b);                                                                                                                                                                                 
241         return c;                                                                                                                                                                                           
242     }
243 
244     /**
245     * @dev Integer division of two numbers, truncating the quotient.
246     */
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         // assert(b > 0); // Solidity automatically throws when dividing by 0                                                                                                                               
249         // uint256 c = a / b;                                                                                                                                                                               
250         // assert(a == b * c + a % b); // There is no case in which this doesn't hold                                                                                                                       
251         return a / b;                                                                                                                                                                                       
252     }
253 
254     /**
255     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
256     */
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         assert(b <= a);                                                                                                                                                                                     
259         return a - b;                                                                                                                                                                                       
260     }
261 
262     /**
263     * @dev Adds two numbers, throws on overflow.
264     */
265     function add(uint256 a, uint256 b) internal pure returns (uint256) {
266         uint256 c = a + b;                                                                                                                                                                                  
267         assert(c >= a);                                                                                                                                                                                     
268         return c;                                                                                                                                                                                           
269     }
270 }