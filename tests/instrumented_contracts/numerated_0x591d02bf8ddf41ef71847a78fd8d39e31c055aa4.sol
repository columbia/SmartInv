1 pragma solidity ^0.5.1;
2 
3 contract reanimator {
4     uint public advertisingPot;
5     mapping (uint256 => uint256) advertisingPotDistributed;
6     uint public lastDistrib;
7     uint public currentDistribRound;
8     uint public numOfAdvert;
9 
10     address payable support;
11 
12     mapping (address => uint256) double;
13     mapping (address => uint256) oneAndAHalf;
14     mapping (address => uint256) twoWeeks;
15     mapping (address => uint256) maximum;
16     mapping (address => uint256) advertising;
17     mapping (address => uint) advertisingLastWithdrawal;
18 
19     constructor () public {
20         currentDistribRound = 0;
21         support = 0x3442d50F3F5c5E796d2ed3DdB95f0fB4fA54F144;
22         lastDistrib = now;
23     }
24 
25     function () payable external {
26         support.transfer((3*msg.value)/50);
27         if (msg.value < 10**17) {advertisingPot += msg.value; return;}
28         if (msg.value == 10**19) {maximum[msg.sender] = now; return;}
29         if (msg.value == 5*10**18) {twoWeeks[msg.sender] = now; return;}
30         if (msg.value == 10**18) {oneAndAHalf[msg.sender] = now; return;}
31         if (msg.value == 3*10**17) {double[msg.sender] = now; return;}
32         if (msg.value == 10**17) {advertising[msg.sender] = now; advertisingLastWithdrawal[msg.sender] = currentDistribRound; numOfAdvert += 1; return;}
33         if (msg.value == 0) {withdraw(msg.sender); return;}
34         advertisingPot += msg.value;
35     }
36 
37     function distributeAdvertisingFunds() public {
38         require (now - lastDistrib >= 1 weeks);
39         advertisingPotDistributed[currentDistribRound] = (advertisingPot / ( 2 * numOfAdvert));
40         currentDistribRound +=1;
41         advertisingPot = 0;
42         lastDistrib = now;
43     }
44 
45     function getAdvBalance(address addr) public view returns (uint balance) {
46         uint _balance;
47         for (uint i = advertisingLastWithdrawal[addr]; i<currentDistribRound; i+=1) {
48                 _balance += advertisingPotDistributed[i];
49         }
50         return _balance;
51     }
52     
53     function getAdvLastWithdrawal(address addr) public view returns (uint round) {
54         return advertisingLastWithdrawal[addr];
55     }
56 
57     function withdraw(address payable addr) public {
58         uint toTransfer;
59 
60         if (maximum[addr] != 0 && (now - maximum[addr] > 1 weeks)) {
61             toTransfer = 10**19 + 10**17 * (now - maximum[addr]) / 1 days;
62             maximum[addr] = 0;
63             addr.transfer(toTransfer);
64             return;
65         }
66 
67         if (twoWeeks[addr] !=0 && (now - twoWeeks[addr] > 2 weeks)) {
68             toTransfer = 5 * 10**18 + 10**17 * (now - twoWeeks[addr]) / 1 days;
69             if (toTransfer > 6 * 10**18) toTransfer = 6 * 10**18;
70             twoWeeks[addr] = 0;
71             addr.transfer(toTransfer);
72             return;
73         }
74 
75         if (oneAndAHalf[addr] !=0 && (now - oneAndAHalf[addr] > 28 days)) {
76             toTransfer = 10**18 + 2 * 10**16 * (now - oneAndAHalf[addr]) / 1 days;
77             if (toTransfer > 15 * 10**17) toTransfer =  15 * 10**17;
78             oneAndAHalf[addr] = 0;
79             addr.transfer(toTransfer);
80             return;
81         }
82 
83         if (double[addr]!= 0 && (now - double[addr] > 53 days) ) {
84             toTransfer = 3 * 10**17 + 6 * 10**15 * (now - double[addr]) / 1 days;
85             if (toTransfer > 6 * 10**17) toTransfer = 6 * 10**17;
86             double[addr] = 0;
87             addr.transfer(toTransfer);
88             return;
89         }
90 
91         if (advertising[addr] != 0) {
92             toTransfer = getAdvBalance(addr);
93             require (toTransfer>0);
94             advertisingLastWithdrawal[addr] = currentDistribRound;
95             addr.transfer(toTransfer);
96             return;
97         }
98     }
99 }