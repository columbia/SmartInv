1 pragma solidity ^0.4.17;
2 
3 contract publish_text {
4     
5     string public message;
6     address public owner;
7     
8     modifier onlyOwner() {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     constructor(string initialMessage) public {
14         message = initialMessage;
15         owner = msg.sender;
16     }
17     
18     function modifyMessage(string newMessage) onlyOwner public {
19         message = newMessage;
20     }
21     
22     function flushETH() public onlyOwner {
23         uint my_balance = address(this).balance;
24         if (my_balance > 0){
25             owner.transfer(address(this).balance);
26         }
27     }
28     
29     function flushERC20(address tokenContractAddress) public onlyOwner {
30         ERC20Interface instance = ERC20Interface(tokenContractAddress);
31         address forwarderAddress = address(this);
32         uint forwarderBalance = instance.balanceOf(forwarderAddress);
33         if (forwarderBalance == 0) {
34           return;
35         }
36         if (!instance.transfer(owner, forwarderBalance)) {
37           revert();
38         }
39     }
40 }
41 
42 contract ERC20Interface {
43     function transfer(address _to, uint256 _value) public returns (bool success);
44     function balanceOf(address _owner) public constant returns (uint256 balance);
45 }