1 pragma solidity ^0.4.15;
2 
3 contract MercatusDeals {
4   uint dealsCount;
5   address public be = 0x873A2832898b17b5C12355769A7E2DAe6c2f92f7;
6   enum state { paid, verified, halted, finished}
7   enum currencyType { USDT, BTC, ETH}
8   struct Deal {
9     state  currentState;
10     uint  start;
11     uint  deadline;
12     uint  maxLoss;
13     uint  startBalance;
14     uint  targetBalance;
15     uint  amount;
16     currencyType  currency;
17     string  investor;
18     address  investorAddress;
19     string  trader;
20     address  traderAddress;
21   }
22   Deal[] public deals;
23   function MercatusDeals() payable{}
24   modifier onlyBe() {
25    require(msg.sender == be);
26    _;
27  }
28   modifier inState(uint dealId, state s) {
29    require(deals[dealId].currentState == s);
30    _;
31  }
32  function getState(uint dealId) public constant returns (uint)  {
33    return uint(deals[dealId].currentState);
34  }
35  function getStart(uint dealId) public constant returns (uint)  {
36    return deals[dealId].start;
37  }
38  function setVerified(uint dealId) public  onlyBe inState(dealId, state.paid) {
39      deals[dealId].currentState = state.verified;
40 }
41 
42  function setHalted(uint dealId) public  onlyBe {
43      require(deals[dealId].currentState == state.paid || deals[dealId].currentState == state.verified);
44      deals[dealId].traderAddress.transfer(deals[dealId].amount);
45      deals[dealId].currentState = state.halted;
46 }
47 function getSplit(uint finishAmount, uint startBalance, uint targetBalance, uint amount) public pure returns (uint) {
48     return ((finishAmount - startBalance) * amount) / ((targetBalance - startBalance) );
49 }
50  function setFinished(uint dealId, uint finishAmount) public  onlyBe inState(dealId, state.verified) {
51      if(finishAmount <= deals[dealId].startBalance){
52        deals[dealId].investorAddress.transfer(deals[dealId].amount);
53      }else if(finishAmount>deals[dealId].targetBalance){
54        deals[dealId].traderAddress.transfer(deals[dealId].amount);
55      }
56      else{
57         uint split = getSplit(finishAmount, deals[dealId].startBalance, deals[dealId].targetBalance, deals[dealId].amount);
58         deals[dealId].traderAddress.transfer(split);
59         deals[dealId].investorAddress.transfer(deals[dealId].amount - split);
60      }
61      deals[dealId].currentState = state.finished;
62 }
63     function getDealsCount() public constant returns (uint){
64         return deals.length;
65     }
66 function () public payable {
67 }
68     function makeDeal(uint _duration, uint _maxLoss, uint _startBalance, uint _targetBalance, uint _amount,  string _investor, address _investorAddress, string _trader, address _traderAddress, uint offer, uint _currency)
69     payable public {
70       require( _currency >= 0 &&  _currency < 3  );
71       require(msg.value == _amount);
72         deals.push(Deal({
73             currentState: state.paid,
74             start: now,
75             deadline: 0,
76             maxLoss: _maxLoss,
77             startBalance: _startBalance,
78             targetBalance: _targetBalance,
79             amount: _amount,
80             currency: currencyType(_currency),
81             investor: _investor,
82             investorAddress: _investorAddress,
83             trader: _trader,
84             traderAddress: _traderAddress
85           }));
86           deals[deals.length-1].deadline = now +  _duration * 86400;
87         spawnInstance(msg.sender,deals.length-1, now, offer);
88     }
89     event spawnInstance(address indexed from, uint indexed dealId, uint start, uint offer);
90 }