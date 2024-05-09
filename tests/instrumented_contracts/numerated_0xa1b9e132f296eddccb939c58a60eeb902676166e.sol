1 pragma solidity ^0.4.18;
2  
3 contract Token {
4     string public symbol = "";
5     string public name = "";
6     uint8 public constant decimals = 18;
7 	string public constant ICOFactoryVersion = "1.0";
8     uint256 _totalSupply = 0;
9 	uint256 _oneEtherEqualsInWei = 0;	
10 	uint256 _maxICOpublicSupply = 0;
11 	uint256 _ownerICOsupply = 0;
12 	uint256 _currentICOpublicSupply = 0;
13 	uint256 _blockICOdatetime = 0;
14 	address _ICOfundsReceiverAddress = 0;
15 	address _remainingTokensReceiverAddress = 0;
16     address owner = 0;	
17     bool setupDone = false;
18 	bool isICOrunning = false;
19 	bool ICOstarted = false;
20 	uint256 ICOoverTimestamp = 0;
21    
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 	event Burn(address indexed _owner, uint256 _value);
25  
26     mapping(address => uint256) balances;
27  
28     mapping(address => mapping (address => uint256)) allowed;
29  
30     function Token(address adr) public {
31         owner = adr;        
32     }
33 	
34 	function() public payable
35 	{
36 		if ((isICOrunning && _blockICOdatetime == 0) || (isICOrunning && _blockICOdatetime > 0 && now <= _blockICOdatetime))
37 		{
38 			uint256 _amount = ((msg.value * _oneEtherEqualsInWei) / 1000000000000000000);
39 			
40 			if (((_currentICOpublicSupply + _amount) > _maxICOpublicSupply) && _maxICOpublicSupply > 0) revert();
41 			
42 			if(!_ICOfundsReceiverAddress.send(msg.value)) revert();					
43 			
44 			_currentICOpublicSupply += _amount;
45 			
46 			balances[msg.sender] += _amount;
47 			
48 			_totalSupply += _amount;			
49 			
50 			Transfer(this, msg.sender, _amount);
51 		}
52 		else
53 		{
54 			revert();
55 		}
56 	}
57    
58     function SetupToken(string tokenName, string tokenSymbol, uint256 oneEtherEqualsInWei, uint256 maxICOpublicSupply, uint256 ownerICOsupply, address remainingTokensReceiverAddress, address ICOfundsReceiverAddress, uint256 blockICOdatetime) public
59     {
60         if (msg.sender == owner && !setupDone)
61         {
62             symbol = tokenSymbol;
63             name = tokenName;
64 			_oneEtherEqualsInWei = oneEtherEqualsInWei;
65 			_maxICOpublicSupply = maxICOpublicSupply * 1000000000000000000;									
66 			if (ownerICOsupply > 0)
67 			{
68 				_ownerICOsupply = ownerICOsupply * 1000000000000000000;
69 				_totalSupply = _ownerICOsupply;
70 				balances[owner] = _totalSupply;
71 				Transfer(this, owner, _totalSupply);
72 			}			
73 			_ICOfundsReceiverAddress = ICOfundsReceiverAddress;
74 			if (_ICOfundsReceiverAddress == 0) _ICOfundsReceiverAddress = owner;
75 			_remainingTokensReceiverAddress = remainingTokensReceiverAddress;
76 			_blockICOdatetime = blockICOdatetime;			
77             setupDone = true;
78         }
79     }
80 	
81 	function StartICO() public returns (bool success)
82     {
83         if (msg.sender == owner && !ICOstarted && setupDone)
84         {
85             ICOstarted = true;			
86 			isICOrunning = true;			
87         }
88 		else
89 		{
90 			revert();
91 		}
92 		return true;
93     }
94 	
95 	function StopICO() public returns (bool success)
96     {
97         if (msg.sender == owner && isICOrunning)
98         {            
99 			if (_remainingTokensReceiverAddress != 0 && _maxICOpublicSupply > 0)
100 			{
101 				uint256 _remainingAmount = _maxICOpublicSupply - _currentICOpublicSupply;
102 				if (_remainingAmount > 0)
103 				{
104 					balances[_remainingTokensReceiverAddress] += _remainingAmount;
105 					_totalSupply += _remainingAmount;
106 					Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);	
107 				}
108 			}				
109 			isICOrunning = false;	
110 			ICOoverTimestamp = now;
111         }
112 		else
113 		{
114 			revert();
115 		}
116 		return true;
117     }
118 	
119 	function BurnTokens(uint256 amountInWei) public returns (bool success)
120     {
121 		if (balances[msg.sender] >= amountInWei)
122 		{
123 			balances[msg.sender] -= amountInWei;
124 			_totalSupply -= amountInWei;
125 			Burn(msg.sender, amountInWei);
126 			Transfer(msg.sender, 0, amountInWei);
127 		}
128 		else
129 		{
130 			revert();
131 		}
132 		return true;
133     }
134  
135     function totalSupply() public constant returns (uint256 totalSupplyValue) {        
136         return _totalSupply;
137     }
138 	
139 	function OneEtherEqualsInWei() public constant returns (uint256 oneEtherEqualsInWei) {        
140         return _oneEtherEqualsInWei;
141     }
142 	
143 	function MaxICOpublicSupply() public constant returns (uint256 maxICOpublicSupply) {        
144         return _maxICOpublicSupply;
145     }
146 	
147 	function OwnerICOsupply() public constant returns (uint256 ownerICOsupply) {        
148         return _ownerICOsupply;
149     }
150 	
151 	function CurrentICOpublicSupply() public constant returns (uint256 currentICOpublicSupply) {        
152         return _currentICOpublicSupply;
153     }
154 	
155 	function RemainingTokensReceiverAddress() public constant returns (address remainingTokensReceiverAddress) {        
156         return _remainingTokensReceiverAddress;
157     }
158 	
159 	function ICOfundsReceiverAddress() public constant returns (address ICOfundsReceiver) {        
160         return _ICOfundsReceiverAddress;
161     }
162 	
163 	function Owner() public constant returns (address ownerAddress) {        
164         return owner;
165     }
166 	
167 	function SetupDone() public constant returns (bool setupDoneFlag) {        
168         return setupDone;
169     }
170     
171 	function IsICOrunning() public constant returns (bool isICOrunningFalg) {        
172         return isICOrunning;
173     }
174 	
175 	function IsICOstarted() public constant returns (bool isICOstartedFlag) {        
176         return ICOstarted;
177     }
178 	
179 	function ICOoverTimeStamp() public constant returns (uint256 ICOoverTimestampCheck) {        
180         return ICOoverTimestamp;
181     }
182 	
183 	function BlockICOdatetime() public constant returns (uint256 blockStopICOdate) {        
184         return _blockICOdatetime;
185     }
186 	
187 	function TimeNow() public constant returns (uint256 timenow) {        
188         return now;
189     }
190 	 
191     function balanceOf(address _owner) public constant returns (uint256 balance) {
192         return balances[_owner];
193     }
194  
195     function transfer(address _to, uint256 _amount) public returns (bool success) {
196         if (balances[msg.sender] >= _amount
197             && _amount > 0
198             && balances[_to] + _amount > balances[_to]) {
199             balances[msg.sender] -= _amount;
200             balances[_to] += _amount;
201             Transfer(msg.sender, _to, _amount);
202             return true;
203         } else {
204             return false;
205         }
206     }
207  
208     function transferFrom(
209         address _from,
210         address _to,
211         uint256 _amount
212     ) public returns (bool success) {
213         if (balances[_from] >= _amount
214             && allowed[_from][msg.sender] >= _amount
215             && _amount > 0
216             && balances[_to] + _amount > balances[_to]) {
217             balances[_from] -= _amount;
218             allowed[_from][msg.sender] -= _amount;
219             balances[_to] += _amount;
220             Transfer(_from, _to, _amount);
221             return true;
222         } else {
223             return false;
224         }
225     }
226  
227     function approve(address _spender, uint256 _amount) public returns (bool success) {
228         allowed[msg.sender][_spender] = _amount;
229         Approval(msg.sender, _spender, _amount);
230         return true;
231     }
232  
233     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
234         return allowed[_owner][_spender];
235     }
236 }