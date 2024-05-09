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
55     mapping(address => uint256) public depositOf;
56 
57     struct Share {
58         address member;
59         uint256 amount;
60     }
61     Share[] private shares;
62 
63     event Deposited(address indexed member, uint256 amount);
64     event Withdrawn(address indexed member, uint256 amount);
65 
66     constructor() public {
67         shares.push(Share(address(0), 0));
68 
69         shares.push(Share(0x05dEbE8428CAe653eBA92a8A887CCC73C7147bB8, 60));
70         shares.push(Share(0xF53e5f0Af634490D33faf1133DE452cd9fF987e1, 20));
71         shares.push(Share(0x34D26e1325352d7B3F91DF22ae97894B0C5343b7, 20));
72     }
73 
74     function() public payable {
75         deposit();
76     }
77 
78     function deposit() public payable {
79         uint256 amount = msg.value;
80         require(amount > 0, "Deposit failed - zero deposits not allowed");
81 
82         for (uint256 i = 1; i < shares.length; i++) {
83             if (shares[i].amount > 0) {
84                 depositOf[shares[i].member] = depositOf[shares[i].member].add(amount.mul(shares[i].amount).div(100));
85             }
86         }
87 
88         emit Deposited(msg.sender, amount);
89     }
90 
91     function withdraw(address _who) public {
92         uint256 amount = depositOf[_who];
93         require(amount > 0 && amount <= address(this).balance, "Insufficient amount.");
94 
95         depositOf[_who] = depositOf[_who].sub(amount);
96 
97         _who.transfer(amount);
98 
99         emit Withdrawn(_who, amount);
100     }
101 
102     function getShares(address _who) public view returns(uint256 amount) {
103         for (uint256 i = 1; i < shares.length; i++) {
104             if (shares[i].member == _who) {
105                 amount = shares[i].amount;
106                 break;
107             }
108         }
109         return amount;
110     }
111 
112     function setShares(address _who, uint256 _amount) public onlyOwner {
113         uint256 index = 0;
114         uint256 total = 100;
115         for (uint256 i = 1; i < shares.length; i++) {
116             if (shares[i].member == _who) {
117                 index = i;
118             } else if (shares[i].amount > 0) {
119                 total = total.sub(shares[i].amount);
120             }
121         }
122         require(_amount <= total, "Insufficient shares.");
123 
124         if (index > 0) {
125             shares[index].amount = _amount;
126         } else {
127             shares.push(Share(_who, _amount));
128         }
129     }
130 }