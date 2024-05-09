1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 contract JasmyHyperDrop
80 {
81     address private admin;
82     address private signOwner;
83     IERC20 private token;
84     
85     uint256 private defaultTokensAmount;
86     uint32 private claimedCount;
87     
88     mapping(uint16 => uint256) private bitmask;
89     
90     string private constant ERR_MSG_SENDER = "ERR_MSG_SENDER";
91     string private constant ERR_AMOUNT = "ERR_AMOUNT";
92     
93     //--------------------------------------------------------------------------------------------------------------------------
94     constructor(address _admin, address _signOwner, address _tokenAddress, uint256 _defaultTokensAmount) public
95     {
96         admin                   = _admin;
97         signOwner               = _signOwner;
98         token                   = IERC20(_tokenAddress);
99         defaultTokensAmount     = _defaultTokensAmount;
100         
101         setClaimed(type(uint16).max, type(uint8).max); // gas savings for the first user that will claim tokens
102     }
103     
104     //--------------------------------------------------------------------------------------------------------------------------
105     function getAdmin() external view returns (address)
106     {
107         return admin;
108     }
109     
110     //--------------------------------------------------------------------------------------------------------------------------
111     function getSignOwner() external view returns (address)
112     {
113         return signOwner;
114     }
115     
116     //--------------------------------------------------------------------------------------------------------------------------
117     function setSignOwner(address _signOwner) external
118     {
119         require(msg.sender == admin, ERR_MSG_SENDER);
120         
121         signOwner = _signOwner;
122     }
123     
124     //--------------------------------------------------------------------------------------------------------------------------
125     function getTokenAddress() external view returns (address)
126     {
127         return address(token);
128     }
129     
130     //--------------------------------------------------------------------------------------------------------------------------
131     function getTotalTokensBalance() external view returns (uint256)
132     {
133         return token.balanceOf(address(this));
134     }
135     
136     //--------------------------------------------------------------------------------------------------------------------------
137     function sendTokens(address _to, uint256 _amount) external
138     {
139         require(msg.sender == admin, ERR_MSG_SENDER);
140         require(_amount <= token.balanceOf(address(this)), ERR_AMOUNT);
141         
142         if(_amount == 0)
143         {
144             token.transfer(_to, token.balanceOf(address(this)));
145         }
146         else
147         {
148             token.transfer(_to, _amount);
149         }
150     }
151     
152     //--------------------------------------------------------------------------------------------------------------------------
153     function getDefaultTokensAmount() external view returns (uint256)
154     {
155         return defaultTokensAmount;
156     }
157     
158     //--------------------------------------------------------------------------------------------------------------------------
159     function setDefaultTokensAmount(uint256 _amount) external
160     {
161         require(msg.sender == admin, ERR_MSG_SENDER);
162         
163         defaultTokensAmount = _amount;
164     }
165     
166     //--------------------------------------------------------------------------------------------------------------------------
167     function getClaimedCount() external view returns (uint32)
168     {
169         return claimedCount;
170     }
171     
172     //--------------------------------------------------------------------------------------------------------------------------
173     function claimTokens(uint16 _block, uint8 _bit, bytes memory _signature) external
174     {
175         require(!isClaimed(_block, _bit), "ERR_ALREADY_CLAIMED");
176         
177         string memory message = string(abi.encodePacked(toAsciiString(msg.sender), ";", uintToString(_block), ";", uintToString(_bit)));
178         verify(message, _signature);
179         
180         token.transfer(msg.sender, defaultTokensAmount);
181         
182         setClaimed(_block, _bit);
183     }
184     
185     //--------------------------------------------------------------------------------------------------------------------------
186     function claimTokens(uint16 _block, uint8 _bit, uint256 _tokensCount, bytes memory _signature) external
187     {
188         require(!isClaimed(_block, _bit));
189         
190         string memory message = string(abi.encodePacked(toAsciiString(msg.sender), ";", uintToString(_block), ";", uintToString(_bit), ";", uintToString(_tokensCount)));
191         verify(message, _signature);
192         
193         token.transfer(msg.sender, _tokensCount);
194         
195         setClaimed(_block, _bit);
196     }
197 
198     //--------------------------------------------------------------------------------------------------------------------------
199     function setClaimed(uint16 _block, uint8 _bit) private
200     {
201         uint256 bitBlock = bitmask[_block];
202         uint256 mask = uint256(1) << _bit;
203         
204         bitmask[_block] = (bitBlock | mask);
205         
206         ++claimedCount;
207     }
208     
209     //--------------------------------------------------------------------------------------------------------------------------
210     function isClaimed(uint16 _block, uint8 _bit) public view returns (bool)
211     {
212         uint256 bitBlock = bitmask[_block];
213         uint256 mask = uint256(1) << _bit;
214         
215         return (bitBlock & mask) > 0;
216     }
217     
218     //--------------------------------------------------------------------------------------------------------------------------
219     function verify(string memory _message, bytes memory _sig) private view
220     {
221         bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(_message))));
222         address messageSigner = recover(messageHash, _sig);
223         
224         require(messageSigner == signOwner, "ERR_VERIFICATION_FAILED");
225     }
226 
227     //--------------------------------------------------------------------------------------------------------------------------
228     function recover(bytes32 _hash, bytes memory _sig) private pure returns (address)
229     {
230         bytes32 r;
231         bytes32 s;
232         uint8 v;
233         
234         require(_sig.length == 65, "ERR_RECOVER_SIG_SIZE");
235 
236         assembly
237         {
238             r := mload(add(_sig, 32))
239             s := mload(add(_sig, 64))
240             v := byte(0, mload(add(_sig, 96)))
241         }
242 
243         if(v < 27)
244         {
245             v += 27;
246         }
247         
248         require(v == 27 || v == 28, "ERR_RECOVER_INVALID_SIG");
249 
250         return ecrecover(_hash, v, r, s);
251     }
252     
253     //--------------------------------------------------------------------------------------------------------------------------
254     function uintToString(uint _i) private pure returns (string memory)
255     {
256         if(_i == 0)
257         {
258             return "0";
259         }
260         uint j = _i;
261         uint len;
262         while (j != 0)
263         {
264             len++;
265             j /= 10;
266         }
267         bytes memory bstr = new bytes(len);
268         uint k = len - 1;
269         while(_i != 0)
270         {
271             bstr[k--] = byte(uint8(48 + _i % 10));
272             _i /= 10;
273         }
274         return string(bstr);
275     }
276     
277     //--------------------------------------------------------------------------------------------------------------------------
278     function toAsciiString(address _addr) private pure returns (string memory)
279     {
280         bytes memory s = new bytes(40);
281         for(uint i = 0; i < 20; i++)
282         {
283             byte b = byte(uint8(uint(_addr) / (2**(8*(19 - i)))));
284             byte hi = byte(uint8(b) / 16);
285             byte lo = byte(uint8(b) - 16 * uint8(hi));
286             s[2*i] = char(hi);
287             s[2*i+1] = char(lo);            
288         }
289         return string(s);
290     }
291     
292     //--------------------------------------------------------------------------------------------------------------------------
293     function char(byte value) private pure returns (byte)
294     {
295         if(uint8(value) < 10)
296         {
297             return byte(uint8(value) + 0x30);
298         }
299         else
300         {
301             return byte(uint8(value) + 0x57);
302         }
303     }
304 }