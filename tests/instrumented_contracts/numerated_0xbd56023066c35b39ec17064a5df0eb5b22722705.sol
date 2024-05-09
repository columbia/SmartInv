1 pragma solidity ^0.4.21;
2 
3 
4 /*
5 * https://proof-of-stable-clone.com/
6 * Contract is **live** in one hour
7 * Deposit to buy in.
8 * Reinvest to reinvest.
9 * Claim to withdraw dividends.
10 * Withdraw to sell.
11 */
12 
13 contract ProofOfStableClone {
14     using SafeMath for uint256;
15    
16     
17     event Deposit(address user, uint amount);
18     event Withdraw(address user, uint amount);
19     event Claim(address user, uint dividends);
20     event Reinvest(address user, uint dividends);
21 
22     bool gameStarted = true;
23 
24     uint constant depositTaxDivisor = 4;
25     uint constant withdrawalTaxDivisor = 11;
26 
27     mapping(address => uint) public investment;
28    
29      address owner = msg.sender;
30 
31     mapping(address => uint) public stake;
32     uint public totalStake;
33     uint stakeValue;
34 
35     mapping(address => uint) dividendCredit;
36     mapping(address => uint) dividendDebit;
37 
38     function ProofOfStableClone() public {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner(){
43         require(msg.sender == owner );
44         _;
45     }
46 
47     function startGame() public onlyOwner {
48         gameStarted = true;
49     }
50 
51     function depositHelper(uint _amount) private {
52         uint _tax = _amount.div(depositTaxDivisor);
53         uint _amountAfterTax = _amount.sub(_tax);
54         if (totalStake > 0)
55             stakeValue = stakeValue.add(_tax.div(totalStake));
56         uint _stakeIncrement = sqrt(totalStake.mul(totalStake).add(_amountAfterTax)).sub(totalStake);
57         investment[msg.sender] = investment[msg.sender].add(_amountAfterTax);
58         stake[msg.sender] = stake[msg.sender].add(_stakeIncrement);
59         totalStake = totalStake.add(_stakeIncrement);
60         dividendDebit[msg.sender] = dividendDebit[msg.sender].add(_stakeIncrement.mul(stakeValue));
61     }
62 
63     function deposit() public payable {
64         require(gameStarted);
65         depositHelper(msg.value);
66         emit Deposit(msg.sender, msg.value);
67     }
68 
69     function withdraw(uint _amount) public {
70         require(_amount > 0);
71         require(_amount <= investment[msg.sender]);
72         uint _tax = _amount.div(withdrawalTaxDivisor);
73         uint _amountAfterTax = _amount.sub(_tax);
74         uint _stakeDecrement = stake[msg.sender].mul(_amount).div(investment[msg.sender]);
75         uint _dividendCredit = _stakeDecrement.mul(stakeValue);
76         investment[msg.sender] = investment[msg.sender].sub(_amount);
77         stake[msg.sender] = stake[msg.sender].sub(_stakeDecrement);
78         totalStake = totalStake.sub(_stakeDecrement);
79         if (totalStake > 0)
80             stakeValue = stakeValue.add(_tax.div(totalStake));
81         dividendCredit[msg.sender] = dividendCredit[msg.sender].add(_dividendCredit);
82         uint _creditDebitCancellation = min(dividendCredit[msg.sender], dividendDebit[msg.sender]);
83         dividendCredit[msg.sender] = dividendCredit[msg.sender].sub(_creditDebitCancellation);
84         dividendDebit[msg.sender] = dividendDebit[msg.sender].sub(_creditDebitCancellation);
85         owner.transfer(_amountAfterTax);
86         emit Withdraw(msg.sender, _amount);
87     }
88 
89     function claimHelper() private returns(uint) {
90         uint _dividendsForStake = stake[msg.sender].mul(stakeValue);
91         uint _dividends = _dividendsForStake.add(dividendCredit[msg.sender]).sub(dividendDebit[msg.sender]);
92         dividendCredit[msg.sender] = 0;
93         dividendDebit[msg.sender] = _dividendsForStake;
94         return _dividends;
95     }
96 
97     function claim() public {
98         uint _dividends = claimHelper();
99         owner.transfer(_dividends);
100         emit Claim(msg.sender, _dividends);
101     }
102 
103     function reinvest() public {
104         uint _dividends = claimHelper();
105         depositHelper(_dividends);
106         emit Reinvest(owner, _dividends);
107     }
108 
109     function dividendsForUser(address _user) public view returns (uint) {
110         return stake[_user].mul(stakeValue).add(dividendCredit[_user]).sub(dividendDebit[_user]);
111     }
112 
113     function min(uint x, uint y) private pure returns (uint) {
114         return x <= y ? x : y;
115     }
116 
117     function sqrt(uint x) private pure returns (uint y) {
118         uint z = (x + 1) / 2;
119         y = x;
120         while (z < y) {
121             y = z;
122             z = (x / z + z) / 2;
123         }
124     }
125 
126       
127     function closeGame() onlyOwner public {
128         uint256 etherBalance = this.balance;
129         owner.transfer(etherBalance);
130     }
131 }
132 
133 /**
134  * @title SafeMath
135  * @dev Math operations with safety checks that throw on error
136  */
137 library SafeMath {
138 
139     /**
140     * @dev Multiplies two numbers, throws on overflow.
141     */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         if (a == 0) {
144             return 0;                                                                                                                                                                                       
145         }
146         uint256 c = a * b;                                                                                                                                                                                  
147         assert(c / a == b);                                                                                                                                                                                 
148         return c;                                                                                                                                                                                           
149     }
150 
151     /**
152     * @dev Integer division of two numbers, truncating the quotient.
153     */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         // assert(b > 0); // Solidity automatically throws when dividing by 0                                                                                                                               
156         // uint256 c = a / b;                                                                                                                                                                               
157         // assert(a == b * c + a % b); // There is no case in which this doesn't hold                                                                                                                       
158         return a / b;                                                                                                                                                                                       
159     }
160 
161     /**
162     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
163     */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         assert(b <= a);                                                                                                                                                                                     
166         return a - b;                                                                                                                                                                                       
167     }
168 
169     /**
170     * @dev Adds two numbers, throws on overflow.
171     */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 c = a + b;                                                                                                                                                                                  
174         assert(c >= a);                                                                                                                                                                                     
175         return c;                                                                                                                                                                                           
176     }
177 }