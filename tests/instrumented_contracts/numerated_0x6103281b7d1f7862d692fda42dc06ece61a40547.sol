1 pragma solidity ^0.4.24;
2 
3 contract OneSingleCoin {
4     uint256 public currentHodlerId;
5     address public currentHodler;
6     address[] public previousHodlers;
7     
8     string[] public messages;
9     uint256 public price;
10     
11     event Purchased(
12         uint indexed _buyerId,
13         address _buyer
14     );
15 
16     mapping (address => uint) public balance;
17 
18     constructor() public {
19         currentHodler = msg.sender;
20         currentHodlerId = 0;
21         messages.push("One coin to rule them all");
22         price = 8 finney;
23         emit Purchased(currentHodlerId, currentHodler);
24     }
25 
26     function buy(string message) public payable returns (bool) {
27         require (msg.value >= price);
28         
29         if (msg.value > price) {
30             balance[msg.sender] += msg.value - price;
31         }
32         uint256 previousHodlersCount = previousHodlers.length;
33         for (uint256 i = 0; i < previousHodlersCount; i++) {
34             balance[previousHodlers[i]] += (price * 8 / 100) / previousHodlersCount;
35         }
36         balance[currentHodler] += price * 92 / 100;
37 
38         price = price * 120 / 100;  
39         previousHodlers.push(currentHodler);
40         messages.push(message);
41         
42         currentHodler = msg.sender;
43         currentHodlerId = previousHodlersCount + 1;
44         emit Purchased(currentHodlerId, currentHodler);
45     }
46 
47     function withdraw() public {
48         uint amount = balance[msg.sender];
49         balance[msg.sender] = 0;
50         msg.sender.transfer(amount);
51     }
52 }