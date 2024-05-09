1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30 	address public owner;
31 	address public newOwner;
32 
33 	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
34 
35 	constructor() public {
36 		owner = msg.sender;
37 		newOwner = address(0);
38 	}
39 
40 	modifier onlyOwner() {
41 		require(msg.sender == owner, "msg.sender == owner");
42 		_;
43 	}
44 
45 	function transferOwnership(address _newOwner) public onlyOwner {
46 		require(address(0) != _newOwner, "address(0) != _newOwner");
47 		newOwner = _newOwner;
48 	}
49 
50 	function acceptOwnership() public {
51 		require(msg.sender == newOwner, "msg.sender == newOwner");
52 		emit OwnershipTransferred(owner, msg.sender);
53 		owner = msg.sender;
54 		newOwner = address(0);
55 	}
56 }
57 
58 contract Authorizable is Ownable {
59     mapping(address => bool) public authorized;
60   
61     event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
62 
63     constructor() public {
64         authorized[msg.sender] = true;
65     }
66 
67     modifier onlyAuthorized() {
68         require(authorized[msg.sender], "authorized[msg.sender]");
69         _;
70     }
71 
72     function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
73         emit AuthorizationSet(addressAuthorized, authorization);
74         authorized[addressAuthorized] = authorization;
75     }
76   
77 }
78 
79 contract ERC20Basic {
80     string public name;
81     string public symbol;
82     uint8 public decimals;
83     uint256 public totalSupply;
84     function balanceOf(address who) public constant returns (uint256);
85     function transfer(address to, uint256 value) public returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public constant returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 contract BasicToken is ERC20Basic {
97     using SafeMath for uint256;
98 
99     mapping(address => uint256) balances;
100 
101     function transferFunction(address _sender, address _to, uint256 _value) internal returns (bool) {
102         require(_to != address(0), "_to != address(0)");
103         require(_to != address(this), "_to != address(this)");
104         require(_value <= balances[_sender], "_value <= balances[_sender]");
105 
106         balances[_sender] = balances[_sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         emit Transfer(_sender, _to, _value);
109         return true;
110     }
111   
112     function transfer(address _to, uint256 _value) public returns (bool) {
113 	    return transferFunction(msg.sender, _to, _value);
114     }
115 
116     function balanceOf(address _owner) public constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119 }
120 
121 contract ERC223TokenCompatible is BasicToken {
122   using SafeMath for uint256;
123   
124   event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
125 
126 	function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public returns (bool success) {
127 		require(_to != address(0), "_to != address(0)");
128         require(_to != address(this), "_to != address(this)");
129 		require(_value <= balances[msg.sender], "_value <= balances[msg.sender]");
130 		
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133 		if( isContract(_to) ) {
134 			require( _to.call.value(0)( bytes4( keccak256( abi.encodePacked( _custom_fallback ) ) ), msg.sender, _value, _data), "_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data)" );
135 
136 		} 
137 		emit Transfer(msg.sender, _to, _value, _data);
138 		return true;
139 	}
140 
141 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
142 		return transfer( _to, _value, _data, "tokenFallback(address,uint256,bytes)");
143 	}
144 
145 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
146 	function isContract(address _addr) private view returns (bool is_contract) {
147 		uint256 length;
148 		assembly {
149             //retrieve the size of the code on target address, this needs assembly
150             length := extcodesize(_addr)
151 		}
152 		return (length>0);
153     }
154 }
155 
156 contract StandardToken is ERC20, BasicToken {
157 
158     mapping (address => mapping (address => uint256)) internal allowed;
159 
160     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161         require(_to != address(0), "_to != address(0)");
162         require(_to != address(this), "_to != address(this)");
163         require(_value <= balances[_from], "_value <= balances[_from]");
164         require(_value <= allowed[_from][msg.sender], "_value <= allowed[_from][msg.sender]");
165 
166         balances[_from] = balances[_from].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169         emit Transfer(_from, _to, _value);
170         return true;
171     }
172 
173     function approve(address _spender, uint256 _value) public returns (bool) {
174         allowed[msg.sender][_spender] = _value;
175         emit Approval(msg.sender, _spender, _value);
176         return true;
177     }
178 
179     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
180         return allowed[_owner][_spender];
181     }
182 
183     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
184         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186         return true;
187     }
188 
189     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
190         uint oldValue = allowed[msg.sender][_spender];
191         if (_subtractedValue > oldValue) {
192             allowed[msg.sender][_spender] = 0;
193         } else {
194         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195         }
196     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198     }
199 
200 }
201 
202 contract HumanStandardToken is StandardToken {
203     /* Approves and then calls the receiving contract */
204     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
205         approve(_spender, _value);
206         require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData), '_spender.call(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData)');
207         return true;
208     }
209     function approveAndCustomCall(address _spender, uint256 _value, bytes _extraData, bytes4 _customFunction) public returns (bool success) {
210         approve(_spender, _value);
211         require(_spender.call(_customFunction, msg.sender, _value, _extraData), "_spender.call(_customFunction, msg.sender, _value, _extraData)");
212         return true;
213     }
214 }
215 
216 contract Startable is Ownable, Authorizable {
217     event Start();
218 
219     bool public started = false;
220 
221     modifier whenStarted() {
222 	    require( started || authorized[msg.sender], "started || authorized[msg.sender]" );
223         _;
224     }
225 
226     function start() onlyOwner public {
227         started = true;
228         emit Start();
229     }
230 }
231 
232 contract StartToken is Startable, ERC223TokenCompatible, StandardToken {
233 
234     function transfer(address _to, uint256 _value) public whenStarted returns (bool) {
235         return super.transfer(_to, _value);
236     }
237     function transfer(address _to, uint256 _value, bytes _data) public whenStarted returns (bool) {
238         return super.transfer(_to, _value, _data);
239     }
240     function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public whenStarted returns (bool) {
241         return super.transfer(_to, _value, _data, _custom_fallback);
242     }
243 
244     function transferFrom(address _from, address _to, uint256 _value) public whenStarted returns (bool) {
245         return super.transferFrom(_from, _to, _value);
246     }
247 
248     function approve(address _spender, uint256 _value) public whenStarted returns (bool) {
249         return super.approve(_spender, _value);
250     }
251 
252     function increaseApproval(address _spender, uint _addedValue) public whenStarted returns (bool success) {
253         return super.increaseApproval(_spender, _addedValue);
254     }
255 
256     function decreaseApproval(address _spender, uint _subtractedValue) public whenStarted returns (bool success) {
257         return super.decreaseApproval(_spender, _subtractedValue);
258     }
259 }
260 
261 
262 contract BurnToken is StandardToken {
263     uint256 public initialSupply;
264 
265     event Burn(address indexed burner, uint256 value);
266     
267     constructor(uint256 _totalSupply) internal {
268         initialSupply = _totalSupply;
269     }
270 
271     function burnFunction(address _burner, uint256 _value) internal returns (bool) {
272         require(_value > 0, "_value > 0");
273 		require(_value <= balances[_burner], "_value <= balances[_burner]");
274 
275         balances[_burner] = balances[_burner].sub(_value);
276         totalSupply = totalSupply.sub(_value);
277         emit Burn(_burner, _value);
278 		return true;
279     }
280     
281 	function burn(uint256 _value) public returns(bool) {
282         return burnFunction(msg.sender, _value);
283     }
284 	
285 	function burnFrom(address _from, uint256 _value) public returns (bool) {
286 		require(_value <= allowed[_from][msg.sender], "_value <= allowed[_from][msg.sender]"); // check if it has the budget allowed
287 		burnFunction(_from, _value);
288 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
289 		return true;
290 	}
291 }
292 
293 contract Token is ERC20Basic, ERC223TokenCompatible, StandardToken, HumanStandardToken {
294     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply ) public {
295         name = _name;
296         symbol = _symbol;
297         decimals = _decimals;
298         totalSupply = _totalSupply;
299         balances[msg.sender] = totalSupply;
300     }
301 }
302 
303 contract TokenStart is Token, StartToken  {
304     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply ) public 
305     Token(_name, _symbol, _decimals, _totalSupply ) 
306     {
307     }
308 }
309 
310 contract TokenStartBurn is Token, StartToken, BurnToken  {
311     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply ) public 
312     Token(_name, _symbol, _decimals, _totalSupply ) 
313     BurnToken(_totalSupply) 
314     {
315     }
316 }