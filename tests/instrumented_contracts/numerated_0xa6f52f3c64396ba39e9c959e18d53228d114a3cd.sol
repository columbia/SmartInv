1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is not paused.
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev Modifier to make a function callable only when the contract is paused.
95    */
96   modifier whenPaused() {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * @dev called by the owner to pause, triggers stopped state
103    */
104   function pause() public onlyOwner whenNotPaused {
105     paused = true;
106     emit Pause();
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() public onlyOwner whenPaused {
113     paused = false;
114     emit Unpause();
115   }
116 }
117 
118 
119 contract RCPreorder is Pausable {
120     uint8 constant WEEK1_PERCENT_AMOUNT = 30;
121     uint8 constant WEEK2_PERCENT_AMOUNT = 60;
122     uint8 constant WEEK3_PERCENT_AMOUNT = 80;
123     uint32 constant WEEK1_DURATION = 1 weeks;
124     uint32 constant WEEK2_DURATION = 2 weeks;
125     uint32 constant WEEK3_DURATION = 3 weeks;
126     uint32 constant SECONDS_PER_BLOCK = 15;
127 
128     event PackPurchased(address indexed user, uint8 indexed packId, uint256 price);
129 
130     struct Purchase {
131         uint8 packId;
132         address user;
133         uint64 commit;
134     }
135 
136     Purchase[] public purchases;
137 
138     mapping (uint8 => uint256) public prices;
139     mapping (uint8 => uint256) public leftCount;
140 
141     uint256 public startBlock;
142 
143     constructor() public {
144         paused = true;
145 
146         // The creator of the contract is the initial owner
147         owner = msg.sender;
148     }
149 
150     function purchase(uint8 _packId) external payable whenNotPaused {
151         require(_packIsAvialable(_packId));
152         require(_isRunning());
153 
154         uint256 currentPrice = _computeCurrentPrice(prices[_packId]);
155         // Check current price of pack
156         require(msg.value >= currentPrice);
157 
158         Purchase memory p = Purchase({
159             user: msg.sender,
160             packId: _packId,
161             commit: uint64(block.number)
162         });
163 
164         purchases.push(p);
165         leftCount[_packId]--;
166 
167         emit PackPurchased(msg.sender, _packId, currentPrice);
168     }
169 
170     function getPackPrice(uint8 _packId) external view returns (uint256) {
171         return _computeCurrentPrice(prices[_packId]);
172     }
173 
174     function getPurchaseCount() external view returns (uint) {
175         return purchases.length;
176     }
177 
178     function run() external onlyOwner {
179         startBlock = block.number;
180         unpause();
181     }
182 
183     function addPack(uint8 _id, uint256 _price, uint256 _count) external onlyOwner {
184         prices[_id] = _price;
185         leftCount[_id] = _count;
186     }
187 
188     function withdraw() external onlyOwner {
189         address(msg.sender).transfer(address(this).balance);
190     }
191 
192     function unpause() public onlyOwner whenPaused {
193         require(startBlock > 0);
194 
195         // Actually unpause the contract.
196         super.unpause();
197     }
198 
199     function _isRunning() internal view returns (bool) {
200         uint diff = block.number - startBlock;
201         return startBlock > 0 && diff < uint(WEEK3_DURATION / SECONDS_PER_BLOCK);
202     }
203 
204     function _packIsAvialable(uint8 _id) internal view returns (bool) {
205         return leftCount[_id] > 0;
206     }
207 
208     function _computeCurrentPrice(
209         uint256 _basePrice
210     )
211         internal
212         view
213         returns (uint256)
214     {
215         uint diff = block.number - startBlock;
216 
217         if (diff < uint(WEEK1_DURATION / SECONDS_PER_BLOCK)) {
218             // Week 1 price
219             return _basePrice * WEEK1_PERCENT_AMOUNT / 100;
220         } else if (diff < uint(WEEK2_DURATION / SECONDS_PER_BLOCK)) {
221             // Week 2 price
222             return _basePrice * WEEK2_PERCENT_AMOUNT / 100;
223         } else if (diff < uint(WEEK3_DURATION / SECONDS_PER_BLOCK)) {
224             // Week 3 price
225             return _basePrice * WEEK3_PERCENT_AMOUNT / 100;
226         }
227 
228         return _basePrice;
229     }
230 }