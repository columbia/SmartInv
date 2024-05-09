1 pragma solidity ^0.4.23;
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
58 // Lucre vesting contract for team members
59 contract LucreVesting is Ownable {
60     struct Vesting {        
61         uint256 amount;
62         uint256 endTime;
63     }
64     mapping(address => Vesting) internal vestings;
65 
66     function addVesting(address _user, uint256 _amount, uint256 _endTime) public ;
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
92     function tokenFallback(address _from, uint256 _value, bytes _data) public;
93 }
94 
95 contract BurnToken is Ownable {
96     using SafeMath for uint256;
97     
98     function burn(uint256 _value) public;
99     function _burn(address _user, uint256 _value) internal;
100     event Burn(address indexed _user, uint256 _value);
101 }
102 
103 //LucreToken implements the ERC20, ERC223 standard methods
104 contract LucreToken is ERC20Standard, ERC223Standard, Ownable, LucreVesting, BurnToken {
105     using SafeMath for uint256;
106 
107     string _name = "LUCRE TOKEN";
108     string _symbol = "LCRT";
109     string _standard = "ERC20 / ERC223";
110     uint256 _decimals = 18; // same value as wei
111     uint256 _totalSupply;
112 
113     mapping(address => uint256) balances;
114     mapping(address => mapping(address => uint256)) allowed;
115 
116     constructor(uint256 _supply) public {
117         require(_supply != 0);
118         _totalSupply = _supply * (10 ** 18);
119         balances[contractOwner] = _totalSupply;
120     }
121 
122     // Returns the _name of the token
123     function name() public view returns (string) {
124         return _name;        
125     }
126 
127     // Returns the _symbol of the token
128     function symbol() public view returns (string) {
129         return _symbol;
130     }
131 
132     // Returns the _standard of the token
133     function standard() public view returns (string) {
134         return _standard;
135     }
136 
137     // Returns the _decimals of the token
138     function decimals() public view returns (uint256) {
139         return _decimals;
140     }
141 
142     // Function to return the total supply of the token
143     function totalSupply() public view returns (uint256) {
144         return _totalSupply;
145     }
146 
147     // Function to return the balance of a specified address
148     function balanceOf(address _user) public view returns (uint256 balance){
149         return balances[_user];
150     }   
151 
152     // Transfer function to be compatible with ERC20 Standard
153     function transfer(address _to, uint256 _value) public returns (bool success){
154         require(_to != 0x0);
155         bytes memory _empty;
156         if(isContract(_to)){
157             return transferToContract(_to, _value, _empty);
158         }else{
159             return transferToAddress(_to, _value, _empty);
160         }
161     }
162 
163     // Transfer function to be compatible with ERC223 Standard
164     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
165         require(_to != 0x0);
166         if(isContract(_to)){
167             return transferToContract(_to, _value, _data);
168         }else{
169             return transferToAddress(_to, _value, _data);
170         }
171     }
172 
173     // This function checks if the address is a contract or wallet
174     // If the codeLength is greater than 0, it is a contract
175     function isContract(address _to) internal view returns (bool) {
176         uint256 _codeLength;
177 
178         assembly {
179             _codeLength := extcodesize(_to)
180         }
181 
182         return _codeLength > 0;
183     }
184 
185     // This function to be used if the target is a contract address
186     function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool) {
187         require(balances[msg.sender] >= _value);
188         require(validateTransferAmount(msg.sender,_value));
189         
190         balances[msg.sender] = balances[msg.sender].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192 
193         ERC223ReceivingContract _tokenReceiver = ERC223ReceivingContract(_to);
194         _tokenReceiver.tokenFallback(msg.sender, _value, _data);
195 
196         emit Transfer(msg.sender, _to, _value);
197         emit Transfer(msg.sender, _to, _value, _data);
198         return true;
199     }
200 
201     // This function to be used if the target is a normal eth/wallet address 
202     function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool) {
203         require(balances[msg.sender] >= _value);
204         require(validateTransferAmount(msg.sender,_value));
205 
206         balances[msg.sender] = balances[msg.sender].sub(_value);
207         balances[_to] = balances[_to].add(_value);
208 
209         emit Transfer(msg.sender, _to, _value);
210         emit Transfer(msg.sender, _to, _value, _data);
211         return true;
212     }
213 
214     // ERC20 standard function
215     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
216         require(_to != 0x0);
217         require(_value <= allowed[_from][msg.sender]);
218         require(_value <= balances[_from]);
219         require(validateTransferAmount(_from,_value));
220 
221         balances[_from] = balances[_from].sub(_value);
222         balances[_to] = balances[_to].add(_value);
223         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224 
225         emit Transfer(_from, _to, _value);
226 
227         return true;
228     }
229 
230     // ERC20 standard function
231     function approve(address _spender, uint256 _value) public returns (bool success){
232         allowed[msg.sender][_spender] = 0;
233         allowed[msg.sender][_spender] = _value;
234 
235         emit Approval(msg.sender, _spender, _value);
236 
237         return true;
238     }
239 
240     // ERC20 standard function
241     function allowance(address _owner, address _spender) public view returns (uint256 remaining){
242         return allowed[_owner][_spender];
243     }
244 
245     // Stops any attempt from sending Ether to this contract
246     function () public {
247         revert();
248     }
249 
250     // public function to call the _burn function 
251     function burn(uint256 _value) public ownerOnly {
252         _burn(msg.sender, _value);
253     }
254 
255     // Burn the specified amount of tokens by the owner
256     function _burn(address _user, uint256 _value) internal ownerOnly {
257         require(balances[_user] >= _value);
258 
259         balances[_user] = balances[_user].sub(_value);
260         _totalSupply = _totalSupply.sub(_value);
261         
262         emit Burn(_user, _value);
263         emit Transfer(_user, address(0), _value);
264 
265         bytes memory _empty;
266         emit Transfer(_user, address(0), _value, _empty);
267     }
268 
269     // Create a vesting entry for the specified user
270     function addVesting(address _user, uint256 _amount, uint256 _endTime) public ownerOnly {
271         vestings[_user].amount = _amount;
272         vestings[_user].endTime = _endTime;
273     }
274 
275     // Returns the vested amount for a specified user
276     function getVestedAmount(address _user) public view returns (uint256 _amount) {
277         _amount = vestings[_user].amount;
278         return _amount;
279     }
280 
281     // Returns the vested end time for a specified user
282     function getVestingEndTime(address _user) public view returns (uint256 _endTime) {
283         _endTime = vestings[_user].endTime;
284         return _endTime;
285     }
286 
287     // Checks if the venting period is over for a specified user
288     function vestingEnded(address _user) public view returns (bool) {
289         if(vestings[_user].endTime <= now) {
290             return true;
291         }
292         else {
293             return false;
294         }
295     }
296 
297     // This function checks the transfer amount against the current balance and vested amount
298     // Returns true if transfer amount is smaller than the difference between the balance and vested amount
299     function validateTransferAmount(address _user, uint256 _amount) internal view returns (bool) {
300         if(vestingEnded(_user)){
301             return true;
302         }else{
303             uint256 _vestedAmount = getVestedAmount(_user);
304             uint256 _currentBalance = balanceOf(_user);
305             uint256 _availableBalance = _currentBalance.sub(_vestedAmount);
306 
307             if(_amount <= _availableBalance) {
308                 return true;
309             }else{
310                 return false;
311             }
312         }
313     }
314 
315     // Manual end vested time 
316     function endVesting(address _user) public ownerOnly {
317         vestings[_user].endTime = now;
318     }
319 }