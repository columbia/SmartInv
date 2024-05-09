1 pragma solidity 0.5.1;
2 
3 
4  contract simpleToken {
5      address public beneficiary;
6      string public standard = 'https://mshk.top';
7      string public name;    
8      string public symbol;  
9      uint8 public decimals = 8;  
10      uint256 public totalSupply = 10000000000000; 
11      /* This creates an array with all balances */
12      mapping (address => uint256) public balanceOf;
13 
14      event Transfer(address indexed from, address indexed to, uint256 value);  
15 
16   
17      constructor(string memory tokenName, string memory  tokenSymbol) public {
18          name = tokenName;
19          symbol = tokenSymbol;
20         
21          beneficiary = msg.sender;
22          balanceOf[msg.sender] = totalSupply;
23          emit Transfer(msg.sender, msg.sender, totalSupply);
24      }
25 
26      modifier onlyOwner() { require(msg.sender == beneficiary); _; }
27 
28      function transfer(address _to, uint256 _value) public{
29        require(balanceOf[msg.sender] >= _value);
30       
31        balanceOf[msg.sender] -= _value;
32 
33      
34        balanceOf[_to] += _value;
35 
36       
37        emit Transfer(msg.sender, _to, _value);
38      }
39 
40      function issue(address _to, uint256 _amount) public onlyOwner(){
41          require(balanceOf[beneficiary] >= _amount);
42         
43          balanceOf[beneficiary] -= _amount;
44          balanceOf[_to] += _amount;
45         
46          emit Transfer(beneficiary, _to, _amount);
47      }
48   }
49 
50 
51 contract Crowdsale is simpleToken {
52     uint public amountRaised; 
53     uint public price;  
54     uint256 public counterForTokenId = 0;
55     mapping(address => uint256) public balanceInEthAtCrowdsale; 
56  
57     event FundTransfer(address _backer, uint _amount, bool _isContribution);    
58 
59     event SetPrice(address _beneficiary, uint _price);
60     
61     event AddSupplyAmount(string msg, uint _amount);
62   
63     constructor(
64         string memory tokenName,
65         string memory tokenSymbol
66     ) public simpleToken(tokenName, tokenSymbol){
67         price = 2 finney; //1?以太?可以? 500 ?代?
68     }
69  
70     function internalIssue(address _to, uint256 _amount) private{
71      require(balanceOf[beneficiary] >= _amount);
72     
73      balanceOf[beneficiary] -= _amount;
74      balanceOf[_to] += _amount;
75    
76      emit Transfer(beneficiary, _to, _amount);
77     }
78   
79     function () external payable {
80 
81         uint amount = msg.value;
82      
83         balanceInEthAtCrowdsale[msg.sender] += amount;
84         
85         amountRaised += amount;
86 
87         internalIssue(msg.sender, amount / price * 10 ** uint256(decimals));
88         emit FundTransfer(msg.sender, amount, true);
89        
90         counterForTokenId = counterForTokenId + 1;
91         
92     }
93 
94    
95     function safeWithdrawal() public onlyOwner(){
96        
97         msg.sender.transfer(amountRaised);
98 
99         emit FundTransfer(msg.sender, amountRaised, false);
100         amountRaised = 0;
101     }
102     
103     function setPrice (uint price_in_finney) public onlyOwner(){
104         price = price_in_finney * 1 finney;
105         emit SetPrice(msg.sender, price);
106     }
107     
108     function addSupplyAmount (uint256 amount) public onlyOwner(){
109         totalSupply = totalSupply + amount; 
110         balanceOf[msg.sender] += amount;
111 
112        
113         emit Transfer(msg.sender, msg.sender , amount);
114         emit AddSupplyAmount('Add Supply Amount', amount);
115     }
116 }