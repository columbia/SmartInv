1 pragma solidity ^0.4.24;
2 
3 contract ClearCoinAdExchange {
4     
5     /*
6      * Events
7      */
8     event lineItemActivated(address indexed wallet);
9     event lineItemDeactivated(address indexed wallet);
10     event adSlotActivated(address indexed wallet);
11     event adSlotDeactivated(address indexed wallet);
12     event clickTracked(address indexed lineItem, address indexed adSlot);
13     
14     address owner;
15     
16     constructor() public {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         require(
22             msg.sender == owner,
23             "Only owner can call this function."
24         );
25         _;
26     }
27 
28     function changeOwner(address new_owner) public onlyOwner {
29         owner = new_owner;
30     }
31 
32     /*
33      * Demand-side (Advertiser)
34      */
35     struct LineItem {
36         uint256 budget;          // when XCLR is transferred to this line item, it's budget increases; eventually the publisher will get paid from the budget
37         string destination_url;  // clicks on creative point here
38         uint256 max_cpc;         // maximum XCLR willing to spend for CPC (Cost Per Click) [8 decimals]
39         uint256 max_daily_spend; // maximum XCLR to spend per 24 hours [8 decimals]
40         uint256 creative_type;   // (1,2,3) => leaderboard (728x90), skyscraper (120x600), medium rectangle (300x250)
41         uint256[] categories;    // (1,2,3,4,etc) => (Automotive, Education, Business, ICO, etc)
42         bool active;
43     }
44     
45     // all line items
46     // costs are charged from this address as XCLR
47     // think of it as the control for Max Lifetime Spend, but you can always top-up with more XCLR
48     // also an identifier for the creative URI
49     mapping (address => LineItem) line_items;
50     
51     modifier lineItemExists {
52         require(
53             line_items[msg.sender].active,
54             "This address has not created a line item."
55         );
56         _;
57     }    
58         
59     function createLineItem(
60         string destination_url,
61         uint256 max_cpc,
62         uint256 max_daily_spend,
63         uint256 creative_type,
64         uint256[] categories
65     ) public {
66         line_items[msg.sender] = LineItem({
67             budget: 0,
68             destination_url: destination_url,
69             max_cpc: max_cpc,
70             max_daily_spend: max_daily_spend,
71             creative_type: creative_type,
72             categories: categories,
73             active: true
74         });
75 
76         emit lineItemActivated(msg.sender);
77     }
78     
79     function deactivateLineItem() public lineItemExists {
80         line_items[msg.sender].active = false;
81         
82         emit lineItemDeactivated(msg.sender);
83     }
84     
85     function activateLineItem() public lineItemExists {
86         line_items[msg.sender].active = true;
87         
88         emit lineItemActivated(msg.sender);
89     }
90 
91 
92     /*
93      * Supply-side (Publisher)
94      */
95     struct AdSlot {
96         string domain;          // domain name of website
97         uint256 creative_type;  // (1,2,3) => leaderboard (728x90), skyscraper (120x600), medium rectangle (300x250)
98         uint256 min_cpc;        // minimum XCLR willing to accept to display ad
99         uint256[] categories;   // (1,2,3,4,etc) => (Automotive, Education, Business, ICO, etc)
100         uint256 avg_ad_quality; // reputation of this AdSlot (updated by algorithm that considers NHT% and number of historical clicks)
101         bool active;
102     }
103     
104     // all ad slots
105     // costs are paid out to these addresses as XCLR
106     mapping (address => AdSlot) ad_slots;
107     
108     modifier adSlotExists {
109         require(
110             ad_slots[msg.sender].active,
111             "This address has not created an ad slot."
112         );
113         _;
114     }
115     
116     function createAdSlot(
117         string domain,
118         uint256 creative_type,
119         uint256 min_cpc,
120         uint256[] categories
121     ) public {
122         ad_slots[msg.sender] = AdSlot({
123             domain: domain,
124             creative_type: creative_type,
125             min_cpc: min_cpc,
126             categories: categories,
127             avg_ad_quality: 100, // starts at 100% by default
128             active: true
129         });
130 
131         emit adSlotActivated(msg.sender);
132     }
133     
134     function deactivateAdSlot() public adSlotExists {
135         ad_slots[msg.sender].active = false;
136         
137         emit adSlotDeactivated(msg.sender);
138     }
139     
140     function activateAdSlot() public adSlotExists {
141         ad_slots[msg.sender].active = true;
142         
143         emit adSlotActivated(msg.sender);
144     }
145 
146     // only owner can submit tracked clicks (from ad server)
147     function trackClick(address line_item_address, address ad_slot_address) public onlyOwner {
148         emit clickTracked(line_item_address, ad_slot_address);
149     }
150     
151 }