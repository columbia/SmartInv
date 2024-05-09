1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {  owner = msg.sender;  }
7     modifier onlyOwner {  require (msg.sender == owner);    _;   }
8     function transferOwnership(address newOwner) onlyOwner public{  owner = newOwner;  }
9 }
10 
11 contract token is owned{
12     string public name; 
13     string public symbol; 
14     uint8 public decimals = 10;  
15     uint256 public totalSupply; 
16 
17     mapping (address => uint256) public balanceOf;
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);  
20     event Burn(address indexed from, uint256 value);  
21     
22     function token(uint256 initialSupply, string tokenName, string tokenSymbol) public {
23 
24         totalSupply = initialSupply * 10 ** uint256(decimals);  
25         
26         balanceOf[msg.sender] = totalSupply; 
27 
28         name = tokenName;
29         symbol = tokenSymbol;
30 
31     }
32 
33     function _transfer(address _from, address _to, uint256 _value) internal {
34 
35       require(_to != 0x0); 
36       require(balanceOf[_from] >= _value); 
37       require(balanceOf[_to] + _value > balanceOf[_to]); 
38       
39       uint previousBalances = balanceOf[_from] + balanceOf[_to]; 
40       balanceOf[_from] -= _value; 
41       balanceOf[_to] += _value; 
42       emit Transfer(_from, _to, _value); 
43       assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
44 
45     }
46 
47     function transfer(address _to, uint256 _value) public {   _transfer(msg.sender, _to, _value);   }
48 
49     function burn(uint256 _value) public onlyOwner returns (bool success) {
50         
51         require(balanceOf[msg.sender] >= _value);   
52 
53 		balanceOf[msg.sender] -= _value; 
54         totalSupply -= _value; 
55         emit Burn(msg.sender, _value);
56         return true;
57     }
58 }
59 
60 contract MyAdvancedToken is token {
61 
62     uint256 public buyPrice; 
63     uint public amountTotal =0; 
64 	uint public amountRaised=0;
65 	bool public crowdFunding = false;  
66     uint public deadline = 0; 
67     uint public fundingGoal = 0;  
68 
69 	mapping (address => bool) public frozenAccount; 
70     
71     event FrozenFunds(address target, bool frozen); 
72 	event FundTransfer(address _backer, uint _amount, bool _isContribution); 
73 
74     function MyAdvancedToken(uint256 initialSupply, string tokenName, string tokenSymbol) public token (initialSupply, tokenName, tokenSymbol) {
75         buyPrice  = 10000; 
76     }
77 
78     function _transfer(address _from, address _to, uint _value) internal {
79         require (_to != 0x0); 
80         require (balanceOf[_from] > _value); 
81         require (balanceOf[_to] + _value > balanceOf[_to]); 
82         require(!frozenAccount[_from]); 
83         require(!frozenAccount[_to]);
84         
85         balanceOf[_from] -= _value; 
86         balanceOf[_to] += _value; 
87         emit Transfer(_from, _to, _value); 
88     }
89 
90     function freezeAccount(address target, bool freeze) public onlyOwner {
91         frozenAccount[target] = freeze;
92         emit FrozenFunds(target, freeze);
93     }
94 
95     function setPrices(uint256 newBuyPrice) public onlyOwner {
96         buyPrice = newBuyPrice;
97     }
98    function () payable public {
99 	  require (crowdFunding == true);
100 	  check_status();
101 	  require (crowdFunding == true);
102 	  uint amount = msg.value* buyPrice;
103 	  _transfer(owner, msg.sender, amount);
104 	  amountTotal += msg.value;
105 	  amountRaised += msg.value;
106       //emit FundTransfer(msg.sender, amount, true);
107     }
108 
109 	function check_status() internal {
110 	  if (deadline >0 && now >= deadline)
111 		  crowdFunding = false;
112 	  if( fundingGoal >0 && amountRaised > fundingGoal )
113 		  crowdFunding = false;
114 
115 	  if( crowdFunding == false ){
116 	      deadline = 0;
117 		  fundingGoal = 0;
118 		  amountRaised = 0;
119 	  }
120 	}
121 
122 	function openCrowdFunding(bool bOpen,uint totalEth, uint durationInMinutes) public  onlyOwner {
123 	    deadline = 0;
124 	    fundingGoal = 0;
125 	    amountRaised = 0;
126 		
127 		crowdFunding = bOpen;
128 
129 		if(totalEth >0){
130 			fundingGoal = totalEth;
131 		}
132 		if(durationInMinutes >0)
133 			deadline = now + durationInMinutes * 1 minutes;
134 	}
135 	
136     function getEth() public  onlyOwner { //ok
137 		require( amountTotal >= 100 );
138         uint256 amt = amountTotal-100;
139         owner.transfer(amt);
140         emit FundTransfer(owner, amt, false);
141 		amountTotal = 100;
142     }
143 }