1 pragma solidity ^0.4.24;
2 
3 // *****
4 // step-by-step.io
5 // First initial micro-ICO in series
6 
7 contract Ownable {
8     address public owner;
9     
10     function Ownable() public {
11         owner = msg.sender;
12     }
13     
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18 }
19 
20 contract microICO is Ownable {
21     uint public soft_cap = 10 ether;
22     uint public end_date = 1532254525;
23     address public owner = 0xF08FE88Ed3120e19546EeEE1ebe5E7b2FF66b5e7;
24     address[] public holders;
25     mapping (address => uint) public holder_balance;
26     
27     function myICO() public {
28         owner = msg.sender;
29         soft_cap = 1 ether; // once we raise min 1 ETH, we can get them and run 1st stage
30         end_date = now + 30 days; // otherwise holders can take their money back 30 days later 
31     }
32     
33     function sendFunds(address _addr) public onlyOwner {
34         require (address(this).balance >= soft_cap); // getting $ETH only if soft_cap reached
35         _addr.transfer(address(this).balance);
36     }
37 
38     function withdraw() public {
39         uint amount;
40         require(now > end_date);// holders can take their money back 30 days later
41         amount = holder_balance[msg.sender];
42         holder_balance[msg.sender] = 0;
43         msg.sender.transfer(amount);
44     }
45     
46     function () public payable {
47         require(msg.value > 0);
48         holders.push(msg.sender);
49         holder_balance[msg.sender] += msg.value;
50     }
51 
52     function getFunds() public view returns (uint){
53         return address(this).balance;
54     }
55 }