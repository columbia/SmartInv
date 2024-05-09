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
64     function changeControllerAccess(address _controller, bool _access) public onlyController {
65         controllers[_controller] = _access;
66     }
67 
68 }
69 
70 
71 
72 // Abstract contract for the full ERC 20 Token standard
73 // https://github.com/ethereum/EIPs/issues/20
74 
75 interface ERC20Token {
76 
77     /**
78      * @notice send `_value` token to `_to` from `msg.sender`
79      * @param _to The address of the recipient
80      * @param _value The amount of token to be transferred
81      * @return Whether the transfer was successful or not
82      */
83     function transfer(address _to, uint256 _value) external returns (bool success);
84 
85     /**
86      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
87      * @param _spender The address of the account able to transfer the tokens
88      * @param _value The amount of tokens to be approved for transfer
89      * @return Whether the approval was successful or not
90      */
91     function approve(address _spender, uint256 _value) external returns (bool success);
92 
93     /**
94      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
95      * @param _from The address of the sender
96      * @param _to The address of the recipient
97      * @param _value The amount of token to be transferred
98      * @return Whether the transfer was successful or not
99      */
100     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
101 
102     /**
103      * @param _owner The address from which the balance will be retrieved
104      * @return The balance
105      */
106     function balanceOf(address _owner) external view returns (uint256 balance);
107 
108     /**
109      * @param _owner The address of the account owning tokens
110      * @param _spender The address of the account able to transfer the tokens
111      * @return Amount of remaining tokens allowed to spent
112      */
113     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
114 
115     /**
116      * @notice return total supply of tokens
117      */
118     function totalSupply() external view returns (uint256 supply);
119 
120     event Transfer(address indexed _from, address indexed _to, uint256 _value);
121     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
122 }
123 
124 contract SNTGiveaway is Controlled {
125     
126     mapping(address => bool) public sentToAddress;
127     mapping(bytes5 => bool) public codeUsed;
128     
129     ERC20Token public SNT;
130     
131     uint public ethAmount;
132     uint public sntAmount;
133     bytes32 public root;
134     
135     event AddressFunded(address dest, bytes5 code, uint ethAmount, uint sntAmount);
136     
137     /// @notice Constructor
138     /// @param _sntAddress address SNT contract address
139     /// @param _ethAmount uint Amount of ETH in wei to send
140     /// @param _sntAmount uint Amount of SNT in wei to send
141     /// @param _root bytes32 Merkle tree root
142     constructor(address _sntAddress, uint _ethAmount, uint _sntAmount, bytes32 _root) public {
143         SNT = ERC20Token(_sntAddress);
144         ethAmount = _ethAmount;
145         sntAmount = _sntAmount;
146         root = _root;
147     }
148 
149     /// @notice Determine if a request to send SNT/ETH is valid based on merkle proof, and destination address
150     /// @param _proof bytes32[] Merkle proof
151     /// @param _code bytes5 Unhashed code
152     /// @param _dest address Destination address
153     function validRequest(bytes32[] _proof, bytes5 _code, address _dest) public view returns(bool) {
154         return !sentToAddress[_dest] && !codeUsed[_code] && MerkleProof.verifyProof(_proof, root, keccak256(abi.encodePacked(_code)));
155     }
156 
157     /// @notice Process request for SNT/ETH and send it to destination address
158     /// @param _proof bytes32[] Merkle proof
159     /// @param _code bytes5 Unhashed code
160     /// @param _dest address Destination address
161     function processRequest(bytes32[] _proof, bytes5 _code, address _dest) public onlyController {
162         require(!sentToAddress[_dest] && !codeUsed[_code], "Funds already sent / Code already used");
163         require(MerkleProof.verifyProof(_proof, root, keccak256(abi.encodePacked(_code))), "Invalid code");
164 
165         sentToAddress[_dest] = true;
166         codeUsed[_code] = true;
167         
168         require(SNT.transfer(_dest, sntAmount), "Transfer did not work");
169         _dest.transfer(ethAmount);
170         
171         emit AddressFunded(_dest, _code, ethAmount, sntAmount);
172     }
173     
174     /// @notice Update configuration settings
175     /// @param _ethAmount uint Amount of ETH in wei to send
176     /// @param _sntAmount uint Amount of SNT in wei to send
177     /// @param _root bytes32 Merkle tree root
178     function updateSettings(uint _ethAmount, uint _sntAmount, bytes32 _root) public onlyController {
179         ethAmount = _ethAmount;
180         sntAmount = _sntAmount;
181         root = _root;
182         
183     }
184 
185     function manualSend(address _dest, bytes5 _code) public onlyController {
186         require(!sentToAddress[_dest] && !codeUsed[_code], "Funds already sent / Code already used");
187 
188         sentToAddress[_dest] = true;
189         codeUsed[_code] = true;
190 
191         require(SNT.transfer(_dest, sntAmount), "Transfer did not work");
192         _dest.transfer(ethAmount);
193         
194         emit AddressFunded(_dest, _code, ethAmount, sntAmount);
195     }
196     
197     /// @notice Extract balance in ETH + SNT from the contract and destroy the contract
198     function boom() public onlyController {
199         uint sntBalance = SNT.balanceOf(address(this));
200         require(SNT.transfer(msg.sender, sntBalance), "Transfer did not work");
201         selfdestruct(msg.sender);
202     }
203 
204 
205     function() public payable {
206           
207     }
208 
209     
210 }