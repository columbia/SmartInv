1 pragma solidity ^0.4.11;
2 
3 contract Withdrawal {
4     address public owner;
5     mapping(address => uint256) public balanceOf;
6     
7     modifier onlyOwner() {
8         if (owner != msg.sender) {
9             throw;
10         }
11         _;
12     }
13     
14     function Withdrawal() {
15         owner = msg.sender;
16     }
17     
18     // Receive donation.
19     function () payable {
20         balanceOf[msg.sender] += msg.value;
21     }
22     
23     function donate(address _from) payable {
24         balanceOf[_from] += msg.value;
25     }
26     
27     // Withdraw donation.
28     function withdraw() {
29         withdrawFrom(msg.sender);
30     }
31     
32     // Owner can recover anything.
33     function recover(address _from) onlyOwner {
34         withdrawFrom(_from);
35     }
36     
37     function withdrawFrom(address _sender) private {
38         uint256 _val = balanceOf[_sender];
39         if (_val > 0) {
40             balanceOf[_sender] = 0;
41             if (!msg.sender.send(_val)) {
42                 throw;
43             }
44         }
45     }
46 }