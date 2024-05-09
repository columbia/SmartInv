1 pragma solidity =0.5.1;
2 
3 contract Pmes {
4 
5     address public owner;
6     uint256 public nextCid = 1;
7 
8     struct Content {
9         string cus;
10         string description;
11         address owner;
12         uint256 readPrice;
13         uint256 writePrice;
14     }
15     mapping(uint256 => string[]) public reviews;
16     enum OfferStatus {Cancelled, Rejected, Opened, Accepted}
17     struct Offer {
18         uint256 id;
19         string buyerAccessString;
20         string sellerPublicKey;
21         string sellerAccessString;
22         OfferStatus status;
23         uint256 cid;
24         address buyerId;
25         uint256 offerType;
26         uint256 price;
27     }
28 
29     mapping(uint256 => Content) public contents;
30     mapping(string => uint256)  CusToCid;
31     function getCid(string memory cus) public view returns (uint256) {
32         return CusToCid[cus];
33     }
34 
35     uint256 public nextOfferId = 1;
36     mapping(uint256 => Offer) public offers;
37     mapping(uint256 => mapping(address => uint256)) public CidBuyerIdToOfferId;
38 
39     mapping(uint256 => uint256[]) public CidToOfferIds;
40     mapping(address => uint256[]) public BuyerIdToOfferIds;
41 
42     // Access level mapping [address]
43     // 0 - access denied
44     // 1 - can edit existing content
45     // 2 - can add content
46     // 3 - can saleAccess
47     // 4 - can changeOwner
48     // 5 - can setAccessLevel
49     mapping(address => uint256) public publishersMap;
50 
51     event postContent(uint256); // makeCid
52     event postOffer(uint256, uint256, uint256, address); // makeOffer
53     event acceptOffer(uint256); // sellContent, changeOwner
54     event postReview(); // newReview
55 
56     constructor() public
57     {
58         // to prevent repeated calls
59         require (owner == address(0x0));
60         // set owner address
61         owner = msg.sender;
62     }
63 
64     function setAccessLevel(
65         address publisherAddress,
66         uint256 accessLevel
67     )
68         public
69         minAccessLevel(5)
70     {
71         publishersMap[publisherAddress] = accessLevel;
72     }
73 
74     function makeCid(
75         string memory cus,
76         address ownerId,
77         string memory description,
78         uint256 readPrice,
79         uint256 writePrice
80     )
81         public
82         minAccessLevel(2)
83         returns (uint256)
84     {
85         // To prevent create already exist
86         uint256 cid = CusToCid[cus];
87         require(cid == 0, "Content already uploaded");
88 
89         cid = nextCid++;
90         CusToCid[cus] = cid;
91 
92         contents[cid] = Content(cus, description, ownerId, readPrice, writePrice);
93         emit postContent(cid);
94 
95         return cid;
96     }
97 
98     function setReadPrice(uint256 cid, uint256 price) public minAccessLevel(1) {
99         require(cid > 0 && cid < nextCid);
100         contents[cid].readPrice = price;
101     }
102 
103     function setWritePrice(uint256 cid, uint256 price) public minAccessLevel(1) {
104         require(cid > 0 && cid < nextCid);
105         contents[cid].writePrice = price;
106     }
107 
108     function addReview(uint256 cid, address buyerId, string memory review) public minAccessLevel(1) {
109         uint256 offerId = CidBuyerIdToOfferId[cid][buyerId];
110         require(offerId != 0);
111         require(offers[offerId].status == OfferStatus.Accepted);
112 
113         reviews[cid].push(review);
114         emit postReview();
115     }
116 
117     function setDescription(uint256 cid, string memory description) public minAccessLevel(1) {
118         require(cid > 0 && cid < nextCid);
119         contents[cid].description = description;
120     }
121 
122     function changeOwner(
123         uint256 cid,
124         address buyerId,
125         string memory sellerPublicKey,
126         string memory sellerAccessString
127     )
128         public
129         minAccessLevel(4)
130     {
131         uint256 offerId = CidBuyerIdToOfferId[cid][buyerId];
132         require(offers[offerId].status == OfferStatus.Opened);
133         contents[cid].owner = buyerId;
134         offers[offerId].sellerAccessString = sellerAccessString;
135         offers[offerId].sellerPublicKey = sellerPublicKey;
136         offers[offerId].status = OfferStatus.Accepted;
137         emit acceptOffer(cid);
138     }
139 
140     function sellContent(
141         uint256 cid,
142         address buyerId,
143         string memory sellerPublicKey,
144         string memory sellerAccessString
145     )
146         public
147         minAccessLevel(3)
148     {
149         uint256 offerId = CidBuyerIdToOfferId[cid][buyerId];
150         require(offers[offerId].status == OfferStatus.Opened);
151         offers[offerId].sellerAccessString = sellerAccessString;
152         offers[offerId].sellerPublicKey = sellerPublicKey;
153         offers[offerId].status = OfferStatus.Accepted;
154         emit acceptOffer(cid);
155     }
156 
157     function makeOffer(
158         uint256 cid,
159         address buyerId,
160         uint256 offerType,
161         uint256 price,
162         string memory buyerAccessString
163     )
164         public
165         minAccessLevel(2)
166     {
167         require(cid > 0 && cid < nextCid, "Wrong cid");
168         // require(CidBuyerIdToOfferId[cid][buyerId] == 0, "");
169         require(
170             offers[CidBuyerIdToOfferId[cid][buyerId]].status != OfferStatus.Accepted &&
171             offers[CidBuyerIdToOfferId[cid][buyerId]].status != OfferStatus.Opened,
172             "Offer already exist"
173         );
174 
175         offers[nextOfferId] = Offer(
176             offers[CidBuyerIdToOfferId[cid][buyerId]].id + 1,
177             buyerAccessString, 
178             "none", 
179             "none", 
180             OfferStatus.Opened, 
181             cid, 
182             buyerId, 
183             offerType, 
184             price
185         );
186 
187         CidBuyerIdToOfferId[cid][buyerId] = nextOfferId;
188 
189         CidToOfferIds[cid].push(nextOfferId);
190         BuyerIdToOfferIds[buyerId].push(nextOfferId);
191 
192         emit postOffer(cid, offerType, price, buyerId);
193         
194         nextOfferId++;
195     }
196 
197     function cancelOffer(uint256 cid, address buyerId) public minAccessLevel(2) {
198         uint256 offerId = CidBuyerIdToOfferId[cid][buyerId];
199         require(offers[offerId].status == OfferStatus.Opened);
200         offers[offerId].status = OfferStatus.Cancelled;
201     }
202 
203     function rejectOffer(uint256 cid, address buyerId) public minAccessLevel(2) {
204         uint256 offerId = CidBuyerIdToOfferId[cid][buyerId];
205         require(offers[offerId].status == OfferStatus.Opened);
206         offers[offerId].status = OfferStatus.Rejected;
207     }
208 
209     modifier minAccessLevel(uint256 level) {
210         if(msg.sender != owner) {
211             require(publishersMap[msg.sender] >= level);
212         }
213         _;
214     }
215 }