1 pragma solidity ^0.4.8;
2 
3 
4 contract AppCoins {
5     mapping (address => mapping (address => uint256)) public allowance;
6     function balanceOf (address _owner) public constant returns (uint256);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (uint);
9 }
10 
11 
12 /**
13  * The Advertisement contract collects campaigns registered by developers
14  * and executes payments to users using campaign registered applications
15  * after proof of Attention.
16  */
17 contract Advertisement {
18 
19 	struct Filters {
20 		string countries;
21 		string packageName;
22 		uint[] vercodes;
23 	}
24 
25 	struct ValidationRules {
26 		bool vercode;
27 		bool ipValidation;
28 		bool country;
29 		uint constipDailyConversions;
30 		uint walletDailyConversions;
31 	}
32 
33 	struct Campaign {
34 		bytes32 bidId;
35 		uint price;
36 		uint budget;
37 		uint startDate;
38 		uint endDate;
39 		string ipValidator;
40 		bool valid;
41 		address  owner;
42 		Filters filters;
43 	}
44 
45 	ValidationRules public rules;
46 	bytes32[] bidIdList;
47 	mapping (bytes32 => Campaign) campaigns;
48 	mapping (bytes => bytes32[]) campaignsByCountry;
49 	AppCoins appc;
50 	bytes2[] countryList;
51     address public owner;
52 	mapping (address => mapping (bytes32 => bool)) userAttributions;
53 
54 
55 
56 	// This notifies clients about a newly created campaign
57 	event CampaignCreated(bytes32 bidId, string packageName,
58 							string countries, uint[] vercodes,
59 							uint price, uint budget,
60 							uint startDate, uint endDate);
61 
62 	event PoARegistered(bytes32 bidId, string packageName,
63 						uint[] timestampList,uint[] nonceList);
64 
65     /**
66     * Constructor function
67     *
68     * Initializes contract with default validation rules
69     */
70     function Advertisement () public {
71         rules = ValidationRules(false, true, true, 2, 1);
72         owner = msg.sender;
73         appc = AppCoins(0x1a7a8bd9106f2b8d977e08582dc7d24c723ab0db);
74     }
75 
76 
77 	/**
78 	* Creates a campaign for a certain package name with
79 	* a defined price and budget and emits a CampaignCreated event
80 	*/
81 	function createCampaign (string packageName, string countries,
82 							uint[] vercodes, uint price, uint budget,
83 							uint startDate, uint endDate) external {
84 		Campaign memory newCampaign;
85 		newCampaign.filters.packageName = packageName;
86 		newCampaign.filters.countries = countries;
87 		newCampaign.filters.vercodes = vercodes;
88 		newCampaign.price = price;
89 		newCampaign.startDate = startDate;
90 		newCampaign.endDate = endDate;
91 
92 		//Transfers the budget to contract address
93         require(appc.allowance(msg.sender, address(this)) >= budget);
94 
95         appc.transferFrom(msg.sender, address(this), budget);
96 
97 		newCampaign.budget = budget;
98 		newCampaign.owner = msg.sender;
99 		newCampaign.valid = true;
100 		newCampaign.bidId = uintToBytes(bidIdList.length);
101 		addCampaign(newCampaign);
102 
103 		CampaignCreated(
104 			newCampaign.bidId,
105 			packageName,
106 			countries,
107 			vercodes,
108 			price,
109 			budget,
110 			startDate,
111 			endDate);
112 
113 	}
114 
115 	function addCampaign(Campaign campaign) internal {
116 		//Add to bidIdList
117 		bidIdList.push(campaign.bidId);
118 		//Add to campaign map
119 		campaigns[campaign.bidId] = campaign;
120 
121 		//Assuming each country is represented in ISO country codes
122 		bytes memory country =  new bytes(2);
123 		bytes memory countriesInBytes = bytes(campaign.filters.countries);
124 		uint countryLength = 0;
125 
126 		for (uint i=0; i<countriesInBytes.length; i++){
127 
128 			//if ',' is found, new country ahead
129 			if(countriesInBytes[i]=="," || i == countriesInBytes.length-1){
130 
131 				if(i == countriesInBytes.length-1){
132 					country[countryLength]=countriesInBytes[i];
133 				}
134 
135 				addCampaignToCountryMap(campaign,country);
136 
137 				country =  new bytes(2);
138 				countryLength = 0;
139 			} else {
140 				country[countryLength]=countriesInBytes[i];
141 				countryLength++;
142 			}
143 
144 		}
145 
146 	}
147 
148 
149 	function addCampaignToCountryMap (Campaign newCampaign,bytes country) internal {
150 		// Adds a country to countryList if the country is not in this list
151 		if (campaignsByCountry[country].length == 0){
152 			bytes2 countryCode;
153 			assembly {
154 			       countryCode := mload(add(country, 32))
155 			}
156 
157 			countryList.push(countryCode);
158 		}
159 
160 		//Adds Campaign to campaignsByCountry map
161 		campaignsByCountry[country].push(newCampaign.bidId);
162 
163 	}
164 
165 	function registerPoA (string packageName, bytes32 bidId,
166 						uint[] timestampList, uint[] nonces,
167 						address appstore, address oem) external {
168 
169 		require (timestampList.length == nonces.length);
170 		//Expect ordered array arranged in ascending order
171 		for(uint i = 0; i < timestampList.length-1; i++){
172 			uint256 timestamp_diff = timestampList[i+1]-timestampList[i];
173 
174 			require((timestamp_diff / 1000) == 10);
175 		}
176 
177 		require(!userAttributions[msg.sender][bidId]);
178 		//atribute
179 		// userAttributions[msg.sender][bidId] = true;
180 
181 		// payFromCampaign(bidId,appstore, oem);
182 
183 		PoARegistered(bidId,packageName,timestampList,nonces);
184 	}
185 
186 	function cancelCampaign (bytes32 bidId) external {
187 		address campaignOwner = getOwnerOfCampaign(bidId);
188 
189 		// Only contract owner or campaign owner can cancel a campaign
190 		require (owner == msg.sender || campaignOwner == msg.sender);
191 		uint budget = getBudgetOfCampaign(bidId);
192 
193 		appc.transfer(campaignOwner, budget);
194 
195 		setBudgetOfCampaign(bidId,0);
196 		setCampaignValidity(bidId,false);
197 
198 
199 
200 	}
201 
202 	function setBudgetOfCampaign (bytes32 bidId, uint budget) internal {
203 		campaigns[bidId].budget = budget;
204 	}
205 
206 	function setCampaignValidity (bytes32 bidId, bool val) internal {
207 		campaigns[bidId].valid = val;
208 	}
209 
210 	function getCampaignValidity(bytes32 bidId) public view returns(bool){
211 		return campaigns[bidId].valid;
212 	}
213 
214 
215 	function getCountryList () public view returns(bytes2[]) {
216 			return countryList;
217 	}
218 
219 	function getCampaignsByCountry(string country)
220 			public view returns (bytes32[]){
221 		bytes memory countryInBytes = bytes(country);
222 
223 		return campaignsByCountry[countryInBytes];
224 	}
225 
226 
227 	function getTotalCampaignsByCountry (string country)
228 			public view returns (uint){
229 		bytes memory countryInBytes = bytes(country);
230 
231 		return campaignsByCountry[countryInBytes].length;
232 	}
233 
234 	function getPackageNameOfCampaign (bytes32 bidId)
235 			public view returns(string) {
236 
237 		return campaigns[bidId].filters.packageName;
238 	}
239 
240 	function getCountriesOfCampaign (bytes32 bidId)
241 			public view returns(string){
242 
243 		return campaigns[bidId].filters.countries;
244 	}
245 
246 	function getVercodesOfCampaign (bytes32 bidId)
247 			public view returns(uint[]) {
248 
249 		return campaigns[bidId].filters.vercodes;
250 	}
251 
252 	function getPriceOfCampaign (bytes32 bidId)
253 			public view returns(uint) {
254 
255 		return campaigns[bidId].price;
256 	}
257 
258 	function getStartDateOfCampaign (bytes32 bidId)
259 			public view returns(uint) {
260 
261 		return campaigns[bidId].startDate;
262 	}
263 
264 	function getEndDateOfCampaign (bytes32 bidId)
265 			public view returns(uint) {
266 
267 		return campaigns[bidId].endDate;
268 	}
269 
270 	function getBudgetOfCampaign (bytes32 bidId)
271 			public view returns(uint) {
272 
273 		return campaigns[bidId].budget;
274 	}
275 
276 	function getOwnerOfCampaign (bytes32 bidId)
277 			public view returns(address) {
278 
279 		return campaigns[bidId].owner;
280 	}
281 
282 	function getBidIdList ()
283 			public view returns(bytes32[]) {
284 		return bidIdList;
285 	}
286 
287 	function payFromCampaign (bytes32 bidId, address appstore, address oem)
288 			internal{
289 		uint dev_share = 85;
290                 uint appstore_share = 10;
291                 uint oem_share = 5;
292 
293 		//Search bid price
294 		Campaign storage campaign = campaigns[bidId];
295 
296 		require (campaign.budget > 0);
297 		require (campaign.budget >= campaign.price);
298 
299 		//transfer to user, appstore and oem
300 		appc.transfer(msg.sender, division(campaign.price * dev_share,100));
301 		appc.transfer(appstore, division(campaign.price * appstore_share,100));
302 		appc.transfer(oem, division(campaign.price * oem_share,100));
303 
304 		//subtract from campaign
305 		campaign.budget -= campaign.price;
306 	}
307 
308 	function division(uint numerator, uint denominator) public constant returns (uint) {
309                 uint _quotient = numerator / denominator;
310         return _quotient;
311     }
312 
313 	function uintToBytes (uint256 i) constant returns(bytes32 b)  {
314 		b = bytes32(i);
315 	}
316 
317 }