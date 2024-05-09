1 pragma solidity ^0.4.18;
2 
3 
4 /**
5 * @title Ownable
6 * @dev The Ownable contract has an owner address, and provides basic authorization control
7 * functions, this simplifies the implementation of "user permissions".
8 */
9 contract Ownable {
10  address public owner;
11 
12 
13  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16  /**
17   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18   * account.
19   */
20  function Ownable() public {
21    owner = msg.sender;
22  }
23 
24  /**
25   * @dev Throws if called by any account other than the owner.
26   */
27  modifier onlyOwner() {
28    require(msg.sender == owner);
29    _;
30  }
31 
32  /**
33   * @dev Allows the current owner to transfer control of the contract to a newOwner.
34   * @param newOwner The address to transfer ownership to.
35   */
36  function transferOwnership(address newOwner) public onlyOwner {
37    require(newOwner != address(0));
38    emit OwnershipTransferred(owner, newOwner);
39    owner = newOwner;
40  }
41 
42 }
43 
44 /**
45  * @title ERC20Basic
46  * @dev Simpler version of ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/179
48  */
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 /// @title Token Loot Contract
68 /// @author Julia Altenried, Yuriy Kashnikov
69 
70 contract TokenLoot is Ownable {
71 
72   // FIELDS
73   /* signer address, verified in 'receiveTokenLoot' method, can be set by owner only */
74   address neverdieSigner;
75   /* SKL token */
76   ERC20 sklToken;
77   /* XP token */
78   ERC20 xpToken;
79   /* Gold token */
80   ERC20 goldToken;
81   /* Silver token */
82   ERC20 silverToken;
83   /* Scale token */
84   ERC20 scaleToken;
85   /* Nonces */
86   mapping (address => uint) public nonces;
87 
88 
89   // EVENTS
90   event ReceiveLoot(address indexed sender,
91                     uint _amountSKL,
92                     uint _amountXP,
93                     uint _amountGold,
94                     uint _amountSilver,
95                     uint _amountScale,
96                     uint _nonce);
97  
98 
99   // SETTERS
100   function setSKLContractAddress(address _to) public onlyOwner {
101     sklToken = ERC20(_to);
102   }
103 
104   function setXPContractAddress(address _to) public onlyOwner {
105     xpToken = ERC20(_to);
106   }
107 
108   function setGoldContractAddress(address _to) public onlyOwner {
109     goldToken = ERC20(_to);
110   }
111 
112   function setSilverContractAddress(address _to) public onlyOwner {
113     silverToken = ERC20(_to);
114   }
115 
116   function setScaleContractAddress(address _to) public onlyOwner {
117     scaleToken = ERC20(_to);
118   }
119 
120   function setNeverdieSignerAddress(address _to) public onlyOwner {
121     neverdieSigner = _to;
122   }
123 
124   /// @dev handy constructor to initialize TokenLoot with a set of proper parameters
125   /// @param _xpContractAddress XP token address
126   /// @param _sklContractAddress SKL token address
127   /// @param _goldContractAddress Gold token address
128   /// @param _silverContractAddress Silver token address
129   /// @param _scaleContractAddress Scale token address
130   /// @param _signer signer address, verified further in swap functions
131   function TokenLoot(address _xpContractAddress,
132                      address _sklContractAddress,
133                      address _goldContractAddress,
134                      address _silverContractAddress,
135                      address _scaleContractAddress,
136                      address _signer) {
137     xpToken = ERC20(_xpContractAddress);
138     sklToken = ERC20(_sklContractAddress);
139     goldToken = ERC20(_goldContractAddress);
140     silverToken = ERC20(_silverContractAddress);
141     scaleToken = ERC20(_scaleContractAddress);
142     neverdieSigner = _signer;
143   }
144 
145   /// @dev withdraw loot tokens
146   /// @param _amountSKL the amount of SKL tokens to withdraw
147   /// @param _amountXP them amount of XP tokens to withdraw
148   /// @param _amountGold them amount of Gold tokens to withdraw
149   /// @param _amountSilver them amount of Silver tokens to withdraw
150   /// @param _amountScale them amount of Scale tokens to withdraw
151   /// @param _nonce incremental index of withdrawal
152   /// @param _v ECDCA signature
153   /// @param _r ECDSA signature
154   /// @param _s ECDSA signature
155   function receiveTokenLoot(uint _amountSKL, 
156                             uint _amountXP, 
157                             uint _amountGold, 
158                             uint _amountSilver,
159                             uint _amountScale,
160                             uint _nonce, 
161                             uint8 _v, 
162                             bytes32 _r, 
163                             bytes32 _s) {
164 
165     // reject if the new nonce is lower or equal to the current one
166     require(_nonce > nonces[msg.sender]);
167     nonces[msg.sender] = _nonce;
168 
169     // verify signature
170     address signer = ecrecover(keccak256(msg.sender, 
171                                          _amountSKL, 
172                                          _amountXP, 
173                                          _amountGold,
174                                          _amountSilver,
175                                          _amountScale,
176                                          _nonce), _v, _r, _s);
177     require(signer == neverdieSigner);
178 
179     // transer tokens
180     if (_amountSKL > 0) assert(sklToken.transfer(msg.sender, _amountSKL));
181     if (_amountXP > 0) assert(xpToken.transfer(msg.sender, _amountXP));
182     if (_amountGold > 0) assert(goldToken.transfer(msg.sender, _amountGold));
183     if (_amountSilver > 0) assert(silverToken.transfer(msg.sender, _amountSilver));
184     if (_amountScale > 0) assert(scaleToken.transfer(msg.sender, _amountScale));
185 
186     // emit event
187     ReceiveLoot(msg.sender, _amountSKL, _amountXP, _amountGold, _amountSilver, _amountScale, _nonce);
188   }
189 
190   /// @dev fallback function to reject any ether coming directly to the contract
191   function () payable public { 
192       revert(); 
193   }
194 
195   /// @dev withdraw all SKL and XP tokens
196   function withdraw() public onlyOwner {
197     uint256 allSKL = sklToken.balanceOf(this);
198     uint256 allXP = xpToken.balanceOf(this);
199     uint256 allGold = goldToken.balanceOf(this);
200     uint256 allSilver = silverToken.balanceOf(this);
201     uint256 allScale = scaleToken.balanceOf(this);
202     if (allSKL > 0) sklToken.transfer(msg.sender, allSKL);
203     if (allXP > 0) xpToken.transfer(msg.sender, allXP);
204     if (allGold > 0) goldToken.transfer(msg.sender, allGold);
205     if (allSilver > 0) silverToken.transfer(msg.sender, allSilver);
206     if (allScale > 0) scaleToken.transfer(msg.sender, allScale);
207   }
208 
209   /// @dev kill contract, but before transfer all SKL and XP tokens 
210   function kill() onlyOwner public {
211     withdraw();
212     selfdestruct(owner);
213   }
214 
215 }