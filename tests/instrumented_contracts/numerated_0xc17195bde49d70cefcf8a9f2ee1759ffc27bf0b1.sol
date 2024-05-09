1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     address public owner;
5     
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7     
8     function Ownable() public {
9         owner = msg.sender;
10     }
11     
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16     
17     function transferOwnership(address newOwner) onlyOwner public {
18         require(newOwner != address(0));
19         OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 contract Pausable is Ownable {
25     bool public paused = false;
26     
27     event Pause();
28     event Unpause();
29 
30     modifier whenNotPaused() {
31         require(!paused);
32         _;
33     }
34     
35     modifier whenPaused() {
36         require(paused);
37         _;
38     }
39     
40     function pause() onlyOwner whenNotPaused public {
41         paused = true;
42         Pause();
43     }
44     
45     function unpause() onlyOwner whenPaused public {
46         paused = false;
47         Unpause();
48     }
49 }
50 
51 contract ERC20Basic {
52     uint256 public totalSupply;
53     function balanceOf(address who) public constant returns (uint256);
54     function transfer(address to, uint256 value) public returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract BasicToken is ERC20Basic {
59     using SafeMath for uint256;
60     
61     mapping(address => uint256) balances;
62     
63     function transfer(address _to, uint256 _value) public returns (bool) {
64         require(_to != address(0));
65         require(_value <= balances[msg.sender]);
66         
67         // SafeMath.sub will throw if there is not enough balance.
68         balances[msg.sender] = balances[msg.sender].sub(_value);
69         balances[_to] = balances[_to].add(_value);
70         Transfer(msg.sender, _to, _value);
71         return true;
72     }
73     
74     function balanceOf(address _owner) public constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 }
78 
79 contract ERC20 is ERC20Basic {
80     function allowance(address owner, address spender) public constant returns (uint256);
81     function transferFrom(address from, address to, uint256 value) public returns (bool);
82     function approve(address spender, uint256 value) public returns (bool);
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 library SafeERC20 {
87     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
88         assert(token.transfer(to, value));
89     }
90     
91     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
92         assert(token.transferFrom(from, to, value));
93     }
94     
95     function safeApprove(ERC20 token, address spender, uint256 value) internal {
96         assert(token.approve(spender, value));
97     }
98 }
99 
100 
101 contract StandardToken is ERC20, BasicToken {
102     mapping (address => mapping (address => uint256)) internal allowed;
103     
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
105         require(_to != address(0));
106         require(_value <= balances[_from]);
107         require(_value <= allowed[_from][msg.sender]);
108         
109         balances[_from] = balances[_from].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112         Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     function approve(address _spender, uint256 _value) public returns (bool) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
123         return allowed[_owner][_spender];
124     }
125 
126     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
127         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
128         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129         return true;
130     }
131 
132     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
133         uint oldValue = allowed[msg.sender][_spender];
134         
135         if (_subtractedValue > oldValue) {
136             allowed[msg.sender][_spender] = 0;
137         } else {
138             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
139         }
140         
141         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142         return true;
143     }
144 }
145   
146 contract LockableToken is StandardToken, Ownable {
147     mapping (address => uint256) internal lockaddress;
148     
149     event Lock(address indexed locker, uint256 time);
150     
151     function lockStatus(address _address) public constant returns(uint256) {
152         return lockaddress[_address];
153     }
154     
155     function lock(address _address, uint256 _time) onlyOwner public {
156         require(_time > now);
157         
158         lockaddress[_address] = _time;
159         Lock(_address, _time);
160     }
161     
162     modifier isNotLocked() {
163         require(lockaddress[msg.sender] < now || lockaddress[msg.sender] == 0);
164         _;
165     }
166 }
167   
168 contract BurnableToken is StandardToken {
169     event Burn(address indexed burner, uint256 value);
170     
171     function burn(uint256 _value) public {
172         require(_value > 0);
173         require(_value <= balances[msg.sender]);
174         
175         address burner = msg.sender;
176         balances[burner] = balances[burner].sub(_value);
177         totalSupply = totalSupply.sub(_value);
178         Burn(burner, _value);
179     }
180 }
181 
182 contract PausableToken is StandardToken, LockableToken, Pausable {
183     modifier whenNotPausedOrOwner() {
184         require(msg.sender == owner || !paused);
185         _;
186     }
187     
188     function transfer(address _to, uint256 _value) public whenNotPausedOrOwner isNotLocked returns (bool) {
189         return super.transfer(_to, _value);
190     }
191     
192     function transferFrom(address _from, address _to, uint256 _value) public whenNotPausedOrOwner isNotLocked returns (bool) {
193         return super.transferFrom(_from, _to, _value);
194     }
195     
196     function approve(address _spender, uint256 _value) public whenNotPausedOrOwner isNotLocked returns (bool) {
197         return super.approve(_spender, _value);
198     }
199     
200     function increaseApproval(address _spender, uint _addedValue) public whenNotPausedOrOwner isNotLocked returns (bool success) {
201         return super.increaseApproval(_spender, _addedValue);
202     }
203     
204     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPausedOrOwner isNotLocked returns (bool success) {
205         return super.decreaseApproval(_spender, _subtractedValue);
206     }
207 }
208 
209 contract Groocoin is PausableToken, BurnableToken {
210     string constant public name = "Groocoin";
211     string constant public symbol = "GROO";
212     uint256 constant public decimals = 18;
213     uint256 constant TOKEN_UNIT = 10 ** uint256(decimals);
214     uint256 constant INITIAL_SUPPLY = 30000000000 * TOKEN_UNIT;
215     
216     function Groocoin() public {
217         paused = true;
218         
219         totalSupply = INITIAL_SUPPLY;
220         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
221         balances[msg.sender] = INITIAL_SUPPLY;
222     }
223 }
224 
225 library SafeMath {
226     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
227         uint256 c = a * b;
228         assert(a == 0 || c / a == b);
229         return c;
230     }
231     
232     function div(uint256 a, uint256 b) internal pure returns (uint256) {
233         uint256 c = a / b;
234         return c;
235     }
236     
237     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238         assert(b <= a);
239         return a - b;
240     }
241     
242     function add(uint256 a, uint256 b) internal pure returns (uint256) {
243         uint256 c = a + b;
244         assert(c >= a);
245         return c;
246     }
247 }