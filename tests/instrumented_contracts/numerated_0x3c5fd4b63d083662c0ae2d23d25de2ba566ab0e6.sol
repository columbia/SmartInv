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
34 	function Ownable () public {
35 		owner = msg.sender;
36 	}
37 
38 	modifier onlyOwner() {
39 		require(msg.sender == owner);
40 		_;
41 	}
42 	
43 	function transferOwnership(address newOwner) public onlyOwner {
44 		require(newOwner != address(0));
45 		OwnershipTransferred(owner, newOwner);
46 		owner = newOwner;
47 	}
48 }
49 
50 contract ERC20 {
51 	uint public totalSupply;
52 	function balanceOf(address _owner) public constant returns (uint balance);
53 	function transfer(address _to,uint _value) public returns (bool success);
54 	function transferFrom(address _from,address _to,uint _value) public returns (bool success);
55 	function approve(address _spender,uint _value) public returns (bool success);
56 	function allownce(address _owner,address _spender) public constant returns (uint remaining);
57 	event Transfer(address indexed _from,address indexed _to,uint _value);
58 	event Approval(address indexed _owner,address indexed _spender,uint _value);
59 }
60 
61 contract MangGuoToken is ERC20,Ownable {
62 	using SafeMath for uint8;
63 	using SafeMath for uint256;
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
78 	//airdrop params
79     address public dropAddress;
80     uint256 public dropCount;
81     uint256 public dropOffset;
82     uint256 public dropAmount;
83 
84 	function MangGuoToken (
85 		string Name,
86 		string Symbol,
87 		uint8 Decimals,
88 		uint256 initialSupply
89 	) public {
90 		name = Name;
91 		symbol = Symbol;
92 		decimals = Decimals;
93 		initial_supply = initialSupply * (10 ** uint256(decimals));
94 		totalSupply = initial_supply;
95 		balances[msg.sender] = totalSupply;
96 		dropAddress = address(0);
97 		dropCount = 0;
98 		dropOffset = 0;
99 		dropAmount = 0;
100 	}
101 	
102 	function itemBalance(address _to) public constant returns (uint amount) {
103 		require(_to != address(0));
104 		amount = 0;
105 		uint256 nowtime = now;
106 		for(uint256 i = 0; i < toMapOption[_to].length; i++) {
107 			require(toMapOption[_to][i].releaseAmount > 0);
108 			if(nowtime >= toMapOption[_to][i].releaseTime) {
109 				amount = amount.add(toMapOption[_to][i].releaseAmount);
110 			}
111 		}
112 		return amount;
113 	}
114 	
115 	function balanceOf(address _owner) public constant returns (uint balance) {
116 		return balances[_owner].add(itemBalance(_owner));
117 	}
118 	
119 	function itemTransfer(address _to) public returns (bool success) {
120 		require(_to != address(0));
121 		uint256 nowtime = now;
122 		for(uint256 i = 0; i < toMapOption[_to].length; i++) {
123 			require(toMapOption[_to][i].releaseAmount >= 0);
124 			if(nowtime >= toMapOption[_to][i].releaseTime && balances[_to] + toMapOption[_to][i].releaseAmount > balances[_to]) {
125 				balances[_to] = balances[_to].add(toMapOption[_to][i].releaseAmount);
126 				toMapOption[_to][i].releaseAmount = 0;
127 			}
128 		}
129 		return true;
130 	}
131 	
132 	function transfer(address _to,uint _value) public returns (bool success) {
133 		itemTransfer(_to);
134 		if(balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]){
135 			balances[msg.sender] = balances[msg.sender].sub(_value);
136 			balances[_to] = balances[_to].add(_value);
137 			Transfer(msg.sender,_to,_value);
138 			return true;
139 		} else {
140 			return false;
141 		}
142 	}
143 	
144 	function transferFrom(address _from,address _to,uint _value) public returns (bool success) {
145 		itemTransfer(_from);
146 		if(balances[_from] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
147 			if(_from != msg.sender) {
148 				require(allowed[_from][msg.sender] > _value);
149 				allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150 			}
151 			balances[_from] = balances[_from].sub(_value);
152 			balances[_to] = balances[_to].add(_value);
153 			Transfer(_from,_to,_value);
154 			return true;
155 		} else {
156 			return false;
157 		}
158 	}
159 	
160 	function approve(address _spender, uint _value) public returns (bool success) {
161 		allowed[msg.sender][_spender] = _value;
162 		Approval(msg.sender,_spender,_value);
163 		return true;
164 	}
165 	
166 	function allownce(address _owner,address _spender) public constant returns (uint remaining) {
167 		return allowed[_owner][_spender];
168 	}
169 	
170 	function setItemOption(address _to, uint256 _amount, uint256 _releaseTime) public returns (bool success) {
171 		require(_to != address(0));
172 		if(_amount > 0 && balances[msg.sender].sub(_amount) >= 0 && balances[_to].add(_amount) > balances[_to]) {
173 			balances[msg.sender] = balances[msg.sender].sub(_amount);
174 			//Transfer(msg.sender, to, _amount);
175 			toMapOption[_to].push(ItemOption(_amount, _releaseTime));
176 			return true;
177 		}
178 		return false;
179 	}
180 	
181 	function setItemOptions(address _to, uint256 _amount, uint256 _startTime, uint8 _count) public returns (bool success) {
182 		require(_to != address(0));
183 		require(_amount > 0);
184 		require(_count > 0);
185 		uint256 releaseTime = _startTime;
186 		for(uint8 i = 0; i < _count; i++) {
187 			releaseTime = releaseTime.add(86400*30);
188 			setItemOption(_to, _amount, releaseTime);
189 		}
190 		return true;
191 	}
192 	
193 	function resetAirDrop(uint256 _dropAmount, uint256 _dropCount) public onlyOwner returns (bool success) {
194 		if(_dropAmount > 0 && _dropCount > 0) {
195 			dropAmount = _dropAmount;
196 			dropCount = _dropCount;
197 			dropOffset = 0;
198 		}
199 		return true;
200 	}
201 	
202 	function resetDropAddress(address _dropAddress) public onlyOwner returns (bool success) {
203 		dropAddress = _dropAddress;
204 		return true;
205 	}
206 	
207 	function airDrop() payable public {
208 		require(msg.value == 0 ether);
209 		
210 		if(balances[msg.sender] == 0 && dropCount > 0) {
211 			if(dropCount > dropOffset) {
212 				if(dropAddress != address(0)) {
213 					if(balances[dropAddress] >= dropAmount && balances[msg.sender] + dropAmount > balances[msg.sender]) {
214 						balances[dropAddress] = balances[dropAddress].sub(dropAmount);
215 						balances[msg.sender] = balances[msg.sender].add(dropAmount);
216 						dropOffset++;
217 						Transfer(dropAddress, msg.sender, dropAmount);
218 					}
219 				} else {
220 					if(balances[owner] >= dropAmount && balances[msg.sender] + dropAmount > balances[msg.sender]) {
221 						balances[owner] = balances[owner].sub(dropAmount);
222 						balances[msg.sender] = balances[msg.sender].add(dropAmount);
223 						dropOffset++;
224 						Transfer(dropAddress, msg.sender, dropAmount);
225 					}
226 				}
227 			}
228 		}
229     }
230 }