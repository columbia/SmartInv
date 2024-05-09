1 /**
2  * BRRR.LIVE - Building generational wealth, together!
3  *
4  * With $BRRR we band together to build generational wealth for a random holder every day, forever.
5  * Provably fair & fully on-chain.
6  *
7  *
8  * HOW IT WORKS
9  * Hold 100K $BRRR (0.1%) to join every daily game forever.
10  * No betting, no losing $ETH, just hold to enter any game.
11  * Every day, forever, a random holder automatically gets 50% of the previous day's total revenue.
12  *  Total revenue include $BRRR volume tax, and literally everything else we make in the future.
13  *
14  *
15  * Website: https://brrr.live
16  * Twitter: https://twitter.com/brrr_live
17  * Telegram: https://t.me/brrr_live
18  * 
19  * 
20 */
21 
22 // SPDX-License-Identifier: MIT
23 
24 pragma solidity 0.8.18;
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint);
28 
29     function balanceOf(address account) external view returns (uint);
30 
31     function transfer(address recipient, uint amount) external returns (bool);
32 
33     function allowance(address owner, address spender) external view returns (uint);
34 
35     function approve(address spender, uint amount) external returns (bool);
36 
37     function transferFrom(
38         address sender,
39         address recipient,
40         uint amount
41     ) external returns (bool);
42 
43     event Transfer(address indexed from, address indexed to, uint value);
44     event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 contract BrrrGame {
48 
49     IERC20 brrrToken;
50     address public owner;
51     uint public minHold;
52     uint public maxTickets;
53     uint public current_game;
54     bool public game_active;
55     uint counter = 1;
56     mapping(uint => address[]) public GameToTickets;
57 
58     mapping(uint => mapping(address => uint)) GameToPlayerTickets;
59     mapping(uint => uint) public GameToPrize;
60 
61     constructor() {
62         owner = msg.sender;
63         minHold = 100000 * 10** 9;
64         maxTickets = 5;
65         game_active = false;
66     }
67 
68     modifier onlyOwner() {
69         require(msg.sender == owner, "not authorized");
70         _;
71     }
72 
73     receive() external payable {
74     }
75 
76     function ticketsInGame(uint game_id) external view returns (address[] memory)
77     {
78         return GameToTickets[game_id];
79     }
80 
81     function playerTicketsInGame(uint game_id, address addy) external view returns (uint)
82     {
83         return GameToPlayerTickets[game_id][addy];
84     }
85 
86     function toggleGame() external onlyOwner() {
87         game_active = !game_active;
88     }
89 
90     function updateMaxTickets(uint _maxTickets) external onlyOwner() {
91         maxTickets = _maxTickets;
92     }
93 
94     function updateMinHold(uint _minHold) external onlyOwner() {
95         minHold = _minHold * 10** 9;
96     }
97 
98     function setTokenAddress(address payable _tokenAddress) external onlyOwner() {
99        brrrToken = IERC20(address(_tokenAddress));
100     }
101 
102     function joinGame() external 
103     {
104         require(game_active == true,"The game is currently inactive, try again later");
105         require(brrrToken.balanceOf(msg.sender) >= minHold,"You don't hold enough $BRRR to join the current game");
106         require(GameToPlayerTickets[current_game][msg.sender] == 0,"You have already joined the current game");
107         
108         uint ticket_amount = brrrToken.balanceOf(msg.sender) / minHold;
109 
110         if(ticket_amount > maxTickets)
111         {
112             ticket_amount = maxTickets;
113         }
114 
115         for(uint i; i < ticket_amount; i++)
116         {
117             GameToTickets[current_game].push(msg.sender);
118         }
119         GameToPlayerTickets[current_game][msg.sender] = ticket_amount;
120     }
121 
122     function GoBrrr() onlyOwner() external payable
123     {
124         if(GameToTickets[current_game].length > 0)
125         {
126             address payable winner;
127             if(GameToTickets[current_game].length == 1){
128                 winner = payable(GameToTickets[current_game][0]);
129             }
130             else 
131             {
132                 winner = payable(GameToTickets[current_game][randomNumber()]);
133             }
134 
135             if(brrrToken.balanceOf(winner) >= (GameToPlayerTickets[current_game][winner] * minHold))
136             {
137                 GameToPrize[current_game] = address(this).balance;
138                 winner.transfer(address(this).balance);
139             }
140             
141         }
142         current_game++;
143     }
144 
145     function emergencyWithdrawal() external onlyOwner {
146         (bool success, ) = msg.sender.call{ value: address(this).balance } ("");
147         require(success, "Transfer failed.");
148     }
149 
150     function randomNumber() internal returns (uint) 
151     {
152         counter++;
153         uint random = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, counter, GameToTickets[current_game].length, gasleft()))) % GameToTickets[current_game].length;
154         return random;
155     }
156 
157 }