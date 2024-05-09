1 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
2 
3 /// @title Abstract token contract - Functions to be implemented by token contracts.
4 /// @author Stefan George - <stefan.george@consensys.net>
5 contract Token {
6     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
7     function totalSupply() constant returns (uint256 supply) {}
8     function balanceOf(address owner) constant returns (uint256 balance);
9     function transfer(address to, uint256 value) returns (bool success);
10     function transferFrom(address from, address to, uint256 value) returns (bool success);
11     function approve(address spender, uint256 value) returns (bool success);
12     function allowance(address owner, address spender) constant returns (uint256 remaining);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 
19 
20 contract SingularDTVToken is Token {
21     function issueTokens(address _for, uint tokenCount) returns (bool);
22 }
23 contract SingularDTVCrowdfunding {
24     function twoYearsPassed() returns (bool);
25     function startDate() returns (uint);
26     function CROWDFUNDING_PERIOD() returns (uint);
27     function TOKEN_TARGET() returns (uint);
28     function valuePerShare() returns (uint);
29     function fundBalance() returns (uint);
30     function campaignEndedSuccessfully() returns (bool);
31 }
32 
33 
34 /// @title Fund contract - Implements revenue distribution.
35 /// @author Stefan George - <stefan.george@consensys.net>
36 contract SingularDTVFund {
37 
38     /*
39      *  External contracts
40      */
41     SingularDTVToken public singularDTVToken;
42     SingularDTVCrowdfunding public singularDTVCrowdfunding;
43 
44     /*
45      *  Storage
46      */
47     address public owner;
48     address constant public workshop = 0xc78310231aA53bD3D0FEA2F8c705C67730929D8f;
49     uint public totalRevenue;
50 
51     // User's address => Revenue at time of withdraw
52     mapping (address => uint) public revenueAtTimeOfWithdraw;
53 
54     // User's address => Revenue which can be withdrawn
55     mapping (address => uint) public owed;
56 
57     /*
58      *  Modifiers
59      */
60     modifier noEther() {
61         if (msg.value > 0) {
62             throw;
63         }
64         _
65     }
66 
67     modifier onlyOwner() {
68         // Only guard is allowed to do this action.
69         if (msg.sender != owner) {
70             throw;
71         }
72         _
73     }
74 
75     modifier campaignEndedSuccessfully() {
76         if (!singularDTVCrowdfunding.campaignEndedSuccessfully()) {
77             throw;
78         }
79         _
80     }
81 
82     /*
83      *  Contract functions
84      */
85     /// @dev Deposits revenue. Returns success.
86     function depositRevenue()
87         external
88         campaignEndedSuccessfully
89         returns (bool)
90     {
91         totalRevenue += msg.value;
92         return true;
93     }
94 
95     /// @dev Withdraws revenue for user. Returns revenue.
96     /// @param forAddress user's address.
97     function calcRevenue(address forAddress) internal returns (uint) {
98         return singularDTVToken.balanceOf(forAddress) * (totalRevenue - revenueAtTimeOfWithdraw[forAddress]) / singularDTVToken.totalSupply();
99     }
100 
101     /// @dev Withdraws revenue for user. Returns revenue.
102     function withdrawRevenue()
103         external
104         noEther
105         returns (uint)
106     {
107         uint value = calcRevenue(msg.sender) + owed[msg.sender];
108         revenueAtTimeOfWithdraw[msg.sender] = totalRevenue;
109         owed[msg.sender] = 0;
110         if (value > 0 && !msg.sender.send(value)) {
111             throw;
112         }
113         return value;
114     }
115 
116     /// @dev Credits revenue to owed balance.
117     /// @param forAddress user's address.
118     function softWithdrawRevenueFor(address forAddress)
119         external
120         noEther
121         returns (uint)
122     {
123         uint value = calcRevenue(forAddress);
124         revenueAtTimeOfWithdraw[forAddress] = totalRevenue;
125         owed[forAddress] += value;
126         return value;
127     }
128 
129     /// @dev Setup function sets external contracts' addresses.
130     /// @param singularDTVTokenAddress Token address.
131     function setup(address singularDTVCrowdfundingAddress, address singularDTVTokenAddress)
132         external
133         noEther
134         onlyOwner
135         returns (bool)
136     {
137         if (address(singularDTVCrowdfunding) == 0 && address(singularDTVToken) == 0) {
138             singularDTVCrowdfunding = SingularDTVCrowdfunding(singularDTVCrowdfundingAddress);
139             singularDTVToken = SingularDTVToken(singularDTVTokenAddress);
140             return true;
141         }
142         return false;
143     }
144 
145     /// @dev Contract constructor function sets guard address.
146     function SingularDTVFund() noEther {
147         // Set owner address
148         owner = msg.sender;
149     }
150 }