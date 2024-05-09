1 pragma solidity ^0.4.2;
2 contract Deed {
3     address public owner;
4     address public previousOwner;
5 }
6 contract Registry {
7     function owner(bytes32 _hash) public constant returns (address);
8 }
9 contract Registrar {
10     function transfer(bytes32 _hash, address newOwner) public;
11     function entries(bytes32 _hash) public constant returns (uint, Deed, uint, uint, uint);
12 }
13 contract Permissioned {
14     mapping(address=>mapping(bytes32=>bool)) internal permissions;
15     bytes32 internal constant PERM_SUPERUSER = keccak256("_superuser");
16     function Permissioned() public {
17         permissions[msg.sender][PERM_SUPERUSER] = true;
18     }
19     modifier ifPermitted(address addr, bytes32 permission) {
20         require(permissions[addr][permission] || permissions[addr][PERM_SUPERUSER]);
21         _;
22     }
23     function isPermitted(address addr, bytes32 permission) public constant returns (bool) {
24         return(permissions[addr][permission] || permissions[addr][PERM_SUPERUSER]);
25     }
26     function setPermission(address addr, bytes32 permission, bool allowed) public ifPermitted(msg.sender, PERM_SUPERUSER) {
27         permissions[addr][permission] = allowed;
28     }
29 }
30 contract RegistryRef {
31     function owner(bytes32 node) public constant returns (address);
32 }
33 contract ReverseRegistrarRef {
34     function setName(string name) public returns (bytes32 node);
35 }
36 contract ENSReverseRegister {
37     function ENSReverseRegister(address registry, string name) public {
38         if (registry != 0) {
39             var reverseRegistrar = RegistryRef(registry).owner(0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2);
40             if (reverseRegistrar != 0) {
41                 ReverseRegistrarRef(reverseRegistrar).setName(name);
42             }
43         }
44     }
45 }
46 contract Pausable is Permissioned {
47     event Pause();
48     event Unpause();
49     bool public paused = false;
50     bytes32 internal constant PERM_PAUSE = keccak256("_pausable");
51     modifier ifNotPaused() {
52         require(!paused);
53         _;
54     }
55     modifier ifPaused {
56         require(paused);
57         _;
58     }
59     function pause() public ifPermitted(msg.sender, PERM_PAUSE) ifNotPaused returns (bool) {
60         paused = true;
61         Pause();
62         return true;
63     }
64     function unpause() public ifPermitted(msg.sender, PERM_PAUSE) ifPaused returns (bool) {
65         paused = false;
66         Unpause();
67         return true;
68     }
69 }
70 library SafeMath {
71     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
72         uint256 c = a * b;
73         assert(a == 0 || c / a == b);
74         return c;
75     }
76     function div(uint256 a, uint256 b) internal constant returns (uint256) {
77         uint256 c = a / b;
78         return c;
79     }
80     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84     function add(uint256 a, uint256 b) internal constant returns (uint256) {
85         uint256 c = a + b;
86         assert(c >= a);
87         return c;
88     }
89 }
90 contract DomainSale is ENSReverseRegister, Pausable {
91     using SafeMath for uint256;
92     Registrar public registrar;
93     mapping (string => Sale) private sales;
94     mapping (address => uint256) private balances;
95     uint256 private constant AUCTION_DURATION = 24 hours;
96     uint256 private constant HIGH_BID_KICKIN = 7 days;
97     uint256 private constant NORMAL_BID_INCREASE_PERCENTAGE = 10;
98     uint256 private constant HIGH_BID_INCREASE_PERCENTAGE = 50;
99     uint256 private constant SELLER_SALE_PERCENTAGE = 90;
100     uint256 private constant START_REFERRER_SALE_PERCENTAGE = 5;
101     uint256 private constant BID_REFERRER_SALE_PERCENTAGE = 5;
102     string private constant CONTRACT_ENS = "domainsale.eth";
103     bytes32 private constant NAMEHASH_ETH = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
104     struct Sale {
105         uint256 price;
106         uint256 reserve;
107         uint256 lastBid;
108         address lastBidder;
109         uint256 auctionStarted;
110         uint256 auctionEnds;
111         address startReferrer;
112         address bidReferrer;
113     }
114     event Offer(address indexed seller, string name, uint256 price, uint256 reserve);
115     event Bid(address indexed bidder, string name, uint256 bid);
116     event Transfer(address indexed seller, address indexed buyer, string name, uint256 value);
117     event Cancel(string name);
118     event Withdraw(address indexed recipient, uint256 amount);
119     modifier onlyNameSeller(string _name) {
120         Deed deed;
121         (,deed,,,) = registrar.entries(keccak256(_name));
122         require(deed.owner() == address(this));
123         require(deed.previousOwner() == msg.sender);
124         _;
125     }
126     modifier deedValid(string _name) {
127         address deed;
128         (,deed,,,) = registrar.entries(keccak256(_name));
129         require(deed != 0);
130         _;
131     }
132     modifier auctionNotStarted(string _name) {
133         require(sales[_name].auctionStarted == 0);
134         _;
135     }
136     modifier canBid(string _name) {
137         require(sales[_name].reserve != 0);
138         _;
139     }
140     modifier canBuy(string _name) {
141         require(sales[_name].price != 0);
142         _;
143     }
144     function DomainSale(address _registry) public ENSReverseRegister(_registry, CONTRACT_ENS) {
145         registrar = Registrar(Registry(_registry).owner(NAMEHASH_ETH));
146     }
147     function sale(string _name) public constant returns (uint256, uint256, uint256, address, uint256, uint256) {
148         Sale storage s = sales[_name];
149         return (s.price, s.reserve, s.lastBid, s.lastBidder, s.auctionStarted, s.auctionEnds);
150     }
151     function isAuction(string _name) public constant returns (bool) {
152         return sales[_name].reserve != 0;
153     }
154     function isBuyable(string _name) public constant returns (bool) {
155         return sales[_name].price != 0 && sales[_name].auctionStarted == 0;
156     }
157     function auctionStarted(string _name) public constant returns (bool) {
158         return sales[_name].lastBid != 0;
159     }
160     function auctionEnds(string _name) public constant returns (uint256) {
161         return sales[_name].auctionEnds;
162     }
163     function minimumBid(string _name) public constant returns (uint256) {
164         Sale storage s = sales[_name];
165         if (s.auctionStarted == 0) {
166             return s.reserve;
167         } else if (s.auctionStarted.add(HIGH_BID_KICKIN) > now) {
168             return s.lastBid.add(s.lastBid.mul(NORMAL_BID_INCREASE_PERCENTAGE).div(100));
169         } else {
170             return s.lastBid.add(s.lastBid.mul(HIGH_BID_INCREASE_PERCENTAGE).div(100));
171         }
172     }
173     function price(string _name) public constant returns (uint256) {
174         return sales[_name].price;
175     }
176     function balance(address addr) public constant returns (uint256) {
177         return balances[addr];
178     }
179     function offer(string _name, uint256 _price, uint256 reserve, address referrer) onlyNameSeller(_name) auctionNotStarted(_name) deedValid(_name) ifNotPaused public {
180         require(_price == 0 || _price > reserve);
181         require(_price != 0 || reserve != 0);
182         Sale storage s = sales[_name];
183         s.reserve = reserve;
184         s.price = _price;
185         s.startReferrer = referrer;
186         Offer(msg.sender, _name, _price, reserve);
187     }
188     function cancel(string _name) onlyNameSeller(_name) auctionNotStarted(_name) deedValid(_name) ifNotPaused public {
189         delete sales[_name];
190         registrar.transfer(keccak256(_name), msg.sender);
191         Cancel(_name);
192     }
193     function buy(string _name, address bidReferrer) canBuy(_name) deedValid(_name) ifNotPaused public payable {
194         Sale storage s = sales[_name];
195         require(msg.value >= s.price);
196         require(s.auctionStarted == 0);
197         Deed deed;
198         (,deed,,,) = registrar.entries(keccak256(_name));
199         address previousOwner = deed.previousOwner();
200         registrar.transfer(keccak256(_name), msg.sender);
201         Transfer(previousOwner, msg.sender, _name, msg.value);
202         distributeFunds(msg.value, previousOwner, s.startReferrer, bidReferrer);
203         delete sales[_name];
204         withdraw();
205     }
206     function bid(string _name, address bidReferrer) canBid(_name) deedValid(_name) ifNotPaused public payable {
207         require(msg.value >= minimumBid(_name));
208         Sale storage s = sales[_name];
209         require(s.auctionStarted == 0 || now < s.auctionEnds);
210         if (s.auctionStarted == 0) {
211           s.auctionStarted = now;
212         } else {
213           balances[s.lastBidder] = balances[s.lastBidder].add(s.lastBid);
214         }
215         s.lastBidder = msg.sender;
216         s.lastBid = msg.value;
217         s.auctionEnds = now.add(AUCTION_DURATION);
218         s.bidReferrer = bidReferrer;
219         Bid(msg.sender, _name, msg.value);
220         withdraw();
221     }
222     function finish(string _name) deedValid(_name) ifNotPaused public {
223         Sale storage s = sales[_name];
224         require(now > s.auctionEnds);
225         Deed deed;
226         (,deed,,,) = registrar.entries(keccak256(_name));
227         address previousOwner = deed.previousOwner();
228         registrar.transfer(keccak256(_name), s.lastBidder);
229         Transfer(previousOwner, s.lastBidder, _name, s.lastBid);
230         distributeFunds(s.lastBid, previousOwner, s.startReferrer, s.bidReferrer);
231         delete sales[_name];
232         withdraw();
233     }
234     function withdraw() ifNotPaused public {
235         uint256 amount = balances[msg.sender];
236         if (amount > 0) {
237             balances[msg.sender] = 0;
238             msg.sender.transfer(amount);
239             Withdraw(msg.sender, amount);
240         }
241     }
242     function invalidate(string _name) ifNotPaused public {
243         address deed;
244         (,deed,,,) = registrar.entries(keccak256(_name));
245         require(deed == 0);
246         Sale storage s = sales[_name];
247         balances[s.lastBidder] = balances[s.lastBidder].add(s.lastBid);
248         delete sales[_name];
249         Cancel(_name);
250         withdraw();
251     }
252     function distributeFunds(uint256 amount, address seller, address startReferrer, address bidReferrer) internal {
253         uint256 startReferrerFunds = amount.mul(START_REFERRER_SALE_PERCENTAGE).div(100);
254         balances[startReferrer] = balances[startReferrer].add(startReferrerFunds);
255         uint256 bidReferrerFunds = amount.mul(BID_REFERRER_SALE_PERCENTAGE).div(100);
256         balances[bidReferrer] = balances[bidReferrer].add(bidReferrerFunds);
257         uint256 sellerFunds = amount.sub(startReferrerFunds).sub(bidReferrerFunds);
258         balances[seller] = balances[seller].add(sellerFunds);
259     }
260 }