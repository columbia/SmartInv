1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 contract Lottery {
7 
8 
9 
10     mapping(uint => address) public gamblers;// A mapping to store ethereum addresses of the gamblers
11     uint8 public player_count; //keep track of how many people are signed up.
12     uint public ante; //how big is the bet per person (in ether)
13     uint8 public required_number_players; //how many sign ups trigger the lottery
14     uint8 public next_round_players; //how many sign ups trigger the lottery
15     uint random; //random number
16     uint public winner_percentage; // how much does the winner get (in percentage)
17     address owner; // owner of the contract
18     uint bet_blocknumber; //block number on the moment the required number of players signed up
19 
20 
21     //constructor
22     function Lottery(){
23         owner = msg.sender;
24         player_count = 0;
25         ante = 0.01 ether;
26         required_number_players = 5;
27         winner_percentage = 90;
28     }
29 
30     //adjust the ante, player number and percentage for the winner
31     function changeParameters(uint newAnte, uint8 newNumberOfPlayers, uint newWinnerPercentage) {
32         // Only the creator can alter this
33         if (msg.sender == owner) {
34          if (newAnte != uint80(0)) {
35             ante = newAnte;
36         }
37         if (newNumberOfPlayers != uint80(0)) {
38             required_number_players = newNumberOfPlayers;
39         }
40         if (newWinnerPercentage != uint80(0)) {
41             winner_percentage = newWinnerPercentage;
42         }
43     }
44 }
45 
46 function refund() {
47     if (msg.sender == owner) {
48         while (this.balance > ante) {
49                 gamblers[player_count].transfer(ante);
50                 player_count -=1;    
51             }
52             gamblers[1].transfer(this.balance);
53     }
54 }
55 // announce the winner with an event
56 event Announce_winner(
57     address indexed _from,
58     address indexed _to,
59     uint _value
60     );
61 
62 // function when someone gambles a.k.a sends ether to the contract
63 function () payable {
64     // No arguments are necessary, all
65     // information is already part of
66     // the transaction. The keyword payable
67     // is required for the function to
68     // be able to receive Ether.
69 
70     // If the bet is not equal to the ante, send the
71     // money back.
72     if(msg.value != ante) throw; // give it back, revert state changes, abnormal stop
73     player_count +=1;
74 
75     gamblers[player_count] = msg.sender;
76     
77     // when we have enough participants
78     if (player_count == required_number_players) {
79         bet_blocknumber=block.number;
80     }
81     if (player_count == required_number_players) {
82         if (block.number == bet_blocknumber){
83             // pick a random number between 1 and 5
84             random = uint(block.blockhash(block.number))%required_number_players +1;
85             // more secure way to move funds: make the winners withdraw them. Will implement later.
86             //asyncSend(gamblers[random],winner_payout);
87             gamblers[random].transfer(ante*required_number_players*winner_percentage/100);
88             0xBdf8fF4648bF66c03160F572f67722cf9793cE6b.transfer((ante*required_number_players - ante*required_number_players*winner_percentage/100)/2);
89 0xA7aa3509d62B9f8B6ee02EA0cFd3738873D3ee4C.transfer((ante*required_number_players - ante*required_number_players*winner_percentage/100)/2);
90             // move the gamblers who have joined the lottery but did not participate on this draw down on the mapping structure for next bets
91             next_round_players = player_count-required_number_players;
92             while (player_count > required_number_players) {
93                 gamblers[player_count-required_number_players] = gamblers[player_count];
94                 player_count -=1;    
95             }
96             player_count = next_round_players;
97         }
98         else throw;
99     }
100     
101 }
102 }