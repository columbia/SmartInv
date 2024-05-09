1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4 	uint256 public totalSupply;
5 	function balanceOf(address _owner) public view returns (uint256);
6 	function transfer(address _to, uint256 _value) public returns (bool);
7 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
8 	function approve(address _spender, uint256 _value) public returns (bool);
9 	function allowance(address _owner, address _spender) public view returns (uint256 remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 contract TokenRecipient {
16 	function receiveApproval(address _from, uint256 _value, address _token, bytes _data) public;
17 	function tokenFallback(address _from, uint256 _value, bytes _data) public;
18 }
19 
20 
21 contract T is ERC20 {
22 	mapping (address => uint256) balances;
23 	mapping (address => mapping (address => uint256)) allowed;
24 	uint8 public decimals;
25 	string public name;
26 	string public symbol;
27 	
28 	bool public running;
29 	address public owner;
30 	address public ownerTemp;
31 	
32 	
33 	
34 	modifier isOwner {
35 		require(owner == msg.sender);
36 		_;
37 	}
38 	
39 	modifier isRunning {
40 		require(running);
41 		_;
42 	}
43 	
44 	function isContract(address _addr) private view returns (bool) {
45 		uint length;
46 		assembly {
47 			length := extcodesize(_addr)
48 		}
49 		return length > 0;
50 	}
51 	
52 	constructor() public {
53 		running = true;
54 		owner = msg.sender;
55 		decimals = 18;
56 		totalSupply = 2 * uint(10)**(decimals + 9);
57 		balances[owner] = totalSupply;
58 		name = "HOTCOIN";
59 		symbol = "HCN";
60 		emit Transfer(address(0), owner, totalSupply);
61 	}
62 	
63 	
64 	
65 	function transfer(address _to, uint256 _value) public isRunning returns (bool) {
66 		require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
67 		balances[msg.sender] -= _value;
68 		balances[_to] += _value;
69 		if (isContract(_to)) {
70 			bytes memory empty;
71 			TokenRecipient(_to).tokenFallback(msg.sender, _value, empty);
72 		}
73 		emit Transfer(msg.sender, _to, _value);
74 		return true;
75 	}
76 	
77 	function transfer(address _to, uint256 _value, bytes _data) public isRunning returns (bool) {
78 		require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
79 		balances[msg.sender] -= _value;
80 		balances[_to] += _value;
81 		if (isContract(_to)) {
82 			TokenRecipient(_to).tokenFallback(msg.sender, _value, _data);
83 		}
84 		emit Transfer(msg.sender, _to, _value);
85 		return true;
86 	}
87 	
88 	function transfer(address _to, uint256 _value, bytes _data, string _callback) public isRunning returns (bool) {
89 		require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
90 		balances[msg.sender] -= _value;
91 		balances[_to] += _value;
92 		if (isContract(_to)) {
93 			assert(_to.call.value(0)(abi.encodeWithSignature(_callback, msg.sender, _value, _data)));
94 		}
95 		emit Transfer(msg.sender, _to, _value);
96 		return true;
97 	}
98 	
99 	function transfer(address[] _tos, uint256[] _values) public isRunning returns (bool) {
100 		uint cnt = _tos.length;
101 		require(cnt > 0 && cnt <= 1000 && cnt == _values.length);
102 		uint256 totalAmount = 0;
103 		uint256 val;
104 		address to;
105 		uint i;
106 		
107 		for (i = 0; i < cnt; i++) {
108 			val = _values[i];
109 			to = _tos[i];
110 			require(balances[to] + val >= balances[to] && totalAmount + val >= totalAmount);
111 			totalAmount += val;
112 		}
113 		
114 		require(balances[msg.sender] >= totalAmount);
115 		balances[msg.sender] -= totalAmount;
116 		bytes memory empty;
117 		
118 		for (i = 0; i < cnt; i++) {
119 			to = _tos[i];
120 			val = _values[i];
121 			balances[to] += val;
122 			if (isContract(to)) {
123 				TokenRecipient(to).tokenFallback(msg.sender, val, empty);
124 			}
125 			emit Transfer(msg.sender, to, val);
126 		}
127 		return true;
128 	}
129 	
130 	
131 	
132 	
133 	function balanceOf(address _owner) public view returns (uint256) {
134 		return balances[_owner];
135 	}
136 	
137 	function transferFrom(address _from, address _to, uint256 _value) public isRunning returns (bool) {
138 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
139 		balances[_to] += _value;
140 		balances[_from] -= _value;
141 		allowed[_from][msg.sender] -= _value;
142 		emit Transfer(_from, _to, _value);
143 		return true;
144 	}
145 
146 	function approve(address _spender, uint256 _value) public isRunning returns (bool) {
147 		allowed[msg.sender][_spender] = _value;
148 		emit Approval(msg.sender, _spender, _value);
149 		return true;
150 	}
151 	
152 	function approve(address _spender, uint256 _value, uint256 _check) public isRunning returns (bool) {
153 		require(allowed[msg.sender][_spender] == _check);
154 		return approve(_spender, _value);
155 	}
156 
157 	function allowance(address _owner, address _spender) public view returns (uint256) {
158 	  return allowed[_owner][_spender];
159 	}
160 	
161 	function approveAndCall(address _spender, uint256 _value, bytes _data) public isRunning returns (bool) {
162 		if (approve(_spender, _value)) {
163 			TokenRecipient(_spender).receiveApproval(msg.sender, _value, this, _data);
164 			return true;
165 		}
166 	}
167 	
168 	function approveAndCall(address _spender, uint256 _value, bytes _data, string _callback) public isRunning returns (bool) {
169 		if (approve(_spender, _value)) {
170 			assert(_spender.call.value(0)(abi.encodeWithSignature(_callback, msg.sender, _value, _data)));
171 			return true;
172 		}
173 	}
174 	
175 	function transferAndCall(address _to, uint256 _value, bytes _data) public isRunning returns (bool) {
176 		if (transfer(_to, _value)) {
177 			TokenRecipient(_to).tokenFallback(msg.sender, _value, _data);
178 			return true;
179 		}
180 	}
181 	
182 	function transferAndCall(address _to, uint256 _value, bytes _data, string _callback) public isRunning returns (bool) {
183 		if (transfer(_to, _value)) {
184 			assert(_to.call.value(0)(abi.encodeWithSignature(_callback, msg.sender, _value, _data)));
185 			return true;
186 		}
187 	}
188 	
189 	
190 	
191 	function setName(string _name) public isOwner {
192 		name = _name;
193 	}
194 	
195 	function setSymbol(string _symbol) public isOwner {
196 		symbol = _symbol;
197 	}
198 	
199 	function setRunning(bool _run) public isOwner {
200 		running = _run;
201 	}
202 	
203 	function transferOwnership(address _owner) public isOwner {
204 		ownerTemp = _owner;
205 	}
206 	
207 	function acceptOwnership() public {
208 		require(msg.sender == ownerTemp);
209 		owner = ownerTemp;
210 		ownerTemp = address(0);
211 	}
212 	
213 	function collectERC20(ERC20 _token, uint _amount) public isRunning isOwner returns (bool success) {
214 		return _token.transfer(owner, _amount);
215 	}
216 }