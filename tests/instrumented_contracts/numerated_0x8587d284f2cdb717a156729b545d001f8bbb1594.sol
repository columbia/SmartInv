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
56     string public constant name = "TriipBooking";
57     string public constant symbol = "TRP";
58     uint8 public constant decimals = 18;
59     
60     mapping(address => uint256) balances;
61     mapping(address => mapping(address=>uint256)) allowed;
62 
63 		uint256 public constant developmentTokens = 15 * 10 ** 24;
64     uint256 public constant bountyTokens = 2.5 * 10 ** 24;
65 		address public constant developmentTokensWallet = 0x2De3a11A5C1397CeFeA81D844C3173629e19a630;
66 		address public constant bountyTokensWallet = 0x7E2435A1780a7E4949C059045754a98894215665;
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
99 			Transfer(address(0), msg.sender, tokens);
100 			totalCrowdsale = totalCrowdsale.add(tokens);
101 			owner.transfer(msg.value);
102 	}	
103 	
104 	function totalSupply() constant returns (uint256 totalSupply) {
105 		return _totalSupply;
106 		
107 	}
108 	function balanceOf(address _owner) constant returns (uint256 balance)
109 	{
110 		// ToDo
111 		return balances[_owner];
112 	}
113 	function transfer(address _to, uint256 _value) returns (bool success){
114 		// ToDo
115 		require(
116 		    balances[msg.sender] >= _value
117 		    && _value > 0
118 		);
119 		balances[msg.sender] -= _value;
120 		balances[_to] += _value;
121 		Transfer(msg.sender,_to,_value);
122 		return true;
123 	}
124 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
125 		require(
126 		    allowed[_from][msg.sender] >= _value
127 		    && balances[_from] >= _value
128 		    && _value > 0
129 		);
130 		balances[_from] -= _value;
131 		balances[_to] += _value;
132 		allowed[_from][msg.sender] -= _value ;
133 		Transfer(_from, _to, _value);
134 		return true;
135 	}
136 	function approve(address _spender, uint256 _value) returns (bool success){
137 		allowed[msg.sender][_spender] = _value;
138 		Approval(msg.sender,_spender, _value);
139 		return true;
140 	}
141 	
142 	function allowance(address _owner, address _spender) constant returns (uint256 remaining){
143         return allowed[_owner][_spender];
144 	}
145 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
146   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
147 
148 	function getConversionRate() public constant returns (uint256) {
149 			uint ts = atNow();
150 			if (ts >= 1520294340) {
151 					return 3200;
152 			} else if (ts >= 1519689540) {
153 					return 3520;
154 			} else if (ts >= 1518998340) {
155 					return 3840;
156 			} else if (ts >= 1518307140 ) {
157 					return 4160;
158 			} else if (ts >= startTime) {
159 					return 4480;
160 			}
161 			return 0;
162 	}
163 	function validPurchase(uint256 _value, uint256 _tokens) internal constant returns (bool) {
164 			bool nonZeroPurchase = _value != 0;
165 			bool withinPeriod = now >= startTime && now <= endTime;
166 			bool withinICOTokens = totalCrowdsale.add(_tokens) <= icoTokens;
167 
168 			return nonZeroPurchase && withinPeriod && withinICOTokens;
169 
170 	}
171 	function atNow() constant public returns (uint) {
172     return now;
173   }
174 
175 }