1 pragma solidity ^0.4.16;
2 
3 // --- ShareHolder forward declaration ---
4 contract ShareHolder
5 {
6 	function addToShareHoldersProfit(string, string) payable
7 	{
8 		// ...
9 	}
10 }
11 // --- End of ShareHolder forward declaration ---
12 
13 contract Ownable 
14 {
15 	address m_addrOwner;
16 
17 	function Ownable() 	
18 	{ 
19 		m_addrOwner = msg.sender; 
20 	}
21 
22 	modifier onlyOwner() 
23 	{
24 		if (msg.sender != m_addrOwner) 
25 		{
26 			revert();
27 		}
28     	_;
29 	}
30 
31 	// ---
32 
33 	function transferOwnership(address newOwner) onlyOwner 
34 	{
35 		m_addrOwner = newOwner;
36 	}
37 
38 	// ---
39 
40 	function isOwner() constant returns (bool bIsOwner) { return (m_addrOwner == msg.sender); }
41 
42 }
43 
44 // ------
45 
46 contract DukeOfEther is Ownable
47 {
48 	address m_addrShareHolder = 0;      // addr. of ShareHolder Profit Manager
49 
50 	uint m_deployedAtBlock = 0;			// Initial block of a contract, used in logging/reporting
51 	uint m_nOwnersMoney = 0;
52 	uint m_nNewCountryPrice = 1 ether;  // Pay to create NEW country
53     uint m_nMinDukePrice = 1 finney;
54     uint m_nDeterioration = 3;          // After day 60, loose 3% a day till m_nMinDukePrice
55 	uint m_nDaysBeforeDeteriorationStarts = 60;
56     uint m_NextDukePaymentIncrease = 150; // Next Duke pays 150% of current
57     uint m_nNumberOfActiveCountries = 0;
58 
59 	struct Country
60 	{
61         bool m_bIsDestroyed;
62 		string m_strNickName;
63 		uint m_nLastDukeRiseDate;
64 		address m_addrCurrentDuke;
65 		uint m_nCurrentDukePaid;
66 		string m_strCountry;
67 	}
68 	
69 	mapping (string => Country) m_Countries;	// Russia, USA, China... Add more using addNewCountry()
70     
71     // --- Events ---
72 
73 	event updateDukeHistory(string strCountry, bool bIsDestroyed, string strNickName, 
74         address indexed addrCurrentDuke, uint nCurrentDukePaid, uint date);
75 	event errorMessage(string strMessage);
76 
77 	// --- Functions ---
78 
79 	function DukeOfEther()
80 	{
81         m_deployedAtBlock = block.number;
82         // ---
83 		addCountry("USA");
84 		addCountry("Russia");
85 		addCountry("China");
86         addCountry("Japan");
87         addCountry("Taiwan");
88         addCountry("Ukraine");
89 	}
90 
91 	// ---
92 	
93 	function addCountry(string strCountry) internal
94 	{
95 	    Country memory newCountryInfo;
96 	    
97         newCountryInfo.m_bIsDestroyed = false;
98 		newCountryInfo.m_strNickName = "Vacant";
99 		newCountryInfo.m_addrCurrentDuke = m_addrOwner;
100 		newCountryInfo.m_nCurrentDukePaid = m_nMinDukePrice;
101 
102         newCountryInfo.m_strCountry = strCountry;
103         newCountryInfo.m_nLastDukeRiseDate = now;
104 		m_Countries[strCountry] = newCountryInfo;
105         
106         updateDukeHistory(strCountry, false, "Vacant", m_addrOwner, 0, now);
107         
108         m_nNumberOfActiveCountries++;
109 	}
110 	
111 	// ---
112 	
113 	function verifyNickNameAndCountry(string strCountry, string strNickName) internal
114     {
115 		if(bytes(strNickName).length > 30 || bytes(strCountry).length > 30)
116         {
117             errorMessage("String too long: keep strNickName and strCountry <= 30");
118             revert();
119         }
120 	}
121 
122 	// ---
123 	
124 	function processShareHolderFee(uint nFee, string strNickName) internal
125 	{	
126 		// --- ShareHolder interface ---
127 		if(m_addrShareHolder != 0)
128         {
129             ShareHolder contractShareHolder = ShareHolder(m_addrShareHolder);
130             contractShareHolder.addToShareHoldersProfit.value(nFee)(strNickName, "");
131         }
132 	}
133 
134 	// ---
135 	
136 	function addRemoveCountry(string strCountry, string strNickName, bool bDestroy) payable
137 	{
138 		verifyNickNameAndCountry(strCountry, strNickName);
139 
140         if(!bDestroy && m_nNumberOfActiveCountries >= 12)
141         {
142             errorMessage("Too many active countries. Consider destroying few.");
143             revert();
144         }
145         else if(bDestroy && m_nNumberOfActiveCountries <= 3)
146         {
147             errorMessage("There should be at least 3 countries alive");
148             revert();
149         }
150         
151         // Demiurg pays more, then gets even
152         if(msg.value < getPaymentToAddRemoveCountry(strCountry, bDestroy))
153 		{
154 			errorMessage("Sorry, but country costs more");
155 			revert();
156 		}
157       
158         // Note that we do not check if the country exists: 
159         // we take money and promote next Duke or Destroyer
160 
161 		address addrPrevDuke = m_Countries[strCountry].m_addrCurrentDuke;
162 		
163 		uint nFee = msg.value / 25;	// 4%
164         uint nAmount = msg.value - nFee;
165         uint nDemiurgsEffectiveAmount = 100 * nAmount / m_NextDukePaymentIncrease;
166 	
167 		processShareHolderFee(nFee, strNickName);
168         
169         updateDukeHistory(strCountry, bDestroy, strNickName, msg.sender, msg.value, now);    
170         
171 		Country memory newCountryInfo;
172         newCountryInfo.m_bIsDestroyed = bDestroy;
173         newCountryInfo.m_strCountry = strCountry;
174         newCountryInfo.m_strNickName = strNickName;
175 		newCountryInfo.m_nLastDukeRiseDate = now;
176 		newCountryInfo.m_addrCurrentDuke = msg.sender;
177 		newCountryInfo.m_nCurrentDukePaid = nDemiurgsEffectiveAmount;
178         
179 		m_Countries[strCountry] = newCountryInfo;
180         
181         if(bDestroy)
182             m_nNumberOfActiveCountries--;
183         else
184             m_nNumberOfActiveCountries++;
185         
186         m_nOwnersMoney += (nAmount - nDemiurgsEffectiveAmount);
187                 
188         addrPrevDuke.transfer(nDemiurgsEffectiveAmount);
189 	}
190 	
191 	// ---
192 	
193 	function becomeDuke(string strCountry, string strNickName) payable
194 	{
195 		if(msg.value < getMinNextBet(strCountry))
196 			revert();
197 
198         if(bytes(strNickName).length > 30 || bytes(strCountry).length > 30)
199         {
200             errorMessage("String too long: keep strNickName and strCountry <= 30");
201             revert();
202         }
203             
204         Country memory countryInfo = m_Countries[strCountry];
205         if(countryInfo.m_addrCurrentDuke == 0 || countryInfo.m_bIsDestroyed == true)
206 		{
207 			errorMessage("This country does not exist: use addRemoveCountry first");
208 			revert();
209 		}
210 		
211 		address addrPrevDuke = m_Countries[strCountry].m_addrCurrentDuke;
212             
213 		uint nFee = msg.value / 25;	// 4%
214 		uint nOwnersFee = msg.value / 100;	// 1%
215 		m_nOwnersMoney += nOwnersFee;
216 
217         uint nPrevDukeReceived = msg.value - nFee - nOwnersFee;
218        
219         countryInfo.m_bIsDestroyed = false;
220         countryInfo.m_strNickName = strNickName;
221 		countryInfo.m_nLastDukeRiseDate = now;
222 		countryInfo.m_addrCurrentDuke = msg.sender;
223 		countryInfo.m_nCurrentDukePaid = msg.value;
224 		countryInfo.m_strCountry = strCountry;
225         
226         m_Countries[strCountry] = countryInfo;
227         
228         updateDukeHistory(strCountry, false, strNickName, msg.sender, msg.value, now); 
229 
230 		processShareHolderFee(nFee, strNickName);
231         
232         addrPrevDuke.transfer(nPrevDukeReceived);
233 	}
234 	
235 	// ---
236 	
237 	function withdrawDukeOwnersMoney() onlyOwner
238 	{
239 		m_addrOwner.transfer(m_nOwnersMoney);
240 	}
241 	
242 	// ---
243 	
244     function setShareHolder(address addr) onlyOwner { m_addrShareHolder = addr; }
245     
246 	function isDestroyed(string strCountry) constant returns (bool) { return m_Countries[strCountry].m_bIsDestroyed; }
247 	function getInitBlock() constant returns (uint nInitBlock) { return m_deployedAtBlock; }
248 	function getDukeNickName(string strCountry) constant returns (string) 
249         { return m_Countries[strCountry].m_strNickName; }
250 	function getDukeDate(string strCountry) constant returns (uint date) 
251         { return m_Countries[strCountry].m_nLastDukeRiseDate; }
252 	function getCurrentDuke(string strCountry) constant returns (address addr) 
253         { return m_Countries[strCountry].m_addrCurrentDuke; }
254 	function getCurrentDukePaid(string strCountry) constant returns (uint nPaid) 
255         { return m_Countries[strCountry].m_nCurrentDukePaid; }
256 	function getMinNextBet(string strCountry) constant returns (uint nNextBet) 
257 	{
258 		if(m_Countries[strCountry].m_nCurrentDukePaid == 0)
259 			return 1 finney;
260 
261         uint nDaysSinceLastRise = (now - m_Countries[strCountry].m_nLastDukeRiseDate) / 86400;
262         uint nDaysMax = m_nDaysBeforeDeteriorationStarts + 100 / m_nDeterioration;
263         if(nDaysSinceLastRise >= nDaysMax)
264             return 1 finney;
265 
266         uint nCurrentDukeDue = m_Countries[strCountry].m_nCurrentDukePaid;
267         if(nDaysSinceLastRise > m_nDaysBeforeDeteriorationStarts)
268             nCurrentDukeDue = nCurrentDukeDue * (nDaysSinceLastRise - m_nDaysBeforeDeteriorationStarts) * m_nDeterioration / 100; 
269             
270 		return  m_NextDukePaymentIncrease * nCurrentDukeDue / 100; 
271 	}
272 
273 	function getPaymentToAddRemoveCountry(string strCountry, bool bRemove) constant returns (uint)
274 	{
275 		if(bRemove && m_Countries[strCountry].m_addrCurrentDuke == 0)
276 			return 0;
277 		else if(!bRemove && m_Countries[strCountry].m_addrCurrentDuke != 0 && m_Countries[strCountry].m_bIsDestroyed == false)	
278 			return 0;
279 
280 		uint nPrice = m_NextDukePaymentIncrease * getMinNextBet(strCountry) / 100;
281 		if(nPrice < m_nNewCountryPrice)
282 			nPrice = m_nNewCountryPrice;
283 		return nPrice;	
284 	}
285 	
286     // TBD: make it deletable
287 }