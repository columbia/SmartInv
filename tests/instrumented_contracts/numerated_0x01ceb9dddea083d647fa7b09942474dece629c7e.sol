1 pragma solidity ^0.4.24;
2 
3 // File: contracts/TeamPerfitForwarder.sol
4 
5 contract TeamPerfitForwarder {
6     string public name = "TeamPerfitForwarder";
7     address public owner;
8     address public teamPerfitAddr;
9 
10     modifier onlyOwner {
11         assert(owner == msg.sender);
12         _;
13     }
14 
15     constructor() 
16         public
17     {
18         owner = msg.sender;
19         teamPerfitAddr = msg.sender;
20     }
21 
22     function() public payable
23     {
24         require(msg.value > 0, "zero value not allowed");
25 
26         teamPerfitAddr.transfer(msg.value);
27     }
28 
29     function deposit() public payable returns(bool)
30     {
31         require(msg.value > 0, "Forwarder Deposit failed - zero deposits not allowed");
32 
33         teamPerfitAddr.transfer(msg.value);
34 
35         return true;
36     }
37 
38     function status() public view returns(address, address)
39     {
40         return (address(teamPerfitAddr), address(owner));
41     }
42 
43     function setTeamPerfitAddr(address newTeamPerfitAddr) public onlyOwner {
44         teamPerfitAddr = newTeamPerfitAddr;
45     }
46 }