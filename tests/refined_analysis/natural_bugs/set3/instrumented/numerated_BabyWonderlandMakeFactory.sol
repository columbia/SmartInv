1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.4;
4 
5 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
6 import "@openzeppelin/contracts/utils/Address.sol";
7 import "@openzeppelin/contracts/access/Ownable.sol";
8 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
9 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
10 import "../interfaces/IBabyWonderlandMintable.sol";
11 
12 contract SmartMintableInitializable is ReentrancyGuard, Ownable {
13     using SafeERC20 for IERC20;
14     using SafeMath for uint256;
15     // The address of the smart minter factory
16     address public immutable SMART_MINTER_FACTORY;
17     IBabyWonderlandMintable public babyWonderlandToken;
18     IERC20 public payToken;
19     bool public isInitialized;
20     address payable public reserve;
21     uint256 public price;
22     uint256 public startTime;
23     uint256 public endTime;
24     uint256 public supply;
25     uint256 public remaning;
26     uint256 public poolLimitPerUser;
27     uint256 public plotsCapacity;
28     bool public hasWhitelistLimit;
29     mapping(address => uint256) public numberOfUsersMinted;
30 
31     event MintPlots(address account, uint256 startTokenId, uint256 number);
32     event NewReserve(address oldReserve, address newReserve);
33 
34     constructor() {
35         SMART_MINTER_FACTORY = msg.sender;
36     }
37 
38     function initialize(
39         address _babyWonderlandToken,
40         address payable _reserve,
41         address _payToken,
42         uint256 _price,
43         uint256 _startTime,
44         uint256 _endTime,
45         uint256 _supply,
46         uint256 _poolLimitPerUser,
47         uint256 _plotsCapacity,
48         bool _hasWhitelistLimit
49     ) external {
50         require(!isInitialized, "Already initialized the contract");
51         require(msg.sender == SMART_MINTER_FACTORY, "Not factory");
52         require(_reserve != address(0), "_reserve can not be address(0)");
53         require(_price > 0, "price can not be 0");
54         require(_startTime <= _endTime, "invalid time params");
55         require(_poolLimitPerUser > 0, "_poolLimitPerUser can not be 0");
56         require(_plotsCapacity > 0, "_plotsCapacity can not be 0");
57         // Make this contract initialized
58         isInitialized = true;
59         babyWonderlandToken = IBabyWonderlandMintable(_babyWonderlandToken);
60         reserve = _reserve;
61         payToken = IERC20(_payToken);
62         price = _price;
63         startTime = _startTime;
64         endTime = _endTime;
65         supply = _supply;
66         remaning = _supply;
67         poolLimitPerUser = _poolLimitPerUser;
68         hasWhitelistLimit = _hasWhitelistLimit;
69         plotsCapacity = _plotsCapacity;
70     }
71 
72     function mint() external payable nonReentrant onlyWhitelist {
73         require(
74             numberOfUsersMinted[msg.sender] < poolLimitPerUser,
75             "purchase limit reached"
76         );
77         require(remaning > 0, "insufficient remaining");
78         require(block.timestamp > startTime, "has not started");
79         require(block.timestamp < endTime, "has expired");
80         numberOfUsersMinted[msg.sender] += 1;
81         if (address(payToken) == address(0)) {
82             require(msg.value == price, "not enough tokens to pay");
83             Address.sendValue(reserve, price);
84         } else {
85             payToken.safeTransferFrom(msg.sender, reserve, price);
86         }
87         remaning -= 1;
88         babyWonderlandToken.batchMint(msg.sender, plotsCapacity);
89 
90         emit MintPlots(
91             msg.sender,
92             babyWonderlandToken.totalSupply() + 1,
93             plotsCapacity
94         );
95     }
96 
97     function batchMint(uint256 number) external payable nonReentrant onlyWhitelist {
98         require(block.timestamp > startTime, "has not started");
99         require(block.timestamp < endTime, "has expired");
100         require(
101             numberOfUsersMinted[msg.sender].add(number) <= poolLimitPerUser,
102             "purchase limit reached"
103         );
104         numberOfUsersMinted[msg.sender] += number;
105         for (uint256 i = 0; i != number; i++) {
106             require(remaning > 0, "insufficient remaining");
107             if (address(payToken) == address(0)) {
108                 require(
109                     msg.value == price.mul(number),
110                     "not enough tokens to pay"
111                 );
112                 Address.sendValue(reserve, price);
113             } else {
114                 payToken.safeTransferFrom(msg.sender, reserve, price);
115             }
116             remaning -= 1;
117             babyWonderlandToken.batchMint(msg.sender, plotsCapacity);
118 
119             emit MintPlots(
120                 msg.sender,
121                 babyWonderlandToken.totalSupply() + 1,
122                 plotsCapacity
123             );
124         }
125     }
126 
127     modifier onlyWhitelist() {
128         require(
129             !hasWhitelistLimit ||
130                 BabyWonderlandMakeFactory(SMART_MINTER_FACTORY).whitelist(
131                     msg.sender
132                 ),
133             "available only to whitelisted users"
134         );
135 
136         _;
137     }
138 }
139 
140 contract BabyWonderlandMakeFactory is Ownable {
141     uint256 private nonce;
142 
143     address immutable public babyWonderlandToken;
144 
145     mapping(address => bool) public isAdmin;
146     mapping(address => bool) public whitelist;
147 
148     event NewSmartMintableContract(address indexed smartChef);
149     event SetAdmin(address account, bool enable);
150     event AddWhitelist(address account);
151     event DelWhitelist(address account);
152 
153     constructor(address _babyWonderlandToken) {
154         require(_babyWonderlandToken != address(0), "illegal token address");
155         babyWonderlandToken = _babyWonderlandToken;
156     }
157 
158     function addWhitelist(address account) public onlyAdmin {
159         whitelist[account] = true;
160         emit AddWhitelist(account);
161     }
162 
163     function batchAddWhitelist(address[] memory accounts) external onlyAdmin {
164         for (uint256 i = 0; i != accounts.length; i++) {
165             addWhitelist(accounts[i]);
166         }
167     }
168 
169     function delWhitelist(address account) public onlyAdmin {
170         whitelist[account] = false;
171         emit DelWhitelist(account);
172     }
173 
174     function batchDelWhitelist(address[] memory accounts) external onlyAdmin {
175         for (uint256 i = 0; i != accounts.length; i++) {
176             delWhitelist(accounts[i]);
177         }
178     }
179 
180     function setAdmin(address admin, bool enable) external onlyOwner {
181         require(
182             admin != address(0),
183             "BabyWonderlandMakeFactory: address is zero"
184         );
185         isAdmin[admin] = enable;
186         emit SetAdmin(admin, enable);
187     }
188 
189     modifier onlyAdmin() {
190         require(
191             isAdmin[msg.sender],
192             "BabyWonderlandMakeFactory: caller is not the admin"
193         );
194         _;
195     }
196 
197     function deployMintable(
198         address payable _reserve,
199         address _payToken,
200         uint256 _price,
201         uint256 _startTime,
202         uint256 _endTime,
203         uint256 _supply,
204         uint256 _poolLimitPerUser,
205         uint256 _plotsCapacity,
206         bool _hasWhitelistLimit
207     ) external onlyAdmin {
208         nonce = nonce + 1;
209         bytes memory bytecode = type(SmartMintableInitializable).creationCode;
210         bytes32 salt = keccak256(abi.encodePacked(nonce));
211         address smartMintableAddress;
212 
213         assembly {
214             smartMintableAddress := create2(
215                 0,
216                 add(bytecode, 32),
217                 mload(bytecode),
218                 salt
219             )
220         }
221         SmartMintableInitializable(smartMintableAddress).initialize(
222             babyWonderlandToken,
223             _reserve,
224             _payToken,
225             _price,
226             _startTime,
227             _endTime,
228             _supply,
229             _poolLimitPerUser,
230             _plotsCapacity,
231             _hasWhitelistLimit
232         );
233         emit NewSmartMintableContract(smartMintableAddress);
234     }
235 }
