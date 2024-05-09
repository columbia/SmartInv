1 pragma solidity 0.4.17;
2 
3 // import "./FunderSmartToken.sol";
4 
5 contract PreSale {
6 
7   address private deployer;
8 
9   // for performing allowed transfer
10   address private FunderSmartTokenAddress = 0x0;
11   address private FundersTokenCentral = 0x0;
12 
13   // 1 eth = 150 fst
14   uint256 public oneEtherIsHowMuchFST = 150;
15 
16   // uint256 public startTime = 0;
17   uint256 public startTime = 1506052800; // 2017/09/22
18   uint256 public endTime   = 1508731200; // 2017/10/22
19 
20   uint256 public soldTokenValue = 0;
21   uint256 public preSaleHardCap = 330000000 * (10 ** 18) * 2 / 100; // presale 2% hard cap amount
22 
23   event BuyEvent (address buyer, string email, uint256 etherValue, uint256 tokenValue);
24 
25   function PreSale () public {
26     deployer = msg.sender;
27   }
28 
29   // PreSale Contract 必須先從 Funder Smart Token approve 過
30   function buyFunderSmartToken (string _email, string _code) payable public returns (bool) {
31     require(FunderSmartTokenAddress != 0x0); // 需初始化過 token contract 位址
32     require(FundersTokenCentral != 0x0); // 需初始化過 fstk 中央帳戶
33     require(msg.value >= 1 ether); // 人們要至少用 1 ether 買 token
34     require(now >= startTime && now <= endTime); // presale 舉辦期間
35     require(soldTokenValue <= preSaleHardCap); // 累積 presale 量不得超過 fst 總發行量 2%
36 
37     uint256 _tokenValue = msg.value * oneEtherIsHowMuchFST;
38 
39     // 35%
40     if (keccak256(_code) == 0xde7683d6497212fbd59b6a6f902a01c91a09d9a070bba7506dcc0b309b358eed) {
41       _tokenValue = _tokenValue * 135 / 100;
42     }
43 
44     // 30%
45     if (keccak256(_code) == 0x65b236bfb931f493eb9e6f3db8d461f1f547f2f3a19e33a7aeb24c7e297c926a) {
46       _tokenValue = _tokenValue * 130 / 100;
47     }
48 
49     // 25%
50     if (keccak256(_code) == 0x274125681e11c33f71574f123a20cfd59ed25e64d634078679014fa3a872575c) {
51       _tokenValue = _tokenValue * 125 / 100;
52     }
53 
54     // 將 FST 從 FundersTokenCentral 轉至 msg.sender
55     if (FunderSmartTokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), FundersTokenCentral, msg.sender, _tokenValue) != true) {
56       revert();
57     }
58 
59     BuyEvent(msg.sender, _email, msg.value, _tokenValue);
60 
61     soldTokenValue = soldTokenValue + _tokenValue;
62 
63     return true;
64   }
65 
66   // 把以太幣傳出去
67   function transferOut (address _to, uint256 _etherValue) public returns (bool) {
68     require(msg.sender == deployer);
69     _to.transfer(_etherValue);
70     return true;
71   }
72 
73   // 指定 FST Token Contract (FunderSmartTokenAddress)
74   function setFSTAddress (address _funderSmartTokenAddress) public returns (bool) {
75     require(msg.sender == deployer);
76     FunderSmartTokenAddress = _funderSmartTokenAddress;
77     return true;
78   }
79 
80   // 指定 FSTK 主帳 (FundersTokenCentral)
81   function setFSTKCentral (address _fundersTokenCentral) public returns (bool) {
82     require(msg.sender == deployer);
83     FundersTokenCentral = _fundersTokenCentral;
84     return true;
85   }
86 
87   function () public {}
88 
89 }