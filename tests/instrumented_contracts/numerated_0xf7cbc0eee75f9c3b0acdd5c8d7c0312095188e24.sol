1 pragma solidity ^0.4.15;
2 
3 contract Dice1{
4     
5     uint public minbet = 10000000000000000; // bet minimum 0.01 ether
6     uint public maxbet; // bet maximum
7     uint public houseedge = 190; // 190%% house edge
8     uint public luckynum;
9     string public winlose;
10     
11     address public banker;
12     
13     event YouWin(address winner, uint betvalue, uint winvalue);
14     event YouLose(address loser, uint betvalue);
15     
16     /* Constructor */
17     function Dice1() payable{
18         maxbet = msg.value/5;
19         require(maxbet > minbet);
20         
21         banker = msg.sender;
22     }
23     
24     // called by contract to generate random number between 0-9
25     function _getrand09() returns(uint) {
26         return uint(block.blockhash(block.number-1))%10;
27     }
28     
29     // receive gambler's money and start betting
30     function () payable {
31         require(msg.value >= minbet);
32         require(msg.value <=maxbet);
33         require(this.balance >= msg.value*2);
34         
35         luckynum = _getrand09();
36         if (luckynum < 5) {
37             uint winvalue = msg.value*2*(10000-190)/10000;
38             YouWin(msg.sender, msg.value, winvalue);
39             msg.sender.transfer(winvalue);
40             winlose = 'win';
41         }
42         else{
43             YouLose(msg.sender, msg.value);
44             msg.sender.transfer(1);
45             winlose = 'lose';
46         }
47     }
48     
49     // get money back
50     function kill() {
51         require(msg.sender == banker);
52         suicide(banker);
53     }
54 }