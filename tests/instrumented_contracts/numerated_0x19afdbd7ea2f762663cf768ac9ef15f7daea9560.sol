1 pragma solidity ^0.4.21;
2 
3 // SafeMath is a part of Zeppelin Solidity library
4 // licensed under MIT License
5 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/LICENSE
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 contract Owned {
41     address owner;
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     /// @dev Contract constructor
49     function Owned() public {
50         owner = msg.sender;
51     }
52 }
53 
54 
55 contract ETCrossPotatoPresale is Owned {
56     using SafeMath for uint;
57 
58     uint256 public auctionEnd;
59     uint256 public itemType;
60 
61     address public highestBidder;
62     uint256 public highestBid = 0.001 ether;
63     bool public ended;
64 
65     event Bid(address from, uint256 amount);
66     event AuctionEnded(address winner, uint256 amount);
67 
68     ETCrossPotatoPresale public sibling;
69     address public potatoOwner = 0xf3a2727a3447653a58D57e4be63d5D5cdc55421B;
70 
71     function ETCrossPotatoPresale(uint256 _auctionEnd, uint256 _itemType) public {
72         auctionEnd = _auctionEnd;
73         itemType = _itemType;
74     }
75 
76     function _isContract(address _user) internal view returns (bool) {
77         uint size;
78         assembly { size := extcodesize(_user) }
79         return size > 0;
80     }
81 
82     function auctionExpired() public view returns (bool) {
83         return now > auctionEnd;
84     }
85 
86     function nextBid() public view returns (uint256) {
87         if (highestBid < 0.1 ether) {
88             return highestBid.add(highestBid / 2);
89         } else if (highestBid < 1 ether) {
90             return highestBid.add(highestBid.mul(15).div(100));
91         } else {
92             return highestBid.add(highestBid.mul(4).div(100));
93         }
94     }
95 
96     function() public payable {
97         require(!_isContract(msg.sender));
98         require(!auctionExpired());
99 
100         uint256 requiredBid = nextBid();
101 
102         require(msg.value >= requiredBid);
103 
104         uint256 change = msg.value.sub(requiredBid);
105 
106         uint256 difference = requiredBid.sub(highestBid);
107         uint256 reward = difference / 4;
108 
109         if (highestBidder != 0x0) {
110             highestBidder.transfer(highestBid.add(reward));
111         }
112 
113         if (address(sibling) != 0x0) {
114             address siblingHighestBidder = sibling.highestBidder();
115             if (siblingHighestBidder != 0x0) {
116                 siblingHighestBidder.transfer(reward / 2);
117             }
118         }
119 
120         if (potatoOwner != 0x0) {
121             potatoOwner.transfer(reward / 10);
122         }
123 
124         if (change > 0) {
125             msg.sender.transfer(change);
126         }
127 
128         highestBidder = msg.sender;
129         highestBid = requiredBid;
130 
131         emit Bid(msg.sender, requiredBid);
132     }
133 
134     function endAuction() public onlyOwner {
135         require(auctionExpired());
136         require(!ended);
137 
138         ended = true;
139         emit AuctionEnded(highestBidder, highestBid);
140 
141         owner.transfer(address(this).balance);
142     }
143 
144     function setSibling(address _sibling) public onlyOwner {
145         sibling = ETCrossPotatoPresale(_sibling);
146     }
147 
148     function setPotatoOwner(address _potatoOwner) public onlyOwner {
149         potatoOwner = _potatoOwner;
150     }
151 }