1 pragma solidity ^0.4.20;
2 
3 contract st4ck {
4     address[][] public wereld;
5     address public owner = 0x5372260584003e8Ae3a24E9dF09fa96037a04c2b;
6     mapping(address => uint) public balance; 
7     bool public rowQuiter = false;
8     
9     function st4ckCount() public view returns (uint) {
10         return wereld.length;
11     }
12     
13     function st4ckHeight(uint x) public view returns (uint) {
14         return wereld[x].length;
15     }
16     
17     function price(uint y) public pure returns(uint)   {
18         return 0.005 ether * (uint(2)**y);
19     }
20     
21     function setRowQuiter(bool newValue) public {
22         require(msg.sender == owner);
23         rowQuiter = newValue;
24     }
25     
26     function buyBlock(uint x, uint y) public payable {
27         balance[msg.sender] += msg.value;
28         require(balance[msg.sender] >= price(y));
29         balance[msg.sender] -= price(y);
30         if(x == wereld.length) {
31             require(rowQuiter == false);
32             wereld.length++;
33         }
34         else if (x > wereld.length) {
35             revert();
36         }
37         require(y == wereld[x].length);
38         wereld[x].push(msg.sender);
39             
40         if(y == 0) {
41             balance[owner] += price(y);
42         }
43         else {
44             balance[wereld[x][y - 1]] += price(y) * 99 / 100;
45             balance[owner] += price(y) * 1 / 100;
46         }  
47         
48     }
49     
50     function withdraw() public {
51         msg.sender.transfer(balance[msg.sender]);
52         balance[msg.sender] = 0;
53     }
54 }