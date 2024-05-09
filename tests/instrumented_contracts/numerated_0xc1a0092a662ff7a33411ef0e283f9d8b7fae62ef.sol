1 pragma solidity ^0.4.21;
2 
3 contract ProofOfPassiveDividends {
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
15     // deposit tax is 14.2%
16     uint constant depositTaxDivisor = 7;
17     // deposit tax is 25%
18     uint constant withdrawalTaxDivisor = 4;
19 
20     mapping(address => uint) public investment;
21 
22     mapping(address => uint) public stake;
23     uint public totalStake;
24     uint stakeValue;
25 
26     mapping(address => uint) dividendCredit;
27     mapping(address => uint) dividendDebit;
28 
29     function ProofOfPassiveDividends() public {
30         owner = msg.sender;
31         preauthorized[owner] = true;
32     }
33 
34     function preauthorize(address _user) public {
35         require(msg.sender == owner);
36         preauthorized[_user] = true;
37     }
38 
39     function startGame() public {
40         require(msg.sender == owner);
41         gameStarted = true;
42     }
43 
44     function depositHelper(uint _amount) private {
45         uint _tax = _amount.div(depositTaxDivisor);
46         uint _amountAfterTax = _amount.sub(_tax);
47         if (totalStake > 0)
48             stakeValue = stakeValue.add(_tax.div(totalStake));
49         uint _stakeIncrement = sqrt(totalStake.mul(totalStake).add(_amountAfterTax)).sub(totalStake);
50         investment[msg.sender] = investment[msg.sender].add(_amountAfterTax);
51         stake[msg.sender] = stake[msg.sender].add(_stakeIncrement);
52         totalStake = totalStake.add(_stakeIncrement);
53         dividendDebit[msg.sender] = dividendDebit[msg.sender].add(_stakeIncrement.mul(stakeValue));
54     }
55 
56     function deposit() public payable {
57         require(preauthorized[msg.sender] || gameStarted);
58         
59         // Removed the referral feature due to nonsense fud! 
60         depositHelper(msg.value);
61         emit Deposit(msg.sender, msg.value);
62     }
63 
64     function withdraw(uint _amount) public {
65         require(_amount > 0);
66         require(_amount <= investment[msg.sender]);
67         uint _tax = _amount.div(withdrawalTaxDivisor);
68         uint _amountAfterTax = _amount.sub(_tax);
69         uint _stakeDecrement = stake[msg.sender].mul(_amount).div(investment[msg.sender]);
70         uint _dividendCredit = _stakeDecrement.mul(stakeValue);
71         investment[msg.sender] = investment[msg.sender].sub(_amount);
72         stake[msg.sender] = stake[msg.sender].sub(_stakeDecrement);
73         totalStake = totalStake.sub(_stakeDecrement);
74         if (totalStake > 0)
75             stakeValue = stakeValue.add(_tax.div(totalStake));
76         dividendCredit[msg.sender] = dividendCredit[msg.sender].add(_dividendCredit);
77         uint _creditDebitCancellation = min(dividendCredit[msg.sender], dividendDebit[msg.sender]);
78         dividendCredit[msg.sender] = dividendCredit[msg.sender].sub(_creditDebitCancellation);
79         dividendDebit[msg.sender] = dividendDebit[msg.sender].sub(_creditDebitCancellation);
80         msg.sender.transfer(_amountAfterTax);
81         emit Withdraw(msg.sender, _amount);
82     }
83 
84     function claimHelper() private returns(uint) {
85         uint _dividendsForStake = stake[msg.sender].mul(stakeValue);
86         uint _dividends = _dividendsForStake.add(dividendCredit[msg.sender]).sub(dividendDebit[msg.sender]);
87         dividendCredit[msg.sender] = 0;
88         dividendDebit[msg.sender] = _dividendsForStake;
89         return _dividends;
90     }
91 
92     function claim() public {
93         uint _dividends = claimHelper();
94         msg.sender.transfer(_dividends);
95         emit Claim(msg.sender, _dividends);
96     }
97 
98     function reinvest() public {
99         uint _dividends = claimHelper();
100         depositHelper(_dividends);
101         emit Reinvest(msg.sender, _dividends);
102     }
103 
104     function dividendsForUser(address _user) public view returns (uint) {
105         return stake[_user].mul(stakeValue).add(dividendCredit[_user]).sub(dividendDebit[_user]);
106     }
107 
108     function min(uint x, uint y) private pure returns (uint) {
109         return x <= y ? x : y;
110     }
111 
112     function sqrt(uint x) private pure returns (uint y) {
113         uint z = (x + 1) / 2;
114         y = x;
115         while (z < y) {
116             y = z;
117             z = (x / z + z) / 2;
118         }
119     }
120 }
121 
122 /**
123  * @title SafeMath
124  * @dev Math operations with safety checks that throw on error
125  */
126 library SafeMath {
127 
128     /**
129     * @dev Multiplies two numbers, throws on overflow.
130     */
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         if (a == 0) {
133             return 0;                                                                                                                                                                                       
134         }
135         uint256 c = a * b;                                                                                                                                                                                  
136         assert(c / a == b);                                                                                                                                                                                 
137         return c;                                                                                                                                                                                           
138     }
139 
140     /**
141     * @dev Integer division of two numbers, truncating the quotient.
142     */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         // assert(b > 0); // Solidity automatically throws when dividing by 0                                                                                                                               
145         // uint256 c = a / b;                                                                                                                                                                               
146         // assert(a == b * c + a % b); // There is no case in which this doesn't hold                                                                                                                       
147         return a / b;                                                                                                                                                                                       
148     }
149 
150     /**
151     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
152     */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         assert(b <= a);                                                                                                                                                                                     
155         return a - b;                                                                                                                                                                                       
156     }
157 
158     /**
159     * @dev Adds two numbers, throws on overflow.
160     */
161     function add(uint256 a, uint256 b) internal pure returns (uint256) {
162         uint256 c = a + b;                                                                                                                                                                                  
163         assert(c >= a);                                                                                                                                                                                     
164         return c;                                                                                                                                                                                           
165     }
166 }