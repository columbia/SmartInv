1 pragma solidity ^0.4.18;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0) {
5       return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 contract Ownable {
28   address public owner;
29   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30   function Ownable() public {
31     owner = msg.sender;
32   }
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 }
43 contract UpfiringStore is Ownable {
44   using SafeMath for uint;
45   mapping(bytes32 => mapping(address => uint)) private payments;
46   mapping(bytes32 => mapping(address => uint)) private paymentDates;
47   mapping(address => uint) private balances;
48   mapping(address => uint) private totalReceiving;
49   mapping(address => uint) private totalSpending;
50   function UpfiringStore() public {}
51   function balanceOf(address _owner) public view returns (uint balance) {
52     return balances[_owner];
53   }
54   function totalReceivingOf(address _owner) public view returns (uint balance) {
55     return totalReceiving[_owner];
56   }
57   function totalSpendingOf(address _owner) public view returns (uint balance) {
58     return totalSpending[_owner];
59   }
60   function check(bytes32 _hash, address _from, uint _availablePaymentTime) public view returns (uint amount) {
61     uint _amount = payments[_hash][_from];
62     uint _date = paymentDates[_hash][_from];
63     if (_amount > 0 && (_date + _availablePaymentTime) > now) {
64       return _amount;
65     } else {
66       return 0;
67     }
68   }
69   function payment(bytes32 _hash, address _from, uint _amount) onlyOwner public returns (bool result) {
70     payments[_hash][_from] = payments[_hash][_from].add(_amount);
71     paymentDates[_hash][_from] = now;
72     return true;
73   }
74   function subBalance(address _owner, uint _amount) onlyOwner public returns (bool result) {
75     require(balances[_owner] >= _amount);
76     balances[_owner] = balances[_owner].sub(_amount);
77     totalSpending[_owner] = totalSpending[_owner].add(_amount);
78     return true;
79   }
80   function addBalance(address _owner, uint _amount) onlyOwner public returns (bool result) {
81     balances[_owner] = balances[_owner].add(_amount);
82     totalReceiving[_owner] = totalReceiving[_owner].add(_amount);
83     return true;
84   }
85 }
86 contract ERC20Basic {
87   function totalSupply() public view returns (uint256);
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 contract Upfiring is Ownable {
99   using SafeMath for uint;
100   ERC20 public token;
101   UpfiringStore public store;
102   uint8 public torrentOwnerPercent = 50;
103   uint8 public seedersProfitMargin = 3;
104   uint public availablePaymentTime = 86400; //seconds
105   uint public minWithdraw = 0;
106   event Payment(string _torrent, uint _amount, address indexed _from);
107   event Refill(address indexed _to, uint _amount);
108   event Withdraw(address indexed _to, uint _amount);
109   event Pay(address indexed _to, uint _amount, bytes32 _hash);
110   event ChangeBalance(address indexed _to, uint _balance);
111   event LogEvent(string _log);
112   function Upfiring(UpfiringStore _store, ERC20 _token, uint8 _torrentOwnerPercent, uint8 _seedersProfitMargin, uint _minWithdraw) public {
113     require(_store != address(0));
114     require(_token != address(0));
115     require(_torrentOwnerPercent != 0);
116     require(_seedersProfitMargin != 0);
117     store = _store;
118     token = _token;
119     torrentOwnerPercent = _torrentOwnerPercent;
120     seedersProfitMargin = _seedersProfitMargin;
121     minWithdraw = _minWithdraw;
122   }
123   function() external payable {
124     revert();
125   }
126   function balanceOf(address _owner) public view returns (uint balance) {
127     return store.balanceOf(_owner);
128   }
129   function totalReceivingOf(address _owner) public view returns (uint balance) {
130     return store.totalReceivingOf(_owner);
131   }
132   function totalSpendingOf(address _owner) public view returns (uint balance) {
133     return store.totalSpendingOf(_owner);
134   }
135   function check(string _torrent, address _from) public view returns (uint amount) {
136     return store.check(torrentToHash(_torrent), _from, availablePaymentTime);
137   }
138   function torrentToHash(string _torrent) internal pure returns (bytes32 _hash)  {
139     return sha256(_torrent);
140   }
141   function refill(uint _amount) external {
142     require(_amount != uint(0));
143     require(token.transferFrom(msg.sender, address(this), _amount));
144     store.addBalance(msg.sender, _amount);
145     ChangeBalance(msg.sender, store.balanceOf(msg.sender));
146     Refill(msg.sender, _amount);
147   }
148   function withdraw(uint _amount) external {
149     require(_amount >= minWithdraw);
150     require(token.balanceOf(address(this)) >= _amount);
151     require(token.transfer(msg.sender, _amount));
152     require(store.subBalance(msg.sender, _amount));
153     ChangeBalance(msg.sender, store.balanceOf(msg.sender));
154     Withdraw(msg.sender, _amount);
155   }
156   function pay(string _torrent, uint _amount, address _owner, address[] _seeders, address[] _freeSeeders) external {
157     require(_amount != uint(0));
158     require(_owner != address(0));
159     bytes32 _hash = torrentToHash(_torrent);
160     require(store.subBalance(msg.sender, _amount));
161     store.payment(_hash, msg.sender, _amount);
162     Payment(_torrent, _amount, msg.sender);
163     ChangeBalance(msg.sender, store.balanceOf(msg.sender));
164     sharePayment(_hash, _amount, _owner, _seeders, _freeSeeders);
165   }
166   function sharePayment(bytes32 _hash, uint _amount, address _owner, address[] _seeders, address[] _freeSeeders) internal {
167     if ((_seeders.length + _freeSeeders.length) == 0) {
168       payTo(_owner, _amount, _hash);
169     } else {
170       uint _ownerAmount = _amount.mul(torrentOwnerPercent).div(100);
171       uint _otherAmount = _amount.sub(_ownerAmount);
172       uint _realOtherAmount = shareSeeders(_seeders, _freeSeeders, _otherAmount, _hash);
173       payTo(_owner, _amount.sub(_realOtherAmount), _hash);
174     }
175   }
176   function shareSeeders(address[] _seeders, address[] _freeSeeders, uint _amount, bytes32 _hash) internal returns (uint){
177     uint _dLength = _freeSeeders.length.add(_seeders.length.mul(seedersProfitMargin));
178     uint _dAmount = _amount.div(_dLength);
179     payToList(_seeders, _dAmount.mul(seedersProfitMargin), _hash);
180     payToList(_freeSeeders, _dAmount, _hash);
181     return _dLength.mul(_dAmount);
182   }
183   function payToList(address[] _seeders, uint _amount, bytes32 _hash) internal {
184     if (_seeders.length > 0) {
185       for (uint i = 0; i < _seeders.length; i++) {
186         address _seeder = _seeders[i];
187         payTo(_seeder, _amount, _hash);
188       }
189     }
190   }
191   function payTo(address _to, uint _amount, bytes32 _hash) internal {
192     require(store.addBalance(_to, _amount));
193     Pay(_to, _amount, _hash);
194     ChangeBalance(_to, store.balanceOf(_to));
195   }
196   function migrateStore(address _to) onlyOwner public {
197     store.transferOwnership(_to);
198   }
199   function setAvailablePaymentTime(uint _availablePaymentTime) onlyOwner public {
200     availablePaymentTime = _availablePaymentTime;
201   }
202   function setSeedersProfitMargin(uint8 _seedersProfitMargin) onlyOwner public {
203     seedersProfitMargin = _seedersProfitMargin;
204   }
205   function setTorrentOwnerPercent(uint8 _torrentOwnerPercent) onlyOwner public {
206     torrentOwnerPercent = _torrentOwnerPercent;
207   }
208   function setMinWithdraw(uint _minWithdraw) onlyOwner public {
209     minWithdraw = _minWithdraw;
210   }
211 }