1 contract SimplePonzi {
2     address public currentInvestor;
3     uint public currentInvestment = 0;
4     
5     function () payable public {
6         require(msg.value > currentInvestment);
7         
8         // payout previous investor
9         currentInvestor.send(currentInvestment);
10 
11         // document new investment
12         currentInvestor = msg.sender;
13         currentInvestment = msg.value;
14 
15     }
16 }