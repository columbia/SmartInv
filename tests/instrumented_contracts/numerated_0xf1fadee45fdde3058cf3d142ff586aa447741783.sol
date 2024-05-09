1 pragma solidity 0.4.24;
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
63     string public name;
64 
65     event Transfer(
66         address indexed from,
67         address indexed to,
68         uint256 value
69     );
70 
71     event Mint(
72         address indexed to,
73         uint256 value
74     );
75 
76     event Burn(
77         address indexed to,
78         uint256 value
79     );
80 
81     event Approval(
82         address indexed owner,
83         address indexed spender,
84         uint256 value
85     );
86 
87     constructor(string _name) public {
88         name = _name;
89     }
90 
91     function transfer(address _to, uint256 _value) public returns(bool) {
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     function ECDSATransfer(
97         address _to,
98         uint256 _value,
99         bytes32 _hash,
100         bytes _sig
101     )
102         onlyContractOwner()
103         public
104         returns(bytes32)
105     {
106         require(!alreadyUsed[_sig]);
107 
108         address from = recover(_hash, _sig);
109         alreadyUsed[_sig] = true;
110         _transfer(from, _to, _value);
111     }
112 
113     function transferFrom(
114         address _from,
115         address _to,
116         uint256 _value
117     )
118         public
119         returns(bool)
120     {
121         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122         _transfer(_from, _to, _value);
123         return true;
124     }
125 
126     function approve(address _spender, uint256 _value) public returns(bool) {
127         require(_spender != address(0));
128 
129         allowed[msg.sender][_spender] = _value;
130         emit Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     function increaseAllowance(
135         address _spender,
136         uint256 _added_value
137     )
138         public
139         returns(bool)
140     {
141         require(_spender != address(0));
142 
143         allowed[msg.sender][_spender] = (
144             allowed[msg.sender][_spender].add(_added_value)
145         );
146         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147         return true;
148     }
149 
150     function decreaseAllowance(
151         address _spender,
152         uint256 _subtracted_value
153     )
154         public
155         returns(bool)
156     {
157         require(_spender != address(0));
158 
159         allowed[msg.sender][_spender] = (
160             allowed[msg.sender][_spender].sub(_subtracted_value)
161         );
162         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164     }
165 
166     function mint(
167         address _account,
168         uint256 _value
169     )
170         onlyContractOwner()
171         public
172         returns(bool)
173     {
174         require(_account != address(0));
175 
176         balances[_account] = balances[_account].add(_value);
177         emit Mint(_account, _value);
178         return true;
179     }
180 
181     function burn(
182         address _account,
183         uint256 _value
184     )
185         onlyContractOwner()
186         public
187         returns(bool)
188     {
189         require(_account != address(0));
190 
191         balances[_account] = balances[_account].sub(_value);
192         emit Burn(_account, _value);
193         return true;
194     }
195 
196     function allowance(
197         address _owner,
198         address _spender
199     )
200         public
201         view
202         returns(uint256)
203     {
204         return allowed[_owner][_spender];
205     }
206 
207     function balanceOf(address _owner) public view returns(uint256) {
208         return balances[_owner];
209     }
210 
211     function getName() public view returns(string) {
212         return name;
213     }
214 
215     function recover(
216         bytes32 hash,
217         bytes signature
218     )
219         public
220         pure
221         returns (address)
222     {
223         bytes32 r;
224         bytes32 s;
225         uint8 v;
226         if (signature.length != 65) {
227             return (address(0));
228         }
229         assembly {
230             r := mload(add(signature, 0x20))
231             s := mload(add(signature, 0x40))
232             v := byte(0, mload(add(signature, 0x60)))
233         }
234         if (v < 27) {
235             v += 27;
236         }
237         if (v != 27 && v != 28) {
238             return (address(0));
239         } else {
240             return ecrecover(hash, v, r, s);
241         }
242     }
243 
244     function _transfer(
245         address _from,
246         address _to,
247         uint256 _value
248     )
249         internal
250     {
251         require(_to != address(0));
252 
253         balances[_from] = balances[_from].sub(_value);
254         balances[_to] = balances[_to].add(_value);
255         emit Transfer(_from, _to, _value);
256     }
257 }