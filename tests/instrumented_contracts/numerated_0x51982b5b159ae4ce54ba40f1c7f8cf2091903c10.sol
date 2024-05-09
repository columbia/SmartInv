1 // hevm: flattened sources of contracts/LightPool.sol
2 pragma solidity ^0.4.21;
3 
4 ////// contracts/interfaces/ERC20.sol
5 /* pragma solidity ^0.4.21; */
6 
7 contract ERC20Events {
8     event Approval(address indexed src, address indexed guy, uint wad);
9     event Transfer(address indexed src, address indexed dst, uint wad);
10 }
11 
12 contract ERC20 is ERC20Events {
13     function decimals() public view returns (uint);
14     function totalSupply() public view returns (uint);
15     function balanceOf(address guy) public view returns (uint);
16     function allowance(address src, address guy) public view returns (uint);
17 
18     function approve(address guy, uint wad) public returns (bool);
19     function transfer(address dst, uint wad) public returns (bool);
20     function transferFrom(address src, address dst, uint wad) public returns (bool);
21 }
22 
23 ////// contracts/interfaces/PriceSanityInterface.sol
24 /* pragma solidity ^0.4.21; */
25 
26 contract PriceSanityInterface {
27     function checkPrice(address base, address quote, bool buy, uint256 baseAmount, uint256 quoteAmount) external view returns (bool result);
28 }
29 
30 ////// contracts/interfaces/WETHInterface.sol
31 /* pragma solidity ^0.4.21; */
32 
33 /* import "./ERC20.sol"; */
34 
35 contract WETHInterface is ERC20 {
36   function() external payable;
37   function deposit() external payable;
38   function withdraw(uint wad) external;
39 }
40 
41 ////// contracts/LightPool.sol
42 /* pragma solidity ^0.4.21; */
43 
44 /* import "./interfaces/WETHInterface.sol"; */
45 /* import "./interfaces/PriceSanityInterface.sol"; */
46 /* import "./interfaces/ERC20.sol"; */
47 
48 contract LightPool {
49     uint16 constant public EXTERNAL_QUERY_GAS_LIMIT = 4999;    // Changes to state require at least 5000 gas
50 
51     struct TokenData {
52         address walletAddress;
53         PriceSanityInterface priceSanityContract;
54     }
55 
56     // key = keccak256(token, base, walletAddress)
57     mapping(bytes32 => TokenData)       public markets;
58     mapping(address => bool)            public traders;
59     address                             public owner;
60 
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     modifier onlyWalletAddress(address base, address quote) {
67         bytes32 key = keccak256(base, quote, msg.sender);
68         require(markets[key].walletAddress == msg.sender);
69         _;
70     }
71 
72     modifier onlyTrader() {
73         require(traders[msg.sender]);
74         _;
75     }
76 
77     function LightPool() public {
78         owner = msg.sender;
79     }
80 
81     function setTrader(address trader, bool enabled) onlyOwner external {
82         traders[trader] = enabled;
83     }
84 
85     function setOwner(address _owner) onlyOwner external {
86         require(_owner != address(0));
87         owner = _owner;
88     }
89 
90     event AddMarket(address indexed base, address indexed quote, address indexed walletAddress, address priceSanityContract);
91     function addMarket(ERC20 base, ERC20 quote, PriceSanityInterface priceSanityContract) external {
92         require(base != address(0));
93         require(quote != address(0));
94 
95         // Make sure there's no such configured token
96         bytes32 tokenHash = keccak256(base, quote, msg.sender);
97         require(markets[tokenHash].walletAddress == address(0));
98 
99         // Initialize token pool data
100         markets[tokenHash] = TokenData(msg.sender, priceSanityContract);
101         emit AddMarket(base, quote, msg.sender, priceSanityContract);
102     }
103 
104     event RemoveMarket(address indexed base, address indexed quote, address indexed walletAddress);
105     function removeMarket(ERC20 base, ERC20 quote) onlyWalletAddress(base, quote) external {
106         bytes32 tokenHash = keccak256(base, quote, msg.sender);
107         TokenData storage tokenData = markets[tokenHash];
108 
109         emit RemoveMarket(base, quote, tokenData.walletAddress);
110         delete markets[tokenHash];
111     }
112 
113     event ChangePriceSanityContract(address indexed base, address indexed quote, address indexed walletAddress, address priceSanityContract);
114     function changePriceSanityContract(ERC20 base, ERC20 quote, PriceSanityInterface _priceSanityContract) onlyWalletAddress(base, quote) external {
115         bytes32 tokenHash = keccak256(base, quote, msg.sender);
116         TokenData storage tokenData = markets[tokenHash];
117         tokenData.priceSanityContract = _priceSanityContract;
118         emit ChangePriceSanityContract(base, quote, msg.sender, _priceSanityContract);
119     }
120 
121     event Trade(address indexed trader, address indexed baseToken, address indexed quoteToken, address walletAddress, bool buy, uint256 baseAmount, uint256 quoteAmount);
122     function trade(ERC20 base, ERC20 quote, address walletAddress, bool buy, uint256 baseAmount, uint256 quoteAmount) onlyTrader external {
123         bytes32 tokenHash = keccak256(base, quote, walletAddress);
124         TokenData storage tokenData = markets[tokenHash];
125         require(tokenData.walletAddress != address(0));
126         if (tokenData.priceSanityContract != address(0)) {
127             require(tokenData.priceSanityContract.checkPrice.gas(EXTERNAL_QUERY_GAS_LIMIT)(base, quote, buy, baseAmount, quoteAmount)); // Limit gas to prevent reentrancy
128         }
129         ERC20 takenToken;
130         ERC20 givenToken;
131         uint256 takenTokenAmount;
132         uint256 givenTokenAmount;
133         if (buy) {
134             takenToken = quote;
135             givenToken = base;
136             takenTokenAmount = quoteAmount;
137             givenTokenAmount = baseAmount;
138         } else {
139             takenToken = base;
140             givenToken = quote;
141             takenTokenAmount = baseAmount;
142             givenTokenAmount = quoteAmount;
143         }
144         require(takenTokenAmount != 0 && givenTokenAmount != 0);
145 
146         // Swap!
147         require(takenToken.transferFrom(msg.sender, tokenData.walletAddress, takenTokenAmount));
148         require(givenToken.transferFrom(tokenData.walletAddress, msg.sender, givenTokenAmount));
149         emit Trade(msg.sender, base, quote, walletAddress, buy, baseAmount, quoteAmount);
150     }
151 }