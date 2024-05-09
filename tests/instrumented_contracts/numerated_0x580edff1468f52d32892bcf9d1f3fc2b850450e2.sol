1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 		uint256 c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8 	}
9 
10 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
11 		assert(b > 0); // Solidity automatically throws when dividing by 0
12 		uint256 c = a / b;
13 		assert(a == b * c + a % b); // There is no case in which this doesn't hold
14 		return c;
15 	}
16 
17 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18 		assert(b <= a);
19 		return a - b;
20 	}
21 
22 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
23 		uint256 c = a + b;
24 		assert(c >= a);
25 		return c;
26 	}
27 }
28 
29 contract Ownable {
30 	address public owner;
31 
32 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34 	modifier onlyOwner() {
35 		require(msg.sender == owner);
36 		_;
37 	}
38 	
39 	function transferOwnership(address newOwner) public onlyOwner {
40 		require(newOwner != address(0));
41 		OwnershipTransferred(owner, newOwner);
42 		owner = newOwner;
43 	}
44 }
45 
46 contract ERC20 {
47 	uint public totalSupply;
48 	function balanceOf(address _owner) public constant returns (uint balance);
49 	function transfer(address _to,uint _value) public returns (bool success);
50 	function transferFrom(address _from,address _to,uint _value) public returns (bool success);
51 	function approve(address _spender,uint _value) public returns (bool success);
52 	function allownce(address _owner,address _spender) public constant returns (uint remaining);
53 	event Transfer(address indexed _from,address indexed _to,uint _value);
54 	event Approval(address indexed _owner,address indexed _spender,uint _value);
55 }
56 
57 contract Option is ERC20,Ownable {
58 	using SafeMath for uint8;
59 	using SafeMath for uint256;
60 	
61 	event Burn(address indexed _from,uint256 _value);
62 	event Increase(address indexed _to, uint256 _value);
63 	event SetItemOption(address _to, uint256 _amount, uint256 _releaseTime);
64 	
65 	struct ItemOption {
66 		uint256 releaseAmount;
67 		uint256 releaseTime;
68 	}
69 
70 	string public name;
71 	string public symbol;
72 	uint8 public decimals;
73 	uint256 public initial_supply;
74 	mapping (address => uint256) public balances;
75 	mapping (address => mapping (address => uint256)) allowed;
76 	mapping (address => ItemOption[]) toMapOption;
77 	
78 	function Option (
79 		string Name,
80 		string Symbol,
81 		uint8 Decimals,
82 		uint256 initialSupply,
83 		address initOwner
84 	) public {
85 		require(initOwner != address(0));
86 		owner = initOwner;
87 		name = Name;
88 		symbol = Symbol;
89 		decimals = Decimals;
90 		initial_supply = initialSupply * (10 ** uint256(decimals));
91 		totalSupply = initial_supply;
92 		balances[initOwner] = totalSupply;
93 	}
94 	
95 	function itemBalance(address _to) public constant returns (uint amount) {
96 		require(_to != address(0));
97 		amount = 0;
98 		uint256 nowtime = now;
99 		for(uint256 i = 0; i < toMapOption[_to].length; i++) {
100 			require(toMapOption[_to][i].releaseAmount > 0);
101 			if(nowtime >= toMapOption[_to][i].releaseTime) {
102 				amount = amount.add(toMapOption[_to][i].releaseAmount);
103 			}
104 		}
105 		return amount;
106 	}
107 	
108 	function balanceOf(address _owner) public constant returns (uint balance) {
109 		return balances[_owner].add(itemBalance(_owner));
110 	}
111 	
112 	function itemTransfer(address _to) public returns (bool success) {
113 		require(_to != address(0));
114 		uint256 nowtime = now;
115 		for(uint256 i = 0; i < toMapOption[_to].length; i++) {
116 			require(toMapOption[_to][i].releaseAmount >= 0);
117 			if(nowtime >= toMapOption[_to][i].releaseTime && balances[_to] + toMapOption[_to][i].releaseAmount > balances[_to]) {
118 				balances[_to] = balances[_to].add(toMapOption[_to][i].releaseAmount);
119 				toMapOption[_to][i].releaseAmount = 0;
120 			}
121 		}
122 		return true;
123 	}
124 	
125 	function transfer(address _to,uint _value) public returns (bool success) {
126 		itemTransfer(_to);
127 		if(balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]){
128 			balances[msg.sender] = balances[msg.sender].sub(_value);
129 			balances[_to] = balances[_to].add(_value);
130 			Transfer(msg.sender,_to,_value);
131 			return true;
132 		} else {
133 			return false;
134 		}
135 	}
136 
137 	function transferFrom(address _from,address _to,uint _value) public returns (bool success) {
138 		itemTransfer(_from);
139 		if(balances[_from] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
140 			if(_from != msg.sender) {
141 				require(allowed[_from][msg.sender] > _value);
142 				allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143 			}
144 			balances[_from] = balances[_from].sub(_value);
145 			balances[_to] = balances[_to].add(_value);
146 			Transfer(_from,_to,_value);
147 			return true;
148 		} else {
149 			return false;
150 		}
151 	}
152 
153 	function approve(address _spender, uint _value) public returns (bool success) {
154 		allowed[msg.sender][_spender] = _value;
155 		Approval(msg.sender,_spender,_value);
156 		return true;
157 	}
158 	
159 	function allownce(address _owner,address _spender) public constant returns (uint remaining) {
160 		return allowed[_owner][_spender];
161 	}
162 	
163 	function burn(uint256 _value) public returns (bool success) {
164 		require(balances[msg.sender] >= _value);
165 		balances[msg.sender] = balances[msg.sender].sub(_value);
166 		totalSupply = totalSupply.sub(_value);
167 		Burn(msg.sender,_value);
168 		return true;
169 	}
170 
171 	function increase(uint256 _value) public onlyOwner returns (bool success) {
172 		if(balances[msg.sender] + _value > balances[msg.sender]) {
173 			totalSupply = totalSupply.add(_value);
174 			balances[msg.sender] = balances[msg.sender].add(_value);
175 			Increase(msg.sender, _value);
176 			return true;
177 		}
178 	}
179 
180 	function setItemOption(address _to, uint256 _amount, uint256 _releaseTime) public returns (bool success) {
181 		require(_to != address(0));
182 		uint256 nowtime = now;
183 		if(_amount > 0 && balances[msg.sender].sub(_amount) >= 0 && balances[_to].add(_amount) > balances[_to]) {
184 			balances[msg.sender] = balances[msg.sender].sub(_amount);
185 			//Transfer(msg.sender, to, _amount);
186 			toMapOption[_to].push(ItemOption(_amount, _releaseTime));
187 			SetItemOption(_to, _amount, _releaseTime);
188 			return true;
189 		}
190 		return false;
191 	}
192 	
193 	function setItemOptions(address _to, uint256 _amount, uint256 _startTime, uint8 _count) public returns (bool success) {
194 		require(_to != address(0));
195 		require(_amount > 0);
196 		require(_count > 0);
197 		uint256 releaseTime = _startTime;
198 		for(uint8 i = 0; i < _count; i++) {
199 			releaseTime = releaseTime.add(1 years);
200 			setItemOption(_to, _amount, releaseTime);
201 		}
202 		return true;
203 	}
204 }