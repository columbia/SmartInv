1 pragma solidity 0.4.21;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract TokenERC20 is owned {
21     address public deployer;
22 
23     string public name ="Universe-ETH";
24     string public symbol = "UETH";
25     uint8 public decimals = 18;
26 
27     uint256 public totalSupply;
28 
29 
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Approval(address indexed owner, address indexed spender, uint value);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Burn(address indexed from, uint256 value);
38 
39     function TokenERC20() public {
40         deployer = msg.sender;
41     }
42 
43     function _transfer(address _from, address _to, uint _value) internal {
44         require(_to != 0x0);
45         require(balanceOf[_from] >= _value);
46         require(balanceOf[_to] + _value >= balanceOf[_to]);
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         balanceOf[_from] -= _value;
49         balanceOf[_to] += _value;
50         emit Transfer(_from, _to, _value);
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54     function transfer(address _to, uint256 _value) public {
55         _transfer(msg.sender, _to, _value);
56     }
57 	
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
59         require(allowance[_from][msg.sender] >= _value);
60         allowance[_from][msg.sender] -= _value;
61         _transfer(_from, _to, _value);
62         return true;
63     }
64 
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         emit Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     function burn(uint256 _value) onlyOwner public returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);
73         balanceOf[msg.sender] -= _value;
74         totalSupply -= _value;
75         emit Burn(msg.sender, _value);
76         return true;
77     }
78 
79 }
80 
81 contract MyAdvancedToken is TokenERC20 {
82     mapping (address => bool) public frozenAccount;
83 
84     event FrozenFunds(address target, bool frozen);
85 
86     function MyAdvancedToken() TokenERC20() public {}
87 
88      function _transfer(address _from, address _to, uint _value) internal {
89         require(_to != 0x0);
90         require(balanceOf[_from] >= _value);
91         require(balanceOf[_to] + _value > balanceOf[_to]);
92         require(!frozenAccount[_from]);
93         require(!frozenAccount[_to]);
94         balanceOf[_from] -= _value;
95         balanceOf[_to] += _value;
96         Transfer(_from, _to, _value);
97     }
98 
99     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
100         uint tempSupply = totalSupply;
101         balanceOf[target] += mintedAmount;
102         totalSupply += mintedAmount;
103         require(totalSupply >= tempSupply);
104         Transfer(0, this, mintedAmount);
105         Transfer(this, target, mintedAmount);
106     }
107 
108 
109     function freezeAccount(address target, bool freeze) onlyOwner public {
110         frozenAccount[target] = freeze;
111         emit FrozenFunds(target, freeze);
112     }
113 
114     function () payable public {
115         require(false);
116     }
117 
118 }
119 
120 contract UETH is MyAdvancedToken {
121     mapping(address => uint) public lockdate;
122     mapping(address => uint) public lockTokenBalance;
123 
124     event LockToken(address account, uint amount, uint unixtime);
125 
126     function UETH() MyAdvancedToken() public {}
127     function getLockBalance(address account) internal returns(uint) {
128         if(now >= lockdate[account]) {
129             lockdate[account] = 0;
130             lockTokenBalance[account] = 0;
131         }
132         return lockTokenBalance[account];
133     }
134 
135     function _transfer(address _from, address _to, uint _value) internal {
136         uint usableBalance = balanceOf[_from] - getLockBalance(_from);
137         require(balanceOf[_from] >= usableBalance);
138         require(_to != 0x0);
139         require(usableBalance >= _value);
140         require(balanceOf[_to] + _value > balanceOf[_to]);
141         require(!frozenAccount[_from]);
142         require(!frozenAccount[_to]);
143         balanceOf[_from] -= _value;
144         balanceOf[_to] += _value;
145         emit Transfer(_from, _to, _value);
146     }
147 
148 
149     function lockTokenToDate(address account, uint amount, uint unixtime) onlyOwner public {
150         require(unixtime >= lockdate[account]);
151         require(unixtime >= now);
152         if(balanceOf[account] >= amount) {
153             lockdate[account] = unixtime;
154             lockTokenBalance[account] = amount;
155             emit LockToken(account, amount, unixtime);
156         }
157     }
158 
159     function lockTokenDays(address account, uint amount, uint _days) public {
160         uint unixtime = _days * 1 days + now;
161         lockTokenToDate(account, amount, unixtime);
162     }
163 
164     function burn(uint256 _value) onlyOwner public returns (bool success) {
165         uint usableBalance = balanceOf[msg.sender] - getLockBalance(msg.sender);
166         require(balanceOf[msg.sender] >= usableBalance);
167         require(usableBalance >= _value);
168         balanceOf[msg.sender] -= _value;
169         totalSupply -= _value; 
170         emit Burn(msg.sender, _value);
171         return true;
172     }
173 }