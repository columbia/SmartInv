1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract BaseToken {
31     using SafeMath for uint256;
32 
33     string public name;
34     string public symbol;
35     uint8 public decimals;
36     uint256 public totalSupply;
37 
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 
44     function _transfer(address _from, address _to, uint _value) internal {
45         require(_to != address(0));
46         require(balanceOf[_from] >= _value);
47         balanceOf[_from] = balanceOf[_from].sub(_value);
48         balanceOf[_to] = balanceOf[_to].add(_value);
49         Transfer(_from, _to, _value);
50     }
51 
52     function transfer(address _to, uint256 _value) public returns (bool success) {
53         _transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);
59         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function approve(address _spender, uint256 _value) public returns (bool success) {
65         allowance[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69 }
70 
71 contract Ownable {
72     address public owner;
73 
74     event OwnershipRenounced(address indexed previousOwner);
75     event OwnershipTransferred(
76         address indexed previousOwner,
77         address indexed newOwner
78     );
79 
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function transferOwnership(address newOwner) public onlyOwner {
86         require(newOwner != address(0));
87         OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89     }
90 
91     function renounceOwnership() public onlyOwner {
92         OwnershipRenounced(owner);
93         owner = address(0);
94     }
95 }
96 
97 contract BurnToken is BaseToken {
98     event Burn(address indexed from, uint256 value);
99 
100     function burn(uint256 _value) public returns (bool success) {
101         require(balanceOf[msg.sender] >= _value);
102         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
103         totalSupply = totalSupply.sub(_value);
104         Burn(msg.sender, _value);
105         return true;
106     }
107 
108     function burnFrom(address _from, uint256 _value) public returns (bool success) {
109         require(balanceOf[_from] >= _value);
110         require(_value <= allowance[_from][msg.sender]);
111         balanceOf[_from] = balanceOf[_from].sub(_value);
112         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
113         totalSupply = totalSupply.sub(_value);
114         Burn(_from, _value);
115         return true;
116     }
117 }
118 
119 contract AirdropToken is BaseToken, Ownable{
120     uint256 public airAmount;
121     address public airSender;
122     uint256 public airLimitCount;
123 
124     mapping (address => uint256) public airCountOf;
125 
126     event Airdrop(address indexed from, uint256 indexed count, uint256 tokenValue);
127 
128     function airdrop() public {
129         require(airAmount > 0);
130         if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {
131             revert();
132         }
133         _transfer(airSender, msg.sender, airAmount);
134         airCountOf[msg.sender] = airCountOf[msg.sender].add(1);
135         Airdrop(msg.sender, airCountOf[msg.sender], airAmount);
136     }
137 
138     function changeAirAmount(uint256 newAirAmount) public onlyOwner {
139         airAmount = newAirAmount;
140     }
141 
142     function changeAirLimitCount(uint256 newAirLimitCount) public onlyOwner {
143         airLimitCount = newAirLimitCount;
144     }
145 }
146 
147 contract LockToken is BaseToken {
148     struct LockMeta {
149         uint256 remain;
150         uint256 endtime;
151     }
152     
153     mapping (address => LockMeta[]) public lockedAddresses;
154 
155     function _transfer(address _from, address _to, uint _value) internal {
156         require(balanceOf[_from] >= _value);
157         uint256 remain = balanceOf[_from].sub(_value);
158         uint256 length = lockedAddresses[_from].length;
159         for (uint256 i = 0; i < length; i++) {
160             LockMeta storage meta = lockedAddresses[_from][i];
161             //拒绝转账
162             if(block.timestamp < meta.endtime && remain < meta.remain){
163                 revert();
164             }
165         }
166 		//放行
167         super._transfer(_from, _to, _value);
168     }
169 }
170 
171 contract TTest is BaseToken, BurnToken, AirdropToken, LockToken {
172 
173     function TTest() public {
174         totalSupply = 36000000000000000;
175         name = "ABCToken";
176         symbol = "ABC";
177         decimals = 8;
178 		
179         owner = msg.sender;
180 
181         airAmount = 100000000;
182         airSender = 0x8888888888888888888888888888888888888888;
183         airLimitCount = 1;
184 
185   
186         balanceOf[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920] = 3600000000000000;
187         Transfer(address(0), 0x7F268F51f3017C3dDB9A343C8b5345918D2AB920, 3600000000000000);
188         lockedAddresses[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920].push(LockMeta({remain: 3600000000000000, endtime: 1528189200}));
189         lockedAddresses[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920].push(LockMeta({remain: 3240000000000000, endtime: 1528192800}));
190         lockedAddresses[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920].push(LockMeta({remain: 2880000000000000, endtime: 1528196400}));
191         lockedAddresses[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920].push(LockMeta({remain: 2520000000000000, endtime: 1528200000}));
192         lockedAddresses[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920].push(LockMeta({remain: 2160000000000000, endtime: 1528203600}));
193         lockedAddresses[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920].push(LockMeta({remain: 1800000000000000, endtime: 1528207200}));
194         lockedAddresses[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920].push(LockMeta({remain: 1440000000000000, endtime: 1528210800}));
195         lockedAddresses[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920].push(LockMeta({remain: 1080000000000000, endtime: 1528214400}));
196         lockedAddresses[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920].push(LockMeta({remain: 720000000000000, endtime: 1528218000}));
197         lockedAddresses[0x7F268F51f3017C3dDB9A343C8b5345918D2AB920].push(LockMeta({remain: 360000000000000, endtime: 1528221600}));
198 
199 
200         balanceOf[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3] = 3600000000000000;
201         Transfer(address(0), 0xE4CB2A481375E0208580194BD38911eE6c2d3fA3, 3600000000000000);
202         lockedAddresses[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3].push(LockMeta({remain: 3600000000000000, endtime: 1528189200}));
203         lockedAddresses[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3].push(LockMeta({remain: 3240000000000000, endtime: 1528192800}));
204         lockedAddresses[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3].push(LockMeta({remain: 2880000000000000, endtime: 1528196400}));
205         lockedAddresses[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3].push(LockMeta({remain: 2520000000000000, endtime: 1528200000}));
206         lockedAddresses[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3].push(LockMeta({remain: 2160000000000000, endtime: 1528203600}));
207         lockedAddresses[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3].push(LockMeta({remain: 1800000000000000, endtime: 1528207200}));
208         lockedAddresses[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3].push(LockMeta({remain: 1440000000000000, endtime: 1528210800}));
209         lockedAddresses[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3].push(LockMeta({remain: 1080000000000000, endtime: 1528214400}));
210         lockedAddresses[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3].push(LockMeta({remain: 720000000000000, endtime: 1528218000}));
211         lockedAddresses[0xE4CB2A481375E0208580194BD38911eE6c2d3fA3].push(LockMeta({remain: 360000000000000, endtime: 1528221600}));
212 
213 
214         balanceOf[0x6a15b2BeC95243996416F6baBd8f288f7B4a8312] = 3600000000000000;
215         Transfer(address(0), 0x6a15b2BeC95243996416F6baBd8f288f7B4a8312, 3600000000000000);
216 
217 
218         balanceOf[0x0863f878b6a1d9271CB5b775394Ff8AF2689456f] = 10800000000000000;
219         Transfer(address(0), 0x0863f878b6a1d9271CB5b775394Ff8AF2689456f, 10800000000000000);
220 
221 
222         balanceOf[0x73149136faFc31E1bA03dC240F5Ad903F2E1aE2e] = 3564000000000000;
223         Transfer(address(0), 0x73149136faFc31E1bA03dC240F5Ad903F2E1aE2e, 3564000000000000);
224         lockedAddresses[0x73149136faFc31E1bA03dC240F5Ad903F2E1aE2e].push(LockMeta({remain: 1663200000000000, endtime: 1528182000}));
225         lockedAddresses[0x73149136faFc31E1bA03dC240F5Ad903F2E1aE2e].push(LockMeta({remain: 1188000000000000, endtime: 1528181400}));
226 
227 
228         balanceOf[0xF63ce8e24d18FAF8D5719f192039145D010c7aBd] = 10836000000000000;
229         Transfer(address(0), 0xF63ce8e24d18FAF8D5719f192039145D010c7aBd, 10836000000000000);
230         lockedAddresses[0xF63ce8e24d18FAF8D5719f192039145D010c7aBd].push(LockMeta({remain: 2167200000000000, endtime: 1528182000}));
231     }
232     
233     function() public {
234         airdrop();
235     }
236 }