1 pragma solidity ^0.4.18;
2 
3 contract Terrus {
4   event PlotSale(
5     uint indexed _x,
6     uint indexed _y,
7     address _from,
8     address indexed _to,
9     uint _price,
10     bool _gift
11   );
12 
13   event PlotTerrainUpdate(
14     uint indexed _x,
15     uint indexed _y,
16     address indexed _by,
17     uint _price,
18     bytes32 _newTerrain
19   );
20 
21   event Withdrawal(
22     address _recipient,
23     uint _amount
24   );
25 
26   struct Plot {
27     bool owned;
28     address owner;
29     uint x;
30     uint y;
31     bytes32 terrain;
32     uint saleCount;
33   }
34   mapping(uint => mapping(uint => Plot)) plots;
35 
36   address owner;
37 
38   mapping(uint => mapping(uint => address)) authorisedSaleAddresses;
39   mapping(uint => mapping(uint => uint)) authorisedSalePrices;
40 
41   // Constructor
42   function Terrus() public {
43     owner = msg.sender;
44   }
45 
46   // Modifiers
47   modifier ownerOnly() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   modifier validNewTerrain(uint x, uint y, bytes32 newTerrain) {
53     // TODO
54     _;
55   }
56 
57   modifier xyBounded(uint x, uint y) {
58     require(x < 1000);
59     require(y < 1000);
60     _;
61   }
62 
63   // Public
64   function authoriseSale(uint x, uint y, address buyer, uint amount) public returns (bool) {
65     Plot memory plot = plots[x][y];
66     require(plot.owned);
67     require(plot.owner == msg.sender);
68     uint fee = getSaleFee();
69     require(amount >= fee);
70     authorisedSaleAddresses[x][y] = buyer;
71     authorisedSalePrices[x][y] = amount;
72     return true;
73   }
74 
75   function buyPlot(uint x, uint y) xyBounded(x, y) public payable returns (bool) {
76     require(!plots[x][y].owned);
77     uint price = getPlotPrice();
78     require(price == msg.value);
79     address buyer = msg.sender;
80     plots[x][y] = Plot({
81       owned: true,
82       owner: buyer,
83       x: x,
84       y: y,
85       terrain: getInitialTerrain(x, y),
86       saleCount: 1
87     });
88     PlotSale(x, y, 0x0, buyer, price, false);
89     return true;
90   }
91 
92   function completeSale(uint x, uint y) public payable returns (bool) {
93     address buyer = msg.sender;
94     require(authorisedSaleAddresses[x][y] != 0x0);
95     require(authorisedSaleAddresses[x][y] == buyer);
96     require(authorisedSalePrices[x][y] == msg.value);
97     uint price = msg.value;
98     uint fee = getSaleFee();
99     uint forSeller = price - fee;
100     Plot storage plot = plots[x][y];
101     address seller = plot.owner;
102     plot.owner = buyer;
103     plot.saleCount += 1;
104     authorisedSaleAddresses[x][y] = 0x0;
105     authorisedSalePrices[x][y] = 0;
106     seller.transfer(forSeller);
107     PlotSale(x, y, seller, buyer, price, false);
108     return true;
109   }
110 
111   function deAuthoriseSale(uint x, uint y) public returns (bool) {
112     Plot storage plot = plots[x][y];
113     require(plot.owned);
114     require(plot.owner == msg.sender);
115     authorisedSaleAddresses[x][y] = 0x0;
116     authorisedSalePrices[x][y] = 0;
117     return true;
118   }
119 
120   function getInitialTerrain(uint x, uint y) public pure returns (bytes32) {
121     return sha256(x, y);
122   }
123 
124   function getOwner() public view returns (address) {
125     return owner;
126   }
127 
128   function getPlot(uint x, uint y) public xyBounded(x, y) view returns (bool owned, address plotOwner, uint plotX, uint plotY, bytes32 plotTerrain) {
129     Plot memory plot = plots[x][y];
130     bytes32 terrain = plot.owned ? plot.terrain : getInitialTerrain(x, y);
131     return (plot.owned, plot.owner, x, y, terrain);
132   }
133 
134   function getPlotPrice() public pure returns (uint) {
135     return 0.01 ether;
136   }
137 
138   function getSaleFee() public pure returns (uint) {
139     return 0.01 ether;
140   }
141 
142   function getSetNewTerrainPrice(uint x, uint y, bytes32 newTerrain) public xyBounded(x, y) validNewTerrain(x, y, newTerrain) view returns (uint) {
143     Plot memory plot = plots[x][y];
144     bytes32 currentTerrain = plot.owned ? plot.terrain : getInitialTerrain(x, y);
145     uint changed = 0;
146     for (uint i = 0; i < 32; i++) {
147       if (newTerrain[i] != currentTerrain[i]) {
148         changed += 1;
149       }
150     }
151     uint price = changed * (0.01 ether);
152     require(price >= 0);
153     return price;
154   }
155 
156   function giftPlot(uint x, uint y, address recipient) public ownerOnly xyBounded(x, y) returns (bool) {
157     require(!plots[x][y].owned);
158     plots[x][y] = Plot({
159       owned: true,
160       owner: recipient,
161       x: x,
162       y: y,
163       terrain: getInitialTerrain(x, y),
164       saleCount: 1
165     });
166     PlotSale(x, y, 0x0, recipient, 0, true);
167     return true;
168   }
169 
170   function ping() public pure returns (bytes4) {
171     return "pong";
172   }
173 
174   // TODO TEST
175   function setNewTerrain(uint x, uint y, bytes32 newTerrain) public xyBounded(x, y) validNewTerrain(x, y, newTerrain) payable returns (bool) {
176     Plot storage plot = plots[x][y];
177     require(plot.owned);
178     require(plot.owner == msg.sender);
179     uint setPrice = getSetNewTerrainPrice(x, y, newTerrain);
180     require(msg.value == setPrice);
181     plot.terrain = newTerrain;
182     PlotTerrainUpdate(x, y, msg.sender, msg.value, newTerrain);
183     return true;
184   }
185 
186   function setOwner(address newOwner) public ownerOnly returns (bool) {
187     owner = newOwner;
188     return true;
189   }
190 
191   function withdrawEther(uint amount) public ownerOnly returns (bool) {
192     require(this.balance >= amount);
193     address recipient = msg.sender;
194     recipient.transfer(amount);
195     Withdrawal(recipient, amount);
196     return true;
197   }
198 }