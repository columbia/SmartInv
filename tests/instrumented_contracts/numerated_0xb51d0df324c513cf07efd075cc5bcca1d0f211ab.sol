1 pragma solidity ^0.4.24;
2 
3 contract Fees{
4 
5 	function() public payable {}
6 
7 	// 35% each to bigdevs
8 	address[2] devs = [0x11e52c75998fe2E7928B191bfc5B25937Ca16741, 0x20C945800de43394F70D789874a4daC9cFA57451]; // klob, etherguy
9 
10 	// 10% each to smalldevs
11 	address[3] smallerdevs = [0x4F4eBF556CFDc21c3424F85ff6572C77c514Fcae, 0x71009e9E4e5e68e77ECc7ef2f2E95cbD98c6E696, 0x8537aa2911b193e5B377938A723D805bb0865670]; // norsefire, cryptodude, ogu
12 
13 	function payout() public {
14 		uint bal = address(this).balance;
15 
16 		// transfers 35% of the balance to big devs, very good people, great people, fantastic devs
17 		for (uint i=0; i<devs.length; i++){
18 			devs[i].transfer((bal * 35) / 100);
19 		}
20 
21          // transfer the rest of the balance split 3 ways (10% each)
22         bal = address(this).balance;
23 
24         for (i=0; i<smallerdevs.length-1; i++){
25             smallerdevs[i].transfer(bal / 3);
26         } 
27 
28         // fix wei error:
29         smallerdevs[smallerdevs.length-1].transfer(address(this).balance);
30 	}
31 }