1 pragma solidity 0.4.15;
2 
3 contract ERC20 {
4     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
5 }
6 
7 contract TokensaleBlacklist {
8     function isRestricted(address _addr) constant returns(bool);
9 }
10 
11 contract TraderStarsSale {
12     uint public constant SALES_START = 1510754400; // 15.11.2017 14:00:00 UTC
13     uint public constant SALES_DEADLINE = 1513864800; // 21.12.2017 14:00:00 UTC
14     address public constant MASTER_WALLET = 0x909B194c56eB3ecf10F1f9FaF5fc8E35B2de1F2d;
15     address public constant TOKEN = 0xfCA1a79D59Bcf870fAA685BE0d0cdA394F52Ceb5;
16     address public constant TOKENSALE_BLACKLIST = 0x945B2c9569A8ebd883d05Ab20f09AD6c241cB156;
17     uint public constant TOKEN_PRICE = 0.00000003 ether;
18     uint public constant PRE_ICO_MAX_CAP = 100000000000;
19     uint public constant ICO_MAX_CAP = 2100000000000;
20     uint public preIcoTotalSupply;
21     uint public icoTotalSupply;
22 
23     event Contributed(address receiver, uint contribution, uint reward);
24 
25     function contribute() payable returns(bool) {
26         require(msg.value >= TOKEN_PRICE);
27         require(now < SALES_DEADLINE);
28         require(now >= SALES_START);
29         // Blacklist of exchange pools, and other not private wallets.
30         require(!TokensaleBlacklist(TOKENSALE_BLACKLIST).isRestricted(msg.sender));
31 
32         uint tokensAmount = _calculateBonusAndUpdateTotal(msg.value / TOKEN_PRICE);
33         require(tokensAmount > 0);
34         require(preIcoTotalSupply < PRE_ICO_MAX_CAP);
35         require(preIcoTotalSupply + icoTotalSupply < ICO_MAX_CAP);
36 
37         require(ERC20(TOKEN).transferFrom(MASTER_WALLET, msg.sender, tokensAmount));
38         // If there is some division reminder from msg.value % TOKEN_PRICE, we just
39         // collect it too.
40         MASTER_WALLET.transfer(msg.value);
41 
42         Contributed(msg.sender, msg.value, tokensAmount);
43         return true;
44     }
45 
46     function _calculateBonusAndUpdateTotal(uint _value) internal returns(uint) {
47         uint currentTime = now;
48         uint amountWithBonus;
49 
50         // between 5.12.2017 14:00:00 UTC and 21.12.2017 14:00:00 UTC no bonus
51         if (currentTime > 1512482400 && currentTime <= SALES_DEADLINE) {
52             icoTotalSupply += _value;
53             return _value;
54         // between 28.11.2017 14:00:00 UTC and 5.12.2017 14:00:00 UTC +2.5%
55         } else if (currentTime > 1511877600 && currentTime <= 1512482400) {
56             amountWithBonus = _value + _value * 25 / 1000;
57             icoTotalSupply += amountWithBonus;
58             return amountWithBonus;
59         // between 24.11.2017 14:00:00 UTC and 28.11.2017 14:00:00 UTC +5%
60         } else if (currentTime > 1511532000 && currentTime <= 1511877600) {
61             amountWithBonus = _value + _value * 50 / 1000;
62             icoTotalSupply += amountWithBonus;
63             return amountWithBonus;
64         // between 22.11.2017 14:00:00 UTC and 24.11.2017 14:00:00 UTC +10%
65         } else if (currentTime > 1511359200 && currentTime <= 1511532000) {
66             amountWithBonus = _value + _value * 100 / 1000;
67             icoTotalSupply += amountWithBonus;
68             return amountWithBonus;
69         // between 21.11.2017 14:00:00 UTC and 22.11.2017 14:00:00 UTC +25%
70         } else if (currentTime > 1511272800 && currentTime <= 1511359200) {
71             amountWithBonus = _value + _value * 250 / 1000;
72             icoTotalSupply += amountWithBonus;
73             return amountWithBonus;
74         // between 15.11.2017 14:00:00 UTC and 17.11.2017 14:00:00 UTC +30%
75         } else if (currentTime >= SALES_START && currentTime <= 1510927200) {
76             amountWithBonus = _value + _value * 300 / 1000;
77             preIcoTotalSupply += amountWithBonus;
78             return amountWithBonus;
79         }
80         
81         return 0;
82     }
83 
84     function () payable {
85         contribute();
86     }
87 }