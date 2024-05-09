1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title Pausable
48  * @dev Base contract which allows children to implement an emergency stop mechanism.
49  */
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is not paused.
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is paused.
67    */
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     emit Pause();
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     emit Unpause();
87   }
88 }
89 
90 
91 /// @title BlockchainCuties Presale
92 contract BlockchainCutiesPresale is Pausable
93 {
94 	struct Purchase
95 	{
96 		address owner;
97 		uint32 cutieKind;
98 	}
99 	Purchase[] public purchases;
100 
101 	mapping (uint32 => uint256) public prices;
102 	mapping (uint32 => uint256) public leftCount;
103 
104 	event Bid(address indexed owner, uint32 indexed cutieKind);
105 
106 	function addCutie(uint32 id, uint256 price, uint256 count) public onlyOwner
107 	{
108 		prices[id] = price;
109 		leftCount[id] = count;
110 	}
111 
112 	function isAvailable(uint32 cutieKind) public view returns (bool)
113 	{
114 		return leftCount[cutieKind] > 0;
115 	}
116 
117 	function getPrice(uint32 cutieKind) public view returns (uint256 price, uint256 left)
118 	{
119 		price = prices[cutieKind];
120 		left = leftCount[cutieKind];
121 	}
122 
123 	function bid(uint32 cutieKind) public payable whenNotPaused
124 	{
125 		require(isAvailable(cutieKind));
126 		require(prices[cutieKind] <= msg.value);
127 
128 		purchases.push(Purchase(msg.sender, cutieKind));
129 		leftCount[cutieKind]--;
130 
131 		emit Bid(msg.sender, cutieKind);
132 	}
133 
134 	function purchasesCount() public view returns (uint256)
135 	{
136 		return purchases.length;
137 	}
138 
139     function destroyContract() public onlyOwner {
140         selfdestruct(msg.sender);
141     }
142 
143     function withdraw() public onlyOwner {
144         address(msg.sender).transfer(address(this).balance);
145     }
146 }