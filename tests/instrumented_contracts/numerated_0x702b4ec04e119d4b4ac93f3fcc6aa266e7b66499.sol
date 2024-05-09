1 pragma solidity 0.4.18;
2 
3 contract ETHx2 {
4     
5     event NewParticipant(address owner, uint256 cost, uint256 new_price);
6 
7     struct Cost {
8         address owner;
9         uint256 cost;
10     }
11 
12     mapping(uint256 => Cost) public participant;
13     mapping(address => string) public msgs;
14 
15     address public Address;
16     uint256 public seatPrice = 5000000000000000;
17 
18     modifier onlyAdmin() {
19         require(msg.sender == Address);
20         _;
21     }
22 
23     function participant() public {
24         Address = msg.sender;
25         participant[1] = Cost(msg.sender, 0);
26         participant[2] = Cost(msg.sender, 0);
27         participant[3] = Cost(msg.sender, 0);
28         participant[4] = Cost(msg.sender, 0);
29         participant[5] = Cost(msg.sender, 0);
30         participant[6] = Cost(msg.sender, 0);
31         participant[7] = Cost(msg.sender, 0);
32         participant[8] = Cost(msg.sender, 0);
33         participant[9] = Cost(msg.sender, 0);
34         participant[10] = Cost(msg.sender, 0);
35         msgs[msg.sender] = "Claim this spot!";
36     }
37 
38     function getX2(uint256 _slot) public view returns(uint256 slot, address owner, uint256 cost, string message) {
39         slot = _slot;
40         owner = participant[_slot].owner;
41         cost = participant[_slot].cost;
42         message = msgs[participant[_slot].owner];
43     }
44 
45     function purchase() public payable {
46         require(msg.sender != address(0));
47         require(msg.value >= seatPrice);
48         uint256 excess = SafeMath.sub(msg.value, seatPrice);
49         participant[1].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
50         participant[2].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
51         participant[3].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
52         participant[4].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
53         participant[5].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
54         participant[6].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
55         participant[7].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
56         participant[8].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
57         participant[9].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), SafeMath.div(100, SafeMath.div(200, 17)))));
58         participant[10] = participant[9];
59         participant[9] = participant[8];
60         participant[8] = participant[7];
61         participant[7] = participant[6];
62         participant[6] = participant[5];
63         participant[5] = participant[4];
64         participant[4] = participant[3];
65         participant[3] = participant[2];
66         participant[2] = participant[1];
67         participant[1] = Cost(msg.sender, seatPrice);
68         Address.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 15)));
69         NewParticipant(msg.sender, seatPrice, SafeMath.mul(SafeMath.div(seatPrice, 100), 115));
70         seatPrice = SafeMath.mul(SafeMath.div(seatPrice, 100), 115);
71         msg.sender.transfer(excess);
72     }
73 
74     function setMessage(string message) public payable {
75         msgs[msg.sender] = message;
76     }
77 
78     function payout() public onlyAdmin {
79         Address.transfer(this.balance);
80     }
81 }
82 
83 library SafeMath {
84     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
85         if (a == 0) {
86             return 0;
87         }
88         uint256 c = a * b;
89         assert(c / a == b);
90         return c;
91     }
92 
93     function div(uint256 a, uint256 b) internal pure returns(uint256) {
94         uint256 c = a / b;
95         return c;
96     }
97 
98     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
99         assert(b <= a);
100         return a - b;
101     }
102 
103     function add(uint256 a, uint256 b) internal pure returns(uint256) {
104         uint256 c = a + b;
105         assert(c >= a);
106         return c;
107     }
108 }