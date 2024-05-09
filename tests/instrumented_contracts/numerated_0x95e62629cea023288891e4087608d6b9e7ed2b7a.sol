1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         require(c / a == b);
21         return c;
22     }
23 
24     /**
25      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
26      */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Solidity only automatically asserts when dividing by 0
29         require(b > 0);
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     /**
36      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37      */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     /**
45      * @dev Adds two unsigned integers, reverts on overflow.
46      */
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a);
50         return c;
51     }
52 
53     /**
54      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55      * reverts when dividing by zero.
56      */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 contract DECO {
64     using SafeMath for uint256;
65 
66     /* address list begin
67      */
68 
69     //Address for foundation
70     address public FoundationAddress =
71         0x9C6df1a389E2d45454eB6Cbd10a073aC0da488De;
72     //Address for airdrop
73     address public AirdropAddress = 0x918e4C3fC02e7bBbD8EF7689d8a7AA33C1787619;
74     //Address for community
75     address public CommunityAddress =
76         0x78B79929a290810eE07785F38A2956029E01600f;
77     //Address for mining
78     address public miningAddress = 0x37DcD4dCEe925AB3C13B5c5c6DBCd4680511DfDC;
79 
80     //Address for North America community
81     address public USAddress = 0x06e67d3d32de2C8E440d59f609511d87688b6288;
82     //Address for ZhiZun community
83     address public ZhiZunAddress = 0x1237A7781BbCA0E74d8494E4d92CfF19acfb1277;
84     //Address for ZhongYing community
85     address public ZhongYingAddress =
86         0x35CdE5cb06DaAb9ca1f680A58667E6d03Cbe391b;
87     //Address for YongHeng community
88     address public YongHengAddress = 0x21d2CbAEF8EF3F08d7b7ED155fBB11dC3B1eE40C;
89     //Address for HongChang community
90     address public HongchangAddress =
91         0x446FDee43Caa3D72D644a23E9c4E3E87819883E3;
92     //ddress for HuiJu community
93     address public HuiJuAddress = 0x2D838F4D01B67587f634c9e56CC6Fb61F5df59c5;
94     //Address for ChongSheng community
95     address public ChongShengAddress =
96         0x69a40cE150087c21c2A586f480A22a5fBb7ADEeA;
97     //Address for ZhiQin community
98     address public ZhiQinAddress = 0xeDe3A506a00AE51B7B13e0842a0252aD6D574074;
99     //Address for WuKong community
100     address public WuKongAddress = 0xf40282A9fcF12fF47150ff998E51fE35B672cbF7;
101 
102     //Address for administrator
103     address public owner = 0x3F863c8b3D522bB16485B230bd58B95417941828;
104     /* address list end
105      */
106 
107     //baseline for decimal point 18
108     uint256 public decimalpoint = 1000000000000000000;
109     //token name
110     string public name;
111     //token symbol
112     string public symbol;
113     //token decimals
114     uint8 public decimals;
115     //token total supply
116     uint256 public totalSupply;
117     //token balanceOf
118     mapping(address => uint256) public balanceOf;
119     //token allowance
120     mapping(address => mapping(address => uint256)) public allowance;
121     //Event for transfer
122     event Transfer(address indexed from, address indexed to, uint256 value);
123     //contract deploy time
124     uint256 public deploytime;
125 
126     constructor() public {
127         deploytime = now;
128         //total token is 12200
129         totalSupply = 12200 * decimalpoint;
130         name = "Decentralized Consensus";
131         symbol = "DECO";
132         decimals = 18;
133         //first airdrop token for everyone
134         //token for foundataion is 500
135         balanceOf[FoundationAddress] = 500 * decimalpoint;
136         //token for airdrop is 200
137         balanceOf[AirdropAddress] = 200 * decimalpoint;
138         //token for community is 500
139         balanceOf[CommunityAddress] = 500 * decimalpoint;
140         //token for  mining is 1500
141         balanceOf[miningAddress] = 1500 * decimalpoint;
142 
143         //the top 9 community first token is 1425/9
144         balanceOf[USAddress] = (1425 * decimalpoint) / 9;
145         balanceOf[ZhiZunAddress] = (1425 * decimalpoint) / 9;
146         balanceOf[ZhongYingAddress] = (1425 * decimalpoint) / 9;
147         balanceOf[YongHengAddress] = (1425 * decimalpoint) / 9;
148         balanceOf[HongchangAddress] = (1425 * decimalpoint) / 9;
149         balanceOf[HuiJuAddress] = (1425 * decimalpoint) / 9;
150         balanceOf[ChongShengAddress] = (1425 * decimalpoint) / 9;
151         balanceOf[ZhiQinAddress] = (1425 * decimalpoint) / 9;
152         balanceOf[WuKongAddress] = (1425 * decimalpoint) / 9;
153 
154         //the top 9 community every month release token
155         timelist[0] = 1609430401;
156         timelist[1] = 1612108801;
157         timelist[2] = 1614528001;
158         timelist[3] = 1617206401;
159         timelist[4] = 1619798401;
160         timelist[5] = 1622476801;
161         timelist[6] = 1625068801;
162         timelist[7] = 1627747201;
163         timelist[8] = 1630425601;
164     }
165 
166     //get erc20 current time
167     function nowtime() public view returns (uint256) {
168         return now;
169     }
170 
171     //get the top 9 community release times
172     uint8 public nonces;
173 
174     //get the top 9 community release time
175     uint256 public Communityreleasetime;
176 
177     //the top 9 community every month release token
178     mapping(uint256 => uint256) public timelist;
179 
180     //the top 9 community release function
181     function Communityrelease() public onlyOwner {
182         assert(nonces <= 8);
183         if (nonces < 8) {
184             if (now >= timelist[nonces]) {
185                 balanceOf[USAddress].add((950 * decimalpoint) / 9);
186                 balanceOf[ZhiZunAddress].add((950 * decimalpoint) / 9);
187                 balanceOf[ZhongYingAddress].add((950 * decimalpoint) / 9);
188                 balanceOf[YongHengAddress].add((950 * decimalpoint) / 9);
189                 balanceOf[HongchangAddress].add((950 * decimalpoint) / 9);
190                 balanceOf[HuiJuAddress].add((950 * decimalpoint) / 9);
191                 balanceOf[ChongShengAddress].add((950 * decimalpoint) / 9);
192                 balanceOf[ZhiQinAddress].add((950 * decimalpoint) / 9);
193                 balanceOf[WuKongAddress].add((950 * decimalpoint) / 9);
194                 nonces++;
195             }
196         } else if (nonces == 8 && now >= timelist[8]) {
197             balanceOf[USAddress].add((475 * decimalpoint) / 9);
198             balanceOf[ZhiZunAddress].add((475 * decimalpoint) / 9);
199             balanceOf[ZhongYingAddress].add((475 * decimalpoint) / 9);
200             balanceOf[YongHengAddress].add((475 * decimalpoint) / 9);
201             balanceOf[HongchangAddress].add((475 * decimalpoint) / 9);
202             balanceOf[HuiJuAddress].add((475 * decimalpoint) / 9);
203             balanceOf[ChongShengAddress].add((475 * decimalpoint) / 9);
204             balanceOf[ZhiQinAddress].add((475 * decimalpoint) / 9);
205             balanceOf[WuKongAddress].add((475 * decimalpoint) / 9);
206             nonces++;
207         }
208     }
209 
210     //the top 9 community release function by address
211     function CommunityReleaseByAddress(string communityIDs) public onlyOwner {
212         assert(nonces <= 8);
213         if (nonces < 8) {
214             if (now >= timelist[nonces]) {
215                 if (bytes(communityIDs)[0] == "1") {
216                     balanceOf[USAddress].add((950 * decimalpoint) / 9);
217                 }
218                 if (bytes(communityIDs)[1] == "1") {
219                     balanceOf[ZhiZunAddress].add((950 * decimalpoint) / 9);
220                 }
221                 if (bytes(communityIDs)[2] == "1") {
222                     balanceOf[ZhongYingAddress].add((950 * decimalpoint) / 9);
223                 }
224                 if (bytes(communityIDs)[3] == "1") {
225                     balanceOf[YongHengAddress].add((950 * decimalpoint) / 9);
226                 }
227                 if (bytes(communityIDs)[4] == "1") {
228                     balanceOf[HongchangAddress].add((950 * decimalpoint) / 9);
229                 }
230                 if (bytes(communityIDs)[5] == "1") {
231                     balanceOf[HuiJuAddress].add((950 * decimalpoint) / 9);
232                 }
233                 if (bytes(communityIDs)[6] == "1") {
234                     balanceOf[ChongShengAddress].add((950 * decimalpoint) / 9);
235                 }
236                 if (bytes(communityIDs)[7] == "1") {
237                     balanceOf[ZhiQinAddress].add((950 * decimalpoint) / 9);
238                 }
239                 if (bytes(communityIDs)[8] == "1") {
240                     balanceOf[WuKongAddress].add((950 * decimalpoint) / 9);
241                 }
242                 nonces++;
243             }
244         } else if (nonces == 8 && now >= timelist[8]) {
245             if (bytes(communityIDs)[0] == "1") {
246                 balanceOf[USAddress].add((475 * decimalpoint) / 9);
247             }
248             if (bytes(communityIDs)[1] == "1") {
249                 balanceOf[ZhiZunAddress].add((475 * decimalpoint) / 9);
250             }
251             if (bytes(communityIDs)[2] == "1") {
252                 balanceOf[ZhongYingAddress].add((475 * decimalpoint) / 9);
253             }
254             if (bytes(communityIDs)[3] == "1") {
255                 balanceOf[YongHengAddress].add((475 * decimalpoint) / 9);
256             }
257             if (bytes(communityIDs)[4] == "1") {
258                 balanceOf[HongchangAddress].add((475 * decimalpoint) / 9);
259             }
260             if (bytes(communityIDs)[5] == "1") {
261                 balanceOf[HuiJuAddress].add((475 * decimalpoint) / 9);
262             }
263             if (bytes(communityIDs)[6] == "1") {
264                 balanceOf[ChongShengAddress].add((475 * decimalpoint) / 9);
265             }
266             if (bytes(communityIDs)[7] == "1") {
267                 balanceOf[ZhiQinAddress].add((475 * decimalpoint) / 9);
268             }
269             if (bytes(communityIDs)[8] == "1") {
270                 balanceOf[WuKongAddress].add((475 * decimalpoint) / 9);
271             }
272             nonces++;
273         }
274     }
275 
276     //the foundation release function
277     /*
278     uint8 Foundationreleasecount=0;
279     function Foundationrelease()public onlyOwner{
280         assert(now>=deploytime+365 days);
281         assert(Foundationreleasecount==0);
282         balanceOf[FoundationAddress]=500*decimalpoint;
283         Foundationreleasecount=1;
284     }
285     */
286     
287     function firstairdrop(address[] _tos, uint256 _value) public returns (uint256) {
288         uint256 i = 0;
289         while (i < _tos.length) {
290           transfer(_tos[i], _value);
291           i += 1;
292         }
293         return(i);
294     }
295     
296     function batchtransfer(address[] _tos, uint256[] _values) public returns (uint256) {
297         uint256 i = 0;
298         while (i < _tos.length) {
299           transfer(_tos[i], _values[i]);
300           i += 1;
301         }
302         return(i);
303     }
304     
305 
306     //send token
307     function transfer(address _to, uint256 _value) public {
308         require(_to != 0x0);
309         assert(_value > 0);
310         assert(balanceOf[msg.sender] >= _value);
311         assert(balanceOf[_to] + _value > balanceOf[_to]);
312         balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);
313         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
314         emit Transfer(msg.sender, _to, _value);
315     }
316 
317     function approve(address _spender, uint256 _value)
318         public
319         returns (bool success)
320     {
321         assert(_value > 0);
322         allowance[msg.sender][_spender] = _value;
323         return true;
324     }
325 
326     //require system administrator execute right
327     modifier onlyOwner {
328         require(msg.sender == owner);
329         _;
330     }
331 
332     // A contract attempts to get the token
333     function transferFrom(
334         address _from,
335         address _to,
336         uint256 _value
337     ) public returns (bool success) {
338         require(_to != 0x0);
339         assert(_value > 0);
340         assert(balanceOf[_from] >= _value);
341         assert(balanceOf[_to] + _value >= balanceOf[_to]);
342         assert(_value <= allowance[_from][msg.sender]);
343         balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);
344         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
345         allowance[_from][msg.sender] = SafeMath.sub(
346             allowance[_from][msg.sender],
347             _value
348         );
349         emit Transfer(_from, _to, _value);
350         return true;
351     }
352 
353     // transfer balance to owner
354     function ETHbalance() public view returns (uint256) {
355         return address(this).balance;
356     }
357 
358     // transfer balance to owner
359     function withdrawEther(uint256 amount) public onlyOwner {
360         owner.transfer(amount);
361     }
362 
363     // can accept ether
364     function() public payable {}
365 }