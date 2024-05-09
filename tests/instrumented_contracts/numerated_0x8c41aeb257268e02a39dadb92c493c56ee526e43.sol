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
54     function deposit(uint _amount, address _referrer) public payable {
55         require(preauthorized[msg.sender] || gameStarted);
56         uint256 _depositAmount = _amount;
57         address referralAddress = _referrer;
58         address uninitializedAddress = address(0);
59        
60         // If the referral address is defined then deduct 5% and transfer to the referral address otherwise skip it
61         if(_referrer != uninitializedAddress){
62          
63         // Calculate the 5% of referral commission
64 		uint256 referralCommission = (_depositAmount / 20); // => 5%
65 		// Transfer the 5% commission to the referral address
66 	    referralAddress.transfer(referralCommission);
67 	    
68 	    // Amount after deduct the referral commission - 5%
69 	    uint256 depostAmountAfterReferralFee = msg.value - referralCommission;
70         
71         // Push 95% of the deposit amount to depositHelper method
72         depositHelper(depostAmountAfterReferralFee);    
73         
74         }
75         
76         else {
77             
78         // Push 100% of the deposit amount to depositHelper method if there is no referral address
79         depositHelper(_depositAmount);
80     
81         }
82     
83         emit Deposit(msg.sender, msg.value);
84     
85     }
86 
87     function withdraw(uint _amount) public {
88         require(_amount > 0);
89         require(_amount <= investment[msg.sender]);
90         uint _tax = _amount.div(withdrawalTaxDivisor);
91         uint _amountAfterTax = _amount.sub(_tax);
92         uint _stakeDecrement = stake[msg.sender].mul(_amount).div(investment[msg.sender]);
93         uint _dividendCredit = _stakeDecrement.mul(stakeValue);
94         investment[msg.sender] = investment[msg.sender].sub(_amount);
95         stake[msg.sender] = stake[msg.sender].sub(_stakeDecrement);
96         totalStake = totalStake.sub(_stakeDecrement);
97         if (totalStake > 0)
98             stakeValue = stakeValue.add(_tax.div(totalStake));
99         dividendCredit[msg.sender] = dividendCredit[msg.sender].add(_dividendCredit);
100         uint _creditDebitCancellation = min(dividendCredit[msg.sender], dividendDebit[msg.sender]);
101         dividendCredit[msg.sender] = dividendCredit[msg.sender].sub(_creditDebitCancellation);
102         dividendDebit[msg.sender] = dividendDebit[msg.sender].sub(_creditDebitCancellation);
103         msg.sender.transfer(_amountAfterTax);
104         emit Withdraw(msg.sender, _amount);
105     }
106 
107     function claimHelper() private returns(uint) {
108         uint _dividendsForStake = stake[msg.sender].mul(stakeValue);
109         uint _dividends = _dividendsForStake.add(dividendCredit[msg.sender]).sub(dividendDebit[msg.sender]);
110         dividendCredit[msg.sender] = 0;
111         dividendDebit[msg.sender] = _dividendsForStake;
112         return _dividends;
113     }
114 
115     function claim() public {
116         uint _dividends = claimHelper();
117         msg.sender.transfer(_dividends);
118         emit Claim(msg.sender, _dividends);
119     }
120 
121     function reinvest() public {
122         uint _dividends = claimHelper();
123         depositHelper(_dividends);
124         emit Reinvest(msg.sender, _dividends);
125     }
126 
127     function dividendsForUser(address _user) public view returns (uint) {
128         return stake[_user].mul(stakeValue).add(dividendCredit[_user]).sub(dividendDebit[_user]);
129     }
130 
131     function min(uint x, uint y) private pure returns (uint) {
132         return x <= y ? x : y;
133     }
134 
135     function sqrt(uint x) private pure returns (uint y) {
136         uint z = (x + 1) / 2;
137         y = x;
138         while (z < y) {
139             y = z;
140             z = (x / z + z) / 2;
141         }
142     }
143 }
144 
145 /**
146  * @title SafeMath
147  * @dev Math operations with safety checks that throw on error
148  */
149 library SafeMath {
150 
151     /**
152     * @dev Multiplies two numbers, throws on overflow.
153     */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         if (a == 0) {
156             return 0;                                                                                                                                                                                       
157         }
158         uint256 c = a * b;                                                                                                                                                                                  
159         assert(c / a == b);                                                                                                                                                                                 
160         return c;                                                                                                                                                                                           
161     }
162 
163     /**
164     * @dev Integer division of two numbers, truncating the quotient.
165     */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         // assert(b > 0); // Solidity automatically throws when dividing by 0                                                                                                                               
168         // uint256 c = a / b;                                                                                                                                                                               
169         // assert(a == b * c + a % b); // There is no case in which this doesn't hold                                                                                                                       
170         return a / b;                                                                                                                                                                                       
171     }
172 
173     /**
174     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
175     */
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         assert(b <= a);                                                                                                                                                                                     
178         return a - b;                                                                                                                                                                                       
179     }
180 
181     /**
182     * @dev Adds two numbers, throws on overflow.
183     */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;                                                                                                                                                                                  
186         assert(c >= a);                                                                                                                                                                                     
187         return c;                                                                                                                                                                                           
188     }
189 }