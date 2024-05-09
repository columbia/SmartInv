1 pragma solidity ^0.4.21;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract Guess23 is owned {
21     
22     
23     uint8 public maxnumber  = 100;
24    // mapping (uint8 => address) players;
25     mapping(address=>uint8[]) mynumbers;
26     mapping(address => bool) isActuallyAnAddressOnMyList;
27     mapping(uint8 => address[]) whosDaWinner;
28     uint8[] allnumbers;
29     address[]  allplayers;
30     uint8 winningNumber;
31     uint256 _lastPlayer;
32     uint public maxplayers = 25;
33     uint public roundnum  = 1;
34     uint256 public myWinShare  = 5;
35     uint256 public myLoseShare  = 0;
36     address[] winnerlist;
37 
38 
39     function Lottery() internal {
40         state = LotteryState.Accepting;
41     }
42     
43     uint8 number;
44     
45     enum LotteryState { Accepting, Finished }
46     
47     LotteryState state; 
48     
49     uint public minAmount = 10000000000000000;
50     
51     function isAddress(address check) public view returns(bool isIndeed) {
52    return isActuallyAnAddressOnMyList[check];
53 }
54   function getBalance() public view returns(uint256 balance) {
55       return this.balance;
56   }
57    
58    function play(uint8 mynumber) payable {
59        require(msg.value == minAmount);
60        require(mynumber >=0);
61        require(mynumber <= maxnumber);
62        require(state == LotteryState.Accepting);
63       whosDaWinner[mynumber].push(msg.sender);
64       mynumbers[msg.sender].push(mynumber);
65        allnumbers.push(mynumber);
66        if (!isAddress(msg.sender)){
67            
68            allplayers.push(msg.sender);
69            isActuallyAnAddressOnMyList[msg.sender] = true;
70        }
71        if (allnumbers.length == maxplayers){
72            state = LotteryState.Finished;
73        }
74        
75    } 
76    function seeMyNumbers()public view returns(uint8[], uint256) {
77        return(mynumbers[msg.sender],mynumbers[msg.sender].length);
78    }
79    function seeAllNumbers() public view returns(uint8[]){
80        return  allnumbers;
81        //return numberlist;
82    }
83    function seeAllPlayers() public view returns(address[]){
84        return allplayers;
85    }
86 
87     function setMaxNumber(uint8 newNumber) public onlyOwner {
88         maxnumber = newNumber;
89     }
90     
91     function setMaxPlayers(uint8 newNumber) public onlyOwner {
92         maxplayers = newNumber;
93     }
94     
95     function setMinAmount(uint newNumber) public onlyOwner {
96         minAmount = newNumber;
97     }
98 
99       function sum(uint8[] data) private returns (uint) {
100         uint S;
101         for(uint i;i < data.length;i++){
102             S += data[i];
103         }
104         return S;
105     }
106     
107     function setMyCut(uint256 win, uint256 lose) public onlyOwner {
108         myWinShare = win;
109         myLoseShare = lose;
110     }
111     
112     function determineNumber() private returns(uint8) {
113         
114         
115         winningNumber = uint8(sum(allnumbers)/allnumbers.length/3*2);
116        
117     }
118     
119     function determineWinner() public onlyOwner returns(uint8, address[]){
120         require (state == LotteryState.Finished);
121         determineNumber();
122        winnerlist = whosDaWinner[winningNumber];
123        if (winnerlist.length > 0){
124            owner.transfer(this.balance/100*myWinShare);
125            uint256 numwinners = winnerlist.length;
126            for (uint8 i =0; i<numwinners; i++){
127                
128                winnerlist[i].transfer(this.balance/numwinners);
129            }
130        } else {
131            owner.transfer(this.balance/100*myLoseShare);
132        }
133          return (winningNumber, winnerlist);
134         
135         
136     }
137     
138     function getNumAdd(uint8 num) public view returns(address[]) {
139         return whosDaWinner[num];
140         
141     }
142     
143     function getResults() public view returns(uint8, address[]){
144         return (winningNumber, winnerlist);
145     }
146     function startOver() public onlyOwner{
147       //  uint8 i = number;
148       for (uint8 i=0; i<allnumbers.length; i++){
149         delete (whosDaWinner[allnumbers[i]]);
150         //delete playerlist;
151         }
152     for (uint8 j=0;j<allplayers.length; j++){
153         delete mynumbers[allplayers[j]];
154         delete isActuallyAnAddressOnMyList[allplayers[j]];
155     }
156         delete allplayers;
157         delete allnumbers;
158         delete winnerlist;
159         
160         state = LotteryState.Accepting;
161         roundnum ++;
162         
163         
164 }
165 
166 
167 }