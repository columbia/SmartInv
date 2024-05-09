1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract NowTees {
4 
5   uint256 public _maxNowTeeSets;
6   address payable public _owner;
7   uint256 public _nowTeeSetPrice;
8   // map from key to set
9   mapping(address => uint256) public _nowTeeKeys;
10   mapping(uint256 => NowTeeSet) public _nowTeeSets;
11   uint256 public _soldSets;
12 
13   event NewNowTeeSet(uint256 setID);
14 
15   struct NowTeeSet {
16     address firstKey;
17     address secondKey;
18     address thirdKey;
19   }
20 
21   constructor(address payable owner, uint256 nowTeeSetPrice, uint256 maxNowTeeSets) public {
22     _owner = owner;
23     _nowTeeSetPrice = nowTeeSetPrice;
24     _maxNowTeeSets = maxNowTeeSets;
25   }
26 
27   modifier onlyOwner() {
28     require(msg.sender == _owner);
29     _;
30   }
31 
32   function changeOwner(address payable newOwner) public onlyOwner() {
33     require(newOwner != address(0));
34     _owner = newOwner;
35   }
36 
37   function changePriceForNowTeeSet(uint256 newPrice) public onlyOwner() {
38 
39     // update price for three shirts
40     _nowTeeSetPrice = newPrice;
41 
42   }
43 
44   function soldSets() view public returns (uint256) {
45     return _soldSets;
46   }
47 
48   function nowTeeSetByKey(address key) view public returns (address, address, address) {
49     NowTeeSet memory set = _nowTeeSets[_nowTeeKeys[key]];
50     return (set.firstKey, set.secondKey, set.thirdKey);
51   }
52 
53   function isValidNowTeeKey(address key) view public returns (bool) {
54     return _nowTeeKeys[key] != 0;
55   }
56 
57   function allocateKey(address key, uint256 set) internal {
58     // make sure that address is a non nil address
59     require(key != address (0));
60     // make sure that key hasn't been used
61     require(_nowTeeKeys[key] == 0);
62     _nowTeeKeys[key] = set;
63   }
64 
65   function buySet(address firstKey, address secondKey, address thirdKey) payable public {
66 
67     // make sure they send in enough ether & forward it to owner
68     require(msg.value >= _nowTeeSetPrice);
69     _owner.transfer(address(this).balance);
70 
71     // make sure that we don't sell more than max sets
72     _soldSets += 1;
73     require(_soldSets <= _maxNowTeeSets);
74 
75     // put key set into state
76     NowTeeSet memory keySet = NowTeeSet(firstKey, secondKey, thirdKey);
77     _nowTeeSets[_soldSets] = keySet;
78     emit NewNowTeeSet(_soldSets);
79 
80     // map keys to set
81     allocateKey(firstKey, _soldSets);
82     allocateKey(secondKey, _soldSets);
83     allocateKey(thirdKey, _soldSets);
84 
85   }
86 
87 }