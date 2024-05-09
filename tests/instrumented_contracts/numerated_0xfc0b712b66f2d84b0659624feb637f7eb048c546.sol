1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
83 
84 /**
85  * @title Claimable
86  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
87  * This allows the new owner to accept the transfer.
88  */
89 contract Claimable is Ownable {
90   address public pendingOwner;
91 
92   /**
93    * @dev Modifier throws if called by any account other than the pendingOwner.
94    */
95   modifier onlyPendingOwner() {
96     require(msg.sender == pendingOwner);
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to set the pendingOwner address.
102    * @param newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address newOwner) onlyOwner public {
105     pendingOwner = newOwner;
106   }
107 
108   /**
109    * @dev Allows the pendingOwner address to finalize the transfer.
110    */
111   function claimOwnership() onlyPendingOwner public {
112     OwnershipTransferred(owner, pendingOwner);
113     owner = pendingOwner;
114     pendingOwner = address(0);
115   }
116 }
117 
118 // File: contracts/DtktSale.sol
119 
120 contract DtktSale is Claimable {
121     using SafeMath for uint256;
122 
123     struct Sale {
124         uint startTime;
125         uint endTime;
126         uint minPurchase;
127         uint weiRaised;
128     }
129 
130     struct Fees {
131         uint fund;
132         uint reward;
133         uint divisor;
134     }
135 
136     struct Wallets {
137         address fund;
138         address fees;
139     }
140 
141     uint public era;
142     Fees public fees;
143     Wallets public wallets;
144     mapping(uint => Sale) public sales;
145     mapping(address => uint) public balances;
146 
147     event NewSale(uint era, uint startTime, uint endTime, uint minPurchase);
148     event NewFees(uint fund, uint reward, uint divisor);
149     event NewWallets(address fund, address fees);
150     event Purchase(uint indexed era, address indexed wallet, uint amount);
151     event Reward(address indexed affiliate, uint amount);
152     event Withdraw(address indexed wallet, uint amount);
153 
154 		function HoduSale() public {
155 			//set default
156 			updateWallets(msg.sender, msg.sender);
157 			updateFees(4, 1, 100);
158 		}
159 
160     function () public payable {
161         if (msg.value > 0) {
162             buy();
163         } else {
164             claim();
165         }
166     }
167 
168     function buy() public payable {
169         buyWithReward(wallets.fees);
170     }
171 
172     function buyWithReward(address affiliate) whenFunding public payable {
173         Sale storage sale = sales[era];
174         require(msg.value >= sale.minPurchase);
175 
176         require(affiliate != msg.sender);
177         require(affiliate != address(this));
178 
179         uint fee = msg.value.mul(fees.fund).div(fees.divisor);
180         uint reward = msg.value.mul(fees.reward).div(fees.divisor);
181         uint amount = msg.value.sub(fee).sub(reward);
182 
183         balances[wallets.fees] = balances[wallets.fees].add(fee);
184         balances[affiliate] = balances[affiliate].add(reward);
185         balances[wallets.fund] = balances[wallets.fund].add(amount);
186 
187         sale.weiRaised = sale.weiRaised.add(amount);
188 
189         Purchase(era, msg.sender, amount);
190         Reward(affiliate, reward);
191     }
192 
193     function claim() public {
194         if (msg.sender == wallets.fees || msg.sender == wallets.fund) require(!funding());
195         uint payment = balances[msg.sender];
196         require(payment > 0);
197         balances[msg.sender] = 0;
198         msg.sender.transfer(payment);
199         Withdraw(msg.sender, payment);
200     }
201 
202     function funding() public view returns (bool) {
203         Sale storage sale = sales[era];
204         return now >= sale.startTime && now <= sale.endTime;
205     }
206 
207     modifier whenFunding() {
208         require(funding());
209         _;
210     }
211 
212     modifier whenNotFunding() {
213         require(!funding());
214         _;
215     }
216 
217     function updateWallets(address _fund, address _fees) whenNotFunding onlyOwner public {
218         wallets = Wallets(_fund, _fees);
219         NewWallets(_fund, _fees);
220     }
221 
222     function updateFees(uint _fund, uint _reward, uint _divisor) whenNotFunding onlyOwner public {
223         require(_divisor > _fund && _divisor > _reward);
224         fees = Fees(_fund, _reward, _divisor);
225         NewFees(_fund, _reward, _divisor);
226     }
227 
228     function addSale(uint _startTime, uint _endTime, uint _minPurchase) whenNotFunding onlyOwner public {
229         require(_startTime >= now && _endTime >= _startTime);
230         era = era.add(1);
231         sales[era] = Sale(_startTime, _endTime, _minPurchase, 0);
232         NewSale(era, _startTime, _endTime, _minPurchase);
233     }
234 }