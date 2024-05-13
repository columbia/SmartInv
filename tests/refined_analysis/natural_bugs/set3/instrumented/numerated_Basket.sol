1 pragma solidity =0.8.7;
2 
3 import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
4 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import { ERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
6 import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
7 import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
8 import './interfaces/IAuction.sol';
9 import "./interfaces/IBasket.sol";
10 import "./interfaces/IFactory.sol";
11 import "hardhat/console.sol";
12 
13 //TODO: add revert reasons or v8 custom errors back in
14 contract Basket is IBasket, ERC20Upgradeable, ReentrancyGuard {
15     using SafeERC20 for IERC20;
16 
17     //TODO: recommend using block timestamp instead of block numbers here
18     uint256 public constant TIMELOCK_DURATION = 4 * 60 * 24; // 1 day in blocks
19     uint256 public constant ONE_YEAR = 365.25 days;
20     uint256 private constant BASE = 1e18;
21 
22     address public publisher;
23     uint256 public licenseFee;
24 
25     IFactory public override factory;
26     IAuction public override auction;
27 
28     uint256 public override ibRatio;
29 
30     PendingPublisher public pendingPublisher;
31     PendingLicenseFee public pendingLicenseFee;
32     PendingWeights public pendingWeights;
33 
34     address[] public tokens;
35     uint256[] public weights;
36 
37     uint256 public override lastFee;
38 
39     bool public override initialized;
40 
41     function initialize(IFactory.Proposal memory proposal, IAuction auction_) external override {
42         require(address(factory) == address(0));
43         require(!initialized);
44 
45         publisher = proposal.proposer;
46         licenseFee = proposal.licenseFee;
47         factory = IFactory(msg.sender);
48         auction = auction_;
49         ibRatio = BASE;
50         tokens = proposal.tokens;
51         weights = proposal.weights;
52         approveUnderlying(address(auction));
53 
54         __ERC20_init(proposal.tokenName, proposal.tokenSymbol);
55 
56         initialized = true;
57     }
58 
59     function getPendingWeights() external override view returns (address[] memory, uint256[] memory) {
60         return (pendingWeights.tokens, pendingWeights.weights);
61     }
62 
63     function validateWeights(address[] memory _tokens, uint256[] memory _weights) public override pure {
64         require(_tokens.length > 0);
65         require(_tokens.length == _weights.length);
66         uint256 length = _tokens.length;
67         address[] memory tokenList = new address[](length);
68 
69         // check uniqueness of tokens and not token(0)
70 
71         for (uint i = 0; i < length; i++) {
72             require(_tokens[i] != address(0));
73             require(_weights[i] > 0);
74 
75             for (uint256 x = 0; x < tokenList.length; x++) {
76                 require(_tokens[i] != tokenList[x]);
77             }
78 
79             tokenList[i] = _tokens[i];
80         }
81     }
82 
83     function mint(uint256 amount) public nonReentrant override {
84         mintTo(amount, msg.sender);
85     }
86 
87     function mintTo(uint256 amount, address to) public nonReentrant override {
88         require(auction.auctionOngoing() == false);
89         require(amount > 0);
90 
91         handleFees();
92 
93         pullUnderlying(amount, msg.sender);
94 
95         _mint(to, amount);
96 
97         emit Minted(to, amount);
98     }
99 
100     function burn(uint256 amount) public nonReentrant override {
101         require(auction.auctionOngoing() == false);
102         require(amount > 0);
103 
104         handleFees();
105 
106         pushUnderlying(amount, msg.sender);
107         _burn(msg.sender, amount);
108         
109         emit Burned(msg.sender, amount);
110     }
111 
112     function auctionBurn(uint256 amount) onlyAuction nonReentrant external override {
113         handleFees();
114         uint256 startSupply = totalSupply();
115         _burn(msg.sender, amount);
116 
117         uint256 newIbRatio = ibRatio * startSupply / (startSupply - amount);
118         ibRatio = newIbRatio;
119 
120         emit NewIBRatio(newIbRatio);
121         emit Burned(msg.sender, amount);
122     }
123 
124     function handleFees() private {
125         if (lastFee == 0) {
126             lastFee = block.timestamp;
127         } else {
128             uint256 startSupply = totalSupply();
129 
130             uint256 timeDiff = (block.timestamp - lastFee);
131             uint256 feePct = timeDiff * licenseFee / ONE_YEAR;
132             uint256 fee = startSupply * feePct / (BASE - feePct);
133 
134             _mint(publisher, fee * (BASE - factory.ownerSplit()) / BASE);
135             _mint(Ownable(address(factory)).owner(), fee * factory.ownerSplit() / BASE);
136             lastFee = block.timestamp;
137 
138             uint256 newIbRatio = ibRatio * startSupply / totalSupply();
139             ibRatio = newIbRatio;
140 
141             emit NewIBRatio(ibRatio);
142         }
143     }
144 
145     // changes publisher
146     // timelocked
147     function changePublisher(address newPublisher) onlyPublisher public override {
148         require(newPublisher != address(0));
149 
150         if (pendingPublisher.publisher != address(0) && pendingPublisher.publisher == newPublisher) {
151             require(block.number >= pendingPublisher.block + TIMELOCK_DURATION);
152             publisher = newPublisher;
153 
154             pendingPublisher.publisher = address(0);
155 
156             emit ChangedPublisher(publisher);
157         } else {
158             pendingPublisher.publisher = newPublisher;
159             pendingPublisher.block = block.number;
160 
161             emit NewPublisherSubmitted(newPublisher);
162         }
163     }
164 
165     //changes licenseFee
166     // timelocked
167     function changeLicenseFee(uint256 newLicenseFee) onlyPublisher public override {
168         require(newLicenseFee >= factory.minLicenseFee() && newLicenseFee != licenseFee);
169         if (pendingLicenseFee.licenseFee != 0 && pendingLicenseFee.licenseFee == newLicenseFee) {
170             require(block.number >= pendingLicenseFee.block + TIMELOCK_DURATION);
171             licenseFee = newLicenseFee;
172 
173             pendingLicenseFee.licenseFee = 0;
174 
175             emit ChangedLicenseFee(licenseFee);
176         } else {
177             pendingLicenseFee.licenseFee = newLicenseFee;
178             pendingLicenseFee.block = block.number;
179 
180             emit NewLicenseFeeSubmitted(newLicenseFee);
181         }
182     }
183 
184     // publish new index
185     // timelocked
186     function publishNewIndex(address[] memory _tokens, uint256[] memory _weights) onlyPublisher public override {
187         validateWeights(_tokens, _weights);
188 
189         if (pendingWeights.pending) {
190             require(block.number >= pendingWeights.block + TIMELOCK_DURATION);
191             if (auction.auctionOngoing() == false) {
192                 auction.startAuction();
193 
194                 emit PublishedNewIndex(publisher);
195             } else if (auction.hasBonded()) {
196 
197             } else {
198                 auction.killAuction();
199 
200                 pendingWeights.tokens = _tokens;
201                 pendingWeights.weights = _weights;
202                 pendingWeights.block = block.number;
203             }
204         } else {
205             pendingWeights.pending = true;
206             pendingWeights.tokens = _tokens;
207             pendingWeights.weights = _weights;
208             pendingWeights.block = block.number;
209 
210             emit NewIndexSubmitted();
211         }
212     }
213 
214     function setNewWeights() onlyAuction external override {
215         tokens = pendingWeights.tokens;
216         weights = pendingWeights.weights;
217         pendingWeights.pending = false;
218 
219         approveUnderlying(address(auction));
220 
221         emit WeightsSet();
222     }
223 
224     // delete pending index
225     function deleteNewIndex() public override {
226         require(msg.sender == publisher || msg.sender == address(auction));
227         require(auction.auctionOngoing() == false);
228 
229         pendingWeights.pending = false;
230 
231         emit DeletedNewIndex(publisher);
232     }
233 
234     function updateIBRatio(uint256 newRatio) onlyAuction external override returns (uint256) {
235         ibRatio = newRatio;
236 
237         emit NewIBRatio(ibRatio);
238 
239         return ibRatio;
240     }
241 
242     function approveUnderlying(address spender) private {
243         for (uint256 i = 0; i < weights.length; i++) {
244             IERC20(tokens[i]).safeApprove(spender, 0);
245             IERC20(tokens[i]).safeApprove(spender, type(uint256).max);
246         }
247     }
248 
249     function pushUnderlying(uint256 amount, address to) private {
250         for (uint256 i = 0; i < weights.length; i++) {
251             uint256 tokenAmount = amount * weights[i] * ibRatio / BASE / BASE;
252             IERC20(tokens[i]).safeTransfer(to, tokenAmount);
253         }
254     }
255 
256     function pullUnderlying(uint256 amount, address from) private {
257         for (uint256 i = 0; i < weights.length; i++) {
258             uint256 tokenAmount = amount * weights[i] * ibRatio / BASE / BASE;
259             require(tokenAmount > 0);
260             IERC20(tokens[i]).safeTransferFrom(from, address(this), tokenAmount);
261         }
262     }
263 
264     modifier onlyAuction() {
265         require(msg.sender == address(auction));
266         _;
267     }
268 
269     modifier onlyPublisher() {
270         require(msg.sender == address(publisher));
271         _;
272     }
273 }