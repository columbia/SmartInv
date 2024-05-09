1 // Last is me! Lottery paying the last player
2 //
3 // git: https://github.com/lastisme/lastisme.github.io/
4 // url: http://lastis.me
5 
6 contract owned {
7   address public owner;
8 
9   function owned() {
10     owner = msg.sender;
11   }
12   modifier onlyOwner() {
13     if (msg.sender != owner) throw;
14     _
15   }
16   function transferOwnership(address newOwner) onlyOwner {
17     owner = newOwner;
18   }
19 }
20 
21 contract LastIsMe is owned {
22   event TicketBought(address _from);
23   event WinnerPayedTicketBought(address _winner, address _from);
24 
25   //constant once constructed
26   uint public blocks;
27   uint public price;
28   ///////////////////////////
29 
30   //semi-constant, tweakable with limits after creation
31   uint public houseFee;      // THOUSANDTHS
32   uint public houseFeeVal;   // houseFee/1000 * price
33   uint public refFeeVal;     // half of the house fee val
34 
35   uint public lotteryFee;    // THOUSANDTHS
36   uint public lotteryFeeVal; // lotteryFee/1000 * price
37 
38   address public leftLottery;
39   address public rightLottery;
40   //////////////////////////////////////////////////
41 
42   uint constant MAX_HOUSE_FEE_THOUSANDTHS   = 20;
43   uint constant MAX_LOTTERY_FEE_THOUSANDTHS = 40;
44 
45   address public lastPlayer;
46   uint    public lastBlock;
47   uint    public totalWinnings;
48   uint    public jackpot;
49   uint    public startedAt;
50 
51   struct Winners {
52     address winner;
53     uint jackpot;
54     uint timestamp;
55   }
56   Winners[] public winners;
57 
58 
59 
60   function LastIsMe(uint _priceParam, uint _blocksParam) {
61     if(_priceParam==0 || _blocksParam==0) throw;
62     price  = _priceParam;
63     blocks = _blocksParam;
64     setHouseFee(10);
65     setLotteryFee(40);
66     totalWinnings = 0;
67     jackpot = 0;
68   }
69 
70   function buyTicket(address _ref) {
71     if( msg.value >= price ) { //ticket bought
72 
73       if( msg.value > price ) {
74         msg.sender.send(msg.value-price);  //payed more than required => refund
75       }
76 
77       if( remaining() == 0 && lastPlayer != 0x0 ) {  //last player was the winner!
78         WinnerPayedTicketBought(lastPlayer,msg.sender);
79         winners[winners.length++] = Winners(lastPlayer, jackpot, block.timestamp);
80         lastPlayer.send(jackpot);
81         totalWinnings=totalWinnings+jackpot;
82         startedAt  = block.timestamp;
83         lastPlayer = msg.sender;
84         lastBlock  = block.number;
85         jackpot    = this.balance;
86         //I am not paying fee and other lotteries fee if I am the lottery re-starter
87       } else {
88         TicketBought(msg.sender);
89         if(lastPlayer==0x0)   //very first ticket
90           startedAt = block.timestamp;
91 
92         lastPlayer = msg.sender;
93         lastBlock  = block.number;
94 
95         if(houseFeeVal>0) {  //house fee could be zero
96           if(_ref==0x0) {
97             owner.send(houseFeeVal);
98           } else {
99             owner.send(refFeeVal);
100             _ref.send(refFeeVal);
101           }
102         }
103 
104         if(leftLottery!=0x0 && lotteryFeeVal>0)
105           leftLottery.send(lotteryFeeVal);
106         if(rightLottery!=0x0 && lotteryFeeVal>0)
107           rightLottery.send(lotteryFeeVal);
108 
109         jackpot = this.balance;
110       }
111     }
112   }
113 
114   function () {
115     buyTicket(0x0);
116   }
117 
118   function finance() {
119   }
120 
121   function allData() constant returns (uint _balance, address _lastPlayer, uint _lastBlock, uint _blockNumber, uint _totalWinners, uint _jackpot, uint _price, uint _blocks, uint _houseFee, uint _lotteryFee, address _leftLottery, address _rightLottery, uint _totalWinnings, uint _startedAt) {
122     return (this.balance, lastPlayer, lastBlock, block.number, winners.length, jackpot, price, blocks, houseFee, lotteryFee, leftLottery, rightLottery, totalWinnings, startedAt);
123   }
124 
125   function baseData() constant returns (uint _balance, address _lastPlayer, uint _lastBlock, uint _blockNumber, uint _totalWinners, uint _jackpot, uint _price, uint _blocks, uint _totalWinnings, uint _startedAt) {
126     return (this.balance, lastPlayer, lastBlock, block.number, winners.length, jackpot, price, blocks, totalWinnings, startedAt);
127   }
128 
129   function elapsed() constant returns (uint) {
130     return block.number - lastBlock;  //>=0
131   }
132 
133   function remaining() constant returns (uint) {
134     var e=elapsed();
135     if(blocks>e)
136       return blocks - elapsed() ;
137     else
138       return 0;
139   }
140 
141   function totalWinners() constant returns (uint) {
142     return winners.length;
143   }
144 
145   function updateLeftLottery( address _newValue) onlyOwner {
146     leftLottery=_newValue;
147   }
148 
149   function updateRightLottery( address _newValue) onlyOwner {
150     rightLottery=_newValue;
151   }
152 
153   function setLotteryFee(uint _newValue) onlyOwner {
154     if( _newValue > MAX_LOTTERY_FEE_THOUSANDTHS ) throw;
155     lotteryFee    = _newValue;
156     var aThousand = price/1000;
157     lotteryFeeVal = aThousand*lotteryFee;
158   }
159 
160   function setHouseFee(uint _newValue) onlyOwner {
161     if( _newValue > MAX_HOUSE_FEE_THOUSANDTHS ) throw;
162     houseFee      = _newValue;
163     var aThousand = price/1000;
164     houseFeeVal   = aThousand*houseFee;
165     refFeeVal     = houseFeeVal / 2;
166   }
167 }