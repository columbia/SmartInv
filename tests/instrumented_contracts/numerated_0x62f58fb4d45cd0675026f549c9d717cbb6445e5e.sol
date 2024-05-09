1 pragma solidity ^0.4.24;
2 
3 contract ETHerNity {
4     
5     struct Tx {
6         address user;
7         uint value;
8     }
9     
10     address public owner;
11     Tx[] public txs;
12     bool blocking;
13     
14     uint constant MIN_ETHER = 0.01 ether;
15     
16     modifier onlyOwner() {
17         require(msg.sender == owner);
18         _;
19     }
20     
21     modifier mutex() {
22         blocking = true;
23         _;
24         blocking = false;
25     }
26     
27     constructor() public {
28         owner = msg.sender;
29     }
30     
31     function() payable public {
32         withReferrer(owner);
33         
34         if (msg.sender == owner) {
35             dispatch();
36         }
37     }
38     
39     function withReferrer(address referrar) payable public {
40         if (blocking) return;
41         
42         owner.send(msg.value / 10);
43         referrar.send(msg.value / 10);
44         
45         if (msg.value < MIN_ETHER)
46             return;
47 
48         txs.push(Tx({
49            user: msg.sender,
50            value: msg.value / 30
51         }));
52     }
53     
54     function dispatch() onlyOwner mutex public {
55         for(uint i = 0; i < txs.length; i++) {
56             if (address(this).balance >= txs[i].value)
57                 txs[i].user.send(txs[i].value);
58         }
59             
60     }
61 
62 }