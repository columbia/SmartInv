1 pragma solidity ^0.4.24;
2 
3 contract Fog {
4   address public owner;
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
19   function move(uint256 direction) public payable {
20     require(tx.origin == msg.sender);
21 
22     uint doubleValue = mul(msg.value, 2);
23     uint minValue = 10000000000000000; // 0.01 Ether
24 
25     // Check for minValue and make sure we have enough balance
26     require(msg.value >= minValue && doubleValue <= address(this).balance);
27 
28     // Roll biased towards direction
29     uint dice = uint(keccak256(abi.encodePacked(now + uint(msg.sender) + direction))) % 3;
30 
31     // Winner
32     if (dice == 2) {
33       msg.sender.transfer(doubleValue);
34       emit Winner(msg.sender, doubleValue);
35 
36     // Looser
37     } else {
38       // Coin biased towards direction
39       uint coin = uint(keccak256(abi.encodePacked(now + uint(msg.sender) + direction))) % 2;
40 
41       // CupCake
42       if (coin == 1) {
43         // Woa! Refund 80%
44         uint eightyPercent = div(mul(msg.value, 80), 100);
45 
46         msg.sender.transfer(eightyPercent);
47         emit CupCake(msg.sender, eightyPercent);
48 
49       // Looser
50       } else {
51         emit Looser(msg.sender, msg.value);
52       }
53     }
54   }
55 
56   function drain(uint value) public onlyOwner {
57     require(value > 0 && value < address(this).balance);
58     owner.transfer(value);
59   }
60 
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     emit OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   function() public payable { }
73 
74   /**
75    * @dev Multiplies two numbers, reverts on overflow.
76    */
77   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
78     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79     // benefit is lost if 'b' is also tested.
80     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81     if (_a == 0) {
82       return 0;
83     }
84 
85     uint256 c = _a * _b;
86     require(c / _a == _b);
87 
88     return c;
89   }
90 
91   /**
92    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
93    */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b > 0); // Solidity only automatically asserts when dividing by 0
96     uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98 
99     return c;
100   }
101 }