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
66   event RewardRef(address indexed refAddr, uint256 wieAmount);
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
96     m_ponziPriceInWei = 50000000;
97   }
98 
99   function() public payable {
100     byPonzi(address(0));
101   }
102 
103   function setPonziAddress(address ponziAddr) public onlyAdmin(AccessRank.Full) {
104     m_ponzi = PonziTokenMinInterface(ponziAddr);
105   }
106 
107   function ponziAddress() public view returns (address ponziAddr) {
108     return address(m_ponzi);
109   }
110 
111   function ponziPriceInWei() public view returns (uint256) { 
112     return m_ponziPriceInWei;
113   }
114 
115   function setPonziPriceInWei(uint256 newPonziPriceInWei) public onlyAdmin(AccessRank.SetPrice) { 
116     m_ponziPriceInWei = newPonziPriceInWei;
117     emit PriceChanged(msg.sender, m_ponziPriceInWei);
118   }
119 
120   function rewardPercent() public view returns (uint256 numerator, uint256 denominator) {
121     numerator = m_rewardNum;
122     denominator = m_rewardDen;
123   }
124 
125   function discountPercent() public view returns (uint256 numerator, uint256 denominator) {
126     numerator = m_discountNum;
127     denominator = m_discountDen;
128   }
129 
130   function provideAccess(address adminAddr, uint8 rank) public onlyAdmin(AccessRank.Full) {
131     require(rank <= uint8(AccessRank.Full));
132     require(m_admins[adminAddr] != AccessRank.Full);
133     m_admins[adminAddr] = AccessRank(rank);
134   }
135 
136   function setRewardPercent(uint256 newNumerator, uint256 newDenominator) public onlyAdmin(AccessRank.Full) {
137     require(newDenominator != 0);
138     m_rewardNum = newNumerator;
139     m_rewardDen = newDenominator;
140   }
141 
142   function setDiscountPercent(uint256 newNumerator, uint256 newDenominator) public onlyAdmin(AccessRank.Full) {
143     require(newDenominator != 0);
144     m_discountNum = newNumerator;
145     m_discountDen = newDenominator;
146   }
147 
148   function byPonzi(address refAddr) public payable {
149     require(m_ponziPriceInWei > 0 && msg.value > m_ponziPriceInWei);
150 
151     uint256 refWeiAmount = 0;
152     uint256 senderPonziAmount = weiToPonzi(msg.value, m_ponziPriceInWei);
153 
154     // check if ref addres is valid and calc reward and discount
155     if (refAddr != msg.sender && refAddr != address(0) && refAddr != address(this)) {
156       // ref reward
157       refWeiAmount = msg.value.mul(m_rewardNum).div(m_rewardDen);
158       // sender discount
159       senderPonziAmount = senderPonziAmount.mul(m_discountDen).div(m_discountDen-m_discountNum);
160     }
161     // check if we have enough ponzi on balance
162     if (availablePonzi() < senderPonziAmount) {
163       emit NotEnoughPonzi(msg.sender, msg.value, m_ponziPriceInWei, availablePonzi());
164       revert();
165     }
166     // transfer ponzi to sender
167     require(m_ponzi.transfer(msg.sender, senderPonziAmount));
168     // transfer eth to ref if needed
169     if (refWeiAmount > 0) {
170       refAddr.transfer(refWeiAmount);
171       emit RewardRef(refAddr, refWeiAmount);
172     }
173     emit PonziSold(msg.sender, m_ponziPriceInWei, senderPonziAmount, msg.value, refAddr);
174   }
175 
176   function availablePonzi() public view returns (uint256) {
177     return m_ponzi.balanceOf(address(this));
178   }
179 
180   function withdrawETH() public onlyAdmin(AccessRank.Withdraw) {
181     uint256 amountWei = address(this).balance;
182     require(amountWei > 0);
183     msg.sender.transfer(amountWei);
184     assert(address(this).balance < amountWei);
185     emit WithdrawalETH(msg.sender, amountWei);
186   }
187 
188   function withdrawPonzi(uint256 amount) public onlyAdmin(AccessRank.Withdraw) {
189     uint256 pt = availablePonzi();
190     require(pt > 0 && amount > 0 && pt >= amount);
191     require(m_ponzi.transfer(msg.sender, amount));
192     assert(availablePonzi() < pt);
193     emit WithdrawalPonzi(msg.sender, pt);
194   }
195 
196   function weiToPonzi(uint256 weiAmount, uint256 tokenPrice) 
197     internal 
198     pure 
199     returns(uint256 tokensAmount) 
200   {
201     tokensAmount = weiAmount.div(tokenPrice);
202   }
203 }