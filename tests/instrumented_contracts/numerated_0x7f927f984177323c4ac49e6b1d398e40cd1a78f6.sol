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
115     function transferFrom(address fromAddr,address toAddr, uint256 value)   public returns (bool);
116     function approve(     address spender, uint256 value)               public returns (bool);
117 
118     event Transfer(address indexed fromAddr, address indexed toAddr,   uint256 amount);
119     event Approval(address indexed _owner,   address indexed _spender, uint256 amount);
120 
121     uint256 public totalSupply;
122 }
123 ////////////////////////////////////////////////////////////////////////////////
124 contract Ownable 
125 {
126     address public owner;
127 
128     //-------------------------------------------------------------------------- @dev The Ownable constructor sets the original `owner` of the contract to the sender account
129     function Ownable() public 
130     {
131         owner = msg.sender;
132     }
133     //-------------------------------------------------------------------------- @dev Throws if called by any account other than the owner.
134     modifier onlyOwner() 
135     {
136         require(msg.sender == owner);
137         _;
138     }
139 }
140 ////////////////////////////////////////////////////////////////////////////////
141 contract Lockable is Ownable 
142 {
143     uint256 internal constant lockedUntil = 1527811200;     // 2018-06-01 00:00 (GMT+0)
144 
145     address internal allowedSender;     // the address that can make transactions when the transaction is locked 
146 
147     //-------------------------------------------------------------------------- @dev Allow access only when is unlocked. This function is good when you make crowdsale to avoid token expose in exchanges
148     modifier unlocked() 
149     {
150         require((now > lockedUntil) || (allowedSender == msg.sender));
151         _;
152     }
153     //-------------------------------------------------------------------------- @dev Allows the current owner to transfer control of the contract to a newOwner.
154     function transferOwnership(address newOwner) public onlyOwner               // @param newOwner The address to transfer ownership to.
155     {
156         require(newOwner != address(0));
157         owner = newOwner;
158 
159         allowedSender = newOwner;
160     }
161 }
162 ////////////////////////////////////////////////////////////////////////////////
163 contract Token is ERC20, Lockable 
164 {
165     using SafeMath for uint256;
166 
167     address public                                      owner;          // Owner of this contract
168     mapping(address => uint256)                         balances;       // Maintain balance in a mapping
169     mapping(address => mapping (address => uint256))    allowances;     // Allowances index-1 = Owner account   index-2 = spender account
170 
171     //------ TOKEN SPECIFICATION
172 
173     string public constant      name     = "Yield Coin";
174     string public constant      symbol   = "YLD";
175 
176     uint256 public constant     decimals = 2;      // Handle the coin as FIAT (2 decimals). ETH Handles 18 decimal places
177 
178     uint256 public constant     initSupply = 1100000000 * 10**decimals;        // 10**18 max
179 
180     //-------------------------------------------------------------------------- Functions with this modifier can only be executed by the owner
181     modifier onlyOwner() 
182     {
183         if (msg.sender != owner) 
184         {
185             //----> (Jean) deprecated       throw;
186             assert(true==false);
187         }
188         _;
189     }
190     //-------------------------------------------------------------------------- Constructor
191     function Token() public 
192     {
193         owner           = msg.sender;
194         totalSupply     = initSupply;
195         balances[owner] = initSupply;   // send the tokens to the owner
196 
197         //-----
198 
199         allowedSender = owner;          // In this contract, only the contract owner can send token while ICO is active.
200     }
201     //--------------------------------------------------------------------------
202     function transfer(address toAddr, uint256 amount)  public   unlocked returns (bool success) 
203     {
204         require(toAddr!=0x0 && toAddr!=msg.sender && amount>0);         // Prevent transfer to 0x0 address and to self, amount must be >0
205 
206         balances[msg.sender] = balances[msg.sender].sub(amount);
207         balances[toAddr]     = balances[toAddr].add(amount);
208 
209         //emit Transfer(msg.sender, toAddr, amount);
210         Transfer(msg.sender, toAddr, amount);
211 
212         return true;
213     }
214     //--------------------------------------------------------------------------
215     function transferFrom(address fromAddr, address toAddr, uint256 amount)  public   unlocked returns (bool) 
216     {
217         if (amount <= 0)                                return false;
218         if (fromAddr==toAddr)                           return false;
219         if(allowances[fromAddr][msg.sender] < amount)   return false;
220         if(balances[fromAddr] < amount)                 return false;
221 
222         balances[fromAddr] = balances[fromAddr].sub(amount);
223         balances[toAddr]   = balances[toAddr].add(  amount);
224 
225         allowances[fromAddr][msg.sender] = allowances[fromAddr][msg.sender].sub(amount);
226 
227         //emit Transfer(fromAddr, toAddr, amount);
228         Transfer(fromAddr, toAddr, amount);
229 
230         return true;
231     }
232     //--------------------------------------------------------------------------
233     function balanceOf(address _owner)  public   constant returns (uint256 balance) 
234     {
235         return balances[_owner];
236     }
237     //--------------------------------------------------------------------------
238     function approve(address _spender, uint256 amount)  public   returns (bool) 
239     {
240         require((amount == 0) || (allowances[msg.sender][_spender] == 0));
241 
242         allowances[msg.sender][_spender] = amount;
243 
244         //emit Approval(msg.sender, _spender, amount);
245         Approval(msg.sender, _spender, amount);
246 
247         return true;
248     }
249     //--------------------------------------------------------------------------
250     function allowance(address _owner, address _spender)  public   constant returns (uint remaining)
251     {
252         return allowances[_owner][_spender];    // Return the allowance for _spender approved by _owner
253     }
254     //--------------------------------------------------------------------------
255     function() public                       
256     {
257         assert(true == false);      // If Ether is sent to this address, don't handle it -> send it back.
258     }
259     //--------------------------------------------------------------------------
260     //--------------------------------------------------------------------------
261     //--------------------------------------------------------------------------
262 
263 
264     //--------------------------------------------------------------------------
265     //--------------------------------------------------------------------------
266     //--------------------------------------------------------------------------
267 }