1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 // Continuous backing with Ether
48 
49 contract continuousBacking	{
50 
51 event CreatedReward(uint256 index,uint256 numAvailable);
52 event ClaimedReward(uint256 index,uint256 totalAmount,uint256 numUnitsDesired,uint256 hostCut,uint256 creatorCut,address backer);
53 event ModifiedNumAvailable(uint256 index,uint256 newNumAvailable);
54 
55 uint256 public MAX_HOST_PERCENT;
56 uint256 public HOST_CUT;
57 uint256 public MAX_NUM_AVAIL;
58 
59 struct Reward 	{
60     string title;
61 	address host;
62 	address creator;
63 	uint256 numTaken;
64 	uint256 numAvailable;
65 	uint256 spmPreventionAmt;
66 }
67 
68 function continuousBacking() {
69 	MAX_HOST_PERCENT=100000000000000000000;
70     HOST_CUT=5000000000000000000;
71 }
72 
73 Reward[] public rewards;
74 
75 function defineReward(string title,address creator,uint256 numAvailable,uint256 minBacking) public	{
76     address host=msg.sender;
77 	Reward memory newReward=Reward(title,host,creator,0,numAvailable,minBacking);
78 	rewards.push(newReward);
79 	emit CreatedReward(rewards.length-1,numAvailable);
80 }
81 
82 function backAtIndex(uint256 index,uint256 numUnitsDesired) public payable	{
83         uint256 totalAmount=msg.value;
84 		if (msg.sender==rewards[index].host || msg.sender==rewards[index].creator) revert();
85 		if (totalAmount<rewards[index].spmPreventionAmt) revert();
86         if (totalAmount==0) revert();
87         if (rewards[index].numTaken==rewards[index].numAvailable) revert();
88         rewards[index].numTaken+=1;
89         address host=rewards[index].host;
90         address creator=rewards[index].creator;
91         
92     	uint256 hostCut;
93 	    uint256 creatorCut;
94         (hostCut, creatorCut) = returnHostAndCreatorCut(totalAmount);
95         
96         host.transfer(hostCut);
97         creator.transfer(creatorCut);
98         
99         emit ClaimedReward(index,totalAmount,numUnitsDesired,hostCut,creatorCut,msg.sender);
100 }
101 
102 function reviseNumAvailable(uint256 index,uint256 newNumAvailable) public	{
103 	if (newNumAvailable>MAX_NUM_AVAIL) revert();
104 	if (newNumAvailable<rewards[index].numTaken) revert();
105 	if (msg.sender==rewards[index].host || msg.sender==rewards[index].creator)	{
106 		rewards[index].numAvailable=newNumAvailable;
107 		emit ModifiedNumAvailable(index,newNumAvailable);
108 	}
109 }
110 
111 function returnHostAndCreatorCut(uint256 totalAmount) private returns(uint256, uint256)	{
112 	uint256 hostCut = SafeMath.div( SafeMath.mul(totalAmount, HOST_CUT), MAX_HOST_PERCENT);
113 	uint256 creatorCut = SafeMath.sub(totalAmount, hostCut );
114 	return ( hostCut, creatorCut );
115 }
116 }