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
19 pragma solidity ^0.4.11;
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
74 
75 pragma solidity ^0.4.15;
76 
77 //Burnable Token interface
78 
79 //import './iERC20Token.sol';
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
103 contract BurnableToken is iBurnableToken, SafeMath {
104 
105   event PaymentEvent(address indexed from, uint amount);
106   event TransferEvent(address indexed from, address indexed to, uint amount);
107   event ApprovalEvent(address indexed from, address indexed to, uint amount);
108   event BurnEvent(address indexed from, uint count, uint value);
109 
110   string  public symbol;
111   string  public name;
112   bool    public isLocked;
113   uint    public decimals;
114   uint    public restrictUntil;                              //vesting for developer tokens
115   uint           tokenSupply;                                //can never be increased; but tokens can be burned
116   address public owner;
117   address public restrictedAcct;                             //no transfers from this addr during vest time
118   mapping (address => uint) balances;
119   mapping (address => mapping (address => uint)) approvals;  //transfer approvals, from -> to
120 
121 
122   modifier ownerOnly {
123     require(msg.sender == owner);
124     _;
125   }
126 
127   modifier unlockedOnly {
128     require(!isLocked);
129     _;
130   }
131 
132   modifier preventRestricted {
133     require((msg.sender != restrictedAcct) || (now >= restrictUntil));
134     _;
135   }
136 
137 
138   //
139   //constructor
140   //
141   function BurnableToken() public {
142     owner = msg.sender;
143   }
144 
145 
146   //
147   // ERC-20
148   //
149 
150   function totalSupply() public constant returns (uint supply) { supply = tokenSupply; }
151 
152   function transfer(address _to, uint _value) public preventRestricted returns (bool success) {
153     //if token supply was not limited then we would prevent wrap:
154     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to])
155     if (balances[msg.sender] >= _value && _value > 0) {
156       balances[msg.sender] -= _value;
157       balances[_to] += _value;
158       TransferEvent(msg.sender, _to, _value);
159       return true;
160     } else {
161       return false;
162     }
163   }
164 
165 
166   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
167     //if token supply was not limited then we would prevent wrap:
168     //if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to])
169     if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && _value > 0) {
170       balances[_from] -= _value;
171       balances[_to] += _value;
172       approvals[_from][msg.sender] -= _value;
173       TransferEvent(_from, _to, _value);
174       return true;
175     } else {
176       return false;
177     }
178   }
179 
180 
181   function balanceOf(address _owner) public constant returns (uint balance) {
182     balance = balances[_owner];
183   }
184 
185 
186   function approve(address _spender, uint _value) public preventRestricted returns (bool success) {
187     approvals[msg.sender][_spender] = _value;
188     ApprovalEvent(msg.sender, _spender, _value);
189     return true;
190   }
191 
192 
193   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
194     return approvals[_owner][_spender];
195   }
196 
197 
198   //
199   // END ERC20
200   //
201 
202 
203   //
204   // default payable function.
205   //
206   function () public payable {
207     PaymentEvent(msg.sender, msg.value);
208   }
209 
210   function initTokenSupply(uint _tokenSupply, uint _decimals) public ownerOnly {
211     require(tokenSupply == 0);
212     tokenSupply = _tokenSupply;
213     balances[owner] = tokenSupply;
214     decimals = _decimals;
215   }
216 
217   function setName(string _name, string _symbol) public ownerOnly {
218     name = _name;
219     symbol = _symbol;
220   }
221 
222   function lock() public ownerOnly {
223     isLocked = true;
224   }
225 
226   function setRestrictedAcct(address _restrictedAcct, uint _restrictUntil) public ownerOnly unlockedOnly {
227     restrictedAcct = _restrictedAcct;
228     restrictUntil = _restrictUntil;
229   }
230 
231   function tokenValue() constant public returns (uint _value) {
232     _value = this.balance / tokenSupply;
233   }
234 
235   function valueOf(address _owner) constant public returns (uint _value) {
236     _value = (this.balance * balances[_owner]) / tokenSupply;
237   }
238 
239   function burnTokens(uint _burnCount) public preventRestricted {
240     if (balances[msg.sender] >= _burnCount && _burnCount > 0) {
241       uint _value = safeMul(this.balance, _burnCount) / tokenSupply;
242       tokenSupply = safeSub(tokenSupply, _burnCount);
243       balances[msg.sender] = safeSub(balances[msg.sender], _burnCount);
244       msg.sender.transfer(_value);
245       BurnEvent(msg.sender, _burnCount, _value);
246     }
247   }
248 
249   function unPaidBurnTokens(uint _burnCount) public preventRestricted {
250     if (balances[msg.sender] >= _burnCount && _burnCount > 0) {
251       tokenSupply = safeSub(tokenSupply, _burnCount);
252       balances[msg.sender] = safeSub(balances[msg.sender], _burnCount);
253       BurnEvent(msg.sender, _burnCount, 0);
254     }
255   }
256 
257   //for debug
258   //only available before the contract is locked
259   function haraKiri() public ownerOnly unlockedOnly {
260     selfdestruct(owner);
261   }
262 
263 }