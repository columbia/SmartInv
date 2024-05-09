1 pragma solidity ^0.4.4;
2 
3 contract mortal {
4     /* Define variable owner of the type address*/
5     address owner;
6 
7     /* this function is executed at initialization and sets the owner of the contract */
8     function mortal() { owner = msg.sender; }
9 
10     /* Function to recover the funds on the contract */
11     function kill() { if (msg.sender == owner) selfdestruct(owner); }
12 }
13 
14 
15 
16 
17 contract BananaBasket is mortal {
18     event HistoryUpdated(string picId, uint[] result);
19     address _owner;
20 
21     struct BasketState
22     {
23         //string picHash;
24         mapping (uint=>uint) ratings;
25     }
26 
27     mapping (string=>BasketState) basketStateHistory;
28 
29     
30 
31     function BananaBasket()
32     {
33         _owner = msg.sender;
34     }
35 
36     function addNewState(string id, uint[] memory ratings)
37     {
38         basketStateHistory[id] = BasketState();
39 
40         for (var index = 0;  index < ratings.length; ++index) {
41             basketStateHistory[id].ratings[index + 1] = ratings[index];
42         }
43 
44         HistoryUpdated(id, ratings);
45     }
46 
47 
48 
49     function getHistory(string id) constant 
50     returns(uint[5] ratings)
51     {
52         //pichash = id;
53         for (var index = 0;  index < 5; ++index) {
54             ratings[index] = basketStateHistory[id].ratings[index + 1];
55         }
56     }
57 }