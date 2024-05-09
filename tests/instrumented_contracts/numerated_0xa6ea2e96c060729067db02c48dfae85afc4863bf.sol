1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract Etharea {
50     using SafeMath for uint;
51     struct Area {
52         string id;
53         uint price;
54         address owner;
55         uint lastUpdate;
56     }
57 
58     address manager;
59     Area[] public soldAreas;
60     mapping(string => address) areaIdToOwner;
61     mapping(string => uint) areaIdToIndex;
62     mapping(string => bool) enabledAreas;
63     uint public defaultPrice = 0.01 ether;
64 
65     modifier onlyOwner() {
66         require(manager == msg.sender);
67         _;
68     }
69 
70     modifier percentage(uint percents) {
71         require(percents >= 0 && percents <= 100);
72         _;
73     }
74 
75     function Etharea() public {
76         manager = msg.sender;
77     }
78 
79     function buy(string areaId) public payable {
80         require(msg.sender != address(0));
81         require(!isContract(msg.sender));
82         require(areaIdToOwner[areaId] != msg.sender);
83         require(enabledAreas[areaId]);
84         if (areaIdToOwner[areaId] == address(0)) {
85             firstBuy(areaId);
86         } else {
87             buyFromOwner(areaId);
88         }
89         manager.transfer(address(this).balance);
90     }
91 
92     function firstBuy(string areaId) private {
93         uint priceRisePercent;
94         (priceRisePercent,) = getPriceRiseAndFeePercent(defaultPrice);
95         require(msg.value == defaultPrice);
96         Area memory newArea = Area({
97             id: areaId,
98             price: defaultPrice.div(100).mul(priceRisePercent.add(100)),
99             owner: msg.sender,
100             lastUpdate: now
101             });
102 
103         uint index = soldAreas.push(newArea).sub(1);
104         areaIdToIndex[areaId] = index;
105         areaIdToOwner[areaId] = msg.sender;
106     }
107 
108     function buyFromOwner(string areaId) private {
109         Area storage areaToChange = soldAreas[areaIdToIndex[areaId]];
110         require(msg.value == areaToChange.price);
111 
112         uint priceRisePercent;
113         uint transactionFeePercent;
114         (priceRisePercent, transactionFeePercent) = getPriceRiseAndFeePercent(areaToChange.price);
115         address oldOwner = areaIdToOwner[areaId];
116         uint payment = msg.value.div(100).mul(uint(100).sub(transactionFeePercent));
117         uint newPrice = areaToChange.price.div(100).mul(priceRisePercent.add(100));
118 
119         areaToChange.owner = msg.sender;
120         areaToChange.lastUpdate = now;
121         areaIdToOwner[areaId] = msg.sender;
122         areaToChange.price = newPrice;
123         oldOwner.transfer(payment);
124     }
125 
126     function getSoldAreasCount() public view returns (uint) {
127         return soldAreas.length;
128     }
129 
130     function getBalance() public onlyOwner view returns (uint) {
131         return address(this).balance;
132     }
133 
134     function getAreaOwner(string areaId) public view returns (address) {
135         return areaIdToOwner[areaId];
136     }
137 
138     function getAreaIndex(string areaId) public view returns (uint) {
139         uint areaIndex = areaIdToIndex[areaId];
140         Area memory area = soldAreas[areaIndex];
141         require(keccak256(area.id) == keccak256(areaId));
142         return areaIndex;
143     }
144 
145     function setDefaultPrice(uint newPrice) public onlyOwner {
146         defaultPrice = newPrice;
147     }
148 
149     function withdraw() public onlyOwner {
150         require(address(this).balance > 0);
151         manager.transfer(address(this).balance);
152     }
153 
154     function getPriceRiseAndFeePercent(uint currentPrice)
155     public pure returns (uint, uint)
156     {
157         if (currentPrice >= 0.01 ether && currentPrice < 0.15 ether) {
158             return (100, 10);
159         }
160 
161         if (currentPrice >= 0.15 ether && currentPrice < 1 ether) {
162             return (60, 6);
163         }
164 
165         if (currentPrice >= 1 ether && currentPrice < 4 ether) {
166             return (40, 5);
167         }
168 
169         if (currentPrice >= 4 ether && currentPrice < 10 ether) {
170             return (30, 4);
171         }
172 
173         if (currentPrice >= 10 ether) {
174             return (25, 3);
175         }
176     }
177 
178     function enableArea(string areaId) public onlyOwner {
179         require(!enabledAreas[areaId]);
180         enabledAreas[areaId] = true;
181     }
182 
183     function isAreaEnabled(string areaId) public view returns (bool) {
184         return enabledAreas[areaId];
185     }
186 
187     function isContract(address userAddress) internal view returns (bool) {
188         uint size;
189         assembly { size := extcodesize(userAddress) }
190         return size > 0;
191     }
192 }