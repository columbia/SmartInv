1 pragma solidity =0.8.7;
2 
3 import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
4 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import { ERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
6 import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
7 import './interfaces/IAuction.sol';
8 import "./interfaces/IBasket.sol";
9 import "./interfaces/IFactory.sol";
10 import "hardhat/console.sol";
11 
12 contract Basket is IBasket, ERC20Upgradeable {
13     using SafeERC20 for IERC20;
14 
15     uint256 public constant TIMELOCK_DURATION = 4 * 60 * 24; // 1 day
16     uint256 public constant ONE_YEAR = 365.25 days;
17     uint256 private constant BASE = 1e18;
18 
19     address public publisher;
20     uint256 public licenseFee;
21 
22     IFactory public override factory;
23     IAuction public override auction;
24 
25     uint256 public override ibRatio;
26 
27     PendingPublisher public pendingPublisher;
28     PendingLicenseFee public pendingLicenseFee;
29     PendingWeights public pendingWeights;
30 
31     address[] public tokens;
32     uint256[] public weights;
33 
34     uint256 public override lastFee;
35 
36     function initialize(IFactory.Proposal memory proposal, IAuction auction_) public override {
37         publisher = proposal.proposer;
38         licenseFee = proposal.licenseFee;
39         factory = IFactory(msg.sender);
40         auction = auction_;
41         ibRatio = BASE;
42         tokens = proposal.tokens;
43         weights = proposal.weights;
44         approveUnderlying(address(auction));
45 
46         __ERC20_init(proposal.tokenName, proposal.tokenSymbol);
47     }
48 
49     function getPendingWeights() external override view returns (address[] memory, uint256[] memory) {
50         return (pendingWeights.tokens, pendingWeights.weights);
51     }
52 
53     function validateWeights(address[] memory _tokens, uint256[] memory _weights) public override pure {
54         require(_tokens.length == _weights.length);
55         uint256 length = _tokens.length;
56         address[] memory tokenList = new address[](length);
57 
58         // check uniqueness of tokens and not token(0)
59 
60         for (uint i = 0; i < length; i++) {
61             require(_tokens[i] != address(0));
62             require(_weights[i] > 0);
63 
64             for (uint256 x = 0; x < tokenList.length; x++) {
65                 require(_tokens[i] != tokenList[x]);
66             }
67 
68             tokenList[i] = _tokens[i];
69         }
70     }
71 
72     function mint(uint256 amount) public override {
73         mintTo(amount, msg.sender);
74     }
75 
76     function mintTo(uint256 amount, address to) public override {
77         require(auction.auctionOngoing() == false);
78         require(amount > 0);
79 
80         handleFees();
81 
82         pullUnderlying(amount, msg.sender);
83 
84         _mint(to, amount);
85 
86         emit Minted(to, amount);
87     }
88 
89     function burn(uint256 amount) public override {
90         require(auction.auctionOngoing() == false);
91         require(amount > 0);
92         require(balanceOf(msg.sender) >= amount);
93 
94         handleFees();
95 
96         pushUnderlying(amount, msg.sender);
97         _burn(msg.sender, amount);
98         
99         emit Burned(msg.sender, amount);
100     }
101 
102     function auctionBurn(uint256 amount) onlyAuction external override {
103         handleFees();
104 
105         _burn(msg.sender, amount);
106 
107         emit Burned(msg.sender, amount);
108     }
109 
110     function handleFees() private {
111         if (lastFee == 0) {
112             lastFee = block.timestamp;
113         } else {
114             uint256 startSupply = totalSupply();
115 
116             uint256 timeDiff = (block.timestamp - lastFee);
117             uint256 feePct = timeDiff * licenseFee / ONE_YEAR;
118             uint256 fee = startSupply * feePct / (BASE - feePct);
119 
120             _mint(publisher, fee * (BASE - factory.ownerSplit()) / BASE);
121             _mint(Ownable(address(factory)).owner(), fee * factory.ownerSplit() / BASE);
122             lastFee = block.timestamp;
123 
124             uint256 newIbRatio = ibRatio * startSupply / totalSupply();
125             ibRatio = newIbRatio;
126 
127             emit NewIBRatio(ibRatio);
128         }
129     }
130 
131     // changes publisher
132     // timelocked
133     function changePublisher(address newPublisher) onlyPublisher public override {
134         require(newPublisher != address(0));
135 
136         if (pendingPublisher.publisher != address(0)) {
137             require(pendingPublisher.publisher == newPublisher);
138             require(block.number >= pendingPublisher.block + TIMELOCK_DURATION);
139             publisher = pendingPublisher.publisher;
140 
141             pendingPublisher.publisher = address(0);
142 
143             emit ChangedPublisher(publisher);
144         } else {
145             pendingPublisher.publisher = newPublisher;
146             pendingPublisher.block = block.number;
147         }
148     }
149 
150     //changes licenseFee
151     // timelocked
152     function changeLicenseFee(uint256 newLicenseFee) onlyPublisher public override {
153         require(newLicenseFee >= factory.minLicenseFee() && newLicenseFee != licenseFee);
154         if (pendingLicenseFee.licenseFee != 0) {
155             require(pendingLicenseFee.licenseFee == newLicenseFee);
156             require(block.number >= pendingLicenseFee.block + TIMELOCK_DURATION);
157             licenseFee = pendingLicenseFee.licenseFee;
158 
159             pendingLicenseFee.licenseFee = 0;
160 
161             emit ChangedLicenseFee(licenseFee);
162         } else {
163             pendingLicenseFee.licenseFee = newLicenseFee;
164             pendingLicenseFee.block = block.number;
165         }
166     }
167 
168     // publish new index
169     // timelocked
170     function publishNewIndex(address[] memory _tokens, uint256[] memory _weights) onlyPublisher public override {
171         validateWeights(_tokens, _weights);
172 
173         if (pendingWeights.pending) {
174             require(block.number >= pendingWeights.block + TIMELOCK_DURATION);
175             if (auction.auctionOngoing() == false) {
176                 auction.startAuction();
177 
178                 emit PublishedNewIndex(publisher);
179             } else if (auction.hasBonded()) {
180 
181             } else {
182                 auction.killAuction();
183 
184                 pendingWeights.tokens = _tokens;
185                 pendingWeights.weights = _weights;
186                 pendingWeights.block = block.number;
187             }
188         } else {
189             pendingWeights.pending = true;
190             pendingWeights.tokens = _tokens;
191             pendingWeights.weights = _weights;
192             pendingWeights.block = block.number;
193         }
194     }
195 
196     function setNewWeights() onlyAuction external override {
197         tokens = pendingWeights.tokens;
198         weights = pendingWeights.weights;
199         pendingWeights.pending = false;
200 
201         approveUnderlying(address(auction));
202 
203         emit WeightsSet();
204     }
205 
206     // delete pending index
207     function deleteNewIndex() public override {
208         require(msg.sender == publisher || msg.sender == address(auction));
209         require(auction.auctionOngoing() == false);
210 
211         pendingWeights.pending = false;
212 
213         emit DeletedNewIndex(publisher);
214     }
215 
216     function updateIBRatio(uint256 newRatio) onlyAuction external override returns (uint256) {
217         ibRatio = newRatio;
218 
219         emit NewIBRatio(ibRatio);
220 
221         return ibRatio;
222     }
223 
224     function approveUnderlying(address spender) private {
225         for (uint256 i = 0; i < weights.length; i++) {
226             IERC20(tokens[i]).approve(spender, type(uint256).max);
227         }
228     }
229 
230     function pushUnderlying(uint256 amount, address to) private {
231         for (uint256 i = 0; i < weights.length; i++) {
232             uint256 tokenAmount = amount * weights[i] * ibRatio / BASE / BASE;
233             IERC20(tokens[i]).safeTransfer(to, tokenAmount);
234         }
235     }
236 
237     function pullUnderlying(uint256 amount, address from) private {
238         for (uint256 i = 0; i < weights.length; i++) {
239             uint256 tokenAmount = amount * weights[i] * ibRatio / BASE / BASE;
240             IERC20(tokens[i]).safeTransferFrom(from, address(this), tokenAmount);
241         }
242     }
243 
244     modifier onlyAuction() {
245         require(msg.sender == address(auction));
246         _;
247     }
248 
249     modifier onlyPublisher() {
250         require(msg.sender == address(publisher));
251         _;
252     }
253 }