1 pragma solidity ^0.4.15;
2 
3 contract ERC20 {
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6   function transferFrom(address from, address to, uint256 value) public returns (bool);
7   function approve(address spender, uint256 value) public returns (bool);
8   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
9   event Approval(address indexed owner, address indexed spender, uint256 value);
10 }
11 
12 library SafeMath {
13   function mul(uint256 a, uint256 b) pure internal returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18   function div(uint256 a, uint256 b) pure internal returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22   function sub(uint256 a, uint256 b) pure internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26   function add(uint256 a, uint256 b) pure internal returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36   function Ownable() public {
37     owner = msg.sender;
38   }
39  
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44  
45   function transferOwnership(address newOwner) onlyOwner public {
46     require(newOwner != address(0));      
47     owner = newOwner;
48   }
49 }
50 
51 interface tokenRecipient { 
52   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
53 }
54 
55 contract LCBrixToken is ERC20, Ownable {
56   using SafeMath for uint256;
57 
58   string constant public name = "LikeCoin Brix";
59   string constant public symbol = "LCB";
60   uint8 constant public decimals = 6;
61   uint256 public totalSupply = 2000000000000;//2000000.000000
62   string constant public oferta = "LCbrix. OFFER TO THE BUYERS. Definitions. The Likecoin system - is a system of software products, and of the legal rights and subjects, associated with them, all together collectively supporting the activities of the Likecoin social network. The contract is an agreement in the form of acceptance of this offer. The Holding Company is Lightport Inter Limited, Hong Kong, which now and in the future owns all legal entities of the Likecoin system, as well as directly or indirectly the rights to all software products of the Likecoin system. The Agent Company is “Solai Tech Finance” LLP, Kazakhstan, which executes contracts in the name and on behalf of the Holding Company. Token - a record of the owner of the contract in the register of contract holders, executed in the Ethereum blockchain. OFFER 1) This offer is a crowdfunding contract, whereby the owner of the contract carries all the risks associated with the successful or unsuccessful development of the project, similarly to the shareholders of the project. Shareholders of the project do not have special obligations to support the liquidity of contracts. 2) The owner of this contract has the right to receive one share of the Holding Company in the period not earlier than indicated in paragraph 3 hereof. The owner of the contract has the right, at its discretion, to extend the term of exchange of the contract for the share. 3) The Holding Company undertakes to make share issue for its capital before May 1, 2020. The Holding Company undertakes to reserve 20% of its shares for exchange on these contracts. 4) To maintain the register of contracts, the Likecoin system issues 2,000,000 tokens in the Ethereum blockchain. Owning one token means owning a contract for receipt in the future of one future share of the Holding Company. 5) The owner of the contract can sell the contract, divide into shares, pledge, grant for free. All actions with contracts are conducted in the registry, which is available for access by both the Likecoin system and the Ethereum blockchain. When dividing a token, the right of exchange for the shares of the Holding Company arises only for that owner of the parts (portions) of the tokens, whereas such parts together constitute the whole number of tokens (integer). 6) The Holding Company undertakes to use all funds raised during the initial sale of contracts for the development of the Likecoin system. Holding Company will be 100% owner of all newly created operating companies of the Likecoin system. 7) In case of exchange of the contract for the share, the relevant token will be placed on a special blocked account and will not be traded in the future. 8) Settlements with contract holders in the name and on behalf of the Holding Company are carried out by the Agent Company.";
63   mapping (address => mapping (address => uint256)) public allowance;
64   mapping (address => uint256) public balanceOf;
65   
66 
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
69     balanceOf[_to] = balanceOf[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75     var _allowance = allowance[_from][msg.sender];
76     balanceOf[_to] = balanceOf[_to].add(_value);
77     balanceOf[_from] = balanceOf[_from].sub(_value);
78     allowance[_from][msg.sender] = _allowance.sub(_value);
79     Transfer(_from, _to, _value);
80     return true;
81   }
82 
83   function approve(address _spender, uint256 _value) public returns (bool) {
84     allowance[msg.sender][_spender] = _value;
85     Approval(msg.sender, _spender, _value);
86     return true;
87   }
88 
89   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
90     tokenRecipient spender = tokenRecipient(_spender);
91     if (approve(_spender, _value)) {
92       spender.receiveApproval(msg.sender, _value, this, _extraData);
93       return true;
94     }
95   }
96 
97   function LCBrixToken() public {
98     balanceOf[owner] = totalSupply;
99   }
100 
101   event TransferWithRef(address indexed _from, address indexed _to, uint256 _value, uint256 indexed ref);
102 
103   function transferWithRef(address _to, uint _value, uint256 _ref) public returns (bool success) {
104     bool result = transfer(_to, _value);
105     if (result)	
106       TransferWithRef(msg.sender, _to, _value, _ref);
107     return result;	
108   }
109 }
110 
111 contract LCBrixTokenCrowdsale is tokenRecipient {
112   using SafeMath for uint256;  
113   address public beneficiary = 0x8399a0673487150f7C5D22b88546EC991814aB03;
114   LCBrixToken public token = LCBrixToken(0xC257bF0a9D24A62a12898dcdeD755196D20FAc17);
115   uint256 public tokenPrice = 0.00375 ether;
116   uint256 public deadline = 1518652800; //2018-02-15 00:00:00 GMT
117   uint256 public goalInEthers = 1000 ether;
118   uint256 public amountRaised = 0;
119   mapping (address => uint256) public balanceOf;
120   mapping (address => uint256) public tokenBalanceOf;
121   bool public crowdsaleClosed = false;
122   bool public goalReached = false;
123   string constant public oferta = "LCbrix. OFFER TO THE BUYERS. Definitions. The Likecoin system - is a system of software products, and of the legal rights and subjects, associated with them, all together collectively supporting the activities of the Likecoin social network. The contract is an agreement in the form of acceptance of this offer. The Holding Company is Lightport Inter Limited, Hong Kong, which now and in the future owns all legal entities of the Likecoin system, as well as directly or indirectly the rights to all software products of the Likecoin system. The Agent Company is “Solai Tech Finance” LLP, Kazakhstan, which executes contracts in the name and on behalf of the Holding Company. Token - a record of the owner of the contract in the register of contract holders, executed in the Ethereum blockchain. OFFER 1) This offer is a crowdfunding contract, whereby the owner of the contract carries all the risks associated with the successful or unsuccessful development of the project, similarly to the shareholders of the project. Shareholders of the project do not have special obligations to support the liquidity of contracts. 2) The owner of this contract has the right to receive one share of the Holding Company in the period not earlier than indicated in paragraph 3 hereof. The owner of the contract has the right, at its discretion, to extend the term of exchange of the contract for the share. 3) The Holding Company undertakes to make share issue for its capital before May 1, 2020. The Holding Company undertakes to reserve 20% of its shares for exchange on these contracts. 4) To maintain the register of contracts, the Likecoin system issues 2,000,000 tokens in the Ethereum blockchain. Owning one token means owning a contract for receipt in the future of one future share of the Holding Company. 5) The owner of the contract can sell the contract, divide into shares, pledge, grant for free. All actions with contracts are conducted in the registry, which is available for access by both the Likecoin system and the Ethereum blockchain. When dividing a token, the right of exchange for the shares of the Holding Company arises only for that owner of the parts (portions) of the tokens, whereas such parts together constitute the whole number of tokens (integer). 6) The Holding Company undertakes to use all funds raised during the initial sale of contracts for the development of the Likecoin system. Holding Company will be 100% owner of all newly created operating companies of the Likecoin system. 7) In case of exchange of the contract for the share, the relevant token will be placed on a special blocked account and will not be traded in the future. 8) Settlements with contract holders in the name and on behalf of the Holding Company are carried out by the Agent Company.";
124   event FundTransfer(address backer, uint amount, bool isContribution);
125 
126   function recalcFlags() public {
127     if (block.timestamp >= deadline || token.balanceOf(this) <= 0)
128       crowdsaleClosed = true;
129     if (amountRaised >= goalInEthers) 
130       goalReached = true;
131   }
132   
133   function recalcTokenPrice() public {
134     uint256 tokensLeft = token.balanceOf(this);    
135     if (tokensLeft <=  400000000000)
136       tokenPrice = 0.00500 ether;
137     else
138     if (tokensLeft <= 1200000000000)
139       tokenPrice = 0.00438 ether;
140   }
141 
142   function () payable public {
143     require(!crowdsaleClosed);
144     uint256 amount = msg.value;
145     uint256 tokenAmount = amount.mul(1000000); 
146     tokenAmount = tokenAmount.div(tokenPrice);
147     require(token.balanceOf(this) >= tokenAmount);
148     amountRaised = amountRaised.add(amount);
149     balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
150     tokenBalanceOf[msg.sender] = tokenBalanceOf[msg.sender].add(tokenAmount);
151     FundTransfer(msg.sender, amount, true);
152     token.transfer(msg.sender, tokenAmount);
153     recalcTokenPrice();
154   }
155 
156   function transferRemainingTokens() public {
157     require(crowdsaleClosed);
158     require(msg.sender == beneficiary);  
159     token.transfer(beneficiary, token.balanceOf(this));
160   }
161 
162   function transferGainedEther() public {
163     require(goalReached); 
164     require(msg.sender == beneficiary);  
165     if (beneficiary.send(this.balance)) {
166       FundTransfer(beneficiary, this.balance, false);
167     }
168   }
169 
170   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
171     _extraData = "";
172     require(crowdsaleClosed && !goalReached);
173     uint256 amount = balanceOf[_from];
174     uint256 tokenAmount = tokenBalanceOf[_from];	
175     require(token == _token && tokenAmount == _value && tokenAmount == token.balanceOf(_from) && amount >0);
176     token.transferFrom(_from, this, tokenAmount);
177     _from.transfer(amount);
178     balanceOf[_from] = 0;
179     tokenBalanceOf[_from] = 0;
180     FundTransfer(_from, amount, false);
181   }
182 
183 }