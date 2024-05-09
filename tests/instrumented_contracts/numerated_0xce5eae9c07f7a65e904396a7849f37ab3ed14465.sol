1 pragma solidity ^0.4.24;
2 
3 contract ConferencePay {
4     uint public endTime;
5     address public owner;
6     mapping (bytes32 => uint) public talkMapping;
7     using SafeMath for uint256;
8 
9     struct Talk {
10         uint amount;
11         address addr;
12         bytes32 title;
13     }
14 
15     Talk[] public talks;
16 
17     modifier onlyBefore(uint _time) { require(now < _time); _; }
18     modifier onlyAfter(uint _time) { require(now > _time); _; }
19 
20 	//event Transfer(address indexed _from, address indexed _to, uint256 _value);
21 
22 	constructor(uint end) public {
23         endTime = end;
24         owner = msg.sender;
25 	}
26 
27     function getTalkCount() public constant returns(uint) {
28         return talks.length;
29     }
30 
31     function add(address addr, bytes32 title) public returns(uint) {
32         uint index = talks.length;
33         talkMapping[title] = index;
34         talks.push(Talk({
35             amount: 0,
36             addr: addr,
37             title: title
38         }));
39         return index;
40     }
41 
42 	function pay(uint talk) public payable returns(bool sufficient) {
43 		talks[talk].amount += msg.value;
44 		return true;
45 	}
46 
47     function end() public {
48         require(now > endTime);
49         uint max = 0;
50         address winnerAddress;
51         uint balance = address(this).balance;
52         owner.transfer(balance.mul(20).div(100));
53         for (uint i = 0; i < talks.length; i++) {
54             if (talks[i].amount > max) {
55                 max = talks[i].amount;
56                 winnerAddress = talks[i].addr;
57             }
58             talks[i].addr.transfer(talks[i].amount.mul(70).div(100));
59         }
60         winnerAddress.transfer(address(this).balance);
61     }
62 }
63 
64 library SafeMath {
65   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a * b;
67     assert(a == 0 || c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal pure returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }