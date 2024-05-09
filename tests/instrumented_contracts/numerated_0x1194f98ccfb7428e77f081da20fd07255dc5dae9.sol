1 pragma solidity 0.4.15;
2 
3 contract ERC20 {
4     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
5 }
6 
7 contract REMMEPreSale {
8     uint public constant SALES_START = 1512399600; // 04.12.2017 15:00:00 UTC
9     uint public constant SALES_DEADLINE = 1514214000; // 25.12.2017 15:00:00 UTC
10     address public constant ASSET_MANAGER_WALLET = 0xbb12800E7446A51395B2d853D6Ce7F22210Bb5E5;
11     address public constant TOKEN = 0x83984d6142934bb535793A82ADB0a46EF0F66B6d; // REMME token
12     address public constant WHITELIST_SUPPLIER = 0x1Ff21eCa1c3ba96ed53783aB9C92FfbF77862584;
13     uint public constant ETH_PRICE_USD = 470;
14     uint public constant TOKEN_PRICE_WEI = 0.04 ether / ETH_PRICE_USD; // 0.000085106382978723 ETH
15     uint public constant TOKEN_CENTS = 10000; // 1 REM is 1.0000 REM
16     uint public constant BONUS = 20; // 20%
17     // 1,000 ETH
18     uint public constant PRE_SALE_SOFT_CAP = 1000 ether;
19     // 6,700 ETH, 78,725,000 REM + 15,745,000 REM BONUS = 94,470,000 REM
20     uint public constant PRE_SALE_MAX_CAP = 6700 ether;
21     // 10 ETH
22     uint public constant MINIMAL_PARTICIPATION = 10 ether;
23     // 1100 ETH
24     uint public constant MAXIMAL_PARTICIPATION = 1100 ether;
25     uint public preSaleContributions;
26     mapping(address => uint) public participantContribution;
27     mapping(address => bool) public whitelist;
28 
29     event Contributed(address receiver, uint contribution, uint reward);
30     event WhitelistUpdated(address participant, bool isWhitelisted);
31 
32     function contribute() payable returns(bool) {
33         return contributeFor(msg.sender);
34     }
35 
36     function contributeFor(address _participant) payable returns(bool) {
37         require(now >= SALES_START);
38         require(now < SALES_DEADLINE);
39         require((participantContribution[_participant] + msg.value) >= MINIMAL_PARTICIPATION);
40         require((participantContribution[_participant] + msg.value) <= MAXIMAL_PARTICIPATION);
41         require((preSaleContributions + msg.value) <= PRE_SALE_MAX_CAP);
42         // Only the whitelisted addresses can participate.
43         require(whitelist[_participant]);
44 
45         // If there is some division reminder, we just collect it too.
46         uint tokensAmount = (msg.value * TOKEN_CENTS) / TOKEN_PRICE_WEI;
47         require(tokensAmount > 0);
48         uint bonusTokens = (tokensAmount * BONUS) / 100;
49         uint totalTokens = tokensAmount + bonusTokens;
50 
51         require(ERC20(TOKEN).transferFrom(ASSET_MANAGER_WALLET, _participant, totalTokens));
52         preSaleContributions += msg.value;
53         participantContribution[_participant] += msg.value;
54         ASSET_MANAGER_WALLET.transfer(msg.value);
55 
56         Contributed(_participant, msg.value, totalTokens);
57         return true;
58     }
59 
60     modifier onlyWhitelistSupplier() {
61         require(msg.sender == WHITELIST_SUPPLIER || msg.sender == ASSET_MANAGER_WALLET);
62         _;
63     }
64 
65     function addToWhitelist(address _participant) onlyWhitelistSupplier() returns(bool) {
66         if (whitelist[_participant]) {
67             return true;
68         }
69         whitelist[_participant] = true;
70         WhitelistUpdated(_participant, true);
71         return true;
72     }
73 
74     function removeFromWhitelist(address _participant) onlyWhitelistSupplier() returns(bool) {
75         if (!whitelist[_participant]) {
76             return true;
77         }
78         whitelist[_participant] = false;
79         WhitelistUpdated(_participant, false);
80         return true;
81     }
82 
83     function isSoftCapReached() constant returns(bool) {
84         return preSaleContributions >= PRE_SALE_SOFT_CAP;
85     }
86 
87     function () payable {
88         contribute();
89     }
90 }