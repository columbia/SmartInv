1 pragma solidity ^0.4.24;
2 
3 contract lucky9io {
4     bool private gameOn = true;
5     address private owner = 0x5Bf066c70C2B5e02F1C6723E72e82478Fec41201;
6     uint private entry_number = 0;
7     uint private value = 0;
8 
9     modifier onlyOwner() {
10      require(msg.sender == owner, "Sender not authorized.");
11      _;
12     }
13 
14     function stopGame() public onlyOwner {
15       gameOn = false;
16       owner.transfer(address(this).balance);
17     }
18 
19     function () public payable{
20         if(gameOn == false) {
21             msg.sender.transfer(msg.value);
22             return;
23         }
24 
25         if(msg.value * 1000 < 9) {
26             msg.sender.transfer(msg.value);
27             return;
28         }
29 
30         entry_number = entry_number + 1;
31         value = address(this).balance;
32 
33         if(entry_number % 999 == 0) {
34             msg.sender.transfer(value * 8 / 10);
35             owner.transfer(value * 11 / 100);
36             return;
37         }
38 
39         if(entry_number % 99 == 0) {
40             msg.sender.transfer(0.09 ether);
41             owner.transfer(0.03 ether);
42             return;
43         }
44 
45         if(entry_number % 9 == 0) {
46             msg.sender.transfer(0.03 ether);
47             owner.transfer(0.01 ether);
48             return;
49         }
50     }
51 }