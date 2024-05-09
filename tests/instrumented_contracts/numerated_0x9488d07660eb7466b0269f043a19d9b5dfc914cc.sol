1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4 
5     function totalSupply() public constant returns (uint);
6 	function balanceOf(address who) public view returns (uint256);
7 	function transfer(address to, uint256 value) public returns (bool);
8 	function allowance(address owner, address spender) public view returns (uint256);
9 	function transferFrom(address from, address to, uint256 value) public returns (bool);
10 	function approve(address spender, uint256 value) public returns (bool);
11 	event Approval(address indexed owner, address indexed spender, uint256 value);
12 	event Transfer(address indexed from, address indexed to, uint256 value);
13 
14 }
15 
16 contract BasicToken is ERC20 {
17 
18     using SafeMath for uint256;
19 
20     uint256  public totalSupply = 10*10**26;
21     uint8 constant public decimals = 18;
22     string constant public name = "Koala life Coin";
23     string constant public symbol = "KALC";
24 
25 	mapping(address => uint256) balances;
26 	mapping (address => mapping (address => uint256)) internal allowed;
27 
28 	function transfer(address _to, uint256 _value) public returns (bool) {
29 		require(_to != address(0));
30 		require(_value <= balances[msg.sender]);
31 
32 		balances[msg.sender] = balances[msg.sender].sub(_value);
33 		balances[_to] = balances[_to].add(_value);
34 		emit Transfer(msg.sender, _to, _value);
35 		return true;
36 	}
37 
38 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
39 		require(_to != address(0));
40 		require(_value <= balances[_from]);
41 		require(_value <= allowed[_from][msg.sender]);
42 
43 		balances[_from] = balances[_from].sub(_value);
44 		balances[_to] = balances[_to].add(_value);
45 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
46 		emit Transfer(_from, _to, _value);
47 		return true;
48 	}
49 
50 	function balanceOf(address _owner) public view returns (uint256 balance) {
51 		return balances[_owner];
52 	}
53 
54 
55    function totalSupply() public constant returns (uint256){
56         return totalSupply;
57    }
58 
59 	function approve(address _spender, uint256 _value) public returns (bool) {
60 		allowed[msg.sender][_spender] = _value;
61 		emit Approval(msg.sender, _spender, _value);
62 		return true;
63 	}
64 
65 
66 	function allowance(address _owner, address _spender) public view returns (uint256) {
67 		return allowed[_owner][_spender];
68 	}
69 
70 
71 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
72 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
73 		emit  Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
74 		return true;
75 	}
76 
77 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
78 		uint oldValue = allowed[msg.sender][_spender];
79 		if (_subtractedValue > oldValue) {
80 			allowed[msg.sender][_spender] = 0;
81 		} else {
82 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
83 		}
84 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
85 		return true;
86 	}
87 
88 }
89 
90 contract Ownable {
91 
92 	address public owner;
93 	
94 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96 	constructor() public {
97 		owner = msg.sender;
98 	}
99 
100 	modifier onlyOwner() {
101 		require(msg.sender == owner);
102 		_;
103 	}
104 
105 	function transferOwnership(address newOwner) public onlyOwner {
106 		require(newOwner != address(0));
107 		emit OwnershipTransferred(owner, newOwner);
108 		owner = newOwner;
109 	}
110 
111 }
112 
113 contract Controlled is Ownable{
114 
115     constructor() public {
116        setExclude(msg.sender);
117     }
118 
119     bool public transferEnabled = false;
120 
121     bool public lockFlag=true;
122     mapping(address => bool) locked;
123     mapping(address => bool) exclude;
124 
125 	event AddLock(address indexed _addr);
126 	event RemoveLock(address indexed _addr);
127 
128     function enableTransfer(bool _enable) public onlyOwner{
129         transferEnabled=_enable;
130     }
131 
132     function disableLock(bool _enable) public onlyOwner returns (bool success){
133         lockFlag=_enable;
134         return true;
135     }
136 
137 	
138     function addLock(address _addr) public onlyOwner returns (bool success){
139         require(_addr!=msg.sender);
140         locked[_addr]=true;
141 		emit AddLock(_addr);
142         return true;
143     }
144 
145     function setExclude(address _addr) public onlyOwner returns (bool success){
146         exclude[_addr]=true;
147         return true;
148     }
149 
150     function removeLock(address _addr) public onlyOwner returns (bool success){
151         locked[_addr]=false;
152 		emit RemoveLock(_addr);
153         return true;
154     }
155 
156     modifier transferAllowed(address _addr) {
157         if (!exclude[_addr]) {
158             assert(transferEnabled);
159             if(lockFlag){
160                 assert(!locked[_addr]);
161             }
162         }
163         _;
164     }
165 
166 }
167 
168 contract BurnableToken is BasicToken {
169 
170 
171 	event Burn(address indexed burner, uint256 value);
172 
173 	function burn(uint256 _value) public {
174 		require(_value <= balances[msg.sender]);
175 
176 		address burner = msg.sender;
177 		balances[burner] = balances[burner].sub(_value);
178 		totalSupply = totalSupply.sub(_value);
179 		emit Burn(burner, _value);
180 	}
181 }
182 
183 
184 contract ControlledToken is BasicToken, Controlled {
185 
186   function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
187     return super.transfer(_to, _value);
188   }
189 
190   function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
191     return super.transferFrom(_from, _to, _value);
192   }
193 
194   function approve(address _spender, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
195     return super.approve(_spender, _value);
196   }
197 
198   function increaseApproval(address _spender, uint _addedValue) public transferAllowed(msg.sender) returns (bool success) {
199     return super.increaseApproval(_spender, _addedValue);
200   }
201 
202   function decreaseApproval(address _spender, uint _subtractedValue) public transferAllowed(msg.sender) returns (bool success) {
203     return super.decreaseApproval(_spender, _subtractedValue);
204   }
205 }
206 
207 
208 contract  KALCToken is ControlledToken, BurnableToken {
209 
210 
211 
212 	constructor() public {
213         balances[msg.sender] = totalSupply;
214         emit Transfer(address(0), msg.sender, totalSupply);
215 	}
216 
217 	event LogRedeem(address beneficiary, uint256 amount);
218 
219 	function redeem() public {
220 
221 		uint256 balance = balanceOf(msg.sender);
222 		super.burn(balance);
223  		emit LogRedeem(msg.sender, balance);
224 	}
225 
226 
227 }
228 
229 
230 library SafeMath {
231 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232 		if (a == 0) {
233 			return 0;
234 		}
235 		uint256 c = a * b;
236 		assert(c / a == b);
237 		return c;
238 	}
239 
240 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
241 		// assert(b > 0); // Solidity automatically throws when dividing by 0
242 		uint256 c = a / b;
243 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
244 		return c;
245 	}
246 
247 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248 		assert(b <= a);
249 		return a - b;
250 	}
251 
252 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
253 		uint256 c = a + b;
254 		assert(c >= a);
255 		return c;
256 	}
257 }