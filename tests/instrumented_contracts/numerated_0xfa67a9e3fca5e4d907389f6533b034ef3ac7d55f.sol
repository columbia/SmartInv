1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 Daily - 75% daily
6 */
7 contract Daily75 {
8 
9     using SafeMath for uint256;
10 
11     mapping(address => uint256) investments;
12     mapping(address => uint256) joined;
13     mapping(address => uint256) withdrawals;
14     mapping(address => uint256) referrer;
15 
16     uint256 public step = 125;
17     uint256 public minimum = 10 finney;
18     uint256 public stakingRequirement = 0.01 ether;
19     address public ownerWallet;
20     address public owner;
21     address promoter1 = 0xC558895aE123BB02b3c33164FdeC34E9Fb66B660;
22     address promoter2 = 0x70C7Eac2858e52856d8143dec1a38bDEc9503eBc;
23 
24     event Invest(address investor, uint256 amount);
25     event Withdraw(address investor, uint256 amount);
26     event Bounty(address hunter, uint256 amount);
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     /**
30      * @dev Constructor Sets the original roles of the contract
31      */
32 
33     constructor() public {
34         owner = msg.sender;
35         ownerWallet = msg.sender;
36     }
37 
38     /**
39      * @dev Modifiers
40      */
41 
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     /**
48      * @dev Allows current owner to transfer control of the contract to a newOwner.
49      * @param newOwner The address to transfer ownership to.
50      * @param newOwnerWallet The address to transfer ownership to.
51      */
52     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
53         require(newOwner != address(0));
54         emit OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56         ownerWallet = newOwnerWallet;
57     }
58 
59     /**
60      * @dev Investments
61      */
62     function () public payable {
63         buy(0x0);
64     }
65 
66     function buy(address _referredBy) public payable {
67         require(msg.value >= minimum);
68 
69         address _customerAddress = msg.sender;
70 
71         if(
72            // is this a referred purchase?
73            _referredBy != 0x0000000000000000000000000000000000000000 &&
74 
75            // no cheating!
76            _referredBy != _customerAddress &&
77 
78            // does the referrer have at least X whole tokens?
79            // i.e is the referrer a godly chad masternode
80            investments[_referredBy] >= stakingRequirement
81        ){
82            // wealth redistribution
83            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
84        }
85 
86        if (investments[msg.sender] > 0){
87            if (withdraw()){
88                withdrawals[msg.sender] = 0;
89            }
90        }
91        investments[msg.sender] = investments[msg.sender].add(msg.value);
92        joined[msg.sender] = block.timestamp;
93        ownerWallet.transfer(msg.value.mul(5).div(100));
94        promoter1.transfer(msg.value.div(100).mul(5));
95        promoter2.transfer(msg.value.div(100).mul(1));
96        emit Invest(msg.sender, msg.value);
97     }
98 
99     /**
100     * @dev Evaluate current balance
101     * @param _address Address of investor
102     */
103     function getBalance(address _address) view public returns (uint256) {
104         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
105         uint256 percent = investments[_address].mul(step).div(100);
106         uint256 different = percent.mul(minutesCount).div(1440);
107         uint256 balance = different.sub(withdrawals[_address]);
108 
109         return balance;
110     }
111 
112     /**
113     * @dev Withdraw dividends from contract
114     */
115     function withdraw() public returns (bool){
116         require(joined[msg.sender] > 0);
117         uint256 balance = getBalance(msg.sender);
118         if (address(this).balance > balance){
119             if (balance > 0){
120                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
121                 msg.sender.transfer(balance);
122                 emit Withdraw(msg.sender, balance);
123             }
124             return true;
125         } else {
126             return false;
127         }
128     }
129 
130     /**
131     * @dev Bounty reward
132     */
133     function bounty() public {
134         uint256 refBalance = checkReferral(msg.sender);
135         if(refBalance >= minimum) {
136              if (address(this).balance > refBalance) {
137                 referrer[msg.sender] = 0;
138                 msg.sender.transfer(refBalance);
139                 emit Bounty(msg.sender, refBalance);
140              }
141         }
142     }
143 
144     /**
145     * @dev Gets balance of the sender address.
146     * @return An uint256 representing the amount owned by the msg.sender.
147     */
148     function checkBalance() public view returns (uint256) {
149         return getBalance(msg.sender);
150     }
151 
152     /**
153     * @dev Gets withdrawals of the specified address.
154     * @param _investor The address to query the the balance of.
155     * @return An uint256 representing the amount owned by the passed address.
156     */
157     function checkWithdrawals(address _investor) public view returns (uint256) {
158         return withdrawals[_investor];
159     }
160 
161     /**
162     * @dev Gets investments of the specified address.
163     * @param _investor The address to query the the balance of.
164     * @return An uint256 representing the amount owned by the passed address.
165     */
166     function checkInvestments(address _investor) public view returns (uint256) {
167         return investments[_investor];
168     }
169 
170     /**
171     * @dev Gets referrer balance of the specified address.
172     * @param _hunter The address of the referrer
173     * @return An uint256 representing the referral earnings.
174     */
175     function checkReferral(address _hunter) public view returns (uint256) {
176         return referrer[_hunter];
177     }
178 }
179 
180 /**
181  * @title SafeMath
182  * @dev Math operations with safety checks that throw on error
183  */
184 library SafeMath {
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         if (a == 0) {
187             return 0;
188         }
189         uint256 c = a * b;
190         assert(c / a == b);
191         return c;
192     }
193 
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         // assert(b > 0); // Solidity automatically throws when dividing by 0
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198         return c;
199     }
200 
201     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202         assert(b <= a);
203         return a - b;
204     }
205 
206     function add(uint256 a, uint256 b) internal pure returns (uint256) {
207         uint256 c = a + b;
208         assert(c >= a);
209         return c;
210     }
211 }