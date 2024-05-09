1 pragma solidity ^0.4.25;
2 
3 /**
4 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT  4% DAILY
5 *
6 * How to invest?
7 * Send any sum to smart contract address.
8 * The minimum investment amount is 0.01 ETH 
9 * The recommended gas limit is 200000 
10 * The contract remembers the address of your wallet, as well as the amount and time of a deposit. 
11 * Every 24 hours after the deposit you have 4% of the amount invested by you.
12 * You can receive a payment at any time by sending 0 ETH to the address of the contract. 
13 * 
14 *  Web          - http://easyethprofit.org
15 *  Telegram_chat: https://t.me/EasyEthProfit
16 */
17 
18 contract EasyEthProfit{
19     mapping (address => uint256) invested;
20     mapping (address => uint256) dateInvest;
21     uint constant public FEE = 4;
22     uint constant public ADMIN_FEE = 10;
23     address private adminAddr;
24     
25     constructor() public{
26         adminAddr = msg.sender;
27     }
28 
29     function () external payable {
30         address sender = msg.sender;
31         
32         if (invested[sender] != 0) {
33             uint256 amount = getInvestorDividend(sender);
34             if (amount >= address(this).balance){
35                 amount = address(this).balance;
36             }
37             sender.send(amount);
38         }
39 
40         dateInvest[sender] = now;
41         invested[sender] += msg.value;
42 
43         if (msg.value > 0){
44             adminAddr.send(msg.value * ADMIN_FEE / 100);
45         }
46     }
47     
48     function getInvestorDividend(address addr) public view returns(uint256) {
49         return invested[addr] * FEE / 100 * (now - dateInvest[addr]) / 1 days;
50     }
51 
52 }