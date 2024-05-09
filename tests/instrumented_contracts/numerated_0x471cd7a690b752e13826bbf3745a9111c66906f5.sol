1 pragma solidity ^0.4.18;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 contract Ethergarden is Ownable {
91   using SafeMath for uint256;
92 
93   struct Tree {
94     uint256 amount;
95     string name;
96     string url;
97   }
98 
99   event NewTree(uint256 treeId, string name, string url, uint256 amount);
100   event TreeWatered(uint256 treeId, uint256 amount);
101   event TreeCutted(uint256 treeId, uint256 amount);
102   event TreeUpdated(uint256 treeId, string name, string url);
103 
104   Tree[] public forest;
105   mapping (uint256 => address) public treeToOwner;
106   mapping (address => uint256) internal ownerTreeCount;
107 
108   function _createTree(string _name, string _url, uint256 _amount) private {
109     uint256 id = forest.push(Tree(_amount, _name, _url)) - 1;
110     treeToOwner[id] = msg.sender;
111     ownerTreeCount[msg.sender] = ownerTreeCount[msg.sender].add(1);
112 
113     NewTree(id, _name, _url, _amount);
114   }
115 
116   function createTree(string _name, string _url) payable external {
117     require(msg.value >= 0.001 ether);
118 
119     _createTree(_name, _url, msg.value);
120   }
121 
122   function getForestCount() external view returns(uint256) {
123     return forest.length;
124   }
125 
126   function changeTreeAttributes(uint256 _treeId, string _name, string _url) external {
127     require(msg.sender == treeToOwner[_treeId]);
128 
129     Tree storage myTree = forest[_treeId];
130     myTree.name = _name;
131     myTree.url = _url;
132 
133     TreeUpdated(_treeId, myTree.name, myTree.url);
134   }
135 
136   function dagheAcqua(uint256 _treeId) payable external {
137     require(msg.value > 0.0001 ether);
138 
139     Tree storage myTree = forest[_treeId];
140     myTree.amount = myTree.amount.add(msg.value);
141 
142     TreeWatered(_treeId, myTree.amount);
143   }
144 
145   function cut(uint256 _treeId) payable external {
146     require(msg.value > 0.0001 ether);
147 
148     Tree storage myTree = forest[_treeId];
149     myTree.amount = myTree.amount.sub(msg.value);
150 
151     TreeCutted(_treeId, myTree.amount);
152   }
153 
154   function withdraw() external onlyOwner {
155     owner.transfer(this.balance);
156   }
157   // fallback function for getting eth sent directly to the contract address
158   function() public payable {}
159 }