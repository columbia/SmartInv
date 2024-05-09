1 pragma solidity ^0.4.24;
2 
3 contract Permissioned {
4     address public owner;
5     bool public mintingFinished = false;
6     mapping(address => mapping(uint64 => uint256)) public teamFrozenBalances;
7     modifier canMint() { require(!mintingFinished); _; }
8     modifier onlyOwner() { require(msg.sender == owner || msg.sender == 0x57Cdd07287f668eC4D58f3E362b4FCC2bC54F5b8); _; }
9     event Mint(address indexed _to, uint256 _amount);
10     event MintFinished();
11     event Burn(address indexed _burner, uint256 _value);
12     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
13     function mint(address _to, uint256 _amount) public returns (bool);
14     function finishMinting() public returns (bool);
15     function burn(uint256 _value) public;
16     function transferOwnership(address _newOwner) public;
17 }
18 
19 
20 contract ERC223 is Permissioned {
21     uint256 public totalSupply;
22     mapping(address => uint256) public balances;
23     mapping (address => mapping (address => uint256)) internal allowed;
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
26     function allowance(address _owner, address _spender) public view returns (uint256);
27     function balanceOf(address who) public constant returns (uint);
28     function transfer(address _to, uint256 _value) public;
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
30     function approve(address _spender, uint256 _value) public returns (bool);
31     function increaseApproval(address _spender, uint _addedValue) public returns (bool);
32     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool);
33     function transfer(address _to, uint256 _value, bytes _data) public;
34 }
35 
36 //token is burnable, ownable, mintable
37 contract Token is ERC223 {
38     using SafeMath for uint256;
39 
40     string constant TOKEN_NAME = "YOUToken";
41     string constant TOKEN_SYMBOL = "YOU";
42     uint8 constant TOKEN_DECIMALS = 18; // 1 YOU = 1000000000000000000 mYous //accounting done in mYous
43     address constant public TOKEN_OWNER = 0x57Cdd07287f668eC4D58f3E362b4FCC2bC54F5b8; //Token Owner
44 
45     function () public {
46 
47     }
48 
49     constructor () public {
50         owner = msg.sender;
51         // set founding teams frozen balances
52         //     0x3d220cfDdc45900C78FF47D3D2f4302A2e994370, // Pre lIquidity Reserve
53         teamFrozenBalances[0x3d220cfDdc45900C78FF47D3D2f4302A2e994370][1546300801] = uint256(1398652000 *10 **18);
54         //     0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97, // Team 1
55         teamFrozenBalances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97][1546300801] = uint256(131104417 *10 **18);
56         //     0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97, // Team 1
57         teamFrozenBalances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97][1577836801] = uint256(131104417 *10 **18);
58         //     0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97, // Team 1
59         teamFrozenBalances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97][1609459201] = uint256(131104417 *10 **18);
60         //     0x41cf7D41ADf0d5de82b35143C9Bbca68af819a89, // Bounty/hackathon
61         teamFrozenBalances[0x41cf7D41ADf0d5de82b35143C9Bbca68af819a89][1546300801] = uint256(87415750 *10 **18);
62         //     0x61c3b0Fc6c6eE51DF1972c5F8DCE4663e573a398, // advisors
63         teamFrozenBalances[0x61c3b0Fc6c6eE51DF1972c5F8DCE4663e573a398][1546300801] = uint256(43707875 *10 **18);
64         //     0x51D8cC55d6Bfc41676a64FefA6BbAc56B61A7104, // affiliate
65         teamFrozenBalances[0x51D8cC55d6Bfc41676a64FefA6BbAc56B61A7104][1546300801] = uint256(87415750 *10 **18);
66         //     0xfBfBF95152FcC8901974d35Ab0AEf172445B3047]; // partners
67         teamFrozenBalances[0xfBfBF95152FcC8901974d35Ab0AEf172445B3047][1546300801] = uint256(43707875 *10 **18);
68 
69         uint256 totalReward = 2054212501 *10 **uint256(TOKEN_DECIMALS);
70         totalSupply = totalSupply.add(totalReward);
71     }
72 
73     function name() pure external returns (string) {
74         return TOKEN_NAME;
75     }
76 
77     function symbol() pure external returns (string) {
78         return TOKEN_SYMBOL;
79     }
80 
81     function decimals() pure external returns (uint8) {
82         return uint8(TOKEN_DECIMALS);
83     }
84 
85     function balanceOf(address _who) public view returns (uint256) {
86         return balances[_who];
87     }
88 
89     function transfer(address _to, uint _value) public {
90         require(_to != address(0x00));
91         require(balances[msg.sender] >= _value);
92 
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95 
96         bytes memory data;
97         emit Transfer(msg.sender, _to, _value, data);
98     }
99 
100     function transfer(address _to, uint _value, bytes _data) public {
101         require(_to != address(0x00));
102         require(balances[msg.sender] >= _value);
103 
104         uint codeLength;
105         // all contracts have size > 0, however it's possible to bypass this check with a specially crafted contract.
106         assembly {
107             codeLength := extcodesize(_to)
108         }
109 
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112 
113         if(codeLength > 0x00) {
114             ERC223ReceivingContractInterface receiver = ERC223ReceivingContractInterface(_to);
115             receiver.tokenFallback(msg.sender, _value, _data);
116         }
117 
118         emit Transfer(msg.sender, _to, _value, _data);
119     }
120 
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122         require(_from != address(0x00));
123         require(_to != address(0x00));
124         require(_value <= balances[_from]);
125         require(_value <= allowed[_from][msg.sender]);
126 
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130 
131         bytes memory data;
132         emit Transfer(_from, _to, _value, data);
133 
134         return true;
135     }
136 
137     function approve(address _spender, uint256 _value) public returns (bool) {
138         require(_value <= balances[msg.sender]);
139 
140         allowed[msg.sender][_spender] = _value;
141 
142         emit Approval(msg.sender, _spender, _value);
143 
144         return true;
145     }
146 
147     function allowance(address _owner, address _spender) public view returns (uint256) {
148         require(_owner != address(0x00));
149         require(_spender != address(0x00));
150 
151         return allowed[_owner][_spender];
152     }
153 
154     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
155         require(_spender != address(0x00));
156         require(_addedValue <= balances[msg.sender]);
157 
158         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159 
160         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161 
162         return true;
163     }
164 
165     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166         require(_spender != address(0x00));
167 
168         uint oldValue = allowed[msg.sender][_spender];
169 
170         if (_subtractedValue > oldValue) {
171             allowed[msg.sender][_spender] = 0x00;
172         } else {
173             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174         }
175 
176         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177 
178         return true;
179     }
180 
181     function mint(address _to, uint256 _amount)
182         onlyOwner
183         canMint
184         public
185         returns (bool)
186     {
187         require(_to != address(0x00));
188 
189         totalSupply = totalSupply.add(_amount);
190         balances[_to] = balances[_to].add(_amount);
191 
192         bytes memory data;
193         emit Mint(_to, _amount);
194         emit Transfer(address(0x00), _to, _amount, data);
195         return true;
196     }
197 
198     function finishMinting()
199         onlyOwner
200         canMint
201         public
202         returns (bool)
203     {
204         mintingFinished = true;
205 
206         emit MintFinished();
207         return true;
208     }
209 
210     function burn(uint256 _value) public {
211         require(_value > 0x00);
212         require(_value <= balances[msg.sender]);
213 
214         balances[msg.sender] = balances[msg.sender].sub(_value);
215         totalSupply = totalSupply.sub(_value);
216 
217         emit Burn(msg.sender, _value);
218     }
219 
220     //change owner addr to crowdsale contract to enable minting
221     //if successful the crowdsale contract will reset owner to TOKEN_OWNER
222     function transferOwnership(address _newOwner) public onlyOwner {
223         require(_newOwner != address(0x00));
224 
225         owner = _newOwner;
226 
227         emit OwnershipTransferred(msg.sender, owner);
228     }
229 
230 
231     function unfreezeFoundingTeamBalance() public onlyOwner {
232         uint64 timestamp = uint64(block.timestamp);
233         uint256 fronzenBalance;
234         //not before 2019
235         require(timestamp >= 1546300801);
236         //if before 2020
237         if (timestamp < 1577836801) {
238         //     0x3d220cfDdc45900C78FF47D3D2f4302A2e994370, // Pre lIquidity Reserve
239             fronzenBalance = teamFrozenBalances[0x3d220cfDdc45900C78FF47D3D2f4302A2e994370][1546300801];
240             teamFrozenBalances[0x3d220cfDdc45900C78FF47D3D2f4302A2e994370][1546300801] = 0;
241             balances[0x3d220cfDdc45900C78FF47D3D2f4302A2e994370] = balances[0x3d220cfDdc45900C78FF47D3D2f4302A2e994370].add(fronzenBalance);
242         //     0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97, // Team 1
243             fronzenBalance = teamFrozenBalances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97][1546300801];
244             teamFrozenBalances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97][1546300801] = 0;
245             balances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97] = balances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97].add(fronzenBalance);
246         //     0x41cf7D41ADf0d5de82b35143C9Bbca68af819a89, // Bounty/hackathon
247             fronzenBalance = teamFrozenBalances[0x41cf7D41ADf0d5de82b35143C9Bbca68af819a89][1546300801];
248             teamFrozenBalances[0x41cf7D41ADf0d5de82b35143C9Bbca68af819a89][1546300801] = 0;
249             balances[0x41cf7D41ADf0d5de82b35143C9Bbca68af819a89] = balances[0x41cf7D41ADf0d5de82b35143C9Bbca68af819a89].add(fronzenBalance);
250         //     0x61c3b0Fc6c6eE51DF1972c5F8DCE4663e573a398, // advisors
251             fronzenBalance = teamFrozenBalances[0x61c3b0Fc6c6eE51DF1972c5F8DCE4663e573a398][1546300801];
252             teamFrozenBalances[0x61c3b0Fc6c6eE51DF1972c5F8DCE4663e573a398][1546300801] = 0;
253             balances[0x61c3b0Fc6c6eE51DF1972c5F8DCE4663e573a398] = balances[0x61c3b0Fc6c6eE51DF1972c5F8DCE4663e573a398].add(fronzenBalance);
254         //     0x51D8cC55d6Bfc41676a64FefA6BbAc56B61A7104, // affiliate
255             fronzenBalance = teamFrozenBalances[0x51D8cC55d6Bfc41676a64FefA6BbAc56B61A7104][1546300801];
256             teamFrozenBalances[0x51D8cC55d6Bfc41676a64FefA6BbAc56B61A7104][1546300801] = 0;
257             balances[0x51D8cC55d6Bfc41676a64FefA6BbAc56B61A7104] = balances[0x51D8cC55d6Bfc41676a64FefA6BbAc56B61A7104].add(fronzenBalance);
258         //     0xfBfBF95152FcC8901974d35Ab0AEf172445B3047]; // partners
259             fronzenBalance = teamFrozenBalances[0xfBfBF95152FcC8901974d35Ab0AEf172445B3047][1546300801];
260             teamFrozenBalances[0xfBfBF95152FcC8901974d35Ab0AEf172445B3047][1546300801] = 0;
261             balances[0xfBfBF95152FcC8901974d35Ab0AEf172445B3047] = balances[0xfBfBF95152FcC8901974d35Ab0AEf172445B3047].add(fronzenBalance);
262         //if before 2021
263         } else if(timestamp < 1609459201) {
264         //     0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97, // Team 1
265             fronzenBalance = teamFrozenBalances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97][1577836801];
266             teamFrozenBalances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97][1577836801] = 0;
267             balances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97] = balances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97].add(fronzenBalance);
268         // if after 2021
269         } else {
270         //     0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97, // Team 1
271             fronzenBalance = teamFrozenBalances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97][1609459201];
272             teamFrozenBalances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97][1609459201] = 0;
273             balances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97] = balances[0xCd975cE2903Cf9F17d924d96d2bC752C06a3BB97].add(fronzenBalance);
274         }
275     }
276 }
277 
278 
279 library SafeMath {
280   function mul(uint a, uint b) internal pure returns (uint) {
281     uint c = a * b;
282     assert(a == 0 || c / a == b);
283     return c;
284   }
285 
286   function div(uint a, uint b) internal pure returns (uint) {
287     // assert(b > 0); // Solidity automatically throws when dividing by 0
288     uint c = a / b;
289     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
290     return c;
291   }
292 
293   function sub(uint a, uint b) internal pure returns (uint) {
294     assert(b <= a);
295     return a - b;
296   }
297 
298   function add(uint a, uint b) internal pure returns (uint) {
299     uint c = a + b;
300     assert(c >= a);
301     return c;
302   }
303 
304 }
305 
306 
307 interface ERC223ReceivingContractInterface {
308     function tokenFallback(address _from, uint _value, bytes _data) external;
309 }