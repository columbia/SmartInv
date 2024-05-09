1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC20Basic {
67   uint256 public totalSupply;
68   function balanceOf(address who) public constant returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) public constant returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 library SafeERC20 {
81   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
82     assert(token.transfer(to, value));
83   }
84 
85   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
86     assert(token.transferFrom(from, to, value));
87   }
88 
89   function safeApprove(ERC20 token, address spender, uint256 value) internal {
90     assert(token.approve(spender, value));
91   }
92 }
93 
94 contract TokenVesting is Ownable {
95     using SafeMath for uint256;
96     using SafeERC20 for ERC20Basic;
97 
98     ERC20Basic token;
99     // vesting
100     mapping (address => uint256) totalVestedAmount;
101 
102     struct Vesting {
103         uint256 amount;
104         uint256 vestingDate;
105     }
106 
107     address[] accountKeys;
108     mapping (address => Vesting[]) public vestingAccounts;
109 
110     // events
111     event Vest(address indexed beneficiary, uint256 amount);
112     event VestingCreated(address indexed beneficiary, uint256 amount, uint256 vestingDate);
113 
114     // modifiers here
115     modifier tokenSet() {
116         require(address(token) != address(0));
117         _;
118     }
119 
120     // vesting constructor
121     function TokenVesting(address token_address){
122        require(token_address != address(0));
123        token = ERC20Basic(token_address);
124     }
125 
126     // set vesting token address
127     function setVestingToken(address token_address) external onlyOwner {
128         require(token_address != address(0));
129         token = ERC20Basic(token_address);
130     }
131 
132     // create vesting by introducing beneficiary addres, total token amount, start date, duration for each vest period and number of periods
133     function createVestingByDurationAndSplits(address user, uint256 total_amount, uint256 startDate, uint256 durationPerVesting, uint256 times) public onlyOwner tokenSet {
134         require(user != address(0));
135         require(startDate >= now);
136         require(times > 0);
137         require(durationPerVesting > 0);
138         uint256 vestingDate = startDate;
139         uint256 i;
140         uint256 amount = total_amount.div(times);
141         for (i = 0; i < times; i++) {
142             vestingDate = vestingDate.add(durationPerVesting);
143             if (vestingAccounts[user].length == 0){
144                 accountKeys.push(user);
145             }
146             vestingAccounts[user].push(Vesting(amount, vestingDate));
147             VestingCreated(user, amount, vestingDate);
148         }
149     }
150 
151     // get current user total granted token amount
152     function getVestingAmountByNow(address user) constant returns (uint256){
153         uint256 amount;
154         uint256 i;
155         for (i = 0; i < vestingAccounts[user].length; i++) {
156             if (vestingAccounts[user][i].vestingDate < now) {
157                 amount = amount.add(vestingAccounts[user][i].amount);
158             }
159         }
160 
161     }
162 
163     // get user available vesting amount, total amount - received amount
164     function getAvailableVestingAmount(address user) constant returns (uint256){
165         uint256 amount;
166         amount = getVestingAmountByNow(user);
167         amount = amount.sub(totalVestedAmount[user]);
168         return amount;
169     }
170 
171     // get list of vesting users address
172     function getAccountKeys(uint256 page) external constant returns (address[10]){
173         address[10] memory accountList;
174         uint256 i;
175         for (i=0 + page * 10; i<10; i++){
176             if (i < accountKeys.length){
177                 accountList[i - page * 10] = accountKeys[i];
178             }
179         }
180         return accountList;
181     }
182 
183     // vest
184     function vest() external tokenSet {
185         uint256 availableAmount = getAvailableVestingAmount(msg.sender);
186         require(availableAmount > 0);
187         totalVestedAmount[msg.sender] = totalVestedAmount[msg.sender].add(availableAmount);
188         token.transfer(msg.sender, availableAmount);
189         Vest(msg.sender, availableAmount);
190     }
191 
192     // drain all eth and tokens to owner in an emergency situation
193     function drain() external onlyOwner {
194         owner.transfer(this.balance);
195         token.transfer(owner, this.balance);
196     }
197 }