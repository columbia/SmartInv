1 pragma solidity 0.6.12;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }	
12 }
13 
14 contract Ownable is Context {
15     address private _owner;
16     address public admin;
17     address public dev;
18     
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor () internal {
25         address msgSender = _msgSender();
26         _owner = msgSender;
27         emit OwnershipTransferred(address(0), msgSender);
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(_owner == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     function renounceOwnership() public virtual onlyOwner {
46         emit OwnershipTransferred(_owner, address(0));
47         _owner = address(0);
48     }
49 
50     function transferOwnership(address newOwner) public virtual onlyOwner {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         emit OwnershipTransferred(_owner, newOwner);
53         _owner = newOwner;
54     }
55 
56     function setAdmin(address _admin) public onlyOwner {
57         admin = _admin;
58     }
59 
60     function setDev(address _dev) public onlyOwner {
61         dev = _dev;
62     }
63     
64     modifier onlyAdmin {
65         require(msg.sender == admin || msg.sender == _owner);
66         _;
67     }
68     
69     modifier onlyDev {
70         require(msg.sender == dev || msg.sender == admin || msg.sender == _owner);
71         _;
72     }    
73 }
74 
75 library SafeMath {
76 
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80 
81         return c;
82     }
83 
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91 
92         return c;
93     }
94 
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97         // benefit is lost if 'b' is also tested.
98         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
99         if (a == 0) {
100             return 0;
101         }
102 
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105 
106         return c;
107     }
108 
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112 
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117 
118         return c;
119     }
120 
121     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
122         return mod(a, b, "SafeMath: modulo by zero");
123     }
124 
125    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
126         require(b != 0, errorMessage);
127         return a % b;
128     }
129 }
130 
131 abstract contract ContractConn{
132     function transfer(address _to, uint256 _value) virtual public;
133     function balanceOf(address who) virtual public view returns (uint256);
134 }
135 
136 
137 
138 contract Minter is Ownable {
139 
140     using SafeMath for uint256;
141     
142     uint256 public userMinted = 0;
143     bool public checkDeadline = false;   
144 
145     mapping (uint256 => bool) public claimedOrderId;
146     
147     ContractConn public zild;   
148     
149     event EventUpdateCheckDeadline(bool newValue);
150 
151     event EventClaim(uint256 orderId, address userAddress,uint256 amount);
152     
153     constructor(address _token) public {
154         zild = ContractConn(_token);
155     }    
156 
157     function claim(uint256 orderId, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public  {
158         if(checkDeadline){
159             require(deadline >= block.timestamp, "expired order");
160         }
161         
162         require(claimedOrderId[orderId] == false, "already claimed");
163       
164         bytes32 hash1 = keccak256(
165             abi.encode(
166                 address(this),
167                 msg.sender,
168                 orderId,
169                 amount,
170                 deadline
171             )
172         );
173 
174         bytes32 hash2 = keccak256(
175             abi.encodePacked(
176                 "\x19Ethereum Signed Message:\n32",
177                 hash1
178             )
179         );
180 
181         address signer = openzeppelin_recover(hash2, v, r, s);
182 
183         require(signer == dev, "invalid signer");
184 
185         zild.transfer(msg.sender,amount);
186         userMinted = userMinted.add(amount);
187         
188         claimedOrderId[orderId] = true;
189         emit EventClaim(orderId, msg.sender, amount);
190     }
191 
192     // for special case
193     function claimByAdmin(uint256 orderId, address _to, uint256 amount) public onlyAdmin {        
194         require(claimedOrderId[orderId] == false, "already claimed");
195         claimedOrderId[orderId] = true;   
196         zild.transfer(_to,amount);
197         userMinted = userMinted.add(amount);
198         emit EventClaim(orderId, _to,amount);
199     }
200 
201     function updateCheckDeadline(bool _checkDeadline) public onlyAdmin {        
202         checkDeadline = _checkDeadline;
203         emit EventUpdateCheckDeadline(_checkDeadline);
204     } 
205 
206     /**
207      *  openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
208      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
209      * `r` and `s` signature fields separately.
210      */
211     function openzeppelin_recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
212         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
213         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
214         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
215         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
216         //
217         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
218         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
219         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
220         // these malleable signatures as well.
221         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
222         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
223 
224         // If the signature is valid (and not malleable), return the signer address
225         address signer = ecrecover(hash, v, r, s);
226         require(signer != address(0), "ECDSA: invalid signature");
227 
228         return signer;
229     }
230 }