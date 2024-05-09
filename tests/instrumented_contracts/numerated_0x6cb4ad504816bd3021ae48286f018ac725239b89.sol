1 pragma solidity 0.4.24;
2 
3 contract Kitties {
4 
5     function ownerOf(uint id) public view returns (address);
6 
7 }
8 
9 contract ICollectable {
10 
11     function mint(uint32 delegateID, address to) public returns (uint);
12 
13     function transferFrom(address from, address to, uint256 tokenId) public;
14     function approve(address to, uint256 tokenId) public;
15     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
16 
17     function safeTransferFrom(address from, address to, uint256 tokenId) public;
18 
19 }
20 
21 contract IAuction {
22 
23     function getAuction(uint256 _tokenId)
24         external
25         view
26         returns
27     (
28         address seller,
29         uint256 startingPrice,
30         uint256 endingPrice,
31         uint256 duration,
32         uint256 startedAt);
33 }
34 
35 contract IPack {
36 
37     function purchase(uint16, address) public payable;
38     function purchaseFor(address, uint16, address) public payable;
39 
40 }
41 
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49     /**
50     * @dev Multiplies two numbers, throws on overflow.
51     */
52     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
53         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         c = a * b;
61         assert(c / a == b);
62         return c;
63     }
64 
65     /**
66     * @dev Integer division of two numbers, truncating the quotient.
67     */
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         // assert(b > 0); // Solidity automatically throws when dividing by 0
70         // uint256 c = a / b;
71         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72         return a / b;
73     }
74 
75     /**
76     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77     */
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         assert(b <= a);
80         return a - b;
81     }
82 
83     /**
84     * @dev Adds two numbers, throws on overflow.
85     */
86     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87         c = a + b;
88         assert(c >= a);
89         return c;
90     }
91 }
92 
93 contract Ownable {
94 
95     address public owner;
96 
97     constructor() public {
98         owner = msg.sender;
99     }
100 
101     function setOwner(address _owner) public onlyOwner {
102         owner = _owner;
103     }
104 
105     function getOwner() public view returns (address) {
106         return owner;
107     }
108 
109     modifier onlyOwner {
110         require(msg.sender == owner);
111         _;
112     }
113 
114 }
115 
116 contract CatInThePack is Ownable {
117 
118     using SafeMath for uint;
119 
120     // the pack of GU cards which will be purchased
121     IPack public pack;
122     // the core CK contract
123     Kitties public kitties;
124     // the core GU collectable contract
125     ICollectable public collectables;
126     // the list of CK auction contracts, usually [Sale, Sire]
127     IAuction[] public auctions;
128     
129     // whether it is currently possible to claim cats
130     bool public canClaim = true;
131     // the collectable delegate id 
132     uint32 public delegateID;
133     // whether the contract is locked (i.e. no more claiming)
134     bool public locked = false;
135     // whether kitties on auction are considered to be owned by the sender
136     bool public includeAuctions = true;
137     // contract where funds will be sent
138     address public vault;
139     // max number of kitties per call
140     uint public claimLimit = 20;
141     // price per statue
142     uint public price = 0.024 ether;
143     
144     
145     // map to track whether a kitty has been claimed
146     mapping(uint => bool) public claimed;
147     // map from statue id to kitty id
148     mapping(uint => uint) public statues;
149 
150     constructor(IPack _pack, IAuction[] memory _auctions, Kitties _kitties, 
151         ICollectable _collectables, uint32 _delegateID, address _vault) public {
152         pack = _pack;
153         auctions = _auctions;
154         kitties = _kitties;
155         collectables = _collectables;
156         delegateID = _delegateID;
157         vault = _vault;
158     }
159 
160     event CatsClaimed(uint[] statueIDs, uint[] kittyIDs);
161 
162     // claim statues tied to the following kittyIDs
163     function claim(uint[] memory kittyIDs, address referrer) public payable returns (uint[] memory ids) {
164 
165         require(canClaim, "claiming not enabled");
166         require(kittyIDs.length > 0, "you must claim at least one cat");
167         require(claimLimit >= kittyIDs.length, "must claim >= the claim limit at a time");
168         
169         // statue id array
170         ids = new uint[](kittyIDs.length);
171         
172         for (uint i = 0; i < kittyIDs.length; i++) {
173 
174             uint kittyID = kittyIDs[i];
175 
176             // mark the kitty as being claimed
177             require(!claimed[kittyID], "kitty must not be claimed");
178             claimed[kittyID] = true;
179 
180             require(ownsOrSelling(kittyID), "you must own all the cats you claim");
181 
182             // create the statue token
183             uint id = collectables.mint(delegateID, msg.sender);
184             ids[i] = id;
185             // record which kitty is associated with this statue
186             statues[id] = kittyID;    
187         }
188         
189         // calculate the total purchase price
190         uint totalPrice = price.mul(kittyIDs.length);
191 
192         require(msg.value >= totalPrice, "wrong value sent to contract");
193        
194         uint half = totalPrice.div(2);
195 
196         // send half the price to buy the packs
197         pack.purchaseFor.value(half)(msg.sender, uint16(kittyIDs.length), referrer); 
198 
199         // send the other half directly to the vault contract
200         vault.transfer(half);
201 
202         emit CatsClaimed(ids, kittyIDs);
203         
204         return ids;
205     }
206 
207     // returns whether the msg.sender owns or is auctioning a kitty
208     function ownsOrSelling(uint kittyID) public view returns (bool) {
209         // call to the core CK contract to find the owner of the kitty
210         address owner = kitties.ownerOf(kittyID);
211         if (owner == msg.sender) {
212             return true;
213         } 
214         // check whether we are including the auction contracts
215         if (includeAuctions) {
216             address seller;
217             for (uint i = 0; i < auctions.length; i++) {
218                 IAuction auction = auctions[i];
219                 // make sure you check that this cat is owned by the auction 
220                 // before calling the method, or getAuction will throw
221                 if (owner == address(auction)) {
222                     (seller, , , ,) = auction.getAuction(kittyID);
223                     return seller == msg.sender;
224                 }
225             }
226         }
227         return false;
228     }
229  
230     function setCanClaim(bool _can, bool lock) public onlyOwner {
231         require(!locked, "claiming is permanently locked");
232         if (lock) {
233             require(!_can, "can't lock on permanently");
234             locked = true;
235         }
236         canClaim = _can;
237     }
238 
239     function getKitty(uint statueID) public view returns (uint) {
240         return statues[statueID];
241     }
242 
243     function setClaimLimit(uint limit) public onlyOwner {
244         claimLimit = limit;
245     }
246 
247     function setIncludeAuctions(bool _include) public onlyOwner {
248         includeAuctions = _include;
249     }
250 
251 }