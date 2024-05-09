1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two unsigned integers, reverts on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two unsigned integers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 contract ERC20Basic {
64     function totalSupply() public view returns (uint256);
65     function balanceOf(address who) public view returns (uint256);
66     function transfer(address to, uint256 value) public returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 contract ERC20 is ERC20Basic {
70     function allowance(address owner, address spender) public view returns (uint256);
71     function transferFrom(address from, address to, uint256 value) public returns (bool);
72     function approve(address spender, uint256 value) public returns (bool);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 contract MultiSendErc20 {
77     using SafeMath for uint256;
78     function multisendToken(address token, address[] memory _contributors, uint256[] memory _balances) public {
79         ERC20 erc20token = ERC20(token);
80         uint8 i = 0;
81 
82         for (i; i < _balances.length; i++) {
83             erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
84         }
85     }
86     
87     function sendToken(address token, address _contributor, uint256 _balance) public {
88         ERC20 erc20token = ERC20(token);
89         erc20token.transferFrom(msg.sender, _contributor, _balance);
90     
91     }
92 }