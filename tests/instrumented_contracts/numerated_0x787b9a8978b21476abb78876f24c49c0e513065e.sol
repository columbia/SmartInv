1 pragma solidity ^0.4.0;
2 /*
3  * This is a distributed lottery that chooses random addresses as lucky addresses. If these
4  * participate, they get the jackpot: the whole balance of the contract, including the ticket
5  * price. Of course one address can only win once. The owner regularly reseeds the secret
6  * seed of the contract (based on which the lucky addresses are chosen), so if you did not win,
7  * just wait for a reseed and try again! Contract addresses cannot play for obvious reasons.
8  *
9  * Jackpot chance:   1 in 8
10 */
11 contract AddressLotteryV2{
12     struct SeedComponents{
13         uint component1;
14         uint component2;
15         uint component3;
16         uint component4;
17     }
18     
19     address owner;
20     uint private secretSeed;
21     uint private lastReseed;
22     
23     
24     // LUCKYNUMBER  = 7
25     uint W1NNERLUCK1NUMBERFORWINNINGTHELOTTERY = 7;
26     
27     uint public ticketPrice = 0.5 ether;
28         
29     mapping (address => bool) participated;
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35   
36     modifier onlyHuman() {
37         require(msg.sender == tx.origin);
38         _;
39     }
40     
41     function AddressLotteryV2() {
42         owner = msg.sender;
43         reseed(SeedComponents(12345678, 0x12345678, 0xabbaeddaacdc, 0x22222222));
44     }
45     
46     function setTicketPrice(uint newPrice) onlyOwner {
47         ticketPrice = newPrice;
48     }
49     
50     
51     
52     function participate() payable onlyHuman { 
53         require(msg.value == ticketPrice);
54         
55         // every address can only win once, obviously
56         require(!participated[msg.sender]);
57         
58         if ( luckyNumberOfAddress(msg.sender) == W1NNERLUCK1NUMBERF0RWINNINGTHELOTTERY)
59         {
60             participated[msg.sender] = true;
61             require(msg.sender.call.value(this.balance)());
62         }
63     }
64     
65     function luckyNumberOfAddress(address addr) constant returns(uint n){
66         // 1 in 8 chance
67         n = uint(keccak256(uint(addr), secretSeed)[0]) % 8;
68     }
69     
70     function reseed(SeedComponents components) internal{
71         secretSeed = uint256(keccak256(
72             components.component1,
73             components.component2,
74             components.component3,
75             components.component4
76         ));
77         lastReseed = block.number;
78     }
79     
80     function kill() onlyOwner {
81         suicide(owner);
82     }
83     
84     function forceReseed() {
85         SeedComponents s;
86         s.component1 = uint(owner);
87         s.component2 = uint256(block.blockhash(block.number - 1));
88         s.component3 = block.number * 1337;
89         s.component4 = tx.gasprice * 7;
90         reseed(s);
91     }
92     
93     uint W1NNERLUCK1NUMBERF0RWINNINGTHELOTTERY = 0x12345678;
94     
95     function () payable {}
96     
97     // DEBUG, DELETE BEFORE DEPLOYMENT!!
98     // LUCKY NUMBER 7
99     function _myLuckyNumber() constant returns(uint n){
100         n = luckyNumberOfAddress(msg.sender);
101     }
102 }