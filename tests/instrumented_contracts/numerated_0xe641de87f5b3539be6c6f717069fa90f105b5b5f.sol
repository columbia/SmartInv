1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address who) external view returns (uint256);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function transfer(address to, uint256 value) external returns (bool);
10     function approve(address spender, uint256 value) external returns (bool);
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 library Address {
28     function isContract(address account) internal view returns (bool) {
29         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
30         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
31         // for accounts without code, i.e. `keccak256('')`
32         bytes32 codehash;
33         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
34         // solhint-disable-next-line no-inline-assembly
35         assembly {
36             codehash := extcodehash(account)
37         }
38         return (codehash != accountHash && codehash != 0x0);
39     }
40 
41     function sendValue(address payable recipient, uint256 amount) internal {
42         require(
43             address(this).balance >= amount,
44             "Address: insufficient balance"
45         );
46 
47         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
48         (bool success, ) = recipient.call{value: amount}("");
49         require(
50             success,
51             "Address: unable to send value, recipient may have reverted"
52         );
53     }
54 
55     function functionCall(address target, bytes memory data)
56         internal
57         returns (bytes memory)
58     {
59         return functionCall(target, data, "Address: low-level call failed");
60     }
61 
62     function functionCall(
63         address target,
64         bytes memory data,
65         string memory errorMessage
66     ) internal returns (bytes memory) {
67         return _functionCallWithValue(target, data, 0, errorMessage);
68     }
69 
70     function functionCallWithValue(
71         address target,
72         bytes memory data,
73         uint256 value
74     ) internal returns (bytes memory) {
75         return
76             functionCallWithValue(
77                 target,
78                 data,
79                 value,
80                 "Address: low-level call with value failed"
81             );
82     }
83 
84     function functionCallWithValue(
85         address target,
86         bytes memory data,
87         uint256 value,
88         string memory errorMessage
89     ) internal returns (bytes memory) {
90         require(
91             address(this).balance >= value,
92             "Address: insufficient balance for call"
93         );
94         return _functionCallWithValue(target, data, value, errorMessage);
95     }
96 
97     function _functionCallWithValue(
98         address target,
99         bytes memory data,
100         uint256 weiValue,
101         string memory errorMessage
102     ) private returns (bytes memory) {
103         require(isContract(target), "Address: call to non-contract");
104 
105         (bool success, bytes memory returndata) = target.call{value: weiValue}(
106             data
107         );
108         if (success) {
109             return returndata;
110         } else {
111             if (returndata.length > 0) {
112                 assembly {
113                     let returndata_size := mload(returndata)
114                     revert(add(32, returndata), returndata_size)
115                 }
116             } else {
117                 revert(errorMessage);
118             }
119         }
120     }
121 }
122 
123 contract Ownable is Context {
124     address private _owner;
125     address private _previousOwner;
126     address private _tollOperator;
127 
128     event OwnershipTransferred(
129         address indexed previousOwner,
130         address indexed newOwner
131     );
132     event TollOperatorChanged(
133         address indexed previousTollOperator,
134         address indexed newTollOperator
135     );
136 
137     constructor() {
138         address msgSender = _msgSender();
139         _owner = msgSender;
140         _tollOperator = msgSender;
141         emit OwnershipTransferred(address(0), msgSender);
142     }
143 
144     function owner() public view returns (address) {
145         return _owner;
146     }
147 
148     function tollOperator() public view returns (address) {
149         return _tollOperator;
150     }
151 
152     modifier onlyOwner() {
153         require(_owner == _msgSender(), "Ownable: caller is not the owner");
154         _;
155     }
156 
157     modifier onlyTollOperator() {
158         require(
159             _tollOperator == _msgSender(),
160             "Ownable: caller is not the Toll Operator"
161         );
162         _;
163     }
164 
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(
167             newOwner != address(0),
168             "Ownable: new owner is the zero address"
169         );
170         emit OwnershipTransferred(_owner, newOwner);
171         _owner = newOwner;
172     }
173 
174     function changeTollOperator(address newTollOperator) public virtual onlyOwner {
175         require(
176             newTollOperator != address(0),
177             "Ownable: new owner is the zero address"
178         );
179         emit TollOperatorChanged(_tollOperator, newTollOperator);
180         _tollOperator = newTollOperator;
181     }
182 }
183 
184 contract AlveyBridge is Context, Ownable {
185     using Address for address;
186 
187     string private _name = "Alvey Bridge";
188     string private _symbol = "Alvey Bridge";
189 
190     IERC20 public alveyToken;
191 
192     mapping (uint256 => uint256) public feeMap;
193     mapping (uint256 => mapping(uint256 => uint256)) public validNonce;
194     mapping (uint256 => uint256) public nonces;
195     mapping (address => bool) public isOperator;
196     mapping (address => bool) public excludedFromRestrictions;
197 
198     bool public isBridgeActive = false;
199 
200     modifier onlyBridgeActive() {
201         if(!excludedFromRestrictions[msg.sender])
202         {
203         require(isBridgeActive, "Bridge is not active");
204         }
205         _;
206     }
207 
208     modifier onlyOperator(){
209         require(isOperator[msg.sender]==true,"Error: Caller is not the operator!");
210         _;
211     }
212 
213     event Crossed(address indexed sender, uint256 value, uint256 fromChainID, uint256 chainID, uint256 nonce);
214 
215     constructor(address _alveyToken, uint256 [] memory _fee, address [] memory operators) {
216         alveyToken = IERC20(_alveyToken);
217         feeMap[56] = _fee[0];
218         isOperator[operators[0]] = true;
219         isOperator[operators[1]] = true;
220         isOperator[operators[2]] = true;
221         isOperator[operators[3]] = true;
222         isOperator[operators[4]] = true;
223         isOperator[operators[5]] = true;
224         isOperator[operators[6]] = true;
225         isOperator[operators[7]] = true;
226         isOperator[operators[8]] = true;
227         isOperator[operators[9]] = true;
228         isOperator[operators[10]] = true; 
229     }
230 
231     function name() public view returns (string memory) {
232         return _name;
233     }
234 
235     function symbol() public view returns (string memory) {
236         return _symbol;
237     }
238 
239     function setBridgeFeeChain(uint256 _chainID, uint256 _fee) public onlyOwner {
240         feeMap[_chainID] = _fee;
241     }
242 
243     function setOperator(address _operator, bool _value) public onlyOwner{
244         require(isOperator[_operator]!=_value,"Error: Already set!");
245         isOperator[_operator]= _value;
246     }
247 
248     function setExcludeFromRestrictions(address _user, bool _value) external  onlyOwner {
249         require(excludedFromRestrictions[_user] != _value, "Error: Already set!");
250         excludedFromRestrictions[_user] = _value;
251     }
252 
253     function setBridgeActive(bool _isBridgeActive) public onlyOwner {
254         isBridgeActive = _isBridgeActive;
255     }
256 
257     function transfer(
258         address receiver,
259         uint256 amount,
260         uint256 fromChainID,
261         uint256 _txNonce
262     ) external onlyOperator {
263         require(validNonce[fromChainID][_txNonce] == 0,"Error: This transfer has been proceed!");
264         alveyToken.transfer(receiver, amount);
265         validNonce[fromChainID][_txNonce]=1;
266     }
267 
268     function cross(
269         uint256 amount,
270         uint256 chainID
271     ) external payable onlyBridgeActive{
272         require(msg.value >= feeMap[chainID], "Bridge fee is not enough");
273         if(msg.value - feeMap[chainID] > 0){
274             payable(msg.sender).transfer(msg.value - feeMap[chainID]);
275         }
276         
277         alveyToken.transferFrom(_msgSender(), address(this), amount);
278         emit Crossed(_msgSender(), amount, block.chainid, chainID, nonces[chainID]);
279         nonces[chainID]+=1;
280     }
281 
282     function claimStuckBalance() external onlyOwner {
283         payable(_msgSender()).transfer(address(this).balance);
284     }
285 
286     function claimStuckTokens(address tokenAddress) external onlyOwner {
287         IERC20(tokenAddress).transfer(_msgSender(), IERC20(tokenAddress).balanceOf(address(this)));
288     }
289 
290     function claimStuckBalanceAmount(uint256 _amount) external  onlyOwner {
291         require(_amount <= address(this).balance);
292         payable(_msgSender()).transfer(_amount);
293     }
294 
295     function claimStuckTokensAmount(address tokenAddress, uint256 _amount) external onlyOwner {
296         IERC20(tokenAddress).transfer(_msgSender(),_amount);
297     }
298 
299 
300     receive() external payable {}
301 }