1 pragma solidity ^0.4.24;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) public onlyOwner {
19         newOwner = _newOwner;
20     }
21     
22     function acceptOwnership() public {
23         require(msg.sender == newOwner);
24         emit OwnershipTransferred(owner, newOwner);
25         owner = newOwner;
26         newOwner = address(0);
27     }
28 }
29 
30 contract CRTLotto is Owned {
31     uint public ticketPrice;
32     uint public totalTickets;
33 
34     mapping(uint => address) public tickets;
35 
36     constructor() public {
37         ticketPrice = 0.01 * 10 ** 18;
38         totalTickets = 0;
39     }
40     
41     function setTicketPrice(uint _ticketPrice) external onlyOwner {
42         ticketPrice = _ticketPrice;
43     }
44     
45     function() payable external {
46         uint ethSent = msg.value;
47         require(ethSent >= ticketPrice);
48         
49         tickets[totalTickets] = msg.sender;
50         totalTickets += 1;
51     }
52     
53     function resetLotto() external onlyOwner {
54         totalTickets = 0;
55     }
56     
57     function withdrawEth() external onlyOwner {
58         owner.transfer(address(this).balance);
59     }
60 }