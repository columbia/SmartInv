1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract ERC20Basic {
85   function totalSupply() public view returns (uint256);
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public view returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 contract ACAToken is ERC20 {
99     using SafeMath for uint256;
100 
101     address public owner;
102     address public admin;
103     address public saleAddress;
104 
105     string public name = "ACA Network Token";
106     string public symbol = "ACA";
107     uint8 public decimals = 18;
108 
109     uint256 totalSupply_;
110     mapping (address => mapping (address => uint256)) internal allowed;
111     mapping (address => uint256) balances;
112 
113     bool transferable = false;
114     mapping (address => bool) internal transferLocked;
115 
116     event Genesis(address owner, uint256 value);
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
119     event Burn(address indexed burner, uint256 value);
120     event LogAddress(address indexed addr);
121     event LogUint256(uint256 value);
122     event TransferLock(address indexed target, bool value);
123 
124     // modifiers
125     modifier onlyOwner() {
126         require(msg.sender == owner);
127         _;
128     }
129 
130     modifier onlyAdmin() {
131         require(msg.sender == owner || msg.sender == admin);
132         _;
133     }
134 
135     modifier canTransfer(address _from, address _to) {
136         require(_to != address(0x0));
137         require(_to != address(this));
138 
139         if ( _from != owner && _from != admin ) {
140             require(transferable);
141             require (!transferLocked[_from]);
142         }
143         _;
144     }
145 
146     // constructor
147     function ACAToken(uint256 _totalSupply, address _saleAddress, address _admin) public {
148         require(_totalSupply > 0);
149         owner = msg.sender;
150         require(_saleAddress != address(0x0));
151         require(_saleAddress != address(this));
152         require(_saleAddress != owner);
153 
154         require(_admin != address(0x0));
155         require(_admin != address(this));
156         require(_admin != owner);
157 
158         require(_admin != _saleAddress);
159 
160         admin = _admin;
161         saleAddress = _saleAddress;
162 
163         totalSupply_ = _totalSupply;
164 
165         balances[owner] = totalSupply_;
166         approve(saleAddress, totalSupply_);
167 
168         emit Genesis(owner, totalSupply_);
169     }
170 
171     // permission related
172     function transferOwnership(address newOwner) public onlyOwner {
173         require(newOwner != address(0));
174         require(newOwner != address(this));
175         require(newOwner != admin);
176 
177         owner = newOwner;
178         emit OwnershipTransferred(owner, newOwner);
179     }
180 
181     function transferAdmin(address _newAdmin) public onlyOwner {
182         require(_newAdmin != address(0));
183         require(_newAdmin != address(this));
184         require(_newAdmin != owner);
185 
186         admin = _newAdmin;
187         emit AdminTransferred(admin, _newAdmin);
188     }
189 
190     function setTransferable(bool _transferable) public onlyAdmin {
191         transferable = _transferable;
192     }
193 
194     function isTransferable() public view returns (bool) {
195         return transferable;
196     }
197 
198     function transferLock() public returns (bool) {
199         transferLocked[msg.sender] = true;
200         emit TransferLock(msg.sender, true);
201         return true;
202     }
203 
204     function manageTransferLock(address _target, bool _value) public onlyAdmin returns (bool) {
205         transferLocked[_target] = _value;
206         emit TransferLock(_target, _value);
207         return true;
208     }
209 
210     function transferAllowed(address _target) public view returns (bool) {
211         return (transferable && transferLocked[_target] == false);
212     }
213 
214     // token related
215     function totalSupply() public view returns (uint256) {
216         return totalSupply_;
217     }
218 
219     function transfer(address _to, uint256 _value) canTransfer(msg.sender, _to) public returns (bool) {
220         require(_value <= balances[msg.sender]);
221 
222         // SafeMath.sub will throw if there is not enough balance.
223         balances[msg.sender] = balances[msg.sender].sub(_value);
224         balances[_to] = balances[_to].add(_value);
225         emit Transfer(msg.sender, _to, _value);
226         return true;
227     }
228 
229     function balanceOf(address _owner) public view returns (uint256 balance) {
230         return balances[_owner];
231     }
232 
233     function balanceOfOwner() public view returns (uint256 balance) {
234         return balances[owner];
235     }
236 
237     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
238         require(_value <= balances[_from]);
239         require(_value <= allowed[_from][msg.sender]);
240 
241         balances[_from] = balances[_from].sub(_value);
242         balances[_to] = balances[_to].add(_value);
243         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
244         emit Transfer(_from, _to, _value);
245         return true;
246     }
247 
248     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {
249         allowed[msg.sender][_spender] = _value;
250         emit Approval(msg.sender, _spender, _value);
251         return true;
252     }
253 
254     function allowance(address _owner, address _spender) public view returns (uint256) {
255         return allowed[_owner][_spender];
256     }
257 
258     function increaseApproval(address _spender, uint _addedValue) public canTransfer(msg.sender, _spender) returns (bool) {
259         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
260         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261         return true;
262     }
263 
264     function decreaseApproval(address _spender, uint _subtractedValue) public canTransfer(msg.sender, _spender) returns (bool) {
265         uint oldValue = allowed[msg.sender][_spender];
266         if (_subtractedValue > oldValue) {
267             allowed[msg.sender][_spender] = 0;
268         } else {
269             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270         }
271         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272         return true;
273     }
274 
275     function burn(uint256 _value) public {
276         require(_value <= balances[msg.sender]);
277         // no need to require value <= totalSupply, since that would imply the
278         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
279 
280         address burner = msg.sender;
281         balances[burner] = balances[burner].sub(_value);
282         totalSupply_ = totalSupply_.sub(_value);
283         emit Burn(burner, _value);
284     }
285 
286     function emergencyERC20Drain(ERC20 _token, uint256 _amount) public onlyOwner {
287         _token.transfer(owner, _amount);
288     }
289 }