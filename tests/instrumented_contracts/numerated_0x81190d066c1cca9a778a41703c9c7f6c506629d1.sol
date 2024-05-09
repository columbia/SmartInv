1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 //Submit ETH to show how big your "Eth penis" is. Each submission
50 //bigger than the prior is awarded 20% of the original added to
51 //their ETH amount. The biggest previous submitter gets 80% of
52 //their original submission back. The biggest ETH dick for 1 day
53 //wins the total accrued balance. During cashout the creator gets
54 //1% and the winner gets the rest. The winner can be paid and the
55 //game reset by calling "Withdraw()".
56 contract EthDickMeasuringGamev3 {
57     address owner;
58     address public largestPenisOwner;
59     uint256 public largestPenis;
60     uint256 public withdrawDate;
61 
62     function EthDickMeasuringGamev3() public{
63         owner = msg.sender;
64         largestPenisOwner = 0;
65         largestPenis = 0;
66     }
67 
68     function () public payable{
69         require(largestPenis < msg.value);
70         address prevOwner = largestPenisOwner;
71         uint256 prevSize = largestPenis;
72         
73         largestPenisOwner = msg.sender;
74         largestPenis = msg.value;
75         withdrawDate = 1 days;
76         
77         //Verify this isn't a new round. Then
78         //send back eth to smaller penis submission
79         if(prevOwner != 0x0)
80             prevOwner.transfer(SafeMath.div(SafeMath.mul(prevSize, 80),100));
81 
82     }
83 
84     function withdraw() public{
85         require(now >= withdrawDate);
86         address roundWinner = largestPenisOwner;
87 
88         //Reset game
89         largestPenis = 0;
90         largestPenisOwner = 0;
91 
92         //Judging penises isn't a fun job
93         //taking my 1% from the total prize.
94         owner.transfer(SafeMath.div(SafeMath.mul(this.balance, 1),100));
95         
96         //Congratulation on your giant penis
97         roundWinner.transfer(this.balance);
98     }
99 }