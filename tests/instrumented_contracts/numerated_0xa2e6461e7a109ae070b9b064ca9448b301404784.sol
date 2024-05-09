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
11 contract MemoryFactory {
12 
13 	address public administrator;
14     uint256 public factoryTotal;
15     // player info
16     mapping(address => Player) public players;
17     // minigame info
18     mapping(address => bool)   public miniGames; 
19    
20     struct Player {
21         uint256 level;
22         uint256 updateTime;
23         uint256 levelUp;
24         mapping(uint256 => uint256) programs;
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
43     function upgrade(address addr) public isAdministrator
44     {
45         selfdestruct(addr);
46     }
47     //--------------------------------------------------------------------------
48     // SETTING CONTRACT MINI GAME 
49     //--------------------------------------------------------------------------
50     function setContractMiniGame(address _addr) public isAdministrator 
51     {
52         MiniGameInterface MiniGame = MiniGameInterface( _addr );
53         if( MiniGame.isContractMiniGame() == false ) { revert(); }
54 
55         miniGames[_addr] = true;
56     }
57     function removeContractMiniGame(address _addr) public isAdministrator
58     {
59         miniGames[_addr] = false;
60     }
61     //--------------------------------------------------------------------------
62     // FACTORY 
63     //--------------------------------------------------------------------------
64     function setFactoryToal(uint256 _value) public onlyContractsMiniGame
65     {
66         factoryTotal = _value;
67     }
68     function updateFactory(address _addr, uint256 _levelUp, uint256 _time) public onlyContractsMiniGame
69     {
70         require(players[_addr].updateTime <= now);
71 
72         Player storage p = players[_addr];
73         p.updateTime     = _time;
74         p.levelUp        = _levelUp;
75     }
76     function setFactoryLevel(address _addr, uint256 _value) public 
77     {
78         require(msg.sender == administrator || miniGames[msg.sender] == true);
79         Player storage p = players[_addr];
80         p.level = _value;
81     }
82     function updateLevel(address _addr) public
83     {
84         Player storage p = players[_addr];
85 
86         if (p.updateTime <= now && p.level < p.levelUp) p.level = p.levelUp;
87     }
88     //--------------------------------------------------------------------------
89     // PROGRAM
90     //--------------------------------------------------------------------------
91     function addProgram(address _addr, uint256 _idx, uint256 _program) public onlyContractsMiniGame
92     {
93         Player storage p = players[_addr];
94         p.programs[uint256(_idx)] += _program;
95     }
96     function subProgram(address _addr, uint256 _idx, uint256 _program) public onlyContractsMiniGame
97     {
98         Player storage p = players[_addr];
99      
100         require(p.programs[uint256(_idx)] >= _program);
101 
102         p.programs[uint256(_idx)] -= _program;
103     }
104     //--------------------------------------------------------------------------
105     // CALL DATA
106     //--------------------------------------------------------------------------
107     function getData(address _addr) public view returns(uint256 _level,uint256 _updateTime, uint256[] _programs) 
108     {
109         Player memory p = players[_addr];
110         _level      = getLevel(_addr);
111         _updateTime = p.updateTime;
112         _programs   = getPrograms(_addr);
113     }
114     function getLevel(address _addr) public view returns(uint256 _level)
115     {
116         Player memory p = players[_addr];
117         _level = p.level;
118         if (p.updateTime <= now && _level < p.levelUp) _level = p.levelUp;
119     }
120     function getPrograms(address _addr) public view returns(uint256[])
121     {
122         Player storage p = players[_addr];
123         uint256[] memory _programs = new uint256[](factoryTotal);
124         
125         for(uint256 idx = 0; idx < factoryTotal; idx++) {
126             _programs[idx] = p.programs[idx];
127         }
128         return _programs;
129     }
130 }