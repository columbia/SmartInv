1 pragma solidity ^0.4.23;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5     function balanceOf(address tokenOwner) constant external returns (uint balance);
6 }
7 
8 contract DeflatLottoInvest {
9 
10   string public name = "DEFLAT LOTTO INVEST";
11   string public symbol = "DEFTLI";
12   string public prob = "Probability 1 of 10";
13   string public comment = "Send 0.002 ETH to captalize DEFLAT and try to win 0.018 ETH, the prize is drawn when the accumulated balance reaches 0.02 ETH";
14 
15   //Send only 0.002 ether, other value will be rejected;
16   //Bids below 0.002 ether generate very low DEFLAT returns when calling the sales contract due to the gas cost, so this is the minimum feasible bid.
17 
18   address[] internal playerPool;
19   address public maincontract = address(0xe36584509F808f865BE1960aA459Ab428fA7A25b); //DEFLAT SALE CONTRACT;
20   token public tokenReward = token(0xe1E0DB951844E7fb727574D7dACa68d1C5D1525b);// DEFLAT COIN CONTRACT;
21   uint rounds = 10;
22   uint quota = 0.002 ether;
23   uint reward;
24   event Payout(address from, address to, uint quantity);
25   function () public payable {
26     require(msg.value == quota);
27     playerPool.push(msg.sender);
28     if (playerPool.length >= rounds) {
29       uint baserand = (block.number-1)+now+block.difficulty;
30       uint winidx = uint(baserand)/10;
31       winidx = baserand - (winidx*10);   
32       address winner = playerPool[winidx];
33       uint amount = address(this).balance;
34       if (winner.send(amount)) { emit Payout(this, winner, amount);}
35       reward = tokenReward.balanceOf(address(this))/((rounds+1)-playerPool.length);    
36       if (reward > 0) { tokenReward.transfer(msg.sender, reward);}   
37       playerPool.length = 0;                
38     } 
39     else {
40        if (playerPool.length == 1) {
41            if (maincontract.call.gas(200000).value(address(this).balance)()) { emit Payout(this, maincontract, quota);}
42        }
43        reward = tokenReward.balanceOf(address(this))/((rounds+1)-playerPool.length);    
44        if (reward > 0) { tokenReward.transfer(msg.sender, reward); }
45     } 
46   }
47 }