1 pragma solidity ^0.4.17;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     
8     constructor() public {
9     }
10 
11     // verifies that an amount is greater than zero
12     modifier greaterThanZero(uint256 _amount) {
13         require(_amount > 0);
14         _;
15     }
16 
17     // validates an address - currently only checks that it isn't null
18     modifier validAddress(address _address) {
19         require(_address != 0x0);
20         _;
21     }
22 
23     // verifies that the address is different than this contract address
24     modifier notThis(address _address) {
25         require(_address != address(this));
26         _;
27     }
28 
29     // Overflow protected math functions
30 
31     /**
32         @dev returns the sum of _x and _y, asserts if the calculation overflows
33 
34         @param _x   value 1
35         @param _y   value 2
36 
37         @return sum
38     */
39     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
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
53     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
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
66     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
67         uint256 z = _x * _y;
68         assert(_x == 0 || z / _x == _y);
69         return z;
70     }
71 }
72 
73 contract IOwned {
74     // this function isn't abstract since the compiler emits automatically generated getter functions as external
75     function owner() public pure returns (address) {}
76 
77     function transferOwnership(address _newOwner) public;
78     function acceptOwnership() public;
79 }
80 
81 
82 contract Owned is IOwned {
83     address public owner;
84     address public newOwner;
85 
86     event OwnershipTransferred(address _prevOwner, address _newOwner);
87 
88     constructor() public {
89         owner = msg.sender;
90     }
91 
92     modifier onlyOwner {
93         assert(msg.sender == owner);
94         _;
95     }
96 
97     function transferOwnership(address _newOwner) public onlyOwner {
98         require(_newOwner != owner);
99         newOwner = _newOwner;
100     }
101 
102     function acceptOwnership() public {
103         require(msg.sender == newOwner);
104         emit OwnershipTransferred(owner, newOwner);
105         owner = newOwner;
106         newOwner = address(0);
107     }
108 }
109 
110 
111 contract IToken {
112     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
113     function name() public pure returns (string) {}
114     function symbol() public pure returns (string) {}
115     function decimals() public pure returns (uint8) {}
116     function totalSupply() public pure returns (uint256) {}
117     function balanceOf(address _owner) public pure returns (uint256) { _owner; }
118     function allowance(address _owner, address _spender) public pure returns (uint256) { _owner; _spender; }
119 
120     function _transfer(address _from, address _to, uint256 _value) internal;
121     function transfer(address _to, uint256 _value) public returns (bool success);
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
123     function approve(address _spender, uint256 _value) public returns (bool success);
124 
125 }
126 
127 
128 contract Token is IToken, Owned, Utils {
129     
130     string public standard = '';
131     string public name = '';
132     string public symbol = '';
133     uint8 public decimals = 0;
134     uint256 public totalSupply = 0;
135 
136     mapping (address => uint256) public balanceOf;
137     mapping (address => mapping (address => uint256)) public allowance;
138 
139     event Transfer(address indexed from, address indexed to, uint256 value);
140     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
141 
142     constructor() public 
143     {
144         name = 'MKC';
145         symbol = 'MKC';
146         decimals = 8;
147         totalSupply = 1000000000 * 10 ** uint256(decimals);
148 
149         balanceOf[owner] = totalSupply;
150     }
151 
152     function _transfer(address _from, address _to, uint256 _value)
153       internal
154       validAddress(_from)
155       validAddress(_to)
156     {
157 
158       require(balanceOf[_from] >= _value);
159       require(balanceOf[_to] + _value > balanceOf[_to]);
160       uint previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]);
161       balanceOf[_from] = safeSub(balanceOf[_from], _value);
162       balanceOf[_to] += safeAdd(balanceOf[_to], _value);
163 
164       emit Transfer(_from, _to, _value);
165 
166       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
167 
168     }
169 
170     function transfer(address _to, uint256 _value)
171       public
172       validAddress(_to)
173       returns (bool)
174     {
175         _transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     function transferFrom(address _from, address _to, uint256 _value)
180         public
181         validAddress(_from)
182         validAddress(_to)
183         returns (bool)
184     {
185         require(_value <= allowance[_from][msg.sender]);   // Check allowance
186 
187         allowance[_from][msg.sender] -= safeSub(allowance[_from][msg.sender], _value);
188 
189         _transfer(_from, _to, _value);
190 
191         return true;
192     }
193 
194     function approve(address _spender, uint256 _value)
195         public
196         validAddress(_spender)
197         returns (bool success)
198     {
199 
200         require(_value == 0 || allowance[msg.sender][_spender] == 0);
201 
202         allowance[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 }
207 
208 contract IMKC {
209 
210     function _transfer(address _from, address _to, uint256 _value) internal;
211     function freezeAccount(address target, bool freeze) public;
212 }
213 
214 
215 contract SmartToken is Owned, Token {
216 
217     string public version = '1.0';
218 
219     event NewSmartToken(address _token);
220 
221     constructor()
222         public
223         Token ()
224     {
225         emit NewSmartToken(address(this));
226     }
227 
228 }
229 
230 
231 contract MKC is IMKC, Token {
232 
233     mapping (address => bool) public frozenAccount;
234 
235     event FrozenFunds(address target, bool frozen);
236 
237     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
238     event NewSmartToken(address _token);
239 
240 
241     constructor()
242       public
243       Token ()
244     {
245         emit NewSmartToken(address(this));
246     }
247 
248 
249     function _transfer(address _from, address _to, uint _value)
250         validAddress(_from)
251         validAddress(_to)
252         internal
253     {
254         require (balanceOf[_from] > _value);
255         require (balanceOf[_to] + _value > balanceOf[_to]);
256         require(!frozenAccount[_from]);
257         require(!frozenAccount[_to]);
258 
259         balanceOf[_from] = safeSub(balanceOf[_from], _value);
260         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
261 
262         emit Transfer(_from, _to, _value);
263 
264     }
265 
266     function freezeAccount(address target, bool freeze)
267         validAddress(target)
268         public
269         onlyOwner
270     {
271         frozenAccount[target] = freeze;
272         emit FrozenFunds(target, freeze);
273     }
274 }