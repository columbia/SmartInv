1 pragma solidity ^0.4.25;
2 
3 /**
4 *
5 -------------------------------------------------------------------------------------------------------
6    Website: https://kingdometh.com
7     Twitter: https://twitter.com/KingdomETH
8     Telegram Group: https://t.me/joinchat/IvMthlFxD8cfhpXR0wqT-g
9     Facebook: https://www.facebook.com/Kingdometh-282085195979826
10     Discord: https://discord.gg/TxhSfNB
11     -------------------------------------------------------------------------------------------------------
12 */
13 contract KingdomETHBank {
14 
15     using SafeMath for uint256;
16 
17     mapping(address => uint256) investments;
18     mapping(address => uint256) joined;
19     mapping(address => uint256) withdrawals;
20     mapping(address => uint256) referrer;
21 
22     uint256 public step = 5;
23     uint256 public minimum = 10 finney;
24     uint256 public stakingRequirement = 0.01 ether;
25     address public ownerWallet;
26     address public owner;
27 
28     event Invest(address investor, uint256 amount);
29     event Withdraw(address investor, uint256 amount);
30     event Bounty(address hunter, uint256 amount);
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     /**
34      * @dev Сonstructor Sets the original roles of the contract
35      */
36 
37     constructor() public {
38         owner = msg.sender;
39         ownerWallet = msg.sender;
40     }
41 
42     /**
43      * @dev Modifiers
44      */
45 
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     /**
52      * @dev Allows current owner to transfer control of the contract to a newOwner.
53      * @param newOwner The address to transfer ownership to.
54      * @param newOwnerWallet The address to transfer ownership to.
55      */
56     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
57         require(newOwner != address(0));
58         emit OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60         ownerWallet = newOwnerWallet;
61     }
62 
63     /**
64      * @dev Investments
65      */
66     function () public payable {
67         buy(0x0);
68     }
69 
70     function buy(address _referredBy) public payable {
71         require(msg.value >= minimum);
72 
73         address _customerAddress = msg.sender;
74 
75         if(
76            // is this a referred purchase?
77            _referredBy != 0x0000000000000000000000000000000000000000 &&
78 
79            // no cheating!
80            _referredBy != _customerAddress &&
81 
82            // does the referrer have at least X whole tokens?
83            // i.e is the referrer a godly chad masternode
84            investments[_referredBy] >= stakingRequirement
85        ){
86            // wealth redistribution
87            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
88        }
89 
90        if (investments[msg.sender] > 0){
91            if (withdraw()){
92                withdrawals[msg.sender] = 0;
93            }
94        }
95        investments[msg.sender] = investments[msg.sender].add(msg.value);
96        joined[msg.sender] = block.timestamp;
97        ownerWallet.transfer(msg.value.mul(5).div(100));
98        emit Invest(msg.sender, msg.value);
99     }
100 
101     /**
102     * @dev Evaluate current balance
103     * @param _address Address of investor
104     */
105     function getBalance(address _address) view public returns (uint256) {
106         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
107         uint256 percent = investments[_address].mul(step).div(100);
108         uint256 different = percent.mul(minutesCount).div(1440);
109         uint256 balance = different.sub(withdrawals[_address]);
110 
111         return balance;
112     }
113 
114     /**
115     * @dev Withdraw dividends from contract
116     */
117     function withdraw() public returns (bool){
118         require(joined[msg.sender] > 0);
119         uint256 balance = getBalance(msg.sender);
120         if (address(this).balance > balance){
121             if (balance > 0){
122                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
123                 msg.sender.transfer(balance);
124                 emit Withdraw(msg.sender, balance);
125             }
126             return true;
127         } else {
128             return false;
129         }
130     }
131 
132     /**
133     * @dev Bounty reward
134     */
135     function bounty() public {
136         uint256 refBalance = checkReferral(msg.sender);
137         if(refBalance >= minimum) {
138              if (address(this).balance > refBalance) {
139                 referrer[msg.sender] = 0;
140                 msg.sender.transfer(refBalance);
141                 emit Bounty(msg.sender, refBalance);
142              }
143         }
144     }
145 
146     /**
147     * @dev Gets balance of the sender address.
148     * @return An uint256 representing the amount owned by the msg.sender.
149     */
150     function checkBalance() public view returns (uint256) {
151         return getBalance(msg.sender);
152     }
153 
154     /**
155     * @dev Gets withdrawals of the specified address.
156     * @param _investor The address to query the the balance of.
157     * @return An uint256 representing the amount owned by the passed address.
158     */
159     function checkWithdrawals(address _investor) public view returns (uint256) {
160         return withdrawals[_investor];
161     }
162 
163     /**
164     * @dev Gets investments of the specified address.
165     * @param _investor The address to query the the balance of.
166     * @return An uint256 representing the amount owned by the passed address.
167     */
168     function checkInvestments(address _investor) public view returns (uint256) {
169         return investments[_investor];
170     }
171 
172     /**
173     * @dev Gets referrer balance of the specified address.
174     * @param _hunter The address of the referrer
175     * @return An uint256 representing the referral earnings.
176     */
177     function checkReferral(address _hunter) public view returns (uint256) {
178         return referrer[_hunter];
179     }
180 }
181 
182 /**
183  * @title SafeMath
184  * @dev Math operations with safety checks that throw on error
185  */
186 library SafeMath {
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         if (a == 0) {
189             return 0;
190         }
191         uint256 c = a * b;
192         assert(c / a == b);
193         return c;
194     }
195 
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         // assert(b > 0); // Solidity automatically throws when dividing by 0
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200         return c;
201     }
202 
203     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
204         assert(b <= a);
205         return a - b;
206     }
207 
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         uint256 c = a + b;
210         assert(c >= a);
211         return c;
212     }
213 }