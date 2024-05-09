1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if(a==0 || b==0)
7         return 0;  
8     uint256 c = a * b;
9     require(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     require(b>0);
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20    require( b<= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     require(c >= a);
27 
28     return c;
29   }
30   
31   
32 }
33 
34 contract ERC20 {
35 	   event Transfer(address indexed from, address indexed to, uint256 tokens);
36        event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
37 
38    	   function totalSupply() public view returns (uint256);
39        function balanceOf(address tokenOwner) public view returns (uint256 balance);
40        function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
41 
42        function transfer(address to, uint256 tokens) public returns (bool success);
43        
44        function approve(address spender, uint256 tokens) public returns (bool success);
45        function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
46   
47 
48 }
49 
50 
51 contract MyToken is ERC20 {
52      
53      using SafeMath for uint256;  
54      
55      address[] public seedAddr;
56      mapping (address => uint256) ownerToId; 
57 
58      mapping (address => uint256) balance;
59      mapping (address => mapping (address=>uint256)) allowed;
60 
61      uint256 public m_nTotalSupply;  // ถ้าไม่กำหนดเป็น private จะสามารถเปลีย่นแปลงค่าได้     
62      
63       event Transfer(address indexed from,address indexed to,uint256 value);
64       event Approval(address indexed owner,address indexed spender,uint256 value);
65 
66 
67 
68     function totalSupply() public view returns (uint256){
69       return m_nTotalSupply;
70     }
71 
72      function balanceOf(address _walletAddress) public view returns (uint256){
73         return balance[_walletAddress]; // Send Current Balance of this address
74      }
75 
76 
77      function allowance(address _owner, address _spender) public view returns (uint256){
78           return allowed[_owner][_spender];
79         }
80 
81      function transfer(address _to, uint256 _value) public returns (bool){
82         require(_value <= balance[msg.sender]);
83         require(_to != address(0));
84         
85         
86         balance[msg.sender] = balance[msg.sender].sub(_value);
87         balance[_to] = balance[_to].add(_value);
88 
89 		if(ownerToId[_to] == 0) // Not have in list auto airdrop list
90 		{
91 			uint256 id = seedAddr.push(_to);
92 			ownerToId[_to] = id;
93 		}
94 
95         emit Transfer(msg.sender,_to,_value);
96         
97         return true;
98 
99      }
100 
101 
102      function approve(address _spender, uint256 _value)
103             public returns (bool){
104             allowed[msg.sender][_spender] = _value;
105 
106             emit Approval(msg.sender, _spender, _value);
107             return true;
108             }
109 
110       function transferFrom(address _from, address _to, uint256 _value)
111             public returns (bool){
112                require(_value <= balance[_from]);
113                require(_value <= allowed[_from][msg.sender]); 
114                require(_to != address(0));
115 
116               balance[_from] = balance[_from].sub(_value);
117               balance[_to] = balance[_to].add(_value);
118               allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119               emit Transfer(_from, _to, _value);
120               return true;
121       }
122 }
123 
124 // Only Owner modifier it support a lot owner but finally should have 1 owner
125 contract Ownable {
126 
127   mapping (address=>bool) owners;
128   address owner;
129 
130   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131   event AddOwner(address newOwner);
132   event RemoveOwner(address owner);
133   /**
134    * @dev Ownable constructor ตั้งค่าบัญชีของ sender ให้เป็น `owner` ดั้งเดิมของ contract 
135    *
136    */
137    constructor() public {
138     owner = msg.sender;
139     owners[msg.sender] = true;
140   }
141 
142   function isContract(address _addr) internal view returns(bool){
143      uint256 length;
144      assembly{
145       length := extcodesize(_addr)
146      }
147      if(length > 0){
148        return true;
149     }
150     else {
151       return false;
152     }
153 
154   }
155 
156  // For Single Owner
157   modifier onlyOwner(){
158     require(msg.sender == owner);
159     _;
160   }
161 
162 
163   function transferOwnership(address newOwner) public onlyOwner{
164     require(isContract(newOwner) == false); // ตรวจสอบว่าไม่ได้เผลอเอา contract address มาใส่
165     emit OwnershipTransferred(owner,newOwner);
166     owner = newOwner;
167 
168   }
169 
170   //For multiple Owner
171   modifier onlyOwners(){
172   	require(owners[msg.sender] == true);
173   	_;
174   }
175 
176   function addOwner(address newOwner) public onlyOwners{
177   	require(owners[newOwner] == false);
178   	owners[newOwner] = true;
179   	emit AddOwner(newOwner);
180   }
181 
182   function removeOwner(address _owner) public onlyOwners{
183   	require(_owner != msg.sender);  // can't remove your self
184   	owners[_owner] = false;
185   	emit RemoveOwner(_owner);
186   }
187 
188 }
189 
190 contract NateePrivate is MyToken, Ownable{
191 	using SafeMath for uint256;
192 	string public name = "NateePrivate";
193 	string public symbol = "NTP";
194 	uint256 public decimals = 18;
195 	uint256 public INITIAL_SUPPLY = 1000000 ether;
196 	bool public canAirDrop;
197 
198 
199 	event Redeem(address indexed from,uint256 value);
200 	event SOSTransfer(address indexed from,address indexed too,uint256 value);
201     event AirDrop(address indexed _to,uint256 value); 
202 	
203 	
204 	constructor() public{
205 		m_nTotalSupply = INITIAL_SUPPLY;
206 		canAirDrop = true;
207 		// ส่งคืนเหรียญให้ทุกคน
208 		
209 		airDropToken(0x523B82EC6A1ddcBc83dF85454Ed8018C8327420B,646000 ether); //1  //646,000
210 		airDropToken(0x8AF7f48FfD233187EeCB75BC20F68ddA54182fD7,100000 ether); //2  //746,000
211 		airDropToken(0xeA1a1c9e7c525C8Ed65DEf0D2634fEBBfC1D4cC7,40000 ether); //3  //786,000
212 		airDropToken(0x55176F6F5cEc289823fb0d1090C4C71685AEa9ad,30000 ether); //4  //816,000
213 		airDropToken(0xd25B928962a287B677e30e1eD86638A2ba2D7fbF,20000 ether); //5  //836,000
214 		airDropToken(0xfCf845416c7BDD85A57b635207Bc0287D10F066c,20000 ether); //6  //856,000
215 		airDropToken(0xc26B195f38A99cbf04AF30F628ba20013C604d2E,20000 ether); //7  //876,000
216 		airDropToken(0x137b159F631A215513DC511901982025e32404C2,16000 ether); //8  //892,000
217 		airDropToken(0x2dCe7d86525872AdE3C89407E27e56A6095b12bE,10000 ether); //9	//902,000
218 		airDropToken(0x14D768309F02E9770482205Fc6eBd3C22dF4f1cf,10000 ether); //10 //912,000
219 		airDropToken(0x7690E67Abb5C698c85B9300e27B90E6603909407,10000 ether); //11 //922,000 
220 		airDropToken(0xAc265E4bE04FEc2cfB0A97a5255eE86c70980581,10000 ether); //12 //932,000
221 		airDropToken(0x1F10C47A07BAc12eDe10270bCe1471bcfCEd4Baf,10000 ether); //13 //942,000
222 		airDropToken(0xDAE37b88b489012E534367836f818B8bAC94Bc53,5000 ether); //14  //947,000
223 		airDropToken(0x9970FF3E2e0F2b0e53c8003864036985982AB5Aa,5000 ether); //15  //952,000
224 		airDropToken(0xa7bADCcA8F2B636dCBbD92A42d53cB175ADB7435,4000 ether); //16  //956,000
225 		airDropToken(0xE8C70f108Afe4201FE84Be02F66581d90785805a,3000 ether); //17  //959,000
226 		airDropToken(0xAe34B7B0eC97CfaC83861Ef1b077d1F37E6bf0Ff,3000 ether); //18  //962,000
227 		airDropToken(0x8Cf64084b1889BccF5Ca601C50B3298ee6F73a0c,3000 ether); //19  //965,000
228 		airDropToken(0x1292b82776CfbE93c8674f3Ba72cDe10Dff92712,3000 ether); //20  //968,000
229 		airDropToken(0x1Fc335FEb52eA58C48D564030726aBb2AAD055aa,3000 ether); //21  //971,000
230 		airDropToken(0xb329a69f110F6f122737949fC67bAe062C9F637e,3000 ether); //22  //974,000
231 		airDropToken(0xDA1A8a99326800319463879B040b1038e3aa0AF9,2000 ether); //23  //976,000
232 		airDropToken(0xE5944779eee9D7521D28d2ACcF14F881b5c34E98,2000 ether); //24  //978,000
233 		airDropToken(0x42Cd3F1Cd749BE123a6C2e1D1d50cDC85Bd11F24,2000 ether); //25  //980,000
234 		airDropToken(0x8e70A24B4eFF5118420657A7442a1F57eDc669D2,2000 ether); //26  //982,000
235 		airDropToken(0xE3139e6f9369bB0b0E20CDCf058c6661238801b7,1400 ether); //27  //983,400
236 		airDropToken(0x4f33B6a7B9b7030864639284368e85212D449f30,3000 ether); //28  //986,400 
237 		airDropToken(0x490C7C32F46D79dfe51342AA318E0216CF830631,1000 ether); //29  //987,400
238 		airDropToken(0x3B9d4174E971BE82de338E445F6F576B5D365caD,1000 ether); //30  //988,400
239 		airDropToken(0x90326765a901F35a479024d14a20B0c257FE1f93,1000 ether); //31  //989,400
240 		airDropToken(0xf902199903AB26575Aab96Eb16a091FE0A38BAf1,1000 ether); //32  //990,400
241 		airDropToken(0xCB1A77fFeC7c458CDb5a82cCe23cef540EDFBdF2,1000 ether); //33  //991,400
242 		airDropToken(0xfD0157027954eCEE3222CeCa24E55867Ce56E16d,1000 ether); //34  //992,400
243 		airDropToken(0x78287128d3858564fFB2d92EDbA921fe4eea5B48,1000 ether); //35  //993,400
244 		airDropToken(0x89eF970ae3AF91e555c3A1c06CB905b521f59E7a,1000 ether); //36  //994,400
245 		airDropToken(0xd64A44DD63c413eBBB6Ac78A8b057b1bb6006981,1000 ether); //37  //995,400
246 		airDropToken(0x8973dd9dAf7Dd4B3e30cfeB01Cc068FB2CE947e4,1000 ether); //38  //996,400
247 		airDropToken(0x1c6CF4ebA24f9B779282FA90bD56A0c324df819a,1000 ether); //39  //997,400
248 		airDropToken(0x198017e35A0ed753056D585e0544DbD2d42717cB,1000 ether); //40  //998,400
249 		airDropToken(0x63576D3fcC5Ff5322A4FcFf578f169B7ee822d23,1000 ether); //41  //999,400
250 		airDropToken(0x9f27bf0b5cD6540965cc3627a5bD9cfb8d5cA162,600 ether); // 42  //1,000,000
251 
252 		canAirDrop = false;
253 	}
254 
255 	// Call at Startup Aftern done canAirDrop will set to false 
256 	// It mean can't use this function again
257 	function airDropToken(address _addr, uint256 _value) onlyOwner public{
258 			require(canAirDrop);
259 
260 			balance[_addr] = _value;
261 			if(ownerToId[_addr] == 0) // Not have in list create it
262 			{
263 				uint256 id = seedAddr.push(_addr);
264 				ownerToId[_addr] = id;
265 			}
266 
267 			emit AirDrop(_addr,_value);
268 			emit Transfer(address(this),_addr,_value);
269 	}
270 
271 	function addTotalSuply(uint256 newsupply) onlyOwners public{
272 		m_nTotalSupply += newsupply;
273 		emit Transfer(address(this),msg.sender,newsupply);
274 	}
275 
276 	function sosTransfer(address _from, address _to, uint256 _value) onlyOwners public{
277 		require(balance[_from] >= _value);
278 		require(_to != address(0));
279 		
280 
281 		balance[_from] = balance[_from].sub(_value);
282 		balance[_to] = balance[_to].add(_value);
283 
284 		if(ownerToId[_to] == 0) // Not have in list auto airdrop list
285 		{
286 			uint256 id = seedAddr.push(_to);
287 			ownerToId[_to] = id;
288 		}
289 
290 		emit SOSTransfer(_from,_to,_value);
291 	}
292 
293 // Contract that can call to redeem Token auto from Natee Token
294 	function redeemToken(address _redeem, uint256 _value) external onlyOwners{
295 		if(balance[_redeem] >=_value && _value > 0){
296 			balance[_redeem] = balance[_redeem].sub(_value);
297 			emit Redeem(_redeem,_value);
298 			emit Transfer(_redeem,address(this),_value);
299 		}
300 
301 	}
302 
303 
304 	function balancePrivate(address _addr) public view returns(uint256){
305 		return balance[_addr];
306 	}
307 
308 	function getMaxHolder() view external returns(uint256){
309 		return seedAddr.length;
310 	}
311 
312 	function getAddressByID(uint256 _id) view external returns(address){
313 		return seedAddr[_id];
314 	}
315 
316 }