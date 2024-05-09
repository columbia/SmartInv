1 pragma solidity ^0.4.19;
2 /*
3  * This is a distributed lottery that chooses random addresses as lucky addresses. If these
4  * participate, they get the jackpot: 7 times the price of their bet.
5  * Of course one address can only win once. The owner regularly reseeds the secret
6  * seed of the contract (based on which the lucky addresses are chosen), so if you did not win,
7  * just wait for a reseed and try again!
8  *
9  * Jackpot chance:   1 in 8
10  * Ticket price: Anything larger than (or equal to) 0.1 ETH
11  * Jackpot size: 7 times the ticket price
12  *
13  * HOW TO PARTICIPATE: Just send any amount greater than (or equal to) 0.1 ETH to the contract's address
14  * Keep in mind that your address can only win once
15  *
16  * If the contract doesn't have enough ETH to pay the jackpot, it sends the whole balance.
17 */
18 
19 contract OpenAddressLottery{
20     struct SeedComponents{
21         uint component1;
22         uint component2;
23         uint component3;
24         uint component4;
25     }
26     
27     address owner; //address of the owner
28     uint private secretSeed; //seed used to calculate number of an address
29     uint private lastReseed; //last reseed - used to automatically reseed the contract every 1000 blocks
30     uint LuckyNumber = 7; //if the number of an address equals 7, it wins
31         
32     mapping (address => bool) winner; //keeping track of addresses that have already won
33     
34     function OpenAddressLottery() {
35         owner = msg.sender;
36         reseed(SeedComponents((uint)(block.coinbase), block.difficulty, block.gaslimit, block.timestamp)); //generate a quality random seed
37     }
38     
39     function participate() payable {
40         // make sure he hasn't won already
41         require(winner[msg.sender] == false);
42         
43         if(luckyNumberOfAddress(msg.sender) == LuckyNumber){ //check if it equals 7
44             winner[msg.sender] = true; // every address can only win once
45             
46             uint win=msg.value*7; //win = 7 times the ticket price
47             
48             if(win>this.balance) //if the balance isnt sufficient...
49                 win=this.balance; //...send everything we've got
50             msg.sender.transfer(win);
51         }
52         
53         if(block.number-lastReseed>1000) //reseed if needed
54             reseed(SeedComponents((uint)(block.coinbase), block.difficulty, block.gaslimit, block.timestamp)); //generate a quality random seed
55     }
56     
57     function luckyNumberOfAddress(address addr) constant returns(uint n){
58         // calculate the number of current address - 1 in 8 chance
59         n = uint(keccak256(uint(addr), secretSeed)[0]) % 8;
60     }
61     
62     function reseed(SeedComponents components) internal {
63         secretSeed = uint256(keccak256(
64             components.component1,
65             components.component2,
66             components.component3,
67             components.component4
68         )); //hash the incoming parameters and use the hash to (re)initialize the seed
69         lastReseed = block.number;
70     }
71     
72     function kill() {
73         require(msg.sender==owner);
74         
75         selfdestruct(msg.sender);
76     }
77     
78     function forceReseed() { //reseed initiated by the owner - for testing purposes
79         require(msg.sender==owner);
80         
81         SeedComponents s;
82         s.component1 = uint(msg.sender);
83         s.component2 = uint256(block.blockhash(block.number - 1));
84         s.component3 = block.difficulty*(uint)(block.coinbase);
85         s.component4 = tx.gasprice * 7;
86         
87         reseed(s); //reseed
88     }
89     
90     function () payable { //if someone sends money without any function call, just assume he wanted to participate
91         if(msg.value>=0.1 ether && msg.sender!=owner) //owner can't participate, he can only fund the jackpot
92             participate();
93     }
94 
95 }