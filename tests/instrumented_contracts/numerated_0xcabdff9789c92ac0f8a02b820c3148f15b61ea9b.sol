1 pragma solidity ^0.4.15;
2 
3 contract MembranaDeals {
4   address public be = 0x873A2832898b17b5C12355769A7E2DAe6c2f92f7;
5   enum state { paid, verified, halted, finished}
6   enum currencyType { USDT, BTC, ETH}
7   struct Deal {
8     state  currentState;
9     uint  start;
10     uint  deadline;
11     uint  maxLoss;
12     uint  startBalance;
13     uint  targetBalance;
14     uint  amount;
15     currencyType  currency;
16     string  investor;
17     address  investorAddress;
18     string  trader;
19     address  traderAddress;
20   }
21   Deal[] public deals;
22   function MercatusDeals() public payable{
23     revert();
24   }
25   modifier onlyBe() {
26    require(msg.sender == be);
27    _;
28  }
29   modifier inState(uint dealId, state s) {
30    require(deals[dealId].currentState == s);
31    _;
32  }
33  function getState(uint dealId) public constant returns (uint)  {
34    return uint(deals[dealId].currentState);
35  }
36  function getStart(uint dealId) public constant returns (uint)  {
37    return deals[dealId].start;
38  }
39  function setVerified(uint dealId) public  onlyBe inState(dealId, state.paid) {
40      deals[dealId].currentState = state.verified;
41 }
42 
43  function setHalted(uint dealId) public  onlyBe {
44      require(deals[dealId].currentState == state.paid || deals[dealId].currentState == state.verified);
45      require(deals[dealId].amount != 0);
46      deals[dealId].traderAddress.transfer(deals[dealId].amount);
47      deals[dealId].amount = 0;
48      deals[dealId].currentState = state.halted;
49 }
50 function getSplit(uint finishAmount, uint startBalance, uint targetBalance, uint amount) public pure returns (uint) {
51     return ((finishAmount - startBalance) * amount) / ((targetBalance - startBalance) );
52 }
53  function setFinished(uint dealId, uint finishAmount) public  onlyBe inState(dealId, state.verified) {
54      require(deals[dealId].amount != 0);
55      if(finishAmount <= deals[dealId].startBalance){
56        deals[dealId].investorAddress.transfer(deals[dealId].amount);
57      }else if(finishAmount>deals[dealId].targetBalance){
58        deals[dealId].traderAddress.transfer(deals[dealId].amount);
59      }
60      else{
61         uint split = getSplit(finishAmount, deals[dealId].startBalance, deals[dealId].targetBalance, deals[dealId].amount);
62         deals[dealId].traderAddress.transfer(split);
63         deals[dealId].investorAddress.transfer(deals[dealId].amount - split);
64      }
65      deals[dealId].amount = 0;
66      deals[dealId].currentState = state.finished;
67 }
68     function getDealsCount() public constant returns (uint){
69         return deals.length;
70     }
71 function () external payable  {
72   revert();
73 }
74     function makeDeal(uint _duration, uint _maxLoss, uint _startBalance, uint _targetBalance, uint _amount,  string _investor, address _investorAddress, string _trader, address _traderAddress, uint offer, uint _currency)
75     payable public {
76       require( _currency >= 0 &&  _currency < 3  );
77       require(msg.value == _amount);
78         deals.push(Deal({
79             currentState: state.paid,
80             start: now,
81             deadline: 0,
82             maxLoss: _maxLoss,
83             startBalance: _startBalance,
84             targetBalance: _targetBalance,
85             amount: _amount,
86             currency: currencyType(_currency),
87             investor: _investor,
88             investorAddress: _investorAddress,
89             trader: _trader,
90             traderAddress: _traderAddress
91           }));
92           deals[deals.length-1].deadline = now +  _duration * 86400;
93         spawnInstance(msg.sender,deals.length-1, now, offer);
94     }
95     event spawnInstance(address indexed from, uint indexed dealId, uint start, uint offer);
96 }