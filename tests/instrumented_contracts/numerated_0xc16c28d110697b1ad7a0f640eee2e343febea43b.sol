1 pragma solidity ^0.4.15;
2 
3 /**
4  *
5  * @author  <newtwist@protonmail.com>
6  *
7  * Version C
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
18 pragma solidity ^0.4.11;
19 
20 /*
21     Overflow protected math functions
22 */
23 contract SafeMath {
24     /**
25         constructor
26     */
27     function SafeMath() public {
28     }
29 
30     /**
31         @dev returns the sum of _x and _y, asserts if the calculation overflows
32 
33         @param _x   value 1
34         @param _y   value 2
35 
36         @return sum
37     */
38     function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {
39         uint256 z = _x + _y;
40         assert(z >= _x);
41         return z;
42     }
43 
44     /**
45         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
46 
47         @param _x   minuend
48         @param _y   subtrahend
49 
50         @return difference
51     */
52     function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {
53         assert(_x >= _y);
54         return _x - _y;
55     }
56 
57     /**
58         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
59 
60         @param _x   factor 1
61         @param _y   factor 2
62 
63         @return product
64     */
65     function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {
66         uint256 z = _x * _y;
67         assert(_x == 0 || z / _x == _y);
68         return z;
69     }
70 }
71 
72 pragma solidity ^0.4.15;
73 
74 //Burnable Token interface
75 
76 pragma solidity ^0.4.15;
77 
78 // Token standard API
79 // https://github.com/ethereum/EIPs/issues/20
80 
81 contract iERC20Token {
82   function totalSupply() public constant returns (uint supply);
83   function balanceOf( address who ) public constant returns (uint value);
84   function allowance( address owner, address spender ) public constant returns (uint remaining);
85 
86   function transfer( address to, uint value) public returns (bool ok);
87   function transferFrom( address from, address to, uint value) public returns (bool ok);
88   function approve( address spender, uint value ) public returns (bool ok);
89 
90   event Transfer( address indexed from, address indexed to, uint value);
91   event Approval( address indexed owner, address indexed spender, uint value);
92 }
93 
94 
95 contract iBurnableToken is iERC20Token {
96   function burnTokens(uint _burnCount) public;
97   function unPaidBurnTokens(uint _burnCount) public;
98 }
99 
100 contract BurnableToken is iBurnableToken, SafeMath {
101 
102   event PaymentEvent(address indexed from, uint amount);
103   event TransferEvent(address indexed from, address indexed to, uint amount);
104   event ApprovalEvent(address indexed from, address indexed to, uint amount);
105   event BurnEvent(address indexed from, uint count, uint value);
106 
107   string  public symbol;
108   string  public name;
109   bool    public isLocked;
110   uint    public decimals;
111   uint    public restrictUntil;                              //vesting for developer tokens
112   uint           tokenSupply;                                //can never be increased; but tokens can be burned
113   address public owner;
114   address public restrictedAcct;                             //no transfers from this addr during vest time
115   mapping (address => uint) balances;
116   mapping (address => mapping (address => uint)) approvals;  //transfer approvals, from -> to
117 
118 
119   modifier ownerOnly {
120     require(msg.sender == owner);
121     _;
122   }
123 
124   modifier unlockedOnly {
125     require(!isLocked);
126     _;
127   }
128 
129   modifier preventRestricted {
130     require((msg.sender != restrictedAcct) || (now >= restrictUntil));
131     _;
132   }
133 
134 
135   //
136   //constructor
137   //
138   function BurnableToken() public {
139     owner = msg.sender;
140   }
141 
142 
143   //
144   // ERC-20
145   //
146 
147   function totalSupply() public constant returns (uint supply) { supply = tokenSupply; }
148 
149   function transfer(address _to, uint _value) public preventRestricted returns (bool success) {
150     //if token supply was not limited then we would prevent wrap:
151     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to])
152     if (balances[msg.sender] >= _value && _value > 0) {
153       balances[msg.sender] -= _value;
154       balances[_to] += _value;
155       TransferEvent(msg.sender, _to, _value);
156       return true;
157     } else {
158       return false;
159     }
160   }
161 
162 
163   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
164     //if token supply was not limited then we would prevent wrap:
165     //if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to])
166     if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && _value > 0) {
167       balances[_from] -= _value;
168       balances[_to] += _value;
169       approvals[_from][msg.sender] -= _value;
170       TransferEvent(_from, _to, _value);
171       return true;
172     } else {
173       return false;
174     }
175   }
176 
177 
178   function balanceOf(address _owner) public constant returns (uint balance) {
179     balance = balances[_owner];
180   }
181 
182 
183   function approve(address _spender, uint _value) public preventRestricted returns (bool success) {
184     approvals[msg.sender][_spender] = _value;
185     ApprovalEvent(msg.sender, _spender, _value);
186     return true;
187   }
188 
189 
190   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
191     return approvals[_owner][_spender];
192   }
193 
194 
195   //
196   // END ERC20
197   //
198 
199 
200   //
201   // default payable function.
202   //
203   function () public payable {
204     PaymentEvent(msg.sender, msg.value);
205   }
206 
207   function initTokenSupply(uint _tokenSupply, uint _decimals) public ownerOnly {
208     require(tokenSupply == 0);
209     tokenSupply = _tokenSupply;
210     balances[owner] = tokenSupply;
211     decimals = _decimals;
212   }
213 
214   function setName(string _name, string _symbol) public ownerOnly {
215     name = _name;
216     symbol = _symbol;
217   }
218 
219   function lock() public ownerOnly {
220     isLocked = true;
221   }
222 
223   function setRestrictedAcct(address _restrictedAcct, uint _restrictUntil) public ownerOnly unlockedOnly {
224     restrictedAcct = _restrictedAcct;
225     restrictUntil = _restrictUntil;
226   }
227 
228   function tokenValue() constant public returns (uint value) {
229     value = this.balance / tokenSupply;
230   }
231 
232   function valueOf(address _owner) constant public returns (uint value) {
233     value = this.balance * balances[_owner] / tokenSupply;
234   }
235 
236   function burnTokens(uint _burnCount) public preventRestricted {
237     if (balances[msg.sender] >= _burnCount && _burnCount > 0) {
238       uint _value = this.balance * _burnCount / tokenSupply;
239       tokenSupply -= _burnCount;
240       balances[msg.sender] -= _burnCount;
241       msg.sender.transfer(_value);
242       BurnEvent(msg.sender, _burnCount, _value);
243     }
244   }
245 
246   function unPaidBurnTokens(uint _burnCount) public preventRestricted {
247     if (balances[msg.sender] >= _burnCount && _burnCount > 0) {
248       tokenSupply -= _burnCount;
249       balances[msg.sender] -= _burnCount;
250       BurnEvent(msg.sender, _burnCount, 0);
251     }
252   }
253 
254   //for debug
255   //only available before the contract is locked
256   function haraKiri() public ownerOnly unlockedOnly {
257     selfdestruct(owner);
258   }
259 
260 }