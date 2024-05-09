1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         require(c / a == b, "SafeMath mul failed");
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b <= a, "SafeMath sub failed");
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         require(c >= a, "SafeMath add failed");
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner, "You are not owner.");
40         _;
41     }
42 
43     function transferOwnership(address _newOwner) public onlyOwner {
44         require(_newOwner != address(0), "Invalid address.");
45 
46         owner = _newOwner;
47 
48         emit OwnershipTransferred(owner, _newOwner);
49     }
50 }
51 
52 contract Foundation is Ownable {
53     using SafeMath for uint256;
54 
55     string public name = "Fomo3D Foundation (Asia)";
56 
57     mapping(address => uint256) public depositOf;
58 
59     struct Member {
60         address who;
61         uint256 shares;
62     }
63     Member[] private members;
64 
65     event Deposited(address indexed who, uint256 amount);
66     event Withdrawn(address indexed who, uint256 amount);
67 
68     constructor() public {
69         members.push(Member(address(0), 0));
70 
71         members.push(Member(0x05dEbE8428CAe653eBA92a8A887CCC73C7147bB8, 60));
72         members.push(Member(0xF53e5f0Af634490D33faf1133DE452cd9fF987e1, 20));
73         members.push(Member(0x34d26e1325352d7b3f91df22ae97894b0c5343b7, 20));
74     }
75 
76     function() public payable {
77         deposit();
78     }
79 
80     function deposit() public payable {
81         uint256 amount = msg.value;
82         require(amount > 0, "Deposit failed - zero deposits not allowed");
83 
84         for (uint256 i = 1; i < members.length; i++) {
85             if (members[i].shares > 0) {
86                 depositOf[members[i].who] = depositOf[members[i].who].add(amount.mul(members[i].shares).div(100));
87             }
88         }
89 
90         emit Deposited(msg.sender, amount);
91     }
92 
93     function withdraw(address _who) public {
94         uint256 amount = depositOf[_who];
95         require(amount > 0 && amount <= address(this).balance, "Insufficient amount.");
96 
97         depositOf[_who] = depositOf[_who].sub(amount);
98 
99         _who.transfer(amount);
100 
101         emit Withdrawn(_who, amount);
102     }
103 
104     function setMember(address _who, uint256 _shares) public onlyOwner {
105         uint256 memberIndex = 0;
106         uint256 sharesSupply = 100;
107         for (uint256 i = 1; i < members.length; i++) {
108             if (members[i].who == _who) {
109                 memberIndex = i;
110             } else if (members[i].shares > 0) {
111                 sharesSupply = sharesSupply.sub(members[i].shares);
112             }
113         }
114         require(_shares <= sharesSupply, "Insufficient shares.");
115 
116         if (memberIndex > 0) {
117             members[memberIndex].shares = _shares;
118         } else {
119             members.push(Member(_who, _shares));
120         }
121     }
122 }