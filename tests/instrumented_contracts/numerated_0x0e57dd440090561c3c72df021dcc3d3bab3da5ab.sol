1 pragma solidity ^0.4.0;
2 
3 contract EthBird {
4     
5     address public owner;
6     address highScoreUser;
7     
8     uint currentHighScore = 0;
9     uint256 ownerCommision = 0;
10     uint contestStartTime = now;
11     
12     mapping(address => bool) paidUsers;
13     
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18     
19     function EthBird() public {
20         owner = msg.sender;
21     }
22     
23     function payEntryFee() public payable  {
24         if (msg.value >= 0.001 ether) {
25             paidUsers[msg.sender] = true;
26             ownerCommision = msg.value / 5;
27             address(owner).transfer(ownerCommision);
28         }
29         
30         if(now >= contestEndTime()){
31             awardHighScore();   
32         }
33     }
34 
35     function getCurrentHighscore() public constant returns (uint) {
36         return currentHighScore;
37     }
38     
39     function getCurrentHighscoreUser() public constant returns (address) {
40         return highScoreUser;
41     }
42     
43     function getCurrentJackpot() public constant returns (uint) {
44         return address(this).balance;
45     }
46     
47     function contestEndTime() public constant returns (uint) {
48         return contestStartTime + 3 hours;
49     }
50     
51     function getNextPayoutEstimation() public constant returns (uint) {
52         if(contestEndTime() > now){
53             return contestEndTime() - now;
54         } else {
55             return 0;
56         }
57     }
58     
59     function recordHighScore(uint score, address userToScore)  public onlyOwner {
60         if(paidUsers[userToScore]){
61             if(score > 0 && score >= currentHighScore){
62                 highScoreUser = userToScore;
63                 currentHighScore = score;
64             }
65         }
66     }
67     
68     function awardHighScore() internal {
69         address(highScoreUser).transfer(address(this).balance);
70         contestStartTime = now;
71         currentHighScore = 0;
72         highScoreUser = 0;
73     }
74 }