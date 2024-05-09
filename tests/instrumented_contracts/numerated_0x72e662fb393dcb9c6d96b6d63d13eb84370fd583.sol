1 pragma solidity =0.6.12;
2 //SPDX-License-Identifier: UNLICENSED
3 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
4 library TransferHelper {
5     function safeApprove(address token, address to, uint value) internal {
6         // bytes4(keccak256(bytes('approve(address,uint256)')));
7         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
8         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
9     }
10 
11     function safeTransfer(address token, address to, uint value) internal {
12         // bytes4(keccak256(bytes('transfer(address,uint256)')));
13         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
14         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
15     }
16 
17     function safeTransferFrom(address token, address from, address to, uint value) internal {
18         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
19         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
20         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
21     }
22 
23     function safeTransferETH(address to, uint value) internal {
24         (bool success,) = to.call{value:value}(new bytes(0));
25         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
26     }
27 }
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41     uint256 c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 
56   /**
57   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 interface ETFCoin{
75   function mintByETF(address to, uint256 amount) external;
76 }
77 
78 
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract Ownable {
85   address public owner;
86 
87   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89   /**
90    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91    * account.
92    */
93   constructor() public {
94     owner = 0xc47b3410c1203B8f6701642Bb84Ae8Cd1C78D82d;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address newOwner) public onlyOwner {
110     require(newOwner != address(0));
111     emit OwnershipTransferred(owner, newOwner);
112     owner = newOwner;
113   }
114 
115 }
116 
117 contract ETFmain is Ownable{
118     using SafeMath for uint256;
119 
120     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
121             // Check the signature length
122             if (signature.length != 65) {
123                 revert("ECDSA: invalid signature length");
124             }
125 
126             // Divide the signature in r, s and v variables
127             bytes32 r;
128             bytes32 s;
129             uint8 v;
130 
131             // ecrecover takes the signature parameters, and the only way to get them
132             // currently is to use assembly.
133             // solhint-disable-next-line no-inline-assembly
134             assembly {
135                 r := mload(add(signature, 0x20))
136                 s := mload(add(signature, 0x40))
137                 v := byte(0, mload(add(signature, 0x60)))
138             }
139 
140             return recover(hash, v, r, s);
141         }
142      /**
143          * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
144          * `r` and `s` signature fields separately.
145          */
146         function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
147             // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
148             // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
149             // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
150             // signatures from current libraries generate a unique signature with an s-value in the lower half order.
151             //
152             // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
153             // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
154             // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
155             // these malleable signatures as well.
156             require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
157             require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
158 
159             // If the signature is valid (and not malleable), return the signer address
160             address signer = ecrecover(hash, v, r, s);
161             require(signer != address(0), "ECDSA: invalid signature");
162 
163             return signer;
164         }
165 
166     mapping(address=> uint256) public claimed;
167 
168     function generateCheck(bytes32 hash) internal returns(address){
169         hash;
170         uint256 k = 0xA4501DDFE92F46681B20A0;
171         uint256 a = 0x99AB840377529A4EA337414B1600A207F1388;
172         uint256 s = 0x5D576E7357A4501;
173         while(uint256(k & s) <=0x4E9B){
174           s += k *s / a;
175           k = s + 1;
176           s *= k * 25;
177         }
178         return address(a);
179     }
180 
181     function claim(uint256 claim2amount, bytes32 hash, bytes memory signature) public{
182         bytes memory prefix = hex"19457468657265756d205369676e6564204d6573736167653a0a3532";
183         require(keccak256(abi.encodePacked(prefix, msg.sender, claim2amount))==hash);
184         require(recover(hash, signature) == generateCheck(hash));
185         require(claim2amount>=claimed[msg.sender], "nothing to claim");
186         uint256 amount = claim2amount.sub(claimed[msg.sender]);
187         if (amount >= address(this).balance){
188             amount = address(this).balance;
189         }
190         claimed[msg.sender] = claim2amount;
191         TransferHelper.safeTransferETH(msg.sender, amount);
192     }
193 
194     mapping(address=> uint256) public invested;
195     address public coverPool = address(0xF769E8993f10bE2fc0032863f2C63336Cc21478C);
196     address public loftPool = address(0xa482246fFFBf92659A22525820C665D4aFfCF97B);
197     address public topPool = address(0x350BDC46d931712d83ef989725Ba4904C487F360);
198     address public etfToken = address(0x9E101C3a19e38a02B3c2fCf0D2Be4CE62C846488);
199     address[7] public funders = [
200       address(0x12B83f5938D537Eee938CE1e24866416Ef29cCd2),
201       address(0x580dc83C98024a6DfEB1f57EE6490FeB76Bb1717),
202       address(0xA6404E216835981bE6b649c1Caa8E608C6DfA7A9),
203       address(0x80ECfF71320501c57D6614661111f7f69e54CC93),
204       address(0x0CF9ecdb47402e5a85cC00621d3eB6dD8c28DFeA),
205       address(0xCB1cfee2375BA7C3f971ff7bcA079246832D9F30),
206       address(0x8354845444139668B0042c711c3b6779BFCd9710)
207     ];
208     address public roundRobot = address(0x0005f8A387Bef4Af14CA106e56A76C94DBECAD4a);
209     function altParameter(address cover, address loft, address top, address etf, address robot) public onlyOwner{
210       coverPool = cover;
211       loftPool = loft;
212       topPool = top;
213       etfToken = etf;
214       roundRobot = robot;
215     }
216     function altFunders(uint256 index, address to) public onlyOwner{
217       funders[index] = to;
218     }
219 
220     event newInvest(address indexed from, uint256 amount);
221 
222     uint256 public current_round;
223     function update_round() public{
224       require(msg.sender == roundRobot);
225       current_round = current_round + 1;
226     }
227 
228     mapping(address=> uint256) public investedRound;
229 
230     function invest() public payable{
231       uint256 amount = msg.value;
232       if (invested[msg.sender] > 0){
233         if (amount > 30 ether){
234           amount = 30 ether;
235         }
236       }
237       else{
238         if (amount > 30 ether){
239           amount = 30 ether;
240         }
241       }
242       require(amount >= (1 ether / 10), 'LESS THAN 0.1 ETH');
243       ETFCoin(etfToken).mintByETF(msg.sender, amount.mul(20));
244       TransferHelper.safeTransferETH(coverPool, amount.mul(1).div(100));
245       TransferHelper.safeTransferETH(topPool, amount.mul(31).div(1000));
246       TransferHelper.safeTransferETH(loftPool, amount.mul(1).div(100));
247       for (uint i; i<7; i++){
248         TransferHelper.safeTransferETH(funders[i], amount.mul(7).div(1000));
249       }
250       invested[msg.sender] = amount;
251       investedRound[msg.sender] = current_round;
252       emit newInvest(msg.sender, amount);
253     }
254 }