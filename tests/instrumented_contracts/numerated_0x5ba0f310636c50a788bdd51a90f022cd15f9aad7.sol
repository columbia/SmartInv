1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     // uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return a / b;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 }
52 
53 // Abstract contract for the full ERC 20 Token standard
54 // https://github.com/ethereum/EIPs/issues/20
55 contract ERC20 {
56     uint256 public _totalSupply;
57     string public name;
58     string public symbol;
59     uint8 public decimals;
60 
61     function totalSupply() public constant returns (uint256 supply);
62     function balanceOf(address _owner) public view returns (uint256 balance);
63     function transfer(address _to, uint256 _value) public returns (bool success);
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
65     function approve(address _spender, uint256 _value) public returns (bool success);
66     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 }
71 
72 //Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
73 
74 contract ERC20Token is ERC20 {
75     using SafeMath for uint256;
76 
77     function totalSupply() public constant returns (uint) {
78         return _totalSupply.sub(balances[address(0)]);
79     }
80 
81     function balanceOf(address _owner) view public returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         //require(balances[msg.sender] >= _value);
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         emit Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
94         balances[_to] = balances[_to].add(_value);
95         balances[_from] = balances[_from].sub(_value);
96         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97         emit Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function approve(address _spender, uint256 _value) public returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
108         return allowed[_owner][_spender];
109     }
110 
111     mapping (address => uint256) balances;
112     mapping (address => mapping (address => uint256)) allowed;
113 }
114 
115 /**
116  * @title ERC677 transferAndCall token interface
117  * @dev See https://github.com/ethereum/EIPs/issues/677 for specification and
118  *      discussion.
119  */
120 contract ERC677 {
121     event Transfer(address indexed _from, address indexed _to, uint256 _amount, bytes _data);
122 
123     function transferAndCall(address _receiver, uint _amount, bytes _data) public;
124 }
125 
126 
127 /**
128  * @title Receiver interface for ERC677 transferAndCall
129  * @dev See https://github.com/ethereum/EIPs/issues/677 for specification and
130  *      discussion.
131  */
132 contract ERC677Receiver {
133     function tokenFallback(address _from, uint _amount, bytes _data) public;
134 }
135 
136 contract ERC677Token is ERC677, ERC20Token {
137     function transferAndCall(address _receiver, uint _amount, bytes _data) public {
138         require(super.transfer(_receiver, _amount));
139 
140         emit Transfer(msg.sender, _receiver, _amount, _data);
141 
142         // call receiver
143         if (isContract(_receiver)) {
144             ERC677Receiver to = ERC677Receiver(_receiver);
145             to.tokenFallback(msg.sender, _amount, _data);
146         }
147     }
148 
149     function isContract(address _addr) internal view returns (bool) {
150         uint len;
151         assembly {
152             len := extcodesize(_addr)
153         }
154         return len > 0;
155     }
156 }
157 
158 contract Splitable is ERC677Token, Ownable {
159     uint32 public split;
160     mapping (address => uint32) public splits;
161 
162     event Split(address indexed addr, uint32 multiplyer);
163 
164     constructor() public {
165         split = 0;
166     }
167 
168     function splitShare() onlyOwner public {
169         require(split * 2 >= split);
170         if (split == 0) split = 2;
171         else split *= 2;
172         claimShare();
173     }
174 
175     function isSplitable() public view returns (bool) {
176         return splits[msg.sender] != split;
177     }
178 
179     function claimShare() public {
180         uint32 s = splits[msg.sender];
181         if (s == split) return;
182         if (s == 0) s = 1;
183 
184         splits[msg.sender] = split;
185         uint b = balances[msg.sender];
186         uint nb = b * split / s;
187 
188         balances[msg.sender] = nb;
189         _totalSupply += nb - b;
190     }
191 
192     function claimShare(address _u1, address _u2) public {
193         uint32 s = splits[_u1];
194         if (s != split) {
195             if (s == 0) s = 1;
196 
197             splits[_u1] = split;
198             uint b = balances[_u1];
199             uint nb = b.mul(split / s);
200 
201             balances[_u1] = nb;
202             _totalSupply += nb - b;
203         }
204         s = splits[_u2];
205         if (s != split) {
206             if (s == 0) s = 1;
207 
208             splits[_u2] = split;
209             b = balances[_u2];
210             nb = b.mul(split / s);
211             
212             balances[_u2] = nb;
213             _totalSupply += nb - b;
214         }
215     }
216 
217     function transfer(address _to, uint256 _value) public returns (bool success) {
218         if (splits[msg.sender] != splits[_to]) claimShare(msg.sender, _to);
219         return super.transfer(_to, _value);
220     }
221 
222     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
223         if (splits[_from] != splits[_to]) claimShare(msg.sender, _to);
224         return super.transferFrom(_from, _to, _value);
225     }
226 
227     function transferAndCall(address _receiver, uint _amount, bytes _data) public {
228         if (splits[_receiver] != splits[_receiver]) claimShare(msg.sender, _receiver);
229         return super.transferAndCall(_receiver, _amount, _data);
230     }
231 }
232 
233 contract Lockable is ERC20Token, Ownable {
234     using SafeMath for uint256;
235     mapping (address => uint256) public lockAmounts;
236 
237     // function lock(address to, uint amount) public onlyOwner {
238     //     lockAmounts[to] = lockAmounts[to].add(amount);
239     // }
240 
241     function unlock(address to, uint amount) public onlyOwner {
242         lockAmounts[to] = lockAmounts[to].sub(amount);
243     }
244 
245     function issueCoin(address to, uint amount) public onlyOwner {
246         lockAmounts[to] = lockAmounts[to].add(amount);
247         transfer(to, amount);
248     //  balances[to] = balances[to].add(amount);
249     //  balances[owner] = balances[owner].sub(amount);
250     //  emit Transfer(owner, to, amount);
251     }
252 
253     function transfer(address _to, uint256 _value) public returns (bool success) {
254         require(balances[msg.sender] >= _value + lockAmounts[msg.sender]);
255         return super.transfer(_to, _value);
256     }
257 
258     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
259         require(balances[_from] >= _value + lockAmounts[_from]);
260         return super.transferFrom(_from, _to, _value);
261     }
262 }
263 
264 contract VCoin is ERC677Token, Ownable, Splitable, Lockable {
265     uint32 public purchaseNo;
266     event Purchase(uint32 indexed purchaseNo, address from, uint value, bytes data);
267 
268     constructor() public {
269         symbol = "VICT";
270         name = "Victory Token";
271         decimals = 18;
272         _totalSupply = 1000000000 * 10**uint(decimals);
273 
274         balances[owner] = _totalSupply;
275         emit Transfer(address(0), owner, _totalSupply);
276 
277         purchaseNo = 1;
278     }
279 
280     function () public payable {
281         require(!isContract(msg.sender));
282         owner.transfer(msg.value);
283         emit Purchase(purchaseNo++, msg.sender, msg.value, msg.data);
284         //emit Transfer(owner, msg.sender, msg.value);
285     }
286 }