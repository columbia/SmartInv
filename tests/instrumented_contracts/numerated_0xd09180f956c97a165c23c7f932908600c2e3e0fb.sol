1 contract SimplePonzi {
2     address public currentInvestor;
3     uint public currentInvestment = 0;
4     
5     function () payable public {
6         // new investments must be 10% greater than current
7         uint minimumInvestment = currentInvestment * 11 / 10;
8         require(msg.value > minimumInvestment);
9 
10         // document new investor
11         address previousInvestor = currentInvestor;
12         currentInvestor = msg.sender;
13         currentInvestment = msg.value;
14 
15         
16         // payout previous investor
17         previousInvestor.send(msg.value);
18     }
19 }