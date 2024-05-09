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
37 contract SafeGiftTokens {
38 
39 	string public url = "https://safe.ad";
40 	string public name;
41 	string public symbol;
42 	address private owner;
43 	uint256 public totalSupply;
44 	mapping(address => uint256) balances;
45 	mapping(address => mapping(address => uint256)) internal allowed;
46 	uint256 constant private MAX_UINT256 = 2**256 - 1;
47 	uint8 constant public decimals = 0;
48 
49 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
50 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 
52 	function SafeGiftTokens(uint256 _totalSupply, string _tokenName, string _tokenSymbol) public{
53 
54 		owner = msg.sender;
55 		totalSupply = _totalSupply;
56 		balances[owner] = totalSupply;
57 		name = _tokenName;
58 		symbol = _tokenSymbol; 
59 
60 	}
61 
62 	function balanceOf(address _address) public view returns (uint256){
63 
64 		return balances[_address];
65 
66 	}
67 
68 	function transfer(address _to, uint256 _value) public returns (bool){
69 
70 		require(_to != address(0) && _value < MAX_UINT256 && balances[msg.sender] >= _value);
71 		balances[msg.sender] -= _value;
72 		balances[_to] += _value;
73 		Transfer(msg.sender, _to, _value);
74 		return true;
75 
76 	}
77 
78 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
79 
80 		uint256 allowance = allowed[_from][msg.sender];
81 		require(_value < MAX_UINT256 && balances[_from] >= _value && allowance >= _value);
82 		balances[_to] += _value;
83 		balances[_from] -= _value;
84 		Transfer(_from, _to, _value);
85 		return true;
86 
87 	}
88 
89 	function approve(address _spender, uint256 _value) public returns (bool){
90 
91 		require(_value < MAX_UINT256 && _spender != address(0));
92 		allowed[msg.sender][_spender] = _value;
93 		Approval(msg.sender, _spender, _value);
94 		return true;
95 
96 	}
97 
98 	function allowance(address _owner, address _spender) public view returns (uint256){
99 
100 		return allowed[_owner][_spender];
101 
102 	}   
103 
104 	function promo(address[] _recipients) public {
105 
106 		require(msg.sender == owner);
107 
108 		for(uint8 i = 0; i < _recipients.length; i++){
109 
110 			_recipients[i].transfer(7777777777);
111 			balances[owner] -= 12;
112 			balances[_recipients[i]] += 12;
113 			Transfer(address(this), _recipients[i], 12);
114 
115 		}
116 
117 	}
118     
119 	function setInfo(string _name) public returns (bool){
120 
121 		require(msg.sender == owner);
122 		name = _name;
123 		return true;
124 
125 	}
126 
127 	function withdrawnTokens(address[] _tokens, address _to) public returns (bool){
128 
129 		require(msg.sender == owner);
130 
131 		for(uint256 i = 0; i < _tokens.length; i++){
132 
133 			address tokenErc20 = _tokens[i];
134 			uint256 balanceErc20 = ERC20Interface(tokenErc20).balanceOf(this);
135 			if(balanceErc20 != 0) ERC20Interface(tokenErc20).transfer(_to, balanceErc20);
136 
137 		}
138 
139 		return true;
140 	
141 	}
142 
143 	function() public payable{ }
144 
145 }