1 pragma solidity ^0.4.24;
2 
3 /**
4 *     https://doubledivs.cash/
5 *      _______   ______    __    __  .______    __       _______ 
6 *     |       \ /  __  \  |  |  |  | |   _  \  |  |     |   ____|
7 *     |  .--.  |  |  |  | |  |  |  | |  |_)  | |  |     |  |__   
8 *     |  |  |  |  |  |  | |  |  |  | |   _  <  |  |     |   __|  
9 *     |  '--'  |  `--'  | |  `--'  | |  |_)  | |  `----.|  |____ 
10 *     |_______/ \______/   \______/  |______/  |_______||_______|
11 *                                                                
12 *      _______   __  ____    ____   _______.                     
13 *     |       \ |  | \   \  /   /  /       |                     
14 *     |  .--.  ||  |  \   \/   /  |   (----`                     
15 *     |  |  |  ||  |   \      /    \   \                         
16 *     |  '--'  ||  |    \    / .----)   |                        
17 *     |_______/ |__|     \__/  |_______/                         
18 *                                                     
19 *     DOUBLEDIVS 50% DIVIDENDS. FOREVER.
20 *     
21 *     https://doubledivs.cash/
22 *     https://doubledivs.cash/
23 */
24 contract DOUBLEDIVS{
25     
26     using SafeMath for uint256;
27 
28     mapping(address => uint256) investments;
29     mapping(address => uint256) joined;
30     mapping(address => uint256) withdrawals;
31     mapping(address => uint256) referrer;
32 
33     uint256 public minimum = 10000000000000000;
34     uint256 public step = 50;
35     address public ownerWallet;
36     address public owner;
37     address public bountyManager;
38     address promoter = 0x28F0088308CDc140C2D72fBeA0b8e529cAA5Cb40;
39 
40     event Invest(address investor, uint256 amount);
41     event Withdraw(address investor, uint256 amount);
42     event Bounty(address hunter, uint256 amount);
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44     
45     /**
46      * @dev Сonstructor Sets the original roles of the contract 
47      */
48      
49     constructor(address _bountyManager) public {
50         owner = msg.sender;
51         ownerWallet = msg.sender;
52         bountyManager = _bountyManager;
53     }
54 
55     /**
56      * @dev Modifiers
57      */
58      
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     modifier onlyBountyManager() {
65         require(msg.sender == bountyManager);
66         _;
67 	}
68 
69     /**
70      * @dev Allows current owner to transfer control of the contract to a newOwner.
71      * @param newOwner The address to transfer ownership to.
72      * @param newOwnerWallet The address to transfer ownership to.
73      */
74     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
75         require(newOwner != address(0));
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         ownerWallet = newOwnerWallet;
79     }
80 
81     /**
82      * @dev Investments
83      */
84     function () external payable {
85         require(msg.value >= minimum);
86         if (investments[msg.sender] > 0){
87             if (withdraw()){
88                 withdrawals[msg.sender] = 0;
89             }
90         }
91         investments[msg.sender] = investments[msg.sender].add(msg.value);
92         joined[msg.sender] = block.timestamp;
93         ownerWallet.transfer(msg.value.div(100).mul(5));
94         promoter.transfer(msg.value.div(100).mul(5));
95         emit Invest(msg.sender, msg.value);
96     }
97 
98     /**
99     * @dev Evaluate current balance
100     * @param _address Address of investor
101     */
102     function getBalance(address _address) view public returns (uint256) {
103         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
104         uint256 percent = investments[_address].mul(step).div(100);
105         uint256 different = percent.mul(minutesCount).div(1440);
106         uint256 balance = different.sub(withdrawals[_address]);
107 
108         return balance;
109     }
110 
111     /**
112     * @dev Withdraw dividends from contract
113     */
114     function withdraw() public returns (bool){
115         require(joined[msg.sender] > 0);
116         uint256 balance = getBalance(msg.sender);
117         if (address(this).balance > balance){
118             if (balance > 0){
119                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
120                 msg.sender.transfer(balance);
121                 emit Withdraw(msg.sender, balance);
122             }
123             return true;
124         } else {
125             return false;
126         }
127     }
128     
129     /**
130     * @dev Bounty reward
131     */
132     function bounty() public {
133         uint256 refBalance = checkReferral(msg.sender);
134         if(refBalance >= minimum) {
135              if (address(this).balance > refBalance) {
136                 referrer[msg.sender] = 0;
137                 msg.sender.transfer(refBalance);
138                 emit Bounty(msg.sender, refBalance);
139              }
140         }
141     }
142 
143     /**
144     * @dev Gets balance of the sender address.
145     * @return An uint256 representing the amount owned by the msg.sender.
146     */
147     function checkBalance() public view returns (uint256) {
148         return getBalance(msg.sender);
149     }
150 
151     /**
152     * @dev Gets withdrawals of the specified address.
153     * @param _investor The address to query the the balance of.
154     * @return An uint256 representing the amount owned by the passed address.
155     */
156     function checkWithdrawals(address _investor) public view returns (uint256) {
157         return withdrawals[_investor];
158     }
159 
160     /**
161     * @dev Gets investments of the specified address.
162     * @param _investor The address to query the the balance of.
163     * @return An uint256 representing the amount owned by the passed address.
164     */
165     function checkInvestments(address _investor) public view returns (uint256) {
166         return investments[_investor];
167     }
168 
169     /**
170     * @dev Gets referrer balance of the specified address.
171     * @param _hunter The address of the referrer
172     * @return An uint256 representing the referral earnings.
173     */
174     function checkReferral(address _hunter) public view returns (uint256) {
175         return referrer[_hunter];
176     }
177 
178     
179 }
180 
181 /**
182  * @title SafeMath
183  * @dev Math operations with safety checks that throw on error
184  */
185 library SafeMath {
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         if (a == 0) {
188             return 0;
189         }
190         uint256 c = a * b;
191         assert(c / a == b);
192         return c;
193     }
194 
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         // assert(b > 0); // Solidity automatically throws when dividing by 0
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199         return c;
200     }
201 
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         assert(b <= a);
204         return a - b;
205     }
206 
207     function add(uint256 a, uint256 b) internal pure returns (uint256) {
208         uint256 c = a + b;
209         assert(c >= a);
210         return c;
211     }
212 }