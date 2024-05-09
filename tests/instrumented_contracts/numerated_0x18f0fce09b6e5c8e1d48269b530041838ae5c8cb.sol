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
103 
104     string public name = "ACA Network Token";
105     string public symbol = "ACA";
106     uint8 public decimals = 18;
107 
108     uint256 totalSupply_;
109     mapping (address => mapping (address => uint256)) internal allowed;
110     mapping (address => uint256) balances;
111 
112     bool transferable = false;
113     mapping (address => bool) internal transferLocked;
114 
115     event Genesis(address owner, uint256 value);
116     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
117     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
118     event Burn(address indexed burner, uint256 value);
119     event LogAddress(address indexed addr);
120     event LogUint256(uint256 value);
121     event TransferLock(address indexed target, bool value);
122 
123     // modifiers
124     modifier onlyOwner() {
125         require(msg.sender == owner);
126         _;
127     }
128 
129     modifier onlyAdmin() {
130         require(msg.sender == owner || msg.sender == admin);
131         _;
132     }
133 
134     modifier canTransfer(address _from, address _to) {
135         require(_to != address(0x0));
136         require(_to != address(this));
137 
138         if ( _from != owner && _from != admin ) {
139             require(transferable);
140             require (!transferLocked[_from]);
141         }
142         _;
143     }
144 
145     // constructor
146     function ACAToken(uint256 _totalSupply, address _newAdmin) public {
147         require(_totalSupply > 0);
148         require(_newAdmin != address(0x0));
149         require(_newAdmin != msg.sender);
150 
151         owner = msg.sender;
152         admin = _newAdmin;
153 
154         totalSupply_ = _totalSupply;
155 
156         balances[owner] = totalSupply_;
157         approve(admin, totalSupply_);
158         emit Genesis(owner, totalSupply_);
159     }
160 
161     // permission related
162     function transferOwnership(address newOwner) public onlyOwner {
163         require(newOwner != address(0));
164         require(newOwner != admin);
165 
166         owner = newOwner;
167         emit OwnershipTransferred(owner, newOwner);
168     }
169 
170     function transferAdmin(address _newAdmin) public onlyOwner {
171         require(_newAdmin != address(0));
172         require(_newAdmin != address(this));
173         require(_newAdmin != owner);
174 
175         admin = _newAdmin;
176         emit AdminTransferred(admin, _newAdmin);
177     }
178 
179     function setTransferable(bool _transferable) public onlyAdmin {
180         transferable = _transferable;
181     }
182 
183     function isTransferable() public view returns (bool) {
184         return transferable;
185     }
186 
187     function transferLock() public returns (bool) {
188         transferLocked[msg.sender] = true;
189         emit TransferLock(msg.sender, true);
190         return true;
191     }
192 
193     function manageTransferLock(address _target, bool _value) public onlyOwner returns (bool) {
194         transferLocked[_target] = _value;
195         emit TransferLock(_target, _value);
196         return true;
197     }
198 
199     function transferAllowed(address _target) public view returns (bool) {
200         return (transferable && transferLocked[_target] == false);
201     }
202 
203     // token related
204     function totalSupply() public view returns (uint256) {
205         return totalSupply_;
206     }
207 
208     function transfer(address _to, uint256 _value) canTransfer(msg.sender, _to) public returns (bool) {
209         require(_value <= balances[msg.sender]);
210 
211         // SafeMath.sub will throw if there is not enough balance.
212         balances[msg.sender] = balances[msg.sender].sub(_value);
213         balances[_to] = balances[_to].add(_value);
214         emit Transfer(msg.sender, _to, _value);
215         return true;
216     }
217 
218     function balanceOf(address _owner) public view returns (uint256 balance) {
219         return balances[_owner];
220     }
221 
222     function balanceOfOwner() public view returns (uint256 balance) {
223         return balances[owner];
224     }
225 
226     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
227         require(_value <= balances[_from]);
228         require(_value <= allowed[_from][msg.sender]);
229 
230         balances[_from] = balances[_from].sub(_value);
231         balances[_to] = balances[_to].add(_value);
232         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233         emit Transfer(_from, _to, _value);
234         return true;
235     }
236 
237     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {
238         allowed[msg.sender][_spender] = _value;
239         emit Approval(msg.sender, _spender, _value);
240         return true;
241     }
242 
243     function allowance(address _owner, address _spender) public view returns (uint256) {
244         return allowed[_owner][_spender];
245     }
246 
247     function increaseApproval(address _spender, uint _addedValue) public canTransfer(msg.sender, _spender) returns (bool) {
248         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250         return true;
251     }
252 
253     function decreaseApproval(address _spender, uint _subtractedValue) public canTransfer(msg.sender, _spender) returns (bool) {
254         uint oldValue = allowed[msg.sender][_spender];
255         if (_subtractedValue > oldValue) {
256             allowed[msg.sender][_spender] = 0;
257         } else {
258             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259         }
260         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261         return true;
262     }
263 
264     function burn(uint256 _value) public {
265         require(_value <= balances[msg.sender]);
266         // no need to require value <= totalSupply, since that would imply the
267         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
268 
269         address burner = msg.sender;
270         balances[burner] = balances[burner].sub(_value);
271         totalSupply_ = totalSupply_.sub(_value);
272         emit Burn(burner, _value);
273     }
274 
275     function emergencyERC20Drain(ERC20 _token, uint256 _amount) public onlyOwner {
276         _token.transfer(owner, _amount);
277     }
278 }