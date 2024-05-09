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
23     uint winnerLuckyNumber = 7;
24     
25     uint public ticketPrice = 1 ether;
26         
27     address owner2;
28         
29     mapping (address => bool) participated;
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner||msg.sender==owner2);
33         _;
34     }
35   
36     modifier onlyHuman() {
37         require(msg.sender == tx.origin);
38         _;
39     }
40     
41     function AddressLotteryV2(address _owner2) {
42         owner = msg.sender;
43         owner2 = _owner2;
44         reseed(SeedComponents(12345678, 0x12345678, 0xabbaeddaacdc, 0x22222222));
45     }
46     
47     function setTicketPrice(uint newPrice) onlyOwner {
48         ticketPrice = newPrice;
49     }
50     
51     function participate() payable onlyHuman { 
52         require(msg.value >= ticketPrice);
53         
54         // every address can only win once, obviously
55         if(!participated[msg.sender]){
56         
57         if ( luckyNumberOfAddress(msg.sender) == winnerLuckyNumber)
58         {
59             participated[msg.sender] = true;
60             require(msg.sender.call.value(this.balance)());
61         }
62             
63         }
64     }
65     
66     function luckyNumberOfAddress(address addr) constant returns(uint n){
67         // 1 in 8 chance
68         n = uint(keccak256(uint(addr), secretSeed)[0]) % 8;
69     }
70     
71     function reseed(SeedComponents components) internal{
72         secretSeed = uint256(keccak256(
73             components.component1,
74             components.component2,
75             components.component3,
76             components.component4
77         ));
78         lastReseed = block.number;
79     }
80     
81     function kill() onlyOwner {
82         suicide(owner);
83     }
84     
85     function forceReseed() onlyOwner{
86         SeedComponents s;
87         s.component1 = uint(owner);
88         s.component2 = uint256(block.blockhash(block.number - 1));
89         s.component3 = block.number * 1337;
90         s.component4 = tx.gasprice * 7;
91         reseed(s);
92     }
93     
94     function () payable {}
95     
96     // DEBUG, DELETE BEFORE DEPLOYMENT!!
97     function _myLuckyNumber() constant returns(uint n){
98         n = luckyNumberOfAddress(msg.sender);
99     }
100 }