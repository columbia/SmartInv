1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Basic {
5     function totalSupply() public view returns (uint256);
6     function balanceOf(address who) public view returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 library SafeMath {
13 
14 
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16 
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28 
29         return a / b;
30     }
31 
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40         c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 
47 contract BasicToken is ERC20Basic {
48     using SafeMath for uint256;
49 
50     mapping(address => uint256) balances;
51 
52     uint256 totalSupply_;
53 
54 
55     function totalSupply() public view returns (uint256) {
56         return totalSupply_;
57     }
58 
59 
60     function transfer(address _to, uint256 _value) public returns (bool) {
61         require(_to != address(0));
62         require(_value <= balances[msg.sender]);
63 
64         balances[msg.sender] = balances[msg.sender].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66         emit Transfer(msg.sender, _to, _value);
67         return true;
68     }
69 
70 
71     function balanceOf(address _owner) public view returns (uint256) {
72         return balances[_owner];
73     }
74 
75 }
76 
77 
78 contract ERC20 is ERC20Basic {
79     function allowance(address owner, address spender)
80     public view returns (uint256);
81 
82     function transferFrom(address from, address to, uint256 value)
83     public returns (bool);
84 
85     function approve(address spender, uint256 value) public returns (bool);
86     event Approval(
87         address indexed owner,
88         address indexed spender,
89         uint256 value
90     );
91 }
92 
93 
94 contract StandardToken is ERC20, BasicToken {
95 
96     mapping (address => mapping (address => uint256)) internal allowed;
97 
98 
99     function transferFrom(
100         address _from,
101         address _to,
102         uint256 _value
103     )
104     public
105     returns (bool)
106     {
107         require(_to != address(0));
108         require(_value <= balances[_from]);
109         require(_value <= allowed[_from][msg.sender]);
110 
111         balances[_from] = balances[_from].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114         emit Transfer(_from, _to, _value);
115         return true;
116     }
117 
118 
119     function approve(address _spender, uint256 _value) public returns (bool) {
120         allowed[msg.sender][_spender] = _value;
121         emit Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125 
126     function allowance(
127         address _owner,
128         address _spender
129     )
130     public
131     view
132     returns (uint256)
133     {
134         return allowed[_owner][_spender];
135     }
136 
137 
138     function increaseApproval(
139         address _spender,
140         uint256 _addedValue
141     )
142     public
143     returns (bool)
144     {
145         allowed[msg.sender][_spender] = (
146         allowed[msg.sender][_spender].add(_addedValue));
147         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148         return true;
149     }
150 
151 
152     function decreaseApproval(
153         address _spender,
154         uint256 _subtractedValue
155     )
156     public
157     returns (bool)
158     {
159         uint256 oldValue = allowed[msg.sender][_spender];
160         if (_subtractedValue > oldValue) {
161             allowed[msg.sender][_spender] = 0;
162         } else {
163             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164         }
165         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166         return true;
167     }
168 
169 }
170 
171 
172 contract Ownable {
173     address public owner;
174 
175 
176     event OwnershipRenounced(address indexed previousOwner);
177     event OwnershipTransferred(
178         address indexed previousOwner,
179         address indexed newOwner
180     );
181 
182 
183     constructor() public {
184         owner = msg.sender;
185     }
186 
187     modifier onlyOwner() {
188         require(msg.sender == owner);
189         _;
190     }
191 
192 
193     function renounceOwnership() public onlyOwner {
194         emit OwnershipRenounced(owner);
195         owner = address(0);
196     }
197 
198     function transferOwnership(address _newOwner) public onlyOwner {
199         _transferOwnership(_newOwner);
200     }
201 
202 
203     function _transferOwnership(address _newOwner) internal {
204         require(_newOwner != address(0));
205         emit OwnershipTransferred(owner, _newOwner);
206         owner = _newOwner;
207     }
208 }
209 
210 contract MintableToken is StandardToken, Ownable {
211     event Mint(address indexed to, uint256 amount);
212     event MintFinished();
213 
214     bool public mintingFinished = false;
215 
216 
217     modifier canMint() {
218         require(!mintingFinished);
219         _;
220     }
221 
222     modifier hasMintPermission() {
223         require(msg.sender == owner);
224         _;
225     }
226 
227     function mint(
228         address _to,
229         uint256 _amount
230     )
231     hasMintPermission
232     canMint
233     public
234     returns (bool)
235     {
236         totalSupply_ = totalSupply_.add(_amount);
237         balances[_to] = balances[_to].add(_amount);
238         emit Mint(_to, _amount);
239         emit Transfer(address(0), _to, _amount);
240         return true;
241     }
242 
243 
244     function finishMinting() onlyOwner canMint public returns (bool) {
245         mintingFinished = true;
246         emit MintFinished();
247         return true;
248     }
249 }
250 
251 
252 contract BurnableToken is BasicToken {
253 
254     event Burn(address indexed burner, uint256 value);
255 
256 
257     function burn(uint256 _value) public {
258         _burn(msg.sender, _value);
259     }
260 
261     function _burn(address _who, uint256 _value) internal {
262         require(_value <= balances[_who]);
263 
264         balances[_who] = balances[_who].sub(_value);
265         totalSupply_ = totalSupply_.sub(_value);
266         emit Burn(_who, _value);
267         emit Transfer(_who, address(0), _value);
268     }
269 }
270 
271 
272 contract StandardBurnableToken is BurnableToken, StandardToken {
273 
274 
275     function burnFrom(address _from, uint256 _value) public {
276         require(_value <= allowed[_from][msg.sender]);
277 
278         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
279         _burn(_from, _value);
280     }
281 }
282 
283 
284 contract GACToken is MintableToken, StandardBurnableToken {
285     string public name = 'Glocal Art Culture Token';
286     string public symbol = 'GACT';
287     uint public decimals = 18;
288     uint public INITIAL_SUPPLY = 10000000000 * 10 ** (uint256(18));
289 
290     function GACToken() {
291         totalSupply_ = INITIAL_SUPPLY;
292         balances[msg.sender] = INITIAL_SUPPLY;
293     }
294 
295 
296 }