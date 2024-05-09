1 pragma solidity ^0.4.0;
2 
3 /// @title PonzICO
4 /// @author acityinohio
5 contract PonzICO {
6     address public owner;
7     uint public total;
8     mapping (address => uint) public invested;
9     mapping (address => uint) public balances;
10 
11     //function signatures
12     function PonzICO() { }
13     function withdraw() { }
14     function reinvest() { }
15     function invest() payable { }
16     
17 }
18 
19 /// @title VoteOnMyTeslaColor EXCLUSIVELY FOR SUPER-ACCREDITED PONZICO INVESTORS
20 /// @author acityinohio
21 contract VoteOnMyTeslaColor {
22     address public owner;
23     enum Color { SolidBlack, MidnightSilverMetallic, DeepBlueMetallic, SilverMetallic, RedMultiCoat }
24     mapping (uint8 => uint32) public votes;
25     mapping (address => bool) public voted;
26 
27     //log vote
28     event LogVotes(Color color, uint num);
29     //log winner
30     event LogWinner(Color color);
31 
32     //hardcode production PonzICO address
33     PonzICO ponzico = PonzICO(0x1ce7986760ADe2BF0F322f5EF39Ce0DE3bd0C82B);
34 
35     //just for me
36     modifier ownerOnly() {require(msg.sender == owner); _; }
37     //only valid colors, as specified by the Model3 production details
38     modifier isValidColor(uint8 color) {require(color < uint8(5)); _; }
39     //Only super-accredited ponzICO investors (0.1 ETH per vote) can vote
40     //Can only vote once! Unless you want to pay to play...
41     modifier superAccreditedInvestor() { require(ponzico.invested(msg.sender) >= 0.1 ether && !voted[msg.sender]); _;}
42 
43     //constructor for initializing VoteOnMyTeslaColor
44     //the owner is the genius who made the revolutionary smart contract PonzICO
45     //obviously blue starts with 10 votes because it is objectively the BEST color
46     function VoteOnMyTeslaColor() {
47         owner = msg.sender;
48         //YOURE MY BOY BLUE
49         votes[uint8(2)] = 10;
50     }
51 
52     //SUPER ACCREDITED INVESTORS ONLY, YOU CAN ONLY VOTE ONCE
53     function vote(uint8 color)
54     superAccreditedInvestor()
55     isValidColor(color)
56     {
57         //0.1 ETH invested in PonzICO per vote, truncated
58         uint32 num = uint32(ponzico.invested(msg.sender) / (0.1 ether));
59         votes[color] += num;
60         voted[msg.sender] = true;
61         LogVotes(Color(color), num);
62     }
63     
64     //pay to vote again! I don't care!
65     //...but it'll cost you 1 ether for me to look the other way, wink wink
66     function itsLikeChicago() payable {
67         require(voted[msg.sender] && msg.value >= 1 ether);
68         voted[msg.sender] = false;
69     }
70 
71     function winnovate()
72     ownerOnly()
73     {
74         Color winner = Color.SolidBlack;
75         for (uint8 choice = 1; choice < 5; choice++) {
76             if (votes[choice] > votes[choice-1]) {
77                 winner = Color(choice);
78             }
79         }
80         LogWinner(winner);
81         //keeping dat blockchain bloat on check
82         selfdestruct(owner);
83     }
84 }