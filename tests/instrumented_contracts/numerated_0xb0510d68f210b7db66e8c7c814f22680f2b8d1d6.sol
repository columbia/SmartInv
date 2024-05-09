1 pragma solidity ^0.4.23;
2 
3 contract Splitter{
4     
5 	address public owner;
6 	address[] public puppets;
7 	mapping (uint256 => address) public extra;
8 	address private _addy;
9 	uint256 private _share;
10 	uint256 private _count;
11 
12 
13 //constructor
14 
15 	constructor() payable public{
16 		owner = msg.sender;
17 		newPuppet();
18 		newPuppet();
19 		newPuppet();
20 		newPuppet();
21 		extra[0] = puppets[0];
22         extra[1] = puppets[1];
23         extra[2] = puppets[2];
24         extra[3] = puppets[3];
25 	}
26 
27 //withdraw (just in case)
28 	
29 	function withdraw() public{
30 		require(msg.sender == owner);
31 		owner.transfer(address(this).balance);
32 	}
33 
34 //puppet count
35 
36 	function getPuppetCount() public constant returns(uint256 puppetCount){
37     	return puppets.length;
38   	}
39 
40 //deploy contracts
41 
42 	function newPuppet() public returns(address newPuppet){
43 	    require(msg.sender == owner);
44     	Puppet p = new Puppet();
45     	puppets.push(p);
46     	return p;
47   		}
48  
49 //update mapping
50 
51     function setExtra(uint256 _id, address _newExtra) public {
52         require(_newExtra != address(0));
53         extra[_id] = _newExtra;
54     }
55 
56 	
57 //fund puppets TROUBLESHOOT gas
58 
59     function fundPuppets() public payable {
60         require(msg.sender == owner);
61     	_share = SafeMath.div(msg.value, 4);
62         extra[0].call.value(_share).gas(800000)();
63         extra[1].call.value(_share).gas(800000)();
64         extra[2].call.value(_share).gas(800000)();
65         extra[3].call.value(_share).gas(800000)();
66         }
67         
68 //fallback function
69 
70 function() payable public{
71 	}
72 }
73 
74 
75 contract Puppet {
76     
77     mapping (uint256 => address) public target;
78     mapping (uint256 => address) public master;
79 	
80 	constructor() payable public{
81 		//target[0] = 0x42D21d1182F3aDD44064F23c1F98843D4B9fd8aa;
82 		target[0] = 0x509Cb8cB2F8ba04aE81eEC394175707Edd37e109;
83         master[0] = 0x5C035Bb4Cb7dacbfeE076A5e61AA39a10da2E956;
84 	}
85 	
86 	//send shares to doubler
87 	//return profit to master
88 
89 	function() public payable{
90 	    if(msg.sender != target[0]){
91 			target[0].call.value(msg.value).gas(600000)();
92 		}
93     }
94 	//emergency withdraw
95 
96 	function withdraw() public{
97 		require(msg.sender == master[0]);
98 		master[0].transfer(address(this).balance);
99 	}
100 }
101 
102 
103 //library
104 
105 library SafeMath {
106 
107   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
108     if (a == 0) {
109       return 0;
110     }
111     c = a * b;
112     assert(c / a == b);
113     return c;
114   }
115 
116   function div(uint256 a, uint256 b) internal pure returns (uint256) {
117     return a / b;
118   }
119 
120   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121     assert(b <= a);
122     return a - b;
123   }
124 
125   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
126     c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 }