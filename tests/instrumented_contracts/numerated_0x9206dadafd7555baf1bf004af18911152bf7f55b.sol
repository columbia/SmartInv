1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4 	function mul(uint a, uint b) internal returns(uint) {
5 		uint c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8 	}
9 
10 	function div(uint a, uint b) internal returns(uint) {
11 		uint c = a / b;
12 		return c; 
13 	}
14 
15 	function sub(uint a, uint b) internal returns(uint) {
16 		assert(b <= a);
17 		return a - b;
18 	}
19 
20 	function add(uint a, uint b) internal returns(uint) {
21 		uint c = a + b;
22 		assert(c >= a);
23 		return c;
24 	}
25 	function max64(uint64 a, uint64 b) internal constant returns(uint64) {
26 		return a >= b ? a : b;
27 	}
28 
29 	function min64(uint64 a, uint64 b) internal constant returns(uint64) {
30 		return a < b ? a : b;
31 	}
32 
33 	function max256(uint256 a, uint256 b) internal constant returns(uint256) {
34 		return a >= b ? a : b;
35 	}
36 
37 	function min256(uint256 a, uint256 b) internal constant returns(uint256) {
38 		return a < b ? a : b;
39 	}
40 
41 	function assert(bool assertion) internal {
42 		if(!assertion) {
43 			throw;
44 		}
45 	}
46 }
47 
48 contract ERC20Basic {
49 	uint public totalSupply;
50 	function balanceOf(address who) constant returns(uint);
51 	function transfer(address to, uint value);
52 	event Transfer(address indexed from, address indexed to, uint value);
53 }
54 
55 contract BasicToken is ERC20Basic {
56 	using SafeMath 	for uint;
57 	mapping(address => uint) balances;
58 
59 	modifier onlyPayloadSize(uint size) {
60 		if(msg.data.length < size + 4) {
61 			throw;
62 		}
63 		_;
64 	}
65 
66 	function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
67 		balances[msg.sender] = balances[msg.sender].sub(_value);
68 		balances[_to] = balances[_to].add(_value);
69 		Transfer(msg.sender, _to, _value);
70 	}
71 
72 	function balanceOf(address _owner) constant returns(uint balance) {
73 		return balances[_owner];
74 	}
75 
76 }
77 
78 contract ERC20 is ERC20Basic {
79 	function allowance(address owner, address spender) constant returns(uint);
80 	function transferFrom(address from, address to, uint value);
81 	function approve(address spender, uint value);
82 	event Approval(address indexed owner, address indexed spender, uint value);
83 }
84 
85 contract StandardToken is BasicToken, ERC20 {
86 	mapping(address => mapping(address => uint)) allowed;
87 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
88 		var _allowance = allowed[_from][msg.sender];
89 		balances[_to] = balances[_to].add(_value);
90 		balances[_from] = balances[_from].sub(_value);
91 		allowed[_from][msg.sender] = _allowance.sub(_value);
92 		Transfer(_from, _to, _value);
93 	}
94 
95 	function approve(address _spender, uint _value) {
96 		if((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
97 		allowed[msg.sender][_spender] = _value;
98 		Approval(msg.sender, _spender, _value);
99 	}
100 
101 	function allowance(address _owner, address _spender) constant returns(uint remaining) {
102 		return allowed[_owner][_spender];
103 	}
104 
105 }
106 
107 contract BIDTToken is StandardToken {
108 	string public constant symbol = "BIDT";
109 	string public constant name = "Block IDentity Token";
110 	uint8 public constant decimals = 18;
111 	address public target;
112 	
113 	uint public baseRate=0;
114 	bool public allowedBuy = false;
115 	uint public  basePublicPlacement  = 1;
116 	event InvalidCaller(address caller);
117 
118 	modifier onlyOwner {
119 		if(target == msg.sender) {
120 			_;
121 		} else {
122 			InvalidCaller(msg.sender);
123 			throw;
124 		}
125 	}
126 
127 	function setRate(uint rate) public onlyOwner {
128 		baseRate = rate;
129 	}
130 	function setPublicPlacementNum(uint publicPlacement) public onlyOwner {
131 		basePublicPlacement = publicPlacement;
132 	}
133 
134 	function openBuy() public onlyOwner {
135 		allowedBuy = true;
136 	}
137 	
138 	function closeBuy() public onlyOwner {
139 		allowedBuy = false;
140 	}
141 
142 	function BIDTToken(address _target) {
143 		target = _target;
144 		totalSupply = 45.5 * 100000000 * 10 ** 18;
145 		balances[target] = totalSupply.div(1000).mul(100);
146 		
147 		balances[0xBE4C612DE6221F557799b7eD456572F0c0A14BD1] = totalSupply.div(1000).mul(180);
148 		balances[0xA29459226F9aFa33b2b22093f5f9FCB9B16a9851] = totalSupply.div(1000).mul(20);
149 		
150 		balances[0x7E7C8b920d2Fd52b6552805C2212d40792b77f6b] = totalSupply.div(1000).mul(40);
151 		balances[0xC6eB2f5C7938F687F58516B5EA6438B8A4803Ee3] = totalSupply.div(1000).mul(5);
152 		balances[0x15dA32920eecaf05C0594C039633F8565471cb5C] = totalSupply.div(1000).mul(5);
153 		
154 		balances[0xCD2C7D18325B7E09DA08DBA6f58D0E6F0e6BDf68] = totalSupply.div(1000).mul(30);
155 		balances[0x2968d05dCF6e706F68ca8fC16F6e430fd822d742] = totalSupply.div(1000).mul(170);
156 
157 		balances[0xD20D3CaC06BfC68f1d0e84855c3395D2D10CDb14] = totalSupply.div(1000).mul(450);
158 	}
159 
160 	function() payable {
161 		issueToken();
162 	}
163 
164 	function issueToken() payable {
165 	    if(allowedBuy){
166 	        assert(msg.value >= 1 ether );
167     		assert(msg.value <= 50 ether );
168     		uint tokens = computeTokenAmount(msg.value);
169     		balances[msg.sender] = balances[msg.sender].add(tokens);
170     		balances[target] = balances[target].sub(tokens);
171 	    }else{
172 	       	throw;
173 	    }
174 		if(!target.send(msg.value)) {
175 			throw;
176 		}
177 	}
178 
179 	function computeTokenAmount(uint ethAmount) internal constant returns(uint tokens) {
180 		uint tokenBase = ethAmount.mul(baseRate);
181 		if(	balances[target] > (totalSupply.div(100)).mul(8-basePublicPlacement)){
182 		    	tokens = tokenBase;
183 		}else{
184 		   	throw;
185 		}
186 		    
187 	}
188 
189 }