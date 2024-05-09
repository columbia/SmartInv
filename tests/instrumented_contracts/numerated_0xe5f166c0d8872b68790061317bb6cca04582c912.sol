1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 }
49 
50 contract ERC20Interface {
51   function totalSupply() public constant returns (uint);
52   function balanceOf(address tokenOwner) public constant returns (uint balance);
53   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
54   function transfer(address to, uint tokens) public returns (bool success);
55   function approve(address spender, uint tokens) public returns (bool success);
56   function transferFrom(address from, address to, uint tokens) public returns (bool success);
57   event Transfer(address indexed from, address indexed to, uint tokens);
58   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 
62 contract ERC827 {
63 
64   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
65   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
66   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
67 
68 }
69 
70 
71 contract TEFoodsToken is Ownable, ERC20Interface {
72 
73   using SafeMath for uint;
74 
75   string public constant name = "TE-FOOD";
76   string public constant symbol = "TFD";
77   uint8 public constant decimals = 18;
78   uint constant _totalSupply = 1000000000 * 1 ether;
79   uint public transferrableTime = 9999999999;
80   uint _vestedSupply;
81   uint _circulatingSupply;
82   mapping (address => uint) balances;
83   mapping (address => mapping(address => uint)) allowed;
84 
85   struct vestedBalance {
86     address addr;
87     uint balance;
88   }
89   mapping (uint => vestedBalance[]) vestingMap;
90 
91 
92 
93   function TEFoodsToken () public {
94     owner = msg.sender;
95     balances[0x00] = _totalSupply;
96   }
97 
98   event VestedTokensReleased(address to, uint amount);
99 
100   function allocateTokens (address addr, uint amount) public onlyOwner returns (bool) {
101     require (addr != 0x00);
102     require (amount > 0);
103     balances[0x00] = balances[0x00].sub(amount);
104     balances[addr] = balances[addr].add(amount);
105     _circulatingSupply = _circulatingSupply.add(amount);
106     assert (_vestedSupply.add(_circulatingSupply).add(balances[0x00]) == _totalSupply);
107     Transfer(0x00, addr, amount);
108     return true;
109   }
110 
111   function allocateVestedTokens (address addr, uint amount, uint vestingPeriod) public onlyOwner returns (bool) {
112     require (addr != 0x00);
113     require (amount > 0);
114     require (vestingPeriod > 0);
115     balances[0x00] = balances[0x00].sub(amount);
116     vestingMap[vestingPeriod].push( vestedBalance (addr,amount) );
117     _vestedSupply = _vestedSupply.add(amount);
118     assert (_vestedSupply.add(_circulatingSupply).add(balances[0x00]) == _totalSupply);
119     return true;
120   }
121 
122   function releaseVestedTokens (uint vestingPeriod) public {
123     require (now >= transferrableTime.add(vestingPeriod));
124     require (vestingMap[vestingPeriod].length > 0);
125     require (vestingMap[vestingPeriod][0].balance > 0);
126     var v = vestingMap[vestingPeriod];
127     for (uint8 i = 0; i < v.length; i++) {
128       balances[v[i].addr] = balances[v[i].addr].add(v[i].balance);
129       _circulatingSupply = _circulatingSupply.add(v[i].balance);
130       _vestedSupply = _vestedSupply.sub(v[i].balance);
131       VestedTokensReleased(v[i].addr, v[i].balance);
132       Transfer(0x00, v[i].addr, v[i].balance);
133       v[i].balance = 0;
134     }
135   }
136 
137   function enableTransfers () public onlyOwner returns (bool) {
138     transferrableTime = now.add(86400);
139     owner = 0x00;
140     return true;
141   }
142 
143   function () public payable {
144     revert();
145   }
146 
147   function totalSupply() public constant returns (uint) {
148     return _circulatingSupply;
149   }
150 
151   function balanceOf(address tokenOwner) public constant returns (uint balance) {
152     return balances[tokenOwner];
153   }
154 
155   function vestedBalanceOf(address tokenOwner, uint vestingPeriod) public constant returns (uint balance) {
156     var v = vestingMap[vestingPeriod];
157     for (uint8 i = 0; i < v.length; i++) {
158       if (v[i].addr == tokenOwner) return v[i].balance;
159     }
160     return 0;
161   }
162 
163   function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
164     return allowed[tokenOwner][spender];
165   }
166 
167   function transfer(address to, uint tokens) public returns (bool success) {
168     require (now >= transferrableTime);
169     require (to != address(this));
170     require (balances[msg.sender] >= tokens);
171     balances[msg.sender] = balances[msg.sender].sub(tokens);
172     balances[to] = balances[to].add(tokens);
173     Transfer(msg.sender, to, tokens);
174     return true;
175   }
176 
177   function approve(address spender, uint tokens) public returns (bool success) {
178     require (now >= transferrableTime);
179     require (spender != address(this));
180     allowed[msg.sender][spender] = tokens;
181     Approval(msg.sender, spender, tokens);
182     return true;
183   }
184 
185   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
186     require (now >= transferrableTime);
187     require (to != address(this));
188     require (allowed[from][msg.sender] >= tokens);
189     balances[from] = balances[from].sub(tokens);
190     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
191     balances[to] = balances[to].add(tokens);
192     Transfer(from, to, tokens);
193     return true;
194   }
195 
196 }
197 
198 contract TEFoods827Token is TEFoodsToken, ERC827 {
199 
200   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
201     super.approve(_spender, _value);
202     require(_spender.call(_data));
203     return true;
204   }
205 
206   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
207     super.transfer(_to, _value);
208     require(_to.call(_data));
209     return true;
210   }
211 
212   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
213     super.transferFrom(_from, _to, _value);
214     require(_to.call(_data));
215     return true;
216   }
217 
218 }