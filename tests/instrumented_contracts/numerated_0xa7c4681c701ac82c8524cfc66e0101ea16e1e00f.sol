1 pragma solidity ^0.4.19;
2 
3 library AddressUtils {
4     function isContract(address addr) internal view returns (bool) {
5         uint256 size;
6         assembly { size := extcodesize(addr) }
7         return size > 0;
8     }
9 }
10 
11 contract BasicAccessControl {
12     address public owner;
13     // address[] public moderators;
14     uint16 public totalModerators = 0;
15     mapping (address => bool) public moderators;
16     bool public isMaintaining = false;
17 
18     function BasicAccessControl() public {
19         owner = msg.sender;
20     }
21 
22     modifier onlyOwner {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     modifier onlyModerators() {
28         require(msg.sender == owner || moderators[msg.sender] == true);
29         _;
30     }
31 
32     modifier isActive {
33         require(!isMaintaining);
34         _;
35     }
36 
37     function ChangeOwner(address _newOwner) onlyOwner public {
38         if (_newOwner != address(0)) {
39             owner = _newOwner;
40         }
41     }
42 
43 
44     function AddModerator(address _newModerator) onlyOwner public {
45         if (moderators[_newModerator] == false) {
46             moderators[_newModerator] = true;
47             totalModerators += 1;
48         }
49     }
50     
51     function RemoveModerator(address _oldModerator) onlyOwner public {
52         if (moderators[_oldModerator] == true) {
53             moderators[_oldModerator] = false;
54             totalModerators -= 1;
55         }
56     }
57 
58     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
59         isMaintaining = _isMaintaining;
60     }
61 }
62 
63 contract ERC20Interface {
64     function totalSupply() public constant returns (uint);
65     function balanceOf(address tokenOwner) public constant returns (uint balance);
66     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
67     function transfer(address to, uint tokens) public returns (bool success);
68     function approve(address spender, uint tokens) public returns (bool success);
69     function transferFrom(address from, address to, uint tokens) public returns (bool success);
70 }
71 
72 
73 contract EtheremonAdventurePresale is BasicAccessControl {
74     uint8 constant NO_ETH_SITE = 52;
75     uint8 constant MAX_BID_PER_SITE = 2;
76     using AddressUtils for address;
77     
78     struct BiddingInfo {
79         address bidder;
80         uint32 bidId;
81         uint amount;
82         uint time;
83         uint8 siteId;
84     }
85     
86     // address
87     address public tokenContract;
88     
89     uint32 public totalBid = 0;
90     uint public startTime;
91     uint public endTime;
92     uint public bidETHMin;
93     uint public bidETHIncrement;
94     uint public bidEMONTMin;
95     uint public bidEMONTIncrement;
96     
97     mapping(uint32 => BiddingInfo) bids;
98     mapping(uint8 => uint32[]) sites;
99 
100     // event
101     event EventPlaceBid(address indexed bidder, uint8 siteId, uint32 bidId, uint amount);
102     
103     // modifier
104     modifier requireTokenContract {
105         require(tokenContract != address(0));
106         _;
107     }
108     
109     modifier validETHSiteId(uint8 _siteId) {
110         require(_siteId > 0 && _siteId <= NO_ETH_SITE);
111         _;
112     }
113     modifier validEMONTSiteId(uint8 _siteId) {
114         require(_siteId == 53 || _siteId == 54);
115         _;
116     }
117     modifier onlyRunning {
118         require(!isMaintaining);
119         require(block.timestamp >= startTime && block.timestamp < endTime);
120         _;
121     }
122     
123     function withdrawEther(address _sendTo, uint _amount) onlyModerators public {
124         // only allow withdraw after the presale 
125         if (block.timestamp < endTime)
126             revert();
127         if (_amount > this.balance) {
128             revert();
129         }
130         _sendTo.transfer(_amount);
131     }
132     
133     function withdrawToken(address _sendTo, uint _amount) onlyModerators requireTokenContract external {
134         // only allow withdraw after the presale 
135         if (block.timestamp < endTime)
136             revert();
137         ERC20Interface token = ERC20Interface(tokenContract);
138         if (_amount > token.balanceOf(address(this))) {
139             revert();
140         }
141         token.transfer(_sendTo, _amount);
142     }
143 
144     
145     // public functions
146     
147     function EtheremonAdventurePresale(uint _bidETHMin, uint _bidETHIncrement, uint _bidEMONTMin, uint _bidEMONTIncrement, uint _startTime, uint _endTime, address _tokenContract) public {
148         if (_startTime >= _endTime) revert();
149         
150         startTime = _startTime;
151         endTime = _endTime;
152         bidETHMin = _bidETHMin;
153         bidETHIncrement = _bidETHIncrement;
154         bidEMONTMin = _bidEMONTMin;
155         bidEMONTIncrement = _bidEMONTIncrement;
156         
157         tokenContract = _tokenContract;
158     }
159     
160     function placeETHBid(uint8 _siteId) onlyRunning payable external validETHSiteId(_siteId) {
161         // check valid bid 
162         if (msg.sender.isContract()) revert();
163         if (msg.value < bidETHMin) revert();
164         
165         uint index = 0;
166         totalBid += 1;
167         BiddingInfo storage bid = bids[totalBid];
168         bid.bidder = msg.sender;
169         bid.bidId = totalBid;
170         bid.amount = msg.value;
171         bid.time = block.timestamp;
172         bid.siteId = _siteId;
173         
174         uint32[] storage siteBids = sites[_siteId];
175         if (siteBids.length >= MAX_BID_PER_SITE) {
176             // find lowest bid
177             uint lowestIndex = 0;
178             BiddingInfo storage currentBid = bids[siteBids[0]];
179             BiddingInfo storage lowestBid = currentBid;
180             for (index = 0; index < siteBids.length; index++) {
181                 currentBid = bids[siteBids[index]];
182                 // check no same ether address 
183                 if (currentBid.bidder == msg.sender) {
184                     revert();
185                 }
186                 if (lowestBid.amount == 0 || currentBid.amount < lowestBid.amount || (currentBid.amount == lowestBid.amount && currentBid.bidId > lowestBid.bidId)) {
187                     lowestIndex = index;
188                     lowestBid = currentBid;
189                 }
190             }
191             
192             // verify bidIncrement
193             if (msg.value < lowestBid.amount + bidETHIncrement)
194                 revert();
195             
196             // update latest bidder
197             siteBids[lowestIndex] = totalBid;
198             
199             // refund for the lowest 
200             lowestBid.bidder.transfer(lowestBid.amount);
201         } else {
202             for (index = 0; index < siteBids.length; index++) {
203                 if (bids[siteBids[index]].bidder == msg.sender)
204                     revert();
205             }
206             siteBids.push(totalBid);
207         }
208         
209         EventPlaceBid(msg.sender, _siteId, totalBid, msg.value);
210     }
211     
212     // call from our payment contract
213     function placeEMONTBid(address _bidder, uint8 _siteId, uint _bidAmount) requireTokenContract onlyRunning onlyModerators external validEMONTSiteId(_siteId) {
214         // check valid bid 
215         if (_bidder.isContract()) revert();
216         if (_bidAmount < bidEMONTMin) revert();
217         
218         
219         uint index = 0;
220         totalBid += 1;
221         BiddingInfo storage bid = bids[totalBid];
222         uint32[] storage siteBids = sites[_siteId];
223         if (siteBids.length >= MAX_BID_PER_SITE) {
224             // find lowest bid
225             uint lowestIndex = 0;
226             BiddingInfo storage currentBid = bids[siteBids[0]];
227             BiddingInfo storage lowestBid = currentBid;
228             for (index = 0; index < siteBids.length; index++) {
229                 currentBid = bids[siteBids[index]];
230                 // check no same ether address 
231                 if (currentBid.bidder == _bidder) {
232                     revert();
233                 }
234                 if (lowestBid.amount == 0 || currentBid.amount < lowestBid.amount || (currentBid.amount == lowestBid.amount && currentBid.bidId > lowestBid.bidId)) {
235                     lowestIndex = index;
236                     lowestBid = currentBid;
237                 }
238             }
239             
240             // verify bidIncrement
241             if (_bidAmount < lowestBid.amount + bidEMONTIncrement)
242                 revert();
243             
244             // update latest bidder
245             bid.bidder = _bidder;
246             bid.bidId = totalBid;
247             bid.amount = _bidAmount;
248             bid.time = block.timestamp;
249             siteBids[lowestIndex] = totalBid;
250             
251             // refund for the lowest 
252             ERC20Interface token = ERC20Interface(tokenContract);
253             token.transfer(lowestBid.bidder, lowestBid.amount);
254         } else {
255             for (index = 0; index < siteBids.length; index++) {
256                 if (bids[siteBids[index]].bidder == _bidder)
257                     revert();
258             }
259             bid.bidder = _bidder;
260             bid.bidId = totalBid;
261             bid.amount = _bidAmount;
262             bid.time = block.timestamp;
263             siteBids.push(totalBid);
264         }
265         
266         EventPlaceBid(_bidder, _siteId, totalBid, _bidAmount);
267     }
268     
269     // get data
270     
271     function getBidInfo(uint32 _bidId) constant external returns(address bidder, uint8 siteId, uint amount, uint time) {
272         BiddingInfo memory bid = bids[_bidId];
273         bidder = bid.bidder;
274         siteId = bid.siteId;
275         amount = bid.amount;
276         time = bid.time;
277     }
278     
279     function getBidBySiteIndex(uint8 _siteId, uint _index) constant external returns(address bidder, uint32 bidId, uint8 siteId, uint amount, uint time) {
280         bidId = sites[_siteId][_index];
281         if (bidId > 0) {
282             BiddingInfo memory bid = bids[bidId];
283             bidder = bid.bidder;
284             siteId = bid.siteId;
285             amount = bid.amount;
286             time = bid.time;
287         }
288     }
289 
290     function countBid(uint8 _siteId) constant external returns(uint) {
291         return sites[_siteId].length;
292     }
293     
294     function getLowestBid(uint8 _siteId) constant external returns(uint lowestAmount) {
295         uint32[] storage siteBids = sites[_siteId];
296         lowestAmount = 0;
297         for (uint index = 0; index < siteBids.length; index++) {
298             if (lowestAmount == 0 || bids[siteBids[index]].amount < lowestAmount) {
299                 lowestAmount = bids[siteBids[index]].amount;
300             }
301         }
302     }
303 }