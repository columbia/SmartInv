1 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 library ECDSA {
7     enum RecoverError {
8         NoError,
9         InvalidSignature,
10         InvalidSignatureLength,
11         InvalidSignatureS,
12         InvalidSignatureV
13     }
14 
15     function _throwError(RecoverError error) private pure {
16         if (error == RecoverError.NoError) {
17             return; // no error: do nothing
18         } else if (error == RecoverError.InvalidSignature) {
19             revert("ECDSA: invalid signature");
20         } else if (error == RecoverError.InvalidSignatureLength) {
21             revert("ECDSA: invalid signature length");
22         } else if (error == RecoverError.InvalidSignatureS) {
23             revert("ECDSA: invalid signature 's' value");
24         } else if (error == RecoverError.InvalidSignatureV) {
25             revert("ECDSA: invalid signature 'v' value");
26         }
27     }
28 
29    
30     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
31      
32         if (signature.length == 65) {
33             bytes32 r;
34             bytes32 s;
35             uint8 v;
36         
37             assembly {
38                 r := mload(add(signature, 0x20))
39                 s := mload(add(signature, 0x40))
40                 v := byte(0, mload(add(signature, 0x60)))
41             }
42             return tryRecover(hash, v, r, s);
43         } else if (signature.length == 64) {
44             bytes32 r;
45             bytes32 vs;
46    
47             assembly {
48                 r := mload(add(signature, 0x20))
49                 vs := mload(add(signature, 0x40))
50             }
51             return tryRecover(hash, r, vs);
52         } else {
53             return (address(0), RecoverError.InvalidSignatureLength);
54         }
55     }
56 
57 
58     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
59         (address recovered, RecoverError error) = tryRecover(hash, signature);
60         _throwError(error);
61         return recovered;
62     }
63 
64 
65     function tryRecover(
66         bytes32 hash,
67         bytes32 r,
68         bytes32 vs
69     ) internal pure returns (address, RecoverError) {
70         bytes32 s;
71         uint8 v;
72         assembly {
73             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
74             v := add(shr(255, vs), 27)
75         }
76         return tryRecover(hash, v, r, s);
77     }
78 
79     /**
80      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
81      *
82      * _Available since v4.2._
83      */
84     function recover(
85         bytes32 hash,
86         bytes32 r,
87         bytes32 vs
88     ) internal pure returns (address) {
89         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
90         _throwError(error);
91         return recovered;
92     }
93 
94 
95     function tryRecover(
96         bytes32 hash,
97         uint8 v,
98         bytes32 r,
99         bytes32 s
100     ) internal pure returns (address, RecoverError) {
101 
102         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
103             return (address(0), RecoverError.InvalidSignatureS);
104         }
105         if (v != 27 && v != 28) {
106             return (address(0), RecoverError.InvalidSignatureV);
107         }
108 
109         address signer = ecrecover(hash, v, r, s);
110         if (signer == address(0)) {
111             return (address(0), RecoverError.InvalidSignature);
112         }
113 
114         return (signer, RecoverError.NoError);
115     }
116 
117  
118     function recover(
119         bytes32 hash,
120         uint8 v,
121         bytes32 r,
122         bytes32 s
123     ) internal pure returns (address) {
124         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
125         _throwError(error);
126         return recovered;
127     }
128 
129 
130     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
131         
132         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
133     }
134 
135 
136     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
137         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
138     }
139 }
140 
141 
142 
143 
144 
145             
146 pragma solidity >=0.8.0;
147 interface IVeeERC20 {
148     event Approval(address indexed owner, address indexed spender, uint value);
149     event Transfer(address indexed from, address indexed to, uint value);
150 
151     function name() external pure returns (string memory);
152     function symbol() external pure returns (string memory);
153     function decimals() external pure returns (uint8);
154     function totalSupply() external view returns (uint);
155     function balanceOf(address owner) external view returns (uint);
156     function allowance(address owner, address spender) external view returns (uint);
157 
158     function approve(address spender, uint value) external returns (bool);
159     function transfer(address to, uint value) external returns (bool);
160     function transferFrom(address from, address to, uint value) external returns (bool);
161 
162     function DOMAIN_SEPARATOR() external view returns (bytes32);
163     function PERMIT_TYPEHASH() external pure returns (bytes32);
164     function nonces(address owner) external view returns (uint);
165 
166     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
167 }
168 
169 
170 pragma solidity >=0.8.0; 
171 
172 
173 contract Vee is IVeeERC20{
174     using ECDSA for bytes32;
175 
176     string public constant override name = 'Vee';
177     string public constant override symbol = 'VEE';
178     uint8 public constant override decimals = 18;
179     uint public override totalSupply;
180     mapping(address => uint) public override balanceOf;
181     mapping(address => mapping(address => uint)) public override allowance;
182 
183     bytes32 immutable public override DOMAIN_SEPARATOR;
184 
185     bytes32 public constant override PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
186     mapping(address => uint) public override nonces;
187 
188      constructor(uint _totalSupply) {
189         DOMAIN_SEPARATOR = keccak256(
190             abi.encode(
191                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
192                 keccak256(bytes(name)),
193                 keccak256(bytes('1')),
194                 block.chainid,
195                 address(this)
196             )
197         );
198         totalSupply = 0;
199         _mint(msg.sender, _totalSupply);  
200     }
201 
202     function _mint(address to, uint value) internal {
203         totalSupply = totalSupply + value;
204         balanceOf[to] = balanceOf[to] + value;
205         emit Transfer(address(0), to, value);
206     }
207 
208     function _burn(address from, uint value) internal {
209         balanceOf[from] = balanceOf[from] - value;
210         totalSupply = totalSupply - value;
211         emit Transfer(from, address(0), value);
212     }
213 
214     function _approve(address owner, address spender, uint value) private {
215         allowance[owner][spender] = value;
216         emit Approval(owner, spender, value);
217     }
218 
219     function _transfer(address from, address to, uint value) private {
220         balanceOf[from] = balanceOf[from] - value;
221         balanceOf[to] = balanceOf[to] + value;
222         emit Transfer(from, to, value);
223     }
224 
225     function approve(address spender, uint value) external override returns (bool) {
226         _approve(msg.sender, spender, value);
227         return true;
228     }
229 
230     function transfer(address to, uint value) external override returns (bool) {
231         _transfer(msg.sender, to, value);
232         return true;
233     }
234 
235     function transferFrom(address from, address to, uint value) external override returns (bool) {
236         if (allowance[from][msg.sender] != type(uint).max) {
237             allowance[from][msg.sender] = allowance[from][msg.sender] - value;
238         }
239         _transfer(from, to, value);
240         return true;
241     }
242 
243     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external override {
244         require(deadline >= block.timestamp, 'EXPIRED');
245 
246         bytes32 digest = keccak256(
247             abi.encodePacked(
248                 '\x19\x01',
249                 DOMAIN_SEPARATOR,
250                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
251             )
252         );
253         address recoveredAddress = digest.toEthSignedMessageHash().recover(v, r, s);
254         require(recoveredAddress != address(0) && recoveredAddress == owner, 'INVALID_SIGNATURE');
255         _approve(owner, spender, value);
256     }
257 
258 }