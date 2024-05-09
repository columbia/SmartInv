1 pragma solidity ^0.4.24;
2 
3 contract AutomatedExchange{
4   function buyTokens() public payable;
5   function calculateTokenSell(uint256 tokens) public view returns(uint256);
6   function calculateTokenBuy(uint256 eth,uint256 contractBalance) public view returns(uint256);
7   function balanceOf(address tokenOwner) public view returns (uint balance);
8 }
9 contract VerifyToken {
10     function totalSupply() public constant returns (uint);
11     function balanceOf(address tokenOwner) public constant returns (uint balance);
12     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
13     function transfer(address to, uint tokens) public returns (bool success);
14     function approve(address spender, uint tokens) public returns (bool success);
15     function transferFrom(address from, address to, uint tokens) public returns (bool success);
16     bool public activated;
17 
18     event Transfer(address indexed from, address indexed to, uint tokens);
19     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
20 }
21 contract ApproveAndCallFallBack {
22     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
23 }
24 contract VRFBet is ApproveAndCallFallBack{
25   using SafeMath for uint;
26   struct Bet{
27     uint blockPlaced;
28     address bettor;
29     uint betAmount;
30   }
31   mapping(address => bytes) public victoryMessages;
32   mapping(uint => Bet) public betQueue;
33   uint public MAX_SIMULTANEOUS_BETS=20;
34   uint public index=0;//index for processing bets
35   uint public indexBetPlace=0;//index for placing bets
36   address vrfAddress= 0x5BD574410F3A2dA202bABBa1609330Db02aD64C2;//0xe0832c4f024D2427bBC6BD0C4931096d2ab5CCaF; //0x5BD574410F3A2dA202bABBa1609330Db02aD64C2;
37   VerifyToken vrfcontract=VerifyToken(vrfAddress);
38   AutomatedExchange exchangecontract=AutomatedExchange(0x48bF5e13A1ee8Bd4385C182904B3ABf73E042675);
39 
40   event Payout(address indexed to, uint tokens);
41   event BetFinalized(address indexed bettor,uint tokensWagered,uint tokensAgainst,uint tokensWon,bytes victoryMessage);
42 
43   //Send tokens with ApproveAndCallFallBack, place a bet
44   function receiveApproval(address from, uint256 tokens, address token, bytes data) public{
45       require(msg.sender==vrfAddress);
46       vrfcontract.transferFrom(from,this,tokens);
47       _placeBet(tokens,from,data);
48   }
49   function placeBetEth(bytes victoryMessage) public payable{
50     require(indexBetPlace-index<MAX_SIMULTANEOUS_BETS);//ensures you don't get a situation where there are too many existing bets to process, locking VRF in the contract
51     uint tokensBefore=vrfcontract.balanceOf(this);
52     exchangecontract.buyTokens.value(msg.value)();
53     _placeBet(vrfcontract.balanceOf(this).sub(tokensBefore),msg.sender,victoryMessage);
54   }
55   function payout(address to,uint numTokens) private{
56     vrfcontract.transfer(to,numTokens);
57     emit Payout(to,numTokens);
58   }
59   function _placeBet(uint numTokens,address from,bytes victoryMessage) private{
60     resolvePriorBets();
61     betQueue[indexBetPlace]=Bet({blockPlaced:block.number,bettor:from,betAmount:numTokens});
62     indexBetPlace+=1;
63     victoryMessages[from]=victoryMessage;
64   }
65   function resolvePriorBets() public{
66     while(betQueue[index].blockPlaced!=0){
67       if(betQueue[index+1].blockPlaced!=0){
68         if(betQueue[index+1].blockPlaced+250>block.number){//bet is not expired
69           if(block.number>betQueue[index+1].blockPlaced){//bet was in the past, future blockhash can be safely used to compute random
70 
71           /*
72             Bet is between two players.
73             Outcome is computed as whether rand(bet1+bet2)<bet1. This makes the probability of winning proportional to the size of your bet, ensuring all bets are EV neutral.
74           */
75             uint totalbet=betQueue[index].betAmount+betQueue[index+1].betAmount;
76             uint randval= random(totalbet,betQueue[index+1].blockPlaced,betQueue[index+1].bettor);
77             if(randval < betQueue[index].betAmount){
78               payout(betQueue[index].bettor,totalbet);
79               emit BetFinalized(betQueue[index+1].bettor,betQueue[index+1].betAmount,betQueue[index].betAmount,0,victoryMessages[betQueue[index].bettor]);
80               emit BetFinalized(betQueue[index].bettor,betQueue[index].betAmount,betQueue[index+1].betAmount,totalbet,victoryMessages[betQueue[index].bettor]);
81             }
82             else{
83               payout(betQueue[index+1].bettor,totalbet);
84               emit BetFinalized(betQueue[index+1].bettor,betQueue[index+1].betAmount,betQueue[index].betAmount,totalbet,victoryMessages[betQueue[index+1].bettor]);
85               emit BetFinalized(betQueue[index].bettor,betQueue[index].betAmount,betQueue[index+1].betAmount,0,victoryMessages[betQueue[index+1].bettor]);
86             }
87             index+=2;
88           }
89           else{ //bet is in the current block, cannot be resolved, no point in continuing the loop
90             return;
91           }
92         }
93         else{//bet has expired, return tokens to users
94           payout(betQueue[index+1].bettor,betQueue[index+1].betAmount);
95           payout(betQueue[index].bettor,betQueue[index].betAmount);
96           index+=2;
97           emit BetFinalized(betQueue[index].bettor,betQueue[index].betAmount,betQueue[index+1].betAmount,betQueue[index].betAmount,"");
98           emit BetFinalized(betQueue[index+1].bettor,betQueue[index+1].betAmount,betQueue[index].betAmount,betQueue[index+1].betAmount,"");
99         }
100       }
101       else{ //single bet with no other to pair it to, must wait for another bet
102         return;
103       }
104     }
105   }
106   function cancelBet() public{
107     resolvePriorBets();
108     require(indexBetPlace-index==1 && betQueue[index].bettor==msg.sender);
109     index+=1;//skip the last remaining bet
110   }
111   /*
112     requires an odd number of bets and your bet is the last one
113   */
114   function canCancelBet() public view returns(bool){
115     return indexBetPlace>0 && !isEven(indexBetPlace-index) && betQueue[indexBetPlace-1].bettor==msg.sender;
116   }
117   function isEven(uint num) public view returns(bool){
118     return 2*(num/2)==num;
119   }
120   function maxRandom(uint blockn, address entropy)
121     internal
122     returns (uint256 randomNumber)
123   {
124       return uint256(keccak256(
125           abi.encodePacked(
126             blockhash(blockn),
127             entropy)
128       ));
129   }
130   function random(uint256 upper, uint256 blockn, address entropy)
131     internal
132     returns (uint256 randomNumber)
133   {
134       return maxRandom(blockn, entropy) % upper + 1;
135   }
136   /*
137     only for frontend viewing purposes
138   */
139   function getBetState(address bettor) public view returns(uint){
140     for(uint i=index;i<indexBetPlace;i++){
141       if(betQueue[i].bettor==bettor){
142         if(!isEven(indexBetPlace-index)){//i<indexBetPlace-1){
143           return 1;
144         }
145         else{
146           return 2;
147         }
148       }
149     }
150     return 0;
151   }
152 }
153 // ----------------------------------------------------------------------------
154 // Safe maths
155 // ----------------------------------------------------------------------------
156 library SafeMath {
157     function add(uint a, uint b) internal pure returns (uint c) {
158         c = a + b;
159         require(c >= a);
160     }
161     function sub(uint a, uint b) internal pure returns (uint c) {
162         require(b <= a);
163         c = a - b;
164     }
165     function mul(uint a, uint b) internal pure returns (uint c) {
166         c = a * b;
167         require(a == 0 || c / a == b);
168     }
169     function div(uint a, uint b) internal pure returns (uint c) {
170         require(b > 0);
171         c = a / b;
172     }
173 }