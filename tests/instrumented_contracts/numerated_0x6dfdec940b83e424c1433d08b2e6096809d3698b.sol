1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 Get Paid 50 Percent daily for 3 days... You can withdraw your dividend every minute...
6 */
7 contract AceReturns {
8 
9     using SafeMath for uint256;
10 
11     mapping(address => uint256) investments;
12     mapping(address => uint256) recentinvestment;
13     mapping(address => uint256) joined;
14     mapping(address => uint256) withdrawals;
15     mapping(address => uint256) referrer;
16     
17     uint256 public step = 50;
18     uint256 public minimum = 10 finney;
19     uint256 public stakingRequirement = 0.25 ether;
20     address public ownerWallet;
21     address public owner;
22     
23     event Invest(address investor, uint256 amount);
24     event Withdraw(address investor, uint256 amount);
25     event Bounty(address hunter, uint256 amount);
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     /**
29      * @dev Constructor Sets the original roles of the contract
30      */
31 
32     constructor() public {
33         owner = msg.sender;
34         ownerWallet = msg.sender;
35     }
36 
37     /**
38      * @dev Modifiers
39      */
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     /**
47      * @dev Allows current owner to transfer control of the contract to a newOwner.
48      * @param newOwner The address to transfer ownership to.
49      * @param newOwnerWallet The address to transfer ownership to.
50      */
51     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
52         require(newOwner != address(0));
53         emit OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55         ownerWallet = newOwnerWallet;
56     }
57 
58     /**
59      * @dev Investments
60      */
61     function () public payable {
62         buy(0x0);
63     }
64 
65     function buy(address _referredBy) public payable {
66         require(msg.value >= minimum);
67         address _customerAddress = msg.sender;
68 
69         if(
70            // is this referred by someone?
71            _referredBy != 0x0000000000000000000000000000000000000000 &&
72 
73            // no cheating!
74            _referredBy != _customerAddress &&
75 
76            // has the referrer invested a minimum of X tokens?
77           investments[_referredBy] >= stakingRequirement
78        ){
79            // referral commission
80            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
81        }
82 
83        if (investments[msg.sender] > 0){
84            if (withdraw()){
85                withdrawals[msg.sender] = 0;
86            }
87        }
88        investments[msg.sender] = investments[msg.sender].add(msg.value);
89        recentinvestment[msg.sender] = (msg.value);
90        joined[msg.sender] = block.timestamp;
91        ownerWallet.transfer(msg.value.mul(5).div(100));
92        emit Invest(msg.sender, msg.value);
93     }
94 
95     /**
96     * Evaluate current balance
97     * _address Address of investor
98     */
99     function getBalance(address _address) view public returns (uint256) {
100         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
101         if (minutesCount < 4321) {
102         uint256 percent = recentinvestment[_address].mul(step).div(100);
103         uint256 different = percent.mul(minutesCount).div(1440);
104         uint256 balance = different.sub(withdrawals[_address]);
105         return balance;
106        }  else {
107         uint256 percentfinal = recentinvestment[_address].mul(150).div(100);
108         uint256 balancefinal = percentfinal.sub(withdrawals[_address]);
109         return balancefinal;
110         }
111       }
112 
113 function getMinutes(address _address) view public returns (uint256) {
114          uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
115          return minutesCount;
116  }
117     /**
118     * Users Withdraw dividends from the contract
119     */
120     function withdraw() public returns (bool){
121         require(joined[msg.sender] > 0);
122         uint256 balance = getBalance(msg.sender);
123         if (address(this).balance > balance){
124             if (balance > 0){
125                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
126                 msg.sender.transfer(balance);
127                 emit Withdraw(msg.sender, balance);
128             }
129             return true;
130         } else {
131             return false;
132         }
133     }
134     /**
135     * Referral Commission
136     */
137     function bounty() public {
138         uint256 refBalance = checkReferral(msg.sender);
139         if(refBalance >= minimum) {
140              if (address(this).balance > refBalance) {
141                 referrer[msg.sender] = 0;
142                 msg.sender.transfer(refBalance);
143                 emit Bounty(msg.sender, refBalance);
144              }
145         }
146     }
147 
148     /**
149     * Gets the balance of the sender's address
150     */
151     function checkBalance() public view returns (uint256) {
152         return getBalance(msg.sender);
153     }
154 
155     /**
156     * Gets the total withdrawals of the specified address after the recent investment
157     */
158     function checkWithdrawals(address _investor) public view returns (uint256) {
159         return withdrawals[_investor];
160     }
161 
162     /**
163     * Gets the total investments of the specified address
164     */
165     function checkInvestments(address _investor) public view returns (uint256) {
166         return investments[_investor];
167     }
168     
169     /**
170     * Gets the recent investment of the specified address
171     */
172     function checkRecentInvestment(address _investor) public view returns (uint256) {
173         return recentinvestment[_investor];
174     }
175     
176     /**
177     * Gets the referral balance of the specified address
178     */
179     function checkReferral(address _hunter) public view returns (uint256) {
180         return referrer[_hunter];
181     }
182 }
183 
184 /**
185  * @title SafeMath
186  * @dev Math operations with safety checks that throw on error
187  */
188 library SafeMath {
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         if (a == 0) {
191             return 0;
192         }
193         uint256 c = a * b;
194         assert(c / a == b);
195         return c;
196     }
197 
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         // assert(b > 0); // Solidity automatically throws when dividing by 0
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202         return c;
203     }
204 
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         assert(b <= a);
207         return a - b;
208     }
209 
210     function add(uint256 a, uint256 b) internal pure returns (uint256) {
211         uint256 c = a + b;
212         assert(c >= a);
213         return c;
214     }
215 }