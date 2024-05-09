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
118 // File: contracts/HodlSale.sol
119 
120 contract HodlSale is Claimable {
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
154     function () public payable {
155         if (msg.value > 0) {
156             buy();
157         } else {
158             claim();
159         }
160     }
161 
162     function buy() public payable {
163         buyWithReward(wallets.fees);
164     }
165 
166     function buyWithReward(address affiliate) whenFunding public payable {
167         Sale storage sale = sales[era];
168         require(msg.value >= sale.minPurchase);
169 
170         require(affiliate != msg.sender);
171         require(affiliate != address(this));
172 
173         uint fee = msg.value.mul(fees.fund).div(fees.divisor);
174         uint reward = msg.value.mul(fees.reward).div(fees.divisor);
175         uint amount = msg.value.sub(fee).sub(reward);
176 
177         balances[wallets.fees] = balances[wallets.fees].add(fee);
178         balances[affiliate] = balances[affiliate].add(reward);
179         balances[wallets.fund] = balances[wallets.fund].add(amount);
180 
181         sale.weiRaised = sale.weiRaised.add(amount);
182 
183         Purchase(era, msg.sender, amount);
184         Reward(affiliate, reward);
185     }
186 
187     function claim() public {
188         if (msg.sender == wallets.fees || msg.sender == wallets.fund) require(!funding());
189         uint payment = balances[msg.sender];
190         require(payment > 0);
191         balances[msg.sender] = 0;
192         msg.sender.transfer(payment);
193         Withdraw(msg.sender, payment);
194     }
195 
196     function funding() public view returns (bool) {
197         Sale storage sale = sales[era];
198         return now >= sale.startTime && now <= sale.endTime;
199     }
200 
201     modifier whenFunding() {
202         require(funding());
203         _;
204     }
205 
206     modifier whenNotFunding() {
207         require(!funding());
208         _;
209     }
210 
211     function updateWallets(address _fund, address _fees) whenNotFunding onlyOwner public {
212         wallets = Wallets(_fund, _fees);
213         NewWallets(_fund, _fees);
214     }
215 
216     function updateFees(uint _fund, uint _reward, uint _divisor) whenNotFunding onlyOwner public {
217         require(_divisor > _fund && _divisor > _reward);
218         fees = Fees(_fund, _reward, _divisor);
219         NewFees(_fund, _reward, _divisor);
220     }
221 
222     function updateSale(uint _startTime, uint _endTime, uint _minPurchase) whenNotFunding onlyOwner public {
223         require(_startTime >= now && _endTime >= _startTime);
224         era = era.add(1);
225         sales[era] = Sale(_startTime, _endTime, _minPurchase, 0);
226         NewSale(era, _startTime, _endTime, _minPurchase);
227     }
228 }