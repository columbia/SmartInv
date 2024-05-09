1 pragma solidity ^0.4.0;
2 
3 contract Dealer {
4 
5     address public pitboss;
6     uint public constant ceiling = 0.25 ether;
7 
8     event Deposit(address indexed _from, uint _value);
9 
10     function Dealer() public {
11       pitboss = msg.sender;
12     }
13 
14     function () public payable {
15       Deposit(msg.sender, msg.value);
16     }
17 
18     modifier pitbossOnly {
19       require(msg.sender == pitboss);
20       _;
21     }
22 
23     function cashout(address winner, uint amount) public pitbossOnly {
24       winner.transfer(amount);
25     }
26 
27     function overflow() public pitbossOnly {
28       require (this.balance > ceiling);
29       pitboss.transfer(this.balance - ceiling);
30     }
31 
32     function kill() public pitbossOnly {
33       selfdestruct(pitboss);
34     }
35 
36 }