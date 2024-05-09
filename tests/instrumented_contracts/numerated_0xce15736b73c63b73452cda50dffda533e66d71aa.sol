1 pragma solidity ^0.4.25;
2 
3 // File: SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {    
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15    
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51  
52 }
53 
54 // File: BACCToken.sol
55 
56 contract BACCToken {
57 
58     using SafeMath for uint256;   
59 
60     mapping (address => uint256) internal balances;
61     mapping (address => mapping (address => uint256)) internal allowed;
62 
63     //--------------------------------  Basic Info  -------------------------------------//
64 
65     string public name;
66     string public symbol;
67     uint8 public decimals;
68     uint256 public totalSupply;
69 
70     //--------------------------------  Basic Info  -------------------------------------//
71 
72 
73   
74     
75     //--------------------------------  Admin Info  -------------------------------------//
76 
77     address internal admin;  //Admin address
78      
79     event ChangeAdmin(address indexed admin, address indexed newAdmin);
80   
81     modifier onlyAdmin() {
82         require(msg.sender == admin); 
83         _;
84     }
85   
86   
87     /**
88      * @dev Change admin address
89      * @param newAdmin New admin address
90      */
91     function changeAdmin(address newAdmin) public onlyAdmin returns (bool)  {
92         require(newAdmin != address(0));
93         uint256 balAdmin = balances[admin];
94         balances[newAdmin] = balances[newAdmin].add(balAdmin);
95         balances[admin] = 0;
96         emit Transfer(admin, newAdmin, balAdmin);
97         emit ChangeAdmin(admin, newAdmin);
98         admin = newAdmin;          
99         return true;
100     }
101 
102     //--------------------------------  Admin Info  -------------------------------------//
103     
104     //-----------------------------  Transfer switch  ----------------------------------//
105 
106     bool public allowedTransfer;     //Whether transfering token is allowed
107     bool public allowedMultiTransfer;     //Whether multi transfering token is allowed
108     
109     /**
110      * @dev Change allowedTransfer flag
111      * @param newAllowedTransfer whether transfering token is allowed
112      */
113     function changeAllowedTransfer(bool newAllowedTransfer) public onlyAdmin returns (bool)  {
114        // require(msg.sender == admin);        
115         allowedTransfer = newAllowedTransfer;
116         return true;
117     }
118     
119     /**
120      * @dev Change allowedMultiTransfer flag
121      * @param newAllowedMultiTransfer whether multi transfering token is allowed
122      */
123     function changeAllowedMultiTransfer(bool newAllowedMultiTransfer) public onlyAdmin returns (bool)  {
124       //  require(msg.sender == admin);        
125         allowedMultiTransfer = newAllowedMultiTransfer;
126         return true;
127     }
128     
129     //-----------------------------  Transfer switch  ----------------------------------//
130 
131     //--------------------------  Events & Constructor  ------------------------------//
132     
133     event Approval(address indexed owner, address indexed spender, uint256 value);
134     event Transfer(address indexed from, address indexed to, uint256 value);
135 
136     // constructor
137     constructor(string tokenName, string tokenSymbol, uint8 tokenDecimals, uint256 totalTokenSupply) public {
138         name = tokenName;
139         symbol = tokenSymbol;
140         decimals = tokenDecimals;
141         totalSupply = totalTokenSupply;
142         admin = msg.sender;
143         balances[msg.sender] = totalTokenSupply;
144         allowedTransfer = true;
145         allowedMultiTransfer = true;
146         emit Transfer(address(0x0), msg.sender, totalTokenSupply); 
147 
148     }
149 
150     //--------------------------  Events & Constructor  ------------------------------//
151     
152     //------------------------------ Account lock  -----------------------------------//
153 
154     // The same account is frozen if it satisfies any freezing conditions
155     mapping (address => bool)  public frozenAccount; //Accounts frozen indefinitely
156     mapping (address => uint256) public frozenTimestamp; // Accounts frozen for a limited period
157 
158    
159 
160     /**
161      * Lock accounts
162      */
163     function freeze(address _target, bool _freeze) public onlyAdmin returns (bool) {
164       //  require(msg.sender == admin);          
165         require(_target != admin);
166         frozenAccount[_target] = _freeze;
167         return true;
168     }
169 
170     /**
171      * Locking accounts through timestamps
172      */
173     function freezeWithTimestamp(address _target, uint256 _timestamp) public onlyAdmin returns (bool) {
174      //   require(msg.sender == admin);          
175         require(_target != admin); 
176         frozenTimestamp[_target] = _timestamp;
177         return true;
178     }
179 
180     /**
181      * Batch Lock-in Account
182      */
183     function multiFreeze(address[] _targets, bool[] _freezes) public onlyAdmin returns (bool) {
184       //  require(msg.sender == admin);         
185         require(_targets.length == _freezes.length);
186         uint256 len = _targets.length;
187         require(len > 0);
188         for (uint256 i = 0; i < len; i = i.add(1)) {
189             address _target = _targets[i];
190             require(_target != admin);
191             bool _freeze = _freezes[i];
192             frozenAccount[_target] = _freeze;
193         }
194         return true;
195     }
196 
197     /**
198      * Lock accounts in batches through timestamps
199      */
200     function multiFreezeWithTimestamp(address[] _targets, uint256[] _timestamps) public onlyAdmin returns (bool) {
201        // require(msg.sender == admin);        
202        // require(_targets.length == _timestamps.length);    
203         require(_targets.length > 0 && _targets.length == _timestamps.length);
204         uint256 len = _targets.length;           
205         for (uint256 i = 0; i < len; i = i.add(1)) {
206             address _target = _targets[i];
207             require(_target != admin);
208             uint256 _timestamp = _timestamps[i];
209             frozenTimestamp[_target] = _timestamp;
210         }
211         return true;
212     }
213 
214     //------------------------------  Account lock  -----------------------------------//
215 
216 
217     //-------------------------  Standard ERC20 Interfaces  --------------------------//
218 
219     function multiTransfer(address[] _tos, uint256[] _values) public returns (bool) {
220         require(allowedMultiTransfer);
221         require(!frozenAccount[msg.sender]);
222         require(now > frozenTimestamp[msg.sender]);
223        // require(_tos.length == _values.length);     
224         require(_tos.length > 0 && _tos.length == _values.length);
225         uint256 len = _tos.length;
226         uint256 amount = 0;
227         for (uint256 i = 0; i < len; i = i.add(1)) {
228             amount = amount.add(_values[i]);
229         }
230         require(balances[msg.sender] >= amount);
231         for (uint256 j = 0; j < len; j = j.add(1)) {
232             address _to = _tos[j];        
233             require(_to != address(0));
234             balances[_to] = balances[_to].add(_values[j]);
235             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
236             emit Transfer(msg.sender, _to, _values[j]);
237         }
238         return true;
239     }
240 
241     function transfer(address _to, uint256 _value) public returns (bool) {
242         require(_to != address(0));
243         require(allowedTransfer);
244         require(!frozenAccount[msg.sender]);
245         require(now > frozenTimestamp[msg.sender]);
246         require(balances[msg.sender].sub(_value) >= 0);    
247         balances[msg.sender] = balances[msg.sender].sub(_value);
248         balances[_to] = balances[_to].add(_value);
249         emit Transfer(msg.sender, _to, _value);
250         return true;
251     }
252 
253     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) { 
254         require(_to != address(0));
255         require(allowedTransfer);
256         require(!frozenAccount[_from]);
257         require(now > frozenTimestamp[_from]);
258         require(balances[_from].sub(_value) >= 0);    
259         require(allowed[_from][msg.sender] >= _value);   
260 
261         balances[_from] = balances[_from].sub(_value);
262         balances[_to] = balances[_to].add(_value);
263         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
264 
265         emit Transfer(_from, _to, _value);
266         return true;
267     }
268 
269     function approve(address _spender, uint256 _value) public returns (bool) { 
270         require(_value == 0 || allowed[msg.sender][_spender] == 0);
271         allowed[msg.sender][_spender] = _value;
272         emit Approval(msg.sender, _spender, _value);
273         return true;
274     }
275 
276     function allowance(address _owner, address _spender) public view returns (uint256) {
277         return allowed[_owner][_spender];
278     }
279 
280     /**
281      * @dev Gets the balance of the specified address.
282      * @param _owner The address to query the the balance of.
283      * @return An uint256 representing the amount owned by the passed address.
284      */
285     function balanceOf(address _owner) public view returns (uint256) {
286         return balances[_owner];
287     }
288 
289     //-------------------------  Standard ERC20 Interfaces  --------------------------//
290 }