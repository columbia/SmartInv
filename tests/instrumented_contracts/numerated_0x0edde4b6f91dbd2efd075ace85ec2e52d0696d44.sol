1 pragma solidity ^0.4.15;
2 
3 /**
4  *
5  * @author  <newtwist@protonmail.com>
6  *
7  * Version D
8  *
9  * Overview:
10  * This is an implimentation of a `burnable` token. The tokens do not pay any dividends; however if/when tokens
11  * are `burned`, the burner gets a share of whatever funds the contract owns at that time. No provision is made
12  * for how tokens are sold; all tokens are initially credited to the contract owner. There is a provision to
13  * establish a single `restricted` account. The restricted account can own tokens, but cannot transfer them or
14  * burn them until after a certain date. . There is also a function to burn tokens without getting paid. This is
15  * useful, for example, if the sale-contract/owner wants to reduce the supply of tokens.
16  *
17  */
18 //import './SafeMath.sol';
19 pragma solidity ^0.4.18;
20 
21 /*
22     Overflow protected math functions
23 */
24 contract SafeMath {
25     /**
26         constructor
27     */
28     function SafeMath() public {
29     }
30 
31     /**
32         @dev returns the sum of _x and _y, asserts if the calculation overflows
33 
34         @param _x   value 1
35         @param _y   value 2
36 
37         @return sum
38     */
39     function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {
40         uint256 z = _x + _y;
41         assert(z >= _x);
42         return z;
43     }
44 
45     /**
46         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
47 
48         @param _x   minuend
49         @param _y   subtrahend
50 
51         @return difference
52     */
53     function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {
54         assert(_x >= _y);
55         return _x - _y;
56     }
57 
58     /**
59         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
60 
61         @param _x   factor 1
62         @param _y   factor 2
63 
64         @return product
65     */
66     function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {
67         uint256 z = _x * _y;
68         assert(_x == 0 || z / _x == _y);
69         return z;
70     }
71 }
72 
73 //import './iBurnableToken.sol';
74 pragma solidity ^0.4.15;
75 
76 //Burnable Token interface
77 
78 //import './iERC20Token.sol';
79 
80 pragma solidity ^0.4.15;
81 
82 // Token standard API
83 // https://github.com/ethereum/EIPs/issues/20
84 
85 contract iERC20Token {
86   function totalSupply() public constant returns (uint supply);
87   function balanceOf( address who ) public constant returns (uint value);
88   function allowance( address owner, address spender ) public constant returns (uint remaining);
89 
90   function transfer( address to, uint value) public returns (bool ok);
91   function transferFrom( address from, address to, uint value) public returns (bool ok);
92   function approve( address spender, uint value ) public returns (bool ok);
93 
94   event Transfer( address indexed from, address indexed to, uint value);
95   event Approval( address indexed owner, address indexed spender, uint value);
96 }
97 
98 contract iBurnableToken is iERC20Token {
99   function burnTokens(uint _burnCount) public;
100   function unPaidBurnTokens(uint _burnCount) public;
101 }
102 
103 
104 contract BurnableToken is iBurnableToken, SafeMath {
105 
106   event PaymentEvent(address indexed from, uint amount);
107   event TransferEvent(address indexed from, address indexed to, uint amount);
108   event ApprovalEvent(address indexed from, address indexed to, uint amount);
109   event BurnEvent(address indexed from, uint count, uint value);
110 
111   string  public symbol;
112   string  public name;
113   bool    public isLocked;
114   uint    public decimals;
115   uint    public restrictUntil;                              //vesting for developer tokens
116   uint           tokenSupply;                                //can never be increased; but tokens can be burned
117   address public owner;
118   address public restrictedAcct;                             //no transfers from this addr during vest time
119   mapping (address => uint) balances;
120   mapping (address => mapping (address => uint)) approvals;  //transfer approvals, from -> to
121 
122 
123   modifier ownerOnly {
124     require(msg.sender == owner);
125     _;
126   }
127 
128   modifier unlockedOnly {
129     require(!isLocked);
130     _;
131   }
132 
133   modifier preventRestricted {
134     require((msg.sender != restrictedAcct) || (now >= restrictUntil));
135     _;
136   }
137 
138 
139   //
140   //constructor
141   //
142   function BurnableToken() public {
143     owner = msg.sender;
144   }
145 
146 
147   //
148   // ERC-20
149   //
150 
151   function totalSupply() public constant returns (uint supply) { supply = tokenSupply; }
152 
153   function transfer(address _to, uint _value) public preventRestricted returns (bool success) {
154     //if token supply was not limited then we would prevent wrap:
155     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to])
156     if (balances[msg.sender] >= _value && _value > 0) {
157       balances[msg.sender] -= _value;
158       balances[_to] += _value;
159       TransferEvent(msg.sender, _to, _value);
160       return true;
161     } else {
162       return false;
163     }
164   }
165 
166 
167   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
168     //if token supply was not limited then we would prevent wrap:
169     //if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to])
170     if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && _value > 0) {
171       balances[_from] -= _value;
172       balances[_to] += _value;
173       approvals[_from][msg.sender] -= _value;
174       TransferEvent(_from, _to, _value);
175       return true;
176     } else {
177       return false;
178     }
179   }
180 
181 
182   function balanceOf(address _owner) public constant returns (uint balance) {
183     balance = balances[_owner];
184   }
185 
186 
187   function approve(address _spender, uint _value) public preventRestricted returns (bool success) {
188     approvals[msg.sender][_spender] = _value;
189     ApprovalEvent(msg.sender, _spender, _value);
190     return true;
191   }
192 
193 
194   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
195     return approvals[_owner][_spender];
196   }
197 
198 
199   //
200   // END ERC20
201   //
202 
203 
204   //
205   // default payable function.
206   //
207   function () public payable {
208     PaymentEvent(msg.sender, msg.value);
209   }
210 
211   function initTokenSupply(uint _tokenSupply, uint _decimals) public ownerOnly {
212     require(tokenSupply == 0);
213     tokenSupply = _tokenSupply;
214     balances[owner] = tokenSupply;
215     decimals = _decimals;
216   }
217 
218   function setName(string _name, string _symbol) public ownerOnly {
219     name = _name;
220     symbol = _symbol;
221   }
222 
223   function lock() public ownerOnly {
224     isLocked = true;
225   }
226 
227   function setRestrictedAcct(address _restrictedAcct, uint _restrictUntil) public ownerOnly unlockedOnly {
228     restrictedAcct = _restrictedAcct;
229     restrictUntil = _restrictUntil;
230   }
231 
232   function tokenValue() constant public returns (uint _value) {
233     _value = this.balance / tokenSupply;
234   }
235 
236   function valueOf(address _owner) constant public returns (uint _value) {
237     _value = (this.balance * balances[_owner]) / tokenSupply;
238   }
239 
240   function burnTokens(uint _burnCount) public preventRestricted {
241     if (balances[msg.sender] >= _burnCount && _burnCount > 0) {
242       uint _value = safeMul(this.balance, _burnCount) / tokenSupply;
243       tokenSupply = safeSub(tokenSupply, _burnCount);
244       balances[msg.sender] = safeSub(balances[msg.sender], _burnCount);
245       msg.sender.transfer(_value);
246       BurnEvent(msg.sender, _burnCount, _value);
247     }
248   }
249 
250   function unPaidBurnTokens(uint _burnCount) public preventRestricted {
251     if (balances[msg.sender] >= _burnCount && _burnCount > 0) {
252       tokenSupply = safeSub(tokenSupply, _burnCount);
253       balances[msg.sender] = safeSub(balances[msg.sender], _burnCount);
254       BurnEvent(msg.sender, _burnCount, 0);
255     }
256   }
257 
258   //for debug
259   //only available before the contract is locked
260   function haraKiri() public ownerOnly unlockedOnly {
261     selfdestruct(owner);
262   }
263 
264 }