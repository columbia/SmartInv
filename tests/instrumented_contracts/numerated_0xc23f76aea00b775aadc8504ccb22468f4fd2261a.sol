1 pragma solidity ^0.4.18;
2 
3 // import "./Pausable.sol";
4 // import "./CratePreSale.sol";
5 
6 contract NewCratePreSale {
7     
8     // migration functions migrate the data from the previous contract in stages
9     // all addresses are included for transparency and easy verification
10     // however addresses with no robots (i.e. failed transaction and never bought properly) have been commented out.
11     // to view the full list of state assignments, go to etherscan.io/address/{address} and you can view the verified
12     mapping (address => uint[]) public userToRobots; 
13 
14     function _migrate(uint _index) external onlyOwner {
15         bytes4 selector = bytes4(sha3("setData()"));
16         address a = migrators[_index];
17         require(a.delegatecall(selector));
18     }
19     // source code - feel free to verify the migration
20     address[6] migrators = [
21         0x700febd9360ac0a0a72f371615427bec4e4454e5, //0x97ae01893e42d6d33fd9851a28e5627222af7bbb,
22         0x72cc898de0a4eac49c46ccb990379099461342f6,
23         0xc3cc48da3b8168154e0f14bf0446c7a93613f0a7,
24         0x4cc96f2ddf6844323ae0d8461d418a4d473b9ac3,
25         0xa52bfcb5ff599e29ee2b9130f1575babaa27de0a,
26         0xe503b42aabda22974e2a8b75fa87e010e1b13584
27     ];
28     
29     function NewCratePreSale() public payable {
30         
31             owner = msg.sender;
32         // one time transfer of state from the previous contract
33         // var previous = CratePreSale(0x3c7767011C443EfeF2187cf1F2a4c02062da3998); //MAINNET
34 
35         // oldAppreciationRateWei = previous.appreciationRateWei();
36         oldAppreciationRateWei = 100000000000000;
37         appreciationRateWei = oldAppreciationRateWei;
38   
39         // oldPrice = previous.currentPrice();
40         oldPrice = 232600000000000000;
41         currentPrice = oldPrice;
42 
43         // oldCratesSold = previous.cratesSold();
44         oldCratesSold = 1075;
45         cratesSold = oldCratesSold;
46 
47         // Migration Rationale
48         // due to solidity issues with enumerability (contract calls cannot return dynamic arrays etc)
49         // no need for trust -> can still use web3 to call the previous contract and check the state
50         // will only change in the future if people send more eth
51         // and will be obvious due to change in crate count. Any purchases on the old contract
52         // after this contract is deployed will be fully refunded, and those robots bought will be voided. 
53         // feel free to validate any address on the old etherscan:
54         // https://etherscan.io/address/0x3c7767011C443EfeF2187cf1F2a4c02062da3998
55         // can visit the exact contracts at the addresses listed above
56     }
57 
58     // ------ STATE ------
59     uint256 constant public MAX_CRATES_TO_SELL = 3900; // Max no. of robot crates to ever be sold
60     uint256 constant public PRESALE_END_TIMESTAMP = 1518699600; // End date for the presale - no purchases can be made after this date - Midnight 16 Feb 2018 UTC
61 
62     uint256 public appreciationRateWei;
63     uint32 public cratesSold;
64     uint256 public currentPrice;
65 
66     // preserve these for later verification
67     uint32 public oldCratesSold;
68     uint256 public oldPrice;
69     uint256 public oldAppreciationRateWei;
70     // mapping (address => uint32) public userCrateCount; // replaced with more efficient method
71     
72 
73     // store the unopened crates of this user
74     // actually stores the blocknumber of each crate 
75     mapping (address => uint[]) public addressToPurchasedBlocks;
76     // store the number of expired crates for each user 
77     // i.e. crates where the user failed to open the crate within 256 blocks (~1 hour)
78     // these crates will be able to be opened post-launch
79     mapping (address => uint) public expiredCrates;
80     // store the part information of purchased crates
81 
82 
83 
84     function openAll() public {
85         uint len = addressToPurchasedBlocks[msg.sender].length;
86         require(len > 0);
87         uint8 count = 0;
88         // len > i to stop predicatable wraparound
89         for (uint i = len - 1; i >= 0 && len > i; i--) {
90             uint crateBlock = addressToPurchasedBlocks[msg.sender][i];
91             require(block.number > crateBlock);
92             // can't open on the same timestamp
93             var hash = block.blockhash(crateBlock);
94             if (uint(hash) != 0) {
95                 // different results for all different crates, even on the same block/same user
96                 // randomness is already taken care of
97                 uint rand = uint(keccak256(hash, msg.sender, i)) % (10 ** 20);
98                 userToRobots[msg.sender].push(rand);
99                 count++;
100             } else {
101                 // all others will be expired
102                 expiredCrates[msg.sender] += (i + 1);
103                 break;
104             }
105         }
106         CratesOpened(msg.sender, count);
107         delete addressToPurchasedBlocks[msg.sender];
108     }
109 
110     // ------ EVENTS ------
111     event CratesPurchased(address indexed _from, uint8 _quantity);
112     event CratesOpened(address indexed _from, uint8 _quantity);
113 
114     // ------ FUNCTIONS ------
115     function getPrice() view public returns (uint256) {
116         return currentPrice;
117     }
118 
119     function getRobotCountForUser(address _user) external view returns(uint256) {
120         return userToRobots[_user].length;
121     }
122 
123     function getRobotForUserByIndex(address _user, uint _index) external view returns(uint) {
124         return userToRobots[_user][_index];
125     }
126 
127     function getRobotsForUser(address _user) view public returns (uint[]) {
128         return userToRobots[_user];
129     }
130 
131     function getPendingCratesForUser(address _user) external view returns(uint[]) {
132         return addressToPurchasedBlocks[_user];
133     }
134 
135     function getPendingCrateForUserByIndex(address _user, uint _index) external view returns(uint) {
136         return addressToPurchasedBlocks[_user][_index];
137     }
138 
139     function getExpiredCratesForUser(address _user) external view returns(uint) {
140         return expiredCrates[_user];
141     }
142 
143     function incrementPrice() private {
144         // Decrease the rate of increase of the crate price
145         // as the crates become more expensive
146         // to avoid runaway pricing
147         // (halving rate of increase at 0.1 ETH, 0.2 ETH, 0.3 ETH).
148         if ( currentPrice == 100000000000000000 ) {
149             appreciationRateWei = 200000000000000;
150         } else if ( currentPrice == 200000000000000000) {
151             appreciationRateWei = 100000000000000;
152         } else if (currentPrice == 300000000000000000) {
153             appreciationRateWei = 50000000000000;
154         }
155         currentPrice += appreciationRateWei;
156     }
157 
158     function purchaseCrates(uint8 _cratesToBuy) public payable whenNotPaused {
159         require(now < PRESALE_END_TIMESTAMP); // Check presale is still ongoing.
160         require(_cratesToBuy <= 10); // Can only buy max 10 crates at a time. Don't be greedy!
161         require(_cratesToBuy >= 1); // Sanity check. Also, you have to buy a crate. 
162         require(cratesSold + _cratesToBuy <= MAX_CRATES_TO_SELL); // Check max crates sold is less than hard limit
163         uint256 priceToPay = _calculatePayment(_cratesToBuy);
164          require(msg.value >= priceToPay); // Check buyer sent sufficient funds to purchase
165         if (msg.value > priceToPay) { //overpaid, return excess
166             msg.sender.transfer(msg.value-priceToPay);
167         }
168         //all good, payment received. increment number sold, price, and generate crate receipts!
169         cratesSold += _cratesToBuy;
170       for (uint8 i = 0; i < _cratesToBuy; i++) {
171             incrementPrice();
172             addressToPurchasedBlocks[msg.sender].push(block.number);
173         }
174 
175         CratesPurchased(msg.sender, _cratesToBuy);
176     } 
177 
178     function _calculatePayment (uint8 _cratesToBuy) private view returns (uint256) {
179         
180         uint256 tempPrice = currentPrice;
181 
182         for (uint8 i = 1; i < _cratesToBuy; i++) {
183             tempPrice += (currentPrice + (appreciationRateWei * i));
184         } // for every crate over 1 bought, add current Price and a multiple of the appreciation rate
185           // very small edge case of buying 10 when you the appreciation rate is about to halve
186           // is compensated by the great reduction in gas by buying N at a time.
187         
188         return tempPrice;
189     }
190 
191 
192     //owner only withdrawal function for the presale
193     function withdraw() onlyOwner public {
194         owner.transfer(this.balance);
195     }
196 
197     function addFunds() onlyOwner external payable {
198 
199     }
200 
201   event SetPaused(bool paused);
202 
203   // starts unpaused
204   bool public paused = false;
205 
206   modifier whenNotPaused() {
207     require(!paused);
208     _;
209   }
210 
211   modifier whenPaused() {
212     require(paused);
213     _;
214   }
215 
216   function pause() external onlyOwner whenNotPaused returns (bool) {
217     paused = true;
218     SetPaused(paused);
219     return true;
220   }
221 
222   function unpause() external onlyOwner whenPaused returns (bool) {
223     paused = false;
224     SetPaused(paused);
225     return true;
226   }
227 
228 
229   address public owner;
230 
231   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233 
234 
235 
236   modifier onlyOwner() {
237     require(msg.sender == owner);
238     _;
239   }
240 
241   function transferOwnership(address newOwner) public onlyOwner {
242     require(newOwner != address(0));
243     OwnershipTransferred(owner, newOwner);
244     owner = newOwner;
245   }
246     
247 }