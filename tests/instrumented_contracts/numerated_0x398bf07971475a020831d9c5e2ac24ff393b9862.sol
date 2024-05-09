1 pragma solidity ^0.4.0;
2 
3 contract FairPonzi {
4     struct Investment {
5         uint initamount;
6         uint inittime;
7         
8         uint refbonus;
9         address refaddress;
10         uint refcount;
11     }
12     struct Payment {
13         address receiver;
14         uint inamount;
15         uint outamount;
16     }
17     mapping(uint => mapping(address => Investment)) public investmentTable;
18     mapping(uint => Payment) public payoutList;
19     
20     uint public rewardinterval = 3600 * 24; // 1day
21     //uint public rewardinterval = 60; // 1min
22     uint public constant minbid = 1000000000000; // 1uETH
23     uint public payoutcount = 0;
24     uint public constant startblock = 5646372; // this disables preinvest advantage
25     uint public payincount = 0;
26     uint roundcount = 0;
27     uint constant maxdays = 365 * 3; // max 3 years, to cap gas costs
28     
29     address constant restaddress = 0x9feA38edD1875cefD3D071C549a3f7Cc7983B455;
30     address constant nulladdress = 0x0000000000000000000000000000000000000000;
31     
32     constructor() public {
33     }
34     
35     function () public payable {
36         buyin(nulladdress); // if normal transaction, nobody get referral
37     }
38     function buyin(address refaddr)public payable{
39         if(block.number < startblock) revert();
40         if(msg.value < minbid) { // wants a payout
41             redeemPayout();
42             return;
43         }
44         Investment storage acc = investmentTable[roundcount][msg.sender];
45         uint addreward = getAccountBalance(msg.sender);
46         uint win = addreward - acc.initamount;
47         if(win > 0){
48             investmentTable[roundcount][acc.refaddress].refbonus += win / 10; // Referral get 10%
49         }
50         
51         acc.initamount = msg.value + addreward;
52         acc.inittime = block.timestamp;
53         if(refaddr != msg.sender && acc.refaddress == nulladdress){
54             acc.refaddress = refaddr;
55             investmentTable[roundcount][refaddr].refcount++;
56         }
57         
58         payincount++;
59     }
60     function redeemPayout() public {
61         Investment storage acc = investmentTable[roundcount][msg.sender];
62         uint addreward = getAccountBalance(msg.sender);
63         uint win = addreward - acc.initamount;
64         uint payamount = addreward + acc.refbonus;
65         if(payamount <= 0) return;
66         if(address(this).balance < payamount){
67             reset();
68         }else{
69             payoutList[payoutcount++] = Payment(msg.sender, acc.initamount, payamount);
70             acc.initamount = 0;
71             acc.refbonus = 0;
72             msg.sender.transfer(payamount);
73             investmentTable[roundcount][acc.refaddress].refbonus += win / 10; // Referral get 10%
74         }
75     }
76     function reset() private {
77         // todo reset list
78         if(restaddress.send(address(this).balance)){
79             // Should always be possible, otherwise new payers have good luck ;)
80         }
81         roundcount++;
82         payincount = 0;
83     }
84     function getAccountBalance(address addr)public constant returns (uint amount){
85         Investment storage acc = investmentTable[roundcount][addr];
86         uint ret = acc.initamount;
87         if(acc.initamount > 0){
88             uint rewardcount = (block.timestamp - acc.inittime) / rewardinterval;
89             if(rewardcount > maxdays) rewardcount = maxdays;
90             while(rewardcount > 0){
91                 ret += ret / 200; // 0.5%
92                 rewardcount--;
93             }
94         }
95         return ret;
96     }
97     function getPayout(uint idrel) public constant returns (address bidder, uint inamount, uint outamount) {
98         Payment storage cur =  payoutList[idrel];
99         return (cur.receiver, cur.inamount, cur.outamount);
100     }
101     function getBlocksUntilStart() public constant returns (uint count){
102         if(startblock <= block.number) return 0;
103         else return startblock - block.number;
104     }
105     function getAccountInfo(address addr) public constant returns (address retaddr, uint initamount, uint investmenttime, uint currentbalance, uint _timeuntilnextreward, uint _refbonus, address _refaddress, uint _refcount) {
106         Investment storage acc = investmentTable[roundcount][addr];
107         uint nextreward = rewardinterval - ((block.timestamp - acc.inittime) % rewardinterval);
108         if(acc.initamount <= 0) nextreward = 0;
109         return (addr, acc.initamount, block.timestamp - acc.inittime, getAccountBalance(addr), nextreward, acc.refbonus, acc.refaddress, acc.refcount);
110     }
111     function getAccountInfo() public constant returns (address retaddr, uint initamount, uint investmenttime, uint currentbalance, uint _timeuntilnextreward, uint _refbonus, address _refaddress, uint _refcount) {
112         return getAccountInfo(msg.sender);
113     }
114     function getStatus() public constant returns (uint _payoutcount, uint _blocksUntilStart, uint _payincount){
115         return (payoutcount, getBlocksUntilStart(), payincount);
116     }
117 }