1 contract Gamble {
2     address owner;
3     Bet[] bets;
4     address[] winners;
5 
6     struct Bet {
7         address sender;
8         int8 range;
9     }
10 
11     function Gamble() {
12         owner = msg.sender;
13     }
14 
15     function place (int8 range) public payable {
16         if (msg.value >= 50 finney && range <= 100) {
17             bets[bets.length++] = Bet({sender: msg.sender, range: range});
18         }
19     }
20 
21     function solve (int8 range) public {
22         if (msg.sender == owner && range <= 100) {
23             for (uint i = 0; i < bets.length; ++i) {
24                 if (bets[i].range == range) {
25                     winners[winners.length++] = bets[i].sender;
26                 }
27             }
28 
29             for (uint j = 0; j < winners.length; ++j) {
30                 winners[j].send(winners.length / this.balance);
31             }
32 
33             selfdestruct(owner);
34         }
35     }
36 }