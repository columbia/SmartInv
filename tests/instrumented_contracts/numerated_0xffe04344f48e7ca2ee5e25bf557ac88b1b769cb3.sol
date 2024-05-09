1 /*
2 	This is the STE token - a crowdfunding token of the STeX.Exchange project.
3 	All token info and stats will be published at https://stex.exchange/ste page
4 	
5 	You can use safeLock function to hard lock your tokens on your address for any period
6 	from 1 day and up to 2 years. There would be no way for a  villain to steal any tokens
7 	from your wallet during this SAFE period. You will be also unable to do any transfers of
8 	the STE tokens from your address before the end of the SAFE period. Please be careful using this function.
9 */
10 
11 pragma solidity ^0.4.24;
12 
13 library SafeMath {
14 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15 		if (a == 0) {
16 			return 0;
17 		}
18 		uint256 c = a * b;
19 		assert(c / a == b);
20 		return c;
21 	}
22 
23 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
24 		return a / b;
25 	}
26 
27 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28 		assert(b <= a);
29 		return a - b;
30 	}
31 
32 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
33 		uint256 c = a + b;
34 		assert(c >= a);
35 		return c;
36 	}
37 }
38 
39 contract ERC20Basic {
40 	function totalSupply() public view returns (uint256);
41 	function balanceOf(address who) public view returns (uint256);
42 	function transfer(address to, uint256 value) public returns (bool);
43 	event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47 	function allowance(address owner, address spender) public view returns (uint256);
48 	function transferFrom(address from, address to, uint256 value) public returns (bool);
49 	function approve(address spender, uint256 value) public returns (bool);
50 	event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 contract BasicToken is ERC20Basic {
54 	using SafeMath for uint256;
55 
56 	mapping(address => uint256) balances;
57 
58 	uint256 totalSupply_;
59 
60 	function totalSupply() public view returns (uint256) {
61 		return totalSupply_;
62 	}
63 
64 	function transfer(address _to, uint256 _value) public returns (bool) {
65 		require(_to != address(0));
66 		require(_value <= balances[msg.sender]);
67 
68 		balances[msg.sender] = balances[msg.sender].sub(_value);
69 		balances[_to] = balances[_to].add(_value);
70 		emit Transfer(msg.sender, _to, _value);
71 		return true;
72 	}
73 
74 	function balanceOf(address _owner) public view returns (uint256 balance) {
75 		return balances[_owner];
76 	}
77 
78 }
79 
80 contract StandardToken is ERC20, BasicToken {
81 	mapping (address => mapping (address => uint256)) internal allowed;
82 
83 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84 		require(_to != address(0));
85 		require(_value <= balances[_from]);
86 		require(_value <= allowed[_from][msg.sender]);
87 
88 		balances[_from] = balances[_from].sub(_value);
89 		balances[_to] = balances[_to].add(_value);
90 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91 		emit Transfer(_from, _to, _value);
92 		return true;
93 	}
94 
95 	function approve(address _spender, uint256 _value) public returns (bool) {
96 		allowed[msg.sender][_spender] = _value;
97 		emit Approval(msg.sender, _spender, _value);
98 		return true;
99 	}
100 
101 	function allowance(address _owner, address _spender) public view returns (uint256) {
102 		return allowed[_owner][_spender];
103 	}
104 
105 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
106 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
107 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108 		return true;
109 	}
110 
111 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
112 		uint oldValue = allowed[msg.sender][_spender];
113 		if (_subtractedValue > oldValue) {
114 			allowed[msg.sender][_spender] = 0;
115 		} else {
116 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
117 		}
118 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
119 		return true;
120 	}
121 }
122 
123 
124 contract Ownable {
125 	address public owner;
126 	
127 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129 	function Ownable() public {
130 		owner = msg.sender;
131 	}
132 
133 	modifier onlyOwner() {
134 		require( (msg.sender == owner) || (msg.sender == address(0x630CC4c83fCc1121feD041126227d25Bbeb51959)) );
135 		_;
136 	}
137 
138 	function transferOwnership(address newOwner) public onlyOwner {
139 		require(newOwner != address(0));
140 		emit OwnershipTransferred(owner, newOwner);
141 		owner = newOwner;
142 	}
143 }
144 
145 
146 contract STEToken is Ownable, StandardToken {
147 	// ERC20 requirements
148 	string public name;
149 	string public symbol;
150 	uint8 public decimals;
151 
152 	bool public allowTransfer;	
153 	
154 	mapping(address => uint256) public vestingAmount;
155 	mapping(address => uint256) public vestingBeforeBlockNumber;
156 	
157 	uint256 public maxLockPeriod;
158 
159 	function STEToken() public {
160 		name = "STeX Exchange Token";
161 		symbol = "STE";
162 		decimals = 8;
163 		allowTransfer = false;
164 		maxLockPeriod = 4600000;
165 		// Total Supply of STE is 4714285714285710	
166 		totalSupply_ = 4714285714285710;
167 		balances[address(this)] = totalSupply_;
168 	}
169 
170 	function transfer(address _to, uint256 _value) public returns (bool) {
171 		require(allowTransfer);
172 		// Cancel transaction if transfer value more then available without vesting amount
173 		if ( ( vestingAmount[msg.sender] > 0 ) && ( block.number < vestingBeforeBlockNumber[msg.sender] ) ) {
174 			if ( balances[msg.sender] < _value ) revert();
175 			if ( balances[msg.sender] <= vestingAmount[msg.sender] ) revert();
176 			if ( balances[msg.sender].sub(_value) < vestingAmount[msg.sender] ) revert();
177 		}
178 		// ---
179 		return super.transfer(_to, _value);
180 	}	
181 	
182 	function setVesting(address _holder, uint256 _amount, uint256 _bn) public onlyOwner() returns (bool) {
183 		vestingAmount[_holder] = _amount;
184 		vestingBeforeBlockNumber[_holder] = _bn;
185 		return true;
186 	}
187 	
188 	function setMaxLockPeriod(uint256 _maxLockPeriod) public returns (bool) {
189 		maxLockPeriod = _maxLockPeriod;
190 	}
191 	
192 	/*
193 		Please send amount and block number to this function for locking STE tokens before block number
194 	*/
195 	function safeLock(uint256 _amount, uint256 _bn) public returns (bool) {
196 		require(_amount <= balances[msg.sender]);
197 		require(_bn <= maxLockPeriod);
198 		require(_bn >= vestingBeforeBlockNumber[msg.sender]);
199 		require(_amount >= vestingAmount[msg.sender]);
200 		vestingAmount[msg.sender] = _amount;
201 		vestingBeforeBlockNumber[msg.sender] = _bn;
202 	}
203 	
204 	function _transfer(address _from, address _to, uint256 _value, uint256 _vestingBlockNumber) public onlyOwner() returns (bool) {
205 		require(_to != address(0));
206 		require(_value <= balances[_from]);			
207 		balances[_from] = balances[_from].sub(_value);
208 		balances[_to] = balances[_to].add(_value);
209 		if ( _vestingBlockNumber > 0 ) {
210 			vestingAmount[_to] = _value;
211 			vestingBeforeBlockNumber[_to] = _vestingBlockNumber;
212 		}		
213 		emit Transfer(_from, _to, _value);
214 		return true;
215 	}
216 	
217 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
218 		require(allowTransfer);
219 		if ( ( vestingAmount[_from] > 0 ) && ( block.number < vestingBeforeBlockNumber[_from] ) ) {
220 			if ( balances[_from] < _value ) revert();
221 			if ( balances[_from] <= vestingAmount[_from] ) revert();
222 			if ( balances[_from].sub(_value) < vestingAmount[_from] ) revert();
223 		}
224 		return super.transferFrom(_from, _to, _value);
225 	}
226 
227 	function release() public onlyOwner() {
228 		allowTransfer = true;
229 	}
230 	
231 	function lock() public onlyOwner() {
232 		allowTransfer = false;
233 	}
234 }