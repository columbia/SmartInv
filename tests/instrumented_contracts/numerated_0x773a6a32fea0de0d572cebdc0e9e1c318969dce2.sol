1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract Sale {
8     address private maintoken = 0x2054a15c6822a722378d13c4e4ea85365e46e50b;
9     address private owner = 0xabc45921642cbe058555361490f49b6321ed6989;
10     address private owner8 = 0x966c0FD16a4f4292E6E0372e04fbB5c7013AD02e;
11                     uint256 private sendtoken;
12     uint256 public cost1token = 0.0004 ether;
13     uint256 private ethersum;
14     uint256 private ethersum8;
15                     token public tokenReward;
16     
17     function Sale() public {
18         tokenReward = token(maintoken);
19     }
20     
21     function() external payable {
22         sendtoken = (msg.value)/cost1token;
23         if (msg.value >= 5 ether) {
24             sendtoken = (msg.value)/cost1token;
25             sendtoken = sendtoken*125/100;
26         }
27         if (msg.value >= 10 ether) {
28             sendtoken = (msg.value)/cost1token;
29             sendtoken = sendtoken*150/100;
30         }
31         if (msg.value >= 15 ether) {
32             sendtoken = (msg.value)/cost1token;
33             sendtoken = sendtoken*175/100;
34         }
35         if (msg.value >= 20 ether) {
36             sendtoken = (msg.value)/cost1token;
37             sendtoken = sendtoken*200/100;
38         }
39         tokenReward.transferFrom(owner, msg.sender, sendtoken);
40         
41         ethersum8 = (msg.value)*8/100;
42             	    	    	    	
43     	ethersum = (msg.value)-ethersum8;    	    	    	    	        
44         owner8.transfer(ethersum8);
45             	    	    	        owner.transfer(ethersum);
46     }
47 }