1 pragma solidity 0.4.25;
2 
3 contract Owned {
4     address public contractOwner;
5 
6     constructor() public {
7         contractOwner = msg.sender;
8     }
9 
10     modifier onlyContractOwner() {
11         require(contractOwner == msg.sender);
12         _;
13     }
14 
15     function forceChangeContractOwnership(address _to) public onlyContractOwner() returns(bool) {
16         contractOwner = _to;
17         return true;
18     }
19 }
20 
21 library SafeMath {
22     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns(uint256) {
33         require(b > 0);
34         uint256 c = a / b;
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
39         require(b <= a);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns(uint256) {
45         uint256 c = a + b;
46         require(c >= a);
47         return c;
48     }
49 
50     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
51         require(b != 0);
52         return a % b;
53     }
54 }
55 
56 contract BDCToken is Owned {
57     using SafeMath for uint256;
58 
59     mapping (bytes => bool) private alreadyUsed;
60     mapping (address => uint256) private balances;
61     mapping (address => mapping (address => uint256)) private allowed;
62 
63     event Transfer(
64         address indexed from,
65         address indexed to,
66         uint256 value
67     );
68 
69     event Mint(
70         address indexed to,
71         uint256 value
72     );
73 
74     event Burn(
75         address indexed to,
76         uint256 value
77     );
78 
79     event Approval(
80         address indexed owner,
81         address indexed spender,
82         uint256 value
83     );
84 
85     string private _name;
86     string private _symbol;
87     uint8 private _decimals;
88 
89     constructor(string name, string symbol, uint8 decimals) public {
90         _name = name;
91         _symbol = symbol;
92         _decimals = decimals;
93     }
94 
95     function transfer(address _to, uint256 _value) public returns(bool) {
96         _transfer(msg.sender, _to, _value);
97         return true;
98     }
99 
100     function ECDSATransfer(
101         address _to,
102         uint256 _value,
103         bytes32 _hash,
104         bytes _sig
105     )
106         onlyContractOwner()
107         public
108         returns(bytes32)
109     {
110         require(!alreadyUsed[_sig]);
111 
112         address from = recover(_hash, _sig);
113         alreadyUsed[_sig] = true;
114         _transfer(from, _to, _value);
115     }
116 
117     function transferFrom(
118         address _from,
119         address _to,
120         uint256 _value
121     )
122         public
123         returns(bool)
124     {
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         _transfer(_from, _to, _value);
127         return true;
128     }
129 
130     function approve(address _spender, uint256 _value) public returns(bool) {
131         require(_spender != address(0));
132 
133         allowed[msg.sender][_spender] = _value;
134         emit Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     function increaseAllowance(
139         address _spender,
140         uint256 _added_value
141     )
142         public
143         returns(bool)
144     {
145         require(_spender != address(0));
146 
147         allowed[msg.sender][_spender] = (
148             allowed[msg.sender][_spender].add(_added_value)
149         );
150         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151         return true;
152     }
153 
154     function decreaseAllowance(
155         address _spender,
156         uint256 _subtracted_value
157     )
158         public
159         returns(bool)
160     {
161         require(_spender != address(0));
162 
163         allowed[msg.sender][_spender] = (
164             allowed[msg.sender][_spender].sub(_subtracted_value)
165         );
166         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167         return true;
168     }
169 
170     function mint(
171         address _account,
172         uint256 _value
173     )
174         onlyContractOwner()
175         public
176         returns(bool)
177     {
178         require(_account != address(0));
179 
180         balances[_account] = balances[_account].add(_value);
181         emit Mint(_account, _value);
182         return true;
183     }
184 
185     function burn(
186         address _account,
187         uint256 _value
188     )
189         onlyContractOwner()
190         public
191         returns(bool)
192     {
193         require(_account != address(0));
194 
195         balances[_account] = balances[_account].sub(_value);
196         emit Burn(_account, _value);
197         return true;
198     }
199 
200     function allowance(
201         address _owner,
202         address _spender
203     )
204         public
205         view
206         returns(uint256)
207     {
208         return allowed[_owner][_spender];
209     }
210 
211     function balanceOf(address _owner) public view returns(uint256) {
212         return balances[_owner];
213     }
214 
215     function name() public view returns(string) {
216         return _name;
217     }
218 
219     function symbol() public view returns(string) {
220         return _symbol;
221     }
222 
223     function decimals() public view returns(uint8) {
224         return _decimals;
225     }
226 
227     function recover(
228         bytes32 hash,
229         bytes signature
230     )
231         public
232         pure
233         returns (address)
234     {
235         bytes32 r;
236         bytes32 s;
237         uint8 v;
238         if (signature.length != 65) {
239             return (address(0));
240         }
241         assembly {
242             r := mload(add(signature, 0x20))
243             s := mload(add(signature, 0x40))
244             v := byte(0, mload(add(signature, 0x60)))
245         }
246         if (v < 27) {
247             v += 27;
248         }
249         if (v != 27 && v != 28) {
250             return (address(0));
251         } else {
252             return ecrecover(hash, v, r, s);
253         }
254     }
255 
256     function _transfer(
257         address _from,
258         address _to,
259         uint256 _value
260     )
261         internal
262     {
263         require(_to != address(0));
264 
265         balances[_from] = balances[_from].sub(_value);
266         balances[_to] = balances[_to].add(_value);
267         emit Transfer(_from, _to, _value);
268     }
269 }