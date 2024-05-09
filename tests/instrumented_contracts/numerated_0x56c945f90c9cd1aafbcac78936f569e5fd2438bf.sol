1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 interface IERC20 {
86   function totalSupply() external view returns (uint256);
87 
88   function balanceOf(address who) external view returns (uint256);
89 
90   function allowance(address owner, address spender)
91     external view returns (uint256);
92 
93   function transfer(address to, uint256 value) external returns (bool);
94 
95   function approve(address spender, uint256 value)
96     external returns (bool);
97 
98   function transferFrom(address from, address to, uint256 value)
99     external returns (bool);
100 
101   event Transfer(
102     address indexed from,
103     address indexed to,
104     uint256 value
105   );
106 
107   event Approval(
108     address indexed owner,
109     address indexed spender,
110     uint256 value
111   );
112 }
113 
114 // File: lib/CanReclaimToken.sol
115 
116 /**
117  * @title Contracts that should be able to recover tokens
118  * @author SylTi
119  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
120  * This will prevent any accidental loss of tokens.
121  */
122 contract CanReclaimToken is Ownable {
123 
124   /**
125    * @dev Reclaim all ERC20 compatible tokens
126    * @param token ERC20 The address of the token contract
127    */
128   function reclaimToken(IERC20 token) external onlyOwner {
129     if (address(token) == address(0)) {
130       owner().transfer(address(this).balance);
131       return;
132     }
133     uint256 balance = token.balanceOf(this);
134     token.transfer(owner(), balance);
135   }
136 
137 }
138 
139 // File: contracts/HeroUp.sol
140 
141 interface HEROES_NEW {
142   function mint(address to, uint256 genes, uint256 level) external returns (uint);
143   function mint(uint256 tokenId, address to, uint256 genes, uint256 level) external returns (uint);
144 }
145 
146 
147 interface HEROES_OLD {
148   function getLock(uint256 _tokenId) external view returns (uint256 lockedTo, uint16 lockId);
149   function unlock(uint256 _tokenId, uint16 _lockId) external returns (bool);
150   function lock(uint256 _tokenId, uint256 _lockedTo, uint16 _lockId) external returns (bool);
151   function transferFrom(address _from, address _to, uint256 _tokenId) external;
152   function getCharacter(uint256 _tokenId) external view returns (uint256 genes, uint256 mintedAt, uint256 godfather, uint256 mentor, uint32 wins, uint32 losses, uint32 level, uint256 lockedTo, uint16 lockId);
153   function ownerOf(uint256 _tokenId) external view returns (address);
154 }
155 
156 contract HeroUp is Ownable, CanReclaimToken {
157   event HeroUpgraded(uint tokenId, address owner);
158 
159   HEROES_OLD public heroesOld;
160   HEROES_NEW public heroesNew;
161   constructor (HEROES_OLD _heroesOld, HEROES_NEW _heroesNew) public {
162     require(address(_heroesOld) != address(0));
163     require(address(_heroesNew) != address(0));
164     heroesOld = _heroesOld;
165     heroesNew = _heroesNew;
166   }
167 
168   function() public {}
169 
170   function setOld(HEROES_OLD _heroesOld) public onlyOwner {
171     require(address(_heroesOld) != address(0));
172     heroesOld = _heroesOld;
173   }
174 
175   function setNew(HEROES_NEW _heroesNew) public onlyOwner {
176     require(address(_heroesNew) != address(0));
177     heroesNew = _heroesNew;
178   }
179 
180   function upgrade(uint _tokenId) public {
181     require(msg.sender == heroesOld.ownerOf(_tokenId));
182     uint256 genes;
183     uint32 level;
184     uint256 lockedTo;
185     uint16 lockId;
186 
187     //transfer old hero
188     (genes,,,,,,level,lockedTo,lockId) = heroesOld.getCharacter(_tokenId);
189     heroesOld.unlock(_tokenId, lockId);
190     heroesOld.lock(_tokenId, 0, 999);
191     heroesOld.transferFrom(msg.sender, address(this), _tokenId);
192 //    heroesOld.unlock(_tokenId, 999);
193 
194     //mint new hero
195     heroesNew.mint(_tokenId, msg.sender, genes, level);
196 
197     emit HeroUpgraded(_tokenId, msg.sender);
198   }
199 }