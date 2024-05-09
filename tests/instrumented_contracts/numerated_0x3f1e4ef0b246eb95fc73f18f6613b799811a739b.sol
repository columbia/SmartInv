1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 // Intermediate deposit contract for DBET V1 and V2 tokens.
54 // Token holders send tokens to this contract to in-turn receive DBET tokens on VET.
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57 
58     function balanceOf(address who) public view returns (uint256);
59 
60     function transfer(address to, uint256 value) public returns (bool);
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 contract ERC20 is ERC20Basic {
66     function allowance(address owner, address spender)
67     public view returns (uint256);
68 
69     function transferFrom(address from, address to, uint256 value)
70     public returns (bool);
71 
72     function approve(address spender, uint256 value) public returns (bool);
73 
74     event Approval(
75         address indexed owner,
76         address indexed spender,
77         uint256 value
78     );
79 }
80 
81 contract DBETToVETDeposit {
82 
83     using SafeMath for uint256;
84 
85     // DBET team address
86     address public dbetTeam;
87     // DBET V1 token contract
88     ERC20 public dbetV1;
89     // DBET V2 token contract
90     ERC20 public dbetV2;
91 
92     // Emergency withdrawals incase something goes wrong
93     bool public emergencyWithdrawalsEnabled;
94     // If deposits are finalized, emergency withdrawals will cease to work
95     bool public finalizedDeposits;
96     // Number of deposits made
97     uint256 public depositIndex;
98 
99     // Mapping of tokens deposited by addresses
100     // isV2 => (address => amount)
101     mapping(bool => mapping(address => uint256)) public depositedTokens;
102 
103     event LogTokenDeposit(
104         bool isV2,
105         address _address,
106         address VETAddress,
107         uint256 amount,
108         uint256 index
109     );
110     event LogEmergencyWithdraw(
111         bool isV2,
112         address _address,
113         uint256 amount
114     );
115 
116     constructor(address v1, address v2) public {
117         dbetTeam = msg.sender;
118         dbetV1 = ERC20(v1);
119         dbetV2 = ERC20(v2);
120     }
121 
122     modifier isDbetTeam() {
123         require(msg.sender == dbetTeam);
124         _;
125     }
126 
127     modifier areWithdrawalsEnabled() {
128         require(emergencyWithdrawalsEnabled && !finalizedDeposits);
129         _;
130     }
131 
132     // Returns the appropriate token contract
133     function getToken(bool isV2) internal returns (ERC20) {
134         if (isV2)
135             return dbetV2;
136         else
137             return dbetV1;
138     }
139 
140     // Deposit V1/V2 tokens into the contract
141     function depositTokens(
142         bool isV2,
143         uint256 amount,
144         address VETAddress
145     )
146     public {
147         require(amount > 0);
148         require(VETAddress != 0);
149         require(getToken(isV2).balanceOf(msg.sender) >= amount);
150         require(getToken(isV2).allowance(msg.sender, address(this)) >= amount);
151 
152         depositedTokens[isV2][msg.sender] = depositedTokens[isV2][msg.sender].add(amount);
153 
154         require(getToken(isV2).transferFrom(msg.sender, address(this), amount));
155 
156         emit LogTokenDeposit(
157             isV2,
158             msg.sender,
159             VETAddress,
160             amount,
161             depositIndex++
162         );
163     }
164 
165     function enableEmergencyWithdrawals () public
166     isDbetTeam {
167         emergencyWithdrawalsEnabled = true;
168     }
169 
170     function finalizeDeposits () public
171     isDbetTeam {
172         finalizedDeposits = true;
173     }
174 
175     // Withdraw deposited tokens if emergency withdrawals have been enabled
176     function emergencyWithdraw(bool isV2) public
177     areWithdrawalsEnabled {
178         require(depositedTokens[isV2][msg.sender] > 0);
179 
180         uint256 amount = depositedTokens[isV2][msg.sender];
181 
182         depositedTokens[isV2][msg.sender] = 0;
183 
184         require(getToken(isV2).transfer(msg.sender, amount));
185 
186         emit LogEmergencyWithdraw(isV2, msg.sender, amount);
187     }
188 
189 }