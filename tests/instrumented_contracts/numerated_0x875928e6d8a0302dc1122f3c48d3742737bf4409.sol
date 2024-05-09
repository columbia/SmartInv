1 pragma solidity ^ 0.4 .19;
2 
3 contract ERC223ReceivingContract { 
4 /**
5  * @dev Standard ERC223 function that will handle incoming token transfers.
6  *
7  * @param _from  Token sender address.
8  * @param _value Amount of tokens.
9  * @param _data  Transaction metadata.
10  */
11     function tokenFallback(address _from, uint _value, bytes _data);
12 }
13 
14 
15 contract Contract {function XBVHandler( address _from, uint256 _value );}
16 
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 
50 }
51 
52 
53 contract tokenRecipient {
54     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
55 }
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
63         uint256 c = a * b;
64         assert(a == 0 || c / a == b);
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal constant returns(uint256) {
69         // assert(b > 0); // Solidity automatically throws when dividing by 0
70         uint256 c = a / b;
71         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72         return c;
73     }
74 
75     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
76         assert(b <= a);
77         return a - b;
78     }
79 
80     function add(uint256 a, uint256 b) internal constant returns(uint256) {
81         uint256 c = a + b;
82         assert(c >= a);
83         return c;
84     }
85 }
86 
87 
88 contract ERC20 {
89 
90    function totalSupply() constant returns(uint totalSupply);
91 
92     function balanceOf(address who) constant returns(uint256);
93 
94     function transfer(address to, uint value) returns(bool ok);
95 
96     function transferFrom(address from, address to, uint value) returns(bool ok);
97 
98     function approve(address spender, uint value) returns(bool ok);
99 
100     function allowance(address owner, address spender) constant returns(uint);
101     event Transfer(address indexed from, address indexed to, uint value);
102     event Approval(address indexed owner, address indexed spender, uint value);
103 
104 }
105 
106 
107 contract XBV is ERC20  {
108 
109     using SafeMath
110     for uint256;
111     /* Public variables of the token */
112     string public standard = 'XBV 2.0';
113     string public name;
114     string public symbol;
115     uint8 public decimals;
116     uint256 public totalSupply;
117     uint256 public initialSupply;
118     bool initialize;
119 
120     mapping( address => uint256) public balanceOf;
121     mapping(address => mapping(address => uint256)) public allowance;
122 
123     /* This generates a public event on the blockchain that will notify clients */
124     event Transfer(address indexed from, address indexed to, uint256 value);
125     event Transfer(address indexed from, address indexed to, uint value, bytes data);
126     event Approval(address indexed owner, address indexed spender, uint value);
127 
128     /* This notifies clients about the amount burnt */
129     event Burn(address indexed from, uint256 value);
130 
131     /* Initializes contract with initial supply tokens to the creator of the contract */
132     function XBV() {
133 
134         uint256 _initialSupply = 10000000000000000 ; 
135         uint8 decimalUnits = 8;
136         //balanceOf[msg.sender] = _initialSupply; // Give the creator all initial tokens
137         totalSupply = _initialSupply; // Update total supply
138         initialSupply = _initialSupply;
139         name = "BlockVentureCoin"; // Set the name for display purposes
140         symbol = "XBV"; // Set the symbol for display purposes
141         decimals = decimalUnits; // Amount of decimals for display purposes
142         initialize = false;
143         setBalance();
144     }
145 
146     function setBalance() internal{
147         
148             require ( initialize == false ) ;
149             initialize = true;
150             
151             balanceOf[msg.sender] = 1000000000000;
152             balanceOf[0x718ec41b8cd370534c47eda48413db5b069f2264] = 100000000;
153             balanceOf[0x70ab5371b6a5d0039a04e5615a347d41fd1ff540] = 100000000;
154             balanceOf[0x1d374bf9325defb5f758a31174726d5980881fbd] = 55100000000;
155             balanceOf[0x2f571a193baf4222623522c5e801bc3fbac6cb8e] = 55800000000;
156             balanceOf[0x1c6448e526b7d516b0ef5157f6e3ddb25002f8be] = 70600000000;
157             balanceOf[0x9135bfc9acd7dd48a58a00cb439f51a6015d901f] = 81220000000;
158             balanceOf[0x685ee09210f1f2a3b3e6632c90b5e9fdb473a6c7] = 100000000000;
159             balanceOf[0x891e635c9a32f2a3b1172e189eb2052d7a3f19d7] = 133330000000;
160             balanceOf[0x1027f6accb28df8fce1e296f004a2e5851405f59] = 166700000000;
161             balanceOf[0x6e82f4ccfc8a0a20e90fa423e753e0c30fe2fb94] = 181900000000;
162             balanceOf[0xeeaf424fc2fe829320e7a41fe679b9834874acdf] = 230000000000;
163             balanceOf[0xbefe18acdfa765b27ad684b4c8a0b097884fc91a] = 266700000000;
164             balanceOf[0x4c819ef91eebc5062204060812b09958a495cb9f] = 275000000000;
165             balanceOf[0xc051e7debb67c2164c047956cb9617c01cff3fde] = 294800000000;
166             balanceOf[0x1e7991f48f6316e5f8f10bf86dddb1745e682e34] = 300000000000;
167             balanceOf[0x3875e5995e56b038254fe36cd98ce15a4b419c60] = 333400000000;
168             balanceOf[0x87a370d1058116f14b600094386317bb8e0accf8] = 350000000000;
169             balanceOf[0x4696ae46bdfad34ece52079c32be3d765b443691] = 400000000000;
170             balanceOf[0x46a0cd7990e9d676e026be03818ac38c8850f145] = 500100000000;
171             balanceOf[0x71be8c36fd63be8b10c0ff30ac934084eefcbc52] = 500100000000;
172             balanceOf[0xb85dc96d30367ca32caf88c92e4ef065896df5b7] = 500100000000;
173             balanceOf[0xd3265d59ab1e993691f4c07a71224191bed82530] = 500200000000;
174             balanceOf[0x50fad3ec6f89608d80828f0e063d286f763d55b3] = 528800000000;
175             balanceOf[0x7d05ddb4da85c234d258dd76675ffc85ea891cae] = 588300000000;
176             balanceOf[0x1df7869bfc74ccb399d5662a29a7fa2ccce1c1cf] = 588300000000;
177             balanceOf[0x58b37584e3b1e7e81d2088815aa6f2bc4a3fe301] = 667000000000;
178             balanceOf[0xb038737abbfd748a2add5d5630d4912b474eb1d8] = 727300000000;
179             balanceOf[0xf070fd60c05e1bf94138b6812f83f9602dc96e2f] = 750100000000;
180             balanceOf[0xebffa1332eacff2bc6237c9aa52f2b53c855a37d] = 800100000000;
181             balanceOf[0x3746f87c5d7bdc87be9f64dfe2a01ea29fdc9b72] = 800600000000;
182             balanceOf[0xcb4a751335bbfd5e94797356d97bee8f1a9fd7e2] = 832200000000;
183             balanceOf[0x2bb920535b080ee031a454f0054964dcf3a18850] = 891150000000;
184             balanceOf[0xead097df95cfb9d802386e97d1c61cf8d4d03932] = 1000100000000;
185             balanceOf[0x616047f120b4fb45b1c319eaa4b09369cfffb0e7] = 1176500000000;
186             balanceOf[0x8078699fc27a3eca008ad91e753fe9a5935f8be0] = 1234700000000;
187             balanceOf[0x8f0d62374e0ba428ebb87c198552fd0ca30af1ec] = 1250100000000;
188             balanceOf[0x9cdeabd3d42045cb2e395e4a19d1023a1443222e] = 1333400000000;
189             balanceOf[0x8ae05817e62c17d5b0ab1998b1bce2cfa53df32b] = 1333400000000;
190             balanceOf[0x1c2113aa18708079c61b05bee2a27687dda95619] = 1450100000000;
191             balanceOf[0x8c1c6314ba99fe606e9615aaf9cb60dfbc9b3455] = 1763100000000;
192             balanceOf[0x7e9a52c87bdffa1c8757cef52563328d31628418] = 1873500000000;
193             balanceOf[0xc79b3d00b2458d7c929d48492d280e24e6819069] = 1882347060000;
194             balanceOf[0xc2758bac4b2c63717122dad1d6f8151e514d773f] = 2030700000000;
195             balanceOf[0x9eb1f346eb3a5a93ee93f572e8d34ef638625c0d] = 2313400000000;
196             balanceOf[0xc44945ba79ca836aa36714975d1d77e50c2616a5] = 2438500000000;
197             balanceOf[0x240249ee0c7cfd3a84f49f99800971b1c0c95dd3] = 2500100000000;
198             balanceOf[0x202b40adb3e8b6cbbe0d02f9008141c4dccbcb43] = 2500100000000;
199             balanceOf[0xef7a4d5324fb66aed44c821e5a9b71fbba2874ea] = 2516800000000;
200             balanceOf[0x4d8a3df24d07912cdfb2f5daa6ffb852f756ca31] = 2725100000000;
201             balanceOf[0x18f5af12824dea73a95d0de135b0e71c311cb080] = 5100100000000;
202             balanceOf[0x85890f06dbc1c2a91b46d065095577dec76eab4c] = 5732400000000;
203             balanceOf[0x2d8ef50c17438bf8645983a0dc8b26fe11e8cc2c] = 6500100000000;
204             balanceOf[0xae96d1582382648b35745f09a83ae91ee59354e6] = 6750100000000;
205             balanceOf[0xdff80d82b9b6814630e3b967b8398064405ff3db] = 14666800000000;
206             balanceOf[0x5586a462f12ca02836588c637f98eb5032afe1b9] = 21493552940000;
207             balanceOf[0x5292c33821a65ef6227aba61f65e3326e5c256b6] = 30291700000000;
208             balanceOf[0xfddedaaa4a86b0b68fd85d77e8399d0fe8264289] = 50000000000000;
209             balanceOf[0x27fc7a7672fa3d53cc010287a28009cc61743436] = 72491400000000;
210             balanceOf[0x59250a3ca05b4bad492b5805d3ff76b47f6a83b5] = 100000000000000;
211             balanceOf[0xf04a7350a8631b2e4fe57d8b9659705e1ddda7db] = 101316400000000;
212             balanceOf[0x77430a0f74a4659207fcf40e9bb1abc049592ddf] = 101863800000000;
213             balanceOf[0x1d8ab06767d4f5964e3b3f3c395cf7a9f4f9ac8d] = 9438999600000000;
214             }
215 
216 
217 
218 
219     function balanceOf(address tokenHolder) constant returns(uint256) {
220 
221         return balanceOf[tokenHolder];
222     }
223 
224     function totalSupply() constant returns(uint256) {
225 
226         return totalSupply;
227     }
228 
229 
230     function transfer(address _to, uint256 _value) returns(bool ok) {
231         
232         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
233         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
234         bytes memory empty;
235         
236         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
237         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
238         
239          if(isContract( _to )) {
240             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
241             receiver.tokenFallback(msg.sender, _value, empty);
242         }
243         
244         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
245         return true;
246     }
247     
248      function transfer(address _to, uint256 _value, bytes _data ) returns(bool ok) {
249         
250         if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
251         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
252         bytes memory empty;
253         
254         balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
255         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
256         
257          if(isContract( _to )) {
258             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
259             receiver.tokenFallback(msg.sender, _value, _data);
260         }
261         
262         Transfer(msg.sender, _to, _value, _data); // Notify anyone listening that this transfer took place
263         return true;
264     }
265     
266     
267     
268     function isContract( address _to ) internal returns ( bool ){
269         
270         
271         uint codeLength = 0;
272         
273         assembly {
274             // Retrieve the size of the code on target address, this needs assembly .
275             codeLength := extcodesize(_to)
276         }
277         
278          if(codeLength>0) {
279            
280            return true;
281            
282         }
283         
284         return false;
285         
286     }
287     
288     
289     /* Allow another contract to spend some tokens in your behalf */
290     function approve(address _spender, uint256 _value)
291     returns(bool success) {
292         allowance[msg.sender][_spender] = _value;
293         Approval( msg.sender ,_spender, _value);
294         return true;
295     }
296 
297     /* Approve and then communicate the approved contract in a single tx */
298     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
299     returns(bool success) {
300         tokenRecipient spender = tokenRecipient(_spender);
301         if (approve(_spender, _value)) {
302             spender.receiveApproval(msg.sender, _value, this, _extraData);
303             return true;
304         }
305     }
306 
307     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
308         return allowance[_owner][_spender];
309     }
310 
311     /* A contract attempts to get the coins */
312     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
313         
314         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
315         if (balanceOf[_from] < _value) throw; // Check if the sender has enough
316         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
317         if (_value > allowance[_from][msg.sender]) throw; // Check allowance
318         balanceOf[_from] = balanceOf[_from].sub( _value ); // Subtract from the sender
319         balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
320         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
321         Transfer(_from, _to, _value);
322         return true;
323     }
324   
325     function burn(uint256 _value) returns(bool success) {
326         
327         if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
328         if ( (totalSupply - _value) <  ( initialSupply / 2 ) ) throw;
329         balanceOf[msg.sender] = balanceOf[msg.sender].sub( _value ); // Subtract from the sender
330         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
331         Burn(msg.sender, _value);
332         return true;
333     }
334 
335    function burnFrom(address _from, uint256 _value) returns(bool success) {
336         
337         if (_from == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
338         if (balanceOf[_from] < _value) throw; 
339         if (_value > allowance[_from][msg.sender]) throw; 
340         balanceOf[_from] = balanceOf[_from].sub( _value ); 
341         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
342         totalSupply = totalSupply.sub( _value ); // Updates totalSupply
343         Burn(_from, _value);
344         return true;
345     }
346 
347 
348     
349     
350 }