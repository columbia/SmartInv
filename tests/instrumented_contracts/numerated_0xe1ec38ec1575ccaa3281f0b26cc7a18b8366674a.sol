1 pragma solidity ^0.4.24;
2 
3 // TokenLoot v2.0 2e59d4
4 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 
48 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   uint256 public totalSupply;
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 // File: zeppelin-solidity/contracts/token/ERC20.sol
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 // File: contracts/TokenLoot.sol
76 
77 /// @title Token Loot Contract
78 /// @author Julia Altenried, Yuriy Kashnikov
79 
80 contract TokenLoot is Ownable {
81 
82   // FIELDS
83   /* signer address, verified in 'receiveTokenLoot' method, can be set by owner only */
84   address public neverdieSigner;
85   /* Nonces */
86   mapping (address => uint256) public nonces;
87   /* Tokens */
88   address[] public tokens;
89 
90   // EVENTS
91   event ReceiveLoot(address indexed sender,
92                     uint256 nonce,
93                     address[] tokens,
94                     uint256[] amounts);
95  
96 
97   // SETTERS
98   function setNeverdieSignerAddress(address _to) public onlyOwner {
99     neverdieSigner = _to;
100   }
101 
102   function setTokens(address[] _tokens) public onlyOwner {
103     for (uint256 i = 0; i < tokens.length; i++) {
104       tokens[i] = _tokens[i];
105     }
106     for (uint256 j = _tokens.length; j < _tokens.length; j++) {
107       tokens.push(_tokens[j]);
108     }
109   }
110 
111   /// @param _tokens tokens addresses
112   /// @param _signer signer address, verified further in swap functions
113   constructor(address[] _tokens, address _signer) {
114     for (uint256 i = 0; i < _tokens.length; i++) {
115       tokens.push(_tokens[i]);
116     }
117     neverdieSigner = _signer;
118   }
119 
120   function receiveTokenLoot(uint256[] _amounts, 
121                             uint256 _nonce, 
122                             uint8 _v, 
123                             bytes32 _r, 
124                             bytes32 _s) {
125 
126     // reject if the new nonce is lower or equal to the current one
127     require(_nonce > nonces[msg.sender],
128             "wrong nonce");
129     nonces[msg.sender] = _nonce;
130 
131     // verify signature
132     address signer = ecrecover(keccak256(msg.sender, 
133                                          _nonce,
134                                          _amounts), _v, _r, _s);
135     require(signer == neverdieSigner,
136             "signature verification failed");
137 
138     // transer tokens
139     
140     for (uint256 i = 0; i < _amounts.length; i++) {
141       if (_amounts[i] > 0) {
142         assert(ERC20(tokens[i]).transfer(msg.sender, _amounts[i]));
143       }
144     }
145     
146 
147     // emit event
148     ReceiveLoot(msg.sender, _nonce, tokens, _amounts);
149   }
150 
151   /// @dev fallback function to reject any ether coming directly to the contract
152   function () payable public { 
153       revert(); 
154   }
155 
156   /// @dev withdraw all SKL and XP tokens
157   function withdraw() public onlyOwner {
158     for (uint256 i = 0; i < tokens.length; i++) {
159       uint256 amount = ERC20(tokens[i]).balanceOf(this);
160       if (amount > 0) ERC20(tokens[i]).transfer(msg.sender, amount);
161     }
162   }
163 
164   /// @dev kill contract, but before transfer all SKL and XP tokens 
165   function kill() onlyOwner public {
166     withdraw();
167     selfdestruct(owner);
168   }
169 
170 }