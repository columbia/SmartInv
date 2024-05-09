1 pragma solidity 0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/TokenRegistry.sol
46 
47 /**
48  * The TokenRegistry is a basic registry mapping token symbols
49  * to their known, deployed addresses on the current blockchain.
50  *
51  * Note that the TokenRegistry does *not* mediate any of the
52  * core protocol's business logic, but, rather, is a helpful
53  * utility for Terms Contracts to use in encoding, decoding, and
54  * resolving the addresses of currently deployed tokens.
55  *
56  * At this point in time, administration of the Token Registry is
57  * under Dharma Labs' control.  With more sophisticated decentralized
58  * governance mechanisms, we intend to shift ownership of this utility
59  * contract to the Dharma community.
60  */
61 contract TokenRegistry is Ownable {
62     mapping (bytes32 => TokenAttributes) public symbolHashToTokenAttributes;
63     string[256] public tokenSymbolList;
64     uint8 public tokenSymbolListLength;
65 
66     struct TokenAttributes {
67         // The ERC20 contract address.
68         address tokenAddress;
69         // The index in `tokenSymbolList` where the token's symbol can be found.
70         uint tokenIndex;
71         // The name of the given token, e.g. "Canonical Wrapped Ether"
72         string name;
73         // The number of digits that come after the decimal place when displaying token value.
74         uint8 numDecimals;
75     }
76 
77     /**
78      * Maps the given symbol to the given token attributes.
79      */
80     function setTokenAttributes(
81         string _symbol,
82         address _tokenAddress,
83         string _tokenName,
84         uint8 _numDecimals
85     )
86         public onlyOwner
87     {
88         bytes32 symbolHash = keccak256(_symbol);
89 
90         // Attempt to retrieve the token's attributes from the registry.
91         TokenAttributes memory attributes = symbolHashToTokenAttributes[symbolHash];
92 
93         if (attributes.tokenAddress == address(0)) {
94             // The token has not yet been added to the registry.
95             attributes.tokenAddress = _tokenAddress;
96             attributes.numDecimals = _numDecimals;
97             attributes.name = _tokenName;
98             attributes.tokenIndex = tokenSymbolListLength;
99 
100             tokenSymbolList[tokenSymbolListLength] = _symbol;
101             tokenSymbolListLength++;
102         } else {
103             // The token has already been added to the registry; update attributes.
104             attributes.tokenAddress = _tokenAddress;
105             attributes.numDecimals = _numDecimals;
106             attributes.name = _tokenName;
107         }
108 
109         // Update this contract's storage.
110         symbolHashToTokenAttributes[symbolHash] = attributes;
111     }
112 
113     /**
114      * Given a symbol, resolves the current address of the token the symbol is mapped to.
115      */
116     function getTokenAddressBySymbol(string _symbol) public view returns (address) {
117         bytes32 symbolHash = keccak256(_symbol);
118 
119         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
120 
121         return attributes.tokenAddress;
122     }
123 
124     /**
125      * Given the known index of a token within the registry's symbol list,
126      * returns the address of the token mapped to the symbol at that index.
127      *
128      * This is a useful utility for compactly encoding the address of a token into a
129      * TermsContractParameters string -- by encoding a token by its index in a
130      * a 256 slot array, we can represent a token by a 1 byte uint instead of a 20 byte address.
131      */
132     function getTokenAddressByIndex(uint _index) public view returns (address) {
133         string storage symbol = tokenSymbolList[_index];
134 
135         return getTokenAddressBySymbol(symbol);
136     }
137 
138     /**
139      * Given a symbol, resolves the index of the token the symbol is mapped to within the registry's
140      * symbol list.
141      */
142     function getTokenIndexBySymbol(string _symbol) public view returns (uint) {
143         bytes32 symbolHash = keccak256(_symbol);
144 
145         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
146 
147         return attributes.tokenIndex;
148     }
149 
150     /**
151      * Given an index, resolves the symbol of the token at that index in the registry's
152      * token symbol list.
153      */
154     function getTokenSymbolByIndex(uint _index) public view returns (string) {
155         return tokenSymbolList[_index];
156     }
157 
158     /**
159      * Given a symbol, returns the name of the token the symbol is mapped to within the registry's
160      * symbol list.
161      */
162     function getTokenNameBySymbol(string _symbol) public view returns (string) {
163         bytes32 symbolHash = keccak256(_symbol);
164 
165         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
166 
167         return attributes.name;
168     }
169 
170     /**
171      * Given the symbol for a token, returns the number of decimals as provided in
172      * the associated TokensAttribute struct.
173      *
174      * Example:
175      *   getNumDecimalsFromSymbol("REP");
176      *   => 18
177      */
178     function getNumDecimalsFromSymbol(string _symbol) public view returns (uint8) {
179         bytes32 symbolHash = keccak256(_symbol);
180 
181         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
182 
183         return attributes.numDecimals;
184     }
185 
186     /**
187      * Given the index for a token in the registry, returns the number of decimals as provided in
188      * the associated TokensAttribute struct.
189      *
190      * Example:
191      *   getNumDecimalsByIndex(1);
192      *   => 18
193      */
194     function getNumDecimalsByIndex(uint _index) public view returns (uint8) {
195         string memory symbol = getTokenSymbolByIndex(_index);
196 
197         return getNumDecimalsFromSymbol(symbol);
198     }
199 
200     /**
201      * Given the index for a token in the registry, returns the name of the token as provided in
202      * the associated TokensAttribute struct.
203      *
204      * Example:
205      *   getTokenNameByIndex(1);
206      *   => "Canonical Wrapped Ether"
207      */
208     function getTokenNameByIndex(uint _index) public view returns (string) {
209         string memory symbol = getTokenSymbolByIndex(_index);
210 
211         string memory tokenName = getTokenNameBySymbol(symbol);
212 
213         return tokenName;
214     }
215 
216     /**
217      * Given the symbol for a token in the registry, returns a tuple containing the token's address,
218      * the token's index in the registry, the token's name, and the number of decimals.
219      *
220      * Example:
221      *   getTokenAttributesBySymbol("WETH");
222      *   => ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", 1, "Canonical Wrapped Ether", 18]
223      */
224     function getTokenAttributesBySymbol(string _symbol)
225         public
226         view
227         returns (
228             address,
229             uint,
230             string,
231             uint
232         )
233     {
234         bytes32 symbolHash = keccak256(_symbol);
235 
236         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
237 
238         return (
239             attributes.tokenAddress,
240             attributes.tokenIndex,
241             attributes.name,
242             attributes.numDecimals
243         );
244     }
245 
246     /**
247      * Given the index for a token in the registry, returns a tuple containing the token's address,
248      * the token's symbol, the token's name, and the number of decimals.
249      *
250      * Example:
251      *   getTokenAttributesByIndex(1);
252      *   => ["0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", "WETH", "Canonical Wrapped Ether", 18]
253      */
254     function getTokenAttributesByIndex(uint _index)
255         public
256         view
257         returns (
258             address,
259             string,
260             string,
261             uint8
262         )
263     {
264         string memory symbol = getTokenSymbolByIndex(_index);
265 
266         bytes32 symbolHash = keccak256(symbol);
267 
268         TokenAttributes storage attributes = symbolHashToTokenAttributes[symbolHash];
269 
270         return (
271             attributes.tokenAddress,
272             symbol,
273             attributes.name,
274             attributes.numDecimals
275         );
276     }
277 }