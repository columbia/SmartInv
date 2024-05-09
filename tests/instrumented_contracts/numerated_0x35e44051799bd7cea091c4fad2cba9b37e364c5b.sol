1 pragma solidity ^0.4.24;
2 
3 // Fabrica pre-ICO stage
4 //      see proposal at fabrica.io
5 
6 contract Ownable {
7     address public owner;
8     
9     function Ownable() public {
10         owner = msg.sender;
11     }
12     
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 }
18 
19 contract myPreICO is Ownable {
20     uint public ETHRaised;
21     uint public soft_cap = 1 ether; // once we raise min 1 ETH, we can get them and start the ICO preparation
22     uint public hard_cap = 10 ether;// once we've raised 10 ETH, you can't withdraw them back, project will run to the ICO stage
23     address public owner = 0x0;
24     uint public end_date;
25     address[] public holders;
26     mapping (address => uint) public holder_balance;
27     
28     function myICO() public {
29         owner = msg.sender;
30         end_date = now + 90 days; // holders can take their money back some time later if pre-ICO failed
31     }
32 
33     function sendFunds(address _addr) public onlyOwner {
34         require (ETHRaised >= soft_cap); // can get $ETH only if soft_cap reached
35         _addr.transfer(address(this).balance);
36     }
37 
38     function withdraw() public {
39         uint amount;
40         require(now > end_date);// holders can take their money back if pre-ICO failed ...
41         require(ETHRaised < hard_cap);// ... and hard_cap has't been reached
42         amount = holder_balance[msg.sender];
43         holder_balance[msg.sender] = 0;
44         msg.sender.transfer(amount);
45     }
46     
47     function () public payable {
48         require(msg.value > 0);
49         holders.push(msg.sender);
50         holder_balance[msg.sender] += msg.value;
51         ETHRaised += msg.value;
52     }
53 
54     function getFunds() public view returns (uint){
55         return address(this).balance;
56     }
57 }