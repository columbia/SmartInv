1 pragma solidity ^0.5.10;
2 /*
3 ------------------------------------------------------
4     GPYX utility token contract
5 
6     Official website:
7     https://www.pyrexcoin.com
8 
9     Symbol      : GPYX
10     Name        : GoldenPyrex
11     Total supply: 10000000
12     Decimals    : 18
13     Audited by t.me/bolpol
14     Powered by ILIK.
15 
16     Enjoy.
17     Released under the MIT License.
18 ----------------------------------------------------
19 */
20 
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address account) external view returns (uint256);
26 
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 contract Ownable {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     constructor () internal {
46         _owner = msg.sender;
47         emit OwnershipTransferred(address(0), _owner);
48     }
49 
50     function owner() public view returns (address) {
51         return _owner;
52     }
53 
54     modifier onlyOwner() {
55         require(isOwner(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     function isOwner() public view returns (bool) {
60         return msg.sender == _owner;
61     }
62 
63     function renounceOwnership() public onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67 
68     function transferOwnership(address newOwner) public onlyOwner {
69         _transferOwnership(newOwner);
70     }
71 
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 contract ERC20Detailed {
80     string private _name;
81     string private _symbol;
82     uint8 private _decimals;
83 
84     constructor (string memory name, string memory symbol, uint8 decimals) public {
85         _name = name;
86         _symbol = symbol;
87         _decimals = decimals;
88     }
89 
90     function name() public view returns (string memory) {
91         return _name;
92     }
93 
94     function symbol() public view returns (string memory) {
95         return _symbol;
96     }
97 
98     function decimals() public view returns (uint8) {
99         return _decimals;
100     }
101 }
102 
103 contract GPYX is IERC20, ERC20Detailed, Ownable {
104     event Burn(address indexed from, uint256 value);
105     event FrozenFunds(address target, bool frozen);
106 
107     uint256 public totalSupply;
108 
109     mapping (address => uint256) private _balances;
110     mapping(address => mapping(address=> uint256)) private _allowances;
111     mapping(address => bool) public frozenAccount;
112 
113     constructor (
114         uint256 initialSupply,
115         string memory name,
116         string memory symbol,
117         uint8 decimals
118     )
119     public
120     ERC20Detailed(name, symbol, decimals)
121     {
122         totalSupply = initialSupply*10**uint256(decimals);
123         _balances[msg.sender] = totalSupply;
124         emit Transfer(address(0), msg.sender, totalSupply);
125     }
126 
127     function _transfer(address _from, address _to, uint256 _value) internal {
128         require(_to != address(0));
129         require(_balances[_from] >=_value);
130         require(_balances[_to] +_value >= _balances[_to]);
131         require(!frozenAccount[msg.sender]);
132         uint256 previousBalances = _balances[_from ] + _balances[_to];
133         _balances[_from] -= _value;
134         _balances[_to] += _value;
135         emit Transfer (_from, _to, _value);
136         assert(_balances[_from] + _balances[_to] == previousBalances);
137     }
138 
139     function transfer(address _to, uint256 _value) public returns (bool success) {
140         _transfer(msg.sender, _to, _value);
141         return true;
142     }
143 
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
145         require(_value <= _allowances[_from][msg.sender]);
146         _allowances[_from][msg.sender] -=_value;
147         _transfer(_from,_to, _value);
148         return true;
149     }
150 
151     function allowance(address owner, address spender) public view returns (uint256) {
152         return _allowances[owner][spender];
153     }
154 
155     function approve(address _spender, uint256 _value) public onlyOwner returns (bool success) {
156         _allowances[msg.sender][_spender] = _value;
157         emit Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     function balanceOf(address _who) public view returns (uint256 balance) {
162         return _balances[_who];
163     }
164 
165     function burn(uint256 _value) public onlyOwner returns (bool success) {
166         require(_balances[msg.sender] >= _value);
167         _balances[msg.sender] -= _value;
168         totalSupply -= _value;
169         emit Burn(msg.sender, _value);
170         return true;
171     }
172 
173     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
174         require(_balances[_from] >= _value);
175         require(_value <= _allowances[_from][msg.sender]);
176         _balances[_from] -= _value;
177         totalSupply -= _value;
178         emit Burn(msg.sender, _value);
179         return true;
180     }
181 
182     function freezeAccount(address target) public onlyOwner returns (bool frozen) {
183         frozenAccount[target] = true;
184         emit FrozenFunds (target, true);
185         return true;
186     }
187 
188     function unfreezeAccount(address target) public onlyOwner returns (bool frozen) {
189         frozenAccount[target] = false;
190         emit FrozenFunds (target, false);
191         return true;
192     }
193 }