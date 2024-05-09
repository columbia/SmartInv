1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Crowdsale/CrowdsaleToken.sol
4 
5 interface CrowdsaleToken {
6     function transfer(address destination, uint amount) external returns (bool);
7     function balanceOf(address account) external view returns (uint);
8     function burn(uint amount) external;
9 }
10 
11 // File: contracts/Token/CrowdsaleState.sol
12 
13 interface CrowdsaleState {
14     function isCrowdsaleSuccessful() external view returns(bool);
15 }
16 
17 // File: contracts/Token/HardCap.sol
18 
19 interface HardCap {
20     function getHardCap() external pure returns(uint);
21 }
22 
23 // File: contracts/Utils/Ownable.sol
24 
25 contract Ownable {
26     address public owner;
27 
28     constructor() public {
29         owner = msg.sender;
30     }
31 
32     function isOwner() view public returns (bool) {
33         return msg.sender == owner;
34     }
35 
36     modifier grantOwner {
37         require(isOwner());
38         _;
39     }
40 }
41 
42 // File: contracts/Proxy/ERC20Allowance.sol
43 
44 interface ERC20Allowance
45 {
46     function transferFrom(address source, address destination, uint amount) external returns (bool);
47 }
48 
49 // File: contracts/Proxy/CryptoPoliceProxy.sol
50 
51 contract CryptoPoliceProxy is Ownable
52 {
53     address public token;
54     address public crowdsale;
55     mapping(address => bool) public allowanceProxyAccess;
56 
57     constructor(address _token) public {
58         token = _token;
59     }
60 
61     function grantAllowanceProxyAccess(address allowanceOwner) grantOwner public {
62         allowanceProxyAccess[allowanceOwner] = true;
63     }
64 
65     function denyAllowanceProxyAccess(address allowanceOwner) grantOwner public {
66         allowanceProxyAccess[allowanceOwner] = false;
67     }
68 
69     function transferAllowance(address destination, uint amount) public returns (bool) {
70         require(allowanceProxyAccess[msg.sender], "Sender must have allowance proxy access");
71         return ERC20Allowance(token).transferFrom(owner, destination, amount);
72     }
73 
74     function setCrowdsale(address _crowdsale) grantOwner public {
75         crowdsale = _crowdsale;
76     }
77 
78     function transfer(address destination, uint amount) grantCrowdsale public returns (bool)
79     {
80         return CrowdsaleToken(token).transfer(destination, amount);
81     }
82 
83     function balanceOf(address account) grantCrowdsale public view returns (uint)
84     {
85         if (account == crowdsale) {
86             return CrowdsaleToken(token).balanceOf(address(this));
87         } else {
88             return CrowdsaleToken(token).balanceOf(account);
89         }
90     }
91 
92     function burn(uint amount) grantCrowdsale public
93     {
94         CrowdsaleToken(token).burn(amount);
95     }
96 
97     modifier grantCrowdsale {
98         require(crowdsale != 0x0, "Crowdsale not set");
99         require(msg.sender == crowdsale, "Sender must be crowdsale");
100         _;
101     }
102 
103     function getHardCap() public pure returns(uint)
104     {
105         return 510000000e18;
106     }
107 
108     function isCrowdsaleSuccessful() public view returns(bool)
109     {
110         return CrowdsaleState(crowdsale).isCrowdsaleSuccessful();
111     }
112 
113 }