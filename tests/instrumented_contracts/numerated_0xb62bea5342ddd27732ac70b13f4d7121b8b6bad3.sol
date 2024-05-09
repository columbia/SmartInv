1 pragma solidity >=0.5.12;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract owned {
38     address public owner;
39 
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address newOwner) onlyOwner public {
50         require(newOwner != address(this));
51         owner = newOwner;
52     }
53 }
54 
55 contract Token {
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
57     function transfer(address _to, uint256 _value) public returns (bool success);
58 	function balanceOf(address account) external view returns (uint256);
59 	
60 }
61 
62 contract PubeTokenSale is owned {
63 	using SafeMath for uint;
64 	Token public tokenAddress;
65     bool public initialized = false;
66 
67 	address public receiverAddress;
68 	
69 	uint public rate = 4000000000000;
70 	uint public start = 1617811200;
71 	uint public last = 1640966340;
72 	
73 	uint public pre_sale = 40;
74     uint public bonus_1 = 30;
75     uint public bonus_2 = 20;
76     uint public bonus_3 = 15;
77     uint public bonus_4 = 10;
78     uint public bonus_5 = 5;
79 	
80     event Initialized();
81     event WithdrawTokens(address destination, uint256 amount);
82     event WithdrawAnyTokens(address tokenAddress, address destination, uint256 amount);
83     event WithdrawEther(address destination, uint256 amount);
84 	
85 
86 	/**
87      * Constructor
88      *
89      * First time rules setup 
90      */
91     constructor() payable public {
92     }
93 
94 
95     /**
96      * Initialize contract
97      *
98      * @param _tokenAddress token address
99      */
100     function init(Token _tokenAddress) onlyOwner public {
101         require(!initialized);
102         initialized = true;
103         tokenAddress = _tokenAddress;
104         emit Initialized();
105     }
106 
107 
108     /**
109      * withdrawTokens
110      *
111      * Withdraw tokens from the contract
112      *
113      * @param amount is an amount of tokens
114      */
115     function withdrawTokens(
116         uint256 amount
117     )
118         onlyOwner public
119     {
120         require(initialized);
121         tokenAddress.transfer(msg.sender, amount);
122         emit WithdrawTokens(msg.sender, amount);
123     }
124 
125     /**
126      * withdrawAnyTokens
127      *
128      * Withdraw any tokens from the contract
129      *
130      * @param _tokenAddress is a token contract address
131      * @param amount is an amount of tokens
132      */
133     function withdrawAnyTokens(
134         address _tokenAddress,
135         uint256 amount
136     )
137         onlyOwner public
138     {
139         Token(_tokenAddress).transfer(msg.sender, amount);
140         emit WithdrawAnyTokens(_tokenAddress, msg.sender, amount);
141     }
142     
143     /**
144      * withdrawEther
145      *
146      * Withdraw ether from the contract
147      *
148      * @param amount is a wei amount 
149      */
150     function withdrawEther(
151         uint256 amount
152     )
153         onlyOwner public
154     {
155         msg.sender.transfer(amount);
156         emit WithdrawEther(msg.sender, amount);
157     }
158 	
159 	modifier SaleOnGoing() {
160     require(now > start - 28 days && now < last);
161     _;
162 	}
163 	
164 	function setRate(uint _rate) public onlyOwner {
165 		rate = _rate;
166 	}
167 	
168 	function setStart(uint _start) public onlyOwner {
169 		start = _start;
170 	}
171 	
172 	function setLast(uint _last) public onlyOwner {
173 		last = _last;
174 	}
175 	function setReceiver(address _receiverAddress) public onlyOwner {
176 		receiverAddress = _receiverAddress;
177 	}
178 	
179 	function SetSale(uint _pre_sale, uint _bonus_1, uint _bonus_2, uint _bonus_3, uint _bonus_4, uint _bonus_5) public onlyOwner {
180 		pre_sale = _pre_sale;
181 		bonus_1 = _bonus_1;
182 		bonus_2 = _bonus_2;
183 		bonus_3 = _bonus_3;
184 		bonus_4 = _bonus_4;
185 		bonus_5 = _bonus_5; 
186 	}
187 	
188 	/**
189      * Execute transaction
190      *
191      * @param transactionBytecode transaction bytecode
192      */
193     function execute(bytes memory transactionBytecode) onlyOwner public {
194         require(initialized);
195         (bool success, ) = msg.sender.call.value(0)(transactionBytecode);
196             require(success);
197     }
198 	
199 	
200 	function BuyPubes() SaleOnGoing payable public {
201 		address payable wallet = address(uint160(receiverAddress));
202 		
203 		uint tokens = rate.mul(msg.value).div(1 ether);
204 		wallet.transfer(msg.value);
205 		
206 		uint BonusPubes = 0;
207 		
208 		if(now < start)  {
209 			BonusPubes = tokens.div(100).mul(pre_sale);
210 		} else if(now >= start && now < start + 7 days) { 	// 1st week
211 			BonusPubes = tokens.div(100).mul(bonus_1);
212 		} else if(now >= start && now < start + 14 days) { 	// 2nd week
213 			BonusPubes = tokens.div(100).mul(bonus_2);
214 		} else if(now >= start && now < start + 21 days) { 	// 3rd week
215 			BonusPubes = tokens.div(100).mul(bonus_3);
216 		} else if(now >= start && now < start + 28 days) { 	// 4th week
217 			BonusPubes = tokens.div(100).mul(bonus_4);
218 		} else if(now >= start && now < start + 49 days) { 	// 5th-7th week
219 			BonusPubes = tokens.div(100).mul(bonus_5);
220 		} 
221 		
222 		uint amountTobuy = msg.value;
223 		uint TotalWithBonus = tokens.add(BonusPubes);
224 		
225         uint TokenLeft = Token(tokenAddress).balanceOf(address(this));
226         require(amountTobuy > 0, "You need to send some Ether");
227         require(TotalWithBonus <= TokenLeft, "Not enough tokens available");
228 		
229 		
230         Token(tokenAddress).transfer(msg.sender, TotalWithBonus);
231 		
232 	}
233 
234 	function() external payable {
235 		BuyPubes();
236 	}
237 	
238 }