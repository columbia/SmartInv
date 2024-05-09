1 pragma solidity ^0.4.18;
2 
3 /**
4  *
5  * Version D
6  * @author  Pratyush Bhatt <MysticMonsoon@protonmail.com>
7  *
8  * Overview:
9  * This is an implimentation of a simple sale token. The tokens do not pay any dividends -- they only exist
10  * as a database of purchasers. A limited number of tokens are created on-the-fly as funds are deposited into the
11  * contract. All of the funds are tranferred to the beneficiary at the end of the token-sale.
12  */
13 
14 pragma solidity ^0.4.18;
15 
16 /*
17     Overflow protected math functions
18 */
19 contract SafeMath {
20     /**
21         constructor
22     */
23     function SafeMath() public {
24     }
25 
26     /**
27         @dev returns the sum of _x and _y, asserts if the calculation overflows
28 
29         @param _x   value 1
30         @param _y   value 2
31 
32         @return sum
33     */
34     function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {
35         uint256 z = _x + _y;
36         assert(z >= _x);
37         return z;
38     }
39 
40     /**
41         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
42 
43         @param _x   minuend
44         @param _y   subtrahend
45 
46         @return difference
47     */
48     function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {
49         assert(_x >= _y);
50         return _x - _y;
51     }
52 
53     /**
54         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
55 
56         @param _x   factor 1
57         @param _y   factor 2
58 
59         @return product
60     */
61     function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {
62         uint256 z = _x * _y;
63         assert(_x == 0 || z / _x == _y);
64         return z;
65     }
66 }
67 
68 pragma solidity ^0.4.18;
69 
70 // Token standard API
71 // https://github.com/ethereum/EIPs/issues/20
72 
73 contract iERC20Token {
74   function totalSupply() public constant returns (uint supply);
75   function balanceOf( address who ) public constant returns (uint value);
76   function allowance( address owner, address spender ) public constant returns (uint remaining);
77 
78   function transfer( address to, uint value) public returns (bool ok);
79   function transferFrom( address from, address to, uint value) public returns (bool ok);
80   function approve( address spender, uint value ) public returns (bool ok);
81 
82   event Transfer( address indexed from, address indexed to, uint value);
83   event Approval( address indexed owner, address indexed spender, uint value);
84 }
85 
86 contract SimpleSaleToken is iERC20Token, SafeMath {
87 
88   event PaymentEvent(address indexed from, uint amount);
89   event TransferEvent(address indexed from, address indexed to, uint amount);
90   event ApprovalEvent(address indexed from, address indexed to, uint amount);
91 
92   string  public symbol;
93   string  public name;
94   bool    public isLocked;
95   uint    public decimals;
96   uint    public tokenPrice;
97   uint           tokenSupply;
98   uint           tokensRemaining;
99   uint    public contractSendGas = 100000;
100   address public owner;
101   address public beneficiary;
102   mapping (address => uint) balances;
103   mapping (address => mapping (address => uint)) approvals;  //transfer approvals, from -> to
104 
105 
106   modifier ownerOnly {
107     require(msg.sender == owner);
108     _;
109   }
110 
111   modifier unlockedOnly {
112     require(!isLocked);
113     _;
114   }
115 
116   modifier duringSale {
117     require(tokenPrice != 0 && tokensRemaining > 0);
118     _;
119   }
120 
121   //this is to protect from short-address attack. use this to verify size of args, especially when an address arg preceeds
122   //a value arg. see: https://www.reddit.com/r/ethereum/comments/63s917/worrysome_bug_exploit_with_erc20_token/dfwmhc3/
123   modifier onlyPayloadSize(uint size) {
124     assert(msg.data.length >= size + 4);
125     _;
126   }
127 
128   //
129   //constructor
130   //
131   function SimpleSaleToken() public {
132     owner = msg.sender;
133     beneficiary = msg.sender;
134   }
135 
136 
137   //
138   // ERC-20
139   //
140 
141   function totalSupply() public constant returns (uint supply) {
142     //if tokenSupply was not limited then we would use safeAdd...
143     supply = tokenSupply + tokensRemaining;
144   }
145 
146   function transfer(address _to, uint _value) public onlyPayloadSize(2*32) returns (bool success) {
147     //prevent wrap
148     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
149       balances[msg.sender] -= _value;
150       balances[_to] += _value;
151       TransferEvent(msg.sender, _to, _value);
152       return true;
153     } else {
154       return false;
155     }
156   }
157 
158 
159   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3*32) public returns (bool success) {
160     //prevent wrap:
161     if (balances[_from] >= _value && approvals[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
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
178   function approve(address _spender, uint _value) public onlyPayloadSize(2*32) returns (bool success) {
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
189   //
190   // END ERC20
191   //
192 
193 
194   //
195   // default payable function.
196   //
197   function () public payable duringSale {
198     uint _quantity = msg.value / tokenPrice;
199     if (_quantity > tokensRemaining)
200        _quantity = tokensRemaining;
201     require(_quantity >= 1);
202     uint _cost = safeMul(_quantity, tokenPrice);
203     uint _refund = safeSub(msg.value, _cost);
204     balances[msg.sender] = safeAdd(balances[msg.sender], _quantity);
205     tokenSupply = safeAdd(tokenSupply, _quantity);
206     tokensRemaining = safeSub(tokensRemaining, _quantity);
207     if (_refund > 0)
208         msg.sender.transfer(_refund);
209     PaymentEvent(msg.sender, msg.value);
210   }
211 
212   function setName(string _name, string _symbol) public ownerOnly {
213     name = _name;
214     symbol = _symbol;
215   }
216 
217 
218   //if decimals = 3, and you want 1 ETH/token, then pass in _tokenPrice = 0.001 * (wei / ether)
219   function setBeneficiary(address _beneficiary, uint _decimals, uint _tokenPrice, uint _tokensRemaining) public ownerOnly unlockedOnly {
220     beneficiary = _beneficiary;
221     decimals = _decimals;
222     tokenPrice = _tokenPrice;
223     tokensRemaining = _tokensRemaining;
224   }
225 
226   function lock() public ownerOnly {
227     require(beneficiary != 0 && tokenPrice != 0);
228     isLocked = true;
229   }
230 
231   function endSale() public ownerOnly {
232     require(beneficiary != 0);
233     //beneficiary is most likely a contract...
234     if (!beneficiary.call.gas(contractSendGas).value(this.balance)())
235       revert();
236     tokensRemaining = 0;
237   }
238 
239   function tune(uint _contractSendGas) public ownerOnly {
240     contractSendGas = _contractSendGas;
241   }
242 
243   //for debug
244   //only available before the contract is locked
245   function haraKiri() public ownerOnly unlockedOnly {
246     selfdestruct(owner);
247   }
248 
249 }