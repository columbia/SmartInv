1 pragma solidity ^0.4.18;
2 
3 // see: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 
35 // Ponzi Token Minimal Interface
36 contract PonziTokenMinInterface {
37   function balanceOf(address owner) public view returns(uint256);
38   function transfer(address to, uint256 value) public returns (bool);
39 }
40 
41 
42 contract PonziSeller {
43   using SafeMath for uint256;
44   enum AccessRank {
45     None,
46     SetPrice,
47     Withdraw,
48     Full
49   }
50 
51   address private constant PONZI_ADDRESS = 0xc2807533832807Bf15898778D8A108405e9edfb1;
52   PonziTokenMinInterface private m_ponzi;
53   uint256 private m_ponziPriceInWei;
54   uint256 private m_rewardNum;
55   uint256 private m_rewardDen;
56   mapping(address => AccessRank) private m_admins;
57 
58   event PriceChanged(address indexed who, uint256 newPrice);
59   event RewardRef(address indexed refAddr, uint256 ponziAmount);
60   event Withdrawal(address indexed to, uint256 amountInWei);
61   event ProvidingAccess(address indexed addr, AccessRank rank);
62   event PonziSold(
63     address indexed purchasedBy, 
64     uint256 indexed priceInWei, 
65     uint256 ponziAmount, 
66     uint256 weiAmount, 
67     address indexed refAddr 
68   );
69   event NotEnoughPonzi(
70     address indexed addr, 
71     uint256 weiAmount, 
72     uint256 ponziPriceInWei, 
73     uint256 ponziBalance
74   );
75 
76   modifier onlyAdmin(AccessRank  r) {
77     require(m_admins[msg.sender] == r || m_admins[msg.sender] == AccessRank.Full);
78     _;
79   }
80 
81   function PonziSeller() public {
82     m_ponzi = PonziTokenMinInterface(PONZI_ADDRESS);
83     m_admins[msg.sender] = AccessRank.Full;
84     m_rewardNum = 1;
85     m_rewardDen = 1;
86   }
87 
88   function() public payable {
89     byPonzi(address(0));
90   }
91 
92   function setPonziAddress(address ponziAddr) public onlyAdmin(AccessRank.Full) {
93     m_ponzi = PonziTokenMinInterface(ponziAddr);
94   }
95 
96   function ponziAddress() public view returns (address ponziAddr) {
97     return address(m_ponzi);
98   }
99 
100   function ponziPriceInWei() public view returns (uint256) { 
101     return m_ponziPriceInWei;
102   }
103 
104   function setPonziPriceInWei(uint256 newPonziPriceInWei) public onlyAdmin(AccessRank.SetPrice) { 
105     m_ponziPriceInWei = newPonziPriceInWei;
106     emit PriceChanged(msg.sender, m_ponziPriceInWei);
107   }
108 
109   function rewardPercent() public view returns (uint256 numerator, uint256 denominator) {
110     numerator = m_rewardNum;
111     denominator = m_rewardDen;
112   }
113 
114   function provideAccess(address adminAddr, uint8 rank) public onlyAdmin(AccessRank.Full) {
115     require(rank <= uint8(AccessRank.Full));
116     require(m_admins[adminAddr] != AccessRank.Full);
117     m_admins[adminAddr] = AccessRank(rank);
118   }
119 
120   function setRewardPercent(uint256 newNumerator, uint256 newDenominator) public onlyAdmin(AccessRank.Full) {
121     require(newDenominator != 0);
122     m_rewardNum = newNumerator;
123     m_rewardDen = newDenominator;
124   }
125 
126   function byPonzi(address refAddr) public payable {
127     require(m_ponziPriceInWei > 0 && msg.value > m_ponziPriceInWei);
128 
129     uint256 refAmount = 0;
130     uint256 senderAmount = weiToPonzi(msg.value, m_ponziPriceInWei);
131 
132     // check if ref addres is valid and calc reward
133     if (refAddr != msg.sender && refAddr != address(0) && refAddr != address(this)) {
134       refAmount = senderAmount.mul(m_rewardNum).div(m_rewardDen);
135     }
136     // check if we have enough ponzi on balance
137     if (availablePonzi() < senderAmount.add(refAmount)) {
138       emit NotEnoughPonzi(msg.sender, msg.value, m_ponziPriceInWei, availablePonzi());
139       revert();
140     }
141   
142     // transfer ponzi to sender
143     require(m_ponzi.transfer(msg.sender, senderAmount));
144     // transfer ponzi to ref if needed
145     if (refAmount > 0) {
146       require(m_ponzi.transfer(refAddr, refAmount));
147       emit RewardRef(refAddr, refAmount);
148     }
149     emit PonziSold(msg.sender, m_ponziPriceInWei, senderAmount, msg.value, refAddr);
150   }
151 
152   function availablePonzi() public view returns (uint256) {
153     return m_ponzi.balanceOf(address(this));
154   }
155 
156   function withdraw() public onlyAdmin(AccessRank.Withdraw) {
157     require(address(this).balance > 0);
158     uint256 b = address(this).balance;
159     msg.sender.transfer(b);
160     assert(address(this).balance < b);
161     emit Withdrawal(msg.sender, b);
162   }
163 
164   function weiToPonzi(uint256 weiAmount, uint256 tokenPrice) 
165     internal 
166     pure 
167     returns(uint256 tokensAmount) 
168   {
169     tokensAmount = weiAmount.div(tokenPrice);
170   }
171 }