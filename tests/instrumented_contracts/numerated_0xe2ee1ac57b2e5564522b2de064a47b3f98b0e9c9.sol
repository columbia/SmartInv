1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b > 0);
16         uint256 c = a / b;
17         assert(a == b * c + a % b);
18         return a / b;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Ownable {
34     address public owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     constructor () public {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     function transferOwnership(address newOwner) public onlyOwner {
48         require(newOwner != address(0));
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51     }
52 }
53 
54 contract Pausable is Ownable {
55     event Pause();
56     event Unpause();
57 
58     bool public paused = false;
59 
60     modifier whenNotPaused() {
61         require(!paused);
62         _;
63     }
64 
65     modifier whenPaused() {
66         require(paused);
67         _;
68     }
69 
70     function pause() onlyOwner whenNotPaused public {
71         paused = true;
72         emit Pause();
73     }
74 
75     function unpause() onlyOwner whenPaused public {
76         paused = false;
77         emit Unpause();
78     }
79 }
80 
81 contract ERC20Basic {
82     function totalSupply() public view returns (uint256);
83     function balanceOf(address who) public view returns (uint256);
84     function transfer(address to, uint256 value) public returns (bool);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 contract BasicToken is ERC20Basic {
89     using SafeMath for uint256;
90 
91     mapping(address => uint256) balances;
92     uint256 totalSupply_;
93 
94     function totalSupply() public view returns (uint256) {
95         return totalSupply_;
96     }
97 
98     function transfer(address _to, uint256 _value) public returns (bool) {
99         require(_to != address(0));
100         require(_value <= balances[msg.sender]);
101 
102         balances[msg.sender] = balances[msg.sender].sub(_value);
103         balances[_to] = balances[_to].add(_value);
104         emit Transfer(msg.sender, _to, _value);
105         return true;
106     }
107 
108     function balanceOf(address _owner) public view returns (uint256 balance) {
109         return balances[_owner];
110     }
111 }
112 
113 contract ERC20 is ERC20Basic {
114     function allowance(address owner, address spender) public view returns (uint256);
115     function transferFrom(address from, address to, uint256 value) public returns (bool);
116     function approve(address spender, uint256 value) public returns (bool);
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 contract StandardToken is ERC20, BasicToken {
121 
122     mapping (address => mapping (address => uint256)) internal allowed;
123 
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125         require(_to != address(0));
126         require(_value <= balances[_from]);
127         require(_value <= allowed[_from][msg.sender]);
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131         emit Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     function approve(address _spender, uint256 _value) public returns (bool) {
136         allowed[msg.sender][_spender] = _value;
137         emit Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     function allowance(address _owner, address _spender) public view returns (uint256) {
142         return allowed[_owner][_spender];
143     }
144 
145     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
146         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
147         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148         return true;
149     }
150 
151     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
152         uint oldValue = allowed[msg.sender][_spender];
153         if (_subtractedValue > oldValue) {
154             allowed[msg.sender][_spender] = 0;
155         } else {
156             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
157         }
158         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159         return true;
160     }
161 }
162 
163 contract BurnableToken is BasicToken, Ownable {
164 
165     event Burn(address indexed burner, uint256 value);
166 
167     function burn(uint256 _value) public {
168         _burn(msg.sender, _value);
169     }
170 
171     function _burn(address _who, uint256 _value) internal {
172         require(_value <= balances[_who]);
173         balances[_who] = balances[_who].sub(_value);
174         totalSupply_ = totalSupply_.sub(_value);
175         emit Burn(_who, _value);
176         emit Transfer(_who, address(0), _value);
177     }
178 }
179 
180 contract WhalesburgToken is StandardToken, BurnableToken, Pausable {
181 
182     using SafeMath for uint256;
183 
184     string  public name = "WhalesburgToken";
185     string  public symbol = "WBT";
186     uint256 constant public decimals = 18;
187     uint256 constant dec = 10**decimals;
188     uint256 public initialSupply = 100000000*dec;
189     uint256 public availableSupply;
190     address public crowdsaleAddress;
191 
192     modifier onlyICO() {
193         require(msg.sender == crowdsaleAddress);
194         _;
195     }
196 
197     constructor ( ) public {
198         totalSupply_ = totalSupply_.add(initialSupply);
199         balances[owner] = balances[owner].add(initialSupply);
200         availableSupply = totalSupply_;
201         emit Transfer(address(0x0), owner, initialSupply);
202     }
203 
204     function setSaleAddress(address _saleaddress) public onlyOwner{
205         crowdsaleAddress = _saleaddress;
206     }
207 
208     function transferFromICO(address _to, uint256 _value) public onlyICO returns(bool) {
209         return super.transfer(_to, _value);
210     }
211 
212     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
213         return super.transfer(_to, _value);
214     }
215 
216     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
217         return super.transferFrom(_from, _to, _value);
218     }
219 
220     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
221         return super.approve(_spender, _value);
222     }
223 
224     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
225         return super.increaseApproval(_spender, _addedValue);
226     }
227 
228     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
229         return super.decreaseApproval(_spender, _subtractedValue);
230     }
231 }