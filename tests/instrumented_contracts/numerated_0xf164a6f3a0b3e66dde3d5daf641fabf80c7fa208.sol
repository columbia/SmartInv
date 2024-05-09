1 pragma solidity 0.5.0;
2 
3 contract AbstractAzimuth {
4    function ownerOf(uint256 pointNum) public view returns(address);
5 }
6 
7 contract Reputation {
8     
9     address azimuthAddress = 0x6ac07B7C4601B5CE11de8Dfe6335B871C7C4dd4d;
10     
11     enum Score { Negative, Neutral, Positive }
12     event LogReputationFact(uint256, uint256, uint, string fact);
13     
14     //  validPointId(): require that _id is a valid point
15     //
16     modifier validPointId(uint256 _id)
17     {
18       require(_id < 0x100000000);
19       _;
20     }
21     
22     function checkOwner(uint256 pointNum)
23     public view
24     validPointId(pointNum)
25     returns(address owner) {
26       AbstractAzimuth azimuth = AbstractAzimuth(azimuthAddress);
27       return azimuth.ownerOf(pointNum);
28     }
29 
30     function appendNegative(uint256 pointNum, uint256 repNum, string memory fact)
31     public {
32       address owner = checkOwner(pointNum);
33       //require(owner == msg.sender);
34       Score score = Score.Negative;
35       emit LogReputationFact(pointNum, repNum, uint(score), fact);
36     }
37 
38     function appendNeutral(uint256 pointNum, uint256 repNum, string memory fact)
39     public {
40       address owner = checkOwner(pointNum);
41       //require(owner == msg.sender);
42       Score score = Score.Neutral;
43       emit LogReputationFact(pointNum, repNum, uint(score), fact);
44     }
45 
46     function appendPositive(uint256 pointNum, uint256 repNum, string memory fact)
47     public {
48       address owner = checkOwner(pointNum);
49       //require(owner == msg.sender);
50       Score score = Score.Positive;
51       emit LogReputationFact(pointNum, repNum, uint(score), fact);
52     }
53 
54 }