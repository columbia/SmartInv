1 pragma solidity ^0.4.18;        // v0.4.18 was the latest possible version. 0.4.19 and above were not allowed
2 
3 ////////////////////////////////////////////////////////////////////////////////
4 library SafeMath 
5 {
6     //--------------------------------------------------------------------------
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
8     {
9         if (a == 0)     return 0;
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14     //--------------------------------------------------------------------------
15     function div(uint256 a, uint256 b) internal pure returns (uint256) 
16     {
17         uint256 c = a / b;
18         return c;
19     }
20     //--------------------------------------------------------------------------
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
22     {
23         assert(b <= a);
24         return a - b;
25     }
26     //--------------------------------------------------------------------------
27     function add(uint256 a, uint256 b) internal pure returns (uint256) 
28     {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 ////////////////////////////////////////////////////////////////////////////////
35 library StringLib 
36 {
37     function concat(string strA, string strB) internal pure returns (string)
38     {
39         uint            i;
40         uint            g;
41         uint            finalLen;
42         bytes memory    dataStrA;
43         bytes memory    dataStrB;
44         bytes memory    buffer;
45 
46         dataStrA  = bytes(strA);
47         dataStrB  = bytes(strB);
48 
49         finalLen  = dataStrA.length + dataStrB.length;
50         buffer    = new bytes(finalLen);
51 
52         for (g=i=0; i<dataStrA.length; i++)   buffer[g++] = dataStrA[i];
53         for (i=0;   i<dataStrB.length; i++)   buffer[g++] = dataStrB[i];
54 
55         return string(buffer);
56     }
57     //--------------------------------------------------------------------------
58     function same(string strA, string strB) internal pure returns(bool)
59     {
60         return keccak256(strA)==keccak256(strB);
61     }
62     //-------------------------------------------------------------------------
63     function uintToAscii(uint number) internal pure returns(byte) 
64     {
65              if (number < 10)         return byte(48 + number);
66         else if (number < 16)         return byte(87 + number);
67 
68         revert();
69     }
70     //-------------------------------------------------------------------------
71     function asciiToUint(byte char) internal pure returns (uint) 
72     {
73         uint asciiNum = uint(char);
74 
75              if (asciiNum > 47 && asciiNum < 58)    return asciiNum - 48;
76         else if (asciiNum > 96 && asciiNum < 103)   return asciiNum - 87;
77 
78         revert();
79     }
80     //-------------------------------------------------------------------------
81     function bytes32ToString (bytes32 data) internal pure returns (string) 
82     {
83         bytes memory bytesString = new bytes(64);
84 
85         for (uint j=0; j < 32; j++) 
86         {
87             byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
88 
89             bytesString[j*2+0] = uintToAscii(uint(char) / 16);
90             bytesString[j*2+1] = uintToAscii(uint(char) % 16);
91         }
92         return string(bytesString);
93     }
94     //-------------------------------------------------------------------------
95     function stringToBytes32(string str) internal pure returns (bytes32) 
96     {
97         bytes memory bString = bytes(str);
98         uint uintString;
99 
100         if (bString.length != 64) { revert(); }
101 
102         for (uint i = 0; i < 64; i++) 
103         {
104             uintString = uintString*16 + uint(asciiToUint(bString[i]));
105         }
106         return bytes32(uintString);
107     }
108 }
109 ////////////////////////////////////////////////////////////////////////////////
110 contract ERC20 
111 {
112     function balanceOf(   address _owner)                               public constant returns (uint256 balance);
113     function transfer(    address toAddr,  uint256 amount)              public returns (bool success);
114     function allowance(   address owner,   address spender)             public constant returns (uint256);
115     function approve(     address spender, uint256 value)               public returns (bool);
116 
117     event Transfer(address indexed fromAddr, address indexed toAddr,   uint256 amount);
118     event Approval(address indexed _owner,   address indexed _spender, uint256 amount);
119 
120     uint256 public totalSupply;
121 }
122 ////////////////////////////////////////////////////////////////////////////////
123 contract Ownable 
124 {
125     address public owner;
126 
127     //-------------------------------------------------------------------------- @dev The Ownable constructor sets the original `owner` of the contract to the sender account
128     function Ownable() public 
129     {
130         owner = msg.sender;
131     }
132     //-------------------------------------------------------------------------- @dev Throws if called by any account other than the owner.
133     modifier onlyOwner() 
134     {
135         require(msg.sender == owner);
136         _;
137     }
138 }
139 ////////////////////////////////////////////////////////////////////////////////
140 contract Lockable is Ownable 
141 {
142     uint256 internal constant lockedUntil = 1533513600;     // 2018-08-06 00:00 (GMT+0)
143 
144     address internal allowedSender;     // the address that can make transactions when the transaction is locked 
145 
146     //-------------------------------------------------------------------------- @dev Allow access only when is unlocked. This function is good when you make crowdsale to avoid token expose in exchanges
147     modifier unlocked() 
148     {
149         require((now > lockedUntil) || (allowedSender == msg.sender));
150         _;
151     }
152     //-------------------------------------------------------------------------- @dev Allows the current owner to transfer control of the contract to a newOwner.
153     function transferOwnership(address newOwner) public onlyOwner               // @param newOwner The address to transfer ownership to.
154     {
155         require(newOwner != address(0));
156         owner = newOwner;
157 
158         allowedSender = newOwner;
159     }
160 }
161 ////////////////////////////////////////////////////////////////////////////////
162 contract Token is ERC20, Lockable 
163 {
164     using SafeMath for uint256;
165 
166     address public                                      owner;          // Owner of this contract
167     mapping(address => uint256)                         balances;       // Maintain balance in a mapping
168     mapping(address => mapping (address => uint256))    allowances;     // Allowances index-1 = Owner account   index-2 = spender account
169 
170     //------ TOKEN SPECIFICATION
171 
172     string public constant      name     = "Playrs";
173     string public constant      symbol   = "PLAYR";
174 
175     uint256 public constant     decimals = 4;      // Handle the coin as FIAT (2 decimals). ETH Handles 18 decimal places
176 
177     uint256 public constant     initSupply = 126000000 * 10**decimals;        // 10**18 max
178 
179     string private constant     supplyReserveMode="quantity";        // "quantity" or "percent"
180     uint256 public constant     supplyReserveVal = 26000000 * 10**decimals;          // if quantity => (val * 10**decimals)   if percent => val;
181 
182     uint256 public              icoSalesSupply   = 0;                   // Needed when burning tokens
183     uint256 public              icoReserveSupply = 0;
184 
185     //-------------------------------------------------------------------------- Functions with this modifier can only be executed by the owner
186     modifier onlyOwner() 
187     {
188         if (msg.sender != allowedSender) 
189         {
190             assert(true==false);
191         }
192         _;
193     }
194     //-------------------------------------------------------------------------- Functions with this modifier can only be executed by the owner
195     modifier onlyOwnerDuringIco() 
196     {
197         if (msg.sender!=allowedSender || now > lockedUntil) 
198         {
199             assert(true==false);
200         }
201         _;
202     }
203     //-------------------------------------------------------------------------- Constructor
204     function Token() public 
205     {
206         owner           = msg.sender;
207         totalSupply     = initSupply;
208         balances[owner] = initSupply;   // send the tokens to the owner
209 
210         //-----
211 
212         allowedSender = owner;          // In this contract, only the contract owner can send token while ICO is active.
213 
214         //----- Handling if there is a special maximum amount of tokens to spend during the ICO or not
215 
216         icoSalesSupply = totalSupply;   
217 
218         if (StringLib.same(supplyReserveMode, "quantity"))
219         {
220             icoSalesSupply = totalSupply.sub(supplyReserveVal);
221         }
222         else if (StringLib.same(supplyReserveMode, "percent"))
223         {
224             icoSalesSupply = totalSupply.mul(supplyReserveVal).div(100);
225         }
226 
227         icoReserveSupply = totalSupply.sub(icoSalesSupply);
228     }
229     //--------------------------------------------------------------------------
230     function transfer(address toAddr, uint256 amount)  public   unlocked returns (bool success) 
231     {
232         require(toAddr!=0x0 && toAddr!=msg.sender && amount>0);     // Prevent transfer to 0x0 address and to self, amount must be >0
233 
234         uint256 availableTokens      = balances[msg.sender];
235 
236         if (msg.sender==allowedSender)                              // Special handling on contract owner 
237         {
238             if (now <= lockedUntil)                                 // The ICO is now running
239             {
240                 uint256 balanceAfterTransfer = availableTokens.sub(amount);      
241 
242                 assert(balanceAfterTransfer >= icoReserveSupply);          // don't sell more than allowed during ICO
243             }
244         }
245 
246         balances[msg.sender] = balances[msg.sender].sub(amount);
247         balances[toAddr]     = balances[toAddr].add(amount);
248 
249         emit Transfer(msg.sender, toAddr, amount);
250         //Transfer(msg.sender, toAddr, amount);
251 
252         return true;
253     }
254     //--------------------------------------------------------------------------
255     function balanceOf(address _owner)  public   constant returns (uint256 balance) 
256     {
257         return balances[_owner];
258     }
259     //--------------------------------------------------------------------------
260     function approve(address _spender, uint256 amount)  public   returns (bool) 
261     {
262         require((amount == 0) || (allowances[msg.sender][_spender] == 0));
263 
264         allowances[msg.sender][_spender] = amount;
265 
266         emit Approval(msg.sender, _spender, amount);
267         //Approval(msg.sender, _spender, amount);
268 
269         return true;
270     }
271     //--------------------------------------------------------------------------
272     function allowance(address _owner, address _spender)  public   constant returns (uint remaining)
273     {
274         return allowances[_owner][_spender];    // Return the allowance for _spender approved by _owner
275     }
276     //--------------------------------------------------------------------------
277     function() public                       
278     {
279         assert(true == false);      // If Ether is sent to this address, don't handle it -> send it back.
280     }
281     //--------------------------------------------------------------------------
282     //--------------------------------------------------------------------------
283     //--------------------------------------------------------------------------
284 
285 
286     //--------------------------------------------------------------------------
287     //
288     // When ICO is closed, send the relaining (unsold) tokens to address 0x0
289     // So no one will be able to use it anymore... 
290     // Anyone can check address 0x0, so to proove unsold tokens belong to no one anymore
291     //
292     //--------------------------------------------------------------------------
293     function destroyRemainingTokens() public unlocked /*view*/ returns(uint)
294     {
295         require(msg.sender==allowedSender && now>lockedUntil);
296 
297         address   toAddr = 0x0000000000000000000000000000000000000000;
298 
299         uint256   amountToBurn = balances[allowedSender];
300 
301         if (amountToBurn > icoReserveSupply)
302         {
303             amountToBurn = amountToBurn.sub(icoReserveSupply);
304         }
305 
306         balances[owner]  = balances[allowedSender].sub(amountToBurn);
307         balances[toAddr] = balances[toAddr].add(amountToBurn);
308 
309         //emit Transfer(msg.sender, toAddr, amount);
310         Transfer(msg.sender, toAddr, amountToBurn);
311 
312         return 1;
313     }        
314     //--------------------------------------------------------------------------
315     //--------------------------------------------------------------------------
316     //--------------------------------------------------------------------------
317 }