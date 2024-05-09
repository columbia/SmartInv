1 pragma solidity ^0.4.13;
2 //date 1500114129 by Ournet International2022649
3 contract tokenGAT {
4         
5         uint256 public totalContribution = 0;
6         uint256 public totalBonusTokensIssued = 0;
7         uint256 public totalSupply = 0;
8         function balanceOf(address _owner) constant returns (uint256 balance);
9         function transfer(address _to, uint256 _value) returns (bool success);
10         function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
11         function approve(address _spender, uint256 _value) returns (bool success);
12         function allowance(address _owner, address _spender) constant returns (uint256 remaining);
13         //events for logging
14         event LogTransaction(address indexed _addres, uint256 value);
15         event Transfer(address indexed _from, address indexed _to, uint256 _value);
16         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17         }
18 
19 /*  ERC 20 token this funtion are also call when somebody or contract want transfer, send, u operate wiht our tokens*/
20 contract StandarTokentokenGAT is tokenGAT{
21 mapping (address => uint256) balances; //asociative array for associate address and its balance like a hashmapp in java
22 mapping (address => uint256 ) weirecives; //asociative array for associate address and its balance like a hashmapp in java
23 mapping (address => mapping (address => uint256)) allowed; // this store addres that are allowed for operate in this contract
24 
25 	
26 function allowance(address _owner, address _spender) constant returns (uint256) {
27     	return allowed[_owner][_spender];
28 }
29 
30 function balanceOf(address _owner) constant returns (uint256 balance) {
31         return balances[_owner];
32 }
33 	
34 function transfer(address _to, uint256 _value) returns (bool success) { 
35    	if(msg.data.length < (2 * 32) + 4) { revert();} 	// mitigates the ERC20 short address attack
36     if (balances[msg.sender] >= _value && _value >= 0){ 
37 		balances[msg.sender] -= _value; //substract balance from user that is transfering (who deploy or who executed it)
38 		balances[_to] += _value;  //add balance from user that is transfering (who deploy or who executed it)
39 		Transfer(msg.sender, _to, _value);    //login
40        	return true;
41      }else
42    		return false;
43      }
44 	
45   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
46      	if(msg.data.length < (3 * 32) + 4) { revert(); } // mitigates the ERC20 short address attack
47        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0){		
48          //add balance to destinate address
49           balances[_to] += _value;
50 		   //substract balance from source address
51         	balances[_from] -= _value;        	
52         	allowed[_from][msg.sender] -= _value;
53 		   //loggin
54         	Transfer(_from, _to, _value);
55         	return true;
56     	} else 
57   			return false;
58 	}
59 //put the addres in allowed mapping	
60  function approve(address _spender, uint256 _value) returns (bool success) {
61    // mitigates the ERC20 spend/approval race condition
62 	if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }    	
63    	allowed[msg.sender][_spender] = _value;    	
64     	Approval(msg.sender, _spender, _value);
65     	return true;
66 	}
67 }
68 
69 contract TokenICOGAT is StandarTokentokenGAT{	
70 	
71 	address owner = msg.sender;
72 	
73 	//Token Metadata
74 	function name() constant returns (string) { return "General Advertising Token"; }
75 	function symbol() constant returns (string) { return "GAT"; }
76 	uint256 public constant decimals = 18;
77 	
78     //ICO Parameters
79 	bool public purchasingAllowed = false;	
80 	address public ethFoundDeposit;      // deposit address for ETH for OurNet International
81 	address public gatFoundDeposit;      // deposit address for Brave International use and OurNet User Fund
82  	uint public deadline; 	//epoch date to end of crowsale
83  	uint public startline; 	//when crowsale start
84 	uint public refundDeadLine;	// peiorode avaible for get refound
85 	uint public transactionCounter;//counter for calcucalate bonus
86  	uint public etherReceived; // Number of Ether received
87  	uint256 public constant gatFund = 250 * (10**6) * 10**decimals;   // 250m GAT reserved for OurNet Intl use, early adopters incentive and ournNet employees team
88  	uint256 public constant tokenExchangeRate = 9000; // 9000 GAT tokens per 1 ETH
89  	uint256 public constant tokenCreationCap =  1000 * (10**6) * 10**decimals; //total of tokens issued
90  	uint256 public constant tokenSellCap =  750 * (10**6) * 10**decimals; //maximun of gat tokens for sell
91 	uint256 public constant tokenSaleMin =  17 * (10**6) * 10**decimals; //minimun goal
92  
93   //constructor or contract	
94  function TokenICOGAT(){
95   startline = now;
96   deadline = startline + 45 * 1 days;
97   refundDeadLine = deadline + 30 days;
98   ethFoundDeposit = owner;
99   gatFoundDeposit = owner;   	 
100   balances[gatFoundDeposit] = gatFund; //deposit fondos for ourNet international 
101   LogTransaction(gatFoundDeposit,gatFund); //login transaction 
102  }
103   
104  function bonusCalculate(uint256 amount) internal returns(uint256){
105  	uint256 amounttmp = 0;
106 	if (transactionCounter > 0 && transactionCounter <= 1000){
107     	return  amount / 2   ;   // bonus 50%
108 	}
109 	if (transactionCounter > 1000 && transactionCounter <= 2000){
110     return	 amount / 5 ;   // bonus 20%
111 	}
112 	if (transactionCounter > 2000 && transactionCounter <= 3000){
113      return	amount / 10;   // bonus 10%
114 	}
115 	if (transactionCounter > 3000 && transactionCounter <= 5000){
116      return	amount / 20;   // bonus 5%
117 	}
118  	return amounttmp;
119 	}	  
120 	
121 	function enablePurchasing() {
122    	if (msg.sender != owner) { revert(); }
123 		if(purchasingAllowed) {revert();}
124 		purchasingAllowed = true;	
125    	}
126 	
127 	function disablePurchasing() {
128     	if (msg.sender != owner) { revert(); }
129 	if(!purchasingAllowed) {revert();}		
130     	purchasingAllowed = false;		
131 	}
132 	
133     function getStats() constant returns (uint256, uint256, uint256, bool) {
134     	return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
135 	}
136 		
137 	// recive ethers funtion witout name is call every some body send ether
138 	function() payable {
139     	if (!purchasingAllowed) { revert(); }   
140         if ((tokenCreationCap - (totalSupply + gatFund)) <= 0) { revert();}  
141     	if (msg.value == 0) { return; }
142 	transactionCounter +=1;
143     	totalContribution += msg.value;
144     	uint256 bonusGiven = bonusCalculate(msg.value);
145         // Number of GAT sent to Ether contributors
146     	uint256 tokensIssued = (msg.value * tokenExchangeRate) + (bonusGiven * tokenExchangeRate);
147     	totalBonusTokensIssued += bonusGiven;
148     	totalSupply += tokensIssued;
149     	balances[msg.sender] += tokensIssued;  
150 	weirecives[msg.sender] += msg.value; // it is import for calculate refund witout token bonus
151     	Transfer(address(this), msg.sender, tokensIssued);
152    }
153 		
154       
155 	// send excess of tokens when de ico end
156 	function sendSurplusTokens() {
157     	if (purchasingAllowed) { revert(); } 	
158      	if (msg.sender != owner) { revert();}
159     	uint256 excess = tokenCreationCap - (totalSupply + gatFund);
160 	if(excess <= 0){revert();}
161     	balances[gatFoundDeposit] += excess;  	
162     	Transfer(address(this), gatFoundDeposit, excess);
163    }
164 	
165 	function withdrawEtherHomeExternal() external{//Regarding security issues the first option is save ether in a online wallet, but if some bad happens, we will use local wallet as contingency plan
166 		if(purchasingAllowed){revert();}
167 		if (msg.sender != owner) { revert();}
168 		ethFoundDeposit.transfer(this.balance); //send ether home		
169 	}
170 	
171 	function withdrawEtherHomeLocal(address _ethHome) external{ // continegency plan
172 		if(purchasingAllowed){revert();}
173 		if (msg.sender != owner) { revert();}
174 		_ethHome.transfer(this.balance); //send ether home		
175 	}
176 	
177 	/* 
178      * When tokenSaleMin is not reach:
179      * 1) donors call the "refund" function of the GATCrowdFundingToken contract 
180 	 */
181 	function refund() public {
182 	if(purchasingAllowed){revert();} // only refund after ico end
183 	if(now >= refundDeadLine ){revert();} // only refund are available before ico end + 30 days
184 	if((totalSupply - totalBonusTokensIssued) >= tokenSaleMin){revert();} // if we sould enough, no refund allow
185 	if(msg.sender == ethFoundDeposit){revert();}	// OurNet not entitled to a refund
186 	uint256 gatVal= balances[msg.sender]; // get balance of who is getting from balances mapping
187 	if(gatVal <=0) {revert();} //if dont have balnace sent no refund
188 	// balances[msg.sender] = 0;//since donor can hold the tokes as souvenir do not update balance of who is getting refund in gatcontract
189         uint256 ethVal = weirecives[msg.sender]; //extract amount contribuited by sender without tokenbonus        
190 	LogTransaction(msg.sender,ethVal);//loggin transaction
191 	msg.sender.transfer(ethVal);// send ether comeback	
192         totalContribution -= ethVal;
193         weirecives[msg.sender] -= ethVal; // getrefound from weirecives
194 	}
195 }