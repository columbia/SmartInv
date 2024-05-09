1 pragma solidity ^0.5.7;
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
84     function balanceOf(address who) public view returns (uint256);
85     function transfer(address to, uint256 value) public returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public view returns (uint256);
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
116     function balanceOf(address _owner) public view returns (uint256 balance) {
117         return balances[_owner];
118     }
119 }
120 
121 contract ERC223TokenCompatible is BasicToken {
122   using SafeMath for uint256;
123   
124   event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
125 
126 	function transfer(address _to, uint256 _value, bytes memory _data, string memory _custom_fallback) public returns (bool success) {
127 		require(_to != address(0), "_to != address(0)");
128         require(_to != address(this), "_to != address(this)");
129 		require(_value <= balances[msg.sender], "_value <= balances[msg.sender]");
130 		
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133 		if( isContract(_to) ) {
134 		    (bool txOk, ) = _to.call.value(0)( abi.encodePacked(bytes4( keccak256( abi.encodePacked( _custom_fallback ) ) ), msg.sender, _value, _data) );
135 			require( txOk, "_to.call.value(0)( abi.encodePacked(bytes4( keccak256( abi.encodePacked( _custom_fallback ) ) ), msg.sender, _value, _data) )" );
136 
137 		} 
138 		emit Transfer(msg.sender, _to, _value, _data);
139 		return true;
140 	}
141 
142 	function transfer(address _to, uint256 _value, bytes memory _data) public returns (bool success) {
143 		return transfer( _to, _value, _data, "tokenFallback(address,uint256,bytes)");
144 	}
145 
146 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
147 	function isContract(address _addr) private view returns (bool is_contract) {
148 		uint256 length;
149 		assembly {
150             //retrieve the size of the code on target address, this needs assembly
151             length := extcodesize(_addr)
152 		}
153 		return (length>0);
154     }
155 }
156 
157 contract StandardToken is ERC20, BasicToken {
158 
159     mapping (address => mapping (address => uint256)) internal allowed;
160 
161     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162         require(_to != address(0), "_to != address(0)");
163         require(_to != address(this), "_to != address(this)");
164         require(_value <= balances[_from], "_value <= balances[_from]");
165         require(_value <= allowed[_from][msg.sender], "_value <= allowed[_from][msg.sender]");
166 
167         balances[_from] = balances[_from].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173 
174     function approve(address _spender, uint256 _value) public returns (bool) {
175         allowed[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
181         return allowed[_owner][_spender];
182     }
183 
184     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
185         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187         return true;
188     }
189 
190     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
191         uint oldValue = allowed[msg.sender][_spender];
192         if (_subtractedValue > oldValue) {
193             allowed[msg.sender][_spender] = 0;
194         } else {
195         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196         }
197     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199     }
200 
201 }
202 
203 contract HumanStandardToken is StandardToken {
204     /* Approves and then calls the receiving contract */
205     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
206         approve(_spender, _value);
207         (bool txOk, ) = _spender.call(abi.encodePacked(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData));
208         require(txOk, '_spender.call(abi.encodePacked(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData))');
209         return true;
210     }
211     function approveAndCustomCall(address _spender, uint256 _value, bytes memory _extraData, bytes4 _customFunction) public returns (bool success) {
212         approve(_spender, _value);
213         (bool txOk, ) = _spender.call(abi.encodePacked(_customFunction, msg.sender, _value, _extraData));
214         require(txOk, "_spender.call(abi.encodePacked(_customFunction, msg.sender, _value, _extraData))");
215         return true;
216     }
217 }
218 
219 contract Startable is Ownable, Authorizable {
220     event Start();
221 
222     bool public started = false;
223 
224     modifier whenStarted() {
225 	    require( started || authorized[msg.sender], "started || authorized[msg.sender]" );
226         _;
227     }
228 
229     function start() onlyOwner public {
230         started = true;
231         emit Start();
232     }
233 }
234 
235 contract StartToken is Startable, ERC223TokenCompatible, StandardToken {
236 
237     function transfer(address _to, uint256 _value) public whenStarted returns (bool) {
238         return super.transfer(_to, _value);
239     }
240     function transfer(address _to, uint256 _value, bytes memory _data) public whenStarted returns (bool) {
241         return super.transfer(_to, _value, _data);
242     }
243     function transfer(address _to, uint256 _value, bytes memory _data, string memory _custom_fallback) public whenStarted returns (bool) {
244         return super.transfer(_to, _value, _data, _custom_fallback);
245     }
246 
247     function transferFrom(address _from, address _to, uint256 _value) public whenStarted returns (bool) {
248         return super.transferFrom(_from, _to, _value);
249     }
250 
251     function approve(address _spender, uint256 _value) public whenStarted returns (bool) {
252         return super.approve(_spender, _value);
253     }
254 
255     function increaseApproval(address _spender, uint _addedValue) public whenStarted returns (bool success) {
256         return super.increaseApproval(_spender, _addedValue);
257     }
258 
259     function decreaseApproval(address _spender, uint _subtractedValue) public whenStarted returns (bool success) {
260         return super.decreaseApproval(_spender, _subtractedValue);
261     }
262 }
263 
264 
265 contract BurnToken is StandardToken {
266     uint256 public initialSupply;
267 
268     event Burn(address indexed burner, uint256 value);
269     
270     constructor(uint256 _totalSupply) internal {
271         initialSupply = _totalSupply;
272     }
273     
274     function burnFunction(address _burner, uint256 _value) internal returns (bool) {
275         require(_value > 0, "_value > 0");
276 		require(_value <= balances[_burner], "_value <= balances[_burner]");
277 
278         balances[_burner] = balances[_burner].sub(_value);
279         totalSupply = totalSupply.sub(_value);
280         emit Burn(_burner, _value);
281 		emit Transfer(_burner, address(0), _value);
282 		return true;
283     }
284     
285 	function burn(uint256 _value) public returns(bool) {
286         return burnFunction(msg.sender, _value);
287     }
288 	
289 	function burnFrom(address _from, uint256 _value) public returns (bool) {
290 		require(_value <= allowed[_from][msg.sender], "_value <= allowed[_from][msg.sender]"); // check if it has the budget allowed
291 		burnFunction(_from, _value);
292 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
293 		return true;
294 	}
295 }
296 
297 contract Changable is Ownable, ERC20Basic {
298     function changeName(string memory _newName) public onlyOwner {
299         name = _newName;
300     }
301     function changeSymbol(string memory _newSymbol) public onlyOwner {
302         symbol = _newSymbol;
303     }
304 }
305 
306 contract Token is ERC20Basic, ERC223TokenCompatible, StandardToken, HumanStandardToken, StartToken, BurnToken, Changable {
307     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public BurnToken(_totalSupply) {
308         name = _name;
309         symbol = _symbol;
310         decimals = _decimals;
311         totalSupply = _totalSupply;
312         
313         balances[msg.sender] = totalSupply;
314 		emit Transfer(address(0), msg.sender, totalSupply);
315     }
316 }