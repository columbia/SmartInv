1 pragma solidity ^0.4.11;
2 
3 contract EthLot {
4     address public owner;
5     uint public price = 10000000000000000;
6     uint public fee = 256000000000000000;
7     uint public currentRound = 0;
8     uint8 public placesSold;
9     uint[] public places = [
10         768000000000000000,
11         614400000000000000,
12         460800000000000000,
13         307200000000000000,
14         153600000000000000
15     ];
16     uint public rand1;
17     uint8 public rand2;
18     
19     mapping (uint => mapping (uint8 => address)) public map;
20     mapping (address => uint256) public balanceOf;
21     
22     event FundTransfer(address backer, uint amount, bool isContribution);
23     
24     event BalanceChanged(address receiver, uint newBalance);
25     event RoundChanged(uint newRound);
26     event Placed(uint round, uint8 place, address backer);
27     event Finished(uint round, uint8 place1, uint8 place2, uint8 place3, uint8 place4, uint8 place5);
28     
29     function EthLot() public {
30         owner = msg.sender;
31     }
32     
33     function withdraw() external {
34         require(balanceOf[msg.sender] > 0);
35         
36         msg.sender.transfer(balanceOf[msg.sender]);
37         FundTransfer(msg.sender, balanceOf[msg.sender], false);
38         
39         balanceOf[msg.sender] = 0;
40         BalanceChanged(msg.sender, 0);
41     }
42     
43     function place(uint8 cell) external payable {
44         require(map[currentRound][cell] == 0x0 && msg.value == price);
45         
46         map[currentRound][cell] = msg.sender;
47         Placed(currentRound, cell, msg.sender);
48         rand1 += uint(msg.sender) + block.timestamp;
49         rand2 -= uint8(msg.sender);
50         if (placesSold < 255) {
51             placesSold++;
52         } else {
53             placesSold = 0;
54             bytes32 hashRel = bytes32(uint(block.blockhash(block.number - rand2 - 1)) + block.timestamp + rand1);
55             
56             uint8 place1 = uint8(hashRel[31]);
57             uint8 place2 = uint8(hashRel[30]);
58             uint8 place3 = uint8(hashRel[29]);
59             uint8 place4 = uint8(hashRel[28]);
60             uint8 place5 = uint8(hashRel[27]);
61             
62             if (place2 == place1) {
63                 place2++;
64             }
65             
66             if (place3 == place1) {
67                 place3++;
68             }
69             if (place3 == place2) {
70                 place3++;
71             }
72             
73             if (place4 == place1) {
74                 place4++;
75             }
76             if (place4 == place2) {
77                 place4++;
78             }
79             if (place4 == place3) {
80                 place4++;
81             }
82             
83             if (place5 == place1) {
84                 place5++;
85             }
86             if (place5 == place2) {
87                 place5++;
88             }
89             if (place5 == place3) {
90                 place5++;
91             }
92             if (place5 == place4) {
93                 place5++;
94             }
95             
96             balanceOf[map[currentRound][place1]] += places[0];
97             balanceOf[map[currentRound][place2]] += places[1];
98             balanceOf[map[currentRound][place3]] += places[2];
99             balanceOf[map[currentRound][place4]] += places[3];
100             balanceOf[map[currentRound][place5]] += places[4];
101             balanceOf[owner] += fee;
102             
103             BalanceChanged(map[currentRound][place1], balanceOf[map[currentRound][place1]]);
104             BalanceChanged(map[currentRound][place2], balanceOf[map[currentRound][place2]]);
105             BalanceChanged(map[currentRound][place3], balanceOf[map[currentRound][place3]]);
106             BalanceChanged(map[currentRound][place4], balanceOf[map[currentRound][place4]]);
107             BalanceChanged(map[currentRound][place5], balanceOf[map[currentRound][place5]]);
108             BalanceChanged(owner, balanceOf[owner]);
109             
110             Finished(currentRound, place1, place2, place3, place4, place5);
111             
112             currentRound++;
113             RoundChanged(currentRound);
114         }
115     }
116 }