1 contract AirSwap {
2     function fill(
3       address makerAddress,
4       uint makerAmount,
5       address makerToken,
6       address takerAddress,
7       uint takerAmount,
8       address takerToken,
9       uint256 expiration,
10       uint256 nonce,
11       uint8 v,
12       bytes32 r,
13       bytes32 s
14     ) payable {}
15 }
16 
17 contract P3D {
18   uint256 public stakingRequirement;
19   function buy(address _referredBy) public payable returns(uint256) {}
20   function balanceOf(address _customerAddress) view public returns(uint256) {}
21   function exit() public {}
22   function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {}
23   function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) { }
24   function myDividends(bool _includeReferralBonus) public view returns(uint256) {}
25   function withdraw() public {}
26   function totalSupply() public view returns(uint256);
27 }
28 
29 contract Pool {
30   P3D constant public p3d = P3D(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
31 
32   address public owner;
33   uint256 public minimum;
34 
35   event Contribution(address indexed caller, address indexed receiver, uint256 contribution, uint256 payout);
36   event Approved(address addr);
37   event Removed(address addr);
38   event OwnerChanged(address owner);
39   event MinimumChanged(uint256 minimum);
40 
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   function() external payable {
46     // accept donations
47     if (msg.sender != address(p3d)) {
48       p3d.buy.value(msg.value)(msg.sender);
49       emit Contribution(msg.sender, address(0), msg.value, 0);
50     }
51   }
52 
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   mapping (address => bool) public approved;
59 
60   function approve(address _addr) external onlyOwner() {
61     approved[_addr] = true;
62     emit Approved(_addr);
63   }
64 
65   function remove(address _addr) external onlyOwner() {
66     approved[_addr] = false;
67     emit Removed(_addr);
68   }
69 
70   function changeOwner(address _newOwner) external onlyOwner() {
71     owner = _newOwner;
72     emit OwnerChanged(owner);
73   }
74   
75   function changeMinimum(uint256 _minimum) external onlyOwner() {
76     minimum = _minimum;
77     emit MinimumChanged(minimum);
78   }
79 
80   function contribute(address _masternode, address _receiver) external payable {
81     // buy p3d
82     p3d.buy.value(msg.value)(_masternode);
83     
84     uint256 payout;
85     
86     // caller must be approved and value must meet the minimum
87     if (approved[msg.sender] && msg.value >= minimum) {
88       payout = p3d.myDividends(true);
89       if (payout != 0) {
90         p3d.withdraw();
91         // send divs to receiver
92         _receiver.transfer(payout);
93       }
94     }
95     
96     emit Contribution(msg.sender, _receiver, msg.value, payout);
97   }
98 
99   function getInfo() external view returns (uint256, uint256) {
100     return (
101       p3d.balanceOf(address(this)),
102       p3d.myDividends(true)
103     );
104   }
105 }
106 
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  */
111 library SafeMath {
112 
113   /**
114   * @dev Multiplies two numbers, throws on overflow.
115   */
116   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
117     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
118     // benefit is lost if 'b' is also tested.
119     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
120     if (a == 0) {
121       return 0;
122     }
123 
124     c = a * b;
125     assert(c / a == b);
126     return c;
127   }
128 
129   /**
130   * @dev Integer division of two numbers, truncating the quotient.
131   */
132   function div(uint256 a, uint256 b) internal pure returns (uint256) {
133     // assert(b > 0); // Solidity automatically throws when dividing by 0
134     // uint256 c = a / b;
135     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136     return a / b;
137   }
138 
139   /**
140   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
141   */
142   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143     assert(b <= a);
144     return a - b;
145   }
146 
147   /**
148   * @dev Adds two numbers, throws on overflow.
149   */
150   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
151     c = a + b;
152     assert(c >= a);
153     return c;
154   }
155 }
156 
157 contract Dex {
158   using SafeMath for uint256;
159 
160   AirSwap constant airswap = AirSwap(0x8fd3121013A07C57f0D69646E86E7a4880b467b7);
161   Pool constant pool = Pool(0xE00c09fEdD3d3Ed09e2D6F6F6E9B1597c1A99bc8);
162   
163   function fill(
164     address masternode,
165     address makerAddress,
166     uint256 makerAmount,
167     address makerToken,
168     uint256 takerAmount,
169     address takerToken,
170     uint256 expiration,
171     uint256 nonce,
172     uint8 v,
173     bytes32 r,
174     bytes32 s
175   ) public payable {
176     // taker token must be ether
177     require(takerToken == address(0));
178     
179     // maker token must not be ether
180     require(makerToken != address(0));
181     
182     // uint256 array to prevent stack too deep
183     // [0] fee 
184     // [1] trade amount 
185     // [2] maker balance checkpoint
186     uint256[] memory settings = new uint256[](3);
187     
188     // 1% fee on taker amount
189     settings[0] = takerAmount / 100;
190 
191     // subtract fee from value
192     settings[1] = msg.value.sub(settings[0]);
193     
194     // checkpoint the maker ether balance
195     settings[2] = makerAddress.balance;
196       
197     // msg value less fee must match taker amount
198     require(settings[1] == takerAmount);
199     
200     // fill order
201     airswap.fill.value(settings[1])(
202       makerAddress,
203       makerAmount,
204       makerToken,
205       msg.sender,
206       settings[1],
207       takerToken,
208       expiration,
209       nonce,
210       v,
211       r,
212       s
213     );
214     
215     // check that the trade was successful (maker balance = checkpoint + trade amount)
216     require(makerAddress.balance == (settings[2].add(settings[1])));
217 
218     // send fee to the pool contract
219     if (settings[0] != 0) {
220       pool.contribute.value(settings[0])(masternode, msg.sender);
221     }
222   }
223 }