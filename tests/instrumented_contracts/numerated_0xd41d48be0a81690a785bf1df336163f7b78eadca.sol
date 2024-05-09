1 pragma solidity ^0.4.19;
2 
3 contract Crypland {
4 
5   struct Element {uint worth; uint level; uint cooldown;}
6   struct Offer {uint startPrice; uint endPrice; uint startBlock; uint endBlock; bool isOffer;}
7 
8   bool public paused;
9   address public owner;
10 
11   Element[][25][4] public elements;
12   mapping (uint => mapping (uint => mapping (uint => address))) public addresses;
13   mapping (uint => mapping (uint => mapping (uint => Offer))) public offers;
14 
15   event ElementBought(uint indexed group, uint indexed asset, uint indexed unit, address user, uint price, uint level, uint worth);
16   event ElementUpgraded(uint indexed group, uint indexed asset, uint indexed unit, address user, uint price, uint level, uint worth);
17   event ElementTransferred(uint indexed group, uint indexed asset, uint indexed unit, address user, uint price, uint level, uint worth);
18 
19   event UserUpgraded(address indexed user, uint group, uint asset, uint unit, uint price);
20   event UserSold(address indexed user, uint group, uint asset, uint unit, uint price);
21   event UserBought(address indexed user, uint group, uint asset, uint unit, uint price);
22 
23   function Crypland() public {
24     owner = msg.sender;
25     paused = false;
26   }
27 
28   modifier whenOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   modifier whenNotPaused() {
34     require(!paused);
35     _;
36   }
37 
38   modifier whenPaused() {
39     require(paused);
40     _;
41   }
42 
43   modifier whenElementHolder(uint group, uint asset, uint unit) {
44     require(group >= 0 && group < 4);
45     require(asset >= 0 && asset < 25);
46     require(unit >= 0 && unit < elements[group][asset].length);
47     require(addresses[group][asset][unit] == msg.sender);
48     _;
49   }
50 
51   modifier whenNotElementHolder(uint group, uint asset, uint unit) {
52     require(group >= 0 && group < 4);
53     require(asset >= 0 && asset < 25);
54     require(unit >= 0 && unit < elements[group][asset].length);
55     require(addresses[group][asset][unit] != msg.sender);
56     _;
57   }
58 
59   function ownerPause() external whenOwner whenNotPaused {
60     paused = true;
61   }
62 
63   function ownerUnpause() external whenOwner whenPaused {
64     paused = false;
65   }
66 
67   function ownerWithdraw(uint amount) external whenOwner {
68     owner.transfer(amount);
69   }
70 
71   function ownerDestroy() external whenOwner {
72     selfdestruct(owner);
73   }
74 
75   function publicGetAsset(uint group, uint asset) view public returns (uint, uint, uint, uint, uint) {
76     return (
77       calcAssetWorthIndex(asset),
78       calcAssetBuyPrice(asset),
79       calcAssetUpgradePrice(asset),
80       calcAssetMax(asset),
81       calcAssetAssigned(group, asset)
82     );
83   }
84 
85   function publicGetElement(uint group, uint asset, uint unit) view public returns (address, uint, uint, uint, uint, bool) {
86     return (
87       addresses[group][asset][unit],
88       elements[group][asset][unit].level,
89       calcElementWorth(group, asset, unit),
90       calcElementCooldown(group, asset, unit),
91       calcElementCurrentPrice(group, asset, unit),
92       offers[group][asset][unit].isOffer
93     );
94   }
95 
96   function publicGetElementOffer(uint group, uint asset, uint unit) view public returns (uint, uint, uint, uint, uint) {
97     return (
98       offers[group][asset][unit].startPrice,
99       offers[group][asset][unit].endPrice,
100       offers[group][asset][unit].startBlock,
101       offers[group][asset][unit].endBlock,
102       block.number
103     );
104   }
105 
106   function userAssignElement(uint group, uint asset, address ref) public payable whenNotPaused {
107     uint price = calcAssetBuyPrice(asset);
108 
109     require(group >= 0 && group < 4);
110     require(asset >= 0 && asset < 23);
111     require(calcAssetAssigned(group, asset) < calcAssetMax(asset));
112     require(msg.value >= price);
113 
114     if (ref == address(0) || ref == msg.sender) {
115       ref = owner;
116     }
117 
118     uint paidWorth = uint(block.blockhash(block.number - asset)) % 100 + 1;
119     Element memory paidElement = Element(paidWorth, 1, 0);
120     uint paidUnit = elements[group][asset].push(paidElement) - 1;
121     addresses[group][asset][paidUnit] = msg.sender;
122 
123     uint freeWorth = uint(block.blockhash(block.number - paidWorth)) % 100 + 1;
124     Element memory freeElement = Element(freeWorth, 1, 0);
125     uint freeUnit = elements[group][23].push(freeElement) - 1;
126     addresses[group][23][freeUnit] = msg.sender;
127 
128     uint refWorth = uint(block.blockhash(block.number - freeWorth)) % 100 + 1;
129     Element memory refElement = Element(refWorth, 1, 0);
130     uint refUnit = elements[group][24].push(refElement) - 1;
131     addresses[group][24][refUnit] = ref;
132 
133     ElementBought(group, asset, paidUnit, msg.sender, price, 1, paidWorth);
134     ElementBought(group, 23, freeUnit, msg.sender, 0, 1, freeWorth);
135     ElementBought(group, 24, refUnit, ref, 0, 1, refWorth);
136     UserBought(msg.sender, group, asset, paidUnit, price);
137     UserBought(msg.sender, group, 23, freeUnit, 0);
138     UserBought(ref, group, 24, refUnit, 0);
139   }
140 
141   function userUpgradeElement(uint group, uint asset, uint unit) public payable whenNotPaused whenElementHolder(group, asset, unit) {
142     uint price = calcAssetUpgradePrice(asset);
143 
144     require(elements[group][asset][unit].cooldown < block.number);
145     require(msg.value >= price);
146 
147     elements[group][asset][unit].level = elements[group][asset][unit].level + 1;
148     elements[group][asset][unit].cooldown = block.number + ((elements[group][asset][unit].level - 1) * 120);
149     
150     ElementUpgraded(group, asset, unit, msg.sender, price, elements[group][asset][unit].level, calcElementWorth(group, asset, unit));
151     UserUpgraded(msg.sender, group, asset, unit, price);
152   }
153 
154   function userOfferSubmitElement(uint group, uint asset, uint unit, uint startPrice, uint endPrice, uint duration) public whenNotPaused whenElementHolder(group, asset, unit) {
155     require(!offers[group][asset][unit].isOffer); 
156     require(startPrice > 0 && endPrice > 0 && duration > 0 && startPrice >= endPrice);
157 
158     offers[group][asset][unit].isOffer = true;
159     offers[group][asset][unit].startPrice = startPrice;
160     offers[group][asset][unit].endPrice = endPrice;
161     offers[group][asset][unit].startBlock = block.number;
162     offers[group][asset][unit].endBlock = block.number + duration;
163   }
164 
165   function userOfferCancelElement(uint group, uint asset, uint unit) public whenNotPaused whenElementHolder(group, asset, unit) {
166     require(offers[group][asset][unit].isOffer);
167     offers[group][asset][unit].isOffer = false;
168     offers[group][asset][unit].startPrice = 0;
169     offers[group][asset][unit].endPrice = 0;
170     offers[group][asset][unit].startBlock = 0;
171     offers[group][asset][unit].endBlock = 0;
172   }
173 
174   function userOfferAcceptElement(uint group, uint asset, uint unit) public payable whenNotPaused whenNotElementHolder(group, asset, unit) {
175     uint price = calcElementCurrentPrice(group, asset, unit);
176 
177     require(offers[group][asset][unit].isOffer);
178     require(msg.value >= price);
179 
180     address seller = addresses[group][asset][unit];
181 
182     addresses[group][asset][unit] = msg.sender;
183     offers[group][asset][unit].isOffer = false;
184 
185     seller.transfer(price * 97 / 100);
186     msg.sender.transfer(msg.value - price);
187 
188     ElementTransferred(group, asset, unit, msg.sender, price, elements[group][asset][unit].level, calcElementWorth(group, asset, unit));
189     UserBought(msg.sender, group, asset, unit, price);
190     UserSold(seller, group, asset, unit, price);
191   }
192 
193   function calcAssetWorthIndex(uint asset) pure internal returns (uint) {
194     return asset < 23 ? (24 - asset) : 1;
195   }
196 
197   function calcAssetBuyPrice(uint asset) pure internal returns (uint) {
198     return asset < 23 ? ((24 - asset) * (25 - asset) * 10**15 / 2) : 0;
199   }
200 
201   function calcAssetUpgradePrice(uint asset) pure internal returns (uint) {
202     return calcAssetWorthIndex(asset) * 10**15;
203   }
204 
205   function calcAssetMax(uint asset) pure internal returns (uint) {
206     return asset < 23 ? ((asset + 1) * (asset + 2) / 2) : 2300;
207   }
208 
209   function calcAssetAssigned(uint group, uint asset) view internal returns (uint) {
210     return elements[group][asset].length;
211   }
212 
213   function calcElementWorth(uint group, uint asset, uint unit) view internal returns (uint) {
214     return elements[group][asset][unit].worth + ((elements[group][asset][unit].level - 1) * calcAssetWorthIndex(asset));
215   }
216 
217   function calcElementCooldown(uint group, uint asset, uint unit) view internal returns (uint) {
218     return elements[group][asset][unit].cooldown > block.number ? elements[group][asset][unit].cooldown - block.number : 0;
219   }
220 
221   function calcElementCurrentPrice(uint group, uint asset, uint unit) view internal returns (uint) {
222     uint price = 0;
223     if (offers[group][asset][unit].isOffer) {
224       if (block.number >= offers[group][asset][unit].endBlock) {
225         price = offers[group][asset][unit].endPrice;
226       } else if (block.number <= offers[group][asset][unit].startBlock) {
227         price = offers[group][asset][unit].startPrice;
228       } else if (offers[group][asset][unit].endPrice == offers[group][asset][unit].startPrice) {
229         price = offers[group][asset][unit].endPrice;
230       } else {
231         uint currentBlockChange = block.number - offers[group][asset][unit].startBlock;
232         uint totalBlockChange = offers[group][asset][unit].endBlock - offers[group][asset][unit].startBlock;
233         uint totalPriceChange = offers[group][asset][unit].startPrice - offers[group][asset][unit].endPrice;
234         uint currentPriceChange = currentBlockChange * totalPriceChange / totalBlockChange;
235         price = offers[group][asset][unit].startPrice - currentPriceChange;
236       }
237     }
238 
239     return price;
240   }
241 }