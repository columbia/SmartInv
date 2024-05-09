1 pragma solidity ^0.4.24;
2 
3 contract Fog {
4   address private owner;
5 
6   event OwnershipTransferred(
7     address indexed owner,
8     address indexed newOwner
9   );
10 
11   event Winner(address indexed to, uint indexed value);
12   event CupCake(address indexed to, uint indexed value);
13   event Looser(address indexed from, uint indexed value);
14 
15   constructor() public {
16     owner = msg.sender;
17   }
18 
19   function move(uint8 direction) public payable {
20     // Double
21     uint doubleValue = mul(msg.value, 2);
22     uint minValue = 10000000000000000; // 0.01 Ether
23 
24     // Check for minValue and make sure we have enough balance
25     require(msg.value >= minValue && doubleValue <= address(this).balance);
26 
27     // Roll biased towards direction
28     uint dice = uint(keccak256(abi.encodePacked(block.timestamp + direction))) % 3;
29 
30     // Winner
31     if (dice == 2) {
32       msg.sender.transfer(doubleValue);
33       emit Winner(msg.sender, doubleValue);
34 
35       // Looser
36     } else {
37       // Coin biased towards direction
38       uint coin = uint(keccak256(abi.encodePacked(block.timestamp + direction))) % 2;
39 
40       // CupCake
41       if (coin == 1) {
42         // Woa! Refund 80%
43         uint eightyPercent = div(mul(msg.value, 80), 100);
44 
45         msg.sender.transfer(eightyPercent);
46         emit CupCake(msg.sender, eightyPercent);
47 
48         // Looser
49       } else {
50         emit Looser(msg.sender, msg.value);
51       }
52     }
53   }
54 
55   function drain(uint value) public onlyOwner {
56     require(value > 0 && value < address(this).balance);
57     owner.transfer(value);
58   }
59 
60   function getOwner() public view returns(address) {
61     return owner;
62   }
63 
64   function transferOwnership(address newOwner) public onlyOwner {
65     require(newOwner != address(0));
66     emit OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   function() public payable { }
76 
77   /**
78    * @dev Multiplies two numbers, reverts on overflow.
79    */
80   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
81     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82     // benefit is lost if 'b' is also tested.
83     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
84     if (_a == 0) {
85       return 0;
86     }
87 
88     uint256 c = _a * _b;
89     require(c / _a == _b);
90 
91     return c;
92   }
93 
94   /**
95    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
96    */
97   function div(uint256 a, uint256 b) internal pure returns (uint256) {
98     require(b > 0); // Solidity only automatically asserts when dividing by 0
99     uint256 c = a / b;
100     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101 
102     return c;
103   }
104 }