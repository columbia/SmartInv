1 pragma solidity ^0.4.24;
2 
3 contract fomoconnect{
4     
5     using SafeMath for uint256;
6 
7     mapping(address => uint256) investments;
8     mapping(address => uint256) joined;
9     mapping(address => uint256) withdrawals;
10     mapping(address => uint256) referrer;
11 
12     uint256 public minimum = 10000000000000000;
13     uint256 public step = 5;
14     address public ownerWallet;
15     address public ownerWallet2 = 0x20007c6aa01e6a0e73d1baB69666438FF43B5ed8;
16     address public owner;
17     address public bountyManager;
18 
19     event Invest(address investor, uint256 amount);
20     event Withdraw(address investor, uint256 amount);
21     event Bounty(address hunter, uint256 amount);
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23     
24     /**
25      * @dev Сonstructor Sets the original roles of the contract 
26      */
27      
28     constructor(address _bountyManager) public {
29         owner = msg.sender;
30         ownerWallet = msg.sender;
31         bountyManager = _bountyManager;
32     }
33 
34     /**
35      * @dev Modifiers
36      */
37      
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     modifier onlyBountyManager() {
44         require(msg.sender == bountyManager);
45         _;
46 	}
47 
48     /**
49      * @dev Allows current owner to transfer control of the contract to a newOwner.
50      * @param newOwner The address to transfer ownership to.
51      * @param newOwnerWallet The address to transfer ownership to.
52      */
53     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
54         require(newOwner != address(0));
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         ownerWallet = newOwnerWallet;
58     }
59 
60     /**
61      * @dev Investments
62      */
63     function () external payable {
64         require(msg.value >= minimum);
65         if (investments[msg.sender] > 0){
66             if (withdraw()){
67                 withdrawals[msg.sender] = 0;
68             }
69         }
70         investments[msg.sender] = investments[msg.sender].add(msg.value);
71         joined[msg.sender] = block.timestamp;
72         ownerWallet.transfer(msg.value.div(100).mul(5));
73         ownerWallet2.transfer(msg.value.div(100).mul(5));
74         emit Invest(msg.sender, msg.value);
75         step++;
76     }
77 
78     /**
79     * @dev Evaluate current balance
80     * @param _address Address of investor
81     */
82     function getBalance(address _address) view public returns (uint256) {
83         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
84         uint256 percent = investments[_address].mul(step).div(100);
85         uint256 different = percent.mul(minutesCount).div(1440);
86         uint256 balance = different.sub(withdrawals[_address]);
87 
88         return balance;
89     }
90     
91     function getStep() view public returns (uint256) {
92         return step;
93     }
94 
95     /**
96     * @dev Withdraw dividends from contract
97     */
98     function withdraw() public returns (bool){
99         require(joined[msg.sender] > 0);
100         uint256 balance = getBalance(msg.sender);
101         if (address(this).balance > balance){
102             if (balance > 0){
103                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
104                 msg.sender.transfer(balance);
105                 emit Withdraw(msg.sender, balance);
106             }
107             return true;
108         } else {
109             return false;
110         }
111     }
112     
113     /**
114     * @dev Bounty reward
115     */
116     function bounty() public {
117         uint256 refBalance = checkReferral(msg.sender);
118         if(refBalance >= minimum) {
119              if (address(this).balance > refBalance) {
120                 referrer[msg.sender] = 0;
121                 msg.sender.transfer(refBalance);
122                 emit Bounty(msg.sender, refBalance);
123              }
124         }
125     }
126 
127     /**
128     * @dev Gets balance of the sender address.
129     * @return An uint256 representing the amount owned by the msg.sender.
130     */
131     function checkBalance() public view returns (uint256) {
132         return getBalance(msg.sender);
133     }
134 
135     /**
136     * @dev Gets withdrawals of the specified address.
137     * @param _investor The address to query the the balance of.
138     * @return An uint256 representing the amount owned by the passed address.
139     */
140     function checkWithdrawals(address _investor) public view returns (uint256) {
141         return withdrawals[_investor];
142     }
143 
144     /**
145     * @dev Gets investments of the specified address.
146     * @param _investor The address to query the the balance of.
147     * @return An uint256 representing the amount owned by the passed address.
148     */
149     function checkInvestments(address _investor) public view returns (uint256) {
150         return investments[_investor];
151     }
152 
153     /**
154     * @dev Gets referrer balance of the specified address.
155     * @param _hunter The address of the referrer
156     * @return An uint256 representing the referral earnings.
157     */
158     function checkReferral(address _hunter) public view returns (uint256) {
159         return referrer[_hunter];
160     }
161     
162     /**
163     * @dev Updates referrer balance 
164     * @param _hunter The address of the referrer
165     * @param _amount An uint256 representing the referral earnings.
166     */
167     function updateReferral(address _hunter, uint256 _amount) onlyBountyManager public {
168         referrer[_hunter] = referrer[_hunter].add(_amount);
169     }
170     
171 }
172 
173 /**
174  * @title SafeMath
175  * @dev Math operations with safety checks that throw on error
176  */
177 library SafeMath {
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         if (a == 0) {
180             return 0;
181         }
182         uint256 c = a * b;
183         assert(c / a == b);
184         return c;
185     }
186 
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         // assert(b > 0); // Solidity automatically throws when dividing by 0
189         uint256 c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191         return c;
192     }
193 
194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195         assert(b <= a);
196         return a - b;
197     }
198 
199     function add(uint256 a, uint256 b) internal pure returns (uint256) {
200         uint256 c = a + b;
201         assert(c >= a);
202         return c;
203     }
204 }