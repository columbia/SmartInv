1 pragma solidity 0.4.23;
2 
3 // Random lottery
4 // Smart contracts can't bet
5 
6 // Pay 0.001 to get a random number
7 // If your random number is the highest so far you're in the lead
8 // If no one beats you in 1 day you can claim your winnnings - the entire balance.
9 
10 contract RandoLotto {
11     
12     uint256 PrizePool;
13     uint256 highScore;
14     address currentWinner;
15     uint256 lastTimestamp;
16     
17     constructor () public {
18         highScore = 0;
19         currentWinner = msg.sender;
20         lastTimestamp = now;
21     }
22     
23     function () public payable {
24         require(msg.sender == tx.origin);
25         require(msg.value >= 0.001 ether);
26     
27         uint256 randomNumber = uint256(keccak256(blockhash(block.number - 1)));
28         
29         if (randomNumber > highScore) {
30             currentWinner = msg.sender;
31             lastTimestamp = now;
32         }
33     }
34     
35     function claimWinnings() public {
36         require(now > lastTimestamp + 1 days);
37         require(msg.sender == currentWinner);
38         
39         msg.sender.transfer(address(this).balance);
40     }
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49     /**
50     * @dev Multiplies two numbers, throws on overflow.
51     */
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         assert(c / a == b);
58         return c;
59     }
60 
61     /**
62     * @dev Integer division of two numbers, truncating the quotient.
63     */
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         // assert(b > 0); // Solidity automatically throws when dividing by 0
66         uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68         return c;
69     }
70 
71     /**
72     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73     */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         assert(b <= a);
76         return a - b;
77     }
78 
79     /**
80     * @dev Adds two numbers, throws on overflow.
81     */
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         assert(c >= a);
85         return c;
86     }
87 }