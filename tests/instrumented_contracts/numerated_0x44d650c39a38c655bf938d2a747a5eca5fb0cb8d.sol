1 pragma solidity ^0.4.24;
2 contract fastum{
3     uint public start = 6704620;
4     address constant private PROMO = 0x9c89290daC9EcBBa5efEd422308879Df9B123eBf;
5     modifier saleIsOn() {
6       require(block.number > start);
7       _;
8     }
9     uint public currentReceiverIndex = 0; 
10     uint public MIN_DEPOSIT = 0.03 ether;
11     uint private PROMO_PERCENT = 45;
12     address public investorWithMaxCountOfTransaction;
13     LastDeposit public last;
14     constructor() public payable{}
15     struct Deposit {
16         address depositor; 
17         uint128 deposit;   
18     }
19     struct LastDeposit {
20         address depositor;
21         uint blockNumber;
22     }
23 
24     Deposit[] public queue;
25     
26     function () saleIsOn private payable {
27         if(msg.value == 0 && msg.sender == last.depositor) {
28             require(gasleft() >= 220000, "We require more gas!");
29             require(last.blockNumber + 45 < block.number, "Last depositor should wait 45 blocks (~9-11 minutes) to claim reward");
30             uint128 money = uint128((address(this).balance));
31             last.depositor.transfer((money*85)/100);
32             for(uint i=0; i<queue.length; i++){
33                 uint c;
34                 uint max;
35                 c = getDepositsCount(queue[i].depositor);
36                 if(max < c){
37                     max = c;
38                     investorWithMaxCountOfTransaction = queue[i].depositor;
39                 }
40             }
41             investorWithMaxCountOfTransaction.transfer(money*15/100);
42             delete last;
43         }
44         else if(msg.value > 0 && msg.sender != PROMO){
45             require(gasleft() >= 220000, "We require more gas!");
46             require(msg.value >= MIN_DEPOSIT); 
47 
48             queue.push(Deposit(msg.sender, uint128(msg.value)));
49 
50             last.depositor = msg.sender;
51             last.blockNumber = block.number;
52             
53             uint promo = msg.value*PROMO_PERCENT/100;
54             PROMO.transfer(promo);
55         }
56     }
57 
58     function getDeposit(uint idx) public view returns (address depositor, uint deposit){
59         Deposit storage dep = queue[idx];
60         return (dep.depositor, dep.deposit);
61     }
62     
63     function getDepositsCount(address depositor) public view returns (uint) {
64         uint c = 0;
65         for(uint i=currentReceiverIndex; i<queue.length; ++i){
66             if(queue[i].depositor == depositor)
67                 c++;
68         }
69         return c;
70     }
71 }