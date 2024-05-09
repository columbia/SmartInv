1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The Priate Conquest Project.  All rights reserved.
4 /* 
5 /* https://www.pirateconquest.com One of the world's slg games of blockchain 
6 /*  
7 /* authors rainy@livestar.com/Jonny.Fu@livestar.com
8 /*                 
9 /* ==================================================================== */
10 /// This Random is inspired by https://github.com/axiomzen/eth-random
11 contract Random {
12     uint256 _seed;
13 
14     function _rand() internal returns (uint256) {
15         _seed = uint256(keccak256(_seed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
16         return _seed;
17     }
18 
19     function _randBySeed(uint256 _outSeed) internal view returns (uint256) {
20         return uint256(keccak256(_outSeed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
21     }
22 
23     
24     function _randByRange(uint256 _min, uint256 _max) internal returns (uint256) {
25         if (_min >= _max) {
26             return _min;
27         }
28         return (_rand() % (_max - _min +1)) + _min;
29     }
30 
31     function _rankByNumber(uint256 _max) internal returns (uint256) {
32         return _rand() % _max;
33     }
34     
35 }
36 
37 interface CaptainTokenInterface {
38   function CreateCaptainToken(address _owner,uint256 _price, uint32 _captainId, uint32 _color,uint32 _atk,uint32 _defense,uint32 _atk_min,uint32 _atk_max) public ;
39   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
40   function balanceOf(address _owner) external view returns (uint256);
41   function setTokenPrice(uint256 _tokenId, uint256 _price) external;
42   function checkCaptain(address _owner,uint32 _captainId) external returns (bool);
43   function setSelled(uint256 _tokenId, bool fsell) external;
44 }
45 
46 interface CaptainGameConfigInterface {
47   function getCardInfo(uint32 cardId) external constant returns (uint32,uint32,uint32, uint32,uint32,uint256,uint256);
48   function getSellable(uint32 _captainId) external returns (bool);
49   function getLevelConfig(uint32 cardId, uint32 level) external view returns (uint32 atk,uint32 defense,uint32 atk_min,uint32 atk_max);
50 }
51 
52 contract CaptainPreSell is Random {
53   using SafeMath for SafeMath;
54   address devAddress;
55   
56   function CaptainPreSell() public {
57     devAddress = msg.sender;
58   }
59 
60   CaptainTokenInterface public captains;
61   CaptainGameConfigInterface public config; 
62   /// @dev The BuyToken event is fired whenever a token is sold.
63   event BuyToken(uint256 tokenId, uint256 oldPrice, address prevOwner, address winner);
64   
65   //mapping
66   mapping(uint32 => uint256) captainToCount;
67   mapping(address => uint32[]) captainUserMap; 
68   /// @notice No tipping!
69   /// @dev Reject all Ether from being sent here, unless it's from one of the
70   ///  two auction contracts. (Hopefully, we can prevent user accidents.)
71   function() external payable {
72   }
73 
74   modifier onlyOwner() {
75     require(msg.sender == devAddress);
76     _;
77   }
78 
79   //setting configuration
80   function setGameConfigContract(address _address) external onlyOwner {
81     config = CaptainGameConfigInterface(_address);
82   }
83 
84   //setting configuration
85   function setCaptainTokenContract(address _address) external onlyOwner {
86     captains = CaptainTokenInterface(_address);
87   }
88 
89   function prepurchase(uint32 _captainId) external payable {
90     uint32 color;
91     uint32 atk;
92     uint32 defense;
93     uint256 price;
94     uint256 captainCount;
95     uint256 SellCount = captainToCount[_captainId];
96     (color,atk,,,defense,price,captainCount) = config.getCardInfo(_captainId);
97     require(config.getSellable(_captainId) == true);
98     SellCount += 1;
99     require(SellCount<=captainCount);
100     uint256 rdm = _randByRange(90,110) % 10000;
101     // Safety check to prevent against an unexpected 0x0 default.
102     require(msg.sender != address(0));
103     require(!captains.checkCaptain(msg.sender,_captainId));
104     // Making sure sent amount is greater than or equal to the sellingPrice
105     require(msg.value >= price);
106      //get the config
107     uint32 atk_min;
108     uint32 atk_max; 
109     (,,atk_min,atk_max) = config.getLevelConfig(_captainId,1);
110    
111     atk_min = uint32(SafeMath.div(SafeMath.mul(uint256(atk_min),rdm),100));
112     atk_max = uint32(SafeMath.div(SafeMath.mul(uint256(atk_max),rdm),100));
113    
114     price = SafeMath.div(SafeMath.mul(price,130),100);
115     captains.CreateCaptainToken(msg.sender,price,_captainId,color,atk, defense,atk_min,atk_max);
116   
117     uint256 balance = captains.balanceOf(msg.sender);
118     uint256 tokenId = captains.tokenOfOwnerByIndex(msg.sender,balance-1);
119     captains.setTokenPrice(tokenId,price);
120     //captains.setSelled(tokenId,true);
121     captainToCount[_captainId] = SellCount;
122 
123     //transfer
124     //devAddress.transfer(msg.value);
125     //event 
126     BuyToken(_captainId, price,address(this),msg.sender);
127   }
128 
129   function getCaptainCount(uint32 _captainId) external constant returns (uint256) {
130     return captainToCount[_captainId];
131   }
132 
133   //@notice withraw all by dev
134   function withdraw() external onlyOwner {
135     require(this.balance>0);
136     msg.sender.transfer(this.balance);
137   }
138 }
139 
140 library SafeMath {
141 
142   /**
143   * @dev Multiplies two numbers, throws on overflow.
144   */
145   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146     if (a == 0) {
147       return 0;
148     }
149     uint256 c = a * b;
150     assert(c / a == b);
151     return c;
152   }
153 
154   function mul32(uint32 a, uint32 b) internal pure returns (uint32) {
155     if (a == 0) {
156       return 0;
157     }
158     uint32 c = a * b;
159     assert(c / a == b);
160     return c;
161   }
162 
163   /**
164   * @dev Integer division of two numbers, truncating the quotient.
165   */
166   function div(uint256 a, uint256 b) internal pure returns (uint256) {
167     // assert(b > 0); // Solidity automatically throws when dividing by 0
168     uint256 c = a / b;
169     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170     return c;
171   }
172 
173   function div32(uint32 a, uint32 b) internal pure returns (uint32) {
174     // assert(b > 0); // Solidity automatically throws when dividing by 0
175     uint32 c = a / b;
176     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
177     return c;
178   }
179 
180   /**
181   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
182   */
183   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
184     assert(b <= a);
185     return a - b;
186   }
187 
188   function sub32(uint32 a, uint32 b) internal pure returns (uint32) {
189     assert(b <= a);
190     return a - b;
191   }
192 
193   /**
194   * @dev Adds two numbers, throws on overflow.
195   */
196   function add(uint256 a, uint256 b) internal pure returns (uint256) {
197     uint256 c = a + b;
198     assert(c >= a);
199     return c;
200   }
201 
202   function add32(uint32 a, uint32 b) internal pure returns (uint32) {
203     uint32 c = a + b;
204     assert(c >= a);
205     return c;
206   }
207 }