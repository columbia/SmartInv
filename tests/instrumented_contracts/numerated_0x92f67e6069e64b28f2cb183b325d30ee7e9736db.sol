1 pragma solidity ^0.4.20;
2     
3 contract LocusOne {
4 
5     	address devAcct;
6     	address potAcct;
7     	uint fee;
8     	uint pot;
9 
10     function() public payable {
11         
12     _split(msg.value); 
13     }
14 
15     function _split(uint _stake) internal {
16         if (msg.value < 0.05 ether || msg.value > 1000000 ether)
17             revert();
18         // Define the Locus dev account
19         devAcct = 0x1daa0BFDEDfB133ec6aEd2F66D64cA88BeC3f0B4;
20         // Define the Locus Pot account (what you're all playing for)      
21         potAcct = 0x708294833AEF21a305200b3463A832Ac97852f2e;        
22         // msg.sender is the address of the caller.
23 
24         // 20% of the total Ether sent will be used to pay devs/support project.
25         fee = div(_stake, 5);
26         
27         // The remaining amount of Ether wll be sent to fund/stake the pot.
28         pot = sub(_stake, fee);
29 
30         devAcct.transfer(fee);
31         potAcct.transfer(pot);
32 
33     }
34 
35             // The below are safemath implementations of the four arithmetic operators
36     // designed to explicitly prevent over- and under-flows of integer values.
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         assert(c / a == b);
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // assert(b > 0); // Solidity automatically throws when dividing by 0
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         assert(b <= a);
56         return a - b;
57     }
58 
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         assert(c >= a);
62         return c;
63     }
64     // not needed until later
65     //function sumproduct(uint256 sn, uint256 %cl) internal pure returns (uint256) {
66     //    uint256 c = a * b;
67     //    assert(c / a == b);
68     //    return c;
69     //}
70  }