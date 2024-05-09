1 /*
2   8888888 .d8888b.   .d88888b.   .d8888b.  888                     888                 888      
3     888  d88P  Y88b d88P" "Y88b d88P  Y88b 888                     888                 888      
4     888  888    888 888     888 Y88b.      888                     888                 888      
5     888  888        888     888  "Y888b.   888888  8888b.  888d888 888888      .d8888b 88888b.  
6     888  888        888     888     "Y88b. 888        "88b 888P"   888        d88P"    888 "88b 
7     888  888    888 888     888       "888 888    .d888888 888     888        888      888  888 
8     888  Y88b  d88P Y88b. .d88P Y88b  d88P Y88b.  888  888 888     Y88b.  d8b Y88b.    888  888 
9   8888888 "Y8888P"   "Y88888P"   "Y8888P"   "Y888 "Y888888 888      "Y888 Y8P  "Y8888P 888  888 
10 
11   Rocket startup for your ICO
12 
13   The innovative platform to create your initial coin offering (ICO) simply, safely and professionally.
14   All the services your project needs: KYC, AI Audit, Smart contract wizard, Legal template,
15   Master Nodes management, on a single SaaS platform!
16 */
17 pragma solidity ^0.4.21;
18 
19 // File: contracts\ICOStartPromo.sol
20 
21 contract ICOStartPromo {
22 
23   string public url = "https://icostart.ch/token-sale";
24   string public name = "icostart.ch/promo";
25   string public symbol = "ICHP";
26   uint8 public decimals = 18;
27   uint256 public totalSupply = 1000000 ether;
28 
29   address private owner;
30 
31   event Transfer(address indexed _from, address indexed _to, uint256 _value);
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   function ICOStartPromo() public {
40     owner = msg.sender;
41   }
42 
43   function setName(string _name) onlyOwner public {
44     name = _name;
45   }
46 
47   function setSymbol(string _symbol) onlyOwner public {
48     symbol = _symbol;
49   }
50 
51   function setUrl(string _url) onlyOwner public {
52     url = _url;
53   }
54 
55   function balanceOf(address /*_owner*/) public view returns (uint256) {
56     return 1000 ether;
57   }
58 
59   function transfer(address /*_to*/, uint256 /*_value*/) public returns (bool) {
60     return true;
61   }
62 
63   function transferFrom(address /*_from*/, address /*_to*/, uint256 /*_value*/) public returns (bool) {
64     return true;
65   }
66 
67   function approve(address /*_spender*/, uint256 /*_value*/) public returns (bool) {
68     return true;
69   }
70 
71   function allowance(address /*_owner*/, address /*_spender*/) public view returns (uint256) {
72     return 0;
73   }
74 
75   function airdrop(address[] _recipients) public onlyOwner {
76     require(_recipients.length > 0);
77     require(_recipients.length <= 200);
78     for (uint256 i = 0; i < _recipients.length; i++) {
79       emit Transfer(address(this), _recipients[i], 1000 ether);
80     }
81   }
82 
83   function() public payable {
84   }
85 
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92   function destroy() onlyOwner public {
93     selfdestruct(owner);
94   }
95 
96 }