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
41 contract CENAuth{
42 	address public owner;
43 	constructor () public{
44 		owner = msg.sender;
45 	}
46 	event LogOwnerChanged (address msgSender );
47 
48 	///@notice check if the msgSender is owner
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
65 contract CENStop is CENAuth{
66 	bool internal stopped = false;
67 
68 	modifier stoppable {
69 		assert (!stopped);
70 		_;
71 	}
72 
73 	function _status() view public returns (bool){
74 		return stopped;
75 	}
76 	function stop() public onlyOwner{
77 		stopped = true;
78 	}
79 	function start() public onlyOwner{
80 		stopped = false;
81 	}
82 
83 }
84 contract Token is SafeMath {
85 	/*
86 		Standard ERC20 token
87 	*/
88 	uint256 public totalSupply;                                 /// total amount of tokens
89 	/// @param _owner The address from which the balance will be retrieved
90 	/// @return The balance
91 	function balanceOf(address _owner) public view returns (uint256 balance);
92 
93 	/// @notice send `_value` token to `_to` from `msg.sender`
94 	/// @param _to The address of the recipient
95 	/// @param _value The amount of token to be transferred
96 	/// @return Whether the transfer was successful or not
97 	function transfer(address _to, uint256 _value) public returns (bool success);
98 
99 	/// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
100 	/// @param _from The address of the sender
101 	/// @param _to The address of the recipient
102 	/// @param _value The amount of token to be transferred
103 	/// @return Whether the transfer was successful or not
104 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
105 
106 	/// @notice `msg.sender` approves `_spender` to spend `_value` tokens
107 	/// @param _spender The address of the account able to transfer the tokens
108 	/// @param _value The amount of tokens to be approved for transfer
109 	/// @return Whether the approval was successful or not
110 	function approve(address _spender, uint256 _value) public returns (bool success);
111 
112 	/// @param _owner The address of the account owning tokens
113 	/// @param _spender The address of the account able to transfer the tokens
114 	/// @return Amount of remaining tokens allowed to spent
115 	function allowance(address _owner, address _spender) view public returns (uint256 remaining);
116 
117 	function burn(uint256 amount) public returns (bool);
118 	
119 	function frozenCheck(address _from , address _to) view private returns (bool);
120 
121 	function freezeAccount(address target , bool freeze) public;
122 
123 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
124 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
125 	event Burn    (address indexed _owner , uint256 _value);
126 }
127 contract StandardToken is Token ,CENStop{
128 
129 	function transfer(address _to, uint256 _value) stoppable public returns (bool ind) {
130 		//Default assumes totalSupply can't be over max (2^256 - 1).
131 		//If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
132 		//Replace the if with this one instead.
133 		//if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
134 		require(_to!= address(0));
135 		require(frozenCheck(msg.sender,_to));
136 		if (balances[msg.sender] >= _value && _value > 0) {
137 			balances[msg.sender] = safeSub(balances[msg.sender] , _value);
138 			balances[_to]  = safeAdd(balances[_to],_value);
139 			emit Transfer(msg.sender, _to, _value);
140 			return true;
141 		} else { return false; }
142 	}
143 
144 	function transferFrom(address _from, address _to, uint256 _value) stoppable public returns (bool success) {
145 		//same as above. Replace this line with the following if you want to protect against wrapping uints.
146 		require(frozenCheck(_from,_to));
147 		require(_to!= address(0));
148 		if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
149 			balances[_to]  = safeAdd(balances[_to],_value);
150 			balances[_from] = safeSub(balances[_from] , _value);
151 			allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
152 			emit Transfer(_from, _to, _value);
153 			return true;
154 		} else { return false; }
155 	}
156 
157 	function balanceOf(address _owner) public view returns (uint256 balance) {
158 		return balances[_owner];
159 	}
160 
161 	function approve(address _spender, uint256 _value) stoppable public returns (bool success) {
162 		require(frozenCheck(_spender,msg.sender));
163 		require(_spender!= address(0));
164 		require(_value>0);
165 		require(allowed[msg.sender][_spender]==0);
166 		allowed[msg.sender][_spender] = _value;
167 		emit Approval(msg.sender, _spender, _value);
168 		return true;
169 	}
170 
171 	function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
172 		return allowed[_owner][_spender];
173 	}
174 	function burn(uint256 amount) stoppable onlyOwner public returns (bool){
175 		if(balances[msg.sender] > amount ){
176 			balances[msg.sender] = safeSub(balances[msg.sender],amount);
177 			totalSupply = safeSub(totalSupply,amount);
178 			emit Burn(msg.sender,amount);
179 			return true;
180 		}else{
181 			return false;
182 		}
183 	}
184 	function frozenCheck(address _from , address _to) view private returns (bool){
185 		require(!frozenAccount[_from]);
186 		require(!frozenAccount[_to]);
187 		return true;
188 	}
189 	function freezeAccount(address target , bool freeze) onlyOwner public{
190 		frozenAccount[target] = freeze;
191 	}
192 
193 	mapping (address => uint256)                      internal  balances;
194 	mapping (address => mapping (address => uint256)) private  allowed;
195 	mapping (address => bool)                         private  frozenAccount;    //Save frozen account
196 
197 }
198 contract CENToken is StandardToken{
199 
200 	string public name = "CEN";                                   /// Set the full name of this contract
201 	uint256 public decimals = 18;                                 /// Set the decimal
202 	string public symbol = "CEN";                                 /// Set the symbol of this contract
203 
204 	constructor() public {                    /// Should have sth in this
205 		owner = msg.sender;
206 		totalSupply = 1000000000000000000000000000;
207 		balances[msg.sender] = totalSupply;
208 	}
209 
210 	function () stoppable public {
211 		revert();
212 	}
213 
214 }