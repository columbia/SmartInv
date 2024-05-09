1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4 
5   address public owner;
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   function transferOwnership(address newOwner) onlyOwner public {
12     require(newOwner != address(0));
13     owner = newOwner;
14   }
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21 }
22 
23 contract LotsData is Ownable {
24 
25     struct Property {
26         string parcel;
27         string street;
28         string city;
29         string state;
30         string zip;
31         uint64 creationTime;
32     }
33 
34     struct Auction {
35         address seller;
36         uint128 startingPriceWei;
37         uint128 endingPriceWei;
38         uint64 duration;
39         uint64 creationTime;
40     }
41 
42     struct Escrow {
43         address seller;
44         address buyer;
45         uint128 amount;
46     }
47 
48     event Transfer(address from, address to, uint256 propertyId);
49     event AuctionCreated(uint256 propertyId, uint256 startingPriceWei, uint256 endingPriceWei, uint256 duration);
50     event AuctionCompleted(uint256 propertyId, uint256 priceWei, address winner);
51     event AuctionCancelled(uint256 propertyId);
52         
53     Property[] properties;
54 
55     mapping (uint256 => address) public propertyIdToOwner;
56     mapping (uint256 => Auction) public propertyIdToAuction;
57     mapping (uint256 => Escrow) public propertyIdToEscrow;
58     
59 }
60 
61 contract LotsApis is LotsData {
62 
63     function getProperty(uint256 _id) external view returns (string parcel, string street, string city, string state, string zip) {
64         Property storage property = properties[_id];
65         parcel = property.parcel;
66         street = property.street;
67         city = property.city;
68         state = property.state;
69         zip = property.zip;
70     }
71     
72     function registerProperty(string parcel, string street, string city, string state, string zip) external onlyOwner {        
73         _registerProperty(parcel, street, city, state, zip);
74     } 
75 
76     function _registerProperty(string parcel, string street, string city, string state, string zip) internal {        
77         Property memory _property = Property({
78             parcel: parcel,
79             street: street,
80             city: city,
81             state: state,
82             zip: zip,
83             creationTime: uint64(now)
84         });
85 
86         uint256 newPropertyId = properties.push(_property) - 1;
87         _transfer(0, msg.sender, newPropertyId);
88     }
89     
90     function transfer(address _to, uint256 _propertyId) external {
91         require(_to != address(0));
92         require(_to != address(this));
93         require(propertyIdToOwner[_propertyId] == msg.sender);
94         Auction storage auction = propertyIdToAuction[_propertyId];
95         require(auction.creationTime == 0);
96         _transfer(msg.sender, _to, _propertyId);
97     }
98 
99     function ownerOf(uint256 _propertyId) external view returns (address owner) {
100         owner = propertyIdToOwner[_propertyId];
101         require(owner != address(0));
102     }
103     
104     function createAuction(uint256 _propertyId, uint256 _startingPriceWei, uint256 _endingPriceWei, uint256 _duration) external onlyOwner {
105         require(_startingPriceWei > _endingPriceWei);
106         require(_startingPriceWei > 0);
107         require(_startingPriceWei == uint256(uint128(_startingPriceWei)));
108         require(_endingPriceWei == uint256(uint128(_endingPriceWei)));
109         require(_duration == uint256(uint64(_duration)));
110         require(propertyIdToOwner[_propertyId] == msg.sender);
111 
112         Auction memory auction = Auction(
113             msg.sender,
114             uint128(_startingPriceWei),
115             uint128(_endingPriceWei),
116             uint64(_duration),
117             uint64(now)
118         );
119 
120         propertyIdToAuction[_propertyId] = auction;
121 
122         AuctionCreated(_propertyId, _startingPriceWei, _endingPriceWei, _duration);
123     }
124     
125     function bid(uint256 _propertyId) external payable {
126         Auction storage auction = propertyIdToAuction[_propertyId];
127         require(auction.startingPriceWei > 0);
128 
129         uint256 price = _getAuctionPrice(auction);
130         require(msg.value >= price);
131 
132         Escrow memory escrow = Escrow({
133                 seller: auction.seller,
134                 buyer: msg.sender,
135                 amount: uint128(price)
136         });
137 
138         delete propertyIdToAuction[_propertyId];
139         propertyIdToEscrow[_propertyId] = escrow;
140 
141         msg.sender.transfer(msg.value - price);        
142         AuctionCompleted(_propertyId, price, msg.sender);
143     }
144 
145     function cancelEscrow(uint256 _propertyId) external onlyOwner {
146         Escrow storage escrow = propertyIdToEscrow[_propertyId];
147         require(escrow.amount > 0);
148 
149         escrow.buyer.transfer(escrow.amount);
150         delete propertyIdToEscrow[_propertyId];
151     }
152 
153     function closeEscrow(uint256 _propertyId) external onlyOwner {
154         Escrow storage escrow = propertyIdToEscrow[_propertyId];
155         require(escrow.amount > 0);
156 
157         escrow.seller.transfer(escrow.amount);
158          _transfer(escrow.seller, escrow.buyer, _propertyId);
159         delete propertyIdToEscrow[_propertyId];
160     }
161 
162     function cancelAuction(uint256 _propertyId) external {
163         Auction storage auction = propertyIdToAuction[_propertyId];
164         require(auction.startingPriceWei > 0);
165 
166         require(msg.sender == auction.seller);
167         delete propertyIdToAuction[_propertyId];
168         AuctionCancelled(_propertyId);
169     }
170     
171     function getAuction(uint256 _propertyId) external view returns(address seller, uint256 startingPriceWei, uint256 endingPriceWei, uint256 duration, uint256 startedAt) {
172         Auction storage auction = propertyIdToAuction[_propertyId];
173         require(auction.startingPriceWei > 0);
174 
175         return (auction.seller, auction.startingPriceWei, auction.endingPriceWei, auction.duration, auction.creationTime);
176     }
177 
178     function getAuctionPrice(uint256 _propertyId) external view returns (uint256) {
179         Auction storage auction = propertyIdToAuction[_propertyId];
180         require(auction.startingPriceWei > 0);
181 
182         return _getAuctionPrice(auction);
183     }
184 
185     function _transfer(address _from, address _to, uint256 _propertyId) internal {
186         propertyIdToOwner[_propertyId] = _to;        
187         Transfer(_from, _to, _propertyId);
188     }
189 
190     function _getAuctionPrice(Auction storage _auction) internal view returns (uint256) {
191         uint256 secondsPassed = 0;
192 
193         if (now > _auction.creationTime) {
194             secondsPassed = now - _auction.creationTime;
195         }
196 
197         uint256 price = _auction.endingPriceWei;
198 
199         if (secondsPassed < _auction.duration) {
200             uint256 priceSpread = _auction.startingPriceWei - _auction.endingPriceWei;
201             uint256 deltaPrice = priceSpread * secondsPassed / _auction.duration;
202             price = _auction.startingPriceWei - deltaPrice;
203         }
204 
205         return price;
206     }
207 }
208 
209 
210 contract LotsMain is LotsApis {
211 
212     function LotsMain() public payable {
213         owner = msg.sender;
214     }
215 
216     function() external payable {
217         require(msg.sender == address(0));
218     }
219 }