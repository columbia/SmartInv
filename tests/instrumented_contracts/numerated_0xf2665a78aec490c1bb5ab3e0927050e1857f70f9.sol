1 /*
2 The ChefICO Smart Contract has the following features implemented:
3 - ETH can only be deposited before the 1st of July, 2018., and only in amounts greater to or equal to 0.2 ETH.
4 - A address(person) can not deposit ETH to the smart contract after they have already deposited 250 ETH.
5 - It is not possible to deposit ETH to the smart contract once the hard cap has been reached.
6 - If a address(person) deposits an ETH amount which makes the total funds deposited to the smart contract exceed the hard cap, 
7   exceeded amount is returned to the address.
8 - If a address(person) deposits an amount which is greater than 250 ETH, or which makes their total deposits through the ICO 
9   exceed 250 ETH, exceeded amount is returned to the address.
10 
11 - If a address(person) deposits an amount that is less than 10 ETH, they achieve certain bonuses based on the time of the transaction.
12   The time-based bonuses for deposits that are less than 10 ETH are defined as follows:
13     1. Deposits made within the first ten days of the ICO achieve a 20% bonus in CHEF tokens.
14     2. Deposits made within the second ten days of the ICO achieve a 15% bonus in CHEF tokens.
15     3. Deposits made within the third ten days of the ICO achieve a 10% bonus in CHEF tokens.
16     4. Deposits made within the fourth ten days of the ICO achieve a 5% bonus in CHEF tokens.
17 
18 - If a address(person) deposits an amount that is equal to or greater than 10 ETH, they achieve certain bonuses based on the 
19   amount transfered. The volume-based bonuses for deposits that are greater than or equal to 10 ETH are defined as follows:
20     1. Deposits greater than or equal to 150 ETH achieve a 35% bonus in CHEF tokens.
21     2. Deposits smaller than 150 ETH, but greater than or equal to 70 ETH achieve a 30% bonus in CHEF tokens.
22     3. Deposits smaller than 70 ETH, but greater than or equal to 25 ETH achieve a 25% bonus in CHEF tokens.
23     4. Deposits smaller than 25 ETH, but greater than or equal to 10 ETH achieve a 20% bonus in CHEF tokens.
24 
25 Short overview of significant functions:
26 - safeWithdrawal:
27     This function enables users to withdraw the funds they have deposited to the ICO in case the ICO does not reach the soft cap. 
28     It will be possible to withdraw the deposited ETH only after the 1st of July, 2018.
29 - chefOwnerWithdrawal: 
30     This function enables the ICO smart contract owner to withdraw the funds in case the ICO reaches the soft or hard cap 
31     (ie. the ICO is successful). The CHEF tokens will be released to investors manually, after we check the KYC status of each 
32     person that has contributed 10 or more ETH, as well as we confirm that each person has not contributed more than 10 ETH 
33     from several addresses.
34 */
35   
36   pragma solidity 0.4.23;
37   library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     if (a == 0) {
44       return 0;
45     }
46     c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     // uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return a / b;
59   }
60 
61   /**
62   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 contract ChefICO {
80     
81     using SafeMath for uint256;
82     
83     uint256 public softCap;
84     uint256 public hardCap;
85     uint256 public totalAmount;
86     uint256 public chefPrice;
87     uint256 public minimumInvestment;
88     uint256 public maximumInvestment;
89     uint256 public finalBonus;
90     
91     uint256 public icoStart;
92     uint256 public icoEnd;
93     address public chefOwner;
94 
95     bool public softCapReached = false;
96     bool public hardCapReached = false;
97 
98     mapping(address => uint256) public balanceOf;
99     mapping(address => uint256) public chefBalanceOf;
100 
101     event ChefICOSucceed(address indexed recipient, uint totalAmount);
102     event ChefICOTransfer(address indexed tokenHolder, uint value, bool isContribution);
103 
104 
105     function ChefICO() public {
106         softCap = 7000 * 1 ether;
107         hardCap = 22500 * 1 ether;
108         totalAmount = 1100 * 1 ether; //Private presale funds with 35% bonus
109         chefPrice = 0.0001 * 1 ether;
110         minimumInvestment = 1 ether / 5;
111         maximumInvestment = 250 * 1 ether;
112        
113         icoStart = 1525471200;
114         icoEnd = 1530396000;
115         chefOwner = msg.sender;
116     }
117     
118     
119     function balanceOf(address _contributor) public view returns (uint256 balance) {
120         return balanceOf[_contributor];
121     }
122     
123     
124     function chefBalanceOf(address _contributor) public view returns (uint256 balance) {
125         return chefBalanceOf[_contributor];
126     }
127 
128 
129     modifier onlyOwner() {
130         require(msg.sender == chefOwner);
131         _;
132     }
133     
134     
135     modifier afterICOdeadline() { 
136         require(now >= icoEnd );
137             _; 
138         }
139         
140         
141     modifier beforeICOdeadline() { 
142         require(now <= icoEnd );
143             _; 
144         }
145     
146    
147     function () public payable beforeICOdeadline {
148         uint256 amount = msg.value;
149         require(!hardCapReached);
150         require(amount >= minimumInvestment && balanceOf[msg.sender] < maximumInvestment);
151         
152         if(hardCap <= totalAmount.add(amount)) {
153             hardCapReached = true;
154             emit ChefICOSucceed(chefOwner, hardCap);
155             
156              if(hardCap < totalAmount.add(amount)) {
157                 uint256 returnAmount = totalAmount.add(amount).sub(hardCap);
158                 msg.sender.transfer(returnAmount);
159                 emit ChefICOTransfer(msg.sender, returnAmount, false);
160                 amount = amount.sub(returnAmount);    
161              }
162         }
163         
164         if(maximumInvestment < balanceOf[msg.sender].add(amount)) {
165           uint overMaxAmount = balanceOf[msg.sender].add(amount).sub(maximumInvestment);
166           msg.sender.transfer(overMaxAmount);
167           emit ChefICOTransfer(msg.sender, overMaxAmount, false);
168           amount = amount.sub(overMaxAmount);
169         }
170 
171         totalAmount = totalAmount.add(amount);
172         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
173                
174         if (amount >= 10 ether) {
175             if (amount >= 150 ether) {
176                 chefBalanceOf[msg.sender] = chefBalanceOf[msg.sender].add(amount.div(chefPrice).mul(135).div(100));
177             }
178             else if (amount >= 70 ether) {
179                 chefBalanceOf[msg.sender] = chefBalanceOf[msg.sender].add(amount.div(chefPrice).mul(130).div(100));
180             }
181             else if (amount >= 25 ether) {
182                 chefBalanceOf[msg.sender] = chefBalanceOf[msg.sender].add(amount.div(chefPrice).mul(125).div(100));
183             }
184             else {
185                 chefBalanceOf[msg.sender] = chefBalanceOf[msg.sender].add(amount.div(chefPrice).mul(120).div(100));
186             }
187         }
188         else if (now <= icoStart.add(10 days)) {
189             chefBalanceOf[msg.sender] = chefBalanceOf[msg.sender].add(amount.div(chefPrice).mul(120).div(100));
190         }
191         else if (now <= icoStart.add(20 days)) {
192             chefBalanceOf[msg.sender] = chefBalanceOf[msg.sender].add(amount.div(chefPrice).mul(115).div(100));
193         }
194         else if (now <= icoStart.add(30 days)) {
195             chefBalanceOf[msg.sender] = chefBalanceOf[msg.sender].add(amount.div(chefPrice).mul(110).div(100));
196         }
197         else if (now <= icoStart.add(40 days)) {
198             chefBalanceOf[msg.sender] = chefBalanceOf[msg.sender].add(amount.div(chefPrice).mul(105).div(100));
199         }
200         else {
201             chefBalanceOf[msg.sender] = chefBalanceOf[msg.sender].add(amount.div(chefPrice));
202         }
203         
204         emit ChefICOTransfer(msg.sender, amount, true);
205         
206         if (totalAmount >= softCap && softCapReached == false ){
207         softCapReached = true;
208         emit ChefICOSucceed(chefOwner, totalAmount);
209         }
210     }
211 
212     
213    function safeWithdrawal() public afterICOdeadline {
214         if (!softCapReached) {
215 	    uint256 amount = balanceOf[msg.sender];
216             balanceOf[msg.sender] = 0;
217             if (amount > 0) {
218                 msg.sender.transfer(amount);
219                 emit ChefICOTransfer(msg.sender, amount, false);
220             }
221         }
222     }
223         
224     
225     function chefOwnerWithdrawal() public onlyOwner {    
226         if ((now >= icoEnd && softCapReached) || hardCapReached) {
227             chefOwner.transfer(totalAmount);
228             emit ChefICOTransfer(chefOwner, totalAmount, false);
229         }
230     }
231 }