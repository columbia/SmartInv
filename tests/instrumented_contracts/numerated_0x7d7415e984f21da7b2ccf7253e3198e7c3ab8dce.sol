1 pragma solidity ^0.4.18;
2 
3 /**
4 * Ponzi Trust Token Seller Smart Contract
5 * Code is published on https://github.com/PonziTrust/TokenSeller
6 * Ponzi Trust https://ponzitrust.com/
7 */
8 
9 // see: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 
40 // Ponzi Token Minimal Interface
41 contract PonziTokenMinInterface {
42   function balanceOf(address owner) public view returns(uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44 }
45 
46 
47 contract PonziSeller {
48   using SafeMath for uint256;
49   enum AccessRank {
50     None,
51     SetPrice,
52     Withdraw,
53     Full
54   }
55 
56   address private constant PONZI_ADDRESS = 0xc2807533832807Bf15898778D8A108405e9edfb1;
57   PonziTokenMinInterface private m_ponzi;
58   uint256 private m_ponziPriceInWei;
59   uint256 private m_rewardNum;
60   uint256 private m_rewardDen;
61   uint256 private m_discountNum;
62   uint256 private m_discountDen;
63   mapping(address => AccessRank) private m_admins;
64 
65   event PriceChanged(address indexed who, uint256 newPrice);
66   event RewardRef(address indexed refAddr, uint256 ponziAmount);
67   event WithdrawalETH(address indexed to, uint256 amountInWei);
68   event WithdrawalPonzi(address indexed to, uint256 amount);
69   event ProvidingAccess(address indexed addr, AccessRank rank);
70   event PonziSold(
71     address indexed purchasedBy, 
72     uint256 indexed priceInWei, 
73     uint256 ponziAmount, 
74     uint256 weiAmount, 
75     address indexed refAddr 
76   );
77   event NotEnoughPonzi(
78     address indexed addr, 
79     uint256 weiAmount, 
80     uint256 ponziPriceInWei, 
81     uint256 ponziBalance
82   );
83 
84   modifier onlyAdmin(AccessRank  r) {
85     require(m_admins[msg.sender] == r || m_admins[msg.sender] == AccessRank.Full);
86     _;
87   }
88 
89   function PonziSeller() public {
90     m_ponzi = PonziTokenMinInterface(PONZI_ADDRESS);
91     m_admins[msg.sender] = AccessRank.Full;
92     m_rewardNum = 1;
93     m_rewardDen = 10;
94     m_discountNum = 5;
95     m_discountDen = 100;
96   }
97 
98   function() public payable {
99     byPonzi(address(0));
100   }
101 
102   function setPonziAddress(address ponziAddr) public onlyAdmin(AccessRank.Full) {
103     m_ponzi = PonziTokenMinInterface(ponziAddr);
104   }
105 
106   function ponziAddress() public view returns (address ponziAddr) {
107     return address(m_ponzi);
108   }
109 
110   function ponziPriceInWei() public view returns (uint256) { 
111     return m_ponziPriceInWei;
112   }
113 
114   function setPonziPriceInWei(uint256 newPonziPriceInWei) public onlyAdmin(AccessRank.SetPrice) { 
115     m_ponziPriceInWei = newPonziPriceInWei;
116     emit PriceChanged(msg.sender, m_ponziPriceInWei);
117   }
118 
119   function rewardPercent() public view returns (uint256 numerator, uint256 denominator) {
120     numerator = m_rewardNum;
121     denominator = m_rewardDen;
122   }
123 
124   function discountPercent() public view returns (uint256 numerator, uint256 denominator) {
125     numerator = m_discountNum;
126     denominator = m_discountDen;
127   }
128 
129   function provideAccess(address adminAddr, uint8 rank) public onlyAdmin(AccessRank.Full) {
130     require(rank <= uint8(AccessRank.Full));
131     require(m_admins[adminAddr] != AccessRank.Full);
132     m_admins[adminAddr] = AccessRank(rank);
133   }
134 
135   function setRewardPercent(uint256 newNumerator, uint256 newDenominator) public onlyAdmin(AccessRank.Full) {
136     require(newDenominator != 0);
137     m_rewardNum = newNumerator;
138     m_rewardDen = newDenominator;
139   }
140 
141   function setDiscountPercent(uint256 newNumerator, uint256 newDenominator) public onlyAdmin(AccessRank.Full) {
142     require(newDenominator != 0);
143     m_discountNum = newNumerator;
144     m_discountDen = newDenominator;
145   }
146 
147   function byPonzi(address refAddr) public payable {
148     require(m_ponziPriceInWei > 0 && msg.value > m_ponziPriceInWei);
149 
150     uint256 refAmount = 0;
151     uint256 senderAmount = weiToPonzi(msg.value, m_ponziPriceInWei);
152 
153     // check if ref addres is valid and calc reward and discount
154     if (refAddr != msg.sender && refAddr != address(0) && refAddr != address(this)) {
155       // ref reward
156       refAmount = senderAmount.mul(m_rewardNum).div(m_rewardDen);
157       // sender discount
158       // uint256 d = m_discountDen/(m_discountDen-m_discountNum)
159       senderAmount = senderAmount.mul(m_discountDen).div(m_discountDen-m_discountNum);
160       // senderAmount = senderAmount.add(senderAmount.mul(m_discountNum).div(m_discountDen));
161     }
162     // check if we have enough ponzi on balance
163     if (availablePonzi() < senderAmount.add(refAmount)) {
164       emit NotEnoughPonzi(msg.sender, msg.value, m_ponziPriceInWei, availablePonzi());
165       revert();
166     }
167   
168     // transfer ponzi to sender
169     require(m_ponzi.transfer(msg.sender, senderAmount));
170     // transfer ponzi to ref if needed
171     if (refAmount > 0) {
172       require(m_ponzi.transfer(refAddr, refAmount));
173       emit RewardRef(refAddr, refAmount);
174     }
175     emit PonziSold(msg.sender, m_ponziPriceInWei, senderAmount, msg.value, refAddr);
176   }
177 
178   function availablePonzi() public view returns (uint256) {
179     return m_ponzi.balanceOf(address(this));
180   }
181 
182   function withdrawETH() public onlyAdmin(AccessRank.Withdraw) {
183     uint256 amountWei = address(this).balance;
184     require(amountWei > 0);
185     msg.sender.transfer(amountWei);
186     assert(address(this).balance < amountWei);
187     emit WithdrawalETH(msg.sender, amountWei);
188   }
189 
190   function withdrawPonzi(uint256 amount) public onlyAdmin(AccessRank.Withdraw) {
191     uint256 pt = availablePonzi();
192     require(pt > 0 && amount > 0 && pt >= amount);
193     require(m_ponzi.transfer(msg.sender, amount));
194     assert(availablePonzi() < pt);
195     emit WithdrawalPonzi(msg.sender, pt);
196   }
197 
198   function weiToPonzi(uint256 weiAmount, uint256 tokenPrice) 
199     internal 
200     pure 
201     returns(uint256 tokensAmount) 
202   {
203     tokensAmount = weiAmount.div(tokenPrice);
204   }
205 }