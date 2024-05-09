1 /* ERC820 Pseudo-introspection Registry Contract
2  * This standard defines a universal registry smart contract where any address
3  * (contract or regular account) can register which interface it supports and
4  * which smart contract is responsible for its implementation.
5  *
6  * Written in 2018 by Jordi Baylina and Jacques Dafflon
7  *
8  * To the extent possible under law, the author(s) have dedicated all copyright
9  * and related and neighboring rights to this software to the public domain
10  * worldwide. This software is distributed without any warranty.
11  *
12  * You should have received a copy of the CC0 Public Domain Dedication along
13  * with this software. If not, see
14  * <http://creativecommons.org/publicdomain/zero/1.0/>.
15  *
16  *    ███████╗██████╗  ██████╗ █████╗ ██████╗  ██████╗
17  *    ██╔════╝██╔══██╗██╔════╝██╔══██╗╚════██╗██╔═████╗
18  *    █████╗  ██████╔╝██║     ╚█████╔╝ █████╔╝██║██╔██║
19  *    ██╔══╝  ██╔══██╗██║     ██╔══██╗██╔═══╝ ████╔╝██║
20  *    ███████╗██║  ██║╚██████╗╚█████╔╝███████╗╚██████╔╝
21  *    ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚════╝ ╚══════╝ ╚═════╝
22  *
23  *    ██████╗ ███████╗ ██████╗ ██╗███████╗████████╗██████╗ ██╗   ██╗
24  *    ██╔══██╗██╔════╝██╔════╝ ██║██╔════╝╚══██╔══╝██╔══██╗╚██╗ ██╔╝
25  *    ██████╔╝█████╗  ██║  ███╗██║███████╗   ██║   ██████╔╝ ╚████╔╝
26  *    ██╔══██╗██╔══╝  ██║   ██║██║╚════██║   ██║   ██╔══██╗  ╚██╔╝
27  *    ██║  ██║███████╗╚██████╔╝██║███████║   ██║   ██║  ██║   ██║
28  *    ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝
29  *
30  */
31 pragma solidity 0.4.24;
32 // IV is value needed to have a vanity address starting with `0x820`.
33 // IV: 15222
34 
35 /// @dev The interface a contract MUST implement if it is the implementer of
36 /// some (other) interface for any address other than itself.
37 interface ERC820ImplementerInterface {
38     /// @notice Indicates whether the contract implements the interface `interfaceHash` for the address `addr` or not.
39     /// @param interfaceHash keccak256 hash of the name of the interface
40     /// @param addr Address for which the contract will implement the interface
41     /// @return ERC820_ACCEPT_MAGIC only if the contract implements `interfaceHash` for the address `addr`.
42     function canImplementInterfaceForAddress(bytes32 interfaceHash, address addr) external view returns(bytes32);
43 }
44 
45 
46 /// @title ERC820 Pseudo-introspection Registry Contract
47 /// @author Jordi Baylina and Jacques Dafflon
48 /// @notice This contract is the official implementation of the ERC820 Registry.
49 /// @notice For more details, see https://eips.ethereum.org/EIPS/eip-820
50 contract ERC820Registry {
51     /// @notice ERC165 Invalid ID.
52     bytes4 constant INVALID_ID = 0xffffffff;
53     /// @notice Method ID for the ERC165 supportsInterface method (= `bytes4(keccak256('supportsInterface(bytes4)'))`).
54     bytes4 constant ERC165ID = 0x01ffc9a7;
55     /// @notice Magic value which is returned if a contract implements an interface on behalf of some other address.
56     bytes32 constant ERC820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC820_ACCEPT_MAGIC"));
57 
58     mapping (address => mapping(bytes32 => address)) interfaces;
59     mapping (address => address) managers;
60     mapping (address => mapping(bytes4 => bool)) erc165Cached;
61 
62     /// @notice Indicates a contract is the `implementer` of `interfaceHash` for `addr`.
63     event InterfaceImplementerSet(address indexed addr, bytes32 indexed interfaceHash, address indexed implementer);
64     /// @notice Indicates `newManager` is the address of the new manager for `addr`.
65     event ManagerChanged(address indexed addr, address indexed newManager);
66 
67     /// @notice Query if an address implements an interface and through which contract.
68     /// @param _addr Address being queried for the implementer of an interface.
69     /// (If `_addr == 0` then `msg.sender` is assumed.)
70     /// @param _interfaceHash keccak256 hash of the name of the interface as a string.
71     /// E.g., `web3.utils.keccak256('ERC777Token')`.
72     /// @return The address of the contract which implements the interface `_interfaceHash` for `_addr`
73     /// or `0x0` if `_addr` did not register an implementer for this interface.
74     function getInterfaceImplementer(address _addr, bytes32 _interfaceHash) external view returns (address) {
75         address addr = _addr == 0 ? msg.sender : _addr;
76         if (isERC165Interface(_interfaceHash)) {
77             bytes4 erc165InterfaceHash = bytes4(_interfaceHash);
78             return implementsERC165Interface(addr, erc165InterfaceHash) ? addr : 0;
79         }
80         return interfaces[addr][_interfaceHash];
81     }
82 
83     /// @notice Sets the contract which implements a specific interface for an address.
84     /// Only the manager defined for that address can set it.
85     /// (Each address is the manager for itself until it sets a new manager.)
86     /// @param _addr Address to define the interface for. (If `_addr == 0` then `msg.sender` is assumed.)
87     /// @param _interfaceHash keccak256 hash of the name of the interface as a string.
88     /// For example, `web3.utils.keccak256('ERC777TokensRecipient')` for the `ERC777TokensRecipient` interface.
89     function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external {
90         address addr = _addr == 0 ? msg.sender : _addr;
91         require(getManager(addr) == msg.sender, "Not the manager");
92 
93         require(!isERC165Interface(_interfaceHash), "Must not be a ERC165 hash");
94         if (_implementer != 0 && _implementer != msg.sender) {
95             require(
96                 ERC820ImplementerInterface(_implementer)
97                     .canImplementInterfaceForAddress(_interfaceHash, addr) == ERC820_ACCEPT_MAGIC,
98                 "Does not implement the interface"
99             );
100         }
101         interfaces[addr][_interfaceHash] = _implementer;
102         emit InterfaceImplementerSet(addr, _interfaceHash, _implementer);
103     }
104 
105     /// @notice Sets the `_newManager` as manager for the `_addr` address.
106     /// The new manager will be able to call `setInterfaceImplementer` for `_addr`.
107     /// @param _addr Address for which to set the new manager.
108     /// @param _newManager Address of the new manager for `addr`. (Pass `0x0` to reset the manager to `_addr` itself.)
109     function setManager(address _addr, address _newManager) external {
110         require(getManager(_addr) == msg.sender, "Not the manager");
111         managers[_addr] = _newManager == _addr ? 0 : _newManager;
112         emit ManagerChanged(_addr, _newManager);
113     }
114 
115     /// @notice Get the manager of an address.
116     /// @param _addr Address for which to return the manager.
117     /// @return Address of the manager for a given address.
118     function getManager(address _addr) public view returns(address) {
119         // By default the manager of an address is the same address
120         if (managers[_addr] == 0) {
121             return _addr;
122         } else {
123             return managers[_addr];
124         }
125     }
126 
127     /// @notice Compute the keccak256 hash of an interface given its name.
128     /// @param _interfaceName Name of the interface.
129     /// @return The keccak256 hash of an interface name.
130     function interfaceHash(string _interfaceName) external pure returns(bytes32) {
131         return keccak256(abi.encodePacked(_interfaceName));
132     }
133 
134     /* --- ERC165 Related Functions --- */
135     /* --- Developed in collaboration with William Entriken. --- */
136 
137     /// @notice Updates the cache with whether the contract implements an ERC165 interface or not.
138     /// @param _contract Address of the contract for which to update the cache.
139     /// @param _interfaceId ERC165 interface for which to update the cache.
140     function updateERC165Cache(address _contract, bytes4 _interfaceId) external {
141         interfaces[_contract][_interfaceId] = implementsERC165InterfaceNoCache(_contract, _interfaceId) ? _contract : 0;
142         erc165Cached[_contract][_interfaceId] = true;
143     }
144 
145     /// @notice Checks whether a contract implements an ERC165 interface or not.
146     /// The result may be cached, if not a direct lookup is performed.
147     /// @param _contract Address of the contract to check.
148     /// @param _interfaceId ERC165 interface to check.
149     /// @return `true` if `_contract` implements `_interfaceId`, false otherwise.
150     function implementsERC165Interface(address _contract, bytes4 _interfaceId) public view returns (bool) {
151         if (!erc165Cached[_contract][_interfaceId]) {
152             return implementsERC165InterfaceNoCache(_contract, _interfaceId);
153         }
154         return interfaces[_contract][_interfaceId] == _contract;
155     }
156 
157     /// @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
158     /// @param _contract Address of the contract to check.
159     /// @param _interfaceId ERC165 interface to check.
160     /// @return `true` if `_contract` implements `_interfaceId`, false otherwise.
161     function implementsERC165InterfaceNoCache(address _contract, bytes4 _interfaceId) public view returns (bool) {
162         uint256 success;
163         uint256 result;
164 
165         (success, result) = noThrowCall(_contract, ERC165ID);
166         if (success == 0 || result == 0) {
167             return false;
168         }
169 
170         (success, result) = noThrowCall(_contract, INVALID_ID);
171         if (success == 0 || result != 0) {
172             return false;
173         }
174 
175         (success, result) = noThrowCall(_contract, _interfaceId);
176         if (success == 1 && result == 1) {
177             return true;
178         }
179         return false;
180     }
181 
182     /// @notice Checks whether the hash is a ERC165 interface (ending with 28 zeroes) or not.
183     /// @param _interfaceHash The hash to check.
184     /// @return `true` if the hash is a ERC165 interface (ending with 28 zeroes), `false` otherwise.
185     function isERC165Interface(bytes32 _interfaceHash) internal pure returns (bool) {
186         return _interfaceHash & 0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0;
187     }
188 
189     /// @dev Make a call on a contract without throwing if the function does not exist.
190     function noThrowCall(address _contract, bytes4 _interfaceId)
191         internal view returns (uint256 success, uint256 result)
192     {
193         bytes4 erc165ID = ERC165ID;
194 
195         assembly {
196                 let x := mload(0x40)               // Find empty storage location using "free memory pointer"
197                 mstore(x, erc165ID)                // Place signature at beginning of empty storage
198                 mstore(add(x, 0x04), _interfaceId) // Place first argument directly next to signature
199 
200                 success := staticcall(
201                     30000,                         // 30k gas
202                     _contract,                     // To addr
203                     x,                             // Inputs are stored at location x
204                     0x08,                          // Inputs are 8 bytes long
205                     x,                             // Store output over input (saves space)
206                     0x20                           // Outputs are 32 bytes long
207                 )
208 
209                 result := mload(x)                 // Load the result
210         }
211     }
212 }