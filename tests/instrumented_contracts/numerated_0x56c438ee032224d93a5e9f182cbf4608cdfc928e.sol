1 // File: contracts/interface/token/ERC20Interface.sol
2 
3 ///////////////////////////////////////////////////////////////////////////////////
4 ////                     Standard ERC-20 token contract (EPK)                   ///
5 ///////////////////////////////////////////////////////////////////////////////////
6 ///                                                                             ///
7 /// Standard ERC-20 token contract definition as mentioned above                ///
8 ///                                                                             ///
9 ///////////////////////////////////////////////////////////////////////////////////
10 ///                                                          Mr.K by 2019/08/01 ///
11 ///////////////////////////////////////////////////////////////////////////////////
12 
13 pragma solidity >=0.5.0 <0.6.0;
14 
15 contract ERC20Interface
16 {
17     uint256 public totalSupply;
18     string  public name;
19     uint8   public decimals;
20     string  public symbol;
21 
22     function balanceOf(address _owner) public view returns (uint256 balance);
23     function transfer(address _to, uint256 _value) public returns (bool success);
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25 
26     function approve(address _spender, uint256 _value) public returns (bool success);
27     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
28 
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 
32     /// 只有合约可以调用的内部API
33     function API_MoveToken(address _from, address _to, uint256 _value) external;
34 }
35 
36 // File: contracts/interface/ticket/TicketInterface.sol
37 
38 ///////////////////////////////////////////////////////////////////////////////////
39 ////                           EPK record contract                              ///
40 ///////////////////////////////////////////////////////////////////////////////////
41 ///                                                                             ///
42 /// Used to pay EPK to unlock accounts, record payment results, and provide a   ///
43 /// query method for querying whether one account has been unlocked.            ///
44 ///                                                                             ///
45 ///////////////////////////////////////////////////////////////////////////////////
46 ///                                                          Mr.K by 2019/08/01 ///
47 ///////////////////////////////////////////////////////////////////////////////////
48 
49 pragma solidity >=0.5.0 <0.6.0;
50 
51 interface TicketInterface {
52 
53     //One address needs to have enough EPK to unlock accounts. If one account has been unlocked before, the method will not take effect.
54     function PaymentTicket() external;
55 
56     //Check if the one address has paid EPK to unlock the account.
57     function HasTicket( address ownerAddr ) external view returns (bool);
58 }
59 
60 // File: contracts/InternalModule.sol
61 
62 pragma solidity >=0.5.0 <0.6.0;
63 
64 
65 contract InternalModule {
66 
67     address[] _authAddress;
68 
69     address _contractOwner;
70 
71     address _managerAddress;
72 
73     constructor() public {
74         _contractOwner = msg.sender;
75     }
76 
77     modifier OwnerOnly() {
78         require( _contractOwner == msg.sender ); _;
79     }
80 
81     modifier ManagerOnly() {
82         require(msg.sender == _managerAddress); _;
83     }
84 
85     modifier APIMethod() {
86 
87         bool exist = false;
88 
89         for (uint i = 0; i < _authAddress.length; i++) {
90             if ( _authAddress[i] == msg.sender ) {
91                 exist = true;
92                 break;
93             }
94         }
95 
96         require(exist); _;
97     }
98 
99     function SetRoundManager(address rmaddr ) external OwnerOnly {
100         _managerAddress = rmaddr;
101     }
102 
103     function AddAuthAddress(address _addr) external ManagerOnly {
104         _authAddress.push(_addr);
105     }
106 
107     function DelAuthAddress(address _addr) external ManagerOnly {
108 
109         for (uint i = 0; i < _authAddress.length; i++) {
110 
111             if (_authAddress[i] == _addr) {
112 
113                 for (uint j = 0; j < _authAddress.length - 1; j++) {
114 
115                     _authAddress[j] = _authAddress[j+1];
116 
117                 }
118 
119                 delete _authAddress[_authAddress.length - 1];
120                 _authAddress.length--;
121             }
122 
123         }
124     }
125 
126 
127 }
128 
129 // File: contracts/ERC20Token.sol
130 
131 pragma solidity >=0.5.0 <0.6.0;
132 
133 
134 
135 
136 contract ERC20Token is ERC20Interface, InternalModule {
137     string  public name                     = "Name";
138     string  public symbol                   = "Symbol";
139     uint8   public decimals                 = 18;
140     uint256 public totalSupply              = 1000000000 * 10 ** 18;
141     uint256 constant private MAX_UINT256    = 2 ** 256 - 1;
142     uint256 private constant brunMaxLimit = (1000000000 * 10 ** 18) - (10000000 * 10 ** 18);
143 
144     mapping (address => uint256) public balances;
145     mapping (address => mapping (address => uint256)) public allowed;
146 
147     event Transfer(address indexed from, address indexed to, uint256 value);
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149 
150     constructor(string memory tokenName, string memory tokenSymbol, uint256 tokenTotalSupply, uint256 mint) public {
151 
152         name = tokenName;
153         symbol = tokenSymbol;
154         totalSupply = tokenTotalSupply;
155 
156         balances[_contractOwner] = mint;
157         balances[address(this)] = tokenTotalSupply - mint;
158     }
159 
160     function transfer(address _to, uint256 _value) public
161     returns (bool success) {
162         require(balances[msg.sender] >= _value);
163         balances[msg.sender] -= _value;
164         balances[_to] += _value;
165         emit Transfer(msg.sender, _to, _value);
166         return true;
167     }
168 
169     function transferFrom(address _from, address _to, uint256 _value) public
170     returns (bool success) {
171         uint256 allowance = allowed[_from][msg.sender];
172         require(balances[_from] >= _value && allowance >= _value);
173         balances[_to] += _value;
174         balances[_from] -= _value;
175         if (allowance < MAX_UINT256) {
176             allowed[_from][msg.sender] -= _value;
177         }
178         emit Transfer(_from, _to, _value);
179         return true;
180     }
181 
182     function balanceOf(address _owner) public view
183     returns (uint256 balance) {
184         return balances[_owner];
185     }
186 
187     function approve(address _spender, uint256 _value) public
188     returns (bool success) {
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194     function allowance(address _owner, address _spender) public view
195     returns (uint256 remaining) {
196         return allowed[_owner][_spender];
197     }
198 
199     uint256 private ticketPrice = 60000000000000000000;
200 
201     mapping( address => bool ) private _paymentTicketAddrMapping;
202 
203     function PaymentTicket() external {
204 
205         require( _paymentTicketAddrMapping[msg.sender] == false, "ERC20_ERR_001");
206         require( balances[msg.sender] >= ticketPrice, "ERC20_ERR_002");
207 
208         balances[msg.sender] -= ticketPrice;
209 
210         if ( balances[address(0x0)] == brunMaxLimit ) {
211             balances[_contractOwner] += ticketPrice;
212         } else if ( balances[address(0x0)] + ticketPrice >= brunMaxLimit ) {
213             balances[_contractOwner] += (balances[address(0x0)] + ticketPrice) - brunMaxLimit;
214             balances[address(0x0)] = brunMaxLimit;
215         } else {
216             balances[address(0x0)] += ticketPrice;
217         }
218         _paymentTicketAddrMapping[msg.sender] = true;
219     }
220 
221     function HasTicket( address ownerAddr ) external view returns (bool) {
222         return _paymentTicketAddrMapping[ownerAddr];
223     }
224     function API_MoveToken(address _from, address _to, uint256 _value) external APIMethod {
225 
226         require( balances[_from] >= _value, "ERC20_ERR_003" );
227 
228         balances[_from] -= _value;
229 
230         if ( _to == address(0x0) ) {
231             if ( balances[address(0x0)] == brunMaxLimit ) {
232                 balances[_contractOwner] += _value;
233             } else if ( balances[address(0x0)] + _value >= brunMaxLimit ) {
234                 balances[_contractOwner] += (balances[address(0x0)] + _value) - brunMaxLimit;
235                 balances[address(0x0)] = brunMaxLimit;
236             } else {
237                 balances[address(0x0)] += _value;
238             }
239         } else {
240             balances[_to] += _value;
241         }
242 
243         emit Transfer( _from, _to, _value );
244     }
245 }