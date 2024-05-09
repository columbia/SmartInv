1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 * $$\   $$\ $$\   $$\ 
6 * $$ |  $$ |\__| $$  |
7 * $$ |  $$ |    $$  / 
8 * $$$$$$$$ |   $$  /  
9 * \_____$$ |  $$  /   
10 *       $$ | $$  /    
11 *       $$ |$$  / $$\ 
12 *       \__|\__/  \__|
13 */
14 contract Fever{
15     
16     using SafeMath for uint256;
17 
18     mapping(address => uint256) investments;
19     mapping(address => uint256) joined;
20     mapping(address => uint256) withdrawals;
21     mapping(address => uint256) referrer;
22 
23     uint256 public minimum = 10000000000000000;
24     uint256 public step = 4;
25     address public ownerWallet;
26     address public owner;
27     address public bountyManager;
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
38     constructor(address _bountyManager) public {
39         owner = msg.sender;
40         ownerWallet = msg.sender;
41         bountyManager = _bountyManager;
42     }
43 
44     /**
45      * @dev Modifiers
46      */
47      
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     modifier onlyBountyManager() {
54         require(msg.sender == bountyManager);
55         _;
56 	}
57 
58     /**
59      * @dev Allows current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      * @param newOwnerWallet The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
64         require(newOwner != address(0));
65         emit OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         ownerWallet = newOwnerWallet;
68     }
69 
70     /**
71      * @dev Investments
72      */
73     function () external payable {
74         require(msg.value >= minimum);
75         if (investments[msg.sender] > 0){
76             if (withdraw()){
77                 withdrawals[msg.sender] = 0;
78             }
79         }
80         investments[msg.sender] = investments[msg.sender].add(msg.value);
81         joined[msg.sender] = block.timestamp;
82         ownerWallet.transfer(msg.value.div(100).mul(5));
83         emit Invest(msg.sender, msg.value);
84     }
85 
86     /**
87     * @dev Evaluate current balance
88     * @param _address Address of investor
89     */
90     function getBalance(address _address) view public returns (uint256) {
91         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
92         uint256 percent = investments[_address].mul(step).div(100);
93         uint256 different = percent.mul(minutesCount).div(1440);
94         uint256 balance = different.sub(withdrawals[_address]);
95 
96         return balance;
97     }
98 
99     /**
100     * @dev Withdraw dividends from contract
101     */
102     function withdraw() public returns (bool){
103         require(joined[msg.sender] > 0);
104         uint256 balance = getBalance(msg.sender);
105         if (address(this).balance > balance){
106             if (balance > 0){
107                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
108                 msg.sender.transfer(balance);
109                 emit Withdraw(msg.sender, balance);
110             }
111             return true;
112         } else {
113             return false;
114         }
115     }
116     
117     /**
118     * @dev Bounty reward
119     */
120     function bounty() public {
121         uint256 refBalance = checkReferral(msg.sender);
122         if(refBalance >= minimum) {
123              if (address(this).balance > refBalance) {
124                 referrer[msg.sender] = 0;
125                 msg.sender.transfer(refBalance);
126                 emit Bounty(msg.sender, refBalance);
127              }
128         }
129     }
130 
131     /**
132     * @dev Gets balance of the sender address.
133     * @return An uint256 representing the amount owned by the msg.sender.
134     */
135     function checkBalance() public view returns (uint256) {
136         return getBalance(msg.sender);
137     }
138 
139     /**
140     * @dev Gets withdrawals of the specified address.
141     * @param _investor The address to query the the balance of.
142     * @return An uint256 representing the amount owned by the passed address.
143     */
144     function checkWithdrawals(address _investor) public view returns (uint256) {
145         return withdrawals[_investor];
146     }
147 
148     /**
149     * @dev Gets investments of the specified address.
150     * @param _investor The address to query the the balance of.
151     * @return An uint256 representing the amount owned by the passed address.
152     */
153     function checkInvestments(address _investor) public view returns (uint256) {
154         return investments[_investor];
155     }
156 
157     /**
158     * @dev Gets referrer balance of the specified address.
159     * @param _hunter The address of the referrer
160     * @return An uint256 representing the referral earnings.
161     */
162     function checkReferral(address _hunter) public view returns (uint256) {
163         return referrer[_hunter];
164     }
165     
166     /**
167     * @dev Updates referrer balance 
168     * @param _hunter The address of the referrer
169     * @param _amount An uint256 representing the referral earnings.
170     */
171     function updateReferral(address _hunter, uint256 _amount) onlyBountyManager public {
172         referrer[_hunter] = referrer[_hunter].add(_amount);
173     }
174     
175 }
176 
177 /**
178  * @title SafeMath
179  * @dev Math operations with safety checks that throw on error
180  */
181 library SafeMath {
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         if (a == 0) {
184             return 0;
185         }
186         uint256 c = a * b;
187         assert(c / a == b);
188         return c;
189     }
190 
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         // assert(b > 0); // Solidity automatically throws when dividing by 0
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195         return c;
196     }
197 
198     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
199         assert(b <= a);
200         return a - b;
201     }
202 
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         uint256 c = a + b;
205         assert(c >= a);
206         return c;
207     }
208 }