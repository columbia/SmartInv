1 pragma solidity ^0.4.11;
2 contract FundariaBonusFund {
3     
4     mapping(address=>uint) public ownedBonus; // storing bonus wei
5     mapping(address=>int) public investorsAccounts; // Fundaria investors accounts
6     uint public finalTimestampOfBonusPeriod; // when the bonus period ends
7     address registeringContractAddress; // contract which can register investors accounts
8     address public fundariaTokenBuyAddress; // address of FundariaTokenBuy contract
9     address creator; // creator address of this contract
10     
11     event BonusWithdrawn(address indexed bonusOwner, uint bonusValue);
12     event AccountFilledWithBonus(address indexed accountAddress, uint bonusValue, int totalValue);
13     
14     function FundariaBonusFund() {
15         creator = msg.sender;
16     }
17     
18     // condition to be creator address to run some functions
19     modifier onlyCreator { 
20         if(msg.sender == creator) _; 
21     }
22     
23     // condition for method to be executed only by bonus owner
24     modifier onlyBonusOwner { 
25         if(ownedBonus[msg.sender]>0) _; 
26     }
27     
28     function setFundariaTokenBuyAddress(address _fundariaTokenBuyAddress) onlyCreator {
29         fundariaTokenBuyAddress = _fundariaTokenBuyAddress;    
30     }
31     
32     function setRegisteringContractAddress(address _registeringContractAddress) onlyCreator {
33         registeringContractAddress = _registeringContractAddress;    
34     }
35     
36     // availability for creator address to set when bonus period ends, but not later then current end moment
37     function setFinalTimestampOfBonusPeriod(uint _finalTimestampOfBonusPeriod) onlyCreator {
38         if(finalTimestampOfBonusPeriod==0 || _finalTimestampOfBonusPeriod<finalTimestampOfBonusPeriod)
39             finalTimestampOfBonusPeriod = _finalTimestampOfBonusPeriod;    
40     }
41     
42     
43     // bonus creator can withdraw their wei after bonus period ended
44     function withdrawBonus() onlyBonusOwner {
45         if(now>finalTimestampOfBonusPeriod) {
46             var bonusValue = ownedBonus[msg.sender];
47             ownedBonus[msg.sender] = 0;
48             BonusWithdrawn(msg.sender, bonusValue);
49             msg.sender.transfer(bonusValue);
50         }
51     }
52     
53     // registering investor account
54     function registerInvestorAccount(address accountAddress) {
55         if(creator==msg.sender || registeringContractAddress==msg.sender) {
56             investorsAccounts[accountAddress] = -1;    
57         }
58     }
59 
60     // bonus owner can transfer their bonus wei to any investor account before bonus period ended
61     function fillInvestorAccountWithBonus(address accountAddress) onlyBonusOwner {
62         if(investorsAccounts[accountAddress]==-1 || investorsAccounts[accountAddress]>0) {
63             var bonusValue = ownedBonus[msg.sender];
64             ownedBonus[msg.sender] = 0;
65             if(investorsAccounts[accountAddress]==-1) investorsAccounts[accountAddress]==0; 
66             investorsAccounts[accountAddress] += int(bonusValue);
67             AccountFilledWithBonus(accountAddress, bonusValue, investorsAccounts[accountAddress]);
68             accountAddress.transfer(bonusValue);
69         }
70     }
71     
72     // add information about bonus wei ownership
73     function setOwnedBonus() payable {
74         if(msg.sender == fundariaTokenBuyAddress)
75             ownedBonus[tx.origin] += msg.value;         
76     }
77 }