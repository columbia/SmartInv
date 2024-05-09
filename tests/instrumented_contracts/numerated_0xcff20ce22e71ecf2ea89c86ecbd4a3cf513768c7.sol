1 pragma solidity ^0.5.1;
2 
3 contract IERC223 {
4     uint public _totalSupply;
5 
6     function balanceOf(address who) public view returns (uint);
7 
8     function transfer(address to, uint value) public returns (bool success);
9 
10     event Transfer(address indexed from, address indexed to, uint value);
11 }
12 
13 library SafeMath {
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a, "SafeMath: subtraction overflow");
23         uint256 c = a - b;
24 
25         return c;
26     }
27 
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38 
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b > 0, "SafeMath: division by zero");
41         uint256 c = a / b;
42 
43         return c;
44     }
45 
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b != 0, "SafeMath: modulo by zero");
48         return a % b;
49     }
50 }
51 
52 library Address {
53     function isContract(address account) internal view returns (bool) {
54         uint256 size;
55         assembly {size := extcodesize(account)}
56         return size > 0;
57     }
58 
59     function toPayable(address account) internal pure returns (address payable) {
60         return address(uint160(account));
61     }
62 }
63 
64 contract MAKES is IERC223 {
65     using SafeMath for uint;
66 
67     address public owner;
68     bool public locked;
69     string public symbol;
70     string public name;
71     uint8 public decimals;
72     uint public maximumSupply;
73 
74     event MinterAdded(address indexed account);
75     event MinterRemoved(address indexed account);
76 
77     mapping(address => bool) public _minters;
78     mapping(address => uint) balances;
79 
80     constructor() public {
81         locked = false;
82         symbol = "MKS";
83         name = "MAKES";
84         decimals = 6;
85         maximumSupply = 200000000000000;
86 
87         owner = msg.sender;
88         _addMinter(msg.sender);
89         mint(msg.sender, 40000000000000);
90     }
91 
92     modifier onlyOwner() {
93         require(isOwner(msg.sender), "OwnerRole: caller does not have the Owner role");
94         _;
95     }
96 
97     modifier onlyMinter() {
98         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
99         _;
100     }
101 
102     function isOwner(address account) public view returns (bool) {
103         return account == owner;
104     }
105 
106     function isMinter(address account) public view returns (bool) {
107         return _minters[account];
108     }
109 
110     function totalSupply() public view returns (uint256) {
111         return _totalSupply;
112     }
113 
114     function transferOwnership(address newOwner) public onlyOwner {
115         owner = newOwner;
116     }
117 
118     function transfer(address _to, uint _value) public returns (bool success) {
119         require(locked == false);
120         require(balanceOf(msg.sender) > _value);
121         require(!Address.isContract(_to));
122 
123         balances[msg.sender] = balances[msg.sender].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         emit Transfer(msg.sender, _to, _value);
126         return true;
127     }
128 
129     function isLocked() public view returns (bool) {
130         return locked;
131     }
132 
133     function applyLock() public onlyOwner {
134         locked = true;
135     }
136 
137     function unlock() public onlyOwner {
138         locked = false;
139     }
140 
141     function balanceOf(address _owner) public view returns (uint balance) {
142         return balances[_owner];
143     }
144 
145     function addMinter(address account) public onlyOwner {
146         _addMinter(account);
147     }
148 
149     function removeMinter(address account) public onlyOwner {
150         _removeMinter(account);
151     }
152 
153     function renounceMinter() public {
154         _removeMinter(msg.sender);
155     }
156 
157     function _addMinter(address account) internal {
158         _minters[account] = true;
159         emit MinterAdded(account);
160     }
161 
162     function _removeMinter(address account) internal {
163         _minters[account] = false;
164         emit MinterRemoved(account);
165     }
166 
167     function mint(address account, uint256 amount) public onlyMinter returns (bool success) {
168         uint newTotalSupply = _totalSupply.add(amount);
169         require(newTotalSupply <= maximumSupply);
170         _totalSupply = newTotalSupply;
171         balances[account] = balances[account].add(amount);
172         emit Transfer(address(0), account, amount);
173         return true;
174     }
175 
176     function burn(uint256 _amount) public {
177         require(balanceOf(msg.sender) >= _amount);
178         balances[msg.sender] = balances[msg.sender].sub(_amount);
179         _totalSupply = _totalSupply.sub(_amount);
180         emit Transfer(msg.sender, address(0), _amount);
181     }
182 }