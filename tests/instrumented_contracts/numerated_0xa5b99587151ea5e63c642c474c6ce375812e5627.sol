1 pragma solidity ^0.4.0;
2 
3 contract EthBird {
4     
5     address public owner;
6     address highScoreUser;
7     
8     uint currentHighScore = 0;
9     uint contestStartTime = now;
10     
11     mapping(address => bool) paidUsers;
12     
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17     
18     function EthBird() public {
19         owner = msg.sender;
20     }
21     
22     function payEntryFee() public payable  {
23         if (msg.value >= 0.001 ether) {
24             paidUsers[msg.sender] = true;
25         }
26     }
27 
28     function getCurrentHighscore() public constant returns (uint) {
29         return currentHighScore;
30     }
31     
32     function getCurrentHighscoreUser() public constant returns (address) {
33         return highScoreUser;
34     }
35     
36     function getCurrentJackpot() public constant returns (uint) {
37         return address(this).balance;
38     }
39     
40     function getNextPayoutEstimation() public constant returns (uint) {
41         return (contestStartTime + 1 days) - now;
42     }
43     
44     function recordHighScore(uint score, address userToScore)  public onlyOwner returns (address) {
45         if(paidUsers[userToScore]){
46             if(score > 0 && score >= currentHighScore){
47                 highScoreUser = userToScore;
48                 currentHighScore = score;
49             }
50             if(now >= contestStartTime + 1 days){
51                 awardHighScore();   
52             }
53         }
54         return userToScore;
55     }
56     
57     function awardHighScore() public onlyOwner {
58         uint256 ownerCommision = address(this).balance / 10;
59         address(owner).transfer(ownerCommision);
60         address(highScoreUser).transfer(address(this).balance);
61         contestStartTime = now;
62     }
63 }