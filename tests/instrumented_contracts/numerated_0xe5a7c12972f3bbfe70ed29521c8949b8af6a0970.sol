1 pragma solidity ^0.4.10;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 /// @title ICONOMI Daa token
6 contract DaaToken {
7   //
8   // events
9   //
10   // ERC20 events
11   event Transfer(address indexed _from, address indexed _to, uint256 _value);
12   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 
14   // mint/burn events
15   event Mint(address indexed _to, uint256 _amount, uint256 _newTotalSupply);
16   event Burn(address indexed _from, uint256 _amount, uint256 _newTotalSupply);
17 
18   // admin events
19   event BlockLockSet(uint256 _value);
20   event NewOwner(address _newOwner);
21   event NewMinter(address _minter);
22 
23   modifier onlyOwner {
24     if (msg.sender == owner) {
25       _;
26     }
27   }
28 
29   modifier minterOrOwner {
30     if (msg.sender == minter || msg.sender == owner) {
31       _;
32     }
33   }
34 
35   modifier blockLock(address _sender) {
36     if (!isLocked() || _sender == owner) {
37       _;
38     }
39   }
40 
41   modifier validTransfer(address _from, address _to, uint256 _amount) {
42     if (isTransferValid(_from, _to, _amount)) {
43       _;
44     }
45   }
46 
47   uint256 public totalSupply;
48   string public name;
49   uint8 public decimals;
50   string public symbol;
51   string public version = '0.0.1';
52   address public owner;
53   address public minter;
54   uint256 public lockedUntilBlock;
55 
56   function DaaToken(
57       string _tokenName,
58       uint8 _decimalUnits,
59       string _tokenSymbol,
60       uint256 _lockedUntilBlock
61   ) {
62 
63     name = _tokenName;
64     decimals = _decimalUnits;
65     symbol = _tokenSymbol;
66     lockedUntilBlock = _lockedUntilBlock;
67     owner = msg.sender;
68   }
69 
70   function transfer(address _to, uint256 _value)
71       public
72       blockLock(msg.sender)
73       validTransfer(msg.sender, _to, _value)
74       returns (bool success)
75   {
76 
77     // transfer tokens
78     balances[msg.sender] -= _value;
79     balances[_to] += _value;
80 
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   function approve(address _spender, uint256 _value)
86       public
87       returns (bool success)
88   {
89     allowed[msg.sender][_spender] = _value;
90     Approval(msg.sender, _spender, _value);
91     return true;
92   }
93 
94   function transferFrom(address _from, address _to, uint256 _value)
95       public
96       blockLock(_from)
97       validTransfer(_from, _to, _value)
98       returns (bool success)
99   {
100 
101     // check sufficient allowance
102     if (_value > allowed[_from][msg.sender]) {
103       return false;
104     }
105 
106     // transfer tokens
107     balances[_from] -= _value;
108     balances[_to] += _value;
109     allowed[_from][msg.sender] -= _value;
110 
111     Transfer(_from, _to, _value);
112     return true;
113   }
114 
115   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
116       public
117       returns (bool success)
118   {
119     if (approve(_spender, _value)) {
120       tokenRecipient(_spender).receiveApproval(msg.sender, _value, this, _extraData);
121       return true;
122     }
123   }
124 
125   /// @notice Mint new tokens. Can only be called by minter or owner
126   function mint(address _to, uint256 _value)
127       public
128       minterOrOwner
129       blockLock(msg.sender)
130       returns (bool success)
131   {
132     // ensure _value is greater than zero and
133     // doesn't overflow
134     if (totalSupply + _value <= totalSupply) {
135       return false;
136     }
137 
138     balances[_to] += _value;
139     totalSupply += _value;
140 
141     Mint(_to, _value, totalSupply);
142     Transfer(0x0, _to, _value);
143 
144     return true;
145   }
146 
147   /// @notice Burn tokens. Can be called by any account
148   function burn(uint256 _value)
149       public
150       blockLock(msg.sender)
151       returns (bool success)
152   {
153     if (_value == 0 || _value > balances[msg.sender]) {
154       return false;
155     }
156 
157     balances[msg.sender] -= _value;
158     totalSupply -= _value;
159 
160     Burn(msg.sender, _value, totalSupply);
161     Transfer(msg.sender, 0x0, _value);
162 
163     return true;
164   }
165 
166   /// @notice Set block lock. Until that block (exclusive) transfers are disallowed
167   function setBlockLock(uint256 _lockedUntilBlock)
168       public
169       onlyOwner
170       returns (bool success)
171   {
172     lockedUntilBlock = _lockedUntilBlock;
173     BlockLockSet(_lockedUntilBlock);
174     return true;
175   }
176 
177   /// @notice Replace current owner with new one
178   function replaceOwner(address _newOwner)
179       public
180       onlyOwner
181       returns (bool success)
182   {
183     owner = _newOwner;
184     NewOwner(_newOwner);
185     return true;
186   }
187 
188   /// @notice Set account that can mint new tokens
189   function setMinter(address _newMinter)
190       public
191       onlyOwner
192       returns (bool success)
193   {
194     minter = _newMinter;
195     NewMinter(_newMinter);
196     return true;
197   }
198 
199   function balanceOf(address _owner)
200       public
201       constant
202       returns (uint256 balance)
203   {
204     return balances[_owner];
205   }
206 
207   function allowance(address _owner, address _spender)
208       public
209       constant
210       returns (uint256 remaining)
211   {
212     return allowed[_owner][_spender];
213   }
214 
215   /// @notice Are transfers currently disallowed
216   function isLocked()
217       public
218       constant
219       returns (bool success)
220   {
221     return lockedUntilBlock > block.number;
222   }
223 
224   /// @dev Checks if transfer parameters are valid
225   function isTransferValid(address _from, address _to, uint256 _amount)
226       private
227       constant
228       returns (bool isValid)
229   {
230     return  balances[_from] >= _amount &&  // sufficient balance
231             _amount > 0 &&                 // amount is positive
232             _to != address(this) &&        // prevent sending tokens to contract
233             _to != 0x0                     // prevent sending token to 0x0 address
234     ;
235   }
236 
237   mapping (address => uint256) balances;
238   mapping (address => mapping (address => uint256)) allowed;
239 }