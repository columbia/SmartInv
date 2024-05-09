1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * See https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   function totalSupply() public view returns (uint256);
80   function balanceOf(address _who) public view returns (uint256);
81   function transfer(address _to, uint256 _value) public returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
86 
87 pragma solidity ^0.4.24;
88 
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address _owner, address _spender)
97     public view returns (uint256);
98 
99   function transferFrom(address _from, address _to, uint256 _value)
100     public returns (bool);
101 
102   function approve(address _spender, uint256 _value) public returns (bool);
103   event Approval(
104     address indexed owner,
105     address indexed spender,
106     uint256 value
107   );
108 }
109 
110 // File: contracts/promocode/PromoCode.sol
111 
112 pragma solidity ^0.4.24;
113 
114 
115 
116 contract PromoCode is Ownable {
117   ERC20 public token;
118   mapping(bytes32 => bool) public used;
119   uint256 public amount;
120 
121   event Redeem(address user, uint256 amount, string code);
122 
123   function PromoCode(ERC20 _token, uint256 _amount) {
124     amount = _amount;
125     token = _token;
126   }
127 
128   function setAmount(uint256 _amount) onlyOwner {
129     amount = _amount;
130   }
131 
132   function redeem(string promoCode, bytes signature) {
133     bytes32 hash = keccak256(abi.encodePacked(promoCode));
134     bytes32 r;
135     bytes32 s;
136     uint8 v;
137     assembly {
138       r := mload(add(signature, 32))
139       s := mload(add(signature, 64))
140       v := and(mload(add(signature, 65)), 255)
141     }
142     if (v < 27) v += 27;
143 
144     require(!used[hash]);
145     used[hash] = true;
146     require(verifyString(promoCode, v, r, s) == owner);
147     address user = msg.sender;
148     require(token.transferFrom(owner, user, amount));
149     emit Redeem(user, amount, promoCode);
150   }
151 
152   // https://blog.ricmoo.com/verifying-messages-in-solidity-50a94f82b2ca
153   // Returns the address that signed a given string message
154   function verifyString(string message, uint8 v, bytes32 r, bytes32 s) public pure returns (address signer) {
155     // The message header; we will fill in the length next
156     string memory header = "\x19Ethereum Signed Message:\n000000";
157     uint256 lengthOffset;
158     uint256 length;
159     assembly {
160     // The first word of a string is its length
161       length := mload(message)
162     // The beginning of the base-10 message length in the prefix
163       lengthOffset := add(header, 57)
164     }
165     // Maximum length we support
166     require(length <= 999999);
167     // The length of the message's length in base-10
168     uint256 lengthLength = 0;
169     // The divisor to get the next left-most message length digit
170     uint256 divisor = 100000;
171     // Move one digit of the message length to the right at a time
172     while (divisor != 0) {
173       // The place value at the divisor
174       uint256 digit = length / divisor;
175       if (digit == 0) {
176         // Skip leading zeros
177         if (lengthLength == 0) {
178           divisor /= 10;
179           continue;
180         }
181       }
182       // Found a non-zero digit or non-leading zero digit
183       lengthLength++;
184       // Remove this digit from the message length's current value
185       length -= digit * divisor;
186       // Shift our base-10 divisor over
187       divisor /= 10;
188 
189       // Convert the digit to its ASCII representation (man ascii)
190       digit += 0x30;
191       // Move to the next character and write the digit
192       lengthOffset++;
193       assembly {
194         mstore8(lengthOffset, digit)
195       }
196     }
197     // The null string requires exactly 1 zero (unskip 1 leading 0)
198     if (lengthLength == 0) {
199       lengthLength = 1 + 0x19 + 1;
200     } else {
201       lengthLength += 1 + 0x19;
202     }
203     // Truncate the tailing zeros from the header
204     assembly {
205       mstore(header, lengthLength)
206     }
207     // Perform the elliptic curve recover operation
208     bytes32 check = keccak256(header, message);
209     return ecrecover(check, v, r, s);
210   }
211 }