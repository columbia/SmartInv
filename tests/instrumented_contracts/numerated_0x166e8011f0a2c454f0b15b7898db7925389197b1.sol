1 pragma solidity ^0.4.23;
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
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
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
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 //-------------------------------------------------------------------------------------------------
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipRenounced(address indexed previousOwner);
61   event OwnershipTransferred(
62     address indexed previousOwner,
63     address indexed newOwner
64   );
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   constructor() public {
72     owner = msg.sender;
73   }
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) public onlyOwner {
88     require(newOwner != address(0));
89     emit OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 
93   /**
94    * @dev Allows the current owner to relinquish control of the contract.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 }
101 
102 //-------------------------------------------------------------------------------------------------
103 
104 contract AifiAsset is Ownable {
105   using SafeMath for uint256;
106 
107   enum AssetState { Pending, Active, Expired }
108   string public assetType;
109   uint256 public totalSupply;
110   AssetState public state;
111 
112   constructor() public {
113     state = AssetState.Pending;
114   }
115 
116   function setState(AssetState _state) public onlyOwner {
117     state = _state;
118     emit SetStateEvent(_state);
119   }
120 
121   event SetStateEvent(AssetState indexed state);
122 }
123 
124 //-------------------------------------------------------------------------------------------------
125 
126 contract InitAifiAsset is AifiAsset {
127   string public assetType = "DEBT";
128   uint public initialSupply = 1000 * 10 ** 18;
129   string[] public subjectMatters;
130   
131   constructor() public {
132     totalSupply = initialSupply;
133   }
134 
135   function addSubjectMatter(string _subjectMatter) public onlyOwner {
136     subjectMatters.push(_subjectMatter);
137   }
138 
139   function updateSubjectMatter(uint _index, string _subjectMatter) public onlyOwner {
140     require(_index <= subjectMatters.length);
141     subjectMatters[_index] = _subjectMatter;
142   }
143 
144   function getSubjectMattersSize() public view returns(uint) {
145     return subjectMatters.length;
146   }
147 }