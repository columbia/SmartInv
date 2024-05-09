1 pragma solidity ^0.4.13;
2 
3 contract Escrow {
4   address public owner;
5   uint public fee;
6   mapping (address =>  mapping (address => uint)) public balances;
7 
8   function Escrow() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function setFee(uint price) onlyOwner external {
18     fee = price;
19   }
20 
21   function start(address payee) payable external {
22     balances[msg.sender][payee] = balances[msg.sender][payee] + msg.value;
23   }
24 
25   function end(address payer, address payee) onlyOwner external returns(bool){
26     uint value = balances[payer][payee];
27     uint paidFee = value / (1000000 / fee);
28     uint payment = value - paidFee;
29     balances[payer][payee] = 0;
30     payee.transfer(payment);
31     owner.transfer(paidFee);
32     return true;
33   }
34   
35   function refund(address payer, address payee) onlyOwner external returns(bool){
36     uint value = balances[payer][payee];
37     balances[payer][payee] = 0;
38     payer.transfer(value);
39     return true;
40   }
41 }