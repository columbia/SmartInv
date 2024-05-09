1 pragma solidity ^0.4.25;
2 
3 contract Voting{
4     address owner;
5     mapping (uint256=>uint256) totalVoting;
6     
7     event ChangeOwner(address owner);
8     event Voting(uint256 videoNum, uint256 totalVoting);
9     
10     constructor() public{
11         owner = msg.sender;
12     }
13     
14     modifier onlyOwner(){
15         require(msg.sender == owner);
16         _;
17     }
18     
19     function changeOwner(address _owner) public onlyOwner returns(bool){
20         owner = _owner;
21         emit ChangeOwner(owner);
22         return true;
23     }
24     
25     function likeVoting(uint256 videoNum) public onlyOwner returns(bool){
26         totalVoting[videoNum] = totalVoting[videoNum] + 1;
27         Voting(videoNum, totalVoting[videoNum]);
28         return true;
29     }
30 
31     function starVoting(uint256 videoNum, uint8 star) public onlyOwner returns(bool) {
32         if(star > 0 && star < 6){
33             totalVoting[videoNum] = totalVoting[videoNum] + star;
34             Voting(videoNum, totalVoting[videoNum]);
35             return true;
36         }else{
37             return false;
38         }
39     }
40 
41     function voteVoting(uint256 videoNum) onlyOwner public returns(bool){
42         totalVoting[videoNum] = totalVoting[videoNum] + 3;
43         Voting(videoNum, totalVoting[videoNum]);
44         return true;
45     }
46     
47     function getVotingData(uint256 videoNum) public view returns(uint256){
48         return totalVoting[videoNum];
49     }
50 }