1 pragma solidity ^0.4.24;
2 /**
3  * Math operations with safety checks
4  */
5 contract SafeMath {
6 
7 	function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
8 		uint256 c = a * b;
9 		judgement(a == 0 || c / a == b);
10 		return c;
11 	}
12 
13 	function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
14 		judgement(b > 0);
15 		uint256 c = a / b;
16 		judgement(a == b * c + a % b);
17 		return c;
18 	}
19 
20 	function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
21 		judgement(b <= a);
22 		return a - b;
23 	}
24 
25 	function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
26 		uint256 c = a + b;
27 		judgement(c>=a && c>=b);
28 		return c;
29 	}
30 	function safeMulWithPresent(uint256 a , uint256 b) pure internal returns (uint256){
31 		uint256 c = safeDiv(safeMul(a,b),1000);
32 		judgement(b == (c*1000)/a);
33 		return c;
34 	}
35 	function judgement(bool assertion) pure internal {
36 		if (!assertion) {
37 			revert();
38 		}
39 	}
40 }
41 contract HCBPerm{
42 	address public owner;
43 	constructor () public{
44 		owner = msg.sender;
45 	}
46 	event LogOwnerChanged (address msgSender );
47 
48 	///notice check if the msgSender is owner
49 	modifier onlyOwner{
50 		assert(msg.sender == owner);
51 		_;
52 	}
53 
54 	function setOwner (address newOwner) public onlyOwner returns (bool){
55 		if (owner == msg.sender){
56 			owner = newOwner;
57 			emit LogOwnerChanged(msg.sender);
58 			return true;
59 		}else{
60 			return false;
61 		}
62 	}
63 
64 }
65 contract HCBFreeze is HCBPerm{
66 	bool internal stopped = false;
67 
68 	modifier stoppable {
69 		assert (!stopped);
70 		_;
71 	}
72 
73 	function status() view public returns (bool){
74 		return stopped;
75 	}
76 	//freeze all env
77 	function stop() public onlyOwner{
78 		stopped = true;
79 	}
80 	//unfreeze
81 	function start() public onlyOwner{
82 		stopped = false;
83 	}
84 
85 }
86 contract Token is SafeMath {
87 	/*
88 		Basic ERC20 token
89 	*/
90 	uint256 public totalSupply;                                 /// total amount of tokens
91 	/// @param _owner The address from which the balance will be retrieved
92 	/// @return The balance
93 	function balanceOf(address _owner) public view returns (uint256 balance);
94 
95 	/// @notice send `_value` token to `_to` from `msg.sender`
96 	/// @param _to The address of the recipient
97 	/// @param _value The amount of token to be transferred
98 	/// @return Whether the transfer was successful or not
99 	function transfer(address _to, uint256 _value) public returns (bool success);
100 
101 	/// @param amount of need to burn
102 	/// @return Burn amount of token
103 	function burn(uint256 amount) public returns (bool);
104 
105 	/// @param _from transaction from address
106 	/// @param _to   transaction to address
107 	/// @return check the from and to address weather been freezed
108 	function frozenCheck(address _from , address _to) view private returns (bool);
109 
110 	/// @param target the address gonna freeze or unfreeze
111 	/// @param freeze freeze or unfreeze
112 	function freezeAccount(address target , bool freeze) public;
113 
114 	/// @param key  the key of main chain
115 	/// return weather operation was successful or not
116 	function register(string key) public returns(bool);
117 
118 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
119 	event Burn    (address indexed _owner , uint256 _value);
120 	event LogRegister (address user, string key);
121 }
122 contract BasicToken is Token ,HCBFreeze{
123 
124 	function transfer(address _to, uint256 _value) stoppable public returns (bool ind) {
125 		//Default assumes totalSupply can't be over max (2^256 - 1).
126 		//If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
127 		//Replace the if with this one instead.
128 		require(_to!= address(0));
129 		require(frozenCheck(msg.sender,_to));
130 		if (balances[msg.sender] >= _value && _value > 0) {
131 			balances[msg.sender] = safeSub(balances[msg.sender] , _value);
132 			balances[_to]  = safeAdd(balances[_to],_value);
133 			emit Transfer(msg.sender, _to, _value);
134 			return true;
135 		} else { return false; }
136 	}
137 
138 	function balanceOf(address _owner) public view returns (uint256 balance) {
139 		return balances[_owner];
140 	}
141 
142 	function burn(uint256 amount) stoppable onlyOwner public returns (bool){
143 		if(balances[msg.sender] > amount ){
144 			balances[msg.sender] = safeSub(balances[msg.sender],amount);
145 			totalSupply = safeSub(totalSupply,amount);
146 			emit Burn(msg.sender,amount);
147 			return true;
148 		}else{
149 			return false;
150 		}
151 	}
152 	function frozenCheck(address _from , address _to) view private returns (bool){
153 		require(!frozenAccount[_from]);
154 		require(!frozenAccount[_to]);
155 		return true;
156 	}
157 	function freezeAccount(address target , bool freeze) onlyOwner public{
158 		frozenAccount[target] = freeze;
159 	}
160 	function register(string key) public returns(bool){
161 		assert(bytes(key).length <= 64);
162 		require(!status());
163 
164 		keys[msg.sender] = key;
165 		emit LogRegister(msg.sender,key);
166 		return true;
167 	}
168 	mapping (address => uint256)                      internal balances;
169 	mapping (address => bool)                         private  frozenAccount;    //Save frozen account
170 	mapping (address => string)                       private  keys;            //mapping main chain's public key and Eth key
171 }
172 contract HCBToken is BasicToken{
173 
174 	string public name = "HiggsCandyBox";                         /// Set the full name of this contract
175 	uint256 public decimals = 18;                                 /// Set the decimal
176 	string public symbol = "HCB";                                 /// Set the symbol of this contract
177 
178 	constructor() public {
179 		owner = msg.sender;
180 		totalSupply = 1000000000000000000000000000;
181 		balances[msg.sender] = totalSupply;
182 	}
183 
184 	function () stoppable public {
185 		revert();
186 	}
187 
188 }