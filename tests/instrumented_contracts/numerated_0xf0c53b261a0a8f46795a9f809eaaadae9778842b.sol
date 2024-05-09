1 pragma solidity ^0.4.25;
2 
3 /*
4 * CryptoMiningWar - Blockchain-based strategy game
5 * Author: InspiGames
6 * Website: https://cryptominingwar.github.io/
7 */
8 
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function min(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a < b ? a : b;
52     }
53 }
54 interface MiniGameInterface {
55     function isContractMiniGame() external pure returns( bool /*_isContractMiniGame*/ );
56     function getCurrentReward(address /*_addr*/) external pure returns( uint256 /*_currentReward*/ );
57     function withdrawReward(address /*_addr*/) external;
58     function fallback() external payable;
59 }
60 contract CrryptoWallet {
61 	using SafeMath for uint256;
62 
63 	address public administrator;
64     uint256 public totalContractMiniGame = 0;
65 
66     mapping(address => bool)   public miniGames; 
67     mapping(uint256 => address) public miniGameAddress;
68 
69     modifier onlyContractsMiniGame() 
70     {
71         require(miniGames[msg.sender] == true);
72         _;
73     }
74     event Withdraw(address _addr, uint256 _eth);
75 
76     constructor() public {
77         administrator = msg.sender;
78     }
79     function () public payable
80     {
81         
82     }
83     /** 
84     * @dev MainContract used this function to verify game's contract
85     */
86     function isContractMiniGame() public pure returns( bool _isContractMiniGame )
87     {
88     	_isContractMiniGame = true;
89     }
90     function isWalletContract() public pure returns(bool)
91     {
92         return true;
93     }
94     function upgrade(address addr) public 
95     {
96         require(administrator == msg.sender);
97 
98         selfdestruct(addr);
99     }
100     /** 
101     * @dev Main Contract call this function to setup mini game.
102     */
103     function setupMiniGame( uint256 /*_miningWarRoundNumber*/, uint256 /*_miningWarDeadline*/) public
104     {
105     }
106     //--------------------------------------------------------------------------
107     // SETTING CONTRACT MINI GAME 
108     //--------------------------------------------------------------------------
109     function setContractsMiniGame( address _addr ) public  
110     {
111         require(administrator == msg.sender);
112 
113         MiniGameInterface MiniGame = MiniGameInterface( _addr );
114 
115         if ( miniGames[_addr] == false ) {
116             miniGames[_addr] = true;
117             miniGameAddress[totalContractMiniGame] = _addr;
118             totalContractMiniGame = totalContractMiniGame + 1;
119         }
120     }
121     /**
122     * @dev remove mini game contract from main contract
123     * @param _addr mini game contract address
124     */
125     function removeContractMiniGame(address _addr) public 
126     {
127         require(administrator == msg.sender);
128 
129         miniGames[_addr] = false;
130     }
131    
132     
133     // --------------------------------------------------------------------------------------------------------------
134     // CALL FUNCTION
135     // --------------------------------------------------------------------------------------------------------------
136     function getCurrentReward(address _addr) public view returns(uint256 _currentReward)
137     {
138         for(uint256 idx = 0; idx < totalContractMiniGame; idx++) {
139             if (miniGames[miniGameAddress[idx]] == true) {
140                 MiniGameInterface MiniGame = MiniGameInterface(miniGameAddress[idx]);
141                 _currentReward += MiniGame.getCurrentReward(_addr);
142             }
143         }
144     }
145 
146     function withdrawReward() public 
147     {
148         for(uint256 idx = 0; idx < totalContractMiniGame; idx++) {
149             if (miniGames[miniGameAddress[idx]] == true) {
150                 MiniGameInterface MiniGame = MiniGameInterface(miniGameAddress[idx]);
151                 MiniGame.withdrawReward(msg.sender);
152             }
153         }
154     }
155 }