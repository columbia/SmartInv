1 pragma solidity ^0.4.21;
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
74 	appc = AppCoins(0x1a7a8bd9106f2b8d977e08582dc7d24c723ab0db);
75     }
76 
77 
78 	/**
79 	* Creates a campaign for a certain package name with
80 	* a defined price and budget and emits a CampaignCreated event
81 	*/
82 	function createCampaign (string packageName, string countries,
83 							uint[] vercodes, uint price, uint budget,
84 				 uint startDate, uint endDate) external {
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
168 			      string walletName) external {
169 
170 
171          require (isCampaignValid(bidId));
172 		require (timestampList.length == nonces.length);
173 		//Expect ordered array arranged in ascending order
174 		for(uint i = 0; i < timestampList.length-1; i++){
175 		        uint timestamp_diff = (timestampList[i+1]-timestampList[i]);
176 			require((timestamp_diff / 1000) == 10);
177 		}
178 
179 	 	// verifyNonces(bytes(packageName),timestampList,nonces);
180 
181 		require(!userAttributions[msg.sender][bidId]);
182 		//atribute
183 		userAttributions[msg.sender][bidId] = true;
184 
185 		payFromCampaign(bidId,appstore, oem);
186 
187 		PoARegistered(bidId,packageName,timestampList,nonces, walletName);
188 	}
189 
190 	function cancelCampaign (bytes32 bidId) external {
191 		address campaignOwner = getOwnerOfCampaign(bidId);
192 
193 		// Only contract owner or campaign owner can cancel a campaign
194 		require (owner == msg.sender || campaignOwner == msg.sender);
195 		uint budget = getBudgetOfCampaign(bidId);
196 
197 		appc.transfer(campaignOwner, budget);
198 
199 		setBudgetOfCampaign(bidId,0);
200 		setCampaignValidity(bidId,false);
201 
202 
203 
204 	}
205 
206 	function setBudgetOfCampaign (bytes32 bidId, uint budget) internal {
207 		campaigns[bidId].budget = budget;
208 	}
209 
210 	function setCampaignValidity (bytes32 bidId, bool val) internal {
211 		campaigns[bidId].valid = val;
212 	}
213 
214 	function getCampaignValidity(bytes32 bidId) public view returns(bool){
215 		return campaigns[bidId].valid;
216 	}
217 
218 
219 	function getCountryList () public view returns(bytes2[]) {
220 			return countryList;
221 	}
222 
223 	function getCampaignsByCountry(string country)
224 			public view returns (bytes32[]){
225 		bytes memory countryInBytes = bytes(country);
226 
227 		return campaignsByCountry[countryInBytes];
228 	}
229 
230 
231 	function getTotalCampaignsByCountry (string country)
232 			public view returns (uint){
233 		bytes memory countryInBytes = bytes(country);
234 
235 		return campaignsByCountry[countryInBytes].length;
236 	}
237 
238 	function getPackageNameOfCampaign (bytes32 bidId)
239 			public view returns(string) {
240 
241 		return campaigns[bidId].filters.packageName;
242 	}
243 
244 	function getCountriesOfCampaign (bytes32 bidId)
245 			public view returns(string){
246 
247 		return campaigns[bidId].filters.countries;
248 	}
249 
250 	function getVercodesOfCampaign (bytes32 bidId)
251 			public view returns(uint[]) {
252 
253 		return campaigns[bidId].filters.vercodes;
254 	}
255 
256 	function getPriceOfCampaign (bytes32 bidId)
257 			public view returns(uint) {
258 
259 		return campaigns[bidId].price;
260 	}
261 
262 	function getStartDateOfCampaign (bytes32 bidId)
263 			public view returns(uint) {
264 
265 		return campaigns[bidId].startDate;
266 	}
267 
268 	function getEndDateOfCampaign (bytes32 bidId)
269 			public view returns(uint) {
270 
271 		return campaigns[bidId].endDate;
272 	}
273 
274 	function getBudgetOfCampaign (bytes32 bidId)
275 			public view returns(uint) {
276 
277 		return campaigns[bidId].budget;
278 	}
279 
280 	function getOwnerOfCampaign (bytes32 bidId)
281 			public view returns(address) {
282 
283 		return campaigns[bidId].owner;
284 	}
285 
286 	function getBidIdList ()
287 			public view returns(bytes32[]) {
288 		return bidIdList;
289 	}
290 
291     function isCampaignValid(bytes32 bidId) public view returns(bool) {
292         Campaign storage campaign = campaigns[bidId];
293         uint nowInMilliseconds = now * 1000;
294         return campaign.valid && campaign.startDate < nowInMilliseconds && campaign.endDate > nowInMilliseconds;
295 	}
296 
297     function payFromCampaign (bytes32 bidId, address appstore, address oem)
298 			internal{
299 		uint dev_share = 85;
300                 uint appstore_share = 10;
301                 uint oem_share = 5;
302 
303 		//Search bid price
304 		Campaign storage campaign = campaigns[bidId];
305 
306 		require (campaign.budget > 0);
307 		require (campaign.budget >= campaign.price);
308 
309 		//transfer to user, appstore and oem
310 		appc.transfer(msg.sender, division(campaign.price * dev_share,100));
311 		appc.transfer(appstore, division(campaign.price * appstore_share,100));
312 		appc.transfer(oem, division(campaign.price * oem_share,100));
313 
314 		//subtract from campaign
315 		campaign.budget -= campaign.price;
316 	}
317 
318     function verifyNonces (bytes packageName,uint64[] timestampList, uint64[] nonces) internal {
319 
320 		for(uint i = 0; i < nonces.length; i++){
321 			bytes8 timestamp = bytes8(timestampList[i]);
322 			bytes8 nonce = bytes8(nonces[i]);
323 			bytes memory byteList = new bytes(packageName.length + timestamp.length);
324 
325 			for(uint j = 0; j < packageName.length;j++){
326 				byteList[j] = packageName[j];
327 			}
328 
329 			for(j = 0; j < timestamp.length; j++ ){
330 				byteList[j + packageName.length] = timestamp[j];
331 			}
332 
333 			bytes32 result = sha256(byteList);
334 
335 			bytes memory noncePlusHash = new bytes(result.length + nonce.length);
336 
337 			for(j = 0; j < nonce.length; j++){
338 				noncePlusHash[j] = nonce[j];
339 			}
340 
341 			for(j = 0; j < result.length; j++){
342 				noncePlusHash[j + nonce.length] = result[j];
343 			}
344 
345 			result = sha256(noncePlusHash);
346 
347 			bytes2[1] memory leadingBytes = [bytes2(0)];
348 			bytes2 comp = 0x0000;
349 
350 			assembly{
351 				mstore(leadingBytes,result)
352 			}
353 
354 			require(comp == leadingBytes[0]);
355 
356 		}
357 	}
358 
359 
360 	function division(uint numerator, uint denominator) public constant returns (uint) {
361                 uint _quotient = numerator / denominator;
362         return _quotient;
363     }
364 
365 	function uintToBytes (uint256 i) constant returns(bytes32 b)  {
366 		b = bytes32(i);
367 	}
368 
369 }