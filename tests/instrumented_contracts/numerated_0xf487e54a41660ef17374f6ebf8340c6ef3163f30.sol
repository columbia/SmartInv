1 pragma solidity 0.4.15;
2 
3 contract ERC20 {
4     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
5 }
6 
7 contract REMMESale {
8     uint public constant SALES_START = 1518552000; // 13.02.2018 20:00:00 UTC
9     uint public constant FIRST_DAY_END = 1518638400; // 14.02.2018 20:00:00 UTC
10     uint public constant SALES_DEADLINE = 1518724800; // 15.02.2018 20:00:00 UTC
11     address public constant ASSET_MANAGER_WALLET = 0xbb12800E7446A51395B2d853D6Ce7F22210Bb5E5;
12     address public constant TOKEN = 0x83984d6142934bb535793A82ADB0a46EF0F66B6d; // REMME token
13     address public constant WHITELIST_SUPPLIER = 0x1Ff21eCa1c3ba96ed53783aB9C92FfbF77862584;
14     uint public constant TOKEN_CENTS = 10000; // 1 REM is 1.0000 REM
15     uint public constant BONUS = 10;
16     uint public constant SALE_MAX_CAP = 500000000 * TOKEN_CENTS;
17     uint public constant MINIMAL_PARTICIPATION = 0.1 ether;
18     uint public constant MAXIMAL_PARTICIPATION = 15 ether;
19 
20     uint public saleContributions;
21     uint public tokensPurchased;
22     uint public allowedGasPrice = 20000000000 wei;
23     uint public tokenPriceWei;
24 
25     mapping(address => uint) public participantContribution;
26     mapping(address => bool) public whitelist;
27 
28     event Contributed(address receiver, uint contribution, uint reward);
29     event WhitelistUpdated(address participant, bool isWhitelisted);
30     event AllowedGasPriceUpdated(uint gasPrice);
31     event TokenPriceUpdated(uint tokenPriceWei);
32     event Error(string message);
33 
34     function REMMESale(uint _ethUsdPrice) {
35         tokenPriceWei = 0.04 ether / _ethUsdPrice;
36     }
37 
38     function contribute() payable returns(bool) {
39         return contributeFor(msg.sender);
40     }
41 
42     function contributeFor(address _participant) payable returns(bool) {
43         require(now >= SALES_START);
44         require(now < SALES_DEADLINE);
45         require((participantContribution[_participant] + msg.value) >= MINIMAL_PARTICIPATION);
46         // Only the whitelisted addresses can participate.
47         require(whitelist[_participant]);
48 
49         //check for MAXIMAL_PARTICIPATION and allowedGasPrice only at first day
50         if (now <= FIRST_DAY_END) {
51             require((participantContribution[_participant] + msg.value) <= MAXIMAL_PARTICIPATION);
52             require(tx.gasprice <= allowedGasPrice);
53         }
54 
55         // If there is some division reminder, we just collect it too.
56         uint tokensAmount = (msg.value * TOKEN_CENTS) / tokenPriceWei;
57         require(tokensAmount > 0);
58         uint bonusTokens = (tokensAmount * BONUS) / 100;
59         uint totalTokens = tokensAmount + bonusTokens;
60 
61         tokensPurchased += totalTokens;
62         require(tokensPurchased <= SALE_MAX_CAP);
63         require(ERC20(TOKEN).transferFrom(ASSET_MANAGER_WALLET, _participant, totalTokens));
64         saleContributions += msg.value;
65         participantContribution[_participant] += msg.value;
66         ASSET_MANAGER_WALLET.transfer(msg.value);
67 
68         Contributed(_participant, msg.value, totalTokens);
69         return true;
70     }
71 
72     modifier onlyWhitelistSupplier() {
73         require(msg.sender == WHITELIST_SUPPLIER || msg.sender == ASSET_MANAGER_WALLET);
74         _;
75     }
76 
77     modifier onlyAdmin() {
78         require(msg.sender == ASSET_MANAGER_WALLET);
79         _;
80     }
81 
82     function addToWhitelist(address _participant) onlyWhitelistSupplier() returns(bool) {
83         if (whitelist[_participant]) {
84             return true;
85         }
86         whitelist[_participant] = true;
87         WhitelistUpdated(_participant, true);
88         return true;
89     }
90 
91     function removeFromWhitelist(address _participant) onlyWhitelistSupplier() returns(bool) {
92         if (!whitelist[_participant]) {
93             return true;
94         }
95         whitelist[_participant] = false;
96         WhitelistUpdated(_participant, false);
97         return true;
98     }
99 
100     function setGasPrice(uint _allowedGasPrice) onlyAdmin() returns(bool) {
101         allowedGasPrice = _allowedGasPrice;
102         AllowedGasPriceUpdated(allowedGasPrice);
103         return true;
104     }
105 
106     function setEthPrice(uint _ethUsdPrice) onlyAdmin() returns(bool) {
107         tokenPriceWei = 0.04 ether / _ethUsdPrice;
108         TokenPriceUpdated(tokenPriceWei);
109         return true;
110     }
111 
112     function () payable {
113         contribute();
114     }
115 }