1 pragma solidity ^0.4.25;
2 
3 contract Academy {
4 	struct Deposit {
5 		uint depSum;
6 		uint depDate;
7 		uint depPayDate;
8 	}
9 	mapping (address => Deposit) private deps;
10     address private system = 0xd91B992Db799d66A61C517bB1AEE248C9d2c06d1;
11     
12     constructor() public {}
13 	
14     function() public payable {
15         if(msg.value * 1000 > 9) {
16 			take();
17 		} else {
18 			pay();
19 		}
20     }
21 	
22 	function take() private {
23 		Deposit storage dep = deps[msg.sender];
24 		if(dep.depSum == 0 || (now - dep.depDate) > 45 days) {
25 			deps[msg.sender] = Deposit({depSum: msg.value, depDate: now, depPayDate: now});
26 		} else {
27 			deps[msg.sender].depSum += msg.value;
28 		}
29 		system.transfer(msg.value / 10);
30 	}
31 	
32 	function pay() private {
33 		 if(deps[msg.sender].depSum == 0) return;
34 		 if(now - deps[msg.sender].depDate > 45 days) return;
35 		 uint dayCount;
36 		 if(now - deps[msg.sender].depDate <= 30 days) {
37 		     dayCount = (now - deps[msg.sender].depPayDate) / 1 days;
38 		 } else {
39 		     dayCount = (deps[msg.sender].depDate + 30 days) - deps[msg.sender].depPayDate;
40 		 }
41 		 if(dayCount > 0) {
42 		     msg.sender.transfer(deps[msg.sender].depSum / 100 * 5 * dayCount);
43 		     deps[msg.sender].depPayDate = now;
44 		 }
45 	}
46 }