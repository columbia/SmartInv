1 pragma solidity ^0.4.11;
2 
3 contract Johnsonville {
4 
5     address owner;
6     address patronOne;
7     address patronTwo;
8     address patronThree;
9 
10     bool patronOneWd;
11     bool patronTwoWd;
12     bool patronThreeWd;
13 
14     modifier onlyOwner {
15       if(msg.sender != owner) throw;
16       _;
17     }
18 
19     function Johnsonville() {
20       owner = msg.sender;
21       patronOneWd = false;
22       patronTwoWd = false;
23       patronThreeWd = false;
24     }
25 
26     function Donate() payable {
27       if(msg.value > patronOne.balance || patronOne == 0x0){
28         patronOne = msg.sender;
29         return;
30       }
31       if(msg.value > patronTwo.balance || patronTwo == 0x0){
32         patronTwo = msg.sender;
33         return;
34       }
35       if(msg.value > patronThree.balance || patronThree == 0x0){
36         patronThree = msg.sender;
37         return;
38       }
39     }
40 
41     function PatronOneWithdrawal(){
42       if(msg.sender == patronOne){ patronOneWd = !patronOneWd; }
43     }
44 
45     function PatronTwoWithdrawal(){
46       if(msg.sender == patronTwo){ patronTwoWd = !patronTwoWd; }
47     }
48 
49     function PatronThreeWithdrawal(){
50       if(msg.sender == patronThree){ patronThreeWd = !patronThreeWd; }
51     }
52 
53     function Withdrawal(address withdrawalAddress) onlyOwner {
54       if(patronOneWd && patronTwoWd && patronThreeWd){
55         selfdestruct(withdrawalAddress);
56       }
57     }
58 
59     function KillContract() onlyOwner {
60       selfdestruct(0x0);
61     }
62 }