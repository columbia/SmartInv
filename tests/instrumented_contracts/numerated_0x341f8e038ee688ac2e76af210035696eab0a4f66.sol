1 contract tradeReport {
2     struct trade {
3         string symbol;
4         string price;
5         string quantity;
6         string buyer;
7         string seller;
8         string execID;
9     }
10     address public publisher;
11     trade public lastTrade;
12 
13     function tradeReport() {
14         publisher = msg.sender;
15     }
16     
17     event Execution(string symbol, string price, string quantity, string buyer, string seller, string execID);
18     
19     function publishExecution(string symbol, string price, string quantity, string buyer, string seller, string execID) {
20         if (msg.sender != publisher)
21             throw;
22             
23         Execution(symbol, price, quantity, buyer, seller, execID);
24         lastTrade = trade(symbol, price, quantity, buyer, seller, execID);
25     }
26 }