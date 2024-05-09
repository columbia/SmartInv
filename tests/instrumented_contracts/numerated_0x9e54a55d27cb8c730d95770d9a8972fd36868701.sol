1 pragma solidity 0.4.24;
2 
3 // File: contracts\misc\Ownable.sol
4 
5 contract Ownable 
6 {
7     address public owner;
8 
9     event OwnershipRenounced(address indexed previousOwner);
10     event OwnershipTransferred(
11       address indexed previousOwner,
12       address indexed newOwner
13     );
14 
15     constructor() public 
16     {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner() 
21     {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     function transferOwnership(address _newOwner) public 
27     onlyOwner 
28     {
29         _transferOwnership(_newOwner);
30     }
31 
32     function _transferOwnership(address _newOwner) internal 
33     {
34         require(_newOwner != address(0));
35         emit OwnershipTransferred(owner, _newOwner);
36         owner = _newOwner;
37     }
38 }
39 
40 // File: contracts\misc\SafeMath.sol
41 
42 library SafeMath 
43 {
44     function mul(uint256 a, uint256 b) internal pure 
45     returns (uint256 c) 
46     {
47         if (a == 0) 
48         {
49             return 0;
50         }
51 
52         c = a * b;
53         assert(c / a == b);
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure 
58     returns (uint256) 
59     {
60         return a / b;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure 
64     returns (uint256) 
65     {
66         assert(b <= a);
67         return a - b;
68     }
69 
70     function add(uint256 a, uint256 b) internal pure 
71     returns (uint256 c) 
72     {
73         c = a + b;
74         assert(c >= a);
75         return c;
76     }
77 }
78 
79 // File: contracts\token\ERC20Basic.sol
80 
81 contract ERC20Basic 
82 {
83     function totalSupply() public view returns (uint256);
84     function balanceOf(address who) public view returns (uint256);
85     function transfer(address to, uint256 value) public returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 // File: contracts\token\BasicToken.sol
90 
91 contract BasicToken is ERC20Basic 
92 {
93     using SafeMath for uint256;
94     mapping(address => uint256) balances;
95     
96     uint256 totalSupply_;
97 
98     function totalSupply() public view 
99     returns (uint256) 
100     {
101         return totalSupply_;
102     }
103 
104     function transfer(address _to, uint256 _value) public 
105     returns (bool) 
106     {
107         require(_to != address(0));
108         require(_value <= balances[msg.sender]);
109 
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         emit Transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     function balanceOf(address _owner) public view 
117     returns (uint256) 
118     {
119         return balances[_owner];
120     }
121 }
122 
123 // File: contracts\token\BurnableToken.sol
124 
125 contract BurnableToken is BasicToken, Ownable
126 {
127     event Burn(address indexed burner, uint256 value);
128 
129     function burn(address burnAddress, uint256 value) public 
130     onlyOwner
131     {
132         require(value <= balances[burnAddress]);
133 
134         balances[burnAddress] = balances[burnAddress].sub(value);
135         totalSupply_ = totalSupply_.sub(value);
136         emit Burn(burnAddress, value);
137         emit Transfer(burnAddress, address(0), value);
138     }
139 }
140 
141 // File: contracts\token\ERC20.sol
142 
143 contract ERC20 is ERC20Basic 
144 {
145     function allowance(address owner, address spender) public view returns (uint256);
146 
147     function transferFrom(address from, address to, uint256 value) public returns (bool);
148 
149     function approve(address spender, uint256 value) public returns (bool); 
150     
151     event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 // File: contracts\token\StandardToken.sol
155 
156 contract StandardToken is ERC20, BasicToken 
157 {
158     mapping (address => mapping (address => uint256)) internal allowed;
159 
160     function transferFrom(address _from, address _to, uint256 _value) public
161     returns (bool)
162     {
163         require(_to != address(0));
164         require(_value <= balances[_from]);
165         require(_value <= allowed[_from][msg.sender]);
166 
167         balances[_from] = balances[_from].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173 
174 
175     function approve(address _spender, uint256 _value) public 
176     returns (bool) 
177     {
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     function allowance(address _owner, address _spender) public view
184     returns (uint256)
185     {
186         return allowed[_owner][_spender];
187     }
188 
189     function increaseApproval(address _spender, uint256 _addedValue) public
190     returns (bool)
191     {
192         allowed[msg.sender][_spender] = (
193         allowed[msg.sender][_spender].add(_addedValue));
194         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196     }
197 
198     function decreaseApproval(address _spender, uint256 _subtractedValue) public
199     returns (bool)
200     {
201         uint256 oldValue = allowed[msg.sender][_spender];
202 
203         if (_subtractedValue > oldValue) 
204         {
205             allowed[msg.sender][_spender] = 0;
206         } 
207         else 
208         {
209             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210         }
211 
212         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216 }
217 
218 // File: contracts\token\MintableToken.sol
219 
220 contract MintableToken is StandardToken, Ownable 
221 {
222     event Mint(address indexed to, uint256 amount);
223 
224     function mint(address _to, uint256 _amount) public
225     onlyOwner
226     returns (bool)
227     {
228         totalSupply_ = totalSupply_.add(_amount);
229         balances[_to] = balances[_to].add(_amount);
230         emit Mint(_to, _amount);
231         emit Transfer(address(0), _to, _amount);
232         return true;
233     }
234 }
235 
236 // File: contracts\token\Pausable.sol
237 
238 contract Pausable is Ownable 
239 {
240     event Pause();
241     event Unpause();
242 
243     bool public paused = false;
244 
245     modifier whenNotPaused() {
246         require(!paused);
247         _;
248     }
249 
250     modifier whenPaused() {
251         require(paused);
252         _;
253     }
254 
255     function pause() public
256     onlyOwner 
257     whenNotPaused  
258     {
259         paused = true;
260         emit Pause();
261     }
262 
263     function unpause() public
264     onlyOwner 
265     whenPaused  
266     {
267         paused = false;
268         emit Unpause();
269     }
270 }
271 
272 // File: contracts\IndexToken.sol
273 
274 contract IndexToken is BurnableToken, MintableToken, Pausable
275 {
276     string constant public name = "Coffee Token";
277     string constant public symbol = "dqr";
278 
279     uint public decimals = 18;
280 }