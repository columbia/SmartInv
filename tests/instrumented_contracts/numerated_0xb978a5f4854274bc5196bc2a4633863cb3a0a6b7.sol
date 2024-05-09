1 pragma solidity ^0.4.0;
2 
3 contract Pyramid {
4     address master;
5 
6     address[] memberQueue;
7     uint queueFront;
8 
9     event Joined(address indexed _member, uint _entries, uint _paybackStartNum);
10 
11     modifier onlymaster { if (msg.sender == master) _; }
12 
13     function Pyramid() {
14         master = msg.sender;
15         memberQueue.push(master);
16         queueFront = 0;
17     }
18 
19     // fallback function, wont work to call join here bc we will run out of gas (2300 gas for send())
20     function(){}
21 
22     // users are allowed to join with .1 - 5 ethereum
23     function join() payable {
24         require(msg.value >= 100 finney);
25 
26         uint entries = msg.value / 100 finney;
27         entries = entries > 50 ? 50 : entries; // cap at 5 ethereum
28 
29         for (uint i = 0; i < entries; i++) {
30             memberQueue.push(msg.sender);
31 
32             if (memberQueue.length % 2 == 1) {
33                 queueFront += 1;
34                 memberQueue[queueFront-1].transfer(194 finney);
35             }
36         }
37 
38         Joined(msg.sender, entries, memberQueue.length * 2);
39 
40         // send back any unused ethereum
41         uint remainder = msg.value - (entries * 100 finney);
42         if (remainder > 1 finney) {
43             msg.sender.transfer(remainder);
44         }
45         //msg.sender.send(msg.value - entries * 100 finney);
46     }
47 
48     function collectFee() onlymaster {
49         master.transfer(this.balance - 200 finney);
50     }
51 
52     function setMaster(address _master) onlymaster {
53         master = _master;
54     }
55 
56 }