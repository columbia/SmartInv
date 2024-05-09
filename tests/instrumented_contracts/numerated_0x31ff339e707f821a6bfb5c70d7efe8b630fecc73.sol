1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4 
5   // Events ---------------------------
6 
7   event Transfer(address indexed _from, address indexed _to, uint _value);
8   event Approval(address indexed _owner, address indexed _spender, uint _value);
9 
10   // Functions ------------------------
11 
12   function totalSupply() constant returns (uint);
13   function balanceOf(address _owner) constant returns (uint balance);
14   function transfer(address _to, uint _value) returns (bool success);
15   function transferFrom(address _from, address _to, uint _value) returns (bool success);
16   function approve(address _spender, uint _value) returns (bool success);
17   function allowance(address _owner, address _spender) constant returns (uint remaining);
18 
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract TriipBooking is ERC20Interface {
51 
52 		using SafeMath for uint256;
53     
54     uint public constant _totalSupply = 50 * 10 ** 24;
55     
56     string public constant name = "TripBooking";
57     string public constant symbol = "TRP";
58     uint8 public constant decimals = 18;
59     
60     mapping(address => uint256) balances;
61     mapping(address => mapping(address=>uint256)) allowed;
62 
63 		uint256 public constant developmentTokens = 15 * 10 ** 24;
64     uint256 public constant bountyTokens = 2.5 * 10 ** 24;
65 		address public constant developmentTokensWallet = 0x27Aa956546Cd747D730CBd82b29a2Fa5b6BeE02a;
66 		address public constant bountyTokensWallet = 0xc377f0B79aD77996a15ED7eFb450DDC760a02b45;
67 
68 		uint public constant startTime = 1516406400;
69 
70     uint public constant endTime = 1520899140;
71 		uint256 public constant icoTokens = 32.5 * 10 ** 24;
72 		uint256 public totalCrowdsale;
73 
74 		 address public owner;
75     
76 	function TriipBooking() {
77 
78 		balances[developmentTokensWallet] = balanceOf(developmentTokensWallet).add(developmentTokens);
79 		Transfer(address(0), developmentTokensWallet, developmentTokens);
80 		balances[bountyTokensWallet] = balanceOf(bountyTokensWallet).add(bountyTokens);
81 		Transfer(address(0), bountyTokensWallet, bountyTokens);
82 
83 		// ToDo
84 		owner = msg.sender;
85 	}
86 
87 	function () payable {
88         createTokens();
89     }
90 	function createTokens() public payable {
91 			uint ts = atNow();
92 	    require(msg.value > 0 );
93 			require(ts < endTime );
94       require(ts >= startTime );
95 			uint256 tokens = msg.value.mul(getConversionRate());
96 			require(validPurchase(msg.value,tokens));
97 
98 	    balances[msg.sender] = balances[msg.sender].add(tokens);
99 			totalCrowdsale = totalCrowdsale.add(tokens);
100 			owner.transfer(msg.value);
101 	}	
102 	
103 	function totalSupply() constant returns (uint256 totalSupply) {
104 		return _totalSupply;
105 		
106 	}
107 	function balanceOf(address _owner) constant returns (uint256 balance)
108 	{
109 		// ToDo
110 		return balances[_owner];
111 	}
112 	function transfer(address _to, uint256 _value) returns (bool success){
113 		// ToDo
114 		require(
115 		    balances[msg.sender] >= _value
116 		    && _value > 0
117 		);
118 		balances[msg.sender] -= _value;
119 		balances[_to] += _value;
120 		Transfer(msg.sender,_to,_value);
121 		return true;
122 	}
123 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
124 		require(
125 		    allowed[_from][msg.sender] >= _value
126 		    && balances[_from] >= _value
127 		    && _value > 0
128 		);
129 		balances[_from] -= _value;
130 		balances[_to] += _value;
131 		allowed[_from][msg.sender] -= _value ;
132 		Transfer(_from, _to, _value);
133 		return true;
134 	}
135 	function approve(address _spender, uint256 _value) returns (bool success){
136 		allowed[msg.sender][_spender] = _value;
137 		Approval(msg.sender,_spender, _value);
138 		return true;
139 	}
140 	
141 	function allowance(address _owner, address _spender) constant returns (uint256 remaining){
142         return allowed[_owner][_spender];
143 	}
144 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
145   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
146 
147 	function getConversionRate() public constant returns (uint256) {
148 			uint ts = atNow();
149 			if (ts >= 1520294340) {
150 					return 3200;
151 			} else if (ts >= 1519689540) {
152 					return 3520;
153 			} else if (ts >= 1518998340) {
154 					return 3840;
155 			} else if (ts >= 1518307140 ) {
156 					return 4160;
157 			} else if (ts >= startTime) {
158 					return 4480;
159 			}
160 			return 0;
161 	}
162 	function validPurchase(uint256 _value, uint256 _tokens) internal constant returns (bool) {
163 			bool nonZeroPurchase = _value != 0;
164 			bool withinPeriod = now >= startTime && now <= endTime;
165 			bool withinICOTokens = totalCrowdsale.add(_tokens) <= icoTokens;
166 
167 			return nonZeroPurchase && withinPeriod && withinICOTokens;
168 
169 	}
170 	function atNow() constant public returns (uint) {
171     return now;
172   }
173 
174 }