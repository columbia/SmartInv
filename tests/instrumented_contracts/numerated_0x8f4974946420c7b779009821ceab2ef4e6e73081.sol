1 pragma solidity ^0.4.24;
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
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 
56 
57 /** 
58  * @title IndexConsumer
59  * @dev This contract adds an autoincrementing index to contracts. 
60  */
61 contract IndexConsumer {
62 
63     using SafeMath for uint256;
64 
65     /** The index */
66     uint256 private freshIndex = 0;
67 
68     /** Fetch the next index */
69     function nextIndex() internal returns (uint256) {
70         uint256 theIndex = freshIndex;
71         freshIndex = freshIndex.add(1);
72         return theIndex;
73     }
74 
75 }
76 
77 
78 /**
79  * @title CapTables
80  * @dev The sole purpose of this contract is to store the cap tables of securities
81  * created by the OFN system.  We take the position that a security is defined
82  * by its cap table and not by its transfer rules.  So a security is
83  * represented by a unique integer index.  A security has a fixed amount and we
84  * preserve this invariant by allowing no other cap table updates beside
85  * transfers.
86  */
87 contract CapTables is IndexConsumer {
88     using SafeMath for uint256;
89 
90     /** Address of security */
91     mapping(uint256 => address) public addresses;
92     mapping(address => uint) private indexes;
93 
94     /** `capTable(security, user) == userBalance` */
95     mapping(uint256 => mapping(address => uint256)) public capTable;
96 
97     /** Total token supplies */
98     mapping(uint256 => uint256) public totalSupply;
99 
100     /* EVENTS */
101 
102     
103 
104     event NewSecurity(uint256 security);
105     event SecurityMigration(uint256 security, address newAddress);
106 
107     modifier onlySecurity(uint256 security) {  
108         require(
109             msg.sender == addresses[security], 
110             "this method MUST be called by the security's control account"
111         );
112         _;
113     }
114 
115     /** @dev retrieve the balance at a given address */
116     function balanceOf(uint256 security, address user) public view returns (uint256) {
117         return capTable[security][user];
118     }
119 
120     /** @dev Add a security to the contract. */
121     function initialize(uint256 supply, address manager) public returns (uint256) {
122         uint256 index = nextIndex();
123         addresses[index] = manager;
124         capTable[index][manager] = supply;
125         totalSupply[index] = supply;
126         indexes[manager] = index;
127         emit NewSecurity(index);
128         return index;
129     }
130 
131 
132     /** @dev Migrate a security to a new address, if its transfer restriction rules change. */
133     function migrate(uint256 security, address newAddress) public onlySecurity(security) {
134         addresses[security] = newAddress;
135         emit SecurityMigration(security, newAddress);
136     }
137 
138     /** @dev Transfer an amount of security. */
139     function transfer(uint256 security, address src, address dest, uint256 amount) 
140         public 
141         onlySecurity(security) 
142     {
143         capTable[security][src] = capTable[security][src].sub(amount);
144         capTable[security][dest] = capTable[security][dest].add(amount);
145     }
146 }