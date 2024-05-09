1 pragma solidity ^0.4.26;
2 
3 library SafeMath
4 {
5     function mul(uint256 a, uint256 b) internal pure
6         returns (uint256)
7     {
8         uint256 c = a * b;
9 
10         assert(a == 0 || c / a == b);
11 
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure
16         returns (uint256)
17     {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure
25         returns (uint256)
26     {
27         assert(b <= a);
28 
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure
33         returns (uint256)
34     {
35         uint256 c = a + b;
36 
37         assert(c >= a);
38 
39         return c;
40     }
41 }
42 
43 contract Ownable
44 {
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     function Ownable() public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address newOwner) public onlyOwner {
59         require(newOwner != address(0));
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62     }
63 }
64 
65 contract TokenERC20 is Ownable {
66     bytes32 public standard;
67     bytes32 public name;
68     bytes32 public symbol;
69     uint256 public totalSupply;
70     uint8 public decimals;
71     bool public allowTransactions;
72     mapping (address => uint256) public balanceOf;
73     mapping (address => mapping (address => uint256)) public allowance;
74     function transfer(address _to, uint256 _value) returns (bool success);
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
76     function approve(address _spender, uint256 _value) returns (bool success);
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
78 }
79 
80 
81 library ECRecovery {
82 
83   /**
84    * @dev Recover signer address from a message by using his signature
85    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
86    * @param sig bytes signature, the signature is generated using web3.eth.sign()
87    */
88   function recover(bytes32 hash, bytes sig) public pure returns (address) {
89     bytes32 r;
90     bytes32 s;
91     uint8 v;
92 
93     //Check the signature length
94     if (sig.length != 65) {
95       return (address(0));
96     }
97 
98     // Divide the signature in r, s and v variables
99     assembly {
100       r := mload(add(sig, 32))
101       s := mload(add(sig, 64))
102       v := byte(0, mload(add(sig, 96)))
103     }
104 
105     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
106     if (v < 27) {
107       v += 27;
108     }
109 
110     // If the version is correct return the signer address
111     if (v != 27 && v != 28) {
112       return (address(0));
113     } else {
114       return ecrecover(hash, v, r, s);
115     }
116   }
117 
118 }
119 
120 contract StmVendor is Ownable {
121     using ECRecovery for bytes32;
122     
123     uint8 constant public EMPTY = 0x0;
124 
125     TokenERC20 public streamityContractAddress;
126 
127     mapping(bytes32 => Deal) public stmTransfers;
128 
129     function StmVendor(address streamityContract) public {
130         require(streamityContract != 0x0);
131         streamityContractAddress = TokenERC20(streamityContract);
132     }
133 
134     struct Deal {
135         uint256 value;
136     }
137     
138     event Multisended(uint256 total);
139 
140     event Trade(uint8 _vendor, bytes32 _tradeID);
141 
142     function payAltCoin(uint8 _vendor, bytes32 _tradeID, uint256 _value, bytes _sign) 
143     external 
144     {
145         bytes32 _hashDeal = keccak256(_tradeID, _value);
146         verifyDeal(_hashDeal, _sign);
147         bool result = streamityContractAddress.transferFrom(msg.sender, address(this), _value);
148         require(result == true);
149         startDeal(_vendor, _hashDeal, _value, _tradeID);
150     }
151 
152     function verifyDeal(bytes32 _hashDeal, bytes _sign) private view {
153         require(_hashDeal.recover(_sign) == owner);
154         require(stmTransfers[_hashDeal].value == EMPTY); 
155     }
156 
157     function startDeal(uint8 _vendor, bytes32 _hashDeal, uint256 _value, bytes32 _tradeID) 
158     private
159     {
160         Deal storage userDeals = stmTransfers[_hashDeal];
161         userDeals.value = _value; 
162         emit Trade(_vendor, _tradeID);
163     }
164 
165     function withdrawCommisionToAddressAltCoin(address _to, uint256 _amount) external onlyOwner {
166         streamityContractAddress.transfer(_to, _amount);
167     }
168 
169     function setStreamityContractAddress(address newAddress) 
170     external onlyOwner 
171     {
172         streamityContractAddress = TokenERC20(newAddress);
173     }
174     
175     function multiTransfer(address[] _addresses, uint256[] _amounts)
176     external onlyOwner
177     returns(bool)
178     {
179         uint256 total = 0;
180         uint8 i = 0;
181         for (i; i < _addresses.length; i++) {
182             streamityContractAddress.transfer(_addresses[i], _amounts[i]);
183             total += _amounts[i];
184         }
185         Multisended(total);
186         return true;
187     }
188 }