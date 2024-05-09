1 pragma solidity ^0.5.1;
2 
3 /**
4  * @dev Math operations with safety checks that throw on error
5  */
6 library  SafeMath {
7     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
8         require(b <= a );
9         uint256 c = a - b;
10         return c;
11     }
12 
13     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require( c >= a && c >= b );
16         return c;
17     }
18 }
19 
20 /**
21  * @dev The Authorized contract has an admin address and a switch activating or
22  * deactivating the transfer functionality.
23  */
24 contract Authorized {
25     // Define an admin
26     address public admin;
27 
28     //Define an profile address
29     address public profitAddress;
30 
31     bool public _openTransfer = false;
32 
33     constructor( address _admin, address _profitAddress ) public {
34         //The admin and profileAddress not equal
35         require( _admin != _profitAddress );
36         admin = _admin;
37         profitAddress = _profitAddress;
38     }
39 
40     // Notify an event of opening transfer functionality.
41     event OpenTransfer( address indexed _operation, bool _previousFlag, bool _currentFlag );
42 
43     // Notify an event of closing transfer functionality.
44     event CloseTransfer( address indexed _operation, bool _previousFlag, bool _currentFlag );
45 
46     // Not Allowed if called by any account other than admin.
47     modifier onlyAdmin( ) {
48         require( msg.sender == admin);
49         _;
50     }
51 
52     // Not Allowed if not open.
53     modifier onlyOpen( ) {
54         require( _openTransfer );
55         require( msg.sender != profitAddress );
56         _;
57     }
58 
59     // Called by the admin to open transfer functionality.
60     function openTransfer( ) public onlyAdmin returns(bool success) {
61         require( !_openTransfer, "The flag is open");
62 
63         bool currentFlag = _openTransfer;
64         _openTransfer = true;
65 
66         emit OpenTransfer(msg.sender, currentFlag, _openTransfer);
67         return true;
68     }
69 
70     // Called by the admin to close transfer functionality.
71     function closeTransfer( ) public onlyAdmin returns(bool success) {
72         require(_openTransfer, "The flag is close");
73 
74         bool currentFlag = _openTransfer;
75         _openTransfer = false;
76 
77         emit CloseTransfer(msg.sender, currentFlag, _openTransfer);
78         return true;
79     }
80 }
81 
82 
83 contract LBKCoin is  Authorized {
84     string public name;
85     string public symbol;
86     uint8 public decimals;
87     uint256 public totalSupply;
88     mapping (address => uint256) public balanceOf;
89     mapping (address => mapping (address => uint256)) public allowance;
90     mapping (address => bool) public freezeOf;
91 
92     event Transfer(address indexed from, address indexed to, uint256 value);
93     event Burn(address indexed operation, address indexed from, uint256 value);
94 
95     // Notify an event of freezing an account.
96     event Freeze(address indexed from, bool _flag);
97 
98     // Notify an event of unfreezing an account.
99     event Unfreeze(address indexed from, bool _flag);
100 
101     constructor( string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply, address _admin, address _profitAddress ) public Authorized( _admin, _profitAddress ) {
102         name = _name;
103         symbol = _symbol;
104         decimals = _decimals;
105         totalSupply = _totalSupply;
106 
107         // The initial fund is allocated to the admin.
108         balanceOf[_admin] = totalSupply;
109     }
110 
111     // Send some funds when the transfer functionality is open.
112     function transfer(address _to, uint256 _value) public onlyOpen {
113         // Sender and receiver must be unfreezed.
114         require( freezeOf[msg.sender] == false && freezeOf[_to] == false );
115         require( _to != address(0) );
116         require( _value > 0 );
117 
118         require (balanceOf[msg.sender] >= _value) ;
119         require ((balanceOf[_to] + _value ) >= balanceOf[_to]) ;
120         balanceOf[msg.sender] = SafeMath.safeSub( balanceOf[msg.sender], _value );
121         balanceOf[_to] = SafeMath.safeAdd( balanceOf[_to], _value );
122         emit Transfer(msg.sender, _to, _value);
123     }
124 
125     // Allow another account to spend the specified amount of funds only when the transfer functionality is open.
126     function approve(address _spender, uint256 _value) public onlyOpen returns (bool success) {
127         // Sender and spender must be unfreezed.
128         require( freezeOf[msg.sender] == false && freezeOf[_spender] == false && _spender != Authorized.profitAddress );
129         require( _spender != address(0) );
130         require( _value >= 0 );
131         allowance[msg.sender][_spender] = _value;
132         return true;
133     }
134 
135     // Transfer some funds from one account to another, which is allowed
136     function transferFrom(address _from, address _to, uint256 _value) public onlyOpen returns (bool success) {
137         // Funds provider, sender and receiver must all be unfreezed.
138         require( freezeOf[msg.sender] == false && freezeOf[_from] == false && freezeOf[_to] == false );
139         require( _to != address(0) );
140         require( _value > 0 );
141 
142         require( balanceOf[_from] >= _value );
143         require( (balanceOf[_to] + _value) >= balanceOf[_to] );
144 
145         require (_value <= allowance[_from][msg.sender]);
146         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
147         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
148         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
149         emit Transfer(_from, _to, _value);
150         return true;
151     }
152 
153     // Only admin can burn some specified funds.
154     function burn(address _profitAddress, uint256 _value) public onlyAdmin returns (bool success) {
155         require( _profitAddress == address(0) || _profitAddress == Authorized.profitAddress );
156         if ( _profitAddress == address(0) ) {
157             require( balanceOf[msg.sender] >= _value );
158             require( _value > 0 );
159 
160             balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
161             totalSupply = SafeMath.safeSub(totalSupply,_value);
162         }
163         if ( _profitAddress != address(0) ) {
164             require( _profitAddress == Authorized.profitAddress );
165             require( balanceOf[_profitAddress] >= _value );
166             require( _value > 0 );
167 
168             balanceOf[_profitAddress] = SafeMath.safeSub(balanceOf[_profitAddress], _value);
169             totalSupply = SafeMath.safeSub(totalSupply,_value);
170         }
171         emit Burn(msg.sender, _profitAddress, _value);
172         return true;
173     }
174 
175     // Only admin can freeze a unfreezed account.
176     function freeze(address _freezeAddress) public onlyAdmin returns (bool success) {
177         require( _freezeAddress != address(0) && _freezeAddress != admin && _freezeAddress != Authorized.profitAddress );
178         require( freezeOf[_freezeAddress] == false );
179         freezeOf[_freezeAddress] = true;
180         emit Freeze(_freezeAddress, freezeOf[_freezeAddress]);
181         return true;
182     }
183 
184     // Only admin can unfreeze a freezed account.
185     function unfreeze(address _unfreezeAddress) public onlyAdmin returns (bool success) {
186         require( _unfreezeAddress != address(0) && _unfreezeAddress != admin && _unfreezeAddress != Authorized.profitAddress );
187         require( freezeOf[_unfreezeAddress] == true );
188         freezeOf[_unfreezeAddress] = false;
189         emit Unfreeze(_unfreezeAddress, freezeOf[_unfreezeAddress]);
190         return true;
191     }
192 }