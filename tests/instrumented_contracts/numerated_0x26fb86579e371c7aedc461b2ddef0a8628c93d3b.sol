1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 
31 contract Ownable {
32     address public owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     function Ownable() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) public onlyOwner {
46         require(newOwner != address(0));
47         OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 }
51 
52 contract Pausable is Ownable {
53     event Pause();
54     event Unpause();
55 
56     bool public paused = false;
57 
58     modifier whenNotPaused() {
59         require(!paused);
60         _;
61     }
62 
63     modifier whenPaused() {
64         require(paused);
65         _;
66     }
67 
68     function pause() onlyOwner whenNotPaused public {
69         paused = true;
70         Pause();
71     }
72 
73     function unpause() onlyOwner whenPaused public {
74         paused = false;
75         Unpause();
76     }
77 }
78 
79 contract ERC20Basic {
80     function totalSupply() public view returns (uint256);
81     function balanceOf(address who) public view returns (uint256);
82     function transfer(address to, uint256 value) public returns (bool);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 contract ERC20 is ERC20Basic {
87     function allowance(address owner, address spender) public view returns (uint256);
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89     function approve(address spender, uint256 value) public returns (bool);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 contract BasicToken is ERC20Basic {
94     using SafeMath for uint256;
95     mapping(address => uint256) balances;
96     uint256 totalSupply_;
97 
98     function totalSupply() public view returns (uint256) {
99         return totalSupply_;
100     }
101 
102     function transfer(address _to, uint256 _value) public returns (bool) {
103         require(_to != address(0));
104         require(_value <= balances[msg.sender]);
105 
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         Transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112     function balanceOf(address _owner) public view returns (uint256 balance) {
113         return balances[_owner];
114     }
115 }
116 
117 contract StandardToken is ERC20, BasicToken {
118     mapping (address => mapping (address => uint256)) internal allowed;
119 
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121         require(_to != address(0));
122         require(_value <= balances[_from]);
123         require(_value <= allowed[_from][msg.sender]);
124 
125         balances[_from] = balances[_from].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128         Transfer(_from, _to, _value);
129         return true;
130     }
131 
132     function approve(address _spender, uint256 _value) public returns (bool) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     function allowance(address _owner, address _spender) public view returns (uint256) {
139         return allowed[_owner][_spender];
140     }
141 
142     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
143         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
144         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145         return true;
146     }
147 
148     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
149         uint oldValue = allowed[msg.sender][_spender];
150         if (_subtractedValue > oldValue) {
151             allowed[msg.sender][_spender] = 0;
152         } else {
153             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
154         }
155         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156         return true;
157     }
158 }
159 
160 contract PausableToken is StandardToken, Pausable {
161     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
162         return super.transfer(_to, _value);
163     }
164 
165     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
166         return super.transferFrom(_from, _to, _value);
167     }
168 
169     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
170         return super.approve(_spender, _value);
171     }
172 
173     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
174         return super.increaseApproval(_spender, _addedValue);
175     }
176 
177     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
178         return super.decreaseApproval(_spender, _subtractedValue);
179     }
180 }
181 
182 contract BoraToken is PausableToken {
183     string public name;
184     string public symbol;
185     uint8 public decimals;
186 
187     event Burn(address to, uint256 amount, uint256 totalSupply);
188     event Lock(address token, address beneficiary, uint256 amount, uint256 releaseTime);
189 
190     function BoraToken(uint256 _supply) public {
191         require(_supply != 0);
192         balances[msg.sender] = _supply;
193         totalSupply_ = _supply;
194         name = 'BORA';
195         symbol = 'BORA';
196         decimals = 18;
197         Transfer(address(0), msg.sender, _supply);
198     }
199 
200     function lock(address _donor, address _beneficiary, uint256 amount, uint256 _duration, bool _revocable) onlyOwner public returns (LockedToken) {
201         uint256 releaseTime = now.add(_duration.mul(1 days));
202         LockedToken lockedToken = new LockedToken(this, _donor, _beneficiary, releaseTime, _revocable);
203         BasicToken.transfer(lockedToken, amount);
204         Lock(lockedToken, _beneficiary, lockedToken.balanceOf(), releaseTime);
205         return lockedToken;
206     }
207 
208     function burn(uint256 _amount) onlyOwner public {
209         require(_amount <= balances[msg.sender]);
210         balances[msg.sender] = balances[msg.sender].sub(_amount);
211         totalSupply_ = totalSupply_.sub(_amount);
212         Burn(msg.sender, _amount, totalSupply_);
213         Transfer(msg.sender, address(0), _amount);
214     }
215 }
216 
217 
218 contract LockedToken {
219     ERC20Basic public token;
220     address public donor;
221     address public beneficiary;
222     uint256 public releaseTime;
223     bool public revocable;
224 
225     event Claim(address beneficiary, uint256 amount, uint256 releaseTime);
226     event Revoke(address donor, uint256 amount);
227 
228     function LockedToken(ERC20Basic _token, address _donor, address _beneficiary, uint256 _releaseTime, bool _revocable) public {
229         require(_token != address(0));
230         require(_donor != address(0));
231         require(_beneficiary != address(0));
232         require(_releaseTime > now);
233 
234         token = ERC20Basic(_token);
235         donor = _donor;
236         beneficiary = _beneficiary;
237         releaseTime = _releaseTime;
238         revocable = _revocable;
239     }
240 
241     function balanceOf() public view returns (uint256) {
242         return token.balanceOf(this);
243     }
244 
245     function revoke() public {
246         require(revocable);
247         require(msg.sender == donor);
248 
249         uint amount = token.balanceOf(this);
250         require(amount > 0);
251         token.transfer(donor, amount);
252         Revoke(donor, amount);
253     }
254 
255     function claim() public {
256         require(now >= releaseTime);
257 
258         uint amount = token.balanceOf(this);
259         require(amount > 0);
260         token.transfer(beneficiary, amount);
261         Claim(beneficiary, amount, releaseTime);
262     }
263 }