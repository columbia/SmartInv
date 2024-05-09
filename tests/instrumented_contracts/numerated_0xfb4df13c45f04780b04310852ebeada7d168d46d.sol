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
63 						uint64[] timestampList,uint64[] nonceList,
64 						string walletName);
65 
66     /**
67     * Constructor function
68     *
69     * Initializes contract with default validation rules
70     */
71     function Advertisement () public {
72         rules = ValidationRules(false, true, true, 2, 1);
73         owner = msg.sender;
74         appc = AppCoins(0x1a7a8bd9106f2b8d977e08582dc7d24c723ab0db);
75     }
76 
77 
78 	/**
79 	* Creates a campaign for a certain package name with
80 	* a defined price and budget and emits a CampaignCreated event
81 	*/
82 	function createCampaign (string packageName, string countries,
83 							uint[] vercodes, uint price, uint budget,
84 							uint startDate, uint endDate) external {
85 		Campaign memory newCampaign;
86 		newCampaign.filters.packageName = packageName;
87 		newCampaign.filters.countries = countries;
88 		newCampaign.filters.vercodes = vercodes;
89 		newCampaign.price = price;
90 		newCampaign.startDate = startDate;
91 		newCampaign.endDate = endDate;
92 
93 		//Transfers the budget to contract address
94         require(appc.allowance(msg.sender, address(this)) >= budget);
95 
96         appc.transferFrom(msg.sender, address(this), budget);
97 
98 		newCampaign.budget = budget;
99 		newCampaign.owner = msg.sender;
100 		newCampaign.valid = true;
101 		newCampaign.bidId = uintToBytes(bidIdList.length);
102 		addCampaign(newCampaign);
103 
104 		CampaignCreated(
105 			newCampaign.bidId,
106 			packageName,
107 			countries,
108 			vercodes,
109 			price,
110 			budget,
111 			startDate,
112 			endDate);
113 
114 	}
115 
116 	function addCampaign(Campaign campaign) internal {
117 		//Add to bidIdList
118 		bidIdList.push(campaign.bidId);
119 		//Add to campaign map
120 		campaigns[campaign.bidId] = campaign;
121 
122 		//Assuming each country is represented in ISO country codes
123 		bytes memory country =  new bytes(2);
124 		bytes memory countriesInBytes = bytes(campaign.filters.countries);
125 		uint countryLength = 0;
126 
127 		for (uint i=0; i<countriesInBytes.length; i++){
128 
129 			//if ',' is found, new country ahead
130 			if(countriesInBytes[i]=="," || i == countriesInBytes.length-1){
131 
132 				if(i == countriesInBytes.length-1){
133 					country[countryLength]=countriesInBytes[i];
134 				}
135 
136 				addCampaignToCountryMap(campaign,country);
137 
138 				country =  new bytes(2);
139 				countryLength = 0;
140 			} else {
141 				country[countryLength]=countriesInBytes[i];
142 				countryLength++;
143 			}
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
166 						uint64[] timestampList, uint64[] nonces,
167 						address appstore, address oem,
168 						string walletName) external {
169 
170         require (isCampaignValid(bidId));
171 		require (timestampList.length == nonces.length);
172 		//Expect ordered array arranged in ascending order
173 		for(uint i = 0; i < timestampList.length-1; i++){
174 		        uint timestamp_diff = (timestampList[i+1]-timestampList[i]);
175 			require((timestamp_diff / 1000) == 10);
176 		}
177 
178 		verifyNonces(bytes(packageName),timestampList,nonces);
179 
180 		require(!userAttributions[msg.sender][bidId]);
181 		//atribute
182 		userAttributions[msg.sender][bidId] = true;
183 
184 		payFromCampaign(bidId,appstore, oem);
185 
186 		PoARegistered(bidId,packageName,timestampList,nonces, walletName);
187 	}
188 
189 	function cancelCampaign (bytes32 bidId) external {
190 		address campaignOwner = getOwnerOfCampaign(bidId);
191 
192 		// Only contract owner or campaign owner can cancel a campaign
193 		require (owner == msg.sender || campaignOwner == msg.sender);
194 		uint budget = getBudgetOfCampaign(bidId);
195 
196 		appc.transfer(campaignOwner, budget);
197 
198 		setBudgetOfCampaign(bidId,0);
199 		setCampaignValidity(bidId,false);
200 
201 
202 
203 	}
204 
205 	function setBudgetOfCampaign (bytes32 bidId, uint budget) internal {
206 		campaigns[bidId].budget = budget;
207 	}
208 
209 	function setCampaignValidity (bytes32 bidId, bool val) internal {
210 		campaigns[bidId].valid = val;
211 	}
212 
213 	function getCampaignValidity(bytes32 bidId) public view returns(bool){
214 		return campaigns[bidId].valid;
215 	}
216 
217 
218 	function getCountryList () public view returns(bytes2[]) {
219 			return countryList;
220 	}
221 
222 	function getCampaignsByCountry(string country)
223 			public view returns (bytes32[]){
224 		bytes memory countryInBytes = bytes(country);
225 
226 		return campaignsByCountry[countryInBytes];
227 	}
228 
229 
230 	function getTotalCampaignsByCountry (string country)
231 			public view returns (uint){
232 		bytes memory countryInBytes = bytes(country);
233 
234 		return campaignsByCountry[countryInBytes].length;
235 	}
236 
237 	function getPackageNameOfCampaign (bytes32 bidId)
238 			public view returns(string) {
239 
240 		return campaigns[bidId].filters.packageName;
241 	}
242 
243 	function getCountriesOfCampaign (bytes32 bidId)
244 			public view returns(string){
245 
246 		return campaigns[bidId].filters.countries;
247 	}
248 
249 	function getVercodesOfCampaign (bytes32 bidId)
250 			public view returns(uint[]) {
251 
252 		return campaigns[bidId].filters.vercodes;
253 	}
254 
255 	function getPriceOfCampaign (bytes32 bidId)
256 			public view returns(uint) {
257 
258 		return campaigns[bidId].price;
259 	}
260 
261 	function getStartDateOfCampaign (bytes32 bidId)
262 			public view returns(uint) {
263 
264 		return campaigns[bidId].startDate;
265 	}
266 
267 	function getEndDateOfCampaign (bytes32 bidId)
268 			public view returns(uint) {
269 
270 		return campaigns[bidId].endDate;
271 	}
272 
273 	function getBudgetOfCampaign (bytes32 bidId)
274 			public view returns(uint) {
275 
276 		return campaigns[bidId].budget;
277 	}
278 
279 	function getOwnerOfCampaign (bytes32 bidId)
280 			public view returns(address) {
281 
282 		return campaigns[bidId].owner;
283 	}
284 
285 	function getBidIdList ()
286 			public view returns(bytes32[]) {
287 		return bidIdList;
288 	}
289 
290     function isCampaignValid(bytes32 bidId) public view returns(bool) {
291         Campaign storage campaign = campaigns[bidId];
292         uint nowInMilliseconds = now * 1000;
293         return campaign.valid && campaign.startDate < nowInMilliseconds && campaign.endDate > nowInMilliseconds;
294 	}
295 
296 	function payFromCampaign (bytes32 bidId, address appstore, address oem)
297 			internal{
298 		uint dev_share = 85;
299                 uint appstore_share = 10;
300                 uint oem_share = 5;
301 
302 		//Search bid price
303 		Campaign storage campaign = campaigns[bidId];
304 
305 		require (campaign.budget > 0);
306 		require (campaign.budget >= campaign.price);
307 
308 		//transfer to user, appstore and oem
309 		appc.transfer(msg.sender, division(campaign.price * dev_share,100));
310 		appc.transfer(appstore, division(campaign.price * appstore_share,100));
311 		appc.transfer(oem, division(campaign.price * oem_share,100));
312 
313 		//subtract from campaign
314 		campaign.budget -= campaign.price;
315 	}
316 
317 	function verifyNonces (bytes packageName,uint64[] timestampList, uint64[] nonces) internal {
318 
319 		for(uint i = 0; i < nonces.length; i++){
320 			bytes8 timestamp = bytes8(timestampList[i]);
321 			bytes8 nonce = bytes8(nonces[i]);
322 			bytes memory byteList = new bytes(packageName.length + timestamp.length);
323 
324 			for(uint j = 0; j < packageName.length;j++){
325 				byteList[j] = packageName[j];
326 			}
327 
328 			for(j = 0; j < timestamp.length; j++ ){
329 				byteList[j + packageName.length] = timestamp[j];
330 			}
331 
332 			bytes32 result = sha256(byteList);
333 
334 			bytes memory noncePlusHash = new bytes(result.length + nonce.length);
335 
336 			for(j = 0; j < nonce.length; j++){
337 				noncePlusHash[j] = nonce[j];
338 			}
339 
340 			for(j = 0; j < result.length; j++){
341 				noncePlusHash[j + nonce.length] = result[j];
342 			}
343 
344 			result = sha256(noncePlusHash);
345 
346 			bytes2[1] memory leadingBytes = [bytes2(0)];
347 			bytes2 comp = 0x0000;
348 
349 			assembly{
350 				mstore(leadingBytes,result)
351 			}
352 
353 			require(comp == leadingBytes[0]);
354 
355 		}
356 	}
357 
358 
359 	function division(uint numerator, uint denominator) public constant returns (uint) {
360                 uint _quotient = numerator / denominator;
361         return _quotient;
362     }
363 
364 	function uintToBytes (uint256 i) constant returns(bytes32 b)  {
365 		b = bytes32(i);
366 	}
367 
368 }