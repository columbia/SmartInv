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
12   function claimAndWithdraw(address sellToken,address buyToken,address user,uint auctionIndex,uint amount) public;
13   function getAuctionIndex(address token1,address token2) public returns(uint);
14 }
15 
16 interface ERC20 {
17   function transfer(address recipient, uint amount) public returns(bool);
18 }
19 
20 
21 contract DutchReserve {
22   DutchExchange constant DUTCH_EXCHANGE = DutchExchange(0xaf1745c0f8117384Dfa5FFf40f824057c70F2ed3);
23   WETH9 constant WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
24 
25   function DutchReserve() public {
26     require(WETH.approve(DUTCH_EXCHANGE,2**255));
27   }
28 
29   function buyToken(ERC20 token) payable public {
30     uint auctionIndex = DUTCH_EXCHANGE.getAuctionIndex(token,WETH);
31     WETH.deposit.value(msg.value)();
32     DUTCH_EXCHANGE.deposit(WETH, msg.value);
33     uint tokenAmount = DUTCH_EXCHANGE.postBuyOrder(token,WETH,auctionIndex,msg.value);
34     DUTCH_EXCHANGE.claimAndWithdraw(token,WETH,this,auctionIndex,tokenAmount);
35     token.transfer(msg.sender,tokenAmount);
36   }
37 
38 }