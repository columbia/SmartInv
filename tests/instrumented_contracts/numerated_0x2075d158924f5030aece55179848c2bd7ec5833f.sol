1 pragma solidity ^0.4.0;
2 /*
3  * This is a distributed lottery that chooses random addresses as lucky addresses. If these
4  * participate, they get the jackpot: the whole balance of the contract, including the ticket
5  * price. Of course one address can only win once. The owner regularly reseeds the secret
6  * seed of the contract (based on which the lucky addresses are chosen), so if you did not win,
7  * just wait for a reseed and try again! Contract addresses cannot play for obvious reasons.
8  *
9  * Ticket price: 0.1 ETH
10  * Jackpot chance:   1 in 8
11 */
12 contract AddressLottery{
13     struct SeedComponents{
14         uint component1;
15         uint component2;
16         uint component3;
17         uint component4;
18     }
19     
20     address owner;
21     uint private secretSeed;
22     uint private lastReseed;
23     
24     uint winnerLuckyNumber = 7;
25         
26     mapping (address => bool) participated;
27 
28 
29     function AddressLottery() {
30         owner = msg.sender;
31         reseed(SeedComponents(12345678, 0x12345678, 0xabbaeddaacdc, 0x22222222));
32     }
33     
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38   
39     modifier onlyHuman() {
40         require(msg.sender == tx.origin);
41         _;
42     }
43     
44     function participate() payable onlyHuman { 
45         require(msg.value == 0.1 ether);
46         
47         // every address can only win once, obviously
48         require(!participated[msg.sender]);
49         
50         if ( luckyNumberOfAddress(msg.sender) == winnerLuckyNumber)
51         {
52             participated[msg.sender] = true;
53             require(msg.sender.call.value(this.balance)());
54         }
55     }
56     
57     function luckyNumberOfAddress(address addr) constant returns(uint n){
58         // 1 in 8 chance
59         n = uint(keccak256(uint(addr), secretSeed)[0]) % 8;
60     }
61     
62     function reseed(SeedComponents components) internal{
63         secretSeed = uint256(keccak256(
64             components.component1,
65             components.component2,
66             components.component3,
67             components.component4
68         ));
69         lastReseed = block.number;
70     }
71     
72     function kill() onlyOwner {
73         suicide(owner);
74     }
75     
76     function forceReseed() onlyOwner{
77         SeedComponents s;
78         s.component1 = uint(msg.sender);
79         s.component2 = uint256(block.blockhash(block.number - 1));
80         s.component3 = block.number * 1337;
81         s.component4 = tx.gasprice * 7;
82         reseed(s);
83     }
84     
85     function () payable {}
86     
87     // DEBUG, DELETE BEFORE DEPLOYMENT!!
88     function _myLuckyNumber() constant returns(uint n){
89         n = luckyNumberOfAddress(msg.sender);
90     }
91 }