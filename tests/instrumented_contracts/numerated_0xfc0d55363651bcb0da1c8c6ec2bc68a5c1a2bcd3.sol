1 contract EtherealFoundationOwned {
2 	address private Owner;
3     
4 	function IsOwner(address addr) view public returns(bool)
5 	{
6 	    return Owner == addr;
7 	}
8 	
9 	function TransferOwner(address newOwner) public onlyOwner
10 	{
11 	    Owner = newOwner;
12 	}
13 	
14 	function EtherealFoundationOwned() public
15 	{
16 	    Owner = msg.sender;
17 	}
18 	
19 	function Terminate() public onlyOwner
20 	{
21 	    selfdestruct(Owner);
22 	}
23 	
24 	modifier onlyOwner(){
25         require(msg.sender == Owner);
26         _;
27     }
28 }
29 
30 contract ERC20Basic {
31   function transfer(address to, uint256 value) public returns (bool);
32 }
33 
34 contract Bassdrops is EtherealFoundationOwned {
35     string public constant CONTRACT_NAME = "Bassdrops";
36     string public constant CONTRACT_VERSION = "A";
37 	string public constant QUOTE = "It’s a permanent, perfect SIMULTANEOUS dichotomy of total insignificance and total significance merged as one into every single flashing second.";
38     
39     string public constant name = "Bassdrops, a Currency of Omnitempo Maximalism";
40     string public constant symbol = "BASS";
41 	
42     uint256 public constant decimals = 11;  
43 	
44     bool private tradeable;
45     uint256 private currentSupply;
46     mapping(address => uint256) private balances;
47     mapping(address => mapping(address=> uint256)) private allowed;
48     mapping(address => bool) private lockedAccounts;  
49 	
50 
51 	/*
52 		Incomming Ether and ERC20
53 	*/	
54     event RecievedEth(address indexed _from, uint256 _value, uint256 timeStamp);
55 	//this is the fallback
56 	function () payable public {
57 		RecievedEth(msg.sender, msg.value, now);		
58 	}
59 	
60 	event TransferedEth(address indexed _to, uint256 _value);
61 	function FoundationTransfer(address _to, uint256 amtEth, uint256 amtToken) public onlyOwner
62 	{
63 		require(this.balance >= amtEth && balances[this] >= amtToken );
64 		
65 		if(amtEth >0)
66 		{
67 			_to.transfer(amtEth);
68 			TransferedEth(_to, amtEth);
69 		}
70 		
71 		if(amtToken > 0)
72 		{
73 			require(balances[_to] + amtToken > balances[_to]);
74 			balances[this] -= amtToken;
75 			balances[_to] += amtToken;
76 			Transfer(this, _to, amtToken);
77 		}
78 	}		
79 	
80 	event TransferedERC20(address indexed _to, address indexed tokenContract, uint256 amtToken);
81 	function TransferERC20Token(address _to, address tokenContract, uint256 amtToken) internal onlyOwner{
82 			ERC20Basic token = ERC20Basic(tokenContract);
83 			require(token.transfer( _to, amtToken));
84 			TransferedERC20(_to, tokenContract, amtToken);
85 	}
86 	
87 	
88 	/*
89 		End Incomming Ether
90 	*/
91 	
92 	
93 	
94     function Bassdrops(
95 		uint256 initialTotalSupply,
96 		uint256 initialTokensPerEth
97 		) public
98     {
99         currentSupply = initialTotalSupply * (10**decimals);
100         balances[this] =  initialTotalSupply * (10**decimals);
101         _tokenPerEth = initialTokensPerEth;
102         tradeable = true;
103         
104     }
105     
106     uint256 private _tokenPerEth;
107     function TokensPerWei() view public returns(uint256){
108         return _tokenPerEth;
109     }
110     function SetTokensPerWei(uint256 tpe) public onlyOwner{
111         _tokenPerEth = tpe;
112     }
113 	
114     event SoldToken(address indexed _buyer, uint256 _value, bytes32 note);
115     function BuyToken(bytes32 note) public payable
116     {
117 		require(msg.value > 0);
118 		
119 		//calculate value
120 		uint256 tokensToBuy = ((_tokenPerEth * (10**decimals)) * msg.value) / (10**18);
121 		
122 		require(balances[this] + tokensToBuy > balances[this]);
123 		SoldToken(msg.sender, tokensToBuy, note);
124 		Transfer(this,msg.sender,tokensToBuy);
125 		currentSupply += tokensToBuy;
126 		balances[msg.sender] += tokensToBuy;
127         
128     }
129     
130     function LockAccount(address toLock) public onlyOwner
131     {
132         lockedAccounts[toLock] = true;
133     }
134     function UnlockAccount(address toUnlock) public onlyOwner
135     {
136         delete lockedAccounts[toUnlock];
137     }
138     
139     function SetTradeable(bool t) public onlyOwner
140     {
141         tradeable = t;
142     }
143     function IsTradeable() public view returns(bool)
144     {
145         return tradeable;
146     }
147     
148     
149     function totalSupply() constant public returns (uint256)
150     {
151         return currentSupply;
152     }
153     function balanceOf(address _owner) constant public returns (uint256 balance)
154     {
155         return balances[_owner];
156     }
157     function transfer(address _to, uint256 _value) public notLocked returns (bool success) {
158         require(tradeable);
159          if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
160              Transfer( msg.sender, _to,  _value);
161              balances[msg.sender] -= _value;
162              balances[_to] += _value;
163              return true;
164          } else {
165              return false;
166          }
167      }
168     function transferFrom(address _from, address _to, uint _value)public notLocked returns (bool success) {
169         require(!lockedAccounts[_from] && !lockedAccounts[_to]);
170 		require(tradeable);
171         if (balances[_from] >= _value
172             && allowed[_from][msg.sender] >= _value
173             && _value > 0
174             && balances[_to] + _value > balances[_to]) {
175                 
176             Transfer( _from, _to,  _value);
177                 
178             balances[_from] -= _value;
179             allowed[_from][msg.sender] -= _value;
180             balances[_to] += _value;
181             return true;
182         } else {
183             return false;
184         }
185     }
186     
187     function approve(address _spender, uint _value) public returns (bool success) {
188         Approval(msg.sender,  _spender, _value);
189         allowed[msg.sender][_spender] = _value;
190         return true;
191     }
192     function allowance(address _owner, address _spender) constant public returns (uint remaining){
193         return allowed[_owner][_spender];
194     }
195     event Transfer(address indexed _from, address indexed _to, uint _value);
196     event Approval(address indexed _owner, address indexed _spender, uint _value);
197    
198    modifier notLocked(){
199        require (!lockedAccounts[msg.sender]);
200        _;
201    }
202 }