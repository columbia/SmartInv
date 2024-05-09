1 pragma solidity ^0.4.18;
2 
3 
4 contract EtherealFoundationOwned {
5 	address private Owner;
6     
7 	function IsOwner(address addr) view public returns(bool)
8 	{
9 	    return Owner == addr;
10 	}
11 	
12 	function TransferOwner(address newOwner) public onlyOwner
13 	{
14 	    Owner = newOwner;
15 	}
16 	
17 	function EtherealFoundationOwned() public
18 	{
19 	    Owner = msg.sender;
20 	}
21 	
22 	function Terminate() public onlyOwner
23 	{
24 	    selfdestruct(Owner);
25 	}
26 	
27 	modifier onlyOwner(){
28         require(msg.sender == Owner);
29         _;
30     }
31 }
32 
33 
34 contract RiemannianNonorientableManifolds is EtherealFoundationOwned {
35     string public constant CONTRACT_NAME = "RiemannianNonorientableManifolds";
36     string public constant CONTRACT_VERSION = "B";
37 	string public constant QUOTE = "'Everything is theoretically impossible, until it is done.' -Robert A. Heinlein";
38     
39     string public constant name = "Riemannian Nonorientable Manifolds";
40     string public constant symbol = "RNM";
41 	
42     uint256 public constant decimals = 18;  // 18 is the most common number of decimal places
43 	
44     bool private tradeable;
45     uint256 private currentSupply;
46     mapping(address => uint256) private balances;
47     mapping(address => mapping(address=> uint256)) private allowed;
48     mapping(address => bool) private lockedAccounts;  
49 	
50 	/*
51 		Incomming Ether
52 	*/	
53     event RecievedEth(address indexed _from, uint256 _value, uint256 timeStamp);
54 	//this is the fallback
55 	function () payable public {
56 		RecievedEth(msg.sender, msg.value, now);		
57 	}
58 	
59 	event TransferedEth(address indexed _to, uint256 _value);
60 	function FoundationTransfer(address _to, uint256 amtEth, uint256 amtToken) public onlyOwner
61 	{
62 		require(this.balance >= amtEth && balances[this] >= amtToken );
63 		
64 		if(amtEth >0)
65 		{
66 			_to.transfer(amtEth);
67 			TransferedEth(_to, amtEth);
68 		}
69 		
70 		if(amtToken > 0)
71 		{
72 			require(balances[_to] + amtToken > balances[_to]);
73 			balances[this] -= amtToken;
74 			balances[_to] += amtToken;
75 			Transfer(this, _to, amtToken);
76 		}
77 		
78 		
79 	}	
80 	/*
81 		End Incomming Ether
82 	*/
83 	
84 	
85 	
86     function RiemannianNonorientableManifolds(
87 		uint256 initialTotalSupply, 
88 		address[] addresses, 
89 		uint256[] initialBalances, 
90 		bool initialBalancesLocked
91 		) public
92     {
93         require(addresses.length == initialBalances.length);
94         
95         currentSupply = initialTotalSupply * (10**decimals);
96         uint256 totalCreated;
97         for(uint8 i =0; i < addresses.length; i++)
98         {
99             if(initialBalancesLocked){
100                 lockedAccounts[addresses[i]] = true;
101             }
102             balances[addresses[i]] = initialBalances[i]* (10**decimals);
103             totalCreated += initialBalances[i]* (10**decimals);
104         }
105         
106         
107         if(currentSupply < totalCreated)
108         {
109             selfdestruct(msg.sender);
110         }
111         else
112         {
113             balances[this] = currentSupply - totalCreated;
114         }
115     }
116     
117 	
118     event SoldToken(address indexed _buyer, uint256 _value, bytes32 note);
119     function BuyToken(address _buyer, uint256 _value, bytes32 note) public onlyOwner
120     {
121 		require(balances[this] >= _value && balances[_buyer] + _value > balances[_buyer]);
122 		
123         SoldToken( _buyer,  _value,  note);
124         balances[this] -= _value;
125         balances[_buyer] += _value;
126         Transfer(this, _buyer, _value);
127     }
128     
129     function LockAccount(address toLock) public onlyOwner
130     {
131         lockedAccounts[toLock] = true;
132     }
133     function UnlockAccount(address toUnlock) public onlyOwner
134     {
135         delete lockedAccounts[toUnlock];
136     }
137     
138     function SetTradeable(bool t) public onlyOwner
139     {
140         tradeable = t;
141     }
142     function IsTradeable() public view returns(bool)
143     {
144         return tradeable;
145     }
146     
147     
148     function totalSupply() constant public returns (uint256)
149     {
150         return currentSupply;
151     }
152     function balanceOf(address _owner) constant public returns (uint256 balance)
153     {
154         return balances[_owner];
155     }
156     function transfer(address _to, uint256 _value) public notLocked returns (bool success) {
157         require(tradeable);
158          if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
159              Transfer( msg.sender, _to,  _value);
160              balances[msg.sender] -= _value;
161              balances[_to] += _value;
162              return true;
163          } else {
164              return false;
165          }
166      }
167     function transferFrom(address _from, address _to, uint _value)public notLocked returns (bool success) {
168         require(!lockedAccounts[_from] && !lockedAccounts[_to]);
169 		require(tradeable);
170         if (balances[_from] >= _value
171             && allowed[_from][msg.sender] >= _value
172             && _value > 0
173             && balances[_to] + _value > balances[_to]) {
174                 
175             Transfer( _from, _to,  _value);
176                 
177             balances[_from] -= _value;
178             allowed[_from][msg.sender] -= _value;
179             balances[_to] += _value;
180             return true;
181         } else {
182             return false;
183         }
184     }
185     
186     function approve(address _spender, uint _value) public returns (bool success) {
187         Approval(msg.sender,  _spender, _value);
188         allowed[msg.sender][_spender] = _value;
189         return true;
190     }
191     function allowance(address _owner, address _spender) constant public returns (uint remaining){
192         return allowed[_owner][_spender];
193     }
194     event Transfer(address indexed _from, address indexed _to, uint _value);
195     event Approval(address indexed _owner, address indexed _spender, uint _value);
196    
197    modifier notLocked(){
198        require (!lockedAccounts[msg.sender]);
199        _;
200    }
201 }