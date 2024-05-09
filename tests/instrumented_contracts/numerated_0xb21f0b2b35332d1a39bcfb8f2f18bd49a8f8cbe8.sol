1 pragma solidity 0.4.24;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a); 
47     return c;
48   }
49 }
50 contract SendEtherContributors {
51     event Multisended(uint256 value , address sender);
52     using SafeMath for uint256;
53 
54     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
55         uint256 total = msg.value;
56         uint256 i = 0;
57         for (i; i < _contributors.length; i++) {
58             require(total >= _balances[i] );
59             total = total.sub(_balances[i]);
60             _contributors[i].transfer(_balances[i]);
61         }
62         emit Multisended(msg.value, msg.sender);
63     }
64 }