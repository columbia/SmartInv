1 pragma solidity ^0.4.18;
2  
3 interface ERC20 {
4 	//ERC-20 Token Standard https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
5 	
6 	function name() public view returns (string);
7 	function symbol() public view returns (string);
8 	function decimals() public view returns (uint8);
9 	function totalSupply() public view returns (uint256);
10 	function balanceOf(address _owner) public view returns (uint256);
11 	function transfer(address _to, uint256 _value) public returns (bool success);
12 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13 	function approve(address _spender, uint256 _value) public returns (bool success);
14 	function allowance(address _owner, address _spender) public view returns (uint256);
15 	
16 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 interface TokenRecipient { 
21 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
22 }
23 
24 interface ERC223Receiver {
25     function tokenFallback(address _from, uint256 _value, bytes _data) public;
26 }
27 
28 contract ERC223 is ERC20 {
29 	//ERC223 token standard https://github.com/Dexaran/ERC223-token-standard
30 	
31 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
32 	function transfer(address _to, uint256 _value, bytes _data, string _customFallback) public returns (bool success);
33 	
34 	event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
35 }
36 
37 contract NGToken is ERC223 {
38 	string constant private NAME 			= "NEO Genesis Token";
39 	string constant private SYMBOL	 		= "NGT";
40 	uint8 constant private DECIMALS 		= 18;
41 	uint256 constant private INITIAL_SUPPLY	= 20000000000 * (10 ** uint256(DECIMALS));
42 	uint256 private totalBurned				= 0;
43 	mapping(address => uint256) private balances;
44 	mapping(address => mapping(address => uint256)) private allowed;
45 	
46 	function NGToken() public {
47 	  balances[msg.sender] = INITIAL_SUPPLY;
48 	}
49 	
50 	//ERC20
51 	function name() public view returns (string) {
52 		return NAME;
53 	}
54 	
55 	function symbol() public view returns (string) {
56 		return SYMBOL;
57 	}
58 	
59 	function decimals() public view returns (uint8) {
60 		return DECIMALS;
61 	}
62 	
63 	function totalSupply() public view returns (uint256) {
64 		return INITIAL_SUPPLY - totalBurned;
65 	}
66 
67 	function balanceOf(address _owner) public view returns (uint256) {
68 		return balances[_owner];
69 	}
70 	
71 	function transfer(address _to, uint256 _value) public returns (bool success) {
72 		if (isContract(_to)) {
73 			bytes memory empty;
74 			return transferToContract(_to, _value, empty);
75 		} else {
76 			require(_to != address(0x0));
77 			require(balances[msg.sender] >= _value);
78 			balances[msg.sender] -= _value;
79 			balances[_to] += _value;
80 			Transfer(msg.sender, _to, _value);
81 			// Transfer(msg.sender, _to, _value, _data);
82 		}
83 		return true;
84 	}
85 
86 	function multipleTransfer(address[] _to, uint256 _value) public returns (bool success) {
87 		require(_value * _to.length > 0);
88 		require(balances[msg.sender] >= _value * _to.length);
89 		balances[msg.sender] -= _value * _to.length;
90 		for (uint256 i = 0; i < _to.length; ++i) {
91 		 	balances[_to[i]] += _value;
92 		 	Transfer(msg.sender, _to[i], _value);
93 		}
94 		return true;
95 	}
96 
97 	function batchTransfer(address[] _to, uint256[] _value) public returns (bool success) {
98 		require(_to.length > 0);
99 		require(_value.length > 0);
100 		require(_to.length == _value.length);
101 		for (uint256 i = 0; i < _to.length; ++i) {
102 			address to = _to[i];
103 			uint256 value = _value[i];
104 			require(balances[msg.sender] >= value);
105 			balances[msg.sender] -= value;
106 		 	balances[to] += value;
107 		 	Transfer(msg.sender, to, value);
108 		}
109 		return true;
110 	}
111 
112 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
113 		require(_to != address(0x0));
114         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
115         balances[_from] -= _value;
116         balances[_to] += _value;
117 		allowed[_from][msg.sender] -= _value;
118         Transfer(_from, _to, _value);
119 		bytes memory empty;
120 		Transfer(_from, _to, _value, empty);
121         return true;
122 	}
123 	
124 	function approve(address _spender, uint256 _value) public returns (bool success) {
125 		//https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
126 		//force to 0 before calling "approve" again
127 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
128 		
129 		allowed[msg.sender][_spender] = _value;
130 		Approval(msg.sender, _spender, _value);
131 		return true;
132 	}
133 	
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
135         TokenRecipient spender = TokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140 		return false;
141     }
142 
143 	function increaseApproval(address _spender, uint256 _addValue) public returns (bool) {
144 		allowed[msg.sender][_spender] += _addValue;
145 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146 		return true;
147 	}
148 
149 	function decreaseApproval(address _spender, uint256 _subValue) public returns (bool) {
150 		if (_subValue > allowed[msg.sender][_spender]) {
151 		  allowed[msg.sender][_spender] = 0;
152 		} else {
153 		  allowed[msg.sender][_spender] -= _subValue;
154 		}
155 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156 		return true;
157 	}	
158 	
159 	function allowance(address _owner, address _spender) public view returns (uint256) {
160 		return allowed[_owner][_spender];
161 	}
162 	
163 	//ERC233
164 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
165 		if (isContract(_to)) {
166 			return transferToContract(_to, _value, _data);
167 		} else {
168 			return transferToAddress(_to, _value, _data);
169 		}
170 	}
171 
172 	function transfer(address _to, uint256 _value, bytes _data, string _customFallback) public returns (bool success) {
173 		if (isContract(_to)) {
174 			require(_to != address(0x0));
175 			require(balances[msg.sender] >= _value);
176 			balances[msg.sender] -= _value;
177 			balances[_to] += _value;
178 			assert(_to.call.value(0)(bytes4(keccak256(_customFallback)), msg.sender, _value, _data));
179 			Transfer(msg.sender, _to, _value);
180 			Transfer(msg.sender, _to, _value, _data);
181 			return true;
182 		} else {
183 			return transferToAddress(_to, _value, _data);
184 		}
185 	}
186 
187     function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
188 		require(_to != address(0x0));
189 		require(balances[msg.sender] >= _value);
190 		balances[msg.sender] -= _value;
191 		balances[_to] += _value;
192 		Transfer(msg.sender, _to, _value);
193 		Transfer(msg.sender, _to, _value, _data);
194 		return true;
195     }
196 
197     function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
198 		require(_to != address(0x0));
199 		require(balances[msg.sender] >= _value);
200 		balances[msg.sender] -= _value;
201 		balances[_to] += _value;
202 		ERC223Receiver receiver = ERC223Receiver(_to);
203 		receiver.tokenFallback(msg.sender, _value, _data);
204         Transfer(msg.sender, _to, _value);
205         Transfer(msg.sender, _to, _value, _data);
206         return true;
207     }
208 
209 	function isContract(address _addr) private view returns (bool) {
210         // if (_addr == address(0x0))
211 		// 	return false;
212         uint256 length;
213         assembly {
214             length := extcodesize(_addr)
215         }
216 		return (length > 0);
217     }
218 	
219 	//Burn
220     event Burn(address indexed burner, uint256 value, uint256 currentSupply, bytes data);
221 
222     function burn(uint256 _value, bytes _data) public returns (bool success) {
223 		require(balances[msg.sender] >= _value);
224 		balances[msg.sender] -= _value;
225 		totalBurned += _value;
226 		Burn(msg.sender, _value, totalSupply(), _data);
227 		return true;
228     }
229 
230     function burnFrom(address _from, uint256 _value, bytes _data) public returns (bool success) {
231 		if (transferFrom(_from, msg.sender, _value)) {
232 			return burn(_value, _data);
233 		}
234         return false;
235     }
236 
237 	function initialSupply() public pure returns (uint256) {
238 		return INITIAL_SUPPLY;
239 	}
240 
241 	function currentBurned() public view returns (uint256) {
242 		return totalBurned;
243 	}
244 
245 	//Stop
246 	function () public {
247         require(false);
248     }
249 }