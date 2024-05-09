1 pragma solidity ^0.4.21;
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
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
49 
50 contract batchTransfer {
51     using SafeMath for uint256;
52     
53     uint public totalEther;
54     
55     function batchTransfer() public {
56         totalEther = 0;
57     }
58     
59     function distribute(address[] myAddresses) public payable {
60             require(myAddresses.length>0);
61             
62             uint256 value = msg.value;
63             uint256 length = myAddresses.length;
64             uint256 distr = value.div(length);
65             
66             if(length==1)
67             {
68                myAddresses[0].transfer(value);
69             }else
70             {
71                 for(uint256 i=0;i<(length.sub(1));i++)
72                 {
73                     myAddresses[i].transfer(distr);
74                     value = value.sub(distr);
75                 }
76                 myAddresses[myAddresses.length-1].transfer(value);
77             }
78             
79             totalEther = totalEther.add(msg.value);
80     }
81 }