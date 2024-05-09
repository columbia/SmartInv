1 pragma solidity ^0.4.15;
2 
3 /**
4  *
5  * @author  <newtwist@protonmail.com>
6  *
7  * Version B
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
18 
19 /*
20     Overflow protected math functions
21 */
22 contract SafeMath {
23     /**
24         constructor
25     */
26     function SafeMath() {
27     }
28 
29     /**
30         @dev returns the sum of _x and _y, asserts if the calculation overflows
31 
32         @param _x   value 1
33         @param _y   value 2
34 
35         @return sum
36     */
37     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
38         uint256 z = _x + _y;
39         assert(z >= _x);
40         return z;
41     }
42 
43     /**
44         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
45 
46         @param _x   minuend
47         @param _y   subtrahend
48 
49         @return difference
50     */
51     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
52         assert(_x >= _y);
53         return _x - _y;
54     }
55 
56     /**
57         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
58 
59         @param _x   factor 1
60         @param _y   factor 2
61 
62         @return product
63     */
64     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
65         uint256 z = _x * _y;
66         assert(_x == 0 || z / _x == _y);
67         return z;
68     }
69 }
70 
71 
72 //Burnable Token interface
73 
74 // Token standard API
75 // https://github.com/ethereum/EIPs/issues/20
76 
77 contract iERC20Token {
78   function totalSupply() constant returns (uint supply);
79   function balanceOf( address who ) constant returns (uint value);
80   function allowance( address owner, address spender ) constant returns (uint remaining);
81 
82   function transfer( address to, uint value) returns (bool ok);
83   function transferFrom( address from, address to, uint value) returns (bool ok);
84   function approve( address spender, uint value ) returns (bool ok);
85 
86   event Transfer( address indexed from, address indexed to, uint value);
87   event Approval( address indexed owner, address indexed spender, uint value);
88 }
89 
90 contract iBurnableToken is iERC20Token {
91   function burnTokens(uint _burnCount) public;
92   function unPaidBurnTokens(uint _burnCount) public;
93 }
94 
95 contract BurnableToken is iBurnableToken, SafeMath {
96 
97   event PaymentEvent(address indexed from, uint amount);
98   event TransferEvent(address indexed from, address indexed to, uint amount);
99   event ApprovalEvent(address indexed from, address indexed to, uint amount);
100   event BurnEvent(address indexed from, uint count, uint value);
101 
102   string  public symbol;
103   string  public name;
104   bool    public isLocked;
105   uint    public decimals;
106   uint    public restrictUntil;                              //vesting for developer tokens
107   uint           tokenSupply;                                //can never be increased; but tokens can be burned
108   address public owner;
109   address public restrictedAcct;                             //no transfers from this addr during vest time
110   mapping (address => uint) balances;
111   mapping (address => mapping (address => uint)) approvals;  //transfer approvals, from -> to
112 
113 
114   modifier ownerOnly {
115     require(msg.sender == owner);
116     _;
117   }
118 
119   modifier unlockedOnly {
120     require(!isLocked);
121     _;
122   }
123 
124   modifier preventRestricted {
125     require((msg.sender != restrictedAcct) || (now >= restrictUntil));
126     _;
127   }
128 
129 
130   //
131   //constructor
132   //
133   function BurnableToken() {
134     owner = msg.sender;
135   }
136 
137 
138   //
139   // ERC-20
140   //
141 
142   function totalSupply() public constant returns (uint supply) { supply = tokenSupply; }
143 
144   function transfer(address _to, uint _value) public preventRestricted returns (bool success) {
145     //if token supply was not limited then we would prevent wrap:
146     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to])
147     if (balances[msg.sender] >= _value && _value > 0) {
148       balances[msg.sender] -= _value;
149       balances[_to] += _value;
150       TransferEvent(msg.sender, _to, _value);
151       return true;
152     } else {
153       return false;
154     }
155   }
156 
157 
158   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
159     //if token supply was not limited then we would prevent wrap:
160     //if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to])
161     if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && _value > 0) {
162       balances[_from] -= _value;
163       balances[_to] += _value;
164       approvals[_from][msg.sender] -= _value;
165       TransferEvent(_from, _to, _value);
166       return true;
167     } else {
168       return false;
169     }
170   }
171 
172 
173   function balanceOf(address _owner) public constant returns (uint balance) {
174     balance = balances[_owner];
175   }
176 
177 
178   function approve(address _spender, uint _value) public preventRestricted returns (bool success) {
179     approvals[msg.sender][_spender] = _value;
180     ApprovalEvent(msg.sender, _spender, _value);
181     return true;
182   }
183 
184 
185   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
186     return approvals[_owner][_spender];
187   }
188 
189 
190   //
191   // END ERC20
192   //
193 
194 
195   //
196   // default payable function.
197   //
198   function () payable {
199     PaymentEvent(msg.sender, msg.value);
200   }
201 
202   function initTokenSupply(uint _tokenSupply) public ownerOnly {
203     require(tokenSupply == 0);
204     tokenSupply = _tokenSupply;
205     balances[owner] = tokenSupply;
206   }
207 
208   function setName(string _name, string _symbol, uint _decimals) public ownerOnly {
209     name = _name;
210     symbol = _symbol;
211     decimals = _decimals;
212   }
213 
214   function lock() public ownerOnly {
215     isLocked = true;
216   }
217 
218   function setRestrictedAcct(address _restrictedAcct, uint _restrictUntil) public ownerOnly unlockedOnly {
219     restrictedAcct = _restrictedAcct;
220     restrictUntil = _restrictUntil;
221   }
222 
223   function tokenValue() constant public returns (uint value) {
224     value = this.balance / tokenSupply;
225   }
226 
227   function valueOf(address _owner) constant public returns (uint value) {
228     value = this.balance * balances[_owner] / tokenSupply;
229   }
230 
231   function burnTokens(uint _burnCount) public preventRestricted {
232     if (balances[msg.sender] >= _burnCount && _burnCount > 0) {
233       uint _value = this.balance * _burnCount / tokenSupply;
234       tokenSupply -= _burnCount;
235       balances[msg.sender] -= _burnCount;
236       msg.sender.transfer(_value);
237       BurnEvent(msg.sender, _burnCount, _value);
238     }
239   }
240 
241   function unPaidBurnTokens(uint _burnCount) public preventRestricted {
242     if (balances[msg.sender] >= _burnCount && _burnCount > 0) {
243       tokenSupply -= _burnCount;
244       balances[msg.sender] -= _burnCount;
245       BurnEvent(msg.sender, _burnCount, 0);
246     }
247   }
248 
249   //for debug
250   //only available before the contract is locked
251   function haraKiri() ownerOnly unlockedOnly {
252     selfdestruct(owner);
253   }
254 
255 }