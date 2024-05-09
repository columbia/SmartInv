1 pragma solidity ^0.4.15;
2 
3 contract CryptoElections {
4 
5     /* Define variable owner of the type address */
6     address creator;
7 
8     modifier onlyCreator() {
9         require(msg.sender == creator);
10         _;
11     }
12 
13     modifier onlyCountryOwner(uint256 countryId) {
14         require(countries[countryId].president==msg.sender);
15         _;
16     }
17     modifier onlyCityOwner(uint cityId) {
18         require(cities[cityId].mayor==msg.sender);
19         _;
20     }
21 
22     struct Country {
23         address president;
24         string slogan;
25         string flagUrl;
26     }
27     struct City {
28         address mayor;
29         string slogan;
30         string picture;
31         uint purchases;
32     }
33     bool maintenance=false;
34     event withdrawalEvent(address user,uint value);
35     event pendingWithdrawalEvent(address user,uint value);
36     event assignCountryEvent(address user,uint countryId);
37     event buyCityEvent(address user,uint cityId);
38     mapping(uint => Country) public countries ;
39     mapping(uint =>  uint[]) public countriesCities ;
40     mapping(uint =>  uint) public citiesCountries ;
41 
42     mapping(uint =>  uint) public cityPopulation ;
43     mapping(uint => City) public cities;
44     mapping(address => uint[]) public userCities;
45     mapping(address => uint) public userPendingWithdrawals;
46     mapping(address => string) public userNicknames;
47 
48     function CryptoElections() public {
49         creator = msg.sender;
50     }
51 
52     function () public payable {
53         revert();
54     }
55 
56     /* This function is executed at initialization and sets the owner of the contract */
57     /* Function to recover the funds on the contract */
58     function kill() public
59     onlyCreator()
60     {
61         selfdestruct(creator);
62     }
63 
64     function transfer(address newCreator) public
65     onlyCreator()
66     {
67         creator=newCreator;
68     }
69 
70 
71 
72     // Contract initialisation
73     function addCountryCities(uint countryId,uint[] _cities)  public
74     onlyCreator()
75     {
76         countriesCities[countryId] = _cities;
77         for (uint i = 0;i<_cities.length;i++) {
78             citiesCountries[_cities[i]] = countryId;
79 
80         }
81     }
82     function setMaintenanceMode(bool _maintenance) public
83     onlyCreator()
84     {
85         maintenance=_maintenance;
86     }
87 
88 
89     // Contract initialisation
90     function addCitiesPopulation(uint[] _cities,uint[]_populations)  public
91     onlyCreator()
92     {
93 
94         for (uint i = 0;i<_cities.length;i++) {
95 
96             cityPopulation[_cities[i]] = _populations[i];
97         }
98     }
99 
100     function setCountrySlogan(uint countryId,string slogan) public
101     onlyCountryOwner(countryId)
102     {
103         countries[countryId].slogan = slogan;
104     }
105 
106     function setCountryPicture(uint countryId,string _flagUrl) public
107     onlyCountryOwner(countryId)
108     {
109         countries[countryId].flagUrl = _flagUrl;
110     }
111 
112     function setCitySlogan(uint256 cityId,string _slogan) public
113     onlyCityOwner(cityId)
114     {
115         cities[cityId].slogan = _slogan;
116     }
117 
118     function setCityPicture(uint256 cityId,string _picture) public
119     onlyCityOwner(cityId)
120     {
121         cities[cityId].picture = _picture;
122     }
123 
124 
125     function withdraw() public {
126         if (maintenance) revert();
127         uint amount = userPendingWithdrawals[msg.sender];
128         // Remember to zero the pending refund before
129         // sending to prevent re-entrancy attacks
130 
131         userPendingWithdrawals[msg.sender] = 0;
132         withdrawalEvent(msg.sender,amount);
133         msg.sender.transfer(amount);
134     }
135 
136     function getPrices(uint purchases) public pure returns (uint[4]) {
137         uint price = 20000000000000000; // 16x0
138         uint pricePrev = 20000000000000000;
139         uint systemCommission = 19000000000000000;
140         uint presidentCommission = 1000000000000000;
141         uint ownerCommission;
142 
143         for (uint i = 1;i<=purchases;i++) {
144             if (i<=7)
145                 price = price*2;
146             else
147                 price = (price*12)/10;
148 
149             presidentCommission = price/100;
150             systemCommission = (price-pricePrev)*2/10;
151             ownerCommission = price-presidentCommission-systemCommission;
152 
153             pricePrev = price;
154         }
155         return [price,systemCommission,presidentCommission,ownerCommission];
156     }
157 
158     function setNickname(string nickname) public {
159         if (maintenance) revert();
160         userNicknames[msg.sender] = nickname;
161     }
162 
163     function _assignCountry(uint countryId)    private returns (bool) {
164         uint  totalPopulation;
165         uint  controlledPopulation;
166 
167         uint  population;
168         for (uint i = 0;i<countriesCities[countryId].length;i++) {
169             population = cityPopulation[countriesCities[countryId][i]];
170             if (cities[countriesCities[countryId][i]].mayor==msg.sender) {
171                 controlledPopulation += population;
172             }
173             totalPopulation += population;
174         }
175         if (controlledPopulation*2>(totalPopulation)) {
176             countries[countryId].president = msg.sender;
177             assignCountryEvent(msg.sender,countryId);
178             return true;
179         } else {
180             return false;
181         }
182     }
183 
184     function buyCity(uint cityId) payable  public  {
185         if (maintenance) revert();
186         uint[4] memory prices = getPrices(cities[cityId].purchases);
187 
188         if (cities[cityId].mayor==msg.sender) {
189             revert();
190         }
191         if (cityPopulation[cityId]==0) {
192             revert();
193         }
194 
195         if ( msg.value+userPendingWithdrawals[msg.sender]>=prices[0]) {
196             // use user limit
197             userPendingWithdrawals[msg.sender] = userPendingWithdrawals[msg.sender]+msg.value-prices[0];
198             pendingWithdrawalEvent(msg.sender,userPendingWithdrawals[msg.sender]+msg.value-prices[0]);
199 
200             cities[cityId].purchases = cities[cityId].purchases+1;
201 
202             userPendingWithdrawals[cities[cityId].mayor] += prices[3];
203             pendingWithdrawalEvent(cities[cityId].mayor,prices[3]);
204 
205             if (countries[citiesCountries[cityId]].president==0) {
206                 userPendingWithdrawals[creator] += prices[2];
207                 pendingWithdrawalEvent(creator,prices[2]);
208 
209             } else {
210                 userPendingWithdrawals[countries[citiesCountries[cityId]].president] += prices[2];
211                 pendingWithdrawalEvent(countries[citiesCountries[cityId]].president,prices[2]);
212             }
213             // change mayor
214             if (cities[cityId].mayor>0) {
215                 _removeUserCity(cities[cityId].mayor,cityId);
216             }
217 
218 
219 
220             cities[cityId].mayor = msg.sender;
221             _addUserCity(msg.sender,cityId);
222 
223             _assignCountry(citiesCountries[cityId]);
224 
225             //send money to creator
226             creator.transfer(prices[1]);
227             buyCityEvent(msg.sender,cityId);
228 
229         } else {
230             revert();
231         }
232     }
233     function getUserCities(address user) public view returns (uint[]) {
234         return userCities[user];
235     }
236 
237     function _addUserCity(address user,uint cityId) private {
238         bool added = false;
239         for (uint i = 0; i<userCities[user].length; i++) {
240             if (userCities[user][i]==0) {
241                 userCities[user][i] = cityId;
242                 added = true;
243                 break;
244             }
245         }
246         if (!added)
247             userCities[user].push(cityId);
248     }
249 
250     function _removeUserCity(address user,uint cityId) private {
251         for (uint i = 0; i<userCities[user].length; i++) {
252             if (userCities[user][i]==cityId) {
253                 delete userCities[user][i];
254             }
255         }
256     }
257 
258 }