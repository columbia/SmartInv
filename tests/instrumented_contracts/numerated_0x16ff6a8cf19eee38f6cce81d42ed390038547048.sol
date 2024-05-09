1 pragma solidity ^0.4.20;
2     
3 // Simple contract to split stakes coming into Locus | One Puzzle. 
4 // 80% of buy in goes to the jackpot, and the remaining 20% goes 
5 // to a dev wallet to support future puzzle development. 
6    
7 contract LocusOne {
8 
9     	address devAcct;
10     	address potAcct;
11     	uint fee;
12     	uint pot;
13         address public owner;
14         
15         // PAUSE EVENTS - onlyOwner can pause contract to lock new registration
16         // once the bounty has reached its goal.
17         
18         event Pause();
19         event Unpause();
20 
21         bool public paused = false;
22         
23         
24   modifier whenNotPaused() {
25     require(!paused);
26     _;
27   }
28 
29   modifier whenPaused() {
30     require(paused);
31     _;
32   }
33         
34     function LocusOne () public payable {
35         owner = msg.sender;
36     }
37     
38       modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43     function() public payable {
44     require (!paused);    
45     _split(msg.value);
46     }
47 
48     function _split(uint _stake) internal {
49         // protects users from staking less than the required amount to claim the bounty
50         require (msg.value >= 0.1 ether);
51         // Define the Locus dev account
52         devAcct = 0x1daa0BFDEDfB133ec6aEd2F66D64cA88BeC3f0B4;
53         // Define the Locus Pot account (what you're all playing for)      
54         potAcct = 0x708294833AEF21a305200b3463A832Ac97852f2e;
55 
56         // 20% of the total Ether sent will be used to pay devs/support project.
57         fee = div(_stake, 5);
58         
59         // The remaining amount of Ether wll be sent to fund/stake the pot.
60         pot = sub(_stake, fee);
61 
62         devAcct.transfer(fee);
63         potAcct.transfer(pot);
64 
65     }
66 
67 
68   function pause() onlyOwner whenNotPaused public {
69     paused = true;
70     emit Pause();
71   }
72 
73   function unpause() onlyOwner whenPaused public {
74     paused = false;
75     emit Unpause();
76   }
77 
78             // The below are safemath implementations of the four arithmetic operators
79     // designed to explicitly prevent over- and under-flows of integer values.
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85         uint256 c = a * b;
86         assert(c / a == b);
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         // assert(b > 0); // Solidity automatically throws when dividing by 0
92         uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         assert(b <= a);
99         return a - b;
100     }
101 
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         assert(c >= a);
105         return c;
106     }
107     // not needed until later
108     //function sumproduct(uint256 sn, uint256 %cl) internal pure returns (uint256) {
109     //    uint256 c = a * b;
110     //    assert(c / a == b);
111     //    return c;
112     //}
113  }