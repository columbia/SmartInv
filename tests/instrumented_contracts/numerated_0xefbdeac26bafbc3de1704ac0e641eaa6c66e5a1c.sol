1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 // ----------------------------------------------------------------------------
37 // Owned contract
38 // ----------------------------------------------------------------------------
39 contract Owned {
40     address public owner;
41     address public newOwner;
42 
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         newOwner = _newOwner;
56     }
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 }
64 
65 contract Token{
66     function transferFrom(address from, address to, uint tokens) public returns (bool success);
67     function balanceOf(address tokenOwner) public view returns (uint balance);
68 }
69 
70 
71 /**
72  * @title token token initial distribution
73  *
74  * @dev Distribute purchasers, airdrop, reserve, and founder tokens
75  */
76 contract Airdrop is Owned {
77   using SafeMath for uint256;
78   Token public token;
79   uint256 private constant decimalFactor = 10**uint256(18);
80   // Keeps track of whether or not a token airdrop has been made to a particular address
81   mapping (address => bool) public airdrops;
82   
83   /**
84     * @dev Constructor function - Set the token token address
85   */
86   constructor(address _tokenContractAdd, address _owner) public {
87     // takes an address of the existing token contract as parameter
88     token = Token(_tokenContractAdd);
89     owner = _owner;
90   }
91   
92   /**
93     * @dev perform a transfer of allocations
94     * @param _recipient is a list of recipients
95     */
96   function airdropTokens(address[] _recipient, uint256[] _tokens) external onlyOwner{
97     for(uint256 i = 0; i< _recipient.length; i++)
98     {
99         uint256 tokens = token.balanceOf(_recipient[i]);
100         if ((!airdrops[_recipient[i]]) && ( tokens == 0)) {
101           airdrops[_recipient[i]] = true;
102           require(token.transferFrom(msg.sender, _recipient[i], _tokens[i] * decimalFactor));
103         }
104     }
105   }
106 }