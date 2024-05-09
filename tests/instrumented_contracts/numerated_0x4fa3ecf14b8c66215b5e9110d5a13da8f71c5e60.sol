1 pragma solidity ^0.5.1;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 contract Ownable {
34     address public owner;
35 
36 
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41 
42     modifier onlyOwner() {
43         require(msg.sender == owner, "Sender is not the owner.");
44         _;
45     }
46 
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         if (newOwner != address(0)) {
50             owner = newOwner;
51         }
52     }
53 
54 }
55 
56 
57 
58 
59 
60 
61 contract ERC20Basic {
62     uint public _totalSupply;
63     function totalSupply() public view returns (uint);
64     function balanceOf(address who) public view returns (uint);
65     function transfer(address to, uint value) public;
66     event Transfer(address indexed from, address indexed to, uint value);
67 }
68 
69 
70 
71 
72 contract ERC20 is ERC20Basic {
73     function allowance(address owner, address spender) public view returns (uint);
74     function transferFrom(address from, address to, uint value) public;
75     function approve(address spender, uint value) public;
76     event Approval(address indexed owner, address indexed spender, uint value);
77 }
78 
79 
80 
81 contract BasicToken is Ownable, ERC20Basic {
82     using SafeMath for uint;
83 
84     mapping(address => uint) public balances;
85 
86 
87     modifier onlyPayloadSize(uint size) {
88         require(!(msg.data.length < size + 4), "Payload size is incorrect.");
89         _;
90     }
91 
92 
93 
94 
95 
96     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
97         require(_to != address(0), "_to address is invalid.");
98 
99         balances[msg.sender] = balances[msg.sender].sub(_value);
100         balances[_to] = balances[_to].add(_value);
101         emit Transfer(msg.sender, _to, _value);
102     }
103 
104 
105 
106     function balanceOf(address _owner) public view returns (uint balance) {
107         return balances[_owner];
108     }
109 
110 }
111 
112 
113 
114 
115 contract StandardToken is BasicToken, ERC20 {
116 
117     mapping (address => mapping (address => uint)) public allowed;
118 
119     uint public constant MAX_UINT = 2**256 - 1;
120 
121 
122     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
123         require(_from != address(0), "_from address is invalid.");
124         require(_to != address(0), "_to address is invalid.");
125 
126         uint _allowance = allowed[_from][msg.sender];
127 
128 
129 
130         if (_allowance < MAX_UINT) {
131             allowed[_from][msg.sender] = _allowance.sub(_value);
132         }
133         balances[_from] = balances[_from].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135 
136         emit Transfer(_from, _to, _value);
137     }
138 
139 
140     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
141 
142 
143         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)), "Invalid function arguments.");
144 
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147     }
148 
149 
150     function allowance(address _owner, address _spender) public view returns (uint remaining) {
151         return allowed[_owner][_spender];
152     }
153 
154 }
155 
156 
157 
158 
159 contract Pausable is Ownable {
160     event Pause();
161     event Unpause();
162 
163     bool public paused = false;
164 
165 
166     modifier whenNotPaused() {
167         require(!paused, "Token is paused.");
168         _;
169     }
170 
171     modifier whenPaused() {
172         require(paused, "Token is unpaused.");
173         _;
174     }
175 
176     function pause() public onlyOwner whenNotPaused {
177         paused = true;
178         emit Pause();
179     }
180 
181 
182     function unpause() public onlyOwner whenPaused {
183         paused = false;
184         emit Unpause();
185     }
186 }
187 
188 contract CrediPoints is Pausable, StandardToken {
189 
190     string public name;
191     string public symbol;
192     uint public decimals;
193 
194     mapping(address => bool) public authorized;
195     mapping(address => bool) public blacklisted;
196 
197     constructor() public {
198         name = "CrediPoints";
199         symbol = "CDP";
200         decimals = 4;
201         setAuthorization(0x28DE6bb45c2b8A74DdFaa926F9996Ee2a7FfFba6);
202         transferOwnership(0x28DE6bb45c2b8A74DdFaa926F9996Ee2a7FfFba6);
203     }
204 
205     modifier onlyAuthorized() {
206         require(authorized[msg.sender], "msg.sender is not authorized");
207         _;
208     }
209 
210     event AuthorizationSet(address _address);
211     function setAuthorization(address _address) public onlyOwner {
212         require(_address != address(0), "Provided address is invalid.");
213         require(!authorized[_address], "Address is already authorized.");
214 
215         authorized[_address] = true;
216 
217         emit AuthorizationSet(_address);
218     }
219 
220     event AuthorizationRevoked(address _address);
221     function revokeAuthorization(address _address) public onlyOwner {
222         require(_address != address(0), "Provided address is invalid.");
223         require(authorized[_address], "Address is already unauthorized.");
224 
225         authorized[_address] = false;
226 
227         emit AuthorizationRevoked(_address);
228     }
229 
230     modifier NotBlacklisted(address _address) {
231         require(!blacklisted[_address], "The provided address is blacklisted.");
232         _;
233     }
234 
235     event BlacklistAdded(address _address);
236     function addBlacklist(address _address) public onlyAuthorized {
237         require(_address != address(0), "Provided address is invalid.");
238         require(!blacklisted[_address], "The provided address is already blacklisted");
239         blacklisted[_address] = true;
240 
241         emit BlacklistAdded(_address);
242     }
243 
244     event BlacklistRemoved(address _address);
245     function removeBlacklist(address _address) public onlyAuthorized {
246         require(_address != address(0), "Provided address is invalid.");
247         require(blacklisted[_address], "The provided address is already not blacklisted");
248         blacklisted[_address] = false;
249 
250         emit BlacklistRemoved(_address);
251     }
252 
253     function transfer(address _to, uint _value) public NotBlacklisted(_to) NotBlacklisted(msg.sender) whenNotPaused {
254         return super.transfer(_to, _value);
255     }
256 
257     function transferFrom(address _from, address _to, uint _value) public NotBlacklisted(_to) NotBlacklisted(_from) NotBlacklisted(msg.sender) whenNotPaused {
258         return super.transferFrom(_from, _to, _value);
259     }
260 
261     function balanceOf(address who) public view returns (uint) {
262         return super.balanceOf(who);
263     }
264 
265     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
266         return super.approve(_spender, _value);
267     }
268 
269     function allowance(address _owner, address _spender) public view returns (uint remaining) {
270         return super.allowance(_owner, _spender);
271     }
272 
273 
274     function totalSupply() public view returns (uint) {
275         return _totalSupply;
276     }
277 
278 
279     function issue(uint amount) public onlyAuthorized {
280         _totalSupply = _totalSupply.add(amount);
281         balances[msg.sender] = balances[msg.sender].add(amount);
282 
283         emit Issue(amount);
284     }
285 
286 
287 
288 
289     function redeem(uint amount) public onlyAuthorized {
290         require(_totalSupply >= amount, "Redeem amount is greater than total supply.");
291         require(balances[msg.sender] >= amount, "Redeem amount is greater than sender's balance.");
292 
293         _totalSupply = _totalSupply.sub(amount);
294         balances[msg.sender] = balances[msg.sender].sub(amount);
295         emit Redeem(amount);
296     }
297 
298     // Called when new token are issued
299     event Issue(uint amount);
300 
301     // Called when tokens are redeemed
302     event Redeem(uint amount);
303 
304 }