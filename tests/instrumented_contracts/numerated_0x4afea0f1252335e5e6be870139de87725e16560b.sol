1 pragma solidity ^0.4.22;
2 
3 //Math operations with safety checks that throw on error
4 
5 library SafeMath {
6 
7     //multiply
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13     //divide
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     //subtract
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     //addition
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 contract Ownable {
36     address public contractOwner;
37 
38     event TransferredOwnership(address indexed _previousOwner, address indexed _newOwner);
39 
40     constructor() public {        
41         contractOwner = msg.sender;
42     }
43 
44     modifier ownerOnly() {
45         require(msg.sender == contractOwner);
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) internal ownerOnly {
50         require(_newOwner != address(0));
51         contractOwner = _newOwner;
52 
53         emit TransferredOwnership(contractOwner, _newOwner);
54     }
55 
56 }
57 
58 // Natmin vesting contract for team members
59 contract NatminVesting is Ownable {
60     struct Vesting {        
61         uint256 amount;
62         uint256 endTime;
63     }
64     mapping(address => Vesting) internal vestings;
65 
66     function addVesting(address _user, uint256 _amount) public ;
67     function getVestedAmount(address _user) public view returns (uint256 _amount);
68     function getVestingEndTime(address _user) public view returns (uint256 _endTime);
69     function vestingEnded(address _user) public view returns (bool) ;
70     function endVesting(address _user) public ;
71 }
72 
73 //ERC20 Standard interface specification
74 contract ERC20Standard {
75     function balanceOf(address _user) public view returns (uint256 balance);
76     function transfer(address _to, uint256 _value) public returns (bool success);
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
78     function approve(address _spender, uint256 _value) public returns (bool success);
79     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
80     event Transfer(address indexed _from, address indexed _to, uint256 _value);
81     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
82 }
83 
84 //ERC223 Standard interface specification
85 contract ERC223Standard {
86     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
87     event Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);
88 }
89 
90 //ERC223 function to handle incoming token transfers
91 contract ERC223ReceivingContract { 
92     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
93         _from;
94         _value;
95         _data;
96     }
97 }
98 
99 contract BurnToken is Ownable {
100     using SafeMath for uint256;
101     
102     function burn(uint256 _value) public;
103     function _burn(address _user, uint256 _value) internal;
104     event Burn(address indexed _user, uint256 _value);
105 }
106 
107 //NatminToken implements the ERC20, ERC223 standard methods
108 contract NatminToken is ERC20Standard, ERC223Standard, Ownable, NatminVesting, BurnToken {
109     using SafeMath for uint256;
110 
111     string _name = "Natmin";
112     string _symbol = "NAT";
113     string _standard = "ERC20 / ERC223";
114     uint256 _decimals = 18; // same value as wei
115     uint256 _totalSupply;
116 
117     mapping(address => uint256) balances;
118     mapping(address => mapping(address => uint256)) allowed;
119 
120     constructor(uint256 _supply) public {
121         require(_supply != 0);
122         _totalSupply = _supply * (10 ** 18);
123         balances[contractOwner] = _totalSupply;
124     }
125 
126     // Returns the _name of the token
127     function name() public view returns (string) {
128         return _name;        
129     }
130 
131     // Returns the _symbol of the token
132     function symbol() public view returns (string) {
133         return _symbol;
134     }
135 
136     // Returns the _standard of the token
137     function standard() public view returns (string) {
138         return _standard;
139     }
140 
141     // Returns the _decimals of the token
142     function decimals() public view returns (uint256) {
143         return _decimals;
144     }
145 
146     // Function to return the total supply of the token
147     function totalSupply() public view returns (uint256) {
148         return _totalSupply;
149     }
150 
151     // Function to return the balance of a specified address
152     function balanceOf(address _user) public view returns (uint256 balance){
153         return balances[_user];
154     }   
155 
156     // Transfer function to be compatable with ERC20 Standard
157     function transfer(address _to, uint256 _value) public returns (bool success){
158         bytes memory _empty;
159         if(isContract(_to)){
160             return transferToContract(_to, _value, _empty);
161         }else{
162             return transferToAddress(_to, _value, _empty);
163         }
164     }
165 
166     // Transfer function to be compatable with ERC223 Standard
167     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
168         if(isContract(_to)){
169             return transferToContract(_to, _value, _data);
170         }else{
171             return transferToAddress(_to, _value, _data);
172         }
173     }
174 
175     // This function checks if the address is a contract or wallet
176     // If the codeLength is greater than 0, it is a contract
177     function isContract(address _to) internal view returns (bool) {
178         uint256 _codeLength;
179 
180         assembly {
181             _codeLength := extcodesize(_to)
182         }
183 
184         return _codeLength > 0;
185     }
186 
187     // This function to be used if the target is a contract address
188     function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool) {
189         require(balances[msg.sender] >= _value);
190         require(vestingEnded(msg.sender));
191         
192         // This will override settings and allow contract owner to send to contract
193         if(msg.sender != contractOwner){
194             ERC223ReceivingContract _tokenReceiver = ERC223ReceivingContract(_to);
195             _tokenReceiver.tokenFallback(msg.sender, _value, _data);
196         }
197 
198         balances[msg.sender] = balances[msg.sender].sub(_value);
199         balances[_to] = balances[_to].add(_value);
200 
201         emit Transfer(msg.sender, _to, _value);
202         emit Transfer(msg.sender, _to, _value, _data);
203         return true;
204     }
205 
206     // This function to be used if the target is a normal eth/wallet address 
207     function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool) {
208         require(balances[msg.sender] >= _value);
209         require(vestingEnded(msg.sender));
210 
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213 
214         emit Transfer(msg.sender, _to, _value);
215         emit Transfer(msg.sender, _to, _value, _data);
216         return true;
217     }
218 
219     // ERC20 standard function
220     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
221         require(_value <= allowed[_from][msg.sender]);
222         require(_value <= balances[_from]);
223         require(vestingEnded(_from));
224 
225         balances[_from] = balances[_from].sub(_value);
226         balances[_to] = balances[_to].add(_value);
227         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228 
229         emit Transfer(_from, _to, _value);
230 
231         return true;
232     }
233 
234     // ERC20 standard function
235     function approve(address _spender, uint256 _value) public returns (bool success){
236         allowed[msg.sender][_spender] = 0;
237         allowed[msg.sender][_spender] = _value;
238 
239         emit Approval(msg.sender, _spender, _value);
240 
241         return true;
242     }
243 
244     // ERC20 standard function
245     function allowance(address _owner, address _spender) public view returns (uint256 remaining){
246         return allowed[_owner][_spender];
247     }
248 
249     // Stops any attempt from sending Ether to this contract
250     function () public {
251         revert();
252     }
253 
254     // public function to call the _burn function 
255     function burn(uint256 _value) public ownerOnly {
256         _burn(msg.sender, _value);
257     }
258 
259     // Burn the specified amount of tokens by the owner
260     function _burn(address _user, uint256 _value) internal ownerOnly {
261         require(balances[_user] >= _value);
262 
263         balances[_user] = balances[_user].sub(_value);
264         _totalSupply = _totalSupply.sub(_value);
265         
266         emit Burn(_user, _value);
267         emit Transfer(_user, address(0), _value);
268 
269         bytes memory _empty;
270         emit Transfer(_user, address(0), _value, _empty);
271     }
272 
273     // Create a vesting entry for the specified user
274     function addVesting(address _user, uint256 _amount) public ownerOnly {
275         vestings[_user].amount = _amount;
276         vestings[_user].endTime = now + 180 days;
277     }
278 
279     // Returns the vested amount for a specified user
280     function getVestedAmount(address _user) public view returns (uint256 _amount) {
281         _amount = vestings[_user].amount;
282         return _amount;
283     }
284 
285     // Returns the vested end time for a specified user
286     function getVestingEndTime(address _user) public view returns (uint256 _endTime) {
287         _endTime = vestings[_user].endTime;
288         return _endTime;
289     }
290 
291     // Checks if the venting period is over for a specified user
292     function vestingEnded(address _user) public view returns (bool) {
293         if(vestings[_user].endTime <= now) {
294             return true;
295         }
296         else {
297             return false;
298         }
299     }
300 
301     // Manual end vested time 
302     function endVesting(address _user) public ownerOnly {
303         vestings[_user].endTime = now;
304     }
305 }