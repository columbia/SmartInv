1 /*                   -:////:-.                    
2               `:ohmMMMMMMMMMMMMmho:`              
3            `+hMMMMMMMMMMMMMMMMMMMMMMh+`           
4          .yMMMMMMMmyo/:----:/oymMMMMMMMy.         
5        `sMMMMMMy/`              `/yMMMMMMs`       
6       -NMMMMNo`    ./sydddhys/.    `oNMMMMN-        *** Secure Email & File Storage ***
7      /MMMMMy`   .sNMMMMMMMMMMMMmo.   `yMMMMM/       
8     :MMMMM+   `yMMMMMMNmddmMMMMMMMs`   +MMMMM:      https://safe.ad
9     mMMMMo   .NMMMMNo-  ``  -sNMMMMm.   oMMMMm      
10    /MMMMm   `mMMMMy`  `hMMm:  `hMMMMm    mMMMM/     
11    yMMMMo   +MMMMd    .NMMM+    mMMMM/   oMMMMy     
12    hMMMM/   sMMMMs     :MMy     yMMMMo   /MMMMh     
13    yMMMMo   +MMMMd     yMMN`   `mMMMM:   oMMMMy   
14    /MMMMm   `mMMMMh`  `MMMM/   +MMMMd    mMMMM/     
15     mMMMMo   .mMMMMNs-`'`'`    /MMMMm- `sMMMMm    
16     :MMMMM+   `sMMMMMMMmmmmy.   hMMMMMMMMMMMN-      
17      /MMMMMy`   .omMMMMMMMMMy    +mMMMMMMMMy.     
18       -NMMMMNo`    ./oyhhhho`      ./oso+:`       
19        `sMMMMMMy/`              `-.               
20          .yMMMMMMMmyo/:----:/oymMMMd`             
21            `+hMMMMMMMMMMMMMMMMMMMMMN.             
22               `:ohmMMMMMMMMMMMMmho:               
23                     .-:////:-.                    
24                                                   
25 
26 */
27 
28 pragma solidity ^0.4.18;
29 
30 /* SAFEToken contract v 1.0 */
31 
32 contract ERC20Interface{
33 
34 	function balanceOf(address) public constant returns (uint256);
35 	function transfer(address, uint256) public returns (bool);
36 
37 }
38 
39 contract SAFEToken{
40 
41 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
42 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 	event MintingAgentChanged(address _addr, bool _state);
44 	event Mint(address indexed _to, uint256 _value);
45 	event MintFinished();
46 	event UpdatedTokenInformation(string _newName, string _newSymbol, uint8 _newDecimals);
47 	event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
48 	event TransfersAreAllowed();
49 	event Error(address indexed _self, uint8 _errorCode);
50 
51 	uint256 constant private MAX_UINT256 = 2**256 - 1;
52 	uint8 constant private ERROR_ZERO_ADDRESS = 1;
53 	uint8 constant private ERROR_INSUFICIENT_BALANCE = 2;
54 	uint8 constant private ERROR_INSUFICIENT_ALLOWENCE = 3;
55 	uint8 constant private ERROR_ARRAYS_LENGTH_DIFF = 4;
56 	uint8 constant private ERROR_INT_OVERFLOW = 5;
57 	uint8 constant private ERROR_UNAUTHORIZED = 6;
58 	uint8 constant private ERROR_TRANSFER_NOT_ALLOWED = 7;
59 
60 	string public name;
61 	string public symbol;
62 	uint8 public decimals;
63 	bool public transfersSuspended = true;
64 	address owner;
65 	uint256 totalSupply_ = 0;
66 	bool mintingFinished = false;
67 	mapping(address => uint256) balances;
68 	mapping(address => mapping(address => uint256)) internal allowed;
69 	mapping(address => bool) mintAgents;
70 
71 	modifier onlyOwner(){
72 
73 		require(msg.sender == owner);
74 		_;
75 
76 	}
77 
78 	modifier onlyMintAgent(){
79 
80 		require(mintAgents[msg.sender]);
81 		_;
82 
83 	}
84 
85 	modifier canMint(){
86 
87 		require(!mintingFinished);
88 		_;
89 
90 	}
91 
92 	function SAFEToken(uint256 _totalSupply, string _name, string _symbol, uint8 _decimals) public{
93 
94 		totalSupply_ = _totalSupply;
95 		owner = msg.sender;
96 		name = _name;
97 		symbol = _symbol;
98 		decimals = _decimals;
99 		balances[owner] = totalSupply_;
100 
101 	}
102     
103 	function totalSupply() public view returns (uint256){
104 
105 		return totalSupply_;
106 
107 	}
108 
109 	function transfer(address _to, uint256 _value) public returns (bool){
110 
111 		if(transfersSuspended) return isError(ERROR_TRANSFER_NOT_ALLOWED);
112 		if(_to == address(0)) return isError(ERROR_ZERO_ADDRESS);
113 		if(balances[msg.sender] < _value) return isError(ERROR_INSUFICIENT_BALANCE);
114 		balances[msg.sender] -= _value;
115 		balances[_to] += _value;
116 		Transfer(msg.sender, _to, _value);
117 		return true;
118 
119 	}
120 
121 	function balanceOf(address _owner) public view returns (uint256){
122 
123 		return balances[_owner];
124 
125 	}
126 
127 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
128 
129 		if(transfersSuspended) return isError(ERROR_TRANSFER_NOT_ALLOWED);
130 		uint256 allowance = allowed[_from][msg.sender];
131 		if(balances[_from] < _value) return isError(ERROR_INSUFICIENT_BALANCE);
132 		if(allowance < _value) return isError(ERROR_INSUFICIENT_ALLOWENCE);
133 		balances[_to] += _value;
134 		balances[_from] -= _value;
135 		if(allowance < MAX_UINT256) allowed[_from][msg.sender] -= _value;
136 		Transfer(_from, _to, _value);
137 		return true;
138 
139 	}
140 
141 	function approve(address _spender, uint256 _value) public returns (bool success){
142 
143 		if(transfersSuspended) return isError(ERROR_TRANSFER_NOT_ALLOWED);
144 		if(_spender == address(0)) return isError(ERROR_ZERO_ADDRESS);
145 		allowed[msg.sender][_spender] = _value;
146 		Approval(msg.sender, _spender, _value);
147 		return true;
148 
149 	}
150 
151 	function allowance(address _owner, address _spender) public view returns (uint256){
152 
153 		return allowed[_owner][_spender];
154 
155 	}
156 
157 	function mint(address[] _receivers, uint256[] _values) public onlyMintAgent canMint returns (bool){
158 
159 		if(_receivers.length != _values.length) return isError(ERROR_ARRAYS_LENGTH_DIFF);
160 
161 		for(uint256 i = 0; i < _receivers.length; ++i){
162 
163 			if(totalSupply_ + _values[i] < totalSupply_) return isError(ERROR_INT_OVERFLOW);
164 			totalSupply_ += _values[i];
165 
166 		}
167 			
168 		for(i = 0; i < _receivers.length; ++i){
169 
170 			balances[_receivers[i]] += _values[i];
171 			Mint(_receivers[i], _values[i]);
172 			Transfer(address(0), _receivers[i], _values[i]);
173 
174 		}
175 
176 		return true;
177 
178 	}
179 
180 	function setMintAgent(address _addr, bool _state) onlyOwner canMint public returns (bool){
181 
182 		if(_addr == address(0)) return isError(ERROR_ZERO_ADDRESS);
183 		mintAgents[_addr] = _state;
184 		MintingAgentChanged(_addr, _state);
185 		return true;
186 
187 	}
188 
189 	function finishMinting() onlyOwner canMint public returns (bool){
190 
191 		mintingFinished = true;
192 		MintFinished();
193 		return true;
194 
195 	}
196 
197 	function allowTransfers() onlyOwner public returns (bool){
198 
199 		transfersSuspended = false;
200 		TransfersAreAllowed();
201 		return true;
202 
203 	}
204 
205 	function changeOwner(address _newOwner) public onlyOwner returns(bool){
206 
207 		if(_newOwner == address(0)) return isError(ERROR_ZERO_ADDRESS);
208 		address prevOwner = owner;
209 		owner = _newOwner;
210 		OwnershipTransferred(prevOwner, owner);
211 		return true;
212 
213 	}
214     
215 	function setTokenInformation(string _name, string _symbol, uint8 _decimals) public onlyOwner returns (bool){
216 
217 		name = _name;
218 		symbol = _symbol;
219 		decimals = _decimals;
220 		UpdatedTokenInformation(_name, _symbol, _decimals);
221 		return true;
222 
223 	}
224 
225 	function withdrawnTokens(address[] _tokens, address _to) public onlyOwner returns (bool){
226 
227 		for(uint256 i = 0; i < _tokens.length; i++){
228 
229 			address token = _tokens[i];
230 			uint256 balance = ERC20Interface(token).balanceOf(this);
231 			if(balance != 0) ERC20Interface(token).transfer(_to, balance);
232 
233 		}
234 
235 		return true;
236 	
237 	}
238 
239 	function isError(uint8 _error) private returns (bool){
240 
241 		Error(msg.sender, _error);
242 		return false;
243 
244 	}
245 
246 }