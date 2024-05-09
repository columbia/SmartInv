1 pragma solidity ^0.4.21;
2 
3 contract EthMonoPoly {
4     using SafeMath for uint256;
5 
6     event Deposit(address user, uint amount);
7     event Withdraw(address user, uint amount);
8     event Claim(address user, uint dividends);
9     event Reinvest(address user, uint dividends);
10 
11     address owner;
12     address vault;
13     mapping(address => bool) preauthorized;
14     bool gameStarted;
15 
16     uint constant depositTaxDivisor = 4;
17     uint constant withdrawalTaxDivisor = 4;
18     uint constant vaultBenefitDivisor = 50;
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
29     function EthMonoPoly(address _vault) public {
30         owner = msg.sender;
31         vault = _vault;
32         preauthorized[owner] = true;
33     }
34 
35     function preauthorize(address _user) public {
36         require(msg.sender == owner);
37         preauthorized[_user] = true;
38     }
39 
40     function startGame() public {
41         require(msg.sender == owner);
42         gameStarted = true;
43     }
44 
45     function depositHelper(uint _amount) private {
46         uint _tax = _amount.div(depositTaxDivisor);
47         uint _amountAfterTax = _amount.sub(_tax);
48         uint _vaultBenefit = _amount.div(vaultBenefitDivisor);
49         uint _amountAfterVaultBenefit = _amountAfterTax.sub(_vaultBenefit);
50         if (totalStake > 0)
51             stakeValue = stakeValue.add(_tax.div(totalStake));
52         uint _stakeIncrement = sqrt(totalStake.mul(totalStake).add(_amountAfterVaultBenefit)).sub(totalStake);
53         investment[msg.sender] = investment[msg.sender].add(_amountAfterVaultBenefit);
54         stake[msg.sender] = stake[msg.sender].add(_stakeIncrement);
55         totalStake = totalStake.add(_stakeIncrement);
56         dividendDebit[msg.sender] = dividendDebit[msg.sender].add(_stakeIncrement.mul(stakeValue));
57         vault.transfer(_vaultBenefit);
58     }
59 
60     function deposit() public payable {
61         require(preauthorized[msg.sender] || gameStarted);
62         depositHelper(msg.value);
63         emit Deposit(msg.sender, msg.value);
64     }
65 
66     function withdraw(uint _amount) public {
67         require(_amount > 0);
68         require(_amount <= investment[msg.sender]);
69         uint _tax = _amount.div(withdrawalTaxDivisor);
70         uint _amountAfterTax = _amount.sub(_tax);
71         uint _stakeDecrement = stake[msg.sender].mul(_amount).div(investment[msg.sender]);
72         uint _dividendCredit = _stakeDecrement.mul(stakeValue);
73         investment[msg.sender] = investment[msg.sender].sub(_amount);
74         stake[msg.sender] = stake[msg.sender].sub(_stakeDecrement);
75         totalStake = totalStake.sub(_stakeDecrement);
76         if (totalStake > 0)
77             stakeValue = stakeValue.add(_tax.div(totalStake));
78         dividendCredit[msg.sender] = dividendCredit[msg.sender].add(_dividendCredit);
79         uint _creditDebitCancellation = min(dividendCredit[msg.sender], dividendDebit[msg.sender]);
80         dividendCredit[msg.sender] = dividendCredit[msg.sender].sub(_creditDebitCancellation);
81         dividendDebit[msg.sender] = dividendDebit[msg.sender].sub(_creditDebitCancellation);
82         uint _vaultBenefit = _amount.div(vaultBenefitDivisor);
83         uint _amountAfterVaultBenefit = _amountAfterTax.sub(_vaultBenefit);
84         msg.sender.transfer(_amountAfterVaultBenefit);
85         vault.transfer(_vaultBenefit);
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
99         uint _vaultBenefit = _dividends.div(vaultBenefitDivisor);
100         uint _amountAfterVaultBenefit = _dividends.sub(_vaultBenefit);
101         msg.sender.transfer(_amountAfterVaultBenefit);
102         vault.transfer(_vaultBenefit);
103         emit Claim(msg.sender, _dividends);
104     }
105 
106     function reinvest() public {
107         uint _dividends = claimHelper();
108         depositHelper(_dividends);
109         emit Reinvest(msg.sender, _dividends);
110     }
111 
112     function dividendsForUser(address _user) public view returns (uint) {
113         return stake[_user].mul(stakeValue).add(dividendCredit[_user]).sub(dividendDebit[_user]);
114     }
115 
116     function min(uint x, uint y) private pure returns (uint) {
117         return x <= y ? x : y;
118     }
119 
120     function sqrt(uint x) private pure returns (uint y) {
121         uint z = (x + 1) / 2;
122         y = x;
123         while (z < y) {
124             y = z;
125             z = (x / z + z) / 2;
126         }
127     }
128 }
129 
130 /**
131  * @title SafeMath
132  * @dev Math operations with safety checks that throw on error
133  */
134 library SafeMath {
135 
136     /**
137     * @dev Multiplies two numbers, throws on overflow.
138     */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         if (a == 0) {
141             return 0;                                                                                                                                                                                       
142         }
143         uint256 c = a * b;                                                                                                                                                                                  
144         assert(c / a == b);                                                                                                                                                                                 
145         return c;                                                                                                                                                                                           
146     }
147 
148     /**
149     * @dev Integer division of two numbers, truncating the quotient.
150     */
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         // assert(b > 0); // Solidity automatically throws when dividing by 0                                                                                                                               
153         // uint256 c = a / b;                                                                                                                                                                               
154         // assert(a == b * c + a % b); // There is no case in which this doesn't hold                                                                                                                       
155         return a / b;                                                                                                                                                                                       
156     }
157 
158     /**
159     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
160     */
161     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162         assert(b <= a);                                                                                                                                                                                     
163         return a - b;                                                                                                                                                                                       
164     }
165 
166     /**
167     * @dev Adds two numbers, throws on overflow.
168     */
169     function add(uint256 a, uint256 b) internal pure returns (uint256) {
170         uint256 c = a + b;                                                                                                                                                                                  
171         assert(c >= a);                                                                                                                                                                                     
172         return c;                                                                                                                                                                                           
173     }
174 }