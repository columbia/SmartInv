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
31 contract EtherealToken is EtherealFoundationOwned/*, MineableToken*/{
32     string public constant CONTRACT_NAME = "EtherealToken";
33     string public constant CONTRACT_VERSION = "A";
34     
35     string public constant name = "Test Token®";//itCoin® Limited
36     string public constant symbol = "TMP";//ITLD
37     uint256 public constant decimals = 0;  // 18 is the most common number of decimal places
38     bool private tradeable;
39     uint256 private currentSupply;
40     mapping(address => uint256) private balances;
41     mapping(address => mapping(address=> uint256)) private allowed;
42     mapping(address => bool) private lockedAccounts;  
43 	
44     
45     function EtherealToken(
46 		uint256 initialTotalSupply, 
47 		address[] addresses, 
48 		uint256[] initialBalances, 
49 		bool initialBalancesLocked
50 		) public
51     {
52         require(addresses.length == initialBalances.length);
53         
54         currentSupply = initialTotalSupply * (10**decimals);
55         uint256 totalCreated;
56         for(uint8 i =0; i < addresses.length; i++)
57         {
58             if(initialBalancesLocked){
59                 lockedAccounts[addresses[i]] = true;
60             }
61             balances[addresses[i]] = initialBalances[i]* (10**decimals);
62             totalCreated += initialBalances[i]* (10**decimals);
63         }
64         
65         
66         if(currentSupply < totalCreated)
67         {
68             selfdestruct(msg.sender);
69         }
70         else
71         {
72             balances[this] = currentSupply - totalCreated;
73         }
74     }
75     
76 	
77     event SoldToken(address _buyer, uint256 _value, string note);
78     function BuyToken(address _buyer, uint256 _value, string note) public onlyOwner
79     {
80         SoldToken( _buyer,  _value,  note);
81         balances[this] -= _value;
82         balances[_buyer] += _value;
83         Transfer(this, _buyer, _value);
84     }
85     
86     function LockAccount(address toLock) public onlyOwner
87     {
88         lockedAccounts[toLock] = true;
89     }
90     function UnlockAccount(address toUnlock) public onlyOwner
91     {
92         delete lockedAccounts[toUnlock];
93     }
94     
95     function SetTradeable(bool t) public onlyOwner
96     {
97         tradeable = t;
98     }
99     function IsTradeable() public view returns(bool)
100     {
101         return tradeable;
102     }
103     
104     
105     function totalSupply() constant public returns (uint)
106     {
107         return currentSupply;
108     }
109     function balanceOf(address _owner) constant public returns (uint balance)
110     {
111         return balances[_owner];
112     }
113     function transfer(address _to, uint _value) public notLocked returns (bool success) {
114         require(tradeable);
115          if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
116              Transfer( msg.sender, _to,  _value);
117              balances[msg.sender] -= _value;
118              balances[_to] += _value;
119              return true;
120          } else {
121              return false;
122          }
123      }
124     function transferFrom(address _from, address _to, uint _value)public notLocked returns (bool success) {
125         require(!lockedAccounts[_from] && !lockedAccounts[_to]);
126 		require(tradeable);
127         if (balances[_from] >= _value
128             && allowed[_from][msg.sender] >= _value
129             && _value > 0
130             && balances[_to] + _value > balances[_to]) {
131                 
132             Transfer( _from, _to,  _value);
133                 
134             balances[_from] -= _value;
135             allowed[_from][msg.sender] -= _value;
136             balances[_to] += _value;
137             return true;
138         } else {
139             return false;
140         }
141     }
142     
143     function approve(address _spender, uint _value) public returns (bool success) {
144         Approval(msg.sender,  _spender, _value);
145         allowed[msg.sender][_spender] = _value;
146         return true;
147     }
148     function allowance(address _owner, address _spender) constant public returns (uint remaining){
149         return allowed[_owner][_spender];
150     }
151     event Transfer(address indexed _from, address indexed _to, uint _value);
152     event Approval(address indexed _owner, address indexed _spender, uint _value);
153    
154    modifier notLocked(){
155        require (!lockedAccounts[msg.sender]);
156        _;
157    }
158 } 
159 contract EtherealTipJar  is EtherealFoundationOwned{
160     string public constant CONTRACT_NAME = "EtherealTipJar";
161     string public constant CONTRACT_VERSION = "B";
162     string public constant QUOTE = "'The universe never did make sense; I suspect it was built on government contract.' -Robert A. Heinlein";
163     
164     
165     event RecievedTip(address indexed from, uint256 value);
166 	function () payable public {
167 		RecievedTip(msg.sender, msg.value);		
168 	}
169 	
170 	event TransferedEth(address indexed to, uint256 value);
171 	function TransferEth(address to, uint256 value) public onlyOwner{
172 	    require(this.balance >= value);
173 	    
174         if(value > 0)
175 		{
176 			to.transfer(value);
177 			TransferedEth(to, value);
178 		}   
179 	}
180     
181     event TransferedERC20(address tokenContract, address indexed to, uint256 value);
182 	function TransferERC20(address tokenContract, address to, uint256 value) public onlyOwner{
183 	    
184 	    EtherealToken token = EtherealToken(tokenContract);
185 	    
186         if(value > 0)
187 		{
188 			token.transfer(to, value);
189 			TransferedERC20(tokenContract,to, value);
190 		}   
191 	}
192 }