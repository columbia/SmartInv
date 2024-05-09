1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5   
6   
7 
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11 
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16 
17 
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23 
24   function transferOwnership(address newOwner) public onlyOwner {
25     require(newOwner != address(0));
26     OwnershipTransferred(owner, newOwner);
27     owner = newOwner;
28   }
29   
30   
31 
32 }
33 
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39   
40 }
41 
42 contract BasicToken is ERC20Basic, Ownable {
43 
44     using SafeMath for uint256;
45     mapping(address => uint256) balances;
46 
47     bool public transfersEnabledFlag;
48 
49 
50     modifier transfersEnabled() {
51         require(transfersEnabledFlag);
52         _;
53     }
54 
55     function enableTransfers() public onlyOwner {
56         transfersEnabledFlag = true;
57     }
58 
59 
60     function transfer(address _to, uint256 _value) transfersEnabled() public returns (bool) {
61         require(_to != address(0));
62         require(_value <= balances[msg.sender]);
63 
64         // SafeMath.sub will throw if there is not enough balance.
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71 
72     function balanceOf(address _owner) public view returns (uint256 balance) {
73         return balances[_owner];
74     }
75     
76     
77     
78 }
79 
80 
81 
82 
83 
84 library SafeMath {
85   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86     if (a == 0) {
87       return 0;
88     }
89     uint256 c = a * b;
90     assert(c / a == b);
91     return c;
92   }
93 
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     
96     uint256 c = a / b;
97     
98     return c;
99   }
100 
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   function add(uint256 a, uint256 b) internal pure returns (uint256) {
107     uint256 c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118   
119 }
120 
121 
122 contract StandardToken is ERC20, BasicToken {
123 
124     mapping (address => mapping (address => uint256)) internal allowed;
125 
126 
127 
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129         require(_to != address(0));
130         require(_value <= balances[_from]);
131         require(_value <= allowed[_from][msg.sender]);
132 
133         balances[_from] = balances[_from].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136         Transfer(_from, _to, _value);
137         return true;
138     }
139 
140 
141     function approve(address _spender, uint256 _value) public returns (bool) {
142         allowed[msg.sender][_spender] = _value;
143         Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147 
148     function allowance(address _owner, address _spender) public view returns (uint256) {
149         return allowed[_owner][_spender];
150     }
151 
152     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
153         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
154         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155         return true;
156     }
157 
158     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
159         uint oldValue = allowed[msg.sender][_spender];
160         if (_subtractedValue > oldValue) {
161             allowed[msg.sender][_spender] = 0;
162         }
163         else {
164             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
165         }
166         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167         return true;
168     }
169 
170 }
171 
172 contract MintableToken is StandardToken {
173     event Mint(address indexed to, uint256 amount);
174 
175     event MintFinished();
176 
177     bool public mintingFinished = false;
178 
179     mapping(address => bool) public minters;
180 
181     modifier canMint() {
182         require(!mintingFinished);
183         _;
184     }
185     modifier onlyMinters() {
186         require(minters[msg.sender] || msg.sender == owner);
187         _;
188     }
189     function addMinter(address _addr) public onlyOwner {
190         minters[_addr] = true;
191     }
192 
193     function deleteMinter(address _addr) public onlyOwner {
194         delete minters[_addr];
195     }
196 
197 
198     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
199         require(_to != address(0));
200         totalSupply = totalSupply.add(_amount);
201         balances[_to] = balances[_to].add(_amount);
202         Mint(_to, _amount);
203         Transfer(address(0), _to, _amount);
204         return true;
205     }
206 
207     function finishMinting() onlyOwner canMint public returns (bool) {
208         mintingFinished = true;
209         MintFinished();
210         return true;
211     }
212 }
213 
214 
215 
216 contract CappedToken is MintableToken {
217 
218     uint256 public cap;
219     
220 
221     function CappedToken(uint256 _cap) public {
222         require(_cap > 0);
223         cap = _cap;
224     }
225 
226 
227     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
228         require(totalSupply.add(_amount) <= cap);
229 
230         return super.mint(_to, _amount);
231     }
232     
233     
234 
235 }
236 
237 
238 contract ParameterizedToken is CappedToken {
239     
240     event  Burn(address indexed from, uint256 value);
241     
242     string public name;
243 
244     string public symbol;
245 
246     uint256 public decimals;
247     
248     
249     
250     
251 
252     function ParameterizedToken(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
253         name = _name;
254         symbol = _symbol;
255         decimals = _decimals;
256     }
257     
258     function burn(uint256 _value) returns (bool success) {
259         if (balances[msg.sender] < _value) throw;            
260 		if (_value <= 0) throw; 
261 		//update blances and  totalSupply and cap 
262         balances[msg.sender] = balances[msg.sender].sub(_value);  
263         totalSupply = SafeMath.sub(totalSupply,_value);    
264         cap = SafeMath.sub(cap,_value); 
265         Burn(msg.sender, _value);
266         return true;
267     }
268     
269     
270     
271 
272 }
273 
274 contract TigerCash is ParameterizedToken {
275 
276     function TigerCash() public ParameterizedToken("TigerCash", "TCH", 18, 1050000000) {
277     }
278     
279     
280     
281     
282     
283 }