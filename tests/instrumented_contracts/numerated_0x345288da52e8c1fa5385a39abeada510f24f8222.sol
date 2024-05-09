1 pragma solidity ^0.4.24;
2 
3 
4 contract Exodus21{
5     
6     using SafeMath for uint256;
7 
8     mapping(address => uint256) investments;
9     mapping(address => uint256) joined;
10     mapping(address => uint256) withdrawals;
11     mapping(address => uint256) referrer;
12 
13     uint256 public minimum = 10000000000000000;
14     uint256 public step = 21;
15     address public ownerWallet;
16     address public owner;
17     address public bountyManager;
18     address promoter = 0x4553d99872248020CC4C37519a4156167170E3C6;
19     /***Card holders Fund*/
20 
21     event Invest(address investor, uint256 amount);
22     event Withdraw(address investor, uint256 amount);
23     event Bounty(address hunter, uint256 amount);
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25     
26     /**
27      * @dev Сonstructor Sets the original roles of the contract 
28      */
29      
30     constructor(address _bountyManager) public {
31         owner = msg.sender;
32         ownerWallet = msg.sender;
33         bountyManager = _bountyManager;
34     }
35 
36     /**
37      * @dev Modifiers
38      */
39      
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     modifier onlyBountyManager() {
46         require(msg.sender == bountyManager);
47         _;
48 	}
49 
50     /**
51      * @dev Allows current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      * @param newOwnerWallet The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
56         require(newOwner != address(0));
57         emit OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59         ownerWallet = newOwnerWallet;
60     }
61 
62     /**
63      * @dev Investments
64      */
65     function () external payable {
66         require(msg.value >= minimum);
67         if (investments[msg.sender] > 0){
68             if (withdraw()){
69                 withdrawals[msg.sender] = 0;
70             }
71         }
72         investments[msg.sender] = investments[msg.sender].add(msg.value);
73         joined[msg.sender] = block.timestamp;
74         ownerWallet.transfer(msg.value.div(100).mul(5));
75         promoter.transfer(msg.value.div(100).mul(5));
76         emit Invest(msg.sender, msg.value);
77     }
78 
79     /**
80     * @dev Evaluate current balance
81     * @param _address Address of investor
82     */
83     function getBalance(address _address) view public returns (uint256) {
84         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
85         uint256 percent = investments[_address].mul(step).div(100);
86         uint256 different = percent.mul(minutesCount).div(1440);
87         uint256 balance = different.sub(withdrawals[_address]);
88 
89         return balance;
90     }
91 
92     /**
93     * @dev Withdraw dividends from contract
94     */
95     function withdraw() public returns (bool){
96         require(joined[msg.sender] > 0);
97         uint256 balance = getBalance(msg.sender);
98         if (address(this).balance > balance){
99             if (balance > 0){
100                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
101                 msg.sender.transfer(balance);
102                 emit Withdraw(msg.sender, balance);
103             }
104             return true;
105         } else {
106             return false;
107         }
108     }
109     
110     /**
111     * @dev Bounty reward
112     */
113     function bounty() public {
114         uint256 refBalance = checkReferral(msg.sender);
115         if(refBalance >= minimum) {
116              if (address(this).balance > refBalance) {
117                 referrer[msg.sender] = 0;
118                 msg.sender.transfer(refBalance);
119                 emit Bounty(msg.sender, refBalance);
120              }
121         }
122     }
123 
124     /**
125     * @dev Gets balance of the sender address.
126     * @return An uint256 representing the amount owned by the msg.sender.
127     */
128     function checkBalance() public view returns (uint256) {
129         return getBalance(msg.sender);
130     }
131 
132     /**
133     * @dev Gets withdrawals of the specified address.
134     * @param _investor The address to query the the balance of.
135     * @return An uint256 representing the amount owned by the passed address.
136     */
137     function checkWithdrawals(address _investor) public view returns (uint256) {
138         return withdrawals[_investor];
139     }
140 
141     /**
142     * @dev Gets investments of the specified address.
143     * @param _investor The address to query the the balance of.
144     * @return An uint256 representing the amount owned by the passed address.
145     */
146     function checkInvestments(address _investor) public view returns (uint256) {
147         return investments[_investor];
148     }
149 
150     /**
151     * @dev Gets referrer balance of the specified address.
152     * @param _hunter The address of the referrer
153     * @return An uint256 representing the referral earnings.
154     */
155     function checkReferral(address _hunter) public view returns (uint256) {
156         return referrer[_hunter];
157     }
158     
159     /**
160     * @dev Updates referrer balance 
161     * @param _hunter The address of the referrer
162     * @param _amount An uint256 representing the referral earnings.
163     */
164     function updateReferral(address _hunter, uint256 _amount) onlyBountyManager public {
165         referrer[_hunter] = referrer[_hunter].add(_amount);
166     }
167     
168 }
169 
170 /**
171  * @title SafeMath
172  * @dev Math operations with safety checks that throw on error
173  */
174 library SafeMath {
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         if (a == 0) {
177             return 0;
178         }
179         uint256 c = a * b;
180         assert(c / a == b);
181         return c;
182     }
183 
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         // assert(b > 0); // Solidity automatically throws when dividing by 0
186         uint256 c = a / b;
187         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188         return c;
189     }
190 
191     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192         assert(b <= a);
193         return a - b;
194     }
195 
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         assert(c >= a);
199         return c;
200     }
201 }