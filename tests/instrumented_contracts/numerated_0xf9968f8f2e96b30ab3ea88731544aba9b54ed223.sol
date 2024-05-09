1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
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
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         // uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return a / b;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipRenounced(address indexed previousOwner);
38   event OwnershipTransferred(
39     address indexed previousOwner,
40     address indexed newOwner
41   );
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   constructor() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to relinquish control of the contract.
62    * @notice Renouncing to ownership will leave the contract without an owner.
63    * It will not be possible to call the functions with the `onlyOwner`
64    * modifier anymore.
65    */
66   function renounceOwnership() public onlyOwner {
67     emit OwnershipRenounced(owner);
68     owner = address(0);
69   }
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param _newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address _newOwner) public onlyOwner {
76     _transferOwnership(_newOwner);
77   }
78 
79   /**
80    * @dev Transfers control of the contract to a newOwner.
81    * @param _newOwner The address to transfer ownership to.
82    */
83   function _transferOwnership(address _newOwner) internal {
84     require(_newOwner != address(0));
85     emit OwnershipTransferred(owner, _newOwner);
86     owner = _newOwner;
87   }
88 }
89 
90 contract Pausable is Ownable {
91 
92     event Pause();
93     event Unpause();
94 
95     bool public paused = false;
96 
97     modifier whenNotPaused() {
98         require(!paused);
99         _;
100     }
101 
102     modifier whenPaused() {
103         require(paused);
104         _;
105     }
106 
107     function pause() onlyOwner whenNotPaused public {
108         paused = true;
109         emit Pause();
110     }
111 
112     function unpause() onlyOwner whenPaused public {
113         paused = false;
114         emit Unpause();
115     }
116 }
117 
118 contract ERC20Basic {
119     function totalSupply() public view returns (uint256);
120     // function totalSupply() view returns (uint256 totalSupply) EIP
121     function balanceOf(address who) public view returns (uint256);
122     // function balanceOf(address _owner) view returns (uint256 balance) EIP
123     function transfer(address to, uint256 value) public returns (bool);
124     // function transfer(address _to, uint256 _value) returns (bool success) EIP
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 contract BasicToken is ERC20Basic {
129     using SafeMath for uint256;
130 
131     mapping(address => uint256) balances;
132 
133     uint256 totalSupply_;
134 
135     function totalSupply() public view returns (uint256) {
136         // function totalSupply() view returns (uint256 totalSupply) EIP
137         return totalSupply_;
138     }
139 
140     function transfer(address _to, uint256 _value) public returns (bool) {
141         // function transfer(address _to, uint256 _value) returns (bool success) EIP
142         require(_to != address(0));
143         require(_value <= balances[msg.sender]);
144 
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         emit Transfer(msg.sender, _to, _value);
148         return true;
149     }
150 
151     function balanceOf(address _owner) public view returns (uint256) {
152         // function balanceOf(address _owner) view returns (uint256 balance) EIP
153         return balances[_owner];
154     }
155 }
156 
157 contract ERC20 is ERC20Basic {
158     function allowance(address owner, address spender)
159     public view returns (uint256);
160 
161     function transferFrom(address from, address to, uint256 value)
162     public returns (bool);
163 
164     function approve(address spender, uint256 value) public returns (bool);
165     event Approval(
166         address indexed owner,
167         address indexed spender,
168         uint256 value
169     );
170 }
171 
172 contract StandardToken is ERC20, BasicToken {
173 
174     mapping (address => mapping (address => uint256)) internal allowed;
175 
176     function transferFrom(
177         address _from,
178         address _to,
179         uint256 _value
180     ) public returns (bool)
181     {
182         require(_to != address(0));
183         require(_value <= balances[_from]);
184         require(_value <= allowed[_from][msg.sender]);
185 
186         balances[_from] = balances[_from].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189         emit Transfer(_from, _to, _value);
190         return true;
191     }
192 
193     function approve(address _spender, uint256 _value) public returns (bool) {
194         allowed[msg.sender][_spender] = _value;
195         emit Approval(msg.sender, _spender, _value);
196         return true;
197     }
198 
199     function allowance(
200         address _owner,
201         address _spender
202     ) public view returns (uint256)
203     {
204         return allowed[_owner][_spender];
205     }
206 
207     function increaseApproval(
208         address _spender,
209         uint _addedValue
210     ) public returns (bool)
211     {
212         allowed[msg.sender][_spender] = (
213         allowed[msg.sender][_spender].add(_addedValue));
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218     function decreaseApproval(
219         address _spender,
220         uint _subtractedValue
221     ) public returns (bool)
222     {
223         uint oldValue = allowed[msg.sender][_spender];
224         if (_subtractedValue > oldValue) {
225             allowed[msg.sender][_spender] = 0;
226         } else {
227             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
228         }
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 }
233 /************* BN Token Contract **************/
234 contract BNToken is StandardToken, Pausable {
235 
236     using SafeMath for uint256;
237 
238     string  public name = "BN";
239     string  public symbol = "BN";
240     uint256 constant public decimals = 18;
241     uint256 constant dec = 10**decimals;
242     uint256 public initialSupply = 50000*dec;
243     uint256 public availableSupply;
244     address public crowdsaleAddress;
245 
246     modifier onlyICO() {
247         require(msg.sender == crowdsaleAddress);
248         _;
249     }
250 
251     constructor() public {
252         totalSupply_ = totalSupply_.add(initialSupply);
253         balances[owner] = balances[owner].add(initialSupply);
254         availableSupply = totalSupply_;
255         emit Transfer(address(0x0), this, initialSupply);
256     }
257 
258     function setSaleAddress(address _saleaddress) public onlyOwner{
259         crowdsaleAddress = _saleaddress;
260     }
261 
262     function transferFromICO(address _to, uint256 _value) public onlyICO returns(bool) {
263         require(_to != address(0x0));
264         return super.transfer(_to, _value);
265     }
266 
267     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
268         return super.transfer(_to, _value);
269     }
270 
271     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
272         return super.transferFrom(_from, _to, _value);
273     }
274 
275     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
276         return super.approve(_spender, _value);
277     }
278 
279     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
280         return super.increaseApproval(_spender, _addedValue);
281     }
282 
283     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
284         return super.decreaseApproval(_spender, _subtractedValue);
285     }
286 }