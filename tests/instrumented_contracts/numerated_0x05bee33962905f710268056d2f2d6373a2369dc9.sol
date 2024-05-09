1 /*
2     xgr_token_db.sol
3     2.0.0
4     
5     Rajci 'iFA' Andor @ ifa@fusionwallet.io
6 */
7 pragma solidity 0.4.18;
8 
9 contract SafeMath {
10     /* Internals */
11     function safeAdd(uint256 a, uint256 b) internal pure returns(uint256) {
12         if ( b > 0 ) {
13             assert( a + b > a );
14         }
15         return a + b;
16     }
17     function safeSub(uint256 a, uint256 b) internal pure returns(uint256) {
18         if ( b > 0 ) {
19             assert( a - b < a );
20         }
21         return a - b;
22     }
23     function safeMul(uint256 a, uint256 b) internal pure returns(uint256) {
24         uint256 c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28     function safeDiv(uint256 a, uint256 b) internal pure returns(uint256) {
29         return a / b;
30     }
31 }
32 
33 contract Owned {
34     /* Variables */
35     address public owner = msg.sender;
36     /* Externals */
37     function replaceOwner(address newOwner) external returns(bool success) {
38         require( isOwner() );
39         owner = newOwner;
40         return true;
41     }
42     /* Internals */
43     function isOwner() internal view returns(bool) {
44         return owner == msg.sender;
45     }
46     /* Modifiers */
47     modifier onlyForOwner {
48         require( isOwner() );
49         _;
50     }
51 }
52 
53 contract TokenDB is SafeMath, Owned {
54     /* Structures */
55     struct allowance_s {
56         uint256 amount;
57         uint256 nonce;
58     }
59     struct deposits_s {
60         address addr;
61         uint256 amount;
62         uint256 start;
63         uint256 end;
64         uint256 interestOnEnd;
65         uint256 interestBeforeEnd;
66         uint256 interestFee;
67         uint256 interestMultiplier;
68         bool    closeable;
69         bool    valid;
70     }
71     /* Variables */
72     mapping(address => mapping(address => allowance_s)) public allowance;
73     mapping(address => uint256) public balanceOf;
74     mapping(uint256 => deposits_s) private deposits;
75     mapping(address => uint256) public lockedBalances;
76     address public tokenAddress;
77     address public depositsAddress;
78     uint256 public depositsCounter;
79     uint256 public totalSupply;
80     /* Constructor */
81     /* Externals */
82     function changeTokenAddress(address newTokenAddress) external onlyForOwner {
83         tokenAddress = newTokenAddress;
84     }
85     function changeDepositsAddress(address newDepositsAddress) external onlyForOwner {
86         depositsAddress = newDepositsAddress;
87     }
88     function openDeposit(address addr, uint256 amount, uint256 end, uint256 interestOnEnd,
89         uint256 interestBeforeEnd, uint256 interestFee, uint256 multiplier, bool closeable) external onlyForDeposits returns(bool success, uint256 DID) {
90         depositsCounter += 1;
91         DID = depositsCounter;
92         lockedBalances[addr] = safeAdd(lockedBalances[addr], amount);
93         deposits[DID] = deposits_s(
94             addr,
95             amount,
96             block.number,
97             end,
98             interestOnEnd,
99             interestBeforeEnd,
100             interestFee,
101             multiplier,
102             closeable,
103             true
104         );
105         return (true, DID);
106     }
107     function closeDeposit(uint256 DID) external onlyForDeposits returns (bool success) {
108         require( deposits[DID].valid );
109         delete deposits[DID].valid;
110         lockedBalances[deposits[DID].addr] = safeSub(lockedBalances[deposits[DID].addr], deposits[DID].amount);
111         return true;
112     }
113     function transfer(address from, address to, uint256 amount, uint256 fee) external onlyForToken returns(bool success) {
114         balanceOf[from] = safeSub(balanceOf[from], safeAdd(amount, fee));
115         balanceOf[to] = safeAdd(balanceOf[to], amount);
116         totalSupply = safeSub(totalSupply, fee);
117         return true;
118     }
119     function increase(address owner, uint256 value) external onlyForToken returns(bool success) {
120         balanceOf[owner] = safeAdd(balanceOf[owner], value);
121         totalSupply = safeAdd(totalSupply, value);
122         return true;
123     }
124     function decrease(address owner, uint256 value) external onlyForToken returns(bool success) {
125         require( safeSub(balanceOf[owner], safeAdd(lockedBalances[owner], value)) >= 0 );
126         balanceOf[owner] = safeSub(balanceOf[owner], value);
127         totalSupply = safeSub(totalSupply, value);
128         return true;
129     }
130     function setAllowance(address owner, address spender, uint256 amount, uint256 nonce) external onlyForToken returns(bool success) {
131         allowance[owner][spender].amount = amount;
132         allowance[owner][spender].nonce = nonce;
133         return true;
134     }
135     /* Constants */
136     function getAllowance(address owner, address spender) public constant returns(bool success, uint256 remaining, uint256 nonce) {
137         return ( true, allowance[owner][spender].amount, allowance[owner][spender].nonce );
138     }
139     function getDeposit(uint256 UID) public constant returns(address addr, uint256 amount, uint256 start,
140         uint256 end, uint256 interestOnEnd, uint256 interestBeforeEnd, uint256 interestFee, uint256 interestMultiplier, bool closeable, bool valid) {
141         addr = deposits[UID].addr;
142         amount = deposits[UID].amount;
143         start = deposits[UID].start;
144         end = deposits[UID].end;
145         interestOnEnd = deposits[UID].interestOnEnd;
146         interestBeforeEnd = deposits[UID].interestBeforeEnd;
147         interestFee = deposits[UID].interestFee;
148         interestMultiplier = deposits[UID].interestMultiplier;
149         closeable = deposits[UID].closeable;
150         valid = deposits[UID].valid;
151     }
152     /* Modifiers */
153     modifier onlyForToken {
154         require( msg.sender == tokenAddress );
155         _;
156     }
157     modifier onlyForDeposits {
158         require( msg.sender == depositsAddress );
159         _;
160     }
161 }