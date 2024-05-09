1 pragma solidity ^0.4.25;
2 
3 contract Voting{
4     address owner;
5     event Voting(uint256 videoNum, uint256 totalVoting);
6     event ChangeOwner(address owner);
7     
8     mapping (uint256=>uint256) totalVoting;
9     
10     constructor(){
11         owner = msg.sender;
12     }
13     
14     modifier onlyOwner(){
15         require(msg.sender == owner);
16         _;
17     }
18     
19     function changeOwner(address _owner) onlyOwner returns(bool){
20         owner = _owner;
21         emit ChangeOwner(_owner);
22         return true;
23     }
24     
25     function likeVoting(uint256 videoNum) onlyOwner returns(bool){
26         totalVoting[videoNum] = totalVoting[videoNum] + 1;
27         emit Voting(videoNum, totalVoting[videoNum]);
28         return true;
29     }
30 
31     function starVoting(uint256 videoNum, uint8 star) onlyOwner returns(bool) {
32         if(star > 0 && star < 6){
33             totalVoting[videoNum] = totalVoting[videoNum] + star;
34             emit Voting(videoNum, totalVoting[videoNum]);
35             return true;
36         }else{
37             return false;
38         }
39     }
40 
41     function voteVoting(uint256[] videoNum, uint256[] count) onlyOwner returns(bool){
42         for(uint i=0; i< videoNum.length; i++){
43             totalVoting[videoNum[i]] = totalVoting[videoNum[i]] + (3 * count[i]);
44             emit Voting(videoNum[i], totalVoting[videoNum[i]]);
45         }
46         return true;
47     }
48     
49     function getVotingData(uint256 videoNum) returns(uint256){
50         return totalVoting[videoNum];
51     }
52 }