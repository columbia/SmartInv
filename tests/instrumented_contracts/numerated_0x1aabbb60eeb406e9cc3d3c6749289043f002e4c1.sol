1 pragma solidity ^0.4.21;
2 
3 
4 library CampaignLibrary {
5 
6     struct Campaign {
7         bytes32 bidId;
8         uint price;
9         uint budget;
10         uint startDate;
11         uint endDate;
12         bool valid;
13         address  owner;
14     }
15 
16     function convertCountryIndexToBytes(uint[] countries) internal returns (uint,uint,uint){
17         uint countries1 = 0;
18         uint countries2 = 0;
19         uint countries3 = 0;
20         for(uint i = 0; i < countries.length; i++){
21             uint index = countries[i];
22 
23             if(index<256){
24                 countries1 = countries1 | uint(1) << index;
25             } else if (index<512) {
26                 countries2 = countries2 | uint(1) << (index - 256);
27             } else {
28                 countries3 = countries3 | uint(1) << (index - 512);
29             }
30         }
31 
32         return (countries1,countries2,countries3);
33     }
34 
35     
36 }
37 
38 contract AdvertisementStorage {
39 
40     mapping (bytes32 => CampaignLibrary.Campaign) campaigns;
41     mapping (address => bool) allowedAddresses;
42     address public owner;
43 
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     modifier onlyAllowedAddress() {
50         require(allowedAddresses[msg.sender]);
51         _;
52     }
53 
54     event CampaignCreated
55         (
56             bytes32 bidId,
57             uint price,
58             uint budget,
59             uint startDate,
60             uint endDate,
61             bool valid,
62             address owner
63     );
64 
65     event CampaignUpdated
66         (
67             bytes32 bidId,
68             uint price,
69             uint budget,
70             uint startDate,
71             uint endDate,
72             bool valid,
73             address  owner
74     );
75 
76     function AdvertisementStorage() public {
77         owner = msg.sender;
78         allowedAddresses[msg.sender] = true;
79     }
80 
81     function setAllowedAddresses(address newAddress, bool isAllowed) public onlyOwner {
82         allowedAddresses[newAddress] = isAllowed;
83     }
84 
85 
86     function getCampaign(bytes32 campaignId)
87         public
88         view
89         returns (
90             bytes32,
91             uint,
92             uint,
93             uint,
94             uint,
95             bool,
96             address
97         ) {
98 
99         CampaignLibrary.Campaign storage campaign = campaigns[campaignId];
100 
101         return (
102             campaign.bidId,
103             campaign.price,
104             campaign.budget,
105             campaign.startDate,
106             campaign.endDate,
107             campaign.valid,
108             campaign.owner
109         );
110     }
111 
112 
113     function setCampaign (
114         bytes32 bidId,
115         uint price,
116         uint budget,
117         uint startDate,
118         uint endDate,
119         bool valid,
120         address owner
121     )
122     public
123     onlyAllowedAddress {
124 
125         CampaignLibrary.Campaign memory campaign = campaigns[campaign.bidId];
126 
127         campaign = CampaignLibrary.Campaign({
128             bidId: bidId,
129             price: price,
130             budget: budget,
131             startDate: startDate,
132             endDate: endDate,
133             valid: valid,
134             owner: owner
135         });
136 
137         emitEvent(campaign);
138 
139         campaigns[campaign.bidId] = campaign;
140         
141     }
142 
143     function getCampaignPriceById(bytes32 bidId)
144         public
145         view
146         returns (uint) {
147         return campaigns[bidId].price;
148     }
149 
150     function setCampaignPriceById(bytes32 bidId, uint price)
151         public
152         onlyAllowedAddress
153         {
154         campaigns[bidId].price = price;
155         emitEvent(campaigns[bidId]);
156     }
157 
158     function getCampaignBudgetById(bytes32 bidId)
159         public
160         view
161         returns (uint) {
162         return campaigns[bidId].budget;
163     }
164 
165     function setCampaignBudgetById(bytes32 bidId, uint newBudget)
166         public
167         onlyAllowedAddress
168         {
169         campaigns[bidId].budget = newBudget;
170         emitEvent(campaigns[bidId]);
171     }
172 
173     function getCampaignStartDateById(bytes32 bidId)
174         public
175         view
176         returns (uint) {
177         return campaigns[bidId].startDate;
178     }
179 
180     function setCampaignStartDateById(bytes32 bidId, uint newStartDate)
181         public
182         onlyAllowedAddress
183         {
184         campaigns[bidId].startDate = newStartDate;
185         emitEvent(campaigns[bidId]);
186     }
187 
188     function getCampaignEndDateById(bytes32 bidId)
189         public
190         view
191         returns (uint) {
192         return campaigns[bidId].endDate;
193     }
194 
195     function setCampaignEndDateById(bytes32 bidId, uint newEndDate)
196         public
197         onlyAllowedAddress
198         {
199         campaigns[bidId].endDate = newEndDate;
200         emitEvent(campaigns[bidId]);
201     }
202 
203     function getCampaignValidById(bytes32 bidId)
204         public
205         view
206         returns (bool) {
207         return campaigns[bidId].valid;
208     }
209 
210     function setCampaignValidById(bytes32 bidId, bool isValid)
211         public
212         onlyAllowedAddress
213         {
214         campaigns[bidId].valid = isValid;
215         emitEvent(campaigns[bidId]);
216     }
217 
218     function getCampaignOwnerById(bytes32 bidId)
219         public
220         view
221         returns (address) {
222         return campaigns[bidId].owner;
223     }
224 
225     function setCampaignOwnerById(bytes32 bidId, address newOwner)
226         public
227         onlyAllowedAddress
228         {
229         campaigns[bidId].owner = newOwner;
230         emitEvent(campaigns[bidId]);
231     }
232 
233     function emitEvent(CampaignLibrary.Campaign campaign) private {
234 
235         if (campaigns[campaign.bidId].owner == 0x0) {
236             emit CampaignCreated(
237                 campaign.bidId,
238                 campaign.price,
239                 campaign.budget,
240                 campaign.startDate,
241                 campaign.endDate,
242                 campaign.valid,
243                 campaign.owner
244             );
245         } else {
246             emit CampaignUpdated(
247                 campaign.bidId,
248                 campaign.price,
249                 campaign.budget,
250                 campaign.startDate,
251                 campaign.endDate,
252                 campaign.valid,
253                 campaign.owner
254             );
255         }
256     }
257 }