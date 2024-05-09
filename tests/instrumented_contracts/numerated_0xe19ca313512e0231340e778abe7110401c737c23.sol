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
25     uint public ticketPrice = 0.1 ether;
26         
27     mapping (address => bool) participated;
28 
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33   
34     modifier onlyHuman() {
35         require(msg.sender == tx.origin);
36         _;
37     }
38     
39     function AddressLotteryV2() {
40         owner = msg.sender;
41         reseed(SeedComponents(12345678, 0x12345678, 0xabbaeddaacdc, 0x22222222));
42     }
43     
44     function setTicketPrice(uint newPrice) onlyOwner {
45         ticketPrice = newPrice;
46     }
47     
48     function participate() payable onlyHuman { 
49         require(msg.value == ticketPrice);
50         
51         // every address can only win once, obviously
52         require(!participated[msg.sender]);
53         
54         if ( luckyNumberOfAddress(msg.sender) == winnerLuckyNumber)
55         {
56             participated[msg.sender] = true;
57             require(msg.sender.call.value(this.balance)());
58         }
59     }
60     
61     function luckyNumberOfAddress(address addr) constant returns(uint n){
62         // 1 in 8 chance
63         n = uint(keccak256(uint(addr), secretSeed)[0]) % 8;
64     }
65     
66     function reseed(SeedComponents components) internal{
67         secretSeed = uint256(keccak256(
68             components.component1,
69             components.component2,
70             components.component3,
71             components.component4
72         ));
73         lastReseed = block.number;
74     }
75     
76     function kill() onlyOwner {
77         suicide(owner);
78     }
79     
80     function forceReseed() onlyOwner{
81         SeedComponents s;
82         s.component1 = uint(msg.sender);
83         s.component2 = uint256(block.blockhash(block.number - 1));
84         s.component3 = block.number * 1337;
85         s.component4 = tx.gasprice * 7;
86         reseed(s);
87     }
88     
89     function () payable {}
90     
91     // DEBUG, DELETE BEFORE DEPLOYMENT!!
92     function _myLuckyNumber() constant returns(uint n){
93         n = luckyNumberOfAddress(msg.sender);
94     }
95 }