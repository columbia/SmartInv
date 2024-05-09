1 pragma solidity ^0.5.0;
2 
3 /*   
4 Developer Telegram    : @MyEtherStoreTeam
5 
6 
7 MyEtherStore......MyEtherStore.......MyEtherStore........MyEtherStore........MyEtherStore
8 
9                                         
10                                         Profit Table
11 
12                *Entry With*              *Doubles*                *Retuns Out*
13                  0.05 ETH                   2X                      0.10 ETH  
14                  0.10 ETH                   2X                      0.20 ETH 
15                  0.25 ETH                   2X                      0.50 ETH
16                  0.50 ETH                   2X                      1.00 ETH 
17                  1.00 ETH                   2X                      2.00 ETH 
18                  1.50 ETH                   2X                      3.00 ETH 
19                  2.00 ETH                   2X                      4.00 ETH 
20                  2.50 ETH                   2X                      5.00 ETH 
21                  3.00 ETH                   2X                      6.00 ETH 
22                  3.50 ETH                   2X                      7.00 ETH 
23                  4.00 ETH                   2X                      8.00 ETH
24                  4.50 ETH                   2X                      9.00 ETH
25                  5.00 ETH                   2X                      10.0 ETH
26                  
27                    
28 MyEtherStore......MyEtherStore.......MyEtherStore........MyEtherStore........MyEtherStore
29 */
30 
31 library SafeMath {
32     
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43     
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50    
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58 
59         return c;
60     }
61    
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65   
66     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         // Solidity only automatically asserts when dividing by 0
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74    
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78 
79     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84 //owner change function
85 contract Owned {
86     address payable public owner;
87     address payable public newOwner;
88 
89     event OwnershipTransferred(address payable indexed _from, address payable indexed _to);
90 
91     constructor() public {
92         owner = msg.sender;
93     }
94 
95     modifier onlyOwner {
96         require(msg.sender == owner);
97         _;
98     }
99 
100     function transferOwnership(address payable _newOwner) public onlyOwner {
101         owner = _newOwner;
102     }
103     function acceptOwnership() public {
104         require(msg.sender == newOwner);
105         emit OwnershipTransferred(owner, newOwner);
106         owner = newOwner;
107         newOwner = address(0);
108     }
109 }
110 
111 
112 contract MyEtherStore is Owned{
113 
114 	using SafeMath for uint;
115 
116 	//address payable public owner;
117 
118 	struct User {
119 		address payable addr;
120 		uint amount;
121 	}
122 
123 	User[] public users;
124 	uint public currentlyPaying = 0;
125 	uint public totalUsers = 0;
126 	uint public totalWei = 0;
127 	uint public totalPayout = 0;
128 	bool public active;
129 	uint256 public minAmount=0.05 ether;
130 	uint256 public maxAmount=5.00 ether;
131 
132 	constructor() public {
133 		owner = msg.sender;
134 		active = true;
135 	}
136 	
137 	function contractActivate() public{
138 	    require(msg.sender==owner);
139 	    require(active == false, "Contract is already active");
140 	    active=true;
141 	}
142 	function contractDeactivate() public{
143 	    require(msg.sender==owner);
144 	    require(active == true, "Contract must be active");
145 	    active=false;
146 	}
147 	
148 	function limitAmount(uint256 min , uint256 max) public{
149 	    require(msg.sender==owner, "Cannot call function unless owner");
150 	    minAmount=min;
151 	    maxAmount=max;
152 	}
153 
154 	function close() public{
155 		require(msg.sender == owner, "Cannot call function unless owner");
156 		require(active == true, "Contract must be active");
157 		require(address(this).balance > 0, "This contract must have a balane above zero");
158 		owner.transfer(address(this).balance);
159 		active = false;
160 	}
161 
162 	
163 	function() external payable{
164 	    require(active==true ,"Contract must be active");
165 	    require(msg.value>=minAmount,"Amount is less than minimum amount");
166 	    require(msg.value<=maxAmount,"Amount Exceeds the Maximum amount");
167 		users.push(User(msg.sender, msg.value));
168 		totalUsers += 1;
169 		totalWei += msg.value;
170 
171 		owner.transfer(msg.value.div(10));
172 		while (address(this).balance > users[currentlyPaying].amount.mul(2)) {
173 			uint sendAmount = users[currentlyPaying].amount.mul(2);
174 			users[currentlyPaying].addr.transfer(sendAmount);
175 			totalPayout += sendAmount;
176 			currentlyPaying += 1;
177 		}
178 	}
179 	
180 	function join() external payable{
181 	    require(active==true ,"Contract must be active");
182 	    require(msg.value>=minAmount,"Amount is less than minimum amount");
183 	    require(msg.value<=maxAmount,"Amount Exceeds the Maximum amount");
184 		users.push(User(msg.sender, msg.value));
185 		totalUsers += 1;
186 		totalWei += msg.value;
187 
188 		owner.transfer(msg.value.div(10));
189 		while (address(this).balance > users[currentlyPaying].amount.mul(2)) {
190 			uint sendAmount = users[currentlyPaying].amount.mul(2);
191 			users[currentlyPaying].addr.transfer(sendAmount);
192 			totalPayout += sendAmount;
193 			currentlyPaying += 1;
194 		}
195 	}
196 }