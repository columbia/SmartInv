1 pragma solidity ^0.4.18;
2 
3 contract EtherealFoundationOwned {
4 	address private Owner;
5     
6 	function IsOwner(address addr) view public returns(bool)
7 	{
8 	    return Owner == addr;
9 	}
10 	
11 	function TransferOwner(address newOwner) public onlyOwner
12 	{
13 	    Owner = newOwner;
14 	}
15 	
16 	function EtherealFoundationOwned() public
17 	{
18 	    Owner = msg.sender;
19 	}
20 	
21 	function Terminate() public onlyOwner
22 	{
23 	    selfdestruct(Owner);
24 	}
25 	
26 	modifier onlyOwner(){
27         require(msg.sender == Owner);
28         _;
29     }
30 }
31 
32 contract GiftzNetworkToken is EtherealFoundationOwned {
33     string public constant CONTRACT_NAME = "GiftzNetworkToken";
34     string public constant CONTRACT_VERSION = "B";
35     
36     string public constant name = "itCoin® Black";
37     string public constant symbol = "ITCB";
38     uint256 public constant decimals = 18;  // 18 is the most common number of decimal places
39     bool private tradeable;
40     uint256 private currentSupply;
41     mapping(address => uint256) private balances;
42     mapping(address => mapping(address=> uint256)) private allowed;
43     mapping(address => bool) private lockedAccounts;  
44 	
45 	/*
46 		Incomming Ether
47 	*/	
48     event RecievedEth(address indexed _from, uint256 _value);
49 	//this is the fallback
50 	function () payable public {
51 		RecievedEth(msg.sender, msg.value);		
52 	}
53 	
54 	event TransferedEth(address indexed _to, uint256 _value);
55 	function FoundationTransfer(address _to, uint256 amtEth, uint256 amtToken) public onlyOwner
56 	{
57 		require(this.balance >= amtEth && balances[this] >= amtToken );
58 		
59 		if(amtEth >0)
60 		{
61 			_to.transfer(amtEth);
62 			TransferedEth(_to, amtEth);
63 		}
64 		
65 		if(amtToken > 0)
66 		{
67 			require(balances[_to] + amtToken > balances[_to]);
68 			balances[this] -= amtToken;
69 			balances[_to] += amtToken;
70 			Transfer(this, _to, amtToken);
71 		}
72 		
73 		
74 	}	
75 	/*
76 		End Incomming Ether
77 	*/
78 	
79 	
80 	
81     function GiftzNetworkToken(
82 		uint256 initialTotalSupply, 
83 		address[] addresses, 
84 		uint256[] initialBalances, 
85 		bool initialBalancesLocked
86 		) public
87     {
88         require(addresses.length == initialBalances.length);
89         
90         currentSupply = initialTotalSupply * (10**decimals);
91         uint256 totalCreated;
92         for(uint8 i =0; i < addresses.length; i++)
93         {
94             if(initialBalancesLocked){
95                 lockedAccounts[addresses[i]] = true;
96             }
97             balances[addresses[i]] = initialBalances[i]* (10**decimals);
98             totalCreated += initialBalances[i]* (10**decimals);
99         }
100         
101         
102         if(currentSupply < totalCreated)
103         {
104             selfdestruct(msg.sender);
105         }
106         else
107         {
108             balances[this] = currentSupply - totalCreated;
109         }
110     }
111     
112 	
113     event SoldToken(address _buyer, uint256 _value, string note);
114     function BuyToken(address _buyer, uint256 _value, string note) public onlyOwner
115     {
116 		require(balances[this] >= _value && balances[_buyer] + _value > balances[_buyer]);
117 		
118         SoldToken( _buyer,  _value,  note);
119         balances[this] -= _value;
120         balances[_buyer] += _value;
121         Transfer(this, _buyer, _value);
122     }
123     
124     function LockAccount(address toLock) public onlyOwner
125     {
126         lockedAccounts[toLock] = true;
127     }
128     function UnlockAccount(address toUnlock) public onlyOwner
129     {
130         delete lockedAccounts[toUnlock];
131     }
132     
133     function SetTradeable(bool t) public onlyOwner
134     {
135         tradeable = t;
136     }
137     function IsTradeable() public view returns(bool)
138     {
139         return tradeable;
140     }
141     
142     
143     function totalSupply() constant public returns (uint256)
144     {
145         return currentSupply;
146     }
147     function balanceOf(address _owner) constant public returns (uint256 balance)
148     {
149         return balances[_owner];
150     }
151     function transfer(address _to, uint256 _value) public notLocked returns (bool success) {
152         require(tradeable);
153          if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
154              Transfer( msg.sender, _to,  _value);
155              balances[msg.sender] -= _value;
156              balances[_to] += _value;
157              return true;
158          } else {
159              return false;
160          }
161      }
162     function transferFrom(address _from, address _to, uint _value)public notLocked returns (bool success) {
163         require(!lockedAccounts[_from] && !lockedAccounts[_to]);
164 		require(tradeable);
165         if (balances[_from] >= _value
166             && allowed[_from][msg.sender] >= _value
167             && _value > 0
168             && balances[_to] + _value > balances[_to]) {
169                 
170             Transfer( _from, _to,  _value);
171                 
172             balances[_from] -= _value;
173             allowed[_from][msg.sender] -= _value;
174             balances[_to] += _value;
175             return true;
176         } else {
177             return false;
178         }
179     }
180     
181     function approve(address _spender, uint _value) public returns (bool success) {
182         Approval(msg.sender,  _spender, _value);
183         allowed[msg.sender][_spender] = _value;
184         return true;
185     }
186     function allowance(address _owner, address _spender) constant public returns (uint remaining){
187         return allowed[_owner][_spender];
188     }
189     event Transfer(address indexed _from, address indexed _to, uint _value);
190     event Approval(address indexed _owner, address indexed _spender, uint _value);
191    
192    modifier notLocked(){
193        require (!lockedAccounts[msg.sender]);
194        _;
195    }
196 }