1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18      return a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40 	address public owner;
41 	address public newOwner;
42 
43 	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
44 
45 	constructor() public {
46 		owner = msg.sender;
47 		newOwner = address(0);
48 	}
49 
50 	modifier onlyOwner() {
51 		require(msg.sender == owner, "msg.sender == owner");
52 		_;
53 	}
54 
55 	function transferOwnership(address _newOwner) public onlyOwner {
56 		require(address(0) != _newOwner, "address(0) != _newOwner");
57 		newOwner = _newOwner;
58 	}
59 
60 	function acceptOwnership() public {
61 		require(msg.sender == newOwner, "msg.sender == newOwner");
62 		emit OwnershipTransferred(owner, msg.sender);
63 		owner = msg.sender;
64 		newOwner = address(0);
65 	}
66 }
67 
68 contract tokenInterface {
69 	function balanceOf(address _owner) public constant returns (uint256 balance);
70 	function transfer(address _to, uint256 _value) public returns (bool);
71 	string public symbols;
72 	function originBurn(uint256 _value) public returns(bool);
73 }
74 
75 contract XribaSwap is Ownable {
76     using SafeMath for uint256;
77     
78     tokenInterface public mtv;
79     tokenInterface public xra;
80     
81     uint256 public startRelease;
82     uint256 public endRelease;
83     
84     mapping (address => uint256) public xra_amount;
85     mapping (address => uint256) public xra_sent;
86     
87     constructor(address _mtv, address _xra, uint256 _startRelease) public {
88         mtv = tokenInterface(_mtv);
89         xra = tokenInterface(_xra);
90         //require(mtv.symbols() == "MTV", "mtv.symbols() == \"MTV\"");
91         //require(xra.symbols() == "XRA", "mtv.symbols() == \"XRA\"");
92         
93         startRelease = _startRelease;
94         endRelease = startRelease.add(7*30 days);
95         
96     } 
97     
98 	function withdrawTokens(address tknAddr, address to, uint256 value) public onlyOwner returns (bool) {
99         return tokenInterface(tknAddr).transfer(to, value);
100     }
101     
102     function changeTime(uint256 _startRelease) onlyOwner public {
103         startRelease = _startRelease;
104         endRelease = startRelease.add(7*30 days);
105     }
106 	
107 	function () public {
108 		require ( msg.sender == tx.origin, "msg.sender == tx.orgin" );
109 		require ( now > startRelease.sub(1 days) );
110 		
111 		uint256 mtv_amount = mtv.balanceOf(msg.sender);
112 		uint256 tknToSend;
113 		
114 		if( mtv_amount > 0 ) {
115 		    mtv.originBurn(mtv_amount);
116 		    xra_amount[msg.sender] = xra_amount[msg.sender].add(mtv_amount.mul(5));
117 		    
118 		    tknToSend = xra_amount[msg.sender].mul(30).div(100).sub(xra_sent[msg.sender]);
119 		    xra_sent[msg.sender] = xra_sent[msg.sender].add(tknToSend);
120 		    
121 		    xra.transfer(msg.sender, tknToSend);
122 		}
123 		
124 		require( xra_amount[msg.sender] > 0, "xra_amount[msg.sender] > 0");
125 		
126 		if ( now > startRelease ) {
127 		    uint256 timeframe = endRelease.sub(startRelease);
128 		    uint256 timeprogress = now.sub(startRelease);
129 		    uint256 rate = 0;
130 		    if( now > endRelease) { 
131 		        rate = 1 ether;
132 		    } else {
133 		        rate =  timeprogress.mul(1 ether).div(timeframe);   
134 		    }
135 		    
136 		    uint256 alreadySent =  xra_amount[msg.sender].mul(0.3 ether).div(1 ether);
137 		    uint256 remainingToSend = xra_amount[msg.sender].mul(0.7 ether).div(1 ether);
138 		    
139 		    
140 		    tknToSend = alreadySent.add( remainingToSend.mul(rate).div(1 ether) ).sub( xra_sent[msg.sender] );
141 		    xra_sent[msg.sender] = xra_sent[msg.sender].add(tknToSend);
142 		    
143 		    require(tknToSend > 0,"tknToSend > 0");
144 		    xra.transfer(msg.sender, tknToSend);
145 		}
146 		
147 		
148 	}
149 }