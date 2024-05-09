1 pragma solidity 0.4.15;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal returns (uint256) {
6         if (a == 0) {
7           return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 
32 }
33 
34 contract Owned {
35     address public contractOwner;
36     address public pendingContractOwner;
37 
38     function Owned() {
39         contractOwner = msg.sender;
40     }
41 
42     modifier onlyContractOwner() {
43         if (contractOwner == msg.sender) {
44             _;
45         }
46     }
47 
48     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
49         pendingContractOwner = _to;
50         return true;
51     }
52 
53     function claimContractOwnership() returns(bool) {
54         if (pendingContractOwner != msg.sender) {
55             return false;
56         }
57         contractOwner = pendingContractOwner;
58         delete pendingContractOwner;
59         return true;
60     }
61 }
62 
63 contract ERC20Interface {
64     function balanceOf(address _address) returns(uint);
65     function transfer(address _receiver, uint _amount) returns(bool);
66     function transferFrom(address _from, address _to, uint _amount) returns(bool);
67 }
68 
69 contract Vesting is Owned {
70     struct Vestings {
71         address receiver;
72         ERC20Interface ERC20;
73         uint amount;
74         uint parts;
75         uint paymentInterval;
76         uint schedule;
77         uint sendings;
78     }
79 
80     mapping (address => uint) public vestingBalance;
81     mapping (address => mapping (address => uint)) public receiverVestings;
82 
83     Vestings[] public vestings;
84 
85     event VestingCreated(address sender, address receiver, address ERC20, uint amount, uint id, uint parts, uint paymentInterval, uint schedule);
86     event VestingSent(address receiver, address ERC20, uint amount, uint id, uint sendings);
87     event ReceiverChanged(uint id, address from, address to);
88 
89     function createVesting(address _receiver, ERC20Interface _ERC20, uint _amount, uint _parts, uint _paymentInterval, uint _schedule) returns(bool) {
90         require(_receiver != 0x0);
91         require(_parts > 0 && _amount > 0 && _parts <= 10000);
92         require(SafeMath.add(_schedule, SafeMath.mul(_paymentInterval, _parts)) <= ((365 * 5 days) + now));
93 
94         vestings.push(Vestings(_receiver, _ERC20, _amount, _parts, _paymentInterval, _schedule, 0));
95         require(_ERC20.transferFrom(msg.sender, address(this), SafeMath.mul(_amount, _parts)));
96         vestingBalance[_ERC20] = SafeMath.add(vestingBalance[_ERC20], (_amount * _parts));
97         receiverVestings[_receiver][_ERC20] = SafeMath.add(receiverVestings[_receiver][_ERC20], (_amount * _parts));
98         VestingCreated(msg.sender, _receiver, _ERC20, _amount, (vestings.length - 1), _parts, _paymentInterval, _schedule);
99         return true;
100     }
101 
102     function sendVesting(uint _id) returns(bool) {
103         require(now >= (vestings[_id].schedule + vestings[_id].paymentInterval * (vestings[_id].sendings + 1)));
104 
105         require(vestings[_id].ERC20.transfer(vestings[_id].receiver, vestings[_id].amount));
106         VestingSent(vestings[_id].receiver, vestings[_id].ERC20, vestings[_id].amount, _id, vestings[_id].sendings);
107         vestings[_id].sendings++;
108         vestingBalance[vestings[_id].ERC20] -= vestings[_id].amount;
109         receiverVestings[vestings[_id].receiver][vestings[_id].ERC20] -= vestings[_id].amount;
110         if (vestings[_id].sendings == vestings[_id].parts) {
111             delete vestings[_id];
112         }
113         return true;
114     }
115 
116     function changeReceiver(uint _id, address _newReceiver) returns(bool) {
117         require(_newReceiver != 0x0);
118         require(msg.sender == vestings[_id].receiver);
119 
120         vestings[_id].receiver = _newReceiver;
121         ReceiverChanged(_id, msg.sender, _newReceiver);
122         return true;
123     }
124 
125     function withdrawExtraTokens(ERC20Interface _ERC20) onlyContractOwner() returns(bool) {
126         require(_ERC20.transfer(contractOwner, getExtraTokens(_ERC20)));
127         return true;
128     }
129 
130     function getVesting(uint _id) constant returns(address, address, uint, uint, uint, uint, uint) {
131         return (vestings[_id].receiver, vestings[_id].ERC20, vestings[_id].amount, vestings[_id].parts, vestings[_id].paymentInterval, vestings[_id].schedule, vestings[_id].sendings);
132     }
133 
134     function getExtraTokens(ERC20Interface _ERC20) constant returns(uint) {
135         return (_ERC20.balanceOf(this) - vestingBalance[_ERC20]);
136     }
137 
138     function getReceiverVesting(address _receiver, address _ERC20) constant returns(uint) {
139         return receiverVestings[_receiver][_ERC20];
140     }
141 }