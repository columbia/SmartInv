1 pragma solidity ^0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 contract MultiEthSender {
55 
56     using SafeMath for uint256;
57 
58     event Send(uint256 _amount, address indexed _receiver);
59 
60     modifier enoughBalance(uint256 amount, address[] list) {
61         uint256 totalAmount = amount.mul(list.length);
62         require(address(this).balance >= totalAmount);
63         _;
64     }
65 
66     constructor() public {
67 
68     }
69 
70     function () public payable {
71         require(msg.value >= 0);
72     }
73 
74     function multiSendEth(uint256 amount, address[] list)
75     enoughBalance(amount, list)
76     public
77     returns (bool) 
78     {
79         for (uint256 i = 0; i < list.length; i++) {
80             address(list[i]).transfer(amount);
81             emit Send(amount, address(list[i]));
82         }
83         return true;
84     }
85 }