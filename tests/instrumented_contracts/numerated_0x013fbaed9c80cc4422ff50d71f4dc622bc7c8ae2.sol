1 pragma solidity ^0.4.8;
2 
3 //ERC20 Compliant
4 contract SPARCPresale {    
5     uint256 public maxEther     = 1000 ether;
6     uint256 public etherRaised  = 0;
7     
8     address public SPARCAddress;
9     address public beneficiary;
10     
11     bool    public funding      = false;
12     
13     address public owner;
14     modifier onlyOwner() {
15         if (msg.sender != owner) {
16             throw;
17         }
18         _;
19     }
20  
21     function SPARCPresale() {
22         owner           = msg.sender;
23         beneficiary     = msg.sender;
24     }
25     
26     function withdrawEther(uint256 amount) onlyOwner {
27         require(amount <= this.balance);
28         
29         if(!beneficiary.send(this.balance)){
30             throw;
31         }
32     }
33     
34     function setSPARCAddress(address _SPARCAddress) onlyOwner {
35         SPARCAddress    = _SPARCAddress;
36     }
37     
38     function startSale() onlyOwner {
39         funding = true;
40     }
41     
42     // Ether transfer to this contact is only available untill the presale limit is reached.
43     
44     // By transfering ether to this contract you are agreeing to these terms of the contract:
45     // - You are not in anyway forbidden from doing business with Canadian businesses or citizens.
46     // - Your funds are not proceeeds of illegal activity.
47     // - Howey Disclaimer:
48     //   - SPARCs do not represent equity or share in the foundation.
49     //   - SPARCs are products of the foundation.
50     //   - There is no expectation of profit from your purchase of SPARCs.
51     //   - SPARCs are for the purpose of reserving future network power.
52     function () payable {
53         assert(funding);
54         assert(etherRaised < maxEther);
55         require(msg.value != 0);
56         require(etherRaised + msg.value <= maxEther);
57         
58         etherRaised  += msg.value;
59         
60         if(!SPARCToken(SPARCAddress).create(msg.sender, msg.value * 20000)){
61             throw;
62         }
63     }
64 }
65 
66 /// SPARCToken interface
67 contract SPARCToken {
68     function create(address to, uint256 amount) returns (bool);
69 }