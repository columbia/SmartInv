1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4 	function totalSupply() public view returns (uint256);
5 	function balanceOf(address who) public view returns (uint256);
6 	function transfer(address to, uint256 value) public returns (bool);
7 	event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11 	function allowance(address owner, address spender) public view returns (uint256);
12 	function transferFrom(address from, address to, uint256 value) public returns (bool);
13 	function approve(address spender, uint256 value) public returns (bool);
14 	event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract BasicToken is ERC20Basic {
18 	using SafeMath for uint256;
19 
20 	mapping(address => uint256) balances;
21 
22 	uint256 totalSupply_;
23 
24 	function totalSupply() public view returns (uint256) {
25 		return totalSupply_;
26 	}
27 
28 	function transfer(address _to, uint256 _value) public returns (bool) {
29 		require(_to != address(0));
30 		require(_value <= balances[msg.sender]);
31 
32 		balances[msg.sender] = balances[msg.sender].sub(_value);
33 		balances[_to] = balances[_to].add(_value);
34 		Transfer(msg.sender, _to, _value);
35 		return true;
36 	}
37 
38 	function balanceOf(address _owner) public view returns (uint256 balance) {
39 		return balances[_owner];
40 	}
41 
42 }
43 
44 contract StandardToken is ERC20, BasicToken {
45 
46 	mapping (address => mapping (address => uint256)) internal allowed;
47 
48 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
49 		require(_to != address(0));
50 		require(_value <= balances[_from]);
51 		require(_value <= allowed[_from][msg.sender]);
52 
53 		balances[_from] = balances[_from].sub(_value);
54 		balances[_to] = balances[_to].add(_value);
55 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
56 		Transfer(_from, _to, _value);
57 		return true;
58 	}
59 
60 	function approve(address _spender, uint256 _value) public returns (bool) {
61 		allowed[msg.sender][_spender] = _value;
62 		Approval(msg.sender, _spender, _value);
63 		return true;
64 	}
65 
66 	function allowance(address _owner, address _spender) public view returns (uint256) {
67 		return allowed[_owner][_spender];
68 	}
69 
70 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
71 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
72 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
73 		return true;
74 	}
75 
76 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
77 		uint oldValue = allowed[msg.sender][_spender];
78 		if (_subtractedValue > oldValue) {
79 			allowed[msg.sender][_spender] = 0;
80 		} else {
81 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
82 		}
83 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
84 		return true;
85 	}
86 
87 }
88 
89 contract BurnableToken is BasicToken {
90 
91     event Burn(address indexed burner, uint256 value);
92 
93     function burn(uint256 _value) public {
94         require(_value <= balances[msg.sender]);
95 
96         address burner = msg.sender;
97         balances[burner] = balances[burner].sub(_value);
98         totalSupply_ = totalSupply_.sub(_value);
99         Burn(burner, _value);
100         Transfer(burner, address(0), _value);
101     }
102 }
103 
104 library SafeMath {
105 
106 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107 		if (a == 0) {
108 			return 0;
109 		}
110 		uint256 c = a * b;
111 		assert(c / a == b);
112 		return c;
113 	}
114 
115 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
116 		uint256 c = a / b;
117 		return c;
118 	}
119 
120 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121 		assert(b <= a);
122 		return a - b;
123 	}
124 
125 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
126 		uint256 c = a + b;
127 		assert(c >= a);
128 		return c;
129 	}
130 }
131 
132 contract Ownable {
133 	address public owner;
134 
135 
136 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138 
139 	function Ownable() public {
140 		owner = msg.sender;
141 	}
142 
143 	modifier onlyOwner() {
144 		require(msg.sender == owner);
145 		_;
146 	}
147 
148 	function transferOwnership(address newOwner) public onlyOwner {
149 		require(newOwner != address(0));
150 		OwnershipTransferred(owner, newOwner);
151 		owner = newOwner;
152 	}
153 
154 }
155 
156 contract TriggmineToken is StandardToken, BurnableToken, Ownable {
157 
158 	string public constant name = "Triggmine Coin";
159 
160 	string public constant symbol = "TRG";
161 
162 	uint256 public constant decimals = 18;
163 
164 	bool public released = false;
165 	event Release();
166 
167 	address public holder;
168 
169 	mapping(address => uint) public lockedAddresses;
170 
171 	modifier isReleased () {
172 		require(released || msg.sender == holder || msg.sender == owner);
173 		require(lockedAddresses[msg.sender] <= now);
174 		_;
175 	}
176 
177 	function TriggmineToken() public {
178 		owner = 0x7E83f1F82Ab7dDE49F620D2546BfFB0539058414;
179 
180 		totalSupply_ = 620000000 * (10 ** decimals);
181 		balances[owner] = totalSupply_;
182 		Transfer(0x0, owner, totalSupply_);
183 
184 		holder = owner;
185 	}
186 
187 	function lockAddress(address _lockedAddress, uint256 _time) public onlyOwner returns (bool) {
188 		require(balances[_lockedAddress] == 0 && lockedAddresses[_lockedAddress] == 0 && _time > now);
189 		lockedAddresses[_lockedAddress] = _time;
190 		return true;
191 	}
192 
193 	function release() onlyOwner public returns (bool) {
194 		require(!released);
195 		released = true;
196 		Release();
197 
198 		return true;
199 	}
200 
201 	function getOwner() public view returns (address) {
202 		return owner;
203 	}
204 
205 	function transfer(address _to, uint256 _value) public isReleased returns (bool) {
206 		return super.transfer(_to, _value);
207 	}
208 
209 	function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {
210 		return super.transferFrom(_from, _to, _value);
211 	}
212 
213 	function approve(address _spender, uint256 _value) public isReleased returns (bool) {
214 		return super.approve(_spender, _value);
215 	}
216 
217 	function increaseApproval(address _spender, uint _addedValue) public isReleased returns (bool success) {
218 		return super.increaseApproval(_spender, _addedValue);
219 	}
220 
221 	function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {
222 		return super.decreaseApproval(_spender, _subtractedValue);
223 	}
224 
225 	function transferOwnership(address newOwner) public onlyOwner {
226 		address oldOwner = owner;
227 		super.transferOwnership(newOwner);
228 
229 		if (oldOwner != holder) {
230 			allowed[holder][oldOwner] = 0;
231 			Approval(holder, oldOwner, 0);
232 		}
233 
234 		if (owner != holder) {
235 			allowed[holder][owner] = balances[holder];
236 			Approval(holder, owner, balances[holder]);
237 		}
238 	}
239 
240 }