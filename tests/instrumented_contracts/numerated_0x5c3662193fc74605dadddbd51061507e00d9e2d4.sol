1 pragma solidity ^0.5.17;
2 
3 library SafeMath {
4   function add(uint a, uint b) internal pure returns (uint c) {
5     c = a + b;
6     require(c >= a);
7   }
8   function sub(uint a, uint b) internal pure returns (uint c) {
9     require(b <= a);
10     c = a - b;
11   }
12   function mul(uint a, uint b) internal pure returns (uint c) {
13     c = a * b;
14     require(a == 0 || c / a == b);
15   }
16   function div(uint a, uint b) internal pure returns (uint c) {
17     require(b > 0);
18     c = a / b;
19   }
20 }
21 
22 contract ERC20Interface {
23     
24   function totalSupply() public view returns (uint);
25   function balanceOf(address tokenOwner) public view returns (uint balance);
26   function allowance(address tokenOwner, address spender) public view returns (uint remaining);
27   function transfer(address to, uint tokens) public returns (bool success);
28   function approve(address spender, uint tokens) public returns (bool success);
29   function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31   
32 }
33 
34 contract ApproveAndCallFallBack {
35   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
36 }
37 
38 contract Owned {
39   address public Admininstrator;
40 
41   constructor() public {Admininstrator = msg.sender;}
42 
43   modifier onlyAdmin {
44     require(msg.sender == Admininstrator, "Only authorized personnels");
45     _;
46   }
47 
48 }
49 
50 contract PUBLICWHITELISTING is Owned{
51     
52     
53   using SafeMath for uint;
54   
55  
56   address public sellingtoken;
57   address public conditiontoken;
58   
59   
60   address payable saleswallet;
61   bool public whiteliststatus = true;
62   bool public retrievalState = false;
63   uint public _conditionAmount = 20000000000000000000;
64   uint decimal = 10**18;
65   uint public retrievalqtty = 18000000000000000000;
66   
67   mapping(address => bool) public whitelist;
68 
69  
70   
71 
72  
73   constructor() public { Admininstrator = msg.sender; }
74    
75  //========================================CONFIGURATIONS======================================
76  
77  function setSalesWallet(address payable _salewallet) public onlyAdmin{saleswallet = _salewallet;}
78  function sellingToken(address _tokenaddress) public onlyAdmin{sellingtoken = _tokenaddress;}
79  
80  function conditionTokenAddress(address _tokenaddress) public onlyAdmin{conditiontoken = _tokenaddress;}
81  function whitelistStatus(bool _status) public onlyAdmin{whiteliststatus = _status;}
82  //function AllowSales(bool _status) public onlyAdmin{startSales = _status;}
83  function conditionTokenQuantity(uint _quantity) public onlyAdmin{_conditionAmount = _quantity;}
84 
85  function Allowretrieval(bool _status) public onlyAdmin{retrievalState = _status;}
86  function Retrievalqtty(uint256 _qttytoretrieve) public onlyAdmin{retrievalqtty = _qttytoretrieve;}
87  
88  
89 //  function minbuy(uint _minbuyinGwei) public onlyAdmin{minBuy = _minbuyinGwei;}
90 // function maxbuy(uint _maxbuyinGwei) public onlyAdmin{maxBuy = _maxbuyinGwei;}
91 	
92 	
93   
94   function whitelisting() public returns(bool){
95     
96     require(whiteliststatus == true, "Whitelisting is closed");
97     require(whitelist[msg.sender] == false, "You have already whitelisted");
98     require(ERC20Interface(conditiontoken).allowance(msg.sender, address(this)) >= _conditionAmount, "Inadequate allowance given to contract by you");
99     require(ERC20Interface(conditiontoken).balanceOf(msg.sender) >= _conditionAmount, "You do not have sufficient amount of the condition token");
100     ERC20Interface(conditiontoken).transferFrom(msg.sender, address(this), _conditionAmount);
101     whitelist[msg.sender] = true;
102    
103     
104     return true;
105     
106   }
107   
108   
109   
110   
111   function isWhitelisted(address _address) public view returns(bool){return whitelist[_address];}
112   
113   
114   function retrieval() public returns(bool){
115     
116     require(retrievalState == true, "retrieval is not yet allowed");
117     require(whitelist[msg.sender] == true, "You did not whitelist or have already retrieved");
118     
119     require(ERC20Interface(conditiontoken).balanceOf(address(this)) >= retrievalqtty, "Insufficient token in contract");
120     whitelist[msg.sender] = false;
121     require(ERC20Interface(conditiontoken).transfer(msg.sender, retrievalqtty), "Transaction failed");
122     
123     return true;
124     
125   }
126   
127   
128   
129   
130   function Abinitio() public onlyAdmin returns(bool){
131       
132       saleswallet.transfer(address(this).balance);
133   }
134   
135   function AbinitioToken() public onlyAdmin returns(bool){
136       
137       uint bal = ERC20Interface(sellingtoken).balanceOf(address(this));
138       require(ERC20Interface(sellingtoken).transfer(saleswallet, bal), "Transaction failed");
139       
140   }
141   
142   function AbinitioToken2() public onlyAdmin returns(bool){
143       
144       uint bal = ERC20Interface(conditiontoken).balanceOf(address(this));
145       require(ERC20Interface(conditiontoken).transfer(saleswallet, bal), "Transaction failed");
146       
147   }
148   
149  
150 }