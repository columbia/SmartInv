1 /**
2  *
3  * @author  David Rosen <kaandoit@mcon.org>
4  *
5  * Version A
6  *
7  * Overview:
8  * This is an implimentation of a `burnable` token. The tokens do not pay any dividends; however if/when tokens
9  * are `burned`, the burner gets a share of whatever funds the contract owns at that time. No provision is made
10  * for how tokens are sold; all tokens are initially credited to the contract owner. There is a provision to
11  * establish a single `restricted` account. The restricted account can own tokens, but cannot transfer them or
12  * burn them until after a certain date. . There is also a function to burn tokens without getting paid. This is
13  * useful, for example, if the sale-contract/owner wants to reduce the supply of tokens.
14  *
15  */
16 
17 /*
18     Overflow protected math functions
19 */
20 contract SafeMath {
21     /**
22         constructor
23     */
24     function SafeMath() {
25     }
26 
27     /**
28         @dev returns the sum of _x and _y, asserts if the calculation overflows
29 
30         @param _x   value 1
31         @param _y   value 2
32 
33         @return sum
34     */
35     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
36         uint256 z = _x + _y;
37         assert(z >= _x);
38         return z;
39     }
40 
41     /**
42         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
43 
44         @param _x   minuend
45         @param _y   subtrahend
46 
47         @return difference
48     */
49     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
50         assert(_x >= _y);
51         return _x - _y;
52     }
53 
54     /**
55         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
56 
57         @param _x   factor 1
58         @param _y   factor 2
59 
60         @return product
61     */
62     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
63         uint256 z = _x * _y;
64         assert(_x == 0 || z / _x == _y);
65         return z;
66     }
67 }
68 contract iERC20Token {
69   function totalSupply() constant returns (uint supply);
70   function balanceOf( address who ) constant returns (uint value);
71   function allowance( address owner, address spender ) constant returns (uint remaining);
72 
73   function transfer( address to, uint value) returns (bool ok);
74   function transferFrom( address from, address to, uint value) returns (bool ok);
75   function approve( address spender, uint value ) returns (bool ok);
76 
77   event Transfer( address indexed from, address indexed to, uint value);
78   event Approval( address indexed owner, address indexed spender, uint value);
79 }
80 contract iBurnableToken is iERC20Token {
81   function burnTokens(uint _burnCount) public;
82   function unPaidBurnTokens(uint _burnCount) public;
83 }
84 
85 
86 contract BurnableToken is iBurnableToken, SafeMath {
87 
88   event PaymentEvent(address indexed from, uint amount);
89   event TransferEvent(address indexed from, address indexed to, uint amount);
90   event ApprovalEvent(address indexed from, address indexed to, uint amount);
91   event BurnEvent(address indexed from, uint count, uint value);
92 
93   string  public symbol;
94   string  public name;
95   bool    public isLocked;
96   uint    public decimals;
97   uint    public restrictUntil;                              //vesting for developer tokens
98   uint           tokenSupply;                                //can never be increased; but tokens can be burned
99   address public owner;
100   address public restrictedAcct;                             //no transfers from this addr during vest time
101   mapping (address => uint) balances;
102   mapping (address => mapping (address => uint)) approvals;  //transfer approvals, from -> to
103 
104 
105   modifier ownerOnly {                                                                                                                                                                                             
106     require(msg.sender == owner);                                                                                                                                                                                  
107     _;                                                                                                                                                                                                             
108   }                                                                                                                                                                                                                
109                                                                                                                                                                                                                    
110   modifier unlockedOnly {                                                                                                                                                                                          
111     require(!isLocked);                                                                                                                                                                                            
112     _;                                                                                                                                                                                                             
113   }                                                                                                                                                                                                                
114                                                                                                                                                                                                                    
115   modifier preventRestricted {                                                                                                                                                                                     
116     require((msg.sender != restrictedAcct) || (now >= restrictUntil));                                                                                                                                             
117     _;                                                                                                                                                                                                             
118   }                                                                                                                                                                                                                
119                                                                                                                                                                                                                    
120                                                                                                                                                                                                                    
121   //                                                                                                                                                                                                               
122   //constructor                                                                                                                                                                                                    
123   //                                                                                                                                                                                                               
124   function BurnableToken() {
125     owner = msg.sender;
126   }
127 
128 
129   //
130   // ERC-20
131   //
132 
133   function totalSupply() public constant returns (uint supply) { supply = tokenSupply; }
134 
135   function transfer(address _to, uint _value) public preventRestricted returns (bool success) {
136     //if token supply was not limited then we would prevent wrap:
137     //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to])
138     if (balances[msg.sender] >= _value && _value > 0) {
139       balances[msg.sender] -= _value;
140       balances[_to] += _value;
141       TransferEvent(msg.sender, _to, _value);
142       return true;
143     } else {
144       return false;
145     }
146   }
147 
148 
149   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
150     //if token supply was not limited then we would prevent wrap:
151     //if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to])
152     if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && _value > 0) {
153       balances[_from] -= _value;
154       balances[_to] += _value;
155       approvals[_from][msg.sender] -= _value;
156       TransferEvent(_from, _to, _value);
157       return true;
158     } else {
159       return false;
160     }
161   }
162 
163 
164   function balanceOf(address _owner) public constant returns (uint balance) {
165     balance = balances[_owner];
166   }
167 
168 
169   function approve(address _spender, uint _value) public preventRestricted returns (bool success) {
170     approvals[msg.sender][_spender] = _value;
171     ApprovalEvent(msg.sender, _spender, _value);
172     return true;
173   }
174 
175 
176   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
177     return approvals[_owner][_spender];
178   }
179 
180 
181   //
182   // END ERC20
183   //
184 
185 
186   //
187   // default payable function.
188   //
189   function () payable {
190     PaymentEvent(msg.sender, msg.value);
191   }
192 
193   function initTokenSupply(uint _tokenSupply) public ownerOnly {
194     require(tokenSupply == 0);
195     tokenSupply = _tokenSupply;
196     balances[owner] = tokenSupply;
197   }
198 
199   function lock() public ownerOnly {
200     isLocked = true;
201   }
202 
203   function setRestrictedAcct(address _restrictedAcct, uint _restrictUntil) public ownerOnly unlockedOnly {
204     restrictedAcct = _restrictedAcct;
205     restrictUntil = _restrictUntil;
206   }
207 
208   function tokenValue() constant public returns (uint value) {
209     value = this.balance / tokenSupply;
210   }
211 
212   function valueOf(address _owner) constant public returns (uint value) {
213     value = this.balance * balances[_owner] / tokenSupply;
214   }
215 
216   function burnTokens(uint _burnCount) public preventRestricted {
217     if (balances[msg.sender] >= _burnCount && _burnCount > 0) {
218       uint _value = this.balance * _burnCount / tokenSupply;
219       tokenSupply -= _burnCount;
220       balances[msg.sender] -= _burnCount;
221       msg.sender.transfer(_value);
222       BurnEvent(msg.sender, _burnCount, _value);
223     }
224   }
225 
226   function unPaidBurnTokens(uint _burnCount) public preventRestricted {
227     if (balances[msg.sender] >= _burnCount && _burnCount > 0) {
228       tokenSupply -= _burnCount;
229       balances[msg.sender] -= _burnCount;
230       BurnEvent(msg.sender, _burnCount, 0);
231     }
232   }
233 
234   //for debug
235   //only available before the contract is locked
236   function haraKiri() ownerOnly unlockedOnly {
237     selfdestruct(owner);
238   }
239 
240 }