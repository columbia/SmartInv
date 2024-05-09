1 pragma solidity ^0.4.23;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5     function balanceOf(address tokenOwner) constant external returns (uint balance);
6 }
7 
8 contract DeflatLottoBurn {
9 
10   string public name = "DEFLAT LOTTO INVEST";
11   string public symbol = "DEFTLI";
12   string public prob = "Probability 1 of 10";
13   string public comment = "Send 0.002 ETH to burn DEFLAT and try to win 0.018 ETH (-gas), the prize is drawn when the accumulated balance reaches 0.02 ETH";
14 
15   //Send only 0.002 ether, other value will be rejected;
16   //Bids below 0.002 ether generate very low DEFLAT returns when calling the sales contract due to the gas cost, so this is the minimum feasible bid.
17   //Tokens moved from source on first bid and burn on last;
18 
19   address[] internal playerPool;
20   address public maincontract = address(0xe36584509F808f865BE1960aA459Ab428fA7A25b); //DEFLAT SALE CONTRACT;
21   address public burncontract = address(0x731468ca17848717CdcBf2ddc0b8301f270b6D36);// BURN FROM LOTTO CONTRACT
22   token public tokenReward = token(0xe1E0DB951844E7fb727574D7dACa68d1C5D1525b);// DEFLAT COIN CONTRACT;
23   uint rounds = 10;
24   uint quota = 0.002 ether;
25   event Payout(address from, address to, uint quantity);
26   function () public payable {
27     require(msg.value == quota);
28     playerPool.push(msg.sender);
29     if (playerPool.length >= rounds) {
30       uint baserand = (block.number-1)+now+block.difficulty;
31       uint winidx = uint(baserand)/10;
32       winidx = baserand - (winidx*10);   
33       address winner = playerPool[winidx];
34       uint amount = address(this).balance;
35       if (winner.send(amount)) { emit Payout(this, winner, amount);}
36       if (tokenReward.balanceOf(address(this)) > 0) {tokenReward.transfer(burncontract, tokenReward.balanceOf(address(this)));}
37       playerPool.length = 0;                
38     } 
39     else {
40        if (playerPool.length == 1) {
41            if (maincontract.call.gas(200000).value(address(this).balance)()) { emit Payout(this, maincontract, quota);}           
42        }
43     } 
44   }
45 }