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
24 }
25 
26 
27 contract DutchReserve {
28   DutchExchange constant DUTCH_EXCHANGE = DutchExchange(0xaf1745c0f8117384Dfa5FFf40f824057c70F2ed3);
29   WETH9 constant WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
30 
31   function DutchReserve() public {
32     require(WETH.approve(DUTCH_EXCHANGE,2**255));
33   }
34 
35   function buyToken(ERC20 token) payable public {
36     uint auctionIndex = DUTCH_EXCHANGE.getAuctionIndex(token,WETH);
37     WETH.deposit.value(msg.value)();
38     DUTCH_EXCHANGE.deposit(WETH, msg.value);
39     DUTCH_EXCHANGE.postBuyOrder(token,WETH,auctionIndex,msg.value);
40     uint amount; uint first;
41     (amount,first) = DUTCH_EXCHANGE.claimBuyerFunds(token,WETH,this,auctionIndex);
42     DUTCH_EXCHANGE.withdraw(token,amount);
43     token.transfer(msg.sender,amount);
44   }
45 
46 }