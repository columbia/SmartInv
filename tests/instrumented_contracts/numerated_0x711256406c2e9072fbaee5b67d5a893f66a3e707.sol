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
47 // Continuous backing with ELIX
48 
49 contract continuousBacking	{
50 
51 // For events, creator and claimee are stored in the events themselves.
52 event CreatedReward(uint256 index,uint256 numAvailable);
53 event ClaimedReward(uint256 index,uint256 totalAmount,uint256 numUnitsDesired,uint256 hostCut,uint256 creatorCut,address backer);
54 event ModifiedNumAvailable(uint256 index,uint256 newNumAvailable);
55 
56 address public ELIX_ADDRESS;
57 uint256 public MAX_HOST_PERCENT;
58 uint256 public HOST_CUT;
59 uint256 public MAX_NUM_AVAIL;
60 
61 struct Reward 	{
62     string title;
63 	address host;
64 	address creator;
65 	uint256 numTaken;
66 	uint256 numAvailable;
67 	uint256 spmPreventionAmt;
68 }
69 
70 function continuousBacking() {
71     MAX_HOST_PERCENT=100000000000000000000;
72     HOST_CUT=5000000000000000000;
73     ELIX_ADDRESS=0xc8C6A31A4A806d3710A7B38b7B296D2fABCCDBA8; 
74     MAX_NUM_AVAIL=10000000;
75 }
76 
77 Reward[] public rewards;
78 
79 function defineReward(string title,address creator,uint256 numAvailable,uint256 minBacking) public	{
80     address host=msg.sender;
81     if (numAvailable>MAX_NUM_AVAIL) revert();
82 	Reward memory newReward=Reward(title,host,creator,0,numAvailable,minBacking);
83 	rewards.push(newReward);
84 	emit CreatedReward(rewards.length-1,numAvailable);
85 }
86 
87 function backAtIndex(uint256 index,uint256 totalAmount,uint256 numUnitsDesired) public	{
88         if (msg.sender==rewards[index].host || msg.sender==rewards[index].creator) revert();
89         if (totalAmount<rewards[index].spmPreventionAmt) revert();
90         if (totalAmount==0) revert();
91         if (rewards[index].numTaken==rewards[index].numAvailable) revert();
92         rewards[index].numTaken+=1;
93         uint256 hostCut;
94 	    uint256 creatorCut;
95         (hostCut, creatorCut) = returnHostAndCreatorCut(totalAmount);
96         
97         if (!token(ELIX_ADDRESS).transferFrom(msg.sender,rewards[index].host,hostCut)) revert(); 
98         if (!token(ELIX_ADDRESS).transferFrom(msg.sender,rewards[index].creator,creatorCut)) revert(); 
99         
100         emit ClaimedReward(index,totalAmount,numUnitsDesired,hostCut,creatorCut,msg.sender);
101 }
102 
103 function reviseNumAvailable(uint256 index,uint256 newNumAvailable) public	{
104 	if (newNumAvailable>MAX_NUM_AVAIL) revert();
105 	if (newNumAvailable<rewards[index].numTaken) revert();
106 	if (msg.sender==rewards[index].creator || msg.sender==rewards[index].host)	{
107 		rewards[index].numAvailable=newNumAvailable;
108 		emit ModifiedNumAvailable(index,newNumAvailable);
109 	}
110 }
111 
112 function returnHostAndCreatorCut(uint256 totalAmount) private returns(uint256, uint256)	{
113 	uint256 hostCut = SafeMath.div( SafeMath.mul(totalAmount, HOST_CUT), MAX_HOST_PERCENT);
114 	uint256 creatorCut = SafeMath.sub(totalAmount, hostCut );
115 	return ( hostCut, creatorCut );
116 }
117 
118 }
119 
120 contract token	{
121 	function transferFrom(address _from,address _to,uint256 _amount) returns (bool success);
122 }