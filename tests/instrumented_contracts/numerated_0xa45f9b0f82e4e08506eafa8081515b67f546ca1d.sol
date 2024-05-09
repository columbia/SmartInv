1 pragma solidity ^0.4.18;
2 
3 
4 interface WETH9 {
5   function approve(address spender, uint amount) public returns(bool);
6   function deposit() public payable;
7 }
8 
9 interface DutchExchange {
10   function deposit(address tokenAddress,uint amount) public returns(uint);
11   function postBuyOrder(address sellToken,address buyToken,uint auctionIndex,uint amount) public returns (uint);
12   function getAuctionIndex(address token1,address token2) public view returns(uint);
13   function claimBuyerFunds(
14         address sellToken,
15         address buyToken,
16         address user,
17         uint auctionIndex
18     ) public returns(uint returned, uint frtsIssued);
19   function withdraw(address tokenAddress,uint amount) public returns (uint);
20   function getCurrentAuctionPrice(
21       address sellToken,
22       address buyToken,
23       uint auctionIndex
24   ) public view returns (uint num, uint den);
25 
26 }
27 
28 interface ERC20 {
29   function transfer(address recipient, uint amount) public returns(bool);
30   function approve(address spender, uint amount) public returns(bool);
31 }
32 
33 interface KyberNetwork {
34     function trade(
35         ERC20 src,
36         uint srcAmount,
37         ERC20 dest,
38         address destAddress,
39         uint maxDestAmount,
40         uint minConversionRate,
41         address walletId
42     )
43         public
44         payable
45         returns(uint);
46 
47     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view
48         returns (uint expectedRate, uint slippageRate);
49 }
50 
51 
52 contract DutchReserve {
53   DutchExchange constant DUTCH_EXCHANGE = DutchExchange(0xaf1745c0f8117384Dfa5FFf40f824057c70F2ed3);
54   WETH9 constant WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
55   KyberNetwork constant KYBER = KyberNetwork(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);
56   ERC20 constant ETH = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
57   ERC20 constant RDN = ERC20(0x255Aa6DF07540Cb5d3d297f0D0D4D84cb52bc8e6);
58 
59   function DutchReserve() public {
60     require(WETH.approve(DUTCH_EXCHANGE,2**255));
61     enableToken(RDN);
62   }
63 
64   function enableToken(ERC20 token) public {
65       require(token.approve(KYBER,2**255));
66   }
67 
68   function getGnosisInvRate(uint ethAmount) public view returns(uint) {
69       ethAmount;
70       
71       uint auctionIndex = DUTCH_EXCHANGE.getAuctionIndex(RDN,WETH);
72       uint num; uint den;
73       (num,den) = DUTCH_EXCHANGE.getCurrentAuctionPrice(RDN,WETH,auctionIndex);
74 
75       return (num * 10**15) / (den * 995);
76   }
77 
78   function getKyberRate(uint rdnAmount) public view returns(uint) {
79       uint rate; uint slippageRate;
80       (rate,slippageRate) = KYBER.getExpectedRate(RDN,ETH,rdnAmount);
81 
82       return rate;
83   }
84 
85   function isArb(uint amount, uint bpsDiff) public view returns(bool) {
86       uint kyberRate = getKyberRate(amount);
87       uint gnosisRate = getGnosisInvRate(amount);
88       uint gnosisRateAdj = (gnosisRate * (10000 + bpsDiff))/10000;
89 
90       return gnosisRateAdj <= kyberRate;
91   }
92 
93   function buyToken(bool onlyIfArb) payable public {
94     uint auctionIndex = DUTCH_EXCHANGE.getAuctionIndex(RDN,WETH);
95     uint minRate = onlyIfArb ? getGnosisInvRate(msg.value) : 1;
96     WETH.deposit.value(msg.value)();
97     DUTCH_EXCHANGE.deposit(WETH, msg.value);
98     DUTCH_EXCHANGE.postBuyOrder(RDN,WETH,auctionIndex,msg.value);
99     uint amount; uint first;
100     (amount,first) = DUTCH_EXCHANGE.claimBuyerFunds(RDN,WETH,this,auctionIndex);
101     DUTCH_EXCHANGE.withdraw(RDN,amount);
102     require(KYBER.trade(RDN,amount,ETH,msg.sender,2**255,minRate,this) > 0) ;
103     //RDN.transfer(msg.sender,amount);
104   }
105 
106 }