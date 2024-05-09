1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract WhiteListRegistry is Ownable {
81 
82     mapping (address => WhiteListInfo) public whitelist;
83     using SafeMath for uint;
84 
85     struct WhiteListInfo {
86         bool whiteListed;
87         uint minCap;
88         uint maxCap;
89     }
90 
91     event AddedToWhiteList(
92         address contributor,
93         uint minCap,
94         uint maxCap
95     );
96 
97     event RemovedFromWhiteList(
98         address _contributor
99     );
100 
101     function addToWhiteList(address _contributor, uint _minCap, uint _maxCap) public onlyOwner {
102         require(_contributor != address(0));
103         whitelist[_contributor] = WhiteListInfo(true, _minCap, _maxCap);
104         AddedToWhiteList(_contributor, _minCap, _maxCap);
105     }
106 
107     function removeFromWhiteList(address _contributor) public onlyOwner {
108         require(_contributor != address(0));
109         delete whitelist[_contributor];
110         RemovedFromWhiteList(_contributor);
111     }
112 
113     function isWhiteListed(address _contributor) public view returns(bool) {
114         return whitelist[_contributor].whiteListed;
115     }
116 
117     function isAmountAllowed(address _contributor, uint _amount) public view returns(bool) {
118        return whitelist[_contributor].maxCap >= _amount && whitelist[_contributor].minCap <= _amount && isWhiteListed(_contributor);
119     }
120 
121 }