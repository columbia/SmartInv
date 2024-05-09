1 pragma solidity ^0.4.11;
2 
3 contract LunarToken {
4 
5   struct LunarPlot {
6     address owner;
7     uint price;
8     bool forSale;
9     string metadata;
10     bool disabled;
11     uint8 subdivision;
12     uint parentID;
13   }
14 
15   address owner;
16   address beneficiary;
17   uint public numPlots;
18   uint public totalOwned;
19   uint public totalPurchases;
20   uint public initialPrice;
21   uint8 public feePercentage;
22   bool public tradingEnabled;
23   bool public subdivisionEnabled;
24   uint8 public maxSubdivisions;
25 
26   // ERC20-compatible fields
27   uint public totalSupply;
28   string public symbol = "LUNA";
29   string public name = "lunars";
30 
31   mapping (uint => LunarPlot) public plots;
32   mapping (address => uint[]) public plotsOwned;
33 
34   event Transfer(address indexed _from, address indexed _to, uint id);
35   event Purchase(address _from, uint id, uint256 price);
36   event PriceChanged(address _from, uint id, uint256 newPrice);
37   event MetadataUpdated(address _from, uint id, string newData);
38 
39   modifier validID(uint id) {
40     require(id < numPlots);
41     require(!plots[id].disabled);
42     _;
43   }
44 
45   modifier ownerOnly() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   modifier isOwnerOf(uint id) {
51     require(msg.sender == ownerOf(id));
52     _;
53   }
54 
55   modifier tradingIsEnabled() {
56     require(tradingEnabled);
57     _;
58   }
59 
60   modifier subdivisionIsEnabled() {
61     require(subdivisionEnabled);
62     _;
63   }
64 
65   function LunarToken(
66     uint _numPlots,
67     uint _initialPriceInWei,
68     uint8 _feePercentage,
69     bool _tradingEnabled,
70     bool _subdivisionEnabled,
71     uint8 _maxSubdivisions
72   ) {
73     numPlots = _numPlots;
74     totalSupply = _numPlots;
75     initialPrice = _initialPriceInWei;
76     feePercentage = _feePercentage > 100 ? 100 : _feePercentage;
77     tradingEnabled = _tradingEnabled;
78     subdivisionEnabled = _subdivisionEnabled;
79     maxSubdivisions = _maxSubdivisions;
80     owner = msg.sender;
81     beneficiary = msg.sender;
82   }
83 
84   /** An ERC20-compatible balance that returns the number of plots owned */
85   function balanceOf(address addr) constant returns(uint) {
86     return plotsOwned[addr].length;
87   }
88 
89   function tokensOfOwnerByIndex(address addr, uint idx) constant returns(uint) {
90     return plotsOwned[addr][idx];
91   }
92 
93   function ownerOf(uint id) constant validID(id) returns (address) {
94     return plots[id].owner;
95   }
96 
97   function isUnowned(uint id) constant validID(id) returns(bool) {
98     return plots[id].owner == 0x0;
99   }
100 
101   function transfer(uint id, address newOwner, string newData)
102     validID(id) isOwnerOf(id) tradingIsEnabled returns(bool)
103   {
104     plots[id].owner = newOwner;
105 
106     if (bytes(newData).length != 0) {
107       plots[id].metadata = newData;
108     }
109 
110     Transfer(msg.sender, newOwner, id);
111     addPlot(newOwner, id);
112     removePlot(msg.sender, id);
113     return true;
114   }
115 
116   function purchase(uint id, string metadata, bool forSale, uint newPrice)
117     validID(id) tradingIsEnabled payable returns(bool)
118   {
119     LunarPlot plot = plots[id];
120 
121     if (isUnowned(id)) {
122       require(msg.value >= initialPrice);
123     } else {
124       require(plot.forSale && msg.value >= plot.price);
125     }
126 
127     if (plot.owner != 0x0) {
128       // We only send money to owner if the owner is set
129       uint fee = plot.price * feePercentage / 100;
130       uint saleProceeds = plot.price - fee;
131       plot.owner.transfer(saleProceeds);
132       removePlot(plot.owner, id);
133     } else {
134       totalOwned++;
135     }
136 
137     addPlot(msg.sender, id);
138     plot.owner = msg.sender;
139     plot.forSale = forSale;
140     plot.price = newPrice;
141 
142     if (bytes(metadata).length != 0) {
143       plot.metadata = metadata;
144     }
145 
146     Purchase(msg.sender, id, msg.value);
147     totalPurchases++;
148     return true;
149   }
150 
151   function subdivide(
152     uint id,
153     bool forSale1,
154     bool forSale2,
155     uint price1,
156     uint price2,
157     string metadata1,
158     string metadata2
159   ) isOwnerOf(id) subdivisionIsEnabled {
160     // Prevent more subdivisions than max
161     require(plots[id].subdivision < maxSubdivisions);
162 
163     LunarPlot storage oldPlot = plots[id];
164 
165     uint id1 = numPlots++;
166     plots[id1] = LunarPlot({
167       owner: msg.sender,
168       price: price1,
169       forSale: forSale1,
170       metadata: metadata1,
171       disabled: false,
172       parentID: id,
173       subdivision: oldPlot.subdivision + 1
174     });
175 
176     uint id2 = numPlots++;
177     plots[id2] = LunarPlot({
178       owner: msg.sender,
179       price: price2,
180       forSale: forSale2,
181       metadata: metadata2,
182       disabled: false,
183       parentID: id,
184       subdivision: oldPlot.subdivision + 1
185     });
186 
187     // Disable old plot and add new plots
188     plots[id].disabled = true;
189     totalOwned += 1;
190     totalSupply += 1;
191 
192     removePlot(msg.sender, id);
193     addPlot(msg.sender, id1);
194     addPlot(msg.sender, id2);
195   }
196 
197   function setPrice(uint id, bool forSale, uint newPrice) validID(id) isOwnerOf(id) {
198     plots[id].price = newPrice;
199     plots[id].forSale = forSale;
200     PriceChanged(msg.sender, id, newPrice);
201   }
202 
203   function setMetadata(uint id, string newData) validID(id) isOwnerOf(id) {
204     plots[id].metadata = newData;
205     MetadataUpdated(msg.sender, id, newData);
206   }
207 
208   // Private methods
209 
210   function removePlot(address addr, uint id) private {
211     // Copy the last entry to id and then delete the last one
212     uint n = plotsOwned[addr].length;
213     for (uint8 i = 0; i < n; i++) {
214       if (plotsOwned[addr][i] == id) {
215         // If found, copy the last element to the idx and then delete last element
216         plotsOwned[addr][i] = plotsOwned[addr][n - 1];
217         delete plotsOwned[addr][n - 1];
218         plotsOwned[addr].length--;
219         break;
220       }
221     }
222   }
223 
224   function addPlot(address addr, uint id) private {
225     plotsOwned[addr].push(id);
226   }
227 
228   // Contract management methods
229 
230   function setOwner(address newOwner) ownerOnly {
231     owner = newOwner;
232   }
233 
234   function setBeneficiary(address newBeneficiary) ownerOnly {
235     beneficiary = newBeneficiary;
236   }
237 
238   function setSubdivisionEnabled(bool enabled) ownerOnly {
239     subdivisionEnabled = enabled;
240   }
241 
242   function setTradingEnabled(bool enabled) ownerOnly {
243     tradingEnabled = enabled;
244   }
245 
246   function setFeePercentage(uint8 _percentage) ownerOnly {
247     feePercentage = _percentage > 100 ? 100 : _percentage;
248   }
249 
250   function setInitialPrice(uint _priceInWei) ownerOnly {
251     initialPrice = _priceInWei;
252   }
253 
254   function withdraw() ownerOnly {
255     beneficiary.transfer(this.balance);
256   }
257 }