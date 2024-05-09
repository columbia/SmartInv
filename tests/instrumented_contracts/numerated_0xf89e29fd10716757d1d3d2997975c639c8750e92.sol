1 contract GradualPonzi {
2     address[] public investors;
3     mapping (address => uint) public balances;
4     uint public constant MINIMUM_INVESTMENT = 1e15;
5 
6     function GradualPonzi () public {
7         investors.push(msg.sender);
8     }
9 
10     function () public payable {
11         require(msg.value >= MINIMUM_INVESTMENT);
12         uint eachInvestorGets = msg.value / investors.length;
13         for (uint i=0; i < investors.length; i++) {
14             balances[investors[i]] += eachInvestorGets;
15         }
16         investors.push(msg.sender);
17     }
18 
19     function withdraw () public {
20         uint payout = balances[msg.sender];
21         balances[msg.sender] = 0;
22         msg.sender.transfer(payout);
23     }
24 }