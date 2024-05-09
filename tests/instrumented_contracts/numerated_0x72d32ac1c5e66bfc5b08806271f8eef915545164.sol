1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   uint256 public totalSupply;
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 contract Dec {
75     function decimals() public view returns (uint8);
76 }
77 
78 contract KeeToken is ERC20, Ownable {
79     // ERC20 standards
80     string public symbol = "KEE";
81     uint8 public decimals = 0;
82     uint public totalSupply = 1000; // inestimable
83     string public name = "CryptoKEE";
84 
85     struct AddRec {
86         address add;
87         uint8   decimals;
88     }
89 
90     // specific data
91     AddRec[] eligible;
92     AddRec temp;
93         // kovan
94         // 0x3406954E89bB166F7aF1f3cd198527Af6D3b10D2,
95         // 0x7ab59D6dF718c3C5EF2B92777B519782Cc283F60,
96         // 0x9090C02e86402E4D5A6a302a08673A0EE5567C91,
97         // 0x148D3436a6A024d432bD5277EcF6B98407D46a2F,
98         // 0x10Cc6a61b75363789d38ea8A101A51C36C507DEf,
99         // 0x81154d24f4de069d1f0c16E3a52e1Ef68714daD9
100         
101 
102     mapping (address => bool) public tokenIncluded;
103     mapping (address => uint256) public bitRegisters;
104     mapping (address => mapping(address => uint256)) public allowed;
105 
106     uint256[] public icoArray;
107 
108     // functions
109 
110     function KeeToken() public {
111         addToken(0xB97048628DB6B661D4C2aA833e95Dbe1A905B280,10);
112         addToken(0x0F5D2fB29fb7d3CFeE444a200298f468908cC942, 18);
113         addToken(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07, 18);
114         addToken(0x7C5A0CE9267ED19B22F8cae653F198e3E8daf098, 18);
115         addToken(0xB63B606Ac810a52cCa15e44bB630fd42D8d1d83d, 8);
116         addToken(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C, 18);
117         addToken(0x667088b212ce3d06a1b553a7221E1fD19000d9aF, 18);
118         addToken(0xCb94be6f13A1182E4A4B6140cb7bf2025d28e41B, 6);
119         addToken(0xFf3519eeeEA3e76F1F699CCcE5E23ee0bdDa41aC, 0);
120         addToken(0xE94327D07Fc17907b4DB788E5aDf2ed424adDff6, 18);
121         addToken(0x12FEF5e57bF45873Cd9B62E9DBd7BFb99e32D73e, 18);
122         addToken(0xE7775A6e9Bcf904eb39DA2b68c5efb4F9360e08C, 6);
123         addToken(0x4156D3342D5c385a87D264F90653733592000581, 8);
124         addToken(0x58ca3065C0F24C7c96Aee8d6056b5B5deCf9c2f8, 18);
125         addToken(0x22F0AF8D78851b72EE799e05F54A77001586B18A, 0);
126 
127         uint mask = 0;
128         for (uint i = 0; i < eligible.length; i++) {
129             tokenIncluded[eligible[i].add] = true;
130         }
131         icoArray.push(0);       // 0 - empty to ensure default ico score = 0
132         icoArray.push(~mask >> 256 - eligible.length);
133     }
134 
135     // external
136 
137     function updateICOmask(uint256 maskPos, uint256 newMask) external onlyOwner {
138         require(maskPos != 0); // can update loc 0
139         require(maskPos < icoArray.length);
140         icoArray[maskPos] = newMask;
141     }
142 
143     function setICObyAddress(address ico, uint256 maskPos) external onlyOwner {
144         require(maskPos != 0);
145         require(maskPos < icoArray.length);
146         bitRegisters[ico] = maskPos;
147     }
148 
149     function clearICObyAddress(address ico) external onlyOwner {
150         bitRegisters[ico] = 0;
151     }
152 
153     function icoBalanceOf(address from, address ico) external view returns (uint) {
154         uint icoMaskPtr = bitRegisters[ico];
155         return icoNumberBalanceOf(from,icoMaskPtr);
156     }
157 
158     // public
159 
160     function pushICO(uint256 mask) public onlyOwner {
161         icoArray.push(mask);
162     }
163 
164 
165     function addToken(address newToken, uint8 decimalPlaces) public onlyOwner {
166         if (tokenIncluded[newToken]) {
167             return;
168         }
169         temp.add = newToken;
170         temp.decimals = decimalPlaces;
171         
172         eligible.push(temp);
173         tokenIncluded[newToken] = true;
174     }
175     
176     function updateToken(uint tokenPos, address newToken, uint8 decimalPlaces)  public onlyOwner {
177         require(tokenPos < eligible.length);
178         eligible[tokenPos].decimals = decimalPlaces;
179         eligible[tokenPos].add = newToken;
180     }
181 
182     function approve(address spender, uint256 value) public returns (bool) {
183         allowed[msg.sender][spender] = value;
184         Approval(msg.sender,spender,value);
185     }
186 
187     function transfer(address to, uint) public returns (bool) {
188         return transferX(msg.sender,to);
189     }
190 
191     function transferFrom(address from, address to, uint) public returns (bool) {
192         if (allowed[from][msg.sender] == 0) {
193             return false;
194         }
195         return transferX(from,to);
196     }
197 
198     function allowance(address owner, address spender) public view returns (uint256) {
199         return allowed[owner][spender];
200     }
201 
202     function balanceOf(address from) public view returns (uint) {
203         uint zero = 0;
204         return internalBalanceOf(from,~zero);
205     }
206 
207     function icoNumberBalanceOf(address from, uint icoMaskPtr) public view returns (uint) {
208         if (icoMaskPtr == 0) 
209             return 0;
210         if (icoMaskPtr >= icoArray.length) 
211             return 0;
212         uint icoRegister = icoArray[icoMaskPtr];
213         return internalBalanceOf(from,icoRegister);
214     }
215 
216     // internal
217 
218     function transferX(address from, address to) internal returns (bool) {
219         uint myRegister = bitRegisters[from];
220         uint yourRegister = bitRegisters[to];
221         uint sent = 0;
222         uint added = 0;
223         for (uint i = 0; i < eligible.length; i++) {
224             if (coinBal(eligible[i],from) > 100) {
225                 myRegister |= (uint(1) << i);
226                 added++;
227             }
228         }
229         if (added > 0) {
230             bitRegisters[from] = myRegister;
231         }      
232         if ((myRegister & ~yourRegister) > 0) {
233             sent = 1;
234             bitRegisters[to] = yourRegister | myRegister;
235         }
236         Transfer(from,to,sent);
237         return true;        
238     }
239 
240     function internalBalanceOf(address from, uint icoRegister) internal view returns (uint) {
241         uint myRegister = bitRegisters[from] & icoRegister;
242         uint bal = 0;
243         for (uint i = 0; i < eligible.length; i++) {
244             uint bit = (uint(1) << i);
245             if ( bit & icoRegister == 0 )
246                 continue;
247             if ( myRegister & bit > 0 ) {
248                 bal++;
249                 continue;
250             }
251             uint coins = coinBal(eligible[i], from);
252             if (coins > 100) 
253                 bal++;
254         }
255         return bal;
256     }
257 
258     // internal
259 
260     function coinBal(AddRec ico, address from) internal view returns (uint) {
261         uint bal = ERC20(ico.add).balanceOf(from);
262         return bal / (10 ** uint(ico.decimals));
263     }
264 
265 }