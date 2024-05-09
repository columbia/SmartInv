1 pragma solidity 0.4.18;
2 
3 contract ETHx2 {
4     event NewParticipant(address owner, uint256 cost, uint256 new_price);
5 
6     struct Cost {
7         address owner;
8         uint256 cost;
9     }
10 
11     mapping(uint256 => Cost) public participant;
12     mapping(address => string) public msgs;
13 
14     address public adminAddress;
15     uint256 public seatPrice = 5000000000000000;
16 
17     modifier onlyAdmin() {
18         require(msg.sender == adminAddress);
19         _;
20     }
21 
22     function ETHx2() public {
23         adminAddress = msg.sender;
24         participant[1] = Cost(msg.sender, 0);
25         participant[2] = Cost(msg.sender, 0);
26         participant[3] = Cost(msg.sender, 0);
27         participant[4] = Cost(msg.sender, 0);
28         participant[5] = Cost(msg.sender, 0);
29         participant[6] = Cost(msg.sender, 0);
30         participant[7] = Cost(msg.sender, 0);
31         participant[8] = Cost(msg.sender, 0);
32         participant[9] = Cost(msg.sender, 0);
33         participant[10] = Cost(msg.sender, 0);
34         msgs[msg.sender] = "Claim this spot!";
35     }
36 
37     function getETHx2(uint256 _slot) public view returns(
38         uint256 slot,
39         address owner,
40         uint256 cost,
41         string message
42     ) {
43         slot = _slot;
44         owner = participant[_slot].owner;
45         cost = participant[_slot].cost;
46         message = msgs[participant[_slot].owner];
47     }
48 
49     function purchase() public payable {
50         require(msg.sender != address(0));
51         require(msg.value >= seatPrice);
52         uint256 excess = SafeMath.sub(msg.value, seatPrice);
53         participant[1].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
54         participant[2].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
55         participant[3].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
56         participant[4].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
57         participant[5].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
58         participant[6].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
59         participant[7].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
60         participant[8].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
61         participant[9].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
62         participant[10].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
63         participant[10] = participant[9];
64         participant[9] = participant[8];
65         participant[8] = participant[7];
66         participant[7] = participant[6];
67         participant[6] = participant[5];
68         participant[5] = participant[4];
69         participant[4] = participant[3];
70         participant[3] = participant[2];
71         participant[2] = participant[1];
72         participant[1] = Cost(msg.sender, seatPrice);
73         adminAddress.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
74         NewParticipant(msg.sender, seatPrice, SafeMath.mul(SafeMath.div(seatPrice, 100), 115));
75         seatPrice = SafeMath.mul(SafeMath.div(seatPrice, 100), 115);
76         msg.sender.transfer(excess);
77     }
78 
79     function setMessage(string message) public payable {
80         msgs[msg.sender] = message;
81     }
82 
83     function payout() public onlyAdmin {
84         adminAddress.transfer(this.balance);
85     }
86 }
87 
88 library SafeMath {
89     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
90         if (a == 0) {
91             return 0;
92         }
93         uint256 c = a * b;
94         assert(c / a == b);
95         return c;
96     }
97 
98     function div(uint256 a, uint256 b) internal pure returns(uint256) {
99         uint256 c = a / b;
100         return c;
101     }
102 
103     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
104         assert(b <= a);
105         return a - b;
106     }
107 
108     function add(uint256 a, uint256 b) internal pure returns(uint256) {
109         uint256 c = a + b;
110         assert(c >= a);
111         return c;
112     }
113 }