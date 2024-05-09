1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract B0xPresale is Ownable {
85 	using SafeMath for uint;
86 
87 	mapping (address => Investment[]) public received;  // mapping of investor address to Investment struct arrays
88 	address[] public investors;                     	// array of investors who have already send Ether
89 
90 	address public receiver1;
91 	address public receiver2;
92 	address public receiver3;
93 
94 	struct Investment {
95 		uint amount;
96 		uint blockNumber;
97 		uint blockTimestamp;
98 	}
99 
100 	function() 
101 		public
102 		payable
103 	{
104 		require(msg.value > 0);
105 		received[msg.sender].push(Investment({
106 			amount: msg.value,
107 			blockNumber: block.number,
108 			blockTimestamp: block.timestamp
109 		}));
110 		investors.push(msg.sender);
111 	}
112 
113 	function B0xPresale(
114 		address _receiver1,
115 		address _receiver2,
116 		address _receiver3)
117 		public
118 	{
119 		receiver1 = _receiver1;
120 		receiver2 = _receiver2;
121 		receiver3 = _receiver3;
122 	}
123 
124 	function withdraw()
125 		public
126 	{
127 		require(msg.sender == owner 
128 			|| msg.sender == receiver1 
129 			|| msg.sender == receiver2 
130 			|| msg.sender == receiver3);
131 
132 		var toSend = this.balance.mul(3).div(7);
133 		require(receiver1.send(toSend));
134 		require(receiver2.send(toSend));
135 		require(receiver3.send(this.balance)); // remaining balance goes to 3rd receiver
136 	}
137 
138 	function ownerWithdraw(
139 		address _receiver,
140 		uint amount
141 	)
142 		public
143 		onlyOwner
144 	{
145 		require(_receiver.send(amount));
146 	}
147 
148 	function setReceiver1(
149 		address _receiver
150 	)
151 		public
152 		onlyOwner
153 	{
154 		require(_receiver != address(0) && _receiver != receiver1);
155 		receiver1 = _receiver;
156 	}
157 
158 	function setReceiver2(
159 		address _receiver
160 	)
161 		public
162 		onlyOwner
163 	{
164 		require(_receiver != address(0) && _receiver != receiver2);
165 		receiver2 = _receiver;
166 	}
167 
168 	function setReceiver3(
169 		address _receiver
170 	)
171 		public
172 		onlyOwner
173 	{
174 		require(_receiver != address(0) && _receiver != receiver3);
175 		receiver3 = _receiver;
176 	}
177 
178 	function getInvestorsAddresses()
179 		public
180 		view
181 		returns (address[])
182 	{
183 		return investors;
184 	}
185 
186 	function getBalance()
187 		public
188 		view
189 		returns (uint)
190 	{
191 		return this.balance;
192 	}
193 }