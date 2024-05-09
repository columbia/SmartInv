1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   /**
17   * @dev Integer division of two numbers, truncating the quotient.
18   */
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   /**
27   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28   */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   /**
35   * @dev Adds two numbers, throws on overflow.
36   */
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 contract CryptoScams {
45   using SafeMath for uint256;  
46   event Bought (uint256 indexed _scamId, address indexed _owner, uint256 _price);
47   event Sold (uint256 indexed _scamId, address indexed _owner, uint256 _price);  
48   address public owner;
49   uint256[] private scams; 
50   mapping (uint256 => uint256) private startingPriceOfScam;
51   mapping (uint256 => uint256) private priceOfScam;
52   mapping (uint256 => address) private ownerOfScam;
53   mapping (uint256 => string) private nameOfScam;
54   uint256 cutPercent = 5;
55 
56   function CryptoScams () public {
57     owner = msg.sender;
58   }
59 
60   modifier onlyOwner() {
61     require(owner == msg.sender);
62     _;
63   }
64   
65   function setCut (uint256 _n) onlyOwner() public {
66 	  require(_n >= 0 && _n <= 10);
67     cutPercent = _n;
68   }
69 
70   function withdraw () onlyOwner() public {
71     owner.transfer(this.balance);
72   }
73 
74   function setOwner (address _owner) onlyOwner() public {
75     owner = _owner;
76   }
77 
78   function listScam (uint256 _scamId, string _name, uint256 _price) onlyOwner() public {
79     require(_price > 0);
80     require(priceOfScam[_scamId] == 0);
81     require(ownerOfScam[_scamId] == address(0));
82     ownerOfScam[_scamId] = owner;
83     priceOfScam[_scamId] = _price;
84     startingPriceOfScam[_scamId] = _price;
85     nameOfScam[_scamId] = _name;
86     scams.push(_scamId);
87   }
88   
89   function getScam(uint256 _scamId) public view returns (address _owner, uint256 _price, string _name) {
90     _owner = ownerOfScam[_scamId];
91     _price = priceOfScam[_scamId];
92     _name = nameOfScam[_scamId];
93   }
94 
95   function getOwner (uint256 _scamId) public view returns (address _owner) {
96     return ownerOfScam[_scamId];
97   }
98 
99   function startingPriceOf (uint256 _scamId) public view returns (uint256 _startingPrice) {
100     return startingPriceOfScam[_scamId];
101   }
102   
103   function priceOf (uint256 _scamId) public view returns (uint256 _price) {
104     return priceOfScam[_scamId];
105   }
106 
107   function nextPriceOf (uint256 _scamId) public view returns (uint256 _nextPrice) {
108     return calculateNextPrice(priceOf(_scamId));
109   }
110 
111   function allScamsForSale () public view returns (uint256[] _scams) {
112     return scams;
113   }
114   
115   function getNumberOfScams () public view returns (uint256 _n) {
116     return scams.length;
117   }
118 
119   function calculateNextPrice (uint256 _currentPrice) public pure returns (uint256 _newPrice) {
120 	  return _currentPrice.mul(125).div(100); // 1.25
121   }
122 
123   function buy (uint256 _scamId) payable public {
124     require(!isContract(msg.sender));
125     require(priceOf(_scamId) > 0);
126     require(getOwner(_scamId) != address(0));
127     require(msg.value == priceOf(_scamId));
128     require(getOwner(_scamId) != msg.sender);
129     address previousOwner = getOwner(_scamId);
130     address newOwner = msg.sender;
131     uint256 price = priceOf(_scamId);
132     ownerOfScam[_scamId] = newOwner;
133     priceOfScam[_scamId] = nextPriceOf(_scamId);
134     Bought(_scamId, newOwner, price);
135     Sold(_scamId, previousOwner, price);
136     uint256 cutAmount = price.mul(cutPercent).div(100);
137     previousOwner.transfer(price - cutAmount);
138   }
139 
140   function isContract(address addr) internal view returns (bool) {
141     uint size;
142     assembly { size := extcodesize(addr) }
143     return size > 0;
144   }
145 }