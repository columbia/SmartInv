1 pragma solidity ^0.4.18;
2 
3 //    88 88888888888 88888888888 88888888ba  88888888ba      88         ,d8  
4 //    88 88          88          88      "8b 88      "8b   ,d88       ,d888  
5 //    88 88          88          88      ,8P 88      ,8P 888888     ,d8" 88  
6 //    88 88aaaaa     88aaaaa     88aaaaaa8P' 88aaaaaa8P'     88   ,d8"   88  
7 //    88 88"""""     88"""""     88""""""8b, 88""""88'       88 ,d8"     88  
8 //    88 88          88          88      `8b 88    `8b       88 8888888888888
9 //    88 88          88          88      a8P 88     `8b      88          88  
10 //    88 88888888888 88          88888888P"  88      `8b     88          88  
11 //    
12 //            THE SMART CONTRACT THAT DOESNT REALLY DO ANYTHING
13 
14 contract IEFBR14Contract {
15    address public owner;       // I made dis :)
16    address[] public users;     // We use it
17    address[] public sponsors;  // Yeah we sponsor...
18    
19    event IEF403I(address submitter);
20    event IEF404I(address submitter);
21    event S222(address operator);
22    event IEE504I(address sponsor, uint value);
23 
24    function IEFBR14Contract() public payable{
25        owner = msg.sender;
26    }
27 
28    function IEFBR14()  public{
29        // Ok, it does a little bit more than nothing :)
30        IEF403I(msg.sender);
31        users.push(msg.sender);
32        IEF404I(msg.sender);       
33    }
34 
35    function Cancel() public{
36        // Let's make it possible to kill this contract
37        require(msg.sender == owner);
38        selfdestruct(owner);
39        S222(msg.sender);
40    }
41 
42    function Sponsor() payable public{
43        // You never know, we might get some sponsors...
44        IEE504I(msg.sender, msg.value);
45        sponsors.push(msg.sender);
46        owner.transfer(msg.value);
47    }
48 }