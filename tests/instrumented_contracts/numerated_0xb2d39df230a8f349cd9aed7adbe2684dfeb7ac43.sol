1 pragma solidity ^0.4.25;
2 
3 /*
4 * CryptoMiningWar - Build your own empire on Blockchain
5 * Author: InspiGames
6 * Website: https://cryptominingwar.github.io/
7 */
8 interface MiniGameInterface {
9     function isContractMiniGame() external pure returns( bool _isContractMiniGame );
10 }
11 contract MemoryArena {
12 
13 	address public administrator;
14     // player info
15     mapping(address => Player) public players;
16     // minigame info
17     mapping(address => bool)   public miniGames; 
18    
19     struct Player {
20         uint256 virusDef;
21         uint256 nextTimeAtk;
22         uint256 endTimeUnequalledDef;
23         uint256 nextTimeArenaBonus;
24         uint256 bonusPoint; // win atk +1; if bonus point equal 3 => send bonus to player and reset bonus point
25     }
26     modifier isAdministrator()
27     {
28         require(msg.sender == administrator);
29         _;
30     }
31     modifier onlyContractsMiniGame() 
32     {
33         require(miniGames[msg.sender] == true);
34         _;
35     }
36     constructor() public {
37         administrator = msg.sender;
38     }
39     function () public payable
40     {
41         
42     }
43     function isMemoryArenaContract() public pure returns(bool)
44     {
45         return true;
46     }
47     function upgrade(address addr) public isAdministrator
48     {
49         selfdestruct(addr);
50     }
51     //--------------------------------------------------------------------------
52     // SETTING CONTRACT MINI GAME 
53     //--------------------------------------------------------------------------
54     function setContractMiniGame(address _addr) public isAdministrator 
55     {
56         MiniGameInterface MiniGame = MiniGameInterface( _addr );
57         if( MiniGame.isContractMiniGame() == false ) { revert(); }
58 
59         miniGames[_addr] = true;
60     }
61     function removeContractMiniGame(address _addr) public isAdministrator
62     {
63         miniGames[_addr] = false;
64     }
65     //--------------------------------------------------------------------------
66     // FACTORY 
67     //--------------------------------------------------------------------------
68     function setVirusDef(address _addr, uint256 _value) public onlyContractsMiniGame
69     {
70         players[_addr].virusDef = _value;
71     }
72     function setNextTimeAtk(address _addr, uint256 _value) public onlyContractsMiniGame
73     {
74         players[_addr].nextTimeAtk = _value;
75     }
76     function setEndTimeUnequalledDef(address _addr, uint256 _value) public onlyContractsMiniGame
77     {
78         players[_addr].endTimeUnequalledDef = _value;
79     }
80     function setNextTimeArenaBonus(address _addr, uint256 _value) public onlyContractsMiniGame
81     {
82         players[_addr].nextTimeArenaBonus = _value;
83     }
84     function setBonusPoint(address _addr, uint256 _value) public onlyContractsMiniGame
85     {
86         players[_addr].bonusPoint = _value;
87     }
88     //--------------------------------------------------------------------------
89     // CALL DATA
90     //--------------------------------------------------------------------------
91     function getData(address _addr) public view returns(uint256 virusDef, uint256 nextTimeAtk, uint256 endTimeUnequalledDef, uint256 nextTimeArenaBonus, uint256 bonusPoint) 
92     {
93         Player memory p = players[_addr];
94         virusDef             = p.virusDef;
95         nextTimeAtk          = p.nextTimeAtk;
96         endTimeUnequalledDef = p.endTimeUnequalledDef;
97         nextTimeArenaBonus   = p.nextTimeArenaBonus;
98         bonusPoint           = p.bonusPoint;
99     }
100 }