1 pragma solidity ^0.4.18;
2 
3 contract Hypes {
4   event NewOne(address owner, uint256 cost, uint256 new_price);
5 
6   struct Hype {
7     address owner;
8     uint256 cost;
9   }
10 
11   mapping (uint256 => Hype) public hypes;
12   mapping (address => string) public msgs;
13 
14   address public ceoAddress;
15   uint256 public seatPrice = 2500000000000000;
16 
17   modifier onlyCEO() { require(msg.sender == ceoAddress); _; }
18 
19   function Hypes() public {
20     ceoAddress = msg.sender;
21     hypes[1] = Hype(msg.sender, 0);
22     hypes[2] = Hype(msg.sender, 0);
23     hypes[3] = Hype(msg.sender, 0);
24     hypes[4] = Hype(msg.sender, 0);
25     hypes[5] = Hype(msg.sender, 0);
26     hypes[6] = Hype(msg.sender, 0);
27     hypes[7] = Hype(msg.sender, 0);
28     hypes[8] = Hype(msg.sender, 0);
29     hypes[9] = Hype(msg.sender, 0);
30     msgs[msg.sender] = "Claim this spot!";
31   }
32 
33   function getHype(uint256 _slot) public view returns (
34     uint256 slot,
35     address owner,
36     uint256 cost,
37     string message
38   ) {
39     slot = _slot;
40     owner = hypes[_slot].owner;
41     cost = hypes[_slot].cost;
42     message = msgs[hypes[_slot].owner];
43   }
44 
45   function purchase() public payable {
46     require(msg.sender != address(0));
47     require(msg.value >= seatPrice);
48     uint256 excess = SafeMath.sub(msg.value, seatPrice);
49     hypes[1].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 9)));
50     hypes[2].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 9)));
51     hypes[3].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 9)));
52     hypes[4].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 9)));
53     hypes[5].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 9)));
54     hypes[6].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 9)));
55     hypes[7].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 9)));
56     hypes[8].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 9)));
57     hypes[9].owner.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 9)));
58     hypes[9] = hypes[8]; hypes[8] = hypes[7]; hypes[7] = hypes[6];
59     hypes[6] = hypes[5]; hypes[5] = hypes[4]; hypes[4] = hypes[3];
60     hypes[3] = hypes[2]; hypes[2] = hypes[1];
61     hypes[1] = Hype(msg.sender, seatPrice);
62     ceoAddress.transfer(uint256(SafeMath.mul(SafeMath.div(seatPrice, 100), 19)));
63     NewOne(msg.sender, seatPrice, SafeMath.mul(SafeMath.div(seatPrice, 100), 109));
64     seatPrice = SafeMath.mul(SafeMath.div(seatPrice, 100), 109);
65     msg.sender.transfer(excess);
66   }
67 
68   function setMessage(string message) public payable {
69     msgs[msg.sender] = message;
70   }
71 
72   function payout() public onlyCEO {
73     ceoAddress.transfer(this.balance);
74   }
75 }
76 
77 library SafeMath {
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     if (a == 0) {
80       return 0;
81     }
82     uint256 c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a / b;
88     return c;
89   }
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }