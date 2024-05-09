1 pragma solidity ^0.4.25;
2 
3 /**
4 *
5 -------------------------------------------------------------------------------------------------------
6     Website: https://lootether.com/
7     Exchange (We recomand to use MetaMask or TrustWallet): https://lootether.com/exchange
8     Second Exchange (We recomand to use MetaMask or TrustWallet): https://lootether.com/second
9     Daily Dividends 10% (We recomand to use MetaMask or TrustWallet): https://lootether.com/daily
10     Twitter: https://twitter.com/lootether
11     Discord: https://discordapp.com/invite/bTK4KbB
12     -------------------------------------------------------------------------------------------------------
13 */
14 contract LootEtherDailyDividends {
15 
16     using SafeMath for uint256;
17 
18     mapping(address => uint256) investments;
19     mapping(address => uint256) joined;
20     mapping(address => uint256) withdrawals;
21     mapping(address => uint256) referrer;
22 
23     uint256 public step = 10;
24     uint256 public minimum = 10 finney;
25     uint256 public stakingRequirement = 0.01 ether;
26     address public ownerWallet;
27     address public owner;
28 
29     event Invest(address investor, uint256 amount);
30     event Withdraw(address investor, uint256 amount);
31     event Bounty(address hunter, uint256 amount);
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     /**
35      * @dev Сonstructor Sets the original roles of the contract
36      */
37 
38     constructor() public {
39         owner = msg.sender;
40         ownerWallet = msg.sender;
41     }
42 
43     /**
44      * @dev Modifiers
45      */
46 
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     /**
53      * @dev Allows current owner to transfer control of the contract to a newOwner.
54      * @param newOwner The address to transfer ownership to.
55      * @param newOwnerWallet The address to transfer ownership to.
56      */
57     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
58         require(newOwner != address(0));
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         ownerWallet = newOwnerWallet;
62     }
63 
64     /**
65      * @dev Investments
66      */
67     function () public payable {
68         buy(0x0);
69     }
70 
71     function buy(address _referredBy) public payable {
72         require(msg.value >= minimum);
73 
74         address _customerAddress = msg.sender;
75 
76         if(
77            // is this a referred purchase?
78            _referredBy != 0x0000000000000000000000000000000000000000 &&
79 
80            // no cheating!
81            _referredBy != _customerAddress &&
82 
83            // does the referrer have at least X whole tokens?
84            // i.e is the referrer a godly chad masternode
85            investments[_referredBy] >= stakingRequirement
86        ){
87            // wealth redistribution
88            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
89        }
90 
91        if (investments[msg.sender] > 0){
92            if (withdraw()){
93                withdrawals[msg.sender] = 0;
94            }
95        }
96        investments[msg.sender] = investments[msg.sender].add(msg.value);
97        joined[msg.sender] = block.timestamp;
98        ownerWallet.transfer(msg.value.mul(10).div(100));
99        emit Invest(msg.sender, msg.value);
100     }
101 
102     /**
103     * @dev Evaluate current balance
104     * @param _address Address of investor
105     */
106     function getBalance(address _address) view public returns (uint256) {
107         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
108         uint256 percent = investments[_address].mul(step).div(100);
109         uint256 different = percent.mul(minutesCount).div(1440);
110         uint256 balance = different.sub(withdrawals[_address]);
111 
112         return balance;
113     }
114 
115     /**
116     * @dev Withdraw dividends from contract
117     */
118     function withdraw() public returns (bool){
119         require(joined[msg.sender] > 0);
120         uint256 balance = getBalance(msg.sender);
121         if (address(this).balance > balance){
122             if (balance > 0){
123                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
124                 msg.sender.transfer(balance);
125                 emit Withdraw(msg.sender, balance);
126             }
127             return true;
128         } else {
129             return false;
130         }
131     }
132 
133     /**
134     * @dev Bounty reward
135     */
136     function bounty() public {
137         uint256 refBalance = checkReferral(msg.sender);
138         if(refBalance >= minimum) {
139              if (address(this).balance > refBalance) {
140                 referrer[msg.sender] = 0;
141                 msg.sender.transfer(refBalance);
142                 emit Bounty(msg.sender, refBalance);
143              }
144         }
145     }
146 
147     /**
148     * @dev Gets balance of the sender address.
149     * @return An uint256 representing the amount owned by the msg.sender.
150     */
151     function checkBalance() public view returns (uint256) {
152         return getBalance(msg.sender);
153     }
154 
155     /**
156     * @dev Gets withdrawals of the specified address.
157     * @param _investor The address to query the the balance of.
158     * @return An uint256 representing the amount owned by the passed address.
159     */
160     function checkWithdrawals(address _investor) public view returns (uint256) {
161         return withdrawals[_investor];
162     }
163 
164     /**
165     * @dev Gets investments of the specified address.
166     * @param _investor The address to query the the balance of.
167     * @return An uint256 representing the amount owned by the passed address.
168     */
169     function checkInvestments(address _investor) public view returns (uint256) {
170         return investments[_investor];
171     }
172 
173     /**
174     * @dev Gets referrer balance of the specified address.
175     * @param _hunter The address of the referrer
176     * @return An uint256 representing the referral earnings.
177     */
178     function checkReferral(address _hunter) public view returns (uint256) {
179         return referrer[_hunter];
180     }
181 }
182 
183 /**
184  * @title SafeMath
185  * @dev Math operations with safety checks that throw on error
186  */
187 library SafeMath {
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         if (a == 0) {
190             return 0;
191         }
192         uint256 c = a * b;
193         assert(c / a == b);
194         return c;
195     }
196 
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         // assert(b > 0); // Solidity automatically throws when dividing by 0
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201         return c;
202     }
203 
204     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205         assert(b <= a);
206         return a - b;
207     }
208 
209     function add(uint256 a, uint256 b) internal pure returns (uint256) {
210         uint256 c = a + b;
211         assert(c >= a);
212         return c;
213     }
214 }