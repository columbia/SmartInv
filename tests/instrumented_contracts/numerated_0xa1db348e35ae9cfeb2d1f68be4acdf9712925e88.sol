1 pragma solidity ^0.4.21;
2 
3 contract holder {
4     function onIncome() public payable; 
5 }
6 
7 contract BatchControl {
8 
9     mapping (address => uint256) public allowed;
10     address public owner;
11     uint256 public price;
12     holder public holderContract;
13 
14     event BUY(address buyer, uint256 amount, uint256 total);
15     event HOLDER(address holder);
16     
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     constructor(uint256 _price) public {
23         owner = msg.sender;
24         allowed[owner] = 1000000;
25         price = _price;
26     }
27     
28     function withdrawal() public {
29         owner.transfer(address(this).balance);
30     }
31     
32     function buy(uint256 amount) payable public {
33         uint256 total = price * amount;
34         assert(total >= price);
35         require(msg.value >= total);
36         
37         allowed[msg.sender] += amount;
38         
39         if (holderContract != address(0)) {
40             holderContract.onIncome.value(msg.value)();
41         }
42         emit BUY(msg.sender, amount, allowed[msg.sender]);
43     }
44     
45     function setPrice(uint256 _p) onlyOwner public {
46         price = _p;
47     }
48     
49     function setHolder(address _holder) onlyOwner public {
50         holderContract = holder(_holder);
51         
52         emit HOLDER(_holder);
53     }
54 }