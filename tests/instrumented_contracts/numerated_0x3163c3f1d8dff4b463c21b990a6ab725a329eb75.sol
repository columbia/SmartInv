1 pragma solidity ^0.4.10;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 contract BasicToken is ERC20Basic {
38   using SafeMath for uint256;
39 
40   mapping(address => uint256) balances;
41 
42   function transfer(address _to, uint256 _value) public returns (bool) {
43     require(_to != address(0));
44 
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   function balanceOf(address _owner) public constant returns (uint256 balance) {
52     return balances[_owner];
53   }
54 
55 }
56 
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public constant returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract StandardToken is ERC20, BasicToken {
65 
66   mapping (address => mapping (address => uint256)) allowed;
67 
68 
69   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71 
72     uint256 _allowance = allowed[_from][msg.sender];
73 
74     balances[_from] = balances[_from].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     allowed[_from][msg.sender] = _allowance.sub(_value);
77     Transfer(_from, _to, _value);
78     return true;
79   }
80 
81   function approve(address _spender, uint256 _value) public returns (bool) {
82     allowed[msg.sender][_spender] = _value;
83     Approval(msg.sender, _spender, _value);
84     return true;
85   }
86 
87   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88     return allowed[_owner][_spender];
89   }
90 
91   function increaseApproval (address _spender, uint _addedValue)
92     returns (bool success) {
93     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
94     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
95     return true;
96   }
97 
98   function decreaseApproval (address _spender, uint _subtractedValue)
99     returns (bool success) {
100     uint oldValue = allowed[msg.sender][_spender];
101     if (_subtractedValue > oldValue) {
102       allowed[msg.sender][_spender] = 0;
103     } else {
104       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
105     }
106     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110 }
111 
112 contract CccTokenIco is StandardToken {
113     using SafeMath for uint256;
114     string public name = "Crypto Credit Card Token";
115     string public symbol = "CCCR";
116     uint8 public constant decimals = 6;
117     
118     uint256 public cntMembers = 0;
119     uint256 public totalSupply = 200000000 * (uint256(10) ** decimals);
120     uint256 public totalRaised;
121 
122     uint256 public startTimestamp;
123     uint256 public durationSeconds = uint256(86400 * 93);//93 days - 15/11/17-16/02/18
124 
125     uint256 public minCap = 3000000 * (uint256(10) ** decimals);
126     uint256 public maxCap = 200000000 * (uint256(10) ** decimals);
127     
128     uint256 public avgRate = uint256(uint256(10)**(18-decimals)).div(707);
129 
130     address public stuff = 0x0CcCb9bAAdD61F9e0ab25bD782765013817821bD;
131     address public teama = 0xfc6851324e2901b3ea6170a90Cc43BFe667D617A;
132     address public teamb = 0x21f0F5E81BEF4dc696C6BF0196c60a1aC797f953;
133     address public teamc = 0xE8726942a46E6C6B3C1F061c14a15c0053A97B6b;
134     address public teamd = 0xe388423Bc655543568dd5b454F47AeD2B304710F;
135     address public teame = 0xa31B987F467aFF700F322105126619496955f503;
136     address public founder = 0xbb2efFab932a4c2f77Fc1617C1a563738D71B0a7;
137     address public baseowner;
138 
139     event LogTransfer(address sender, address to, uint amount);
140     event Clearing(address to, uint256 amount);
141 
142     function CccTokenIco(
143     ) 
144     {
145         cntMembers = 0;
146         startTimestamp = now - 34 days;//19.12.2017
147         baseowner = msg.sender;
148         balances[baseowner] = totalSupply;
149         Transfer(0x0, baseowner, totalSupply);
150 
151         ///carry out token holders from previous contract instance
152         
153         balances[baseowner] = balances[baseowner].sub(500003530122);
154         balances[0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12] = balances[0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12].add(500003530122);
155         Transfer(baseowner, 0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12, 500003530122);
156 
157         balances[baseowner] = balances[baseowner].sub(276000000009);
158         balances[0xaa00a534093975ac45ecac2365e40b2f81cf554b] = balances[0xaa00a534093975ac45ecac2365e40b2f81cf554b].add(276000000009);
159         Transfer(baseowner, 0xaa00a534093975ac45ecac2365e40b2f81cf554b, 276000000009);
160 
161         balances[baseowner] = balances[baseowner].sub(200000000012);
162         balances[0xdaeb100e594bec89aa8282d5b0f54e01100559b0] = balances[0xdaeb100e594bec89aa8282d5b0f54e01100559b0].add(200000000012);
163         Transfer(baseowner, 0xdaeb100e594bec89aa8282d5b0f54e01100559b0, 200000000012);
164 
165         balances[baseowner] = balances[baseowner].sub(31740000001);
166         balances[0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2] = balances[0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2].add(31740000001);
167         Transfer(baseowner, 0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2, 31740000001);
168 
169         balances[baseowner] = balances[baseowner].sub(27318424808);
170         balances[0xedfd6f7b43a4e2cdc39975b61965302c47c523cb] = balances[0xedfd6f7b43a4e2cdc39975b61965302c47c523cb].add(27318424808);
171         Transfer(baseowner, 0xedfd6f7b43a4e2cdc39975b61965302c47c523cb, 27318424808);
172 
173         balances[baseowner] = balances[baseowner].sub(24130680006);
174         balances[0x911af73f46c16f0682c707fdc46b3e5a9b756dfc] = balances[0x911af73f46c16f0682c707fdc46b3e5a9b756dfc].add(24130680006);
175         Transfer(baseowner, 0x911af73f46c16f0682c707fdc46b3e5a9b756dfc, 24130680006);
176 
177         balances[baseowner] = balances[baseowner].sub(15005580557);
178         balances[0x2cec090622838aa3abadd176290dea1bbd506466] = balances[0x2cec090622838aa3abadd176290dea1bbd506466].add(15005580557);
179         Transfer(baseowner, 0x2cec090622838aa3abadd176290dea1bbd506466, 15005580557);
180 
181         balances[baseowner] = balances[baseowner].sub(9660000004);
182         balances[0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1] = balances[0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1].add(9660000004);
183         Transfer(baseowner, 0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1, 9660000004);
184 
185         balances[baseowner] = balances[baseowner].sub(2652719081);
186         balances[0xb63a69b443969139766e5734c50b2049297bf335] = balances[0xb63a69b443969139766e5734c50b2049297bf335].add(2652719081);
187         Transfer(baseowner, 0xb63a69b443969139766e5734c50b2049297bf335, 2652719081);
188 
189         balances[baseowner] = balances[baseowner].sub(2460000000);
190         balances[0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f] = balances[0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f].add(2460000000);
191         Transfer(baseowner, 0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f, 2460000000);
192 
193         balances[baseowner] = balances[baseowner].sub(2351000007);
194         balances[0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd] = balances[0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd].add(2351000007);
195         Transfer(baseowner, 0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd, 2351000007);
196 
197         balances[baseowner] = balances[baseowner].sub(1717313037);
198         balances[0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f] = balances[0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f].add(1717313037);
199         Transfer(baseowner, 0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f, 1717313037);
200 
201         balances[baseowner] = balances[baseowner].sub(1419509002);
202         balances[0x5e454499faec83dc1aa65d9f0164fb558f9bfdef] = balances[0x5e454499faec83dc1aa65d9f0164fb558f9bfdef].add(1419509002);
203         Transfer(baseowner, 0x5e454499faec83dc1aa65d9f0164fb558f9bfdef, 1419509002);
204 
205         balances[baseowner] = balances[baseowner].sub(1265308761);
206         balances[0x77d7ab3250f88d577fda9136867a3e9c2f29284b] = balances[0x77d7ab3250f88d577fda9136867a3e9c2f29284b].add(1265308761);
207         Transfer(baseowner, 0x77d7ab3250f88d577fda9136867a3e9c2f29284b, 1265308761);
208 
209         balances[baseowner] = balances[baseowner].sub(1009138801);
210         balances[0x60a1db27141cbab745a66f162e68103f2a4f2205] = balances[0x60a1db27141cbab745a66f162e68103f2a4f2205].add(1009138801);
211         Transfer(baseowner, 0x60a1db27141cbab745a66f162e68103f2a4f2205, 1009138801);
212 
213         balances[baseowner] = balances[baseowner].sub(941571961);
214         balances[0xab58b3d1866065353bf25dbb813434a216afd99d] = balances[0xab58b3d1866065353bf25dbb813434a216afd99d].add(941571961);
215         Transfer(baseowner, 0xab58b3d1866065353bf25dbb813434a216afd99d, 941571961);
216 
217         balances[baseowner] = balances[baseowner].sub(694928265);
218         balances[0x8b545e68cf9363e09726e088a3660191eb7152e4] = balances[0x8b545e68cf9363e09726e088a3660191eb7152e4].add(694928265);
219         Transfer(baseowner, 0x8b545e68cf9363e09726e088a3660191eb7152e4, 694928265);
220 
221         balances[baseowner] = balances[baseowner].sub(688204065);
222         balances[0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e] = balances[0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e].add(688204065);
223         Transfer(baseowner, 0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e, 688204065);
224 
225         balances[baseowner] = balances[baseowner].sub(671272463);
226         balances[0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17] = balances[0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17].add(671272463);
227         Transfer(baseowner, 0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17, 671272463);
228 
229         balances[baseowner] = balances[baseowner].sub(633682839);
230         balances[0xd912f08de16beecab4cc8f1947c119caf6852cf4] = balances[0xd912f08de16beecab4cc8f1947c119caf6852cf4].add(633682839);
231         Transfer(baseowner, 0xd912f08de16beecab4cc8f1947c119caf6852cf4, 633682839);
232 
233         balances[baseowner] = balances[baseowner].sub(633668277);
234         balances[0xdc4b279fd978d248bef6c783c2c937f75855537e] = balances[0xdc4b279fd978d248bef6c783c2c937f75855537e].add(633668277);
235         Transfer(baseowner, 0xdc4b279fd978d248bef6c783c2c937f75855537e, 633668277);
236 
237         balances[baseowner] = balances[baseowner].sub(632418818);
238         balances[0x7399a52d49139c9593ea40c11f2f296ca037a18a] = balances[0x7399a52d49139c9593ea40c11f2f296ca037a18a].add(632418818);
239         Transfer(baseowner, 0x7399a52d49139c9593ea40c11f2f296ca037a18a, 632418818);
240 
241         balances[baseowner] = balances[baseowner].sub(570202760);
242         balances[0xbb4691d4dff55fb110f996d029900e930060fe48] = balances[0xbb4691d4dff55fb110f996d029900e930060fe48].add(570202760);
243         Transfer(baseowner, 0xbb4691d4dff55fb110f996d029900e930060fe48, 570202760);
244 
245         balances[baseowner] = balances[baseowner].sub(428950000);
246         balances[0x826fa4d3b34893e033b6922071b55c1de8074380] = balances[0x826fa4d3b34893e033b6922071b55c1de8074380].add(428950000);
247         Transfer(baseowner, 0x826fa4d3b34893e033b6922071b55c1de8074380, 428950000);
248 
249         balances[baseowner] = balances[baseowner].sub(334650000);
250         balances[0x12f3f72fb89f86110d666337c6cb49f3db4b15de] = balances[0x12f3f72fb89f86110d666337c6cb49f3db4b15de].add(334650000);
251         Transfer(baseowner, 0x12f3f72fb89f86110d666337c6cb49f3db4b15de, 334650000);
252 
253         balances[baseowner] = balances[baseowner].sub(276000007);
254         balances[0x65f34b34b2c5da1f1469f4165f4369242edbbec5] = balances[0x65f34b34b2c5da1f1469f4165f4369242edbbec5].add(276000007);
255         Transfer(baseowner, 0xbb4691d4dff55fb110f996d029900e930060fe48, 276000007);
256 
257         balances[baseowner] = balances[baseowner].sub(181021555);
258         balances[0x750b5f444a79895d877a821dfce321a9b00e77b3] = balances[0x750b5f444a79895d877a821dfce321a9b00e77b3].add(181021555);
259         Transfer(baseowner, 0x750b5f444a79895d877a821dfce321a9b00e77b3, 181021555);
260 
261         balances[baseowner] = balances[baseowner].sub(143520151);
262         balances[0x8d88391bfcb5d3254f82addba383523907e028bc] = balances[0x8d88391bfcb5d3254f82addba383523907e028bc].add(143520151);
263         Transfer(baseowner, 0x8d88391bfcb5d3254f82addba383523907e028bc, 143520151);
264 
265         balances[baseowner] = balances[baseowner].sub(131825237);
266         balances[0xf0db27cdabcc02ede5aee9574241a84af930f08e] = balances[0xf0db27cdabcc02ede5aee9574241a84af930f08e].add(131825237);
267         Transfer(baseowner, 0xf0db27cdabcc02ede5aee9574241a84af930f08e, 131825237);
268 
269         balances[baseowner] = balances[baseowner].sub(99525370);
270         balances[0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3] = balances[0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3].add(99525370);
271         Transfer(baseowner, 0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3, 99525370);
272 
273 		
274         balances[baseowner] = balances[baseowner].sub(71712001);
275         balances[0xc19aab396d51f7fa9d8a9c147ed77b681626d074] = balances[0xc19aab396d51f7fa9d8a9c147ed77b681626d074].add(71712001);
276         Transfer(baseowner, 0xc19aab396d51f7fa9d8a9c147ed77b681626d074, 71712001);
277 
278         balances[baseowner] = balances[baseowner].sub(69000011);
279         balances[0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461] = balances[0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461].add(69000011);
280         Transfer(baseowner, 0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461, 69000011);
281 
282         balances[baseowner] = balances[baseowner].sub(55873094);
283         balances[0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0] = balances[0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0].add(55873094);
284         Transfer(baseowner, 0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0, 55873094);
285 
286         balances[baseowner] = balances[baseowner].sub(42465543);
287         balances[0xa404999fa8815c53e03d238f3355dce64d7a533a] = balances[0xa404999fa8815c53e03d238f3355dce64d7a533a].add(42465543);
288         Transfer(baseowner, 0xa404999fa8815c53e03d238f3355dce64d7a533a, 42465543);
289 
290         balances[baseowner] = balances[baseowner].sub(40228798);
291         balances[0xdae37bde109b920a41d7451931c0ce7dd824d39a] = balances[0xdae37bde109b920a41d7451931c0ce7dd824d39a].add(40228798);
292         Transfer(baseowner, 0xdae37bde109b920a41d7451931c0ce7dd824d39a, 40228798);
293 
294         balances[baseowner] = balances[baseowner].sub(27600006);
295         balances[0x6f44062ec1287e4b6890c9df34571109894d2d5b] = balances[0x6f44062ec1287e4b6890c9df34571109894d2d5b].add(27600006);
296         Transfer(baseowner, 0x6f44062ec1287e4b6890c9df34571109894d2d5b, 27600006);
297 
298         balances[baseowner] = balances[baseowner].sub(26027997);
299         balances[0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf] = balances[0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf].add(26027997);
300         Transfer(baseowner, 0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf, 26027997);
301 
302         balances[baseowner] = balances[baseowner].sub(13800009);
303         balances[0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8] = balances[0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8].add(13800009);
304         Transfer(baseowner, 0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8, 13800009);
305 
306         balances[baseowner] = balances[baseowner].sub(13463420);
307         balances[0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf] = balances[0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf].add(13463420);
308         Transfer(baseowner, 0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf, 13463420);
309 
310         balances[baseowner] = balances[baseowner].sub(2299998);
311         balances[0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e] = balances[0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e].add(2299998);
312         Transfer(baseowner, 0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e, 2299998);
313 
314         balances[baseowner] = balances[baseowner].sub(1993866);
315         balances[0x74a4d45b8bb857f627229b94cf2b9b74308c61bb] = balances[0x74a4d45b8bb857f627229b94cf2b9b74308c61bb].add(1993866);
316         Transfer(baseowner, 0x74a4d45b8bb857f627229b94cf2b9b74308c61bb, 1993866);
317 
318         cntMembers = cntMembers.add(41);
319 
320     }
321 
322     function bva(address partner, uint256 value, uint256 rate, address adviser) isIcoOpen payable public 
323     {
324       uint256 tokenAmount = calculateTokenAmount(value);
325       if(msg.value != 0)
326       {
327         tokenAmount = calculateTokenCount(msg.value,avgRate);
328       }else
329       {
330         require(msg.sender == stuff);
331         avgRate = avgRate.add(rate).div(2);
332       }
333       if(msg.value != 0)
334       {
335         Clearing(teama, msg.value.mul(6).div(100));
336         teama.transfer(msg.value.mul(6).div(100));
337         Clearing(teamb, msg.value.mul(6).div(1000));
338         teamb.transfer(msg.value.mul(6).div(1000));
339         Clearing(teamc, msg.value.mul(6).div(1000));
340         teamc.transfer(msg.value.mul(6).div(1000));
341         Clearing(teamd, msg.value.mul(1).div(100));
342         teamd.transfer(msg.value.mul(1).div(100));
343         Clearing(teame, msg.value.mul(9).div(1000));
344         teame.transfer(msg.value.mul(9).div(1000));
345         Clearing(stuff, msg.value.mul(9).div(1000));
346         stuff.transfer(msg.value.mul(9).div(1000));
347         Clearing(founder, msg.value.mul(70).div(100));
348         founder.transfer(msg.value.mul(70).div(100));
349         if(partner != adviser)
350         {
351           Clearing(adviser, msg.value.mul(20).div(100));
352           adviser.transfer(msg.value.mul(20).div(100));
353         }else
354         {
355           Clearing(founder, msg.value.mul(20).div(100));
356           founder.transfer(msg.value.mul(20).div(100));
357         } 
358       }
359       totalRaised = totalRaised.add(tokenAmount);
360       balances[baseowner] = balances[baseowner].sub(tokenAmount);
361       balances[partner] = balances[partner].add(tokenAmount);
362       Transfer(baseowner, partner, tokenAmount);
363       cntMembers = cntMembers.add(1);
364     }
365     
366     function() isIcoOpen payable public
367     {
368       if(msg.value != 0)
369       {
370         uint256 tokenAmount = calculateTokenCount(msg.value,avgRate);
371         Clearing(teama, msg.value.mul(6).div(100));
372         teama.transfer(msg.value.mul(6).div(100));
373         Clearing(teamb, msg.value.mul(6).div(1000));
374         teamb.transfer(msg.value.mul(6).div(1000));
375         Clearing(teamc, msg.value.mul(6).div(1000));
376         teamc.transfer(msg.value.mul(6).div(1000));
377         Clearing(teamd, msg.value.mul(1).div(100));
378         teamd.transfer(msg.value.mul(1).div(100));
379         Clearing(teame, msg.value.mul(9).div(1000));
380         teame.transfer(msg.value.mul(9).div(1000));
381         Clearing(stuff, msg.value.mul(9).div(1000));
382         stuff.transfer(msg.value.mul(9).div(1000));
383         Clearing(founder, msg.value.mul(90).div(100));
384         founder.transfer(msg.value.mul(90).div(100));
385         totalRaised = totalRaised.add(tokenAmount);
386         balances[baseowner] = balances[baseowner].sub(tokenAmount);
387         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
388         Transfer(baseowner, msg.sender, tokenAmount);
389         cntMembers = cntMembers.add(1);
390       }
391     }
392 
393     function calculateTokenAmount(uint256 count) constant returns(uint256) 
394     {
395         uint256 icoDeflator = getIcoDeflator();
396         return count.mul(icoDeflator).div(100);
397     }
398 
399     function calculateTokenCount(uint256 weiAmount, uint256 rate) constant returns(uint256) 
400     {
401         if(rate==0)revert();
402         uint256 icoDeflator = getIcoDeflator();
403         return weiAmount.div(rate).mul(icoDeflator).div(100);
404     }
405 
406     function getIcoDeflator() constant returns (uint256)
407     {
408         if (now <= startTimestamp + 14 days)//15.11.2017-29.11.2017 38% 
409         {
410             return 138;
411         }else if (now <= startTimestamp + 46 days)//29.11.2017-31.12.2017 23% 
412         {
413             return 123;
414         }else if (now <= startTimestamp + 60 days)//01.01.2018-14.01.2018 15% 
415         {
416             return 115;
417         }else if (now <= startTimestamp + 74 days)//15.01.2018-28.01.2018
418         {
419             return 109;
420         }else
421         {
422             return 105;
423         }
424     }
425 
426     function finalize(uint256 weiAmount) isIcoFinished isStuff payable public
427     {
428       if(msg.sender == founder)
429       {
430         founder.transfer(weiAmount);
431       }
432     }
433 
434     function transfer(address _to, uint _value) isIcoFinished returns (bool) 
435     {
436         return super.transfer(_to, _value);
437     }
438 
439     function transferFrom(address _from, address _to, uint _value) isIcoFinished returns (bool) 
440     {
441         return super.transferFrom(_from, _to, _value);
442     }
443 
444     modifier isStuff() 
445     {
446         require(msg.sender == stuff || msg.sender == founder);
447         _;
448     }
449 
450     modifier isIcoOpen() 
451     {
452         require(now >= startTimestamp);//15.11-29.11 pre ICO
453         require(now <= startTimestamp + 14 days || now >= startTimestamp + 19 days);//gap 29.11-04.12
454         require(now <= (startTimestamp + durationSeconds) || totalRaised < minCap);//04.12-02.02 ICO
455         require(totalRaised <= maxCap);
456         _;
457     }
458 
459     modifier isIcoFinished() 
460     {
461         require(now >= startTimestamp);
462         require(totalRaised >= maxCap || (now >= (startTimestamp + durationSeconds) && totalRaised >= minCap));
463         _;
464     }
465 
466 }