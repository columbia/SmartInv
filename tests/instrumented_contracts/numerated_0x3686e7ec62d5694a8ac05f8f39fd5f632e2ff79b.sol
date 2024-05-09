1 pragma solidity 0.4.24;
2 
3 /*
4 Check code on Github: https://github.com/maraoz/cryptokitties-arena/tree/700d2e67d52396485236623402dba4e60e3765c0
5 */
6 
7 contract Destiny {
8     function fight(bytes32 cat1, bytes32 cat2, bytes32 entropy) public returns (bytes32 winner);
9 }
10 
11 contract KittyInterface {
12     function approve(address _to, uint256 _tokenId) public;
13 	function transfer(address to, uint256 kittyId);
14 	function transferFrom(address from, address to, uint256 kittyId);
15 	function getKitty(uint256 _id) external view returns (bool isGestating, bool isReady, uint256 cooldownIndex, uint256 nextActionAt, uint256 siringWithId, uint256 birthTime, uint256 matronId, uint256 sireId, uint256 generation, uint256 genes);
16 }
17 
18 contract Random {
19   // The upper bound of the number returns is 2^bits - 1
20   function bitSlice(uint256 n, uint256 bits, uint256 slot) public pure returns(uint256) {
21       uint256 offset = slot * bits;
22       // mask is made by shifting left an offset number of times
23       uint256 mask = uint256((2**bits) - 1) << offset;
24       // AND n with mask, and trim to max of 5 bits
25       return uint256((n & mask) >> offset);
26   }
27 
28   /**
29   * @dev This function assumes that the consumer contract has logic for handling when
30   the returned blockhash is bytes32(0), 
31   */
32   function maxRandom(uint256 sourceBlock) public view returns (uint256 randomNumber) {
33     require(block.number > sourceBlock);
34     return uint256(block.blockhash(sourceBlock));
35   }
36 
37   function random(uint256 upper) public view returns (uint256 randomNumber) {
38     return random(upper, block.number - 1);
39   }
40 
41   // return a pseudo random number between lower and upper bounds
42   // given the number of previous blocks it should hash.
43   function random(uint256 upper, uint256 sourceBlock) public returns (uint256 randomNumber) {
44     return maxRandom(sourceBlock) % upper;
45   }
46 }
47 
48 
49 contract KittyArena is Random {
50 	struct Player {
51 		uint256 kitty;
52 		address addr;
53 	}
54 
55 	struct Game {
56 		Player player1;
57 		Player player2;
58 		uint256 fightBlock;
59 		address winner;
60 	}
61 
62 	KittyInterface public ck;
63 	Destiny destiny;
64 	Game[] public games;
65 
66 	address constant public TIE = address(-2);
67 
68 	event KittyEntered(uint256 indexed gameId, uint256 indexed kittyId, address indexed owner);
69 	event FightStarted(uint256 indexed gameId, uint256 fightBlock);
70 	event FightResolved(uint256 indexed gameId, address indexed winner);
71 
72 	constructor (KittyInterface _ck, Destiny _destiny) public {
73 		ck = _ck;
74 		destiny = _destiny;
75 	}
76 
77 	function enter(uint256 kitty) external {
78 		ck.transferFrom(msg.sender, this, kitty);
79 		Player storage player;
80 		Game storage game;
81 
82 		if (games.length > 0 && games[games.length - 1].fightBlock == 0) {
83 			// player is player2 for game
84 			game = games[games.length - 1];
85 			game.player2 = Player(kitty, msg.sender);
86 			game.fightBlock = block.number;
87 
88 			player = game.player2;
89 
90 			emit FightStarted(games.length - 1, game.fightBlock);
91 		} else {
92 			games.length += 1;
93 			game = games[games.length - 1];
94 			game.player1 = Player(kitty, msg.sender);
95 
96 			player = game.player1;
97 		}
98 
99 		emit KittyEntered(games.length - 1, player.kitty, player.addr);
100 	}
101 
102 	function resolve(uint256 gameId) external {
103 		Game storage game = games[gameId];
104 		require(game.winner == address(0));
105         require(game.player1.addr != address(0));
106         require(game.player2.addr != address(0));
107 
108 		game.winner = getWinner(gameId);
109 		
110 		ck.transfer(game.winner == TIE ? game.player1.addr : game.winner, game.player1.kitty);
111 		ck.transfer(game.winner == TIE ? game.player2.addr : game.winner, game.player2.kitty);
112 
113 		emit FightResolved(gameId, game.winner);
114 	}
115 
116 	function getWinner(uint256 gameId) public view returns (address) {
117 		Game storage game = games[gameId];
118 		if (game.winner != address(0)) {
119 			return game.winner;
120 		}
121 
122 		bytes32 genes1 = catGenes(game.player1.kitty);
123 		bytes32 genes2 = catGenes(game.player2.kitty);
124 
125 		require(block.number > game.fightBlock);
126 		bytes32 seed = bytes32(maxRandom(game.fightBlock));
127 		
128 		// If game isn't resolved in 256 blocks and we cannot get the entropy,
129 		// we considered it tie
130 		if (seed == bytes32(0)) {
131 			return TIE;
132 		}
133 
134 		bytes32 winnerGenes = destiny.fight(genes1, genes2, seed);
135 
136 		if (winnerGenes == genes1) {
137 			return game.player1.addr;
138 		} 
139 
140 		if (winnerGenes == genes2) { 
141 			return game.player2.addr;
142 		}
143 
144 		// Destiny may return something other than one of the two cats gens,
145 		// if so we consider it a tie
146 		return TIE;
147 	}
148 
149 	function catGenes(uint256 kitty) private view returns (bytes32 genes) {
150 		var (,,,,,,,,,_genes) = ck.getKitty(kitty);
151 		genes = bytes32(_genes);
152 	}
153 }