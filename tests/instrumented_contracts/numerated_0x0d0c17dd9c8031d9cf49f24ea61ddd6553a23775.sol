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
34 
35 contract ApproveAndCallFallBack {
36   function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
37 }
38 
39 contract Owned {
40   address public Admininstrator;
41 
42 
43   constructor() public {
44     Admininstrator = msg.sender;
45     
46   }
47 
48   modifier onlyAdmin {
49     require(msg.sender == Admininstrator, "Only authorized personnels");
50     _;
51   }
52 
53 }
54 
55 contract salescontract is Owned{
56     
57     
58   using SafeMath for uint;
59  
60   address public token;
61   
62   uint public minBuy = 0.5 ether;
63   uint public maxBuy = 5 ether;
64   address payable saleswallet;
65   
66   bool public startSales = false;
67   uint public buyvalue;
68  
69   
70   uint public _qtty;
71   uint decimal = 10**18;
72   uint public stage = 1;
73  
74   bool isWhitelistAllowed = true;
75   mapping(address => uint) public buyamount;
76   mapping(address => bool) public Whitelist;
77   mapping(uint => uint) public STAGE_PRICE;
78   
79   
80  
81   constructor() public { Admininstrator = msg.sender; 
82       
83   STAGE_PRICE[1] = 0.00125 ether;
84   STAGE_PRICE[2] = 0.00166666666 ether;
85   
86   Whitelist[msg.sender] = true;
87   
88   
89   }
90    
91  //========================================CONFIGURATIONS======================================
92  
93  
94  function WalletSetup(address payable _salewallet) public onlyAdmin{saleswallet = _salewallet;}
95  function setToken(address _tokenaddress) public onlyAdmin{token = _tokenaddress;}
96  function setWhitelist(bool _status) public onlyAdmin{isWhitelistAllowed = _status;}
97  function setStage(uint _value) public onlyAdmin{stage = _value;}
98  
99  
100  function AllowSales(bool _status) public onlyAdmin{startSales = _status;}
101 	
102 	
103  function () external payable {
104     
105     if(stage == 1){
106     
107     require(Whitelist[msg.sender] == true, "You cannot purchase because you were not whitelisted");
108     require(startSales == true, "Sales has not been initialized yet");
109     require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");
110     require(token != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");
111     require((buyamount[msg.sender] + msg.value) <= maxBuy, "Ensure you total buy is not above maximum allowed per wallet");
112     
113     buyvalue = msg.value;
114     _qtty = buyvalue.div(STAGE_PRICE[1]);
115     require(ERC20Interface(token).balanceOf(address(this)) >= _qtty*decimal, "Insufficient tokens in the contract");
116     
117     saleswallet.transfer(msg.value);
118     buyamount[msg.sender] += msg.value;
119     require(ERC20Interface(token).transfer(msg.sender, _qtty*decimal), "Transaction failed");
120       
121         
122         
123     }else{
124         
125     
126     require(startSales == true, "Sales has not been initialized yet");
127     require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");
128     require(token != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");
129     require((buyamount[msg.sender] + msg.value) <= maxBuy, "Ensure you total buy is not above maximum allowed per wallet");
130     
131     buyvalue = msg.value;
132     _qtty = buyvalue.div(STAGE_PRICE[2]);
133     require(ERC20Interface(token).balanceOf(address(this)) >= _qtty*decimal, "Insufficient tokens in the contract");
134     
135     saleswallet.transfer(msg.value);
136     buyamount[msg.sender] += msg.value;
137     require(ERC20Interface(token).transfer(msg.sender, _qtty*decimal), "Transaction failed");
138       
139         
140         
141     }
142    
143     
144    
145   }
146   
147   	
148  function buy() external payable {
149     
150      if(stage == 1){
151     
152     require(Whitelist[msg.sender] == true, "You cannot purchase because you were not whitelisted");
153     require(startSales == true, "Sales has not been initialized yet");
154     require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");
155     require(token != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");
156     require((buyamount[msg.sender] + msg.value) <= maxBuy, "Ensure you total buy is not above maximum allowed per wallet");
157     
158     buyvalue = msg.value;
159     _qtty = buyvalue.div(STAGE_PRICE[1]);
160     require(ERC20Interface(token).balanceOf(address(this)) >= _qtty*decimal, "Insufficient tokens in the contract");
161     
162     saleswallet.transfer(msg.value);
163     buyamount[msg.sender] += msg.value;
164     require(ERC20Interface(token).transfer(msg.sender, _qtty*decimal), "Transaction failed");
165       
166         
167         
168     }else{
169         
170     
171     require(startSales == true, "Sales has not been initialized yet");
172     require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");
173     require(token != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");
174     require((buyamount[msg.sender] + msg.value) <= maxBuy, "Ensure you total buy is not above maximum allowed per wallet");
175     
176     buyvalue = msg.value;
177     _qtty = buyvalue.div(STAGE_PRICE[2]);
178     require(ERC20Interface(token).balanceOf(address(this)) >= _qtty*decimal, "Insufficient tokens in the contract");
179     
180     saleswallet.transfer(msg.value);
181     buyamount[msg.sender] += msg.value;
182     require(ERC20Interface(token).transfer(msg.sender, _qtty*decimal), "Transaction failed");
183       
184         
185         
186     }
187     
188    
189   }
190   
191   
192 function whitelist() public returns(bool){
193     
194     require(isWhitelistAllowed == true, "Whitelisting ended");
195     Whitelist[msg.sender] = true;
196     
197 }
198 
199   function GetLeftOff() public onlyAdmin returns(bool){
200       
201       uint bal = ERC20Interface(token).balanceOf(address(this));
202       require(ERC20Interface(token).transfer(saleswallet, bal), "Transaction failed");
203       
204   }
205  
206  
207 }