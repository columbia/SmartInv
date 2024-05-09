1 pragma solidity ^0.4.15;
2 
3 // Anyone can own this contract as long as they pay less
4 // than the previous owner.
5 contract EtherImp {
6     address public creator;
7     address public currentOwner;
8     address public previousOwner;
9     uint public lastPricePaid;
10 
11     event LogTransfer(
12         address _from,
13         address _to,
14         uint _value
15     );
16 
17     function EtherImp() payable public {
18         require(msg.value > 0);
19 
20         creator = msg.sender;
21         currentOwner = creator;
22         previousOwner = creator;
23         lastPricePaid = msg.value;
24     }
25     
26     function buyBottle() payable public {
27         // Conditions
28         require(msg.sender != currentOwner);
29         require(msg.value > 0);
30         require(msg.value < lastPricePaid);
31         
32         // Effects
33         previousOwner = currentOwner;
34         currentOwner = msg.sender;
35         lastPricePaid = msg.value;
36         LogTransfer(previousOwner, currentOwner, lastPricePaid);
37         
38         // Interactions
39         previousOwner.transfer(msg.value);
40     }
41 
42     function close() onlyCreator {
43         selfdestruct(creator);
44     }
45 
46     modifier onlyCreator {
47         require(msg.sender == creator);
48         _;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == currentOwner);
53         _;
54     }
55 }