1 pragma solidity ^0.4.23;
2 
3 contract Ethervote {
4     
5     address feeRecieverOne = 0xa03F27587883135DA9565e7EfB523e1657A47a07;
6     address feeRecieverTwo = 0x549377418b1b7030381de9aA1319E41C044467c7;
7 
8     address[] playerAddresses;
9     
10     uint public expiryBlock;
11     
12     uint public leftSharePrice = 10 finney;
13     uint public rightSharePrice = 10 finney;
14     
15     uint public leftSharePriceRateOfIncrease = 1 finney;
16     uint public rightSharePriceRateOfIncrease = 1 finney;
17     
18     uint public leftVotes = 0;
19     uint public rightVotes = 0;
20     
21     uint public thePot = 0 wei;
22     
23     bool public betIsSettled = false;
24 
25     struct Player {
26         uint leftShares;
27         uint rightShares;
28         uint excessEther;
29         bool hasBetBefore;
30     }
31     
32     mapping(address => Player) players;
33     
34     
35     constructor() public {
36         expiryBlock = block.number + 17500;
37     }
38     
39     function bet(bool bettingLeft) public payable {
40         
41         require(block.number < expiryBlock);
42         
43         if(!players[msg.sender].hasBetBefore){
44             playerAddresses.push(msg.sender);
45             players[msg.sender].hasBetBefore = true;
46         }
47             
48             uint amountSent = msg.value;
49             
50             if(bettingLeft){
51                 require(amountSent >= leftSharePrice);
52                 
53                 while(amountSent >= leftSharePrice){
54                     players[msg.sender].leftShares++;
55                     leftVotes++;
56                     thePot += leftSharePrice;
57                     amountSent -= leftSharePrice;
58                     
59                     if((leftVotes % 15) == 0){//if the number of left votes is a multiple of 15
60                         leftSharePrice += leftSharePriceRateOfIncrease;
61                         if(leftVotes <= 45){//increase the rate at first, then decrease it to zero.
62                             leftSharePriceRateOfIncrease += 1 finney;
63                         }else if(leftVotes > 45){
64                             if(leftSharePriceRateOfIncrease > 1 finney){
65                                 leftSharePriceRateOfIncrease -= 1 finney;
66                             }else if(leftSharePriceRateOfIncrease <= 1 finney){
67                                 leftSharePriceRateOfIncrease = 0 finney;
68                             }
69                         }
70                     }
71                     
72                 }
73                 if(amountSent > 0){
74                     players[msg.sender].excessEther += amountSent;
75                 }
76                 
77             }
78             else{//betting for the right option
79                 require(amountSent >= rightSharePrice);
80                 
81                 while(amountSent >= rightSharePrice){
82                     players[msg.sender].rightShares++;
83                     rightVotes++;
84                     thePot += rightSharePrice;
85                     amountSent -= rightSharePrice;
86                     
87                     if((rightVotes % 15) == 0){//if the number of right votes is a multiple of 15
88                         rightSharePrice += rightSharePriceRateOfIncrease;
89                         if(rightVotes <= 45){//increase the rate at first, then decrease it to zero.
90                             rightSharePriceRateOfIncrease += 1 finney;
91                         }else if(rightVotes > 45){
92                             if(rightSharePriceRateOfIncrease > 1 finney){
93                                 rightSharePriceRateOfIncrease -= 1 finney;
94                             }else if(rightSharePriceRateOfIncrease <= 1 finney){
95                                 rightSharePriceRateOfIncrease = 0 finney;
96                             }
97                         }
98                     }
99                     
100                 }
101                 if(amountSent > 0){
102                     if(msg.sender.send(amountSent) == false)players[msg.sender].excessEther += amountSent;
103                 }
104             }
105     }
106     
107     
108     function settleBet() public {
109         require(block.number >= expiryBlock);
110         require(betIsSettled == false);
111 
112         uint winRewardOne = thePot * 2;
113         winRewardOne = winRewardOne / 20;
114         if(feeRecieverOne.send(winRewardOne) == false) players[feeRecieverOne].excessEther = winRewardOne;//in case the tx fails, the excess ether function lets you withdraw it manually
115 
116         uint winRewardTwo = thePot * 1;
117         winRewardTwo = winRewardTwo / 20;
118         if(feeRecieverTwo.send(winRewardTwo) == false) players[feeRecieverTwo].excessEther = winRewardTwo;
119 
120         uint winReward = thePot * 17;
121         winReward = winReward / 20;
122         
123         if(leftVotes > rightVotes){
124             winReward = winReward / leftVotes;
125             for(uint i=0;i<playerAddresses.length;i++){
126                 if(players[playerAddresses[i]].leftShares > 0){
127                     if(playerAddresses[i].send(players[playerAddresses[i]].leftShares * winReward) == false){
128                         //if the send fails
129                         players[playerAddresses[i]].excessEther = players[playerAddresses[i]].leftShares * winReward;
130                     }
131                 }
132             }
133         }else if(rightVotes > leftVotes){
134             winReward = winReward / rightVotes;
135             for(uint u=0;u<playerAddresses.length;u++){
136                 if(players[playerAddresses[u]].rightShares > 0){
137                     if(playerAddresses[u].send(players[playerAddresses[u]].rightShares * winReward) == false){
138                         //if the send fails
139                         players[playerAddresses[u]].excessEther = players[playerAddresses[u]].rightShares * winReward;
140                     }
141                 }
142             }
143         }else if(rightVotes == leftVotes){//split it in a tie
144             uint rightWinReward = (winReward / rightVotes) / 2;
145             for(uint q=0;q<playerAddresses.length;q++){
146                 if(players[playerAddresses[q]].rightShares > 0){
147                     if(playerAddresses[q].send(players[playerAddresses[q]].rightShares * rightWinReward) == false){
148                         //if the send fails
149                         players[playerAddresses[q]].excessEther = players[playerAddresses[q]].rightShares * rightWinReward;
150                     }
151                 }
152             }
153 
154             uint leftWinReward = winReward / leftVotes;
155             for(uint l=0;l<playerAddresses.length;l++){
156                 if(players[playerAddresses[l]].leftShares > 0){
157                     if(playerAddresses[l].send(players[playerAddresses[l]].leftShares * leftWinReward) == false){
158                         //if the send fails
159                         players[playerAddresses[l]].excessEther = players[playerAddresses[l]].leftShares * leftWinReward;
160                     }
161                 }
162             }
163 
164         }
165 
166         betIsSettled = true;
167     }
168     
169     
170     function retrieveExcessEther() public {
171         assert(players[msg.sender].excessEther > 0);
172         if(msg.sender.send(players[msg.sender].excessEther)){
173             players[msg.sender].excessEther = 0;
174         }
175     }
176     
177     function viewMyShares(bool left) public view returns(uint){
178         if(left)return players[msg.sender].leftShares;
179         return players[msg.sender].rightShares;
180     }
181 }