1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.0;
3 
4 interface iERC20 {
5 
6 	function balanceOf(address who) external view returns (uint256 balance);
7 
8 	function allowance(address owner, address spender) external view returns (uint256 remaining);
9 
10 	function transfer(address to, uint256 value) external returns (bool success);
11 
12 	function approve(address spender, uint256 value) external returns (bool success);
13 
14 	function transferFrom(address from, address to, uint256 value) external returns (bool success);
15 
16 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 
18 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract Context {
22 	function _msgSender() internal view returns (address) {
23 		return msg.sender;
24 	}
25 
26 	function _msgData() internal view returns (bytes memory) {
27 		this;
28 		return msg.data;
29 	}
30 }
31 
32 library SafeMath {
33 	function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
34 		c = a - b;
35 		assert(b <= a && c <= a);
36 		return c;
37 	}
38 
39 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40 		c = a + b;
41 		assert(c >= a && c>=b);
42 		return c;
43 	}
44 }
45 
46 library SafeERC20 {
47 	function safeTransfer(iERC20 _token, address _to, uint256 _value) internal {
48 		require(_token.transfer(_to, _value));
49 	}
50 }
51 
52 contract Controllable is Context {
53     mapping (address => bool) public controllers;
54 
55 	constructor () {
56 		address msgSender = _msgSender();
57 		controllers[msgSender] = true;
58 	}
59 
60 	modifier onlyController() {
61 		require(controllers[_msgSender()], "Controllable: caller is not a controller");
62 		_;
63 	}
64 
65     function addController(address _address) public onlyController {
66         controllers[_address] = true;
67     }
68 
69     function removeController(address _address) public onlyController {
70         delete controllers[_address];
71     }
72 }
73 
74 contract Pausable is Controllable {
75 	event Pause();
76 	event Unpause();
77 
78 	bool public paused = false;
79 
80 	modifier whenNotPaused() {
81 		require(!paused);
82 		_;
83 	}
84 
85 	modifier whenPaused() {
86 		require(paused);
87 		_;
88 	}
89 
90 	function pause() public onlyController whenNotPaused {
91 		paused = true;
92 		emit Pause();
93 	}
94 
95 	function unpause() public onlyController whenPaused {
96 		paused = false;
97 		emit Unpause();
98 	}
99 }
100 
101 contract MNW is Controllable, Pausable, iERC20 {
102 	using SafeMath for uint256;
103 	using SafeERC20 for iERC20;
104 
105 	mapping (address => uint256) public balances;
106 	mapping (address => mapping (address => uint256)) public allowed;
107 	mapping (address => bool) public frozenAccount;
108 
109 	uint256 public totalSupply;
110 	string public constant name = "Morpheus.Network";
111 	uint8 public constant decimals = 18;
112 	string public constant symbol = "MNW";
113 	uint256 public constant initialSupply = 47897218 * 10 ** uint(decimals);
114 
115 	constructor() {
116 		totalSupply = initialSupply;
117 		balances[msg.sender] = totalSupply;
118     	controllers[msg.sender] = true;
119 		emit Transfer(address(0),msg.sender,initialSupply);
120 	}
121 
122 	function receiveEther() public payable {
123 		revert();
124 	}
125 
126 	function transfer(address _to, uint256 _value) external override whenNotPaused returns (bool success) {
127 		require(_to != msg.sender,"T1- Recipient can not be the same as sender");
128 		require(_to != address(0),"T2- Please check the recipient address");
129 		require(balances[msg.sender] >= _value,"T3- The balance of sender is too low");
130 		require(!frozenAccount[msg.sender],"T4- The wallet of sender is frozen");
131 		require(!frozenAccount[_to],"T5- The wallet of recipient is frozen");
132 
133 		balances[msg.sender] = balances[msg.sender].sub(_value);
134 		balances[_to] = balances[_to].add(_value);
135 
136 		emit Transfer(msg.sender, _to, _value);
137 
138 		return true;
139 	}
140 
141 	function transferFrom(address _from, address _to, uint256 _value) external override whenNotPaused returns (bool success) {
142 		require(_to != address(0),"TF1- Please check the recipient address");
143 		require(balances[_from] >= _value,"TF2- The balance of sender is too low");
144 		require(allowed[_from][msg.sender] >= _value,"TF3- The allowance of sender is too low");
145 		require(!frozenAccount[_from],"TF4- The wallet of sender is frozen");
146 		require(!frozenAccount[_to],"TF5- The wallet of recipient is frozen");
147 
148 		balances[_from] = balances[_from].sub(_value);
149 		balances[_to] = balances[_to].add(_value);
150 
151 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152 
153 		emit Transfer(_from, _to, _value);
154 
155 		return true;
156 	}
157 
158 	function balanceOf(address _owner) public override view returns (uint256 balance) {
159 		return balances[_owner];
160 	}
161 
162 	function approve(address _spender, uint256 _value) external override whenNotPaused returns (bool success) {
163 		require((_value == 0) || (allowed[msg.sender][_spender] == 0),"A1- Reset allowance to 0 first");
164 
165 		allowed[msg.sender][_spender] = _value;
166 
167 		emit Approval(msg.sender, _spender, _value);
168 
169 		return true;
170 	}
171 
172 	function increaseApproval(address _spender, uint256 _addedValue) external whenNotPaused returns (bool) {
173 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
174 
175 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176 
177 		return true;
178 	}
179 
180 	function decreaseApproval(address _spender, uint256 _subtractedValue) external whenNotPaused returns (bool) {
181 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_subtractedValue);
182 
183 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184 
185 		return true;
186 	}
187 
188 	function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {
189 		return allowed[_owner][_spender];
190 	}
191 
192 	function transferToken(address tokenAddress, uint256 amount) external onlyController {
193 		iERC20(tokenAddress).safeTransfer(msg.sender,amount);
194 	}
195 
196 	function flushToken(address tokenAddress) external onlyController {
197 		uint256 amount = iERC20(tokenAddress).balanceOf(address(this));
198 		iERC20(tokenAddress).safeTransfer(msg.sender,amount);
199 	}
200 
201 	function burn(uint256 _value) external onlyController returns (bool) {
202 		require(_value <= balances[msg.sender],"B1- The balance of burner is too low");
203 
204 		balances[msg.sender] = balances[msg.sender].sub(_value);
205 		totalSupply = totalSupply.sub(_value);
206 
207 		emit Burn(msg.sender, _value);
208 
209 		emit Transfer(msg.sender, address(0), _value);
210 
211 		return true;
212 	}
213 
214 	function freeze(address _address, bool _state) external onlyController returns (bool) {
215 		frozenAccount[_address] = _state;
216 
217 		emit Freeze(_address, _state);
218 
219 		return true;
220 	}
221 
222 	event Burn(address indexed burner, uint256 value);
223 	event Freeze(address target, bool frozen);
224 }