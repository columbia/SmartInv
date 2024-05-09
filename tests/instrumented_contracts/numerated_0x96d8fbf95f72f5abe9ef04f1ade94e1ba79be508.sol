1 pragma solidity ^0.4.18;
2 
3 pragma solidity ^0.4.18;
4 
5 contract EtherealFoundationOwned {
6 	address private Owner;
7     
8 	function IsOwner(address addr) view public returns(bool)
9 	{
10 	    return Owner == addr;
11 	}
12 	
13 	function TransferOwner(address newOwner) public onlyOwner
14 	{
15 	    Owner = newOwner;
16 	}
17 	
18 	function EtherealFoundationOwned() public
19 	{
20 	    Owner = msg.sender;
21 	}
22 	
23 	function Terminate() public onlyOwner
24 	{
25 	    selfdestruct(Owner);
26 	}
27 	
28 	modifier onlyOwner(){
29         require(msg.sender == Owner);
30         _;
31     }
32 }
33 
34 contract GiftzNetworkToken is EtherealFoundationOwned {
35     string public constant CONTRACT_NAME = "GiftzNetworkToken";
36     string public constant CONTRACT_VERSION = "A";
37     
38     string public constant name = "itCoin® Black";
39     string public constant symbol = "ITC";
40     uint256 public constant decimals = 18;  // 18 is the most common number of decimal places
41     bool private tradeable;
42     uint256 private currentSupply;
43     mapping(address => uint256) private balances;
44     mapping(address => mapping(address=> uint256)) private allowed;
45     mapping(address => bool) private lockedAccounts;  
46 	
47 	/*
48 		Incomming Ether
49 	*/	
50     event RecievedEth(address indexed _from, uint256 _value);
51 	//this is the fallback
52 	function () payable public {
53 		RecievedEth(msg.sender, msg.value);		
54 	}
55 	
56 	event TransferedEth(address indexed _to, uint256 _value);
57 	function FoundationTransfer(address _to, uint256 amtEth, uint256 amtToken) public onlyOwner
58 	{
59 		require(this.balance >= amtEth && balances[this] >= amtToken );
60 		
61 		if(amtEth >0)
62 		{
63 			_to.transfer(amtEth);
64 			TransferedEth(_to, amtEth);
65 		}
66 		
67 		if(amtToken > 0)
68 		{
69 			require(balances[_to] + amtToken > balances[_to]);
70 			balances[this] -= amtToken;
71 			balances[_to] += amtToken;
72 			Transfer(this, _to, amtToken);
73 		}
74 		
75 		
76 	}	
77 	/*
78 		End Incomming Ether
79 	*/
80 	
81 	
82 	
83     function GiftzNetworkToken(
84 		uint256 initialTotalSupply, 
85 		address[] addresses, 
86 		uint256[] initialBalances, 
87 		bool initialBalancesLocked
88 		) public
89     {
90         require(addresses.length == initialBalances.length);
91         
92         currentSupply = initialTotalSupply * (10**decimals);
93         uint256 totalCreated;
94         for(uint8 i =0; i < addresses.length; i++)
95         {
96             if(initialBalancesLocked){
97                 lockedAccounts[addresses[i]] = true;
98             }
99             balances[addresses[i]] = initialBalances[i]* (10**decimals);
100             totalCreated += initialBalances[i]* (10**decimals);
101         }
102         
103         
104         if(currentSupply < totalCreated)
105         {
106             selfdestruct(msg.sender);
107         }
108         else
109         {
110             balances[this] = currentSupply - totalCreated;
111         }
112     }
113     
114 	
115     event SoldToken(address _buyer, uint256 _value, string note);
116     function BuyToken(address _buyer, uint256 _value, string note) public onlyOwner
117     {
118 		require(balances[this] >= _value && balances[_buyer] + _value > balances[_buyer]);
119 		
120         SoldToken( _buyer,  _value,  note);
121         balances[this] -= _value;
122         balances[_buyer] += _value;
123         Transfer(this, _buyer, _value);
124     }
125     
126     function LockAccount(address toLock) public onlyOwner
127     {
128         lockedAccounts[toLock] = true;
129     }
130     function UnlockAccount(address toUnlock) public onlyOwner
131     {
132         delete lockedAccounts[toUnlock];
133     }
134     
135     function SetTradeable(bool t) public onlyOwner
136     {
137         tradeable = t;
138     }
139     function IsTradeable() public view returns(bool)
140     {
141         return tradeable;
142     }
143     
144     
145     function totalSupply() constant public returns (uint256)
146     {
147         return currentSupply;
148     }
149     function balanceOf(address _owner) constant public returns (uint256 balance)
150     {
151         return balances[_owner];
152     }
153     function transfer(address _to, uint256 _value) public notLocked returns (bool success) {
154         require(tradeable);
155          if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
156              Transfer( msg.sender, _to,  _value);
157              balances[msg.sender] -= _value;
158              balances[_to] += _value;
159              return true;
160          } else {
161              return false;
162          }
163      }
164     function transferFrom(address _from, address _to, uint _value)public notLocked returns (bool success) {
165         require(!lockedAccounts[_from] && !lockedAccounts[_to]);
166 		require(tradeable);
167         if (balances[_from] >= _value
168             && allowed[_from][msg.sender] >= _value
169             && _value > 0
170             && balances[_to] + _value > balances[_to]) {
171                 
172             Transfer( _from, _to,  _value);
173                 
174             balances[_from] -= _value;
175             allowed[_from][msg.sender] -= _value;
176             balances[_to] += _value;
177             return true;
178         } else {
179             return false;
180         }
181     }
182     
183     function approve(address _spender, uint _value) public returns (bool success) {
184         Approval(msg.sender,  _spender, _value);
185         allowed[msg.sender][_spender] = _value;
186         return true;
187     }
188     function allowance(address _owner, address _spender) constant public returns (uint remaining){
189         return allowed[_owner][_spender];
190     }
191     event Transfer(address indexed _from, address indexed _to, uint _value);
192     event Approval(address indexed _owner, address indexed _spender, uint _value);
193    
194    modifier notLocked(){
195        require (!lockedAccounts[msg.sender]);
196        _;
197    }
198 }