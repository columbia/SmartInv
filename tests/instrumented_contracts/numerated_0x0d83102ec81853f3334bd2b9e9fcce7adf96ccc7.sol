1 /*
2  * This is a distributed lottery that chooses random addresses as lucky addresses. If these
3  * participate, they get the jackpot: 1.9 times the price of their bet.
4  * Of course one address can only win once. The owner regularly reseeds the secret
5  * seed of the contract (based on which the lucky addresses are chosen), so if you did not win,
6  * just wait for a reseed and try again!
7  *
8  * Jackpot chance:   50%
9  * Ticket price: Anything larger than (or equal to) 0.1 ETH
10  * Jackpot size: 1.9 times the ticket price
11  *
12  * HOW TO PARTICIPATE: Just send any amount greater than (or equal to) 0.1 ETH to the contract's address
13  * Keep in mind that your address can only win once
14  *
15  * If the contract doesn't have enough ETH to pay the jackpot, it sends the whole balance.
16  *
17  * Example: For each address, a random number is generated, either 0 or 1. This number is then compared
18  * with the LuckyNumber - a constant 1. If they are equal, the contract will instantly send you the jackpot:
19  * your bet multiplied by 1.9 (House edge of 0.1)
20 */
21 
22 contract OpenAddressLottery{
23     struct SeedComponents{
24         uint component1;
25         uint component2;
26         uint component3;
27         uint component4;
28     }
29     
30     address owner; //address of the owner
31     uint private secretSeed; //seed used to calculate number of an address
32     uint private lastReseed; //last reseed - used to automatically reseed the contract every 1000 blocks
33     uint LuckyNumber = 1; //if the number of an address equals 1, it wins
34         
35     mapping (address => bool) winner; //keeping track of addresses that have already won
36     
37     function OpenAddressLottery() {
38         owner = msg.sender;
39         reseed(SeedComponents((uint)(block.coinbase), block.difficulty, block.gaslimit, block.timestamp)); //generate a quality random seed
40     }
41     
42     function participate() payable {
43         if(msg.value<0.1 ether)
44             return; //verify ticket price
45         
46         // make sure he hasn't won already
47         require(winner[msg.sender] == false);
48         
49         if(luckyNumberOfAddress(msg.sender) == LuckyNumber){ //check if it equals 1
50             winner[msg.sender] = true; // every address can only win once
51             
52             uint win=(msg.value/10)*19; //win = 1.9 times the ticket price
53             
54             if(win>this.balance) //if the balance isnt sufficient...
55                 win=this.balance; //...send everything we've got
56             msg.sender.transfer(win);
57         }
58         
59         if(block.number-lastReseed>1000) //reseed if needed
60             reseed(SeedComponents((uint)(block.coinbase), block.difficulty, block.gaslimit, block.timestamp)); //generate a quality random seed
61     }
62     
63     function luckyNumberOfAddress(address addr) constant returns(uint n){
64         // calculate the number of current address - 50% chance
65         n = uint(keccak256(uint(addr), secretSeed)[0]) % 2; //mod 2 returns either 0 or 1
66     }
67     
68     function reseed(SeedComponents components) internal {
69         secretSeed = uint256(keccak256(
70             components.component1,
71             components.component2,
72             components.component3,
73             components.component4
74         )); //hash the incoming parameters and use the hash to (re)initialize the seed
75         lastReseed = block.number;
76     }
77     
78     function kill() {
79         require(msg.sender==owner);
80         
81         selfdestruct(msg.sender);
82     }
83     
84     function forceReseed() { //reseed initiated by the owner - for testing purposes
85         require(msg.sender==owner);
86         
87         SeedComponents s;
88         s.component1 = uint(msg.sender);
89         s.component2 = uint256(block.blockhash(block.number - 1));
90         s.component3 = block.difficulty*(uint)(block.coinbase);
91         s.component4 = tx.gasprice * 7;
92         
93         reseed(s); //reseed
94     }
95     
96     function () payable { //if someone sends money without any function call, just assume he wanted to participate
97         if(msg.value>=0.1 ether && msg.sender!=owner) //owner can't participate, he can only fund the jackpot
98             participate();
99     }
100 
101 }