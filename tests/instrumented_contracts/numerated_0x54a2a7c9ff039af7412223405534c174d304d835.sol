1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
7         // benefit is lost if 'b' is also tested.
8         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         // uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return a / b;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract BaseToken {
37     using SafeMath for uint256;
38 
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42     uint256 public totalSupply;
43 
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 
50     function _transfer(address _from, address _to, uint _value) internal {
51         require(_to != address(0));
52         require(balanceOf[_from] >= _value);
53         balanceOf[_from] = balanceOf[_from].sub(_value);
54         balanceOf[_to] = balanceOf[_to].add(_value);
55         Transfer(_from, _to, _value);
56     }
57 
58     function transfer(address _to, uint256 _value) public returns (bool success) {
59         _transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
64         require(_value <= allowance[_from][msg.sender]);
65         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
66         _transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function approve(address _spender, uint256 _value) public returns (bool success) {
71         allowance[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 }
76 
77 contract Ownable {
78     address public owner;
79 
80     event OwnershipRenounced(address indexed previousOwner);
81     event OwnershipTransferred(
82         address indexed previousOwner,
83         address indexed newOwner
84     );
85 
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     function transferOwnership(address newOwner) public onlyOwner {
92         require(newOwner != address(0));
93         OwnershipTransferred(owner, newOwner);
94         owner = newOwner;
95     }
96 
97     function renounceOwnership() public onlyOwner {
98         OwnershipRenounced(owner);
99         owner = address(0);
100     }
101 }
102 
103 contract BurnToken is BaseToken {
104     event Burn(address indexed from, uint256 value);
105 
106     function burn(uint256 _value) public returns (bool success) {
107         require(balanceOf[msg.sender] >= _value);
108         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
109         totalSupply = totalSupply.sub(_value);
110         Burn(msg.sender, _value);
111         return true;
112     }
113 
114     function burnFrom(address _from, uint256 _value) public returns (bool success) {
115         require(balanceOf[_from] >= _value);
116         require(_value <= allowance[_from][msg.sender]);
117         balanceOf[_from] = balanceOf[_from].sub(_value);
118         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
119         totalSupply = totalSupply.sub(_value);
120         Burn(_from, _value);
121         return true;
122     }
123 }
124 
125 contract AirdropToken is BaseToken, Ownable {
126     uint256 public airAmount;
127     address public airSender;
128     uint256 public airLimitCount;
129 
130     mapping (address => uint256) public airCountOf;
131 
132     event Airdrop(address indexed from, uint256 indexed count, uint256 tokenValue);
133 
134     function airdrop() public {
135         require(airAmount > 0);
136         if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {
137             revert();
138         }
139         _transfer(airSender, msg.sender, airAmount);
140         airCountOf[msg.sender] = airCountOf[msg.sender].add(1);
141         Airdrop(msg.sender, airCountOf[msg.sender], airAmount);
142     }
143 
144     function changeAirAmount(uint256 newAirAmount) public onlyOwner {
145         airAmount = newAirAmount;
146     }
147 
148     function changeAirLimitCount(uint256 newAirLimitCount) public onlyOwner {
149         airLimitCount = newAirLimitCount;
150     }
151 }
152 
153 contract LockToken is BaseToken {
154     struct LockMeta {
155         uint256 remain;
156         uint256 endtime;
157     }
158     
159     mapping (address => LockMeta[]) public lockedAddresses;
160 
161     function _transfer(address _from, address _to, uint _value) internal {
162         require(balanceOf[_from] >= _value);
163         uint256 remain = balanceOf[_from].sub(_value);
164         uint256 length = lockedAddresses[_from].length;
165         for (uint256 i = 0; i < length; i++) {
166             LockMeta storage meta = lockedAddresses[_from][i];
167             if(block.timestamp < meta.endtime && remain < meta.remain){
168                 revert();
169             }
170         }
171         super._transfer(_from, _to, _value);
172     }
173 }
174 
175 contract ADEToken is BaseToken, BurnToken, AirdropToken, LockToken {
176 
177     function ADEToken() public {
178         totalSupply = 36000000000000000;
179         name = "ADE Token";
180         symbol = "ADE";
181         decimals = 8;
182 		
183         owner = msg.sender;
184 
185         airAmount = 100000000;
186         airSender = 0x8888888888888888888888888888888888888888;
187         airLimitCount = 1;
188 
189         //基金会持有
190         balanceOf[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7] = 3600000000000000;
191         Transfer(address(0), 0xf03A4f01713F38EB7d63C6e691C956E8C56630F7, 3600000000000000);
192         //创世块 至 2019/06/07 23:59:59
193         lockedAddresses[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7].push(LockMeta({remain: 3600000000000000, endtime: 1559923200}));
194         //2019/06/08 00:00:00 至 2019/07/07 23:59:59
195         lockedAddresses[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7].push(LockMeta({remain: 3240000000000000, endtime: 1562515200}));
196         //2019/07/08 00:00:00 至 2019/08/07 23:59:59
197         lockedAddresses[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7].push(LockMeta({remain: 2880000000000000, endtime: 1565193600}));
198         //2019/08/08 00:00:00 至 2019/09/07 23:59:59
199         lockedAddresses[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7].push(LockMeta({remain: 2520000000000000, endtime: 1567872000}));
200         //2019/09/08 00:00:00 至 2019/10/07 23:59:59
201         lockedAddresses[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7].push(LockMeta({remain: 2160000000000000, endtime: 1570464000}));
202         //2019/10/08 00:00:00 至 2019/11/07 23:59:59
203         lockedAddresses[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7].push(LockMeta({remain: 1800000000000000, endtime: 1573142400}));
204         //2019/11/08 00:00:00 至 2019/12/07 23:59:59
205         lockedAddresses[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7].push(LockMeta({remain: 1440000000000000, endtime: 1575734400}));
206         //2019/12/08 00:00:00 至 2020/01/07 23:59:59
207         lockedAddresses[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7].push(LockMeta({remain: 1080000000000000, endtime: 1578412800}));
208         //2020/01/08 00:00:00 至 2020/02/07 23:59:59
209         lockedAddresses[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7].push(LockMeta({remain: 720000000000000, endtime: 1581091200}));
210         //2020/02/08 00:00:00 至 2020/03/07 23:59:59
211         lockedAddresses[0xf03A4f01713F38EB7d63C6e691C956E8C56630F7].push(LockMeta({remain: 360000000000000, endtime: 1583596800}));
212         
213         //团队持有
214         balanceOf[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20] = 3600000000000000;
215         Transfer(address(0), 0x76d2dbf2b1e589ff28EcC9203EA781f490696d20, 3600000000000000);
216         //创世块 至 2018/12/07 23:59:59
217         lockedAddresses[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20].push(LockMeta({remain: 3600000000000000, endtime: 1544198400}));
218         //2018/12/08 00:00:00 至 2019/01/07 23:59:59
219         lockedAddresses[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20].push(LockMeta({remain: 3240000000000000, endtime: 1546876800}));
220         //2019/01/08 00:00:00 至 2019/02/07 23:59:59
221         lockedAddresses[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20].push(LockMeta({remain: 2880000000000000, endtime: 1549555200}));
222         //2019/02/08 00:00:00 至 2019/03/07 23:59:59
223         lockedAddresses[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20].push(LockMeta({remain: 2520000000000000, endtime: 1551974400}));
224         //2019/03/08 00:00:00 至 2019/04/07 23:59:59
225         lockedAddresses[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20].push(LockMeta({remain: 2160000000000000, endtime: 1554652800}));
226         //2019/04/08 00:00:00 至 2019/05/07 23:59:59
227         lockedAddresses[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20].push(LockMeta({remain: 1800000000000000, endtime: 1557244800}));
228         //2019/05/08 00:00:00 至 2019/06/07 23:59:59
229         lockedAddresses[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20].push(LockMeta({remain: 1440000000000000, endtime: 1559923200}));
230         //2019/06/08 00:00:00 至 2019/07/07 23:59:59
231         lockedAddresses[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20].push(LockMeta({remain: 1080000000000000, endtime: 1562515200}));
232         //2019/07/08 00:00:00 至 2019/08/07 23:59:59
233         lockedAddresses[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20].push(LockMeta({remain: 720000000000000, endtime: 1565193600}));
234         //2019/08/08 00:00:00 至 2019/09/07 23:59:59
235         lockedAddresses[0x76d2dbf2b1e589ff28EcC9203EA781f490696d20].push(LockMeta({remain: 360000000000000, endtime: 1567872000}));
236 
237         //市场营销
238         balanceOf[0x62d545CD7e67abA36e92c46cfA764c0f1626A9Ae] = 3600000000000000;
239         Transfer(address(0), 0x62d545CD7e67abA36e92c46cfA764c0f1626A9Ae, 3600000000000000);
240 
241         //激励
242         balanceOf[0x8EaA35b0794ebFD412765DFb2Faa770Abae0f36b] = 10800000000000000;
243         Transfer(address(0), 0x8EaA35b0794ebFD412765DFb2Faa770Abae0f36b, 10800000000000000);
244 
245         //基石轮
246         balanceOf[0x8ECeAd3B4c2aD7C4854a42F93A956F5e3CAE9Fd2] = 3564000000000000;
247         Transfer(address(0), 0x8ECeAd3B4c2aD7C4854a42F93A956F5e3CAE9Fd2, 3564000000000000);
248         //创世块 至 2018/09/07 23:59:59
249         lockedAddresses[0x8ECeAd3B4c2aD7C4854a42F93A956F5e3CAE9Fd2].push(LockMeta({remain: 1663200000000000, endtime: 1536336000}));
250         //2018/09/08 00:00:00 至 2018/12/07 23:59:59
251         lockedAddresses[0x8ECeAd3B4c2aD7C4854a42F93A956F5e3CAE9Fd2].push(LockMeta({remain: 1188000000000000, endtime: 1544198400}));
252 
253         //机构轮
254         balanceOf[0xC458A9017d796b2b4b76b416f814E1A8Ce82e310] = 10836000000000000;
255         Transfer(address(0), 0xC458A9017d796b2b4b76b416f814E1A8Ce82e310, 10836000000000000);
256         //创世块 至 2018/09/07 23:59:59
257         lockedAddresses[0xC458A9017d796b2b4b76b416f814E1A8Ce82e310].push(LockMeta({remain: 2167200000000000, endtime: 1536336000}));
258     }
259     
260     function() public {
261         airdrop();
262     }
263 }