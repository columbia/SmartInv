1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
5         if(a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns(uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipRenounced(address indexed previousOwner);
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     modifier onlyOwner() { require(msg.sender == owner); _;  }
36 
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41     function _transferOwnership(address _newOwner) internal {
42         require(_newOwner != address(0));
43         emit OwnershipTransferred(owner, _newOwner);
44         owner = _newOwner;
45     }
46 
47     function renounceOwnership() public onlyOwner {
48         emit OwnershipRenounced(owner);
49         owner = address(0);
50     }
51 
52     function transferOwnership(address _newOwner) public onlyOwner {
53         _transferOwnership(_newOwner);
54     }
55 }
56 
57 contract ERC20 {
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 
61     function totalSupply() public view returns(uint256);
62     function balanceOf(address who) public view returns(uint256);
63     function transfer(address to, uint256 value) public returns(bool);
64     function transferFrom(address from, address to, uint256 value) public returns(bool);
65     function massTransfer(address[] _tos, uint256[] _values) public returns(bool);
66     function allowance(address owner, address spender) public view returns(uint256);
67     function approve(address spender, uint256 value) public returns(bool);
68 }
69 
70 contract StandardToken is ERC20, Ownable {
71     using SafeMath for uint256;
72 
73     uint256 totalSupply_;
74 
75     string public name;
76     string public symbol;
77     uint8 public decimals;
78 
79     mapping(address => uint256) balances;
80     mapping(address => mapping(address => uint256)) public allowed;
81 
82     constructor(string _name, string _symbol, uint8 _decimals) public {
83         name = _name;
84         symbol = _symbol;
85         decimals = _decimals;
86     }
87     
88     
89     ////////////////////////////
90     bool public paused = true;
91     
92     event Pause();
93     event Unpause();
94 
95     modifier whenNotPaused() { require(!paused); _; }
96     modifier whenPaused() { require(paused); _; }
97 
98     function pause() onlyOwner whenNotPaused public {
99         paused = true;
100         emit Pause();
101     }
102     
103     function unpause() onlyOwner whenPaused public {
104         paused = false;
105         emit Unpause();
106     }
107     ////////////////////////////
108     
109     
110     
111     function totalSupply() public view returns(uint256) {
112         return totalSupply_;
113     }
114 
115     function balanceOf(address _owner) public view returns(uint256) {
116         return balances[_owner];
117     }
118     
119     //////////////////////////
120     function transfer(address _to, uint256 _amount) whenNotPaused public returns(bool) {
121         require(_to != address(0));
122         require(_amount <= balances[msg.sender]);
123 
124         balances[msg.sender] = balances[msg.sender].sub(_amount);
125         balances[_to] = balances[_to].add(_amount);
126         
127         emit Transfer(msg.sender, _to, _amount);
128         return true;
129     }
130 
131     function massTransfer(address[] _tos, uint256[] _amounts) whenNotPaused public returns(bool){
132         require(_tos.length == _amounts.length);
133 
134         uint256 S;
135         uint8 x = 0;
136         for(x;x < _amounts.length;x++){
137             S += _amounts[x];
138         }
139         require(S <= balances[msg.sender]);
140 
141         uint8 i = 0;
142         for (i; i < _tos.length; i++) {
143             balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
144             balances[_tos[i]] = balances[_tos[i]].add(_amounts[i]);
145 
146             emit Transfer(msg.sender, _tos[i], _amounts[i]);
147         }
148         return true;
149     }
150 
151     function transferFrom(address _from, address _to, uint256 _amount) whenNotPaused public returns(bool) {
152         require(_to != address(0));
153         require(_amount <= allowed[_from][msg.sender]); // Check allowance
154         require(_amount > 0);
155 
156         balances[_from] = balances[_from].sub(_amount);
157         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
158         balances[_to] = balances[_to].add(_amount);
159 
160         emit Transfer(_from, _to, _amount);
161         return true;
162     }
163     //////////////////////////
164     
165 
166     function allowance(address _owner, address _spender) public view returns(uint256) {
167         return allowed[_owner][_spender];
168     }
169 
170     function approve(address _spender, uint256 _value) public returns(bool) {
171         allowed[msg.sender][_spender] = _value;
172 
173         emit Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 
177     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
178         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
179 
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
185         uint oldValue = allowed[msg.sender][_spender];
186 
187         if(_subtractedValue > oldValue) {
188             allowed[msg.sender][_spender] = 0;
189         }
190         else {
191             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192         }
193 
194         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196     }
197 }
198 
199 contract MintableToken is StandardToken {
200     bool public mintingFinished = false;
201 
202     event Mint(address indexed to, uint256 amount);
203     event MintFinished();
204 
205     modifier canMint() { require(!mintingFinished); _; }
206     modifier hasMintPermission() { require(msg.sender == owner); _; }
207 
208     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
209         totalSupply_ = totalSupply_.add(_amount);
210         balances[_to] = balances[_to].add(_amount);
211 
212         emit Mint(_to, _amount);
213         emit Transfer(address(0), _to, _amount);
214         return true;
215     }
216 
217     function massMint(address[] _tos, uint256[] _amounts) hasMintPermission canMint public returns(bool) {
218         require(_tos.length == _amounts.length);
219 
220         uint8 i = 0;
221         for (i; i < _tos.length; i++) {
222             totalSupply_ = totalSupply_.add(_amounts[i]);
223             balances[_tos[i]] = balances[_tos[i]].add(_amounts[i]);
224 
225             emit Mint(_tos[i], _amounts[i]);
226             emit Transfer(address(0), _tos[i], _amounts[i]);
227         }
228         return true;
229     }
230 
231     function finishMinting() onlyOwner canMint public returns(bool) {
232         mintingFinished = true;
233 
234         emit MintFinished();
235         return true;
236     }
237 }
238 
239 contract CappedToken is MintableToken {
240     uint256 public cap;
241 
242     constructor(uint256 _cap) public {
243         require(_cap > 0);
244         cap = _cap;
245     }
246 
247     function mint(address _to, uint256 _amount) public returns(bool) {
248         require(totalSupply_.add(_amount) <= cap);
249 
250         return super.mint(_to, _amount);
251     }
252 }
253 
254 contract BurnableToken is StandardToken {
255     event Burn(address indexed burner, uint256 value);
256 
257     function _burn(address _who, uint256 _value) internal {
258         require(_value <= balances[_who]);
259 
260         balances[_who] = balances[_who].sub(_value);
261         totalSupply_ = totalSupply_.sub(_value);
262 
263         emit Burn(_who, _value);
264         emit Transfer(_who, address(0), _value);
265     }
266 
267     function burn(address _from, uint256 _value) onlyOwner public {
268         _burn(_from, _value);
269     }
270 }
271 
272 contract SafeCrypt is CappedToken, BurnableToken {
273     constructor() CappedToken(1535714285) StandardToken("SafeCrypt", "SFC", 0) public { }
274 }