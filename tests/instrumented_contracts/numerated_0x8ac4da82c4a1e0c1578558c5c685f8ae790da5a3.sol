1 pragma solidity ^0.4.23; 
2  
3 /*    
4 * Author:  Konstantin G...
5 * Telegram: @bunnygame
6 * 
7 * email: info@bunnycoin.co
8 * site : http://bunnycoin.co
9 * @title Ownable
10 * @dev The Ownable contract has an owner address, and provides basic authorization control
11 * functions, this simplifies the implementation of "user permissions".
12 */
13 
14 contract Ownable {
15     
16     address owner;
17     address ownerMoney;   
18     
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20  
21 
22     /**
23     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24     * account.
25     */    
26     constructor() public {
27         owner = msg.sender;
28         ownerMoney = msg.sender;
29     }
30 
31     /**
32     * @dev Throws if called by any account other than the owner.
33     */
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39  
40 
41     function transferMoney(address _add) public  onlyOwner {
42         if (_add != address(0)) {
43             ownerMoney = _add;
44         }
45     }
46     
47  
48     function transferOwner(address _add) public onlyOwner {
49         if (_add != address(0)) {
50             owner = _add;
51         }
52     } 
53       
54     function getOwnerMoney() public view onlyOwner returns(address) {
55         return ownerMoney;
56     } 
57  
58 }
59 
60  
61 
62 /**
63  * @title Whitelist
64  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
65  * @dev This simplifies the implementation of "user permissions".
66  */
67 contract Whitelist is Ownable {
68     mapping(address => bool) public whitelist;
69 
70     mapping(uint  => address)   whitelistCheck;
71     uint public countAddress = 0;
72 
73     event WhitelistedAddressAdded(address addr);
74     event WhitelistedAddressRemoved(address addr);
75  
76   /**
77    * @dev Throws if called by any account that's not whitelisted.
78    */
79     modifier onlyWhitelisted() {
80         require(whitelist[msg.sender]);
81         _;
82     }
83 
84     constructor() public {
85             whitelist[msg.sender] = true;  
86     }
87 
88   /**
89    * @dev add an address to the whitelist
90    * @param addr address
91    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
92    */
93     function addAddressToWhitelist(address addr) onlyWhitelisted public returns(bool success) {
94         if (!whitelist[addr]) {
95             whitelist[addr] = true;
96 
97             countAddress = countAddress + 1;
98             whitelistCheck[countAddress] = addr;
99 
100             emit WhitelistedAddressAdded(addr);
101             success = true;
102         }
103     }
104 
105     function getWhitelistCheck(uint key) onlyWhitelisted view public returns(address) {
106         return whitelistCheck[key];
107     }
108 
109 
110     function getInWhitelist(address addr) public view returns(bool) {
111         return whitelist[addr];
112     }
113  
114     /**
115     * @dev add addresses to the whitelist
116     * @param addrs addresses
117     * @return true if at least one address was added to the whitelist,
118     * false if all addresses were already in the whitelist
119     */
120     function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
121         for (uint256 i = 0; i < addrs.length; i++) {
122             if (addAddressToWhitelist(addrs[i])) {
123                 success = true;
124             }
125         }
126     }
127 
128     /**
129     * @dev remove an address from the whitelist
130     * @param addr address
131     * @return true if the address was removed from the whitelist,
132     * false if the address wasn't in the whitelist in the first place
133     */
134     function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
135         if (whitelist[addr]) {
136             whitelist[addr] = false;
137             emit WhitelistedAddressRemoved(addr);
138             success = true;
139         }
140     }
141 
142     /**
143     * @dev remove addresses from the whitelist
144     * @param addrs addresses
145     * @return true if at least one address was removed from the whitelist,
146     * false if all addresses weren't in the whitelist in the first place
147     */
148     function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
149         for (uint256 i = 0; i < addrs.length; i++) {
150             if (removeAddressFromWhitelist(addrs[i])) {
151                 success = true;
152             }
153         }
154     }
155 }
156 
157 /**
158  * @title SafeMath
159  * @dev Math operations with safety checks that throw on error
160  */
161 library SafeMath {
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         assert(b <= a);
164         return a - b;
165     }
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         assert(c >= a);
169         return c;
170     }
171 }
172  
173 contract StorageMarket  is Whitelist {
174 
175   using SafeMath for uint256;
176  
177     // the last cost of a sold seal
178     uint public lastmoney = 0;   
179     uint public lastBunny = 0;   
180     uint public countBunny = 0;   
181 
182 
183     bool public pause = false; 
184 
185     // how many a bunny
186     mapping (uint32 => uint) public bunnyCost;
187 
188     event AddCost(uint32 bunnyId, uint money);
189     event DeleteCost(uint32 bunnyId);
190 
191     function setPause() public onlyWhitelisted {
192         pause = !pause;
193     }
194 
195     function isPauseSave() public  view returns(bool){
196         return !pause;
197     }
198 
199 
200     function setBunnyCost(uint32 _bunnyID, uint _money) external onlyWhitelisted {
201         require(isPauseSave());
202         lastmoney = _money;   
203         lastBunny = _bunnyID;  
204         bunnyCost[_bunnyID] = _money;
205         if (bunnyCost[_bunnyID] == 0) { 
206             countBunny = countBunny.add(1);
207         }
208         emit AddCost(_bunnyID, _money);
209     }
210     
211     function getBunnyCost(uint32 _bunnyID) public view returns (uint money) {
212         return bunnyCost[_bunnyID];
213     }
214 
215     function deleteBunnyCost(uint32 _bunnyID) external onlyWhitelisted { 
216         require(isPauseSave()); 
217         bunnyCost[_bunnyID] = 0;
218         if (bunnyCost[_bunnyID] != 0) { 
219             countBunny = countBunny.sub(1);
220             emit DeleteCost(_bunnyID); 
221         }
222     }
223  
224 }