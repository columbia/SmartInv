1 pragma solidity ^0.4.25;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2019 Decentralization Authority MDAO.
6  * Released under the MIT License.
7  *
8  * ZeroPriceIndex - Management system for maintaining the trade prices of
9  *                  ERC tokens & collectibles listed within ZeroCache.
10  *
11  * Version 19.2.9
12  *
13  * https://d14na.org
14  * support@d14na.org
15  */
16 
17 
18 /*******************************************************************************
19  *
20  * SafeMath
21  */
22 library SafeMath {
23     function add(uint a, uint b) internal pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function sub(uint a, uint b) internal pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31     function mul(uint a, uint b) internal pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     function div(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 /*******************************************************************************
43  *
44  * ERC Token Standard #20 Interface
45  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
46  */
47 contract ERC20Interface {
48     function totalSupply() public constant returns (uint);
49     function balanceOf(address tokenOwner) public constant returns (uint balance);
50     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
51     function transfer(address to, uint tokens) public returns (bool success);
52     function approve(address spender, uint tokens) public returns (bool success);
53     function transferFrom(address from, address to, uint tokens) public returns (bool success);
54 
55     event Transfer(address indexed from, address indexed to, uint tokens);
56     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
57 }
58 
59 
60 /*******************************************************************************
61  *
62  * ApproveAndCallFallBack
63  *
64  * Contract function to receive approval and execute function in one call
65  * (borrowed from MiniMeToken)
66  */
67 contract ApproveAndCallFallBack {
68     function approveAndCall(address spender, uint tokens, bytes data) public;
69     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
70 }
71 
72 
73 /*******************************************************************************
74  *
75  * Owned contract
76  */
77 contract Owned {
78     address public owner;
79     address public newOwner;
80 
81     event OwnershipTransferred(address indexed _from, address indexed _to);
82 
83     constructor() public {
84         owner = msg.sender;
85     }
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address _newOwner) public onlyOwner {
93         newOwner = _newOwner;
94     }
95 
96     function acceptOwnership() public {
97         require(msg.sender == newOwner);
98 
99         emit OwnershipTransferred(owner, newOwner);
100 
101         owner = newOwner;
102 
103         newOwner = address(0);
104     }
105 }
106 
107 
108 /*******************************************************************************
109  * 
110  * Zer0netDb Interface
111  */
112 contract Zer0netDbInterface {
113     /* Interface getters. */
114     function getAddress(bytes32 _key) external view returns (address);
115     function getBool(bytes32 _key)    external view returns (bool);
116     function getBytes(bytes32 _key)   external view returns (bytes);
117     function getInt(bytes32 _key)     external view returns (int);
118     function getString(bytes32 _key)  external view returns (string);
119     function getUint(bytes32 _key)    external view returns (uint);
120 
121     /* Interface setters. */
122     function setAddress(bytes32 _key, address _value) external;
123     function setBool(bytes32 _key, bool _value) external;
124     function setBytes(bytes32 _key, bytes _value) external;
125     function setInt(bytes32 _key, int _value) external;
126     function setString(bytes32 _key, string _value) external;
127     function setUint(bytes32 _key, uint _value) external;
128 
129     /* Interface deletes. */
130     function deleteAddress(bytes32 _key) external;
131     function deleteBool(bytes32 _key) external;
132     function deleteBytes(bytes32 _key) external;
133     function deleteInt(bytes32 _key) external;
134     function deleteString(bytes32 _key) external;
135     function deleteUint(bytes32 _key) external;
136 }
137 
138 
139 /*******************************************************************************
140  *
141  * @notice Zero(Cache) Price Index
142  *
143  * @dev Manages the current trade prices of ZeroCache tokens.
144  */
145 contract ZeroPriceIndex is Owned {
146     using SafeMath for uint;
147 
148     /* Initialize Zer0net Db contract. */
149     Zer0netDbInterface private _zer0netDb;
150 
151     /* Initialize price notification. */
152     event PriceSet(
153         bytes32 indexed key, 
154         uint value
155     );
156 
157     /**
158      * Set Zero(Cache) Price Index namespaces
159      * 
160      * NOTE: Keep all namespaces lowercase.
161      */
162     string private _NAMESPACE = 'zpi';
163 
164     /* Set Dai Stablecoin (trade pair) base. */
165     string private _TRADE_PAIR_BASE = 'DAI';
166 
167     /**
168      * Initialize Core Tokens
169      * 
170      * NOTE: All tokens are traded against DAI Stablecoin.
171      */
172     string[3] _CORE_TOKENS = [
173         'WETH',     // Wrapped Ether
174         '0GOLD',    // ZeroGold
175         '0xBTC'     // 0xBitcoin Token
176     ];
177 
178     /***************************************************************************
179      *
180      * Constructor
181      */
182     constructor() public {
183         /* Initialize Zer0netDb (eternal) storage database contract. */
184         // NOTE We hard-code the address here, since it should never change.
185         _zer0netDb = Zer0netDbInterface(0xE865Fe1A1A3b342bF0E2fcB11fF4E3BCe58263af);
186     }
187 
188     /**
189      * @dev Only allow access to an authorized Zer0net administrator.
190      */
191     modifier onlyAuthBy0Admin() {
192         /* Verify write access is only permitted to authorized accounts. */
193         require(_zer0netDb.getBool(keccak256(
194             abi.encodePacked(msg.sender, '.has.auth.for.zero.price.index'))) == true);
195 
196         _;      // function code is inserted here
197     }
198     
199     /**
200      * Get Trade Price
201      * 
202      * NOTE: All trades are made against DAI stablecoin.
203      */
204     function tradePriceOf(
205         string _token
206     ) external view returns (uint price) {
207         /* Initailze hash. */
208         bytes32 hash = 0x0;
209         
210         /* Set hash. */
211         hash = keccak256(abi.encodePacked(
212             _NAMESPACE, '.', _token, '.', _TRADE_PAIR_BASE
213         ));
214 
215         /* Retrieve value from Zer0net Db. */
216         price = _zer0netDb.getUint(hash);
217     }
218 
219     /**
220      * Get (All) Core Trade Prices
221      * 
222      * NOTE: All trades are made against DAI stablecoin.
223      */
224     function coreTradePrices() external view returns (uint[3] prices) {
225         /* Initailze hash. */
226         bytes32 hash = 0x0;
227         
228         /* Set hash. */
229         hash = keccak256(abi.encodePacked(
230             _NAMESPACE, '.WETH.', _TRADE_PAIR_BASE
231         ));
232 
233         /* Retrieve value from Zer0net Db. */
234         prices[0] = _zer0netDb.getUint(hash);
235 
236         /* Set hash. */
237         hash = keccak256(abi.encodePacked(
238             _NAMESPACE, '.0GOLD.', _TRADE_PAIR_BASE
239         ));
240 
241         /* Retrieve value from Zer0net Db. */
242         prices[1] = _zer0netDb.getUint(hash);
243 
244         /* Set hash. */
245         hash = keccak256(abi.encodePacked(
246             _NAMESPACE, '.0xBTC.', _TRADE_PAIR_BASE
247         ));
248 
249         /* Retrieve value from Zer0net Db. */
250         prices[2] = _zer0netDb.getUint(hash);
251     }
252 
253     /**
254      * Set Trade Price
255      * 
256      * NOTE: All trades are made against DAI stablecoin.
257      * 
258      * Keys for trade pairs are encoded using the 'exact' symbol,
259      * as listed in their respective contract:
260      * 
261      *     Wrapped Ether `0PI.WETH.DAI`
262      *     0x3f1c44ba685cff388a95a3e7ae4b6f00efe4793f0629b97577c1aa17090665ad
263      * 
264      *     ZeroGold `0PI.0GOLD.DAI`
265      *     0xeb7bb6c531569208c3173a7af7030a37a5a4b6d9f1518a8ae9ec655bde099fec
266      * 
267      *     0xBitcoin Token `0PI.0xBTC.DAI`
268      *     0xcaf604185158d62d93f6252c02ca8238aecf42f5560c4c98d13cd1391bc54d42
269      */
270     function setTradePrice(
271         string _token,
272         uint _value
273     ) external onlyAuthBy0Admin returns (bool success) {
274         /* Set hash. */
275         bytes32 hash = keccak256(abi.encodePacked(
276             _NAMESPACE, '.', _token, '.', _TRADE_PAIR_BASE
277         ));
278 
279         /* Set value in Zer0net Db. */
280         _zer0netDb.setUint(hash, _value);
281         
282         /* Broadcast event. */
283         emit PriceSet(hash, _value);
284         
285         /* Return success. */
286         return true;
287     }
288     
289     /**
290      * Set Core Prices
291      * 
292      * NOTE: All trades are made against DAI stablecoin.
293      * 
294      * NOTE: Use of `string[]` is still experimental, 
295      *       so we are required to `setCorePrices` by sending
296      *       `_values` in the proper format.
297      */
298     function setAllCoreTradePrices(
299         uint[] _values
300     ) external onlyAuthBy0Admin returns (bool success) {
301         /* Iterate Core Tokens for updating. */    
302         for (uint i = 0; i < _CORE_TOKENS.length; i++) {
303             /* Set hash. */
304             bytes32 hash = keccak256(abi.encodePacked(
305                 _NAMESPACE, '.', _CORE_TOKENS[i], '.', _TRADE_PAIR_BASE
306             ));
307     
308             /* Set value in Zer0net Db. */
309             _zer0netDb.setUint(hash, _values[i]);
310             
311             /* Broadcast event. */
312             emit PriceSet(hash, _values[i]);
313         }
314         
315         /* Return success. */
316         return true;
317     }
318     
319     /**
320      * THIS CONTRACT DOES NOT ACCEPT DIRECT ETHER
321      */
322     function () public payable {
323         /* Cancel this transaction. */
324         revert('Oops! Direct payments are NOT permitted here.');
325     }
326 
327     /**
328      * Transfer Any ERC20 Token
329      *
330      * @notice Owner can transfer out any accidentally sent ERC20 tokens.
331      *
332      * @dev Provides an ERC20 interface, which allows for the recover
333      *      of any accidentally sent ERC20 tokens.
334      */
335     function transferAnyERC20Token(
336         address tokenAddress, uint tokens
337     ) public onlyOwner returns (bool success) {
338         return ERC20Interface(tokenAddress).transfer(owner, tokens);
339     }
340 }