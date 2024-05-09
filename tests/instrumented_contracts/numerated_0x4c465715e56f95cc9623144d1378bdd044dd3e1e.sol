1 /**
2  * This contract manages the messages (or ads) to be displayed in the Pray4Prey aquarium.
3  **/
4 
5 contract mortal {
6 	address owner;
7 
8 	function mortal() {
9 		owner = msg.sender;
10 	}
11 
12 	function kill() {
13 		if (owner == msg.sender)
14 			suicide(owner);
15 	}
16 }
17 
18 contract Display is mortal {
19 	/** the price per advertisement type per time interval (day, week, month). **/
20 	uint[][] prices;
21 	/** the duration of an interval in days **/
22 	uint16[] duration;
23 	/** list of advertisements per address **/
24 	Ad[] ads;
25 	/** the expiry dates of the locks per adType*/
26 	uint[] locks;
27 
28 	struct Ad {
29 		//the id of the ad
30 		uint32 id;
31 		// the type of the ad
32 		uint8 adType;
33 		// the expiry timestamp 
34 		uint expiry;
35 		//the corresponding address
36 		address client;
37 	}
38 
39 	/** 
40 	 * sets the default values
41 	 **/
42 	function Display() {
43 		prices = [
44 			[100000000000000000, 300000000000000000, 500000000000000000],
45 			[500000000000000000, 1500000000000000000, 2500000000000000000],
46 			[2000000000000000000, 5000000000000000000, 8000000000000000000]
47 		];
48 		duration = [1, 7, 30];
49 		locks = [now, now, now];
50 	}
51 
52 	/** buys the basic ad **/
53 	function() payable {
54 		buyAd(0, 0);
55 	}
56 
57 	/** buys a specific ad**/
58 	function buyAd(uint8 adType, uint8 interval) payable {
59 		if (adType >= prices.length || interval >= duration.length || msg.value < prices[interval][adType]) throw;
60 		if (locks[adType] > now) throw;
61 		ads.push(Ad(uint32(ads.length), adType, now + msg.value / prices[interval][adType] * duration[interval] * 1 days, msg.sender));
62 	}
63 
64 	/** change the prices of an interval **/
65 	function changePrices(uint[3] newPrices, uint8 interval) {
66 		prices[interval] = newPrices;
67 	}
68 
69 	/** let the owner withdraw the funds */
70 	function withdraw() {
71 		if (msg.sender == owner)
72 			owner.send(address(this).balance);
73 	}
74 
75 	/* returns 10 ads beginning from startindex */
76 	function get10Ads(uint startIndex) constant returns(uint32[10] ids, uint8[10] adTypes, uint[10] expiries, address[10] clients) {
77 		uint endIndex = startIndex + 10;
78 		if (endIndex > ads.length) endIndex = ads.length;
79 		uint j = 0;
80 		for (uint i = startIndex; i < endIndex; i++) {
81 			ids[j] = ads[i].id;
82 			adTypes[j] = (ads[i].adType);
83 			expiries[j] = (ads[i].expiry);
84 			clients[j] = (ads[i].client);
85 			j++;
86 		}
87 	}
88 
89 	/** returns the number of ads **/
90 	function getNumAds() constant returns(uint) {
91 		return ads.length;
92 	}
93 
94 	/** returns the prices of an interval**/
95 	function getPricesPerInterval(uint8 interval) constant returns(uint[]) {
96 		return prices[interval];
97 	}
98 
99 	/** returns the price of a given type for a given interval**/
100 	function getPrice(uint8 adType, uint8 interval) constant returns(uint) {
101 		return prices[interval][adType];
102 	}
103 
104 	/** locks a type until a given date **/
105 	function lock(uint8 adType, uint expiry) {
106 		locks[adType] = expiry;
107 	}
108 }