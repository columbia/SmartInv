1 /*
2 / _\_ __ ___   __ _ _ __| |_/ / /\ \ \___ | |_   _____  ___
3 \ \| '_ ` _ \ / _` | '__| __\ \/  \/ / _ \| \ \ / / _ \/ __|
4 _\ \ | | | | | (_| | |  | |_ \  /\  / (_) | |\ V /  __/\__ \
5 \__/_| |_| |_|\__,_|_|   \__| \/  \/ \___/|_| \_/ \___||___/
6 */
7 
8 // SPDX-License-Identifier: Unlicensed
9 
10 pragma solidity >= 0.6.12;
11 
12 library SafeMath {
13     /**
14      * @dev Returns the addition of two unsigned integers, reverting on
15      * overflow.
16      *
17      * Counterpart to Solidity's `+` operator.
18      *
19      * Requirements:
20      *
21      * - Addition cannot overflow.
22      */
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26 
27         return c;
28     }
29 }
30 
31 contract SmartWolves {
32     using SafeMath for uint;
33 
34     uint status;
35 
36     uint registrationFee;
37 
38     address payable public companyAccount;
39 
40     event Enrolled(
41         uint8 indexed pool,
42         address indexed payerAddress,
43         string indexed username,
44         uint amount
45     );
46 
47     event PoolPurchased(
48         uint8 indexed pool,
49         address indexed payerAddress,
50         uint amount,
51         string indexed username
52     );
53 
54     event PayoutSuccess(
55         address indexed payee,
56         string indexed username,
57         uint amount
58     );
59 
60     event NewDeposit(
61         address indexed payer,
62         uint amount
63     );
64 
65     event CompanyAccountChanged(
66         address indexed oldAccount,
67         address indexed newAccount
68     );
69 
70     struct User {
71         bool status;
72         uint8 pool;
73         address paymentAddress;
74         string userName;
75     }
76 
77     mapping(uint8 => uint) public pools;
78 
79     mapping(string => User) public users;
80 
81     constructor(uint _registrationFee) public {
82         registrationFee = _registrationFee;
83         companyAccount = msg.sender;
84 
85         pools[1] = 50000000000000000;
86         pools[2] = 200000000000000000;
87         pools[3] = 500000000000000000;
88         pools[4] = 1000000000000000000;
89         pools[5] = 2000000000000000000;
90         pools[6] = 5000000000000000000;
91         pools[7] = 10000000000000000000;
92         pools[8] = 20000000000000000000;
93         pools[9] = 30000000000000000000;
94         pools[10] = 50000000000000000000;
95         pools[11] = 100000000000000000000;
96     }
97 
98     modifier onlyOwner(){
99         require(msg.sender == companyAccount, 'Sorry this can be only by the admin account!');
100         _;
101     }
102 
103     modifier noContract(address _address){
104         require(!isContract(_address), 'Payment to a contract is not allowed!');
105         _;
106     }
107 
108     modifier notEnrolledAlready(string memory _username){
109         require(users[_username].status == false, 'You seems like have been enrolled already!');
110         _;
111     }
112 
113     function enrol(string calldata _username, uint8 _pool) external payable notEnrolledAlready(_username) {
114         require(msg.value >= pools[_pool].add(registrationFee), 'Please send the correct amount!');
115 
116         depositAmount(companyAccount, msg.value);
117         // Enrol user
118         users[_username] = User(true, _pool, msg.sender, _username);
119         // Emit event telling that there is a new enrolment
120         emit Enrolled(_pool, msg.sender, _username, msg.value);
121     }
122 
123     function withdrawToUserAccount(address _userAddress, string calldata __userName, uint _amount) external payable onlyOwner noContract(_userAddress) {
124         depositAmount(_userAddress, _amount);
125         // Emit success payout event
126         emit PayoutSuccess(_userAddress, __userName, _amount);
127     }
128 
129     function isContract(address account) internal view returns (bool) {
130         // This method relies in extcodesize, which returns 0 for contracts in
131         // construction, since the code is only stored at the end of the
132         // constructor execution.
133 
134         uint256 size;
135         // solhint-disable-next-line no-inline-assembly
136         assembly {size := extcodesize(account)}
137         return size > 0;
138     }
139 
140     function depositAmount(address _user, uint256 _amount) internal {
141         require(address(this).balance >= _amount, "Address: insufficient balance");
142 
143         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
144         (bool success,) = _user.call{value : _amount}("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     function changeCompanyAccount(address payable _newAccount) external onlyOwner {
149         address oldAccount = companyAccount;
150         companyAccount = _newAccount;
151         emit CompanyAccountChanged(oldAccount, _newAccount);
152     }
153 
154     function purchasePool(string calldata _username, uint8 _pool) external payable noContract(msg.sender) {
155         require(msg.value >= pools[_pool], 'Please send the correct pool upgrade amount!');
156 
157         depositAmount(companyAccount, msg.value);
158         User storage user = users[_username];
159         user.pool = _pool;
160         // emit pool purchase event
161         emit PoolPurchased(_pool, msg.sender, msg.value, _username);
162     }
163 
164     receive() external payable {
165         emit NewDeposit(msg.sender, msg.value);
166     }
167 
168     fallback() external payable {
169         emit NewDeposit(msg.sender, msg.value);
170     }
171 }