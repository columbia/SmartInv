1 // SPDX-License-Identifier: MIT
2 // Modified from https://github.com/ensdomains/governance/blob/master/contracts/ENSToken.sol
3 pragma solidity 0.8.10;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
7 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
8 import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
9 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
10 import "@openzeppelin/contracts/utils/structs/BitMaps.sol";
11 
12 import "./MerkleProof.sol";
13 import "../interfaces/IRevokableTokenLock.sol";
14 
15 contract ArenaToken is ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes {
16     using BitMaps for BitMaps.BitMap;
17 
18     /// mint cooldown period
19     uint256 public constant MIN_MINT_INTERVAL = 365 days;
20     /// maximum tokens allowed per mint
21     /// 10_000 = 100%
22     uint256 public constant MINT_CAP = 200; // 2%
23 
24     bytes32 public merkleRoot;
25     /// Proportion of airdropped tokens that are immediately claimable
26     /// 10_000 = 100%
27     uint256 public immutable claimableProportion;
28     /// Timestamp at which tokens are no longer claimable
29     uint256 public immutable claimPeriodEnds;
30     /// vesting contract
31     IRevokableTokenLock public tokenLock;
32     BitMaps.BitMap private claimed;
33 
34     /// vesting duration
35     uint256 public vestDuration;
36     /// timestamp till next mint is allowed
37     uint256 public nextMint;
38 
39     event MerkleRootChanged(bytes32 merkleRoot);
40     event Claim(address indexed claimant, uint256 amount);
41     event Vest(address indexed claimant, uint256 amount);
42 
43     /**
44      * @dev Constructor.
45      * @param _freeSupply The number of tokens to mint for contract deployer (then transferred to timelock controller after deployment)
46      * @param _airdropSupply The number of tokens to reserve for the airdrop
47      * @param _claimableProportion The value in BPS of the % of claimable vs vested
48      * @param _claimPeriodEnds The timestamp at which tokens are no longer claimable
49      * @param _vestDuration The token vesting duration
50      */
51     constructor(
52         uint256 _freeSupply,
53         uint256 _airdropSupply,
54         uint256 _claimableProportion,
55         uint256 _claimPeriodEnds,
56         uint256 _vestDuration
57     ) ERC20("Code4rena", "ARENA") ERC20Permit("Code4rena") {
58         // TODO: Change Symbol TBD
59         require(_claimableProportion <= 10_000, "claimable exceeds limit");
60         require(_claimPeriodEnds > block.timestamp, "cannot have a backward time");
61         _mint(msg.sender, _freeSupply);
62         _mint(address(this), _airdropSupply);
63         nextMint = block.timestamp + MIN_MINT_INTERVAL;
64         claimableProportion = _claimableProportion;
65         claimPeriodEnds = _claimPeriodEnds;
66         vestDuration = _vestDuration;
67     }
68 
69     /**
70      * @dev set vesting contract
71      * @param _tokenLock address of the vesting contract
72      */
73     function setTokenLock(address _tokenLock) external onlyOwner {
74         require(_tokenLock != address(0), "Address cannot be 0x");
75         tokenLock = IRevokableTokenLock(_tokenLock);
76     }
77 
78     /**
79      * @dev Claims airdropped tokens.
80      * @param amount The amount of the claim being made.
81      * @param merkleProof A merkle proof proving the claim is valid.
82      */
83     function claimTokens(uint256 amount, bytes32[] calldata merkleProof) external {
84         require(block.timestamp < claimPeriodEnds, "ArenaToken: Claim period ended");
85         // we don't need to check that `merkleProof` has the correct length as
86         // submitting a valid partial merkle proof would require `leaf` to map
87         // to an intermediate hash in the merkle tree but `leaf` uses msg.sender
88         // which is 20 bytes instead of 32 bytes and can't be chosen arbitrarily
89         bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
90         (bool valid, uint256 index) = MerkleProof.verify(merkleProof, merkleRoot, leaf);
91         require(valid, "ArenaToken: Valid proof required.");
92         require(!isClaimed(index), "ArenaToken: Tokens already claimed.");
93 
94         claimed.set(index);
95 
96         uint256 claimableAmount;
97         uint256 remainingAmount;
98 
99         unchecked {
100             claimableAmount = (amount * claimableProportion) / 10_000;
101             remainingAmount = amount - claimableAmount;
102         }
103 
104         emit Claim(msg.sender, claimableAmount);
105 
106         // transfer claimable proportion to caller
107         _transfer(address(this), msg.sender, claimableAmount);
108         // self-delegate if no prior delegatee was chosen
109         if (delegates(msg.sender) == address(0)) {
110             _delegate(msg.sender, msg.sender);
111         }
112 
113         require(address(tokenLock) != address(0), "Vesting contract not initialized");
114         tokenLock.setupVesting(
115             msg.sender,
116             block.timestamp,
117             block.timestamp,
118             block.timestamp + vestDuration
119         );
120         // approve TokenLock for token transfer
121         _approve(address(this), address(tokenLock), remainingAmount);
122         tokenLock.lock(msg.sender, remainingAmount);
123         emit Vest(msg.sender, remainingAmount);
124     }
125 
126     /**
127      * @dev Allows the owner to sweep unclaimed tokens after the claim period ends.
128      * @param dest The address to sweep the tokens to.
129      */
130     function sweep(address dest) external onlyOwner {
131         require(block.timestamp >= claimPeriodEnds, "ArenaToken: Claim period not yet ended");
132         _transfer(address(this), dest, balanceOf(address(this)));
133     }
134 
135     /**
136      * @dev Returns true if the claim at the given index in the merkle tree has already been made.
137      * @param index The index into the merkle tree.
138      */
139     function isClaimed(uint256 index) public view returns (bool) {
140         return claimed.get(index);
141     }
142 
143     /**
144      * @dev Sets the merkle root. Only callable if the root is not yet set.
145      * @param _merkleRoot The merkle root to set.
146      */
147     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
148         require(merkleRoot == bytes32(0), "ArenaToken: Merkle root already set");
149         merkleRoot = _merkleRoot;
150         emit MerkleRootChanged(_merkleRoot);
151     }
152 
153     /**
154      * @dev Mints new tokens.
155      * @param dest The address to mint the new tokens to.
156      * @param amount The quantity of tokens to mint.
157      */
158     function mint(address dest, uint256 amount) external onlyOwner {
159         require(
160             amount <= (totalSupply() * MINT_CAP) / 10_000,
161             "ArenaToken: Mint exceeds maximum amount"
162         );
163         require(block.timestamp >= nextMint, "ArenaToken: Cannot mint yet");
164 
165         nextMint = block.timestamp + MIN_MINT_INTERVAL;
166         _mint(dest, amount);
167     }
168 
169     // The following functions are overrides required by Solidity.
170 
171     function _afterTokenTransfer(
172         address from,
173         address to,
174         uint256 amount
175     ) internal override(ERC20, ERC20Votes) {
176         super._afterTokenTransfer(from, to, amount);
177     }
178 
179     function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes) {
180         super._mint(to, amount);
181     }
182 
183     function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
184         super._burn(account, amount);
185     }
186 }
