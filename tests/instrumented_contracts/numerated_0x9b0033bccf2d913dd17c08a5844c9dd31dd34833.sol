1 contract SimplePyramid {
2     uint public constant MINIMUM_INVESTMENT = 1e15; // 0.001 ether
3     uint public numInvestors = 0;
4     uint public depth = 0;
5     address[] public investors;
6     mapping(address => uint) public balances;
7 
8     function SimplePyramid () public payable {
9         require(msg.value >= MINIMUM_INVESTMENT);
10         investors.length = 3;
11         investors[0] = msg.sender;
12         numInvestors = 1;
13         depth = 1;
14         balances[address(this)] = msg.value;
15     }
16    
17     function () payable public {
18         require(msg.value >= MINIMUM_INVESTMENT);
19         balances[address(this)] += msg.value;
20 
21         numInvestors += 1;
22         investors[numInvestors - 1] = msg.sender;
23 
24         if (numInvestors == investors.length) {
25             // pay out previous layer
26             uint endIndex = numInvestors - 2**depth;
27             uint startIndex = endIndex - 2**(depth-1);
28             for (uint i = startIndex; i < endIndex; i++)
29                 balances[investors[i]] += MINIMUM_INVESTMENT;
30 
31             // spread remaining ether among all participants
32             uint paid = MINIMUM_INVESTMENT * 2**(depth-1);
33             uint eachInvestorGets = (balances[address(this)] - paid) / numInvestors;
34             for(i = 0; i < numInvestors; i++)
35                 balances[investors[i]] += eachInvestorGets;
36 
37             // update state variables
38             balances[address(this)] = 0;
39             depth += 1;
40             investors.length += 2**depth;
41         }
42     }
43 
44     function withdraw () public {
45         uint payout = balances[msg.sender];
46         balances[msg.sender] = 0;
47         msg.sender.transfer(payout);
48     }
49 }