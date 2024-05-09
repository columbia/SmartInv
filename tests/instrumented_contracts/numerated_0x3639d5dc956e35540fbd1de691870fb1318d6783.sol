1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title MerkleProof
5  * @dev Merkle proof verification based on
6  * https://github.com/ameensol/merkle-tree-solidity/blob/master/src/MerkleProof.sol
7  */
8 library MerkleProof {
9   /**
10    * @dev Verifies a Merkle proof proving the existence of a leaf in a Merkle tree. Assumes that each pair of leaves
11    * and each pair of pre-images are sorted.
12    * @param _proof Merkle proof containing sibling hashes on the branch from the leaf to the root of the Merkle tree
13    * @param _root Merkle root
14    * @param _leaf Leaf of Merkle tree
15    */
16   function verifyProof(
17     bytes32[] _proof,
18     bytes32 _root,
19     bytes32 _leaf
20   )
21     internal
22     pure
23     returns (bool)
24   {
25     bytes32 computedHash = _leaf;
26 
27     for (uint256 i = 0; i < _proof.length; i++) {
28       bytes32 proofElement = _proof[i];
29 
30       if (computedHash < proofElement) {
31         // Hash(current computed hash + current element of the proof)
32         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
33       } else {
34         // Hash(current element of the proof + current computed hash)
35         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
36       }
37     }
38 
39     // Check if the computed hash (root) is equal to the provided root
40     return computedHash == _root;
41   }
42 }
43 
44 
45 
46 contract Controlled {
47 
48     mapping(address => bool) public controllers;
49 
50     /// @notice The address of the controller is the only address that can call
51     ///  a function with this modifier
52     modifier onlyController { 
53         require(controllers[msg.sender]); 
54         _; 
55     }
56 
57     address public controller;
58 
59     constructor() internal { 
60         controllers[msg.sender] = true; 
61         controller = msg.sender;
62     }
63 
64     /// @notice Changes the controller of the contract
65     /// @param _newController The new controller of the contract
66     function changeController(address _newController) public onlyController {
67         controller = _newController;
68     }
69 
70     function changeControllerAccess(address _controller, bool _access) public onlyController {
71         controllers[_controller] = _access;
72     }
73 
74 }
75 
76 
77 
78 // Abstract contract for the full ERC 20 Token standard
79 // https://github.com/ethereum/EIPs/issues/20
80 
81 interface ERC20Token {
82 
83     /**
84      * @notice send `_value` token to `_to` from `msg.sender`
85      * @param _to The address of the recipient
86      * @param _value The amount of token to be transferred
87      * @return Whether the transfer was successful or not
88      */
89     function transfer(address _to, uint256 _value) external returns (bool success);
90 
91     /**
92      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
93      * @param _spender The address of the account able to transfer the tokens
94      * @param _value The amount of tokens to be approved for transfer
95      * @return Whether the approval was successful or not
96      */
97     function approve(address _spender, uint256 _value) external returns (bool success);
98 
99     /**
100      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value The amount of token to be transferred
104      * @return Whether the transfer was successful or not
105      */
106     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
107 
108     /**
109      * @param _owner The address from which the balance will be retrieved
110      * @return The balance
111      */
112     function balanceOf(address _owner) external view returns (uint256 balance);
113 
114     /**
115      * @param _owner The address of the account owning tokens
116      * @param _spender The address of the account able to transfer the tokens
117      * @return Amount of remaining tokens allowed to spent
118      */
119     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
120 
121     /**
122      * @notice return total supply of tokens
123      */
124     function totalSupply() external view returns (uint256 supply);
125 
126     event Transfer(address indexed _from, address indexed _to, uint256 _value);
127     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
128 }
129 
130 
131 contract SNTGiveaway is Controlled {
132     
133     mapping(address => bool) public sentToAddress;
134     mapping(bytes5 => bool) public codeUsed;
135     
136     ERC20Token public SNT;
137     
138     uint public ethAmount;
139     uint public sntAmount;
140     bytes32 public root;
141     
142     event AddressFunded(address dest, bytes5 code, uint ethAmount, uint sntAmount);
143     
144     /// @notice Constructor
145     /// @param _sntAddress address SNT contract address
146     /// @param _ethAmount uint Amount of ETH in wei to send
147     /// @param _sntAmount uint Amount of SNT in wei to send
148     /// @param _root bytes32 Merkle tree root
149     constructor(address _sntAddress, uint _ethAmount, uint _sntAmount, bytes32 _root) public {
150         SNT = ERC20Token(_sntAddress);
151         ethAmount = _ethAmount;
152         sntAmount = _sntAmount;
153         root = _root;
154     }
155 
156     /// @notice Determine if a request to send SNT/ETH is valid based on merkle proof, and destination address
157     /// @param _proof bytes32[] Merkle proof
158     /// @param _code bytes5 Unhashed code
159     /// @param _dest address Destination address
160     function validRequest(bytes32[] _proof, bytes5 _code, address _dest) public view returns(bool) {
161         return !sentToAddress[_dest] && !codeUsed[_code] && MerkleProof.verifyProof(_proof, root, keccak256(abi.encodePacked(_code)));
162     }
163 
164     /// @notice Process request for SNT/ETH and send it to destination address
165     /// @param _proof bytes32[] Merkle proof
166     /// @param _code bytes5 Unhashed code
167     /// @param _dest address Destination address
168     function processRequest(bytes32[] _proof, bytes5 _code, address _dest) public onlyController {
169         require(!sentToAddress[_dest] && !codeUsed[_code], "Funds already sent / Code already used");
170         require(MerkleProof.verifyProof(_proof, root, keccak256(abi.encodePacked(_code))), "Invalid code");
171 
172         sentToAddress[_dest] = true;
173         codeUsed[_code] = true;
174         
175         require(SNT.transfer(_dest, sntAmount), "Transfer did not work");
176         _dest.transfer(ethAmount);
177         
178         emit AddressFunded(_dest, _code, ethAmount, sntAmount);
179     }
180     
181     /// @notice Update configuration settings
182     /// @param _ethAmount uint Amount of ETH in wei to send
183     /// @param _sntAmount uint Amount of SNT in wei to send
184     /// @param _root bytes32 Merkle tree root
185     function updateSettings(uint _ethAmount, uint _sntAmount, bytes32 _root) public onlyController {
186         ethAmount = _ethAmount;
187         sntAmount = _sntAmount;
188         root = _root;
189         
190     }
191 
192     function manualSend(address _dest, bytes5 _code) public onlyController {
193         require(!sentToAddress[_dest] && !codeUsed[_code], "Funds already sent / Code already used");
194 
195         sentToAddress[_dest] = true;
196         codeUsed[_code] = true;
197 
198         require(SNT.transfer(_dest, sntAmount), "Transfer did not work");
199         _dest.transfer(ethAmount);
200         
201         emit AddressFunded(_dest, _code, ethAmount, sntAmount);
202     }
203     
204     /// @notice Extract balance in ETH + SNT from the contract and destroy the contract
205     function boom() public onlyController {
206         uint sntBalance = SNT.balanceOf(address(this));
207         require(SNT.transfer(msg.sender, sntBalance), "Transfer did not work");
208         selfdestruct(msg.sender);
209     }
210     
211     /// @notice Extract balance in ETH + SNT from the contract
212     function retrieveFunds() public onlyController {
213         uint sntBalance = SNT.balanceOf(address(this));
214         require(SNT.transfer(msg.sender, sntBalance), "Transfer did not work");
215     }
216 
217 
218     function() public payable {
219           
220     }
221 
222     
223 }