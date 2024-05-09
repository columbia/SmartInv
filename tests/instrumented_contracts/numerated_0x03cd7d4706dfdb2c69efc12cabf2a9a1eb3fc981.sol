1 pragma solidity ^0.4.4;
2 
3 
4 contract SafeMath{
5   function safeMul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint a, uint b) internal returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17 	
18 	function safeSub(uint a, uint b) internal returns (uint) {
19     	assert(b <= a);
20     	return a - b;
21   }
22 
23 	function safeAdd(uint a, uint b) internal returns (uint) {
24     	uint c = a + b;
25     	assert(c >= a);
26     	return c;
27   }
28 	function assert(bool assertion) internal {
29 	    if (!assertion) {
30 	      throw;
31 	    }
32 	}
33 }
34 
35 
36 contract ERC20{
37 
38  	function totalSupply() constant returns (uint256 totalSupply) {}
39 	function balanceOf(address _owner) constant returns (uint256 balance) {}
40 	function transfer(address _recipient, uint256 _value) returns (bool success) {}
41 	function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
42 	function approve(address _spender, uint256 _value) returns (bool success) {}
43 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
44 
45 	event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
46 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 
48 
49 }
50 
51 contract Snbtoken is ERC20, SafeMath{
52 	
53 	mapping(address => uint256) balances;
54 
55 	uint256 public totalSupply;
56 
57 
58 	function balanceOf(address _owner) constant returns (uint256 balance) {
59 	    return balances[_owner];
60 	}
61 
62 	function transfer(address _to, uint256 _value) returns (bool success){
63 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
64 	    balances[_to] = safeAdd(balances[_to], _value);
65 	    Transfer(msg.sender, _to, _value);
66 	    return true;
67 	}
68 
69 	mapping (address => mapping (address => uint256)) allowed;
70 
71 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
72 	    var _allowance = allowed[_from][msg.sender];
73 	    
74 	    balances[_to] = safeAdd(balances[_to], _value);
75 	    balances[_from] = safeSub(balances[_from], _value);
76 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
77 	    Transfer(_from, _to, _value);
78 	    return true;
79 	}
80 
81 	function approve(address _spender, uint256 _value) returns (bool success) {
82 	    allowed[msg.sender][_spender] = _value;
83 	    Approval(msg.sender, _spender, _value);
84 	    return true;
85 	}
86 
87 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
88 	    return allowed[_owner][_spender];
89 	}
90 	string 	public name = "SNB - Network for the Blind";
91 	string 	public symbol = "SNB";
92 	uint 	public decimals = 0;
93 	uint 	public INITIAL_SUPPLY = 70000000;
94 
95 	function Snbtoken() {
96 	  totalSupply = INITIAL_SUPPLY;
97 	  balances[msg.sender] = INITIAL_SUPPLY;
98 	}
99 }
100 
101 contract SnbtokenICO is ERC20, SafeMath{
102 
103 	
104 	mapping(address => uint256) balances;
105 
106 	uint256 public totalSupply;
107 
108 
109 	function balanceOf(address _owner) constant returns (uint256 balance) {
110 	    return balances[_owner];
111 	}
112 
113 	function transfer(address _to, uint256 _value) returns (bool success){
114 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
115 	    balances[_to] = safeAdd(balances[_to], _value);
116 	    Transfer(msg.sender, _to, _value);
117 	    return true;
118 	}
119 
120 	mapping (address => mapping (address => uint256)) allowed;
121 
122 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
123 	    var _allowance = allowed[_from][msg.sender];
124 	    
125 	    balances[_to] = safeAdd(balances[_to], _value);
126 	    balances[_from] = safeSub(balances[_from], _value);
127 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
128 	    Transfer(_from, _to, _value);
129 	    return true;
130 	}
131 
132 	function approve(address _spender, uint256 _value) returns (bool success) {
133 	    allowed[msg.sender][_spender] = _value;
134 	    Approval(msg.sender, _spender, _value);
135 	    return true;
136 	}
137 
138 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
139 	    return allowed[_owner][_spender];
140 	}
141 
142 
143 
144 
145 	uint256 public endTime;
146 	uint256 public price;
147 
148 	modifier during_offering_time(){
149 
150 	    
151 	    
152 	    if(now>1513911600)
153 		{
154 				price 	= 2231;
155 		}
156 		else if(now>1513306800)
157 		{
158 		    	price 	= 2491;
159 		}
160 		else if(now>1512702000)
161 		{
162 		    	price 	= 2708;
163 		}
164 		else if(now>1512025200)
165 		{
166 		    	price 	= 3032;
167 		}
168         else if(now>1511589600) ///1511589600 ///1511938800
169 		{
170 		    	price 	= 3249;
171 		}
172 		else
173 		{
174 		        price 	= 500;
175 		}
176 	    
177 	    
178 	    
179 		if (now >= endTime){
180 			throw;
181 		}else{
182 			_;
183 		}
184 	}
185 
186 	function () payable during_offering_time {
187 		createTokens(msg.sender);
188 	}
189 
190 	function createTokens(address recipient) payable {
191 		if (msg.value == 0) {
192 		  throw;
193 		}
194 
195 
196 		uint tokens = safeDiv(safeMul(msg.value, price), 1 ether);
197 		totalSupply = safeAdd(totalSupply, tokens);
198 
199 		balances[recipient] = safeAdd(balances[recipient], tokens);
200 
201 		if (!owner.send(msg.value)) {
202 		  throw;
203 		}
204 	}
205 
206 
207 
208 
209 	string 	public name = "SNB - Network for the Blind";
210 	string 	public symbol = "SNB";
211 	uint 	public decimals = 0;
212 	uint256 public INITIAL_SUPPLY = 70000000;
213 	uint256 public SALES_SUPPLY = 130000000;
214 	address public owner;
215 
216 	function SnbtokenICO() {
217 		totalSupply = INITIAL_SUPPLY;
218 		balances[msg.sender] = INITIAL_SUPPLY;
219 
220 		owner 	= msg.sender;
221 
222 		price 	= 500;
223 				
224 
225 
226 		endTime = 1514617200;
227 	}
228 
229 }