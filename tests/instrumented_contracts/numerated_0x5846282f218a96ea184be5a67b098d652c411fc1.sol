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
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) public view returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract ACAToken is ERC20 {
64     using SafeMath for uint256;
65 
66     address public owner;
67     address public admin;
68 
69     string public name = "ACA Network Token";
70     string public symbol = "ACA";
71     uint8 public decimals = 18;
72 
73     uint256 totalSupply_;
74     mapping (address => mapping (address => uint256)) internal allowed;
75     mapping (address => uint256) balances;
76 
77     bool transferable = false;
78     mapping (address => bool) internal transferLocked;
79 
80     event Genesis(address owner, uint256 value);
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
83     event Burn(address indexed burner, uint256 value);
84     event LogAddress(address indexed addr);
85     event LogUint256(uint256 value);
86     event TransferLock(address indexed target, bool value);
87 
88     // modifiers
89     modifier onlyOwner() {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     modifier onlyAdmin() {
95         require(msg.sender == owner || msg.sender == admin);
96         _;
97     }
98 
99     modifier canTransfer(address _from, address _to) {
100         require(_to != address(0x0));
101         require(_to != address(this));
102 
103         if ( _from != owner && _from != admin ) {
104             require(transferable);
105             require (!transferLocked[_from]);
106         }
107         _;
108     }
109 
110     // constructor
111     function ACAToken(uint256 _totalSupply, address _newAdmin) public {
112         require(_totalSupply > 0);
113         require(_newAdmin != address(0x0));
114         require(_newAdmin != msg.sender);
115 
116         owner = msg.sender;
117         admin = _newAdmin;
118 
119         totalSupply_ = _totalSupply;
120 
121         balances[owner] = totalSupply_;
122         approve(admin, totalSupply_);
123         Genesis(owner, totalSupply_);
124     }
125 
126     // permission related
127     function transferOwnership(address newOwner) public onlyOwner {
128         require(newOwner != address(0));
129         require(newOwner != admin);
130 
131         owner = newOwner;
132         OwnershipTransferred(owner, newOwner);
133     }
134 
135     function transferAdmin(address _newAdmin) public onlyOwner {
136         require(_newAdmin != address(0));
137         require(_newAdmin != address(this));
138         require(_newAdmin != owner);
139 
140         admin = _newAdmin;
141         AdminTransferred(admin, _newAdmin);
142     }
143 
144     function setTransferable(bool _transferable) public onlyAdmin {
145         transferable = _transferable;
146     }
147 
148     function isTransferable() public view returns (bool) {
149         return transferable;
150     }
151 
152     function transferLock() public returns (bool) {
153         transferLocked[msg.sender] = true;
154         TransferLock(msg.sender, true);
155         return true;
156     }
157 
158     function manageTransferLock(address _target, bool _value) public onlyOwner returns (bool) {
159         transferLocked[_target] = _value;
160         TransferLock(_target, _value);
161         return true;
162     }
163 
164     function transferAllowed(address _target) public view returns (bool) {
165         return (transferable && transferLocked[_target] == false);
166     }
167 
168     // token related
169     function totalSupply() public view returns (uint256) {
170         return totalSupply_;
171     }
172 
173     function transfer(address _to, uint256 _value) canTransfer(msg.sender, _to) public returns (bool) {
174         require(_value <= balances[msg.sender]);
175 
176         // SafeMath.sub will throw if there is not enough balance.
177         balances[msg.sender] = balances[msg.sender].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         Transfer(msg.sender, _to, _value);
180         return true;
181     }
182 
183     function balanceOf(address _owner) public view returns (uint256 balance) {
184         return balances[_owner];
185     }
186 
187     function balanceOfOwner() public view returns (uint256 balance) {
188         return balances[owner];
189     }
190 
191     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
192         require(_value <= balances[_from]);
193         require(_value <= allowed[_from][msg.sender]);
194 
195         balances[_from] = balances[_from].sub(_value);
196         balances[_to] = balances[_to].add(_value);
197         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198         Transfer(_from, _to, _value);
199         return true;
200     }
201 
202     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {
203         allowed[msg.sender][_spender] = _value;
204         Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     function allowance(address _owner, address _spender) public view returns (uint256) {
209         return allowed[_owner][_spender];
210     }
211 
212     function increaseApproval(address _spender, uint _addedValue) public canTransfer(msg.sender, _spender) returns (bool) {
213         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218     function decreaseApproval(address _spender, uint _subtractedValue) public canTransfer(msg.sender, _spender) returns (bool) {
219         uint oldValue = allowed[msg.sender][_spender];
220         if (_subtractedValue > oldValue) {
221             allowed[msg.sender][_spender] = 0;
222         } else {
223             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224         }
225         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 
229     function burn(uint256 _value) public {
230         require(_value <= balances[msg.sender]);
231         // no need to require value <= totalSupply, since that would imply the
232         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
233 
234         address burner = msg.sender;
235         balances[burner] = balances[burner].sub(_value);
236         totalSupply_ = totalSupply_.sub(_value);
237         Burn(burner, _value);
238     }
239 
240     function emergencyERC20Drain(ERC20 _token, uint256 _amount) public onlyOwner {
241         _token.transfer(owner, _amount);
242     }
243 }