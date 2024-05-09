1 pragma solidity ^0.4.21;
2 
3 contract ProofOfStableCoin {
4     using SafeMath for uint256;
5 
6     event Deposit(address user, uint amount);
7     event Withdraw(address user, uint amount);
8     event Claim(address user, uint dividends);
9     event Reinvest(address user, uint dividends);
10 
11     address owner;
12     mapping(address => bool) preauthorized;
13     bool gameStarted;
14 
15     uint constant depositTaxDivisor = 3;
16     uint constant withdrawalTaxDivisor = 3;
17 
18     mapping(address => uint) public investment;
19 
20     mapping(address => uint) public stake;
21     uint public totalStake;
22     uint stakeValue;
23 
24     mapping(address => uint) dividendCredit;
25     mapping(address => uint) dividendDebit;
26 
27     function ProofOfStableCoin() public {
28         owner = msg.sender;
29         preauthorized[owner] = true;
30     }
31 
32     function preauthorize(address _user) public {
33         require(msg.sender == owner);
34         preauthorized[_user] = true;
35     }
36 
37     function startGame() public {
38         require(msg.sender == owner);
39         gameStarted = true;
40     }
41 
42     function depositHelper(uint _amount) private {
43         uint _tax = _amount.div(depositTaxDivisor);
44         uint _amountAfterTax = _amount.sub(_tax);
45         if (totalStake > 0)
46             stakeValue = stakeValue.add(_tax.div(totalStake));
47         uint _stakeIncrement = sqrt(totalStake.mul(totalStake).add(_amountAfterTax)).sub(totalStake);
48         investment[msg.sender] = investment[msg.sender].add(_amountAfterTax);
49         stake[msg.sender] = stake[msg.sender].add(_stakeIncrement);
50         totalStake = totalStake.add(_stakeIncrement);
51         dividendDebit[msg.sender] = dividendDebit[msg.sender].add(_stakeIncrement.mul(stakeValue));
52     }
53 
54     function deposit() public payable {
55         require(preauthorized[msg.sender] || gameStarted);
56         depositHelper(msg.value);
57         emit Deposit(msg.sender, msg.value);
58     }
59 
60     function withdraw(uint _amount) public {
61         require(_amount > 0);
62         require(_amount <= investment[msg.sender]);
63         uint _tax = _amount.div(withdrawalTaxDivisor);
64         uint _amountAfterTax = _amount.sub(_tax);
65         uint _stakeDecrement = stake[msg.sender].mul(_amount).div(investment[msg.sender]);
66         uint _dividendCredit = _stakeDecrement.mul(stakeValue);
67         investment[msg.sender] = investment[msg.sender].sub(_amount);
68         stake[msg.sender] = stake[msg.sender].sub(_stakeDecrement);
69         totalStake = totalStake.sub(_stakeDecrement);
70         if (totalStake > 0)
71             stakeValue = stakeValue.add(_tax.div(totalStake));
72         dividendCredit[msg.sender] = dividendCredit[msg.sender].add(_dividendCredit);
73         uint _creditDebitCancellation = min(dividendCredit[msg.sender], dividendDebit[msg.sender]);
74         dividendCredit[msg.sender] = dividendCredit[msg.sender].sub(_creditDebitCancellation);
75         dividendDebit[msg.sender] = dividendDebit[msg.sender].sub(_creditDebitCancellation);
76         msg.sender.transfer(_amountAfterTax);
77         emit Withdraw(msg.sender, _amount);
78     }
79 
80     function claimHelper() private returns(uint) {
81         uint _dividendsForStake = stake[msg.sender].mul(stakeValue);
82         uint _dividends = _dividendsForStake.add(dividendCredit[msg.sender]).sub(dividendDebit[msg.sender]);
83         dividendCredit[msg.sender] = 0;
84         dividendDebit[msg.sender] = _dividendsForStake;
85         return _dividends;
86     }
87 
88     function claim() public {
89         uint _dividends = claimHelper();
90         msg.sender.transfer(_dividends);
91         emit Claim(msg.sender, _dividends);
92     }
93 
94     function reinvest() public {
95         uint _dividends = claimHelper();
96         depositHelper(_dividends);
97         emit Reinvest(msg.sender, _dividends);
98     }
99 
100     function dividendsForUser(address _user) public view returns (uint) {
101         return stake[_user].mul(stakeValue).add(dividendCredit[_user]).sub(dividendDebit[_user]);
102     }
103 
104     function min(uint x, uint y) private pure returns (uint) {
105         return x <= y ? x : y;
106     }
107 
108     function sqrt(uint x) private pure returns (uint y) {
109         uint z = (x + 1) / 2;
110         y = x;
111         while (z < y) {
112             y = z;
113             z = (x / z + z) / 2;
114         }
115     }
116 }
117 
118 /**
119  * @title SafeMath
120  * @dev Math operations with safety checks that throw on error
121  */
122 library SafeMath {
123 
124     /**
125     * @dev Multiplies two numbers, throws on overflow.
126     */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         if (a == 0) {
129             return 0;                                                                                                                                                                                       
130         }
131         uint256 c = a * b;                                                                                                                                                                                  
132         assert(c / a == b);                                                                                                                                                                                 
133         return c;                                                                                                                                                                                           
134     }
135 
136     /**
137     * @dev Integer division of two numbers, truncating the quotient.
138     */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         // assert(b > 0); // Solidity automatically throws when dividing by 0                                                                                                                               
141         // uint256 c = a / b;                                                                                                                                                                               
142         // assert(a == b * c + a % b); // There is no case in which this doesn't hold                                                                                                                       
143         return a / b;                                                                                                                                                                                       
144     }
145 
146     /**
147     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
148     */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         assert(b <= a);                                                                                                                                                                                     
151         return a - b;                                                                                                                                                                                       
152     }
153 
154     /**
155     * @dev Adds two numbers, throws on overflow.
156     */
157     function add(uint256 a, uint256 b) internal pure returns (uint256) {
158         uint256 c = a + b;                                                                                                                                                                                  
159         assert(c >= a);                                                                                                                                                                                     
160         return c;                                                                                                                                                                                           
161     }
162 }