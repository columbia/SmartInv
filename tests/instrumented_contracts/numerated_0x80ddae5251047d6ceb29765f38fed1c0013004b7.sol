1 contract Lottery {
2     event GetBet(uint betAmount, uint blockNumber, bool won); 
3 
4     struct Bet {
5         uint betAmount;
6         uint blockNumber;
7         bool won;
8     }
9 
10     address private organizer;
11     Bet[] private bets;
12 
13     // Create a new lottery with numOfBets supported bets.
14     function Lottery() {
15         organizer = msg.sender;
16     }
17     
18     // Fallback function returns ether
19     function() {
20         throw;
21     }
22     
23     // Make a bet
24     function makeBet() {
25         // Won if block number is even
26         // (note: this is a terrible source of randomness, please don't use this with real money)
27         bool won = (block.number % 2) == 0; 
28         
29         // Record the bet with an event
30         bets.push(Bet(msg.value, block.number, won));
31         
32         // Payout if the user won, otherwise take their money
33         if(won) { 
34             if(!msg.sender.send(msg.value)) {
35                 // Return ether to sender
36                 throw;
37             } 
38         }
39     }
40     
41     // Get all bets that have been made
42     function getBets() {
43         if(msg.sender != organizer) { throw; }
44         
45         for (uint i = 0; i < bets.length; i++) {
46             GetBet(bets[i].betAmount, bets[i].blockNumber, bets[i].won);
47         }
48     }
49     
50     // Suicide :(
51     function destroy() {
52         if(msg.sender != organizer) { throw; }
53         
54         suicide(organizer);
55     }
56 }