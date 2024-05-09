1 pragma solidity 0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     function Ownable() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) onlyOwner public {
41         require(newOwner != address(0));
42         OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract ERC20 {
48     uint256 public totalSupply;
49     function balanceOf(address who) public view returns (uint256);
50     function transfer(address to, uint256 value) public returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     function allowance(address owner, address spender) public view returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract Pausable is Ownable {
60     event Paused();
61     event Unpaused();
62 
63     bool public pause = false;
64 
65     modifier whenNotPaused() {
66         require(!pause);
67         _;
68     }
69 
70     modifier whenPaused() {
71         require(pause);
72         _;
73     }
74 
75     function pause() onlyOwner whenNotPaused public {
76         pause = true;
77         Paused();
78     }
79 
80     function unpause() onlyOwner whenPaused public {
81         pause = false;
82         Unpaused();
83     }
84 }
85 
86 contract Freezable is Ownable {
87     mapping (address => bool) public frozenAccount;
88 
89     event Frozen(address indexed account, bool freeze);
90 
91     function freeze(address _acct) onlyOwner public {
92         frozenAccount[_acct] = true;
93         Frozen(_acct, true);
94     }
95 
96     function unfreeze(address _acct) onlyOwner public {
97         frozenAccount[_acct] = false;
98         Frozen(_acct, false);
99     }
100 }
101 
102 contract StandardToken is ERC20, Pausable, Freezable {
103     using SafeMath for uint256;
104 
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;
107 
108     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
109         require(_to != address(0));
110         require(_value > 0);
111         require(!frozenAccount[msg.sender]);
112 
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
120         require(_from != address(0));
121         require(_to != address(0));
122         require(!frozenAccount[_from]);
123 
124         uint256 _allowance = allowed[_from][msg.sender];
125 
126         balances[_from] = balances[_from].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         allowed[_from][msg.sender] = _allowance.sub(_value);
129         Transfer(_from, _to, _value);
130         return true;
131     }
132 
133     function balanceOf(address _owner) public constant returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137     function approve(address _spender, uint256 _value) public returns (bool) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146 }
147 
148 contract GAWToken is StandardToken {
149 
150     string public name = "Galaxy World Coin";
151     string public symbol = "GAW";
152     uint public decimals = 18;
153 
154     uint public constant TOTAL_SUPPLY    = 6000000000e18;
155     address public constant WALLET_GAW   = 0x0A97a0aC50386283288518908eC547e0471f8308; 
156 
157     mapping(address => uint256) public addressLocked;
158     mapping(address => uint256) public addressLockupDate;
159 
160     event UpdatedLockingState(address indexed to, uint256 value, uint256 date);
161 
162     modifier canTransfer(address _sender, uint256 _value) {
163         require(_sender != address(0));
164 
165         uint256 remaining = balances[_sender].sub(_value);
166         uint256 totalLockAmt = 0;
167 
168         if (addressLocked[_sender] > 0) {
169             totalLockAmt = totalLockAmt.add(getLockedAmount(_sender));
170         }
171 
172         require(remaining >= totalLockAmt);
173 
174         _;
175     }
176 
177     function GAWToken() public {
178         balances[msg.sender] = TOTAL_SUPPLY;
179         totalSupply = TOTAL_SUPPLY;
180 
181         transfer(WALLET_GAW, TOTAL_SUPPLY);
182     }
183 
184     function getLockedAmount(address _address)
185         public
186 		view
187 		returns (uint256)
188 	{
189         uint256 lockupDate = addressLockupDate[_address];
190         uint256 lockedAmt = addressLocked[_address];
191 
192 
193         uint256 diff = (now - lockupDate) / 2592000; // month diff
194         uint256 partition = 10;
195 
196         if (diff >= partition) 
197             return 0;
198         else
199             return lockedAmt.mul(partition-diff).div(partition);
200 	
201         return 0;
202     }
203 
204     function setLockup(address _address, uint256 _value, uint256 _lockupDate)
205         public
206         onlyOwner
207     {
208         require(_address != address(0));
209 
210         addressLocked[_address] = _value;
211         addressLockupDate[_address] = _lockupDate;
212         UpdatedLockingState(_address, _value, _lockupDate);
213     }
214 
215     function transfer(address _to, uint _value)
216         public
217         canTransfer(msg.sender, _value)
218 		returns (bool success)
219 	{
220         return super.transfer(_to, _value);
221     }
222 
223     function transferFrom(address _from, address _to, uint _value)
224         public
225         canTransfer(_from, _value)
226 		returns (bool success)
227 	{
228         return super.transferFrom(_from, _to, _value);
229     }
230 
231     function() payable public { }
232 
233     function withdrawEther() public {
234         if (address(this).balance > 0)
235 		    owner.send(address(this).balance);
236 	}
237 
238     function withdrawSelfToken() public {
239         if(balanceOf(this) > 0)
240             this.transfer(owner, balanceOf(this));
241     }
242 
243     function close() public onlyOwner {
244         selfdestruct(owner);
245     }
246 }