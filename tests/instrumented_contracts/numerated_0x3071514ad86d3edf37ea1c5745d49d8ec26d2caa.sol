1 contract Kingdom {
2     
3     struct City {
4         mapping(uint => uint) resources; //food, wood, stone, iron, gold, ... special
5         mapping(uint => mapping(uint => uint)) map;
6         mapping(uint => uint) resourceFactors; //population, food, wood, stone, iron, gold, woodWork, mason, blacksmith, goldforge, spirit, prestige
7         uint populationNeeded;
8         uint mapX;      //expansion of the map along the x diagonal
9         uint mapY;      //expansion of the map along the y diagonal
10         uint lastClaimResources;                //when did the user last claim his resources  
11         mapping(uint => uint) lastClaimItems;   //when did the user last claim his special items
12         bool initiatet;
13     }
14     
15     struct Building {
16         uint resource0;
17         uint resource1;
18         uint price0;
19         uint price1;
20         uint resourceIndex;
21         uint resourceAmount;
22     }
23     
24     address public owner;
25     address public king;
26     uint    public kingSpirit;
27     address public queen;
28     uint    public queenPrestige;
29     uint    public totalCities;
30     uint    public buildings_total;
31     uint    public sell_id;
32     
33     mapping(address => mapping(uint => uint)) marketplacePrices;
34     mapping(address => mapping(uint => uint)) marketplaceID;
35         
36     mapping(address => City) kingdoms;      //users kingdoms
37     mapping(uint => Building) buildings;    //list of possible buildings
38     
39     
40     //Constructor
41     function Kingdom () public {
42         owner           = msg.sender;
43         king            = msg.sender;
44         kingSpirit      = 0;
45         queen           = msg.sender;
46         queenPrestige   = 0;
47         totalCities     = 0;
48         buildings_total = 0;
49         sell_id         = 0;
50     }
51             
52 /*  0  population
53     1  food
54     2  wood
55     3  stone
56     4  iron
57     5  gold
58     6  woodWork
59     7  mason
60     8  blacksmith
61     9  goldforge
62     10 spirit
63     11 prestige */
64             
65     //Create buildings list
66     function initBuilding(uint r0, uint r1, uint p0, uint p1, uint m, uint a) public {
67         require(msg.sender == owner);
68         //resource0, resource1, price0, price1, mapTo, mapAmount
69         buildings[buildings_total]   = Building(r0,  r1,  p0,  p1,  m,   a); //grass
70         buildings_total += 1;
71        /*[0,  0,   0,  0,  0,  0], //grass
72          [0,  1,   1,  1,  0,  20], //house
73          [0,  1,   1,  1,  1,  1], //farm
74          [1,  2,   1,  1,  2,  2], //lumbermill
75          [1,  3,   2,  1,  3,  1], //stonemine
76          [2,  3,   2,  1,  4,  1], //ironmine
77          [4,  1,   1,  2,  5,  1], //goldmine
78          [1,  3,   2,  2,  6,  1], //woodshop
79          [2,  3,   2,  3,  7,  1], //masonry
80          [3,  4,   3,  2,  8,  1], //blacksmith
81          [4,  1,   2,  4,  9,  1], //goldforge
82          [2,  17,  2,  1,  10, 1], //church
83          [3,  9,   3,  1,  10, 2], //doctor
84          [1,  5,   4,  1,  10, 4], //gentlemens club
85          [3,  13,  3,  1,  10, 1], //inn
86          [4,  18,  4,  2,  10, 2], //theater
87          [2,  14,  5,  2,  10, 4], //concerthall
88          [4,  6,   4,  2,  10, 1], //bathhouse
89          [1,  10,  5,  2,  10, 2], //baker
90          [3,  11,  6,  3,  10, 4], //museum
91          [4,  7,   5,  3,  10, 1], //barber
92          [1,  19,  6,  3,  10, 2], //tailor
93          [2,  15,  7,  3,  10, 4], //arena
94          [2,  12,  6,  1,  11, 1], //monument
95          [3,  8,   7,  1,  11, 2], //park
96          [2,  20,  8,  1,  11, 4], //plaza
97          [1,  16, 10,  1,  11, 8] //castle */
98     }
99     //log resources
100     
101     event Resources(address sender, uint food, uint wood, uint stone, uint iron, uint gold);
102     
103     function logResources() public {
104         Resources(  msg.sender,
105                     kingdoms[msg.sender].resources[0],
106                     kingdoms[msg.sender].resources[1],
107                     kingdoms[msg.sender].resources[2],
108                     kingdoms[msg.sender].resources[3],
109                     kingdoms[msg.sender].resources[4]);
110     }
111     
112     function newLeader() public {
113         if(kingdoms[msg.sender].resourceFactors[10] > kingSpirit){
114             kingSpirit = kingdoms[msg.sender].resourceFactors[10];
115             king = msg.sender;
116             NewLeader(msg.sender, kingSpirit, 0);
117         }
118         //try to claim the smaller throne
119         if(kingdoms[msg.sender].resourceFactors[11] > queenPrestige){
120             queenPrestige = kingdoms[msg.sender].resourceFactors[11];
121             queen = msg.sender;
122             NewLeader(msg.sender, queenPrestige, 1);
123         }
124     }
125     
126     //initiate user when first visiting
127     function initiateUser() public {
128         if(!kingdoms[msg.sender].initiatet){
129             kingdoms[msg.sender].initiatet = true;
130             kingdoms[msg.sender].resources[0] = 5;
131             kingdoms[msg.sender].resources[1] = 5;
132             kingdoms[msg.sender].resources[2] = 5;
133             kingdoms[msg.sender].resources[3] = 5;
134             kingdoms[msg.sender].resources[4] = 5;
135             kingdoms[msg.sender].mapX = 6;
136             kingdoms[msg.sender].mapY = 6;
137             totalCities += 1;
138             logResources();
139         }
140     }
141     
142     //log building creating for ease of reading
143     event BuildAt(address sender, uint xpos, uint ypos, uint building);
144     event NewLeader(address sender, uint spirit, uint Ltype);
145     
146     //build building at location (posx,posy)
147     function buildAt(uint xpos, uint ypos, uint building) public {
148         require(kingdoms[msg.sender].resources[buildings[building].resource0] >= buildings[building].price0
149         &&      kingdoms[msg.sender].resources[buildings[building].resource1] >= buildings[building].price1
150         &&      kingdoms[msg.sender].mapX > xpos
151         &&      kingdoms[msg.sender].mapY > ypos
152         &&      (kingdoms[msg.sender].populationNeeded <= kingdoms[msg.sender].resourceFactors[0] || building == 1)
153         &&      building > 0 && building <= buildings_total
154         &&      kingdoms[msg.sender].map[xpos][ypos] == 0);
155         
156         kingdoms[msg.sender].populationNeeded += 5;
157         kingdoms[msg.sender].map[xpos][ypos] = building;
158         kingdoms[msg.sender].resourceFactors[buildings[building].resourceIndex] += buildings[building].resourceAmount;
159         
160         kingdoms[msg.sender].resources[buildings[building].resource0] -= buildings[building].price0;
161         kingdoms[msg.sender].resources[buildings[building].resource1] -= buildings[building].price1;
162         
163         //try to claim the throne
164         newLeader();
165         BuildAt(msg.sender, xpos, ypos, building);
166         logResources();
167     }
168     
169     //log when a user expands their map
170     event ExpandX(address sender);
171     event ExpandY(address sender);
172     
173     //expand map in direction x
174     function expandX() public payable{
175         assert(msg.value >= 300000000000000*(kingdoms[msg.sender].mapY));
176         owner.transfer(msg.value);
177         kingdoms[msg.sender].mapX += 1;
178         ExpandX(msg.sender);
179     }
180     
181     //expand map in direction Y
182     function expandY() public payable{
183         assert(msg.value >= 300000000000000*(kingdoms[msg.sender].mapX));
184         owner.transfer(msg.value);
185         kingdoms[msg.sender].mapY += 1;
186         ExpandY(msg.sender);
187     }
188     
189     
190     //claim resources
191     function claimBasicResources() public {
192         //can claim every 2 hours - basic resources
193         assert(now >= kingdoms[msg.sender].lastClaimResources + 1 * 1 hours);
194         kingdoms[msg.sender].resources[0] += kingdoms[msg.sender].resourceFactors[1];
195         kingdoms[msg.sender].resources[1] += kingdoms[msg.sender].resourceFactors[2];
196         kingdoms[msg.sender].resources[2] += kingdoms[msg.sender].resourceFactors[3];
197         kingdoms[msg.sender].resources[3] += kingdoms[msg.sender].resourceFactors[4];
198         kingdoms[msg.sender].resources[4] += kingdoms[msg.sender].resourceFactors[5];
199         kingdoms[msg.sender].lastClaimResources = now;
200         logResources();
201     }
202     
203     //log item clain
204     event Items(address sender, uint item);
205     function claimSpecialResource(uint shopIndex) public {
206         //can claim every 5 hours - special items
207         assert(now >= kingdoms[msg.sender].lastClaimItems[shopIndex] + 3 * 1 hours
208         &&     shopIndex > 5
209         &&     shopIndex < 10);
210         for (uint item = 0; item < kingdoms[msg.sender].resourceFactors[shopIndex]; item++){
211             //get pseudo random number
212             uint select = ((now-(item+shopIndex))%13);
213             uint finalI = 0;
214             //award the item to player
215             if(select < 6){
216                 finalI = ((shopIndex-6)*4)+5;   //
217             }
218             else if(select < 10){
219                 finalI = ((shopIndex-6)*4)+6;   //
220             }
221             else if(select < 12){
222                 finalI = ((shopIndex-6)*4)+7;   //
223             }
224             else {
225                 finalI = ((shopIndex-6)*4)+8;   //
226             }
227             kingdoms[msg.sender].resources[finalI] += 1;
228             Items(msg.sender, finalI);
229         }
230         kingdoms[msg.sender].lastClaimItems[shopIndex] = now;
231     }
232     
233     event SellItem (address sender, uint item, uint price, uint sell_id);
234     
235     function sellItem(uint item, uint price) public {
236         assert( item >= 0
237         &&      item <= 27
238         &&      marketplacePrices[msg.sender][item] == 0
239         &&      price > 0
240         &&      kingdoms[msg.sender].resources[item] > 0);
241         
242         marketplacePrices[msg.sender][item] = price;
243         marketplaceID[msg.sender][item] = sell_id;
244         
245         SellItem(msg.sender, item, price, sell_id);
246         sell_id += 1;
247         logResources();
248     }
249     
250     event BuyItem (address buyer, uint item, uint sell_id);
251     
252     function buyItem (address seller, uint item) public payable {
253         assert( msg.value >= marketplacePrices[seller][item]
254                 && marketplacePrices[seller][item] > 0
255         );
256         
257         kingdoms[msg.sender].resources[item] += 1; 
258         uint cut = msg.value/100;
259         owner.transfer(cut*3);
260         king.transfer(cut);
261         queen.transfer(cut);
262         seller.transfer(msg.value-(cut*5));
263         marketplacePrices[seller][item] = 0;
264         BuyItem (msg.sender, item, marketplaceID[seller][item]);
265         logResources();
266     }
267     
268     function buySpecialBuilding (uint xpos, uint ypos, uint building) public payable {
269         require(kingdoms[msg.sender].mapX >= xpos
270         &&      kingdoms[msg.sender].mapY >= ypos
271         &&      ((msg.value >= 100000000000000000 && building == 97) || (msg.value >= 1000000000000000000 && building == 98) || (msg.value >= 5000000000000000000 && building == 99))
272         &&      kingdoms[msg.sender].map[xpos][ypos] == 0);
273         
274         kingdoms[msg.sender].map[xpos][ypos] = building;
275         
276         if (building == 97){
277             kingdoms[msg.sender].resourceFactors[10] += 8;
278         }
279         if (building == 98){
280             kingdoms[msg.sender].resourceFactors[11] += 8;
281         }
282         if (building == 99){
283             kingdoms[msg.sender].resourceFactors[11] += 16;
284         }
285         owner.transfer(msg.value);
286         BuildAt(msg.sender, xpos, ypos, building);
287         //try to claim the throne
288         newLeader();
289         
290     }
291 
292 }