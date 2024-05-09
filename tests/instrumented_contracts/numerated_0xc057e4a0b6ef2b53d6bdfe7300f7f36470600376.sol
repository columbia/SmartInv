1 pragma solidity ^0.5.1;
2 
3 /* SafeMath cal*/
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         require(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b > 0);
17         uint256 c = a / b;
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a);
23         uint256 c = a - b;
24         return c;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a);
30         return c;
31     }
32 
33     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b != 0);
35         return a % b;
36     }
37 }
38 
39 /* IERC20 inteface */
40 interface IERC20 {
41   function transfer(address to, uint256 value) external returns (bool);
42   function approve(address spender, uint256 value) external returns (bool);
43   function transferFrom(address from, address to, uint256 value) external returns (bool);
44   function totalSupply() external view returns (uint256);
45   function balanceOf(address who) external view returns (uint256);
46   function allowance(address owner, address spender) external view returns (uint256);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 /* Owner permission */
52 contract Ownable {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     constructor () internal {
58         _owner = msg.sender;
59         emit OwnershipTransferred(address(0), _owner);
60     }
61 
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(isOwner());
68         _;
69     }
70 
71     function isOwner() public view returns (bool) {
72         return msg.sender == _owner;
73     }
74 
75     function transferOwnership(address newOwner) public onlyOwner {
76         _transferOwnership(newOwner);
77     }
78 
79     function _transferOwnership(address newOwner) internal {
80         require(newOwner != address(0));
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 }
85 
86 /* LockAble contract */
87 contract LockAble is Ownable {
88 
89     mapping (address => bool) _walletLockAddr;
90 
91     function setLockWallet(address lockAddress)  public onlyOwner returns (bool){
92         _walletLockAddr[lockAddress] = true;
93         return true;
94     }
95 
96     function setReleaseWallet(address lockAddress)  public onlyOwner returns (bool){
97          _walletLockAddr[lockAddress] = false;
98         return true;
99     }
100 
101     function isLockWallet(address lockAddress)  public view returns (bool){
102         require(lockAddress != address(0), "Ownable: new owner is the zero address");
103         return _walletLockAddr[lockAddress];
104     }
105 }
106 
107 contract PartnerShip is LockAble{
108 
109    mapping (address => bool) _partnerAddr;
110 
111    function addPartnership(address partner) public onlyOwner returns (bool){
112        require(partner != address(0), "Ownable: new owner is the zero address");
113 
114        _partnerAddr[partner] = true;
115        return true;
116    }
117 
118    function removePartnership(address partner) public onlyOwner returns (bool){
119       require(partner != address(0), "Ownable: new owner is the zero address");
120 
121       _partnerAddr[partner] = false;
122 
123       return true;
124    }
125 
126    function isPartnership(address partner)  public view returns (bool){
127        return _partnerAddr[partner];
128    }
129 
130 
131 }
132 
133 contract SaveWon is IERC20, Ownable, PartnerShip {
134 
135     using SafeMath for uint256;
136     string private _name;
137     string private _symbol;
138     uint256 private _totalSupply;
139     
140     uint8 private _decimals = 18;
141 
142     mapping (address => uint256) internal _balances;
143     mapping (address => mapping (address => uint256)) private _allowed;
144 
145 
146     event Burn(address indexed from, uint256 value);
147     
148     constructor() public {
149         _name = "SAVEWON";
150         _symbol = "SW";
151         uint256 INITIAL_SUPPLY = 50000000000 * (10 ** uint256(_decimals));
152         _totalSupply = _totalSupply.add(INITIAL_SUPPLY);
153         _balances[msg.sender] = _balances[msg.sender].add(INITIAL_SUPPLY);
154         
155         emit Transfer(address(0), msg.sender, _totalSupply);
156     }
157 
158 
159     function name() public view returns (string memory) {
160         return _name;
161     }
162 
163     function symbol() public view returns (string memory) {
164         return _symbol;
165     }
166 
167     function decimals() public view returns (uint8) {
168         return _decimals;
169     }
170     
171     function totalSupply() public view returns (uint256) {
172         return _totalSupply;
173     }
174 
175     function balanceOf(address owner) public view returns (uint256) {
176         return _balances[owner];
177     }
178 
179     function transfer(address to, uint256 value) public returns (bool) {
180          require(_walletLockAddr[msg.sender] != true, "Wallet Locked");
181 
182         _transfer(msg.sender, to, value);
183         return true;
184     }
185 
186     function transferFrom(address from, address to, uint256 value) public returns (bool) {
187          _transfer(from, to, value);
188          _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
189          return true;
190     }
191 
192     function _transfer(address from, address to, uint256 value) internal {
193         require(to != address(0));
194 
195         _balances[from] = _balances[from].sub(value);
196         _balances[to] = _balances[to].add(value);
197         emit Transfer(from, to, value);
198 
199     }
200 
201     function approve(address spender, uint256 value) public returns (bool) {
202         _approve(msg.sender, spender, value);
203         return true;
204     }
205 
206     function _approve(address owner, address spender, uint256 value) internal {
207         require(spender != address(0));
208         require(owner != address(0));
209 
210         _allowed[owner][spender] = value;
211         emit Approval(owner, spender, value);
212     }
213 
214     function allowance(address owner, address spender) public view returns (uint256) {
215         return _allowed[owner][spender];
216     }
217 
218    function burn(uint256 value) public onlyOwner{
219         require(value != 0, "Ownable: new owner is the zero address");
220 
221        _burn(msg.sender, value);
222    }
223 
224    function _burn(address account, uint256 value) internal {
225        require(account != address(0));
226        require(value <= _balances[account]);
227 
228        _totalSupply = _totalSupply.sub(value);
229        _balances[account] = _balances[account].sub(value);
230        emit Burn(account, value);
231        emit Transfer(account, address(0), value);
232    }
233 
234    function multiTransfer(address[] memory toArray, uint256[] memory valueArray) public returns (bool){
235      if(isPartnership(msg.sender) || isOwner()){
236        uint256 i = 0;
237        while(i < toArray.length){
238          transfer( toArray[i],valueArray[i]);
239          i += 1;
240        }
241        return true;
242      } else {
243        return false;
244      }
245    }
246 }