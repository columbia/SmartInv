1 pragma solidity ^0.4.23;
2 
3 contract LoversForLife {
4     struct Lovers {
5         string lover1;
6         string lover2;
7         string whyDoYouLove;
8         uint worth;
9         
10         
11     }
12     
13     uint minPrice = 500000000000000;
14     uint maxPrice = 500000000000000000;
15     address creator;
16     Lovers[] public loverList;
17     uint public amountOfLovers = 0;
18     mapping(address => uint) loverNumber;
19 
20     constructor() public {
21         creator = msg.sender;
22     }
23 
24     function setPrice(uint price) public{
25         require(msg.sender == creator);
26         minPrice = price;
27     }
28     
29     function createLover(string l1, string l2, string message) public payable{
30         require(msg.value >= minPrice);
31         require(msg.value <= maxPrice);
32         Lovers memory newLover = Lovers ({
33             lover1: l1,
34             lover2: l2,
35             whyDoYouLove: message,
36             worth: msg.value
37             
38             
39         });
40         
41         loverList.push(newLover);
42         loverNumber[msg.sender] = amountOfLovers;
43         amountOfLovers++;
44        
45         creator.transfer(msg.value);
46     }
47     
48     function findLover(address user) public view returns (uint){
49         return loverNumber[user];
50     }
51     
52     
53     
54     
55 }