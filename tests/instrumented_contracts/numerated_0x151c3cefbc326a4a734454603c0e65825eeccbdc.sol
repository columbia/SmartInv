1 pragma solidity ^0.4.24;
2 
3 contract ConferencePay {
4 
5     using SafeMath for uint256;
6     uint public endTime;
7     address public owner;
8     bool public active = true;
9     mapping (bytes32 => uint) public talkMapping;
10 
11     struct Talk {
12         uint amount;
13         address addr;
14         bytes32 title;
15     }
16 
17     Talk[] public talks;
18 
19     modifier notEnded() { require(true == active); _; }
20 
21 	event Pay(address indexed _from, uint256 indexed _talk);
22     event Ended();
23 
24 	constructor(uint end) public {
25         endTime = end;
26         owner = msg.sender;
27 	}
28 
29     function getTalkCount() public constant returns(uint) {
30         return talks.length;
31     }
32 
33     function add(address addr, bytes32 title) public notEnded returns(uint) {
34         require(owner == msg.sender);
35         uint index = talks.length;
36         talkMapping[title] = index;
37         talks.push(Talk({
38             amount: 0,
39             addr: addr,
40             title: title
41         }));
42         return index;
43     }
44 
45 	function pay(uint talk) public notEnded payable {
46 		talks[talk].amount += msg.value;
47         emit Pay(msg.sender, talk);
48 	}
49 
50     function end() notEnded public {
51         require(now > endTime);
52         uint max = 0;
53         address winnerAddress;
54         uint balance = address(this).balance;
55         owner.transfer(balance.mul(20).div(100));
56         for (uint i = 0; i < talks.length; i++) {
57             if (talks[i].amount > max) {
58                 max = talks[i].amount;
59                 winnerAddress = talks[i].addr;
60             }
61             talks[i].addr.transfer(talks[i].amount.mul(70).div(100));
62         }
63         winnerAddress.transfer(address(this).balance);
64         active = false;
65         emit Ended();
66     }
67 }
68 
69 library SafeMath {
70   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a * b;
72     assert(a == 0 || c / a == b);
73     return c;
74   }
75 
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return c;
81   }
82 
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }