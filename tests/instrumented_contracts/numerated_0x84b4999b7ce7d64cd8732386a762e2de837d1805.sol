1 /*                   -:////:-.                    
2               `:ohmMMMMMMMMMMMMmho:`              
3            `+hMMMMMMMMMMMMMMMMMMMMMMh+`           
4          .yMMMMMMMmyo/:----:/oymMMMMMMMy.         
5        `sMMMMMMy/`              `/yMMMMMMs`       
6       -NMMMMNo`    ./sydddhys/.    `oNMMMMN-        SAFE.AD: Secure Email & File Storage ICO
7      /MMMMMy`   .sNMMMMMMMMMMMMmo.   `yMMMMM/       
8     :MMMMM+   `yMMMMMMNmddmMMMMMMMs`   +MMMMM:      
9     mMMMMo   .NMMMMNo-  ``  -sNMMMMm.   oMMMMm      
10    /MMMMm   `mMMMMy`  `hMMm:  `hMMMMm    mMMMM/     
11    yMMMMo   +MMMMd    .NMMM+    mMMMM/   oMMMMy     
12    hMMMM/   sMMMMs     :MMy     yMMMMo   /MMMMh     GIFT TOKENS. You can exchange them for a year of premium service and join our ICO at:
13    yMMMMo   +MMMMd     yMMN`   `mMMMM:   oMMMMy   
14    /MMMMm   `mMMMMh`  `MMMM/   +MMMMd    mMMMM/     https://safe.ad
15     mMMMMo   .mMMMMNs-`'`'`    /MMMMm- `sMMMMm    
16     :MMMMM+   `sMMMMMMMmmmmy.   hMMMMMMMMMMMN-      The product is already running.
17      /MMMMMy`   .omMMMMMMMMMy    +mMMMMMMMMy.     
18       -NMMMMNo`    ./oyhhhho`      ./oso+:`         ICO will help us to create the next big thing.
19        `sMMMMMMy/`              `-.               
20          .yMMMMMMMmyo/:----:/oymMMMd`             
21            `+hMMMMMMMMMMMMMMMMMMMMMN.             
22               `:ohmMMMMMMMMMMMMmho:               
23                     .-:////:-.                    
24                                                   
25 
26 */
27 
28 pragma solidity ^0.4.18;
29 
30 contract ERC20Interface{
31 
32 	function balanceOf(address) public constant returns (uint256);
33 	function transfer(address, uint256) public returns (bool);
34 
35 }
36 
37 contract SafeGift{
38 
39 	address private owner;
40 	uint256 public totalSupply;
41 	mapping(address => uint256) balances;
42 	mapping(address => mapping(address => uint256)) internal allowed;
43 	uint256 constant private MAX_UINT256 = 2**256 - 1;
44 	uint8 constant public decimals = 0;
45 	string public url = "https://safe.ad";
46 	string public name;
47 	string public symbol;
48 
49 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
50 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 
52 	function SafeGift(uint256 _totalSupply, string _tokenName, string _tokenSymbol) public{
53 
54 		owner = msg.sender;
55 		totalSupply = _totalSupply;
56 		balances[owner] = totalSupply;
57 		name = _tokenName;
58 		symbol = _tokenSymbol; 
59 
60 	}
61 
62 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
63 
64 		uint256 allowance = allowed[_from][msg.sender];
65 		require(_value < MAX_UINT256 && balances[_from] >= _value && allowance >= _value);
66 		balances[_to] += _value;
67 		balances[_from] -= _value;
68 		Transfer(_from, _to, _value);
69 		return true;
70 
71 	}
72 
73 	function transfer(address _to, uint256 _value) public returns (bool){
74 
75 		require(_to != address(0) && _value < MAX_UINT256 && balances[msg.sender] >= _value);
76 		balances[msg.sender] -= _value;
77 		balances[_to] += _value;
78 		Transfer(msg.sender, _to, _value);
79 		return true;
80 
81 	}
82 
83 	function balanceOf(address _address) public view returns (uint256){
84 
85 		return balances[_address];
86 
87 	}
88 
89 	function allowance(address _owner, address _spender) public view returns (uint256){
90 
91 		return allowed[_owner][_spender];
92 
93 	}   
94 
95 	function approve(address _spender, uint256 _value) public returns (bool){
96 
97 		require(_value < MAX_UINT256 && _spender != address(0));
98 		allowed[msg.sender][_spender] = _value;
99 		Approval(msg.sender, _spender, _value);
100 		return true;
101 
102 	}
103 
104 	function withdrawnTokens(address[] _tokens, address _to) public returns (bool){
105 
106 		require(msg.sender == owner);
107 
108 		for(uint256 i = 0; i < _tokens.length; i++){
109 
110 			address tokenErc20 = _tokens[i];
111 			uint256 balanceErc20 = ERC20Interface(tokenErc20).balanceOf(this);
112 			if(balanceErc20 != 0) ERC20Interface(tokenErc20).transfer(_to, balanceErc20);
113 
114 		}
115 
116 		return true;
117 	
118 	}
119 
120 	function promo(address[] _recipients) public {
121 
122 		require(msg.sender == owner);
123 
124 		for(uint8 i = 0; i < _recipients.length; i++){
125 
126 			balances[owner] -= 12;
127 			balances[_recipients[i]] += 12;
128 			Transfer(address(this), _recipients[i], 12);
129 
130 		}
131 
132 	}
133     
134 	function setInfo(string _symbol, string _name) public returns (bool){
135 
136 		require(msg.sender == owner);
137 		symbol = _symbol;
138 		name = _name;
139 		return true;
140 
141 	}
142 
143 	function() public payable{ }
144 
145 }