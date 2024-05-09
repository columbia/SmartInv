1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team Proof of Long Hodl presents..
5 */
6 
7 pragma solidity ^0.4.21;
8 
9 contract ProofOfLongHodl {
10     using SafeMath for uint256;
11 
12     event Deposit(address user, uint amount);
13     event Withdraw(address user, uint amount);
14     event Claim(address user, uint dividends);
15     event Reinvest(address user, uint dividends);
16 
17     address owner;
18     mapping(address => bool) preauthorized;
19     bool gameStarted;
20 
21     uint constant depositTaxDivisor = 29;		// 29% of  deposits goes to  divs
22     uint constant withdrawalTaxDivisor = 29;	// 29% of  withdrawals goes to  divs
23     uint constant lotteryFee = 25; 				// 4% of deposits and withdrawals goes to lotteryPool
24 
25     mapping(address => uint) public investment;
26 
27     mapping(address => uint) public stake;
28     uint public totalStake;
29     uint stakeValue;
30 
31     mapping(address => uint) dividendCredit;
32     mapping(address => uint) dividendDebit;
33 
34     function ProofOfLongHodl() public {
35         owner = msg.sender;
36         preauthorized[owner] = true;
37     }
38 
39     function preauthorize(address _user) public {
40         require(msg.sender == owner);
41         preauthorized[_user] = true;
42     }
43 
44     function startGame() public {
45         require(msg.sender == owner);
46         gameStarted = true;
47     }
48 
49     function depositHelper(uint _amount) private {
50     	require(_amount > 0);
51         uint _tax = _amount.mul(depositTaxDivisor).div(100);
52         uint _lotteryPool = _amount.div(lotteryFee); // add to lottery fee
53         uint _amountAfterTax = _amount.sub(_tax).sub(_lotteryPool);
54 
55         lotteryPool = lotteryPool.add(_lotteryPool);
56 
57         // check if first deposit, and greater than and make user eligable for lottery
58         if (isEligable[msg.sender] == false &&  _amount > 0.1 ether) {
59         	isEligable[msg.sender] = true;
60         	hasWithdrawed[msg.sender] = false;
61 
62         	lotteryAddresses.push(msg.sender);
63         	eligableIndex[msg.sender] = lotteryAddresses.length - 1;      	
64         }
65 
66         if (totalStake > 0)
67             stakeValue = stakeValue.add(_tax.div(totalStake));
68         uint _stakeIncrement = sqrt(totalStake.mul(totalStake).add(_amountAfterTax)).sub(totalStake);
69         investment[msg.sender] = investment[msg.sender].add(_amountAfterTax);
70         stake[msg.sender] = stake[msg.sender].add(_stakeIncrement);
71         totalStake = totalStake.add(_stakeIncrement);
72         dividendDebit[msg.sender] = dividendDebit[msg.sender].add(_stakeIncrement.mul(stakeValue));
73     }
74 
75     function deposit() public payable {
76         require(preauthorized[msg.sender] || gameStarted);
77         depositHelper(msg.value);
78         emit Deposit(msg.sender, msg.value);
79     }
80 
81     function withdraw(uint _amount) public {
82         require(_amount > 0);
83         require(_amount <= investment[msg.sender]);
84         uint _tax = _amount.mul(withdrawalTaxDivisor).div(100);
85         uint _lotteryPool = _amount.div(lotteryFee); // add to lottery fee
86         uint _amountAfterTax = _amount.sub(_tax).sub(_lotteryPool);
87 
88         lotteryPool = lotteryPool.add(_lotteryPool);
89 
90         // removing user from lotteryAddresses if it is first withdraw
91         if (lotteryAddresses.length != 0 && !hasWithdrawed[msg.sender] ) {
92         	hasWithdrawed[msg.sender] = true;
93         	isEligable[msg.sender] = false;
94         	totalWithdrawals = totalWithdrawals.add(_amountAfterTax);
95         	withdrawalsCTR++;
96 
97         	// delete user from lottery addresses index to delete
98         	uint indexToDelete = eligableIndex[msg.sender]; 
99         	address lastAddress = lotteryAddresses[lotteryAddresses.length - 1];
100         	lotteryAddresses[indexToDelete] = lastAddress;
101         	lotteryAddresses.length--;
102 
103         	eligableIndex[lastAddress] = indexToDelete;
104         	eligableIndex[msg.sender] = 0;
105 
106         	if (withdrawalsCTR > 9 && totalWithdrawals > 1 ether) {
107         		// pick lottery winner and sent reward
108 			    uint256 winnerIndex = rand(lotteryAddresses.length);
109 			    address winner = lotteryAddresses[winnerIndex];
110 
111 			    winner.transfer(lotteryPool);
112 			    totalWithdrawals = 0;
113 			    withdrawalsCTR = 0;
114 			    lotteryPool = 0;
115 			    lotteryRound++;
116 			    lastWinner = winner;
117         	}
118         }
119 
120         uint _stakeDecrement = stake[msg.sender].mul(_amount).div(investment[msg.sender]);
121         uint _dividendCredit = _stakeDecrement.mul(stakeValue);
122         investment[msg.sender] = investment[msg.sender].sub(_amount);
123         stake[msg.sender] = stake[msg.sender].sub(_stakeDecrement);
124         totalStake = totalStake.sub(_stakeDecrement);
125         if (totalStake > 0)
126             stakeValue = stakeValue.add(_tax.div(totalStake));
127         dividendCredit[msg.sender] = dividendCredit[msg.sender].add(_dividendCredit);
128         uint _creditDebitCancellation = min(dividendCredit[msg.sender], dividendDebit[msg.sender]);
129         dividendCredit[msg.sender] = dividendCredit[msg.sender].sub(_creditDebitCancellation);
130         dividendDebit[msg.sender] = dividendDebit[msg.sender].sub(_creditDebitCancellation);
131 
132         msg.sender.transfer(_amountAfterTax);
133         emit Withdraw(msg.sender, _amount);
134     }
135 
136     function claimHelper() private returns(uint) {
137         uint _dividendsForStake = stake[msg.sender].mul(stakeValue);
138         uint _dividends = _dividendsForStake.add(dividendCredit[msg.sender]).sub(dividendDebit[msg.sender]);
139         dividendCredit[msg.sender] = 0;
140         dividendDebit[msg.sender] = _dividendsForStake;
141 
142         return _dividends;
143     }
144 
145     function claim() public {
146         uint _dividends = claimHelper();
147         msg.sender.transfer(_dividends);
148 
149         emit Claim(msg.sender, _dividends);
150     }
151 
152     function reinvest() public {
153         uint _dividends = claimHelper();
154         depositHelper(_dividends);
155 
156         emit Reinvest(msg.sender, _dividends);
157     }
158 
159     function dividendsForUser(address _user) public view returns (uint) {
160         return stake[_user].mul(stakeValue).add(dividendCredit[_user]).sub(dividendDebit[_user]);
161     }
162 
163     function min(uint x, uint y) private pure returns (uint) {
164         return x <= y ? x : y;
165     }
166 
167     function sqrt(uint x) private pure returns (uint y) {
168         uint z = (x + 1) / 2;
169         y = x;
170         while (z < y) {
171             y = z;
172             z = (x / z + z) / 2;
173         }
174     }
175 
176     // LOTTERY MODULE
177     uint private lotteryPool = 0;
178     uint private lotteryRound = 1;
179     address private lastWinner;
180 
181     uint public withdrawalsCTR = 0;
182     uint public totalWithdrawals = 0;
183 
184     mapping(address => uint256) internal eligableIndex; // 
185     mapping(address => bool) internal isEligable; // for first deposit check
186     mapping(address => bool) internal hasWithdrawed; // check if user already withdrawed
187 
188     address[] public lotteryAddresses;
189 
190     // Generate random number between 0 & max
191     uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;
192     function rand(uint max) constant public returns (uint256 result){
193         uint256 factor = FACTOR * 100 / max;
194         uint256 lastBlockNumber = block.number - 1;
195         uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
196     
197         return uint256((uint256(hashVal) / factor)) % max;
198     }
199 
200     // check if address is withdrawed
201     function checkIfEligable(address _address) public view returns (bool) {
202     	return (isEligable[_address] && !hasWithdrawed[_address]) ;
203     }
204 
205     function getLotteryData() public view returns( uint256, uint256, address) {
206     	return (lotteryPool, lotteryRound, lastWinner);
207     }
208 
209     function lotteryParticipants() public view returns(uint256) {
210     	return lotteryAddresses.length;
211     }
212     
213 }
214 
215 /**
216  * @title SafeMath
217  * @dev Math operations with safety checks that throw on error
218  */
219 library SafeMath {
220 
221     /**
222     * @dev Multiplies two numbers, throws on overflow.
223     */
224     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
225         if (a == 0) {
226             return 0;                                                                                                                                                                                       
227         }
228         uint256 c = a * b;                                                                                                                                                                                  
229         assert(c / a == b);                                                                                                                                                                                 
230         return c;                                                                                                                                                                                           
231     }
232 
233     /**
234     * @dev Integer division of two numbers, truncating the quotient.
235     */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         // assert(b > 0); // Solidity automatically throws when dividing by 0                                                                                                                               
238         // uint256 c = a / b;                                                                                                                                                                               
239         // assert(a == b * c + a % b); // There is no case in which this doesn't hold                                                                                                                       
240         return a / b;                                                                                                                                                                                       
241     }
242 
243     /**
244     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
245     */
246     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
247         assert(b <= a);                                                                                                                                                                                     
248         return a - b;                                                                                                                                                                                       
249     }
250 
251     /**
252     * @dev Adds two numbers, throws on overflow.
253     */
254     function add(uint256 a, uint256 b) internal pure returns (uint256) {
255         uint256 c = a + b;                                                                                                                                                                                  
256         assert(c >= a);                                                                                                                                                                                     
257         return c;                                                                                                                                                                                           
258     }
259 }