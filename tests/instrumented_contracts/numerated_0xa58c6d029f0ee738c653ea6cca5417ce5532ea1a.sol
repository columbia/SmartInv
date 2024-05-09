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
12   function getAuctionIndex(address token1,address token2) public returns(uint);
13   function claimBuyerFunds(
14         address sellToken,
15         address buyToken,
16         address user,
17         uint auctionIndex
18     ) public returns(uint returned, uint frtsIssued);
19   function withdraw(address tokenAddress,uint amount) public returns (uint);    
20 }
21 
22 interface ERC20 {
23   function transfer(address recipient, uint amount) public returns(bool);
24   function approve(address spender, uint amount) public returns(bool);  
25 }
26 
27 interface KyberNetwork {
28     function trade(
29         ERC20 src,
30         uint srcAmount,
31         ERC20 dest,
32         address destAddress,
33         uint maxDestAmount,
34         uint minConversionRate,
35         address walletId
36     )
37         public
38         payable
39         returns(uint);    
40 }
41 
42 
43 contract DutchReserve {
44   DutchExchange constant DUTCH_EXCHANGE = DutchExchange(0xaf1745c0f8117384Dfa5FFf40f824057c70F2ed3);
45   WETH9 constant WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
46   KyberNetwork constant KYBER = KyberNetwork(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);
47   ERC20 constant ETH = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
48 
49   function DutchReserve() public {
50     require(WETH.approve(DUTCH_EXCHANGE,2**255));
51   }
52   
53   function enableToken(ERC20 token) public {
54       require(token.approve(KYBER,2**255));
55   }
56 
57   function buyToken(ERC20 token) payable public {
58     uint auctionIndex = DUTCH_EXCHANGE.getAuctionIndex(token,WETH);
59     WETH.deposit.value(msg.value)();
60     DUTCH_EXCHANGE.deposit(WETH, msg.value);
61     DUTCH_EXCHANGE.postBuyOrder(token,WETH,auctionIndex,msg.value);
62     uint amount; uint first;
63     (amount,first) = DUTCH_EXCHANGE.claimBuyerFunds(token,WETH,this,auctionIndex);
64     DUTCH_EXCHANGE.withdraw(token,amount);
65     require(KYBER.trade(token,amount,ETH,msg.sender,2**255,1,this) > 0) ;
66     //token.transfer(msg.sender,amount);
67   }
68 
69 }