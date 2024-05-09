1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-04
3 */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Friday, July 20, 2018
7  (UTC) */
8 
9 pragma solidity ^0.4.26;
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 /**
52  * @title Helps contracts guard agains reentrancy attacks.
53  * @author Remco Bloemen <remco@2π.com>
54  * @notice If you mark a function `nonReentrant`, you should also
55  * mark it `external`.
56  */
57 contract ReentrancyGuard {
58 
59   /**
60    * @dev We use a single lock for the whole contract.
61    */
62   bool private reentrancy_lock = false;
63 
64   /**
65    * @dev Prevents a contract from calling itself, directly or indirectly.
66    * @notice If you mark a function `nonReentrant`, you should also
67    * mark it `external`. Calling one nonReentrant function from
68    * another is not supported. Instead, you can implement a
69    * `private` function doing the actual work, and a `external`
70    * wrapper marked as `nonReentrant`.
71    */
72   modifier nonReentrant() {
73     require(!reentrancy_lock);
74     reentrancy_lock = true;
75     _;
76     reentrancy_lock = false;
77   }
78 
79 }
80 
81 /**
82  * @title Eliptic curve signature operations
83  *
84  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
85  */
86 
87 library ECRecovery {
88 
89   /**
90    * @dev Recover signer address from a message by using his signature
91    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
92    * @param sig bytes signature, the signature is generated using web3.eth.sign()
93    */
94   function recover(bytes32 hash, bytes sig) public pure returns (address) {
95     bytes32 r;
96     bytes32 s;
97     uint8 v;
98 
99     //Check the signature length
100     if (sig.length != 65) {
101       return (address(0));
102     }
103 
104     // Divide the signature in r, s and v variables
105     assembly {
106       r := mload(add(sig, 32))
107       s := mload(add(sig, 64))
108       v := byte(0, mload(add(sig, 96)))
109     }
110 
111     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
112     if (v < 27) {
113       v += 27;
114     }
115 
116     // If the version is correct return the signer address
117     if (v != 27 && v != 28) {
118       return (address(0));
119     } else {
120       return ecrecover(hash, v, r, s);
121     }
122   }
123 
124 }
125 
126 library SafeMath {
127     
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b <= a, "SafeMath: subtraction overflow");
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144         // benefit is lost if 'b' is also tested.
145         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
146         if (a == 0) {
147             return 0;
148         }
149 
150         uint256 c = a * b;
151         require(c / a == b, "SafeMath: multiplication overflow");
152 
153         return c;
154     }
155 
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Solidity only automatically asserts when dividing by 0
158         require(b > 0, "SafeMath: division by zero");
159         uint256 c = a / b;
160         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161 
162         return c;
163     }
164 
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         require(b != 0, "SafeMath: modulo by zero");
167         return a % b;
168     }
169 }
170 
171 contract STMPackage is Ownable, ReentrancyGuard {
172     using ECRecovery for bytes32;
173 
174     //mapping(bytes32 => Deal) public streamityTransfers;
175 
176     //constructor(address streamityContract) public {
177     //    require(streamityContract != 0x0); 
178     //}
179 
180     //struct Deal {
181     //    uint256 value;
182     //}
183 
184     event MultiTransfer(
185         address _to,
186         uint _amount
187     );
188 
189     event BuyPackage(bytes32 _tradeId);
190     
191     function pay(bytes32 _tradeID, uint256 _value, bytes _sign) 
192     external 
193     payable 
194     {
195         require(msg.value > 0);
196         require(msg.value == _value);
197         bytes32 _hashDeal = keccak256(_tradeID,  msg.value);
198         verifyDeal(_hashDeal, _sign);
199         emit BuyPackage(_tradeID);
200     }
201 
202     function verifyDeal(bytes32 _hashDeal, bytes _sign) private view {
203         require(_hashDeal.recover(_sign) == owner); 
204     }
205 
206     function withdrawToAddress(address _to, uint256 _amount) external onlyOwner {
207         _to.transfer(_amount);
208     }
209     
210     function multiTransfer(address[] _addresses, uint[] _amounts)
211     external onlyOwner
212     returns(bool)
213     {
214         for (uint i = 0; i < _addresses.length; i++) {
215             _safeTransfer(_addresses[i], _amounts[i]);
216             emit MultiTransfer(_addresses[i], _amounts[i]);
217         }
218         return true;
219     }
220     
221     function _safeTransfer(address _to, uint _amount) internal {
222         require(_to != 0);
223         _to.transfer(_amount);
224     }
225 }