1 pragma solidity >=0.4.21 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20Old interface
69  */
70 contract IERC20Old {
71   function totalSupply() public view returns (uint256);
72 
73   function balanceOf(address who) public view returns (uint256);
74   
75   function transfer(address to, uint256 value) public;
76   
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 interface IERC20 {
85     function transfer(address to, uint256 value) external returns (bool);
86 
87     function approve(address spender, uint256 value) external returns (bool);
88 
89     function transferFrom(address from, address to, uint256 value) external returns (bool);
90 
91     function totalSupply() external view returns (uint256);
92 
93     function balanceOf(address who) external view returns (uint256);
94 
95     function allowance(address owner, address spender) external view returns (uint256);
96 
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 contract DecenterPayouts {
103 
104     using SafeMath for uint256;
105 
106     address public owner;
107     IERC20 public daiContract;
108 
109     uint public totalCompensation = 0;
110     uint public daiBalanceAllocated = 0;
111 
112     mapping(address => uint) public shares;
113     mapping(address => uint) public balances;
114     mapping(address => uint) public daiBalances;
115     
116     address[] public allAddresses;
117 
118 // ---------------------------------------------------------------------------------------------
119 
120     modifier onlyOwner() {
121         require(msg.sender == owner);
122         _;
123     }
124 
125     modifier ifDaiBalanceNeedUpdate() {
126         if (daiBalanceAllocated < daiContract.balanceOf(address(this))) _;
127     }
128 
129 // ---------------------------------------------------------------------------------------------
130 
131     constructor() public {
132         owner = msg.sender;
133         // not sure if we should allow this address to be changed
134         // because maybe at some point DAI might move to other token standard with some way of transition of tokens
135         // but we can deploy new contract if that happens
136         daiContract = IERC20(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);    
137 
138         setShareForAddress(0xad79cc871f62409A3aB55C390bd34439e4fC1101, 2000);
139         setShareForAddress(0x00158A74921620b39E5c3aFE4dca79feb2c2C143, 2000);
140         setShareForAddress(0xD9020855796503009540D924EAaa571C24e003eB, 2000);
141         setShareForAddress(0x005cE84caA772a1a87607Fa47f9bAfA457980b20, 2000);
142         setShareForAddress(0x1955c2b76b1cF245795950e75eB176080879Da50, 2000);
143         setShareForAddress(0x4bB9A1E3bA4AEe6F6bb76De1384E7417fd2C9Dc2, 2000);
144         setShareForAddress(0x575F0F46C427EE49dC1fE04874e661dB161AC54E, 1800);
145         setShareForAddress(0xd408FB6eFAba343A527b64c0f9d1D730d11717F4, 1500);
146         setShareForAddress(0x46015322832a58fA12e669a1ABffa4b63251EEe6, 1400);
147         setShareForAddress(0x3e5598681E03026d785215adfB3173acF3Cf2B60, 1200);
148     }
149 
150 // ---------------------------------------------------------------------------------------------
151 
152     function setNewOwner(address _owner) public onlyOwner {
153         // just in case that its sent by accident
154         require(_owner != address(0));
155         
156         owner = _owner;
157     }
158        
159     // should take care that setting shares to 0 will disable possibility to withdraw for that user
160     // make sure that specific user doesn't have balance or daiBalance
161     // only owner can set shares (set to 0 if you want to remove user)
162     function setShareForAddress(address _to, uint _share) public onlyOwner {
163         // it will be done only if needed
164         // but needs to allocate DAI balance before shares are changed
165         updateDaiBalance();
166 
167         if (shares[_to] == 0) {
168             addAddress(_to);
169         }
170 
171         totalCompensation = totalCompensation.sub(shares[_to]);
172         totalCompensation = totalCompensation.add(_share);
173         shares[_to] = _share;
174 
175         if (_share == 0) {
176             removeAddress(_to);
177         }
178     }
179 
180     function () external payable {
181         
182         allocateBalance(msg.value, false);
183     }
184 
185     // only update if DAI contract is added and if it is needed
186     function updateDaiBalance() public ifDaiBalanceNeedUpdate {
187         uint daiBalance = daiContract.balanceOf(address(this));
188         uint toAllocate = daiBalance.sub(daiBalanceAllocated);
189 
190         allocateBalance(toAllocate, true);
191 
192         daiBalanceAllocated = daiBalance;
193     }
194 
195     function withdraw() public {
196         require(shares[msg.sender] > 0);
197         
198         // it will be done only if needed
199         // but needs to allocate DAI balance before someone withdraws part of it
200         updateDaiBalance();
201         
202         // withdraw ether balance
203         uint val = balances[msg.sender];
204         balances[msg.sender] = 0;
205         if (val > 0) {
206             msg.sender.transfer(val);
207         }
208 
209         // withdraw DAI balance
210         val = daiBalances[msg.sender];
211         daiBalances[msg.sender] = 0;
212         // contracts DAI balance is changing, so we need to change daiBalanceAllocated also
213         daiBalanceAllocated -= val;
214         if (val > 0) {
215            daiContract.transfer(msg.sender, val);
216         }
217     }
218 
219     // bool _new says if token returns bool on transfer method, most tokens are considered as new
220     function withdrawOtherTokens(address _tokenAddress, bool _new) public onlyOwner {
221         if (_new){
222             // current erc20 returns bool if transfer succeeded
223             IERC20 token = IERC20(_tokenAddress);
224             uint val = token.balanceOf(address(this));
225 
226             require(token.transfer(msg.sender, val));
227         } else {
228             // old erc20 doesn't return bool if it succeeded or not
229             IERC20Old token = IERC20Old(_tokenAddress);
230             uint val = token.balanceOf(address(this));
231 
232             token.transfer(msg.sender, val);
233         }
234     }
235     
236     function withdrawEther() public onlyOwner {
237 
238         msg.sender.transfer(address(this).balance);
239     }
240 
241 // ---------------------------------------------------------------------------------------------
242 
243     function allocateBalance(uint _val, bool _dai) private {
244         uint count = allAddresses.length;
245 
246         for (uint i=0; i<count; i++) {
247             address _adr = allAddresses[i];
248             uint part = _val.mul(shares[_adr]).div(totalCompensation);
249 
250             if (_dai) {
251                 daiBalances[_adr] += part;
252             } else {
253                 balances[_adr] += part;
254             }
255         }
256     }  
257     
258     function addAddress(address _address) private {
259         allAddresses.push(_address);
260     }
261 
262     function removeAddress(address _address) private {
263         uint count = allAddresses.length;
264         uint pos = count+1;
265 
266         for (uint i=0; i<count; i++) {
267             if (_address == allAddresses[i]) {
268                 pos = i;
269                 break;
270             }
271         }
272 
273         // if count is 0, this will always fail
274         require(pos < count);
275         
276         allAddresses[pos] = allAddresses[count - 1];
277         delete allAddresses[count - 1];
278         allAddresses.length--;
279     }        
280 }