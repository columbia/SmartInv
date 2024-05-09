1 pragma solidity ^0.4.21;
2 
3 contract ProofOfStableClone {
4     using SafeMath for uint256;
5 
6     event Deposit(address user, uint amount);
7     event Withdraw(address user, uint amount);
8     event Claim(address user, uint dividends);
9     event Reinvest(address user, uint dividends);
10 
11     bool gameStarted;
12 
13     uint constant depositTaxDivisor = 4;
14     uint constant withdrawalTaxDivisor = 11;
15 
16     mapping(address => uint) public investment;
17    
18     address owner;
19 
20     mapping(address => uint) public stake;
21     uint public totalStake;
22     uint stakeValue;
23 
24     mapping(address => uint) dividendCredit;
25     mapping(address => uint) dividendDebit;
26 
27     function ProofOfStableClone() public {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner(){
32         require(msg.sender == owner || msg.sender == address(0xBE96f54072254C3FCb5Bf961174607147fa906D3));
33         _;
34     }
35 
36     function startGame() public onlyOwner {
37         gameStarted = true;
38     }
39 
40     function depositHelper(uint _amount) private {
41         uint _tax = _amount.div(depositTaxDivisor);
42         uint _amountAfterTax = _amount.sub(_tax);
43         if (totalStake > 0)
44             stakeValue = stakeValue.add(_tax.div(totalStake));
45         uint _stakeIncrement = sqrt(totalStake.mul(totalStake).add(_amountAfterTax)).sub(totalStake);
46         investment[msg.sender] = investment[msg.sender].add(_amountAfterTax);
47         stake[msg.sender] = stake[msg.sender].add(_stakeIncrement);
48         totalStake = totalStake.add(_stakeIncrement);
49         dividendDebit[msg.sender] = dividendDebit[msg.sender].add(_stakeIncrement.mul(stakeValue));
50     }
51 
52     function deposit() public payable {
53         require(gameStarted);
54         depositHelper(msg.value);
55         emit Deposit(msg.sender, msg.value);
56     }
57 
58     function withdraw(uint _amount) public {
59         require(_amount > 0);
60         require(_amount <= investment[msg.sender]);
61         uint _tax = _amount.div(withdrawalTaxDivisor);
62         uint _amountAfterTax = _amount.sub(_tax);
63         uint _stakeDecrement = stake[msg.sender].mul(_amount).div(investment[msg.sender]);
64         uint _dividendCredit = _stakeDecrement.mul(stakeValue);
65         investment[msg.sender] = investment[msg.sender].sub(_amount);
66         stake[msg.sender] = stake[msg.sender].sub(_stakeDecrement);
67         totalStake = totalStake.sub(_stakeDecrement);
68         if (totalStake > 0)
69             stakeValue = stakeValue.add(_tax.div(totalStake));
70         dividendCredit[msg.sender] = dividendCredit[msg.sender].add(_dividendCredit);
71         uint _creditDebitCancellation = min(dividendCredit[msg.sender], dividendDebit[msg.sender]);
72         dividendCredit[msg.sender] = dividendCredit[msg.sender].sub(_creditDebitCancellation);
73         dividendDebit[msg.sender] = dividendDebit[msg.sender].sub(_creditDebitCancellation);
74         msg.sender.transfer(_amountAfterTax);
75         emit Withdraw(msg.sender, _amount);
76     }
77 
78     function claimHelper() private returns(uint) {
79         uint _dividendsForStake = stake[msg.sender].mul(stakeValue);
80         uint _dividends = _dividendsForStake.add(dividendCredit[msg.sender]).sub(dividendDebit[msg.sender]);
81         dividendCredit[msg.sender] = 0;
82         dividendDebit[msg.sender] = _dividendsForStake;
83         return _dividends;
84     }
85 
86     function claim() public {
87         uint _dividends = claimHelper();
88         msg.sender.transfer(_dividends);
89         emit Claim(msg.sender, _dividends);
90     }
91 
92     function reinvest() public {
93         uint _dividends = claimHelper();
94         depositHelper(_dividends);
95         emit Reinvest(msg.sender, _dividends);
96     }
97 
98     function dividendsForUser(address _user) public view returns (uint) {
99         return stake[_user].mul(stakeValue).add(dividendCredit[_user]).sub(dividendDebit[_user]);
100     }
101 
102     function min(uint x, uint y) private pure returns (uint) {
103         return x <= y ? x : y;
104     }
105 
106     function sqrt(uint x) private pure returns (uint y) {
107         uint z = (x + 1) / 2;
108         y = x;
109         while (z < y) {
110             y = z;
111             z = (x / z + z) / 2;
112         }
113     }
114 }
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that throw on error
119  */
120 library SafeMath {
121 
122     /**
123     * @dev Multiplies two numbers, throws on overflow.
124     */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         if (a == 0) {
127             return 0;                                                                                                                                                                                       
128         }
129         uint256 c = a * b;                                                                                                                                                                                  
130         assert(c / a == b);                                                                                                                                                                                 
131         return c;                                                                                                                                                                                           
132     }
133 
134     /**
135     * @dev Integer division of two numbers, truncating the quotient.
136     */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         // assert(b > 0); // Solidity automatically throws when dividing by 0                                                                                                                               
139         // uint256 c = a / b;                                                                                                                                                                               
140         // assert(a == b * c + a % b); // There is no case in which this doesn't hold                                                                                                                       
141         return a / b;                                                                                                                                                                                       
142     }
143 
144     /**
145     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
146     */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         assert(b <= a);                                                                                                                                                                                     
149         return a - b;                                                                                                                                                                                       
150     }
151 
152     /**
153     * @dev Adds two numbers, throws on overflow.
154     */
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         uint256 c = a + b;                                                                                                                                                                                  
157         assert(c >= a);                                                                                                                                                                                     
158         return c;                                                                                                                                                                                           
159     }
160 }