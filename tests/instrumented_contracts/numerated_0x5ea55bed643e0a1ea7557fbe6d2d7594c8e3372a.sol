1 pragma solidity 0.5.14;
2           
3         
4         // thepanther.info
5         
6               
7 /**     
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   /**
36   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a); 
49     return c;
50   }
51 }
52 contract ThePanther {
53     event Multisended(uint256 value , address sender);
54     using SafeMath for uint256;
55 
56     function multisendEther(address payable[]  memory  _contributors, uint256[] memory _balances) public payable {
57         uint256 total = msg.value;
58         uint256 i = 0;
59         for (i; i < _contributors.length; i++) {
60             require(total >= _balances[i] );
61             total = total.sub(_balances[i]);
62             _contributors[i].transfer(_balances[i]);
63         }
64         emit Multisended(msg.value, msg.sender);
65     }
66 }