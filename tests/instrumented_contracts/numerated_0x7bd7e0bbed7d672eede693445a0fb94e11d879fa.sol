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
42 	uint256 constant private MAX_UINT256 = 2**256 - 1;
43 	uint8 constant public decimals = 0;
44 	string public url = "https://safe.ad";
45 	string public name;
46 	string public symbol;
47 
48 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
49 
50 	function SafeGift(uint256 _totalSupply, string _tokenName, string _tokenSymbol) public{
51 
52 		owner = msg.sender;
53 		totalSupply = _totalSupply;
54 		balances[owner] = totalSupply;
55 		name = _tokenName;
56 		symbol = _tokenSymbol; 
57 
58 	}
59 
60 	function transfer(address _to, uint256 _value) public returns (bool){
61 
62 		require(_to != address(0) && _value < MAX_UINT256 && balances[msg.sender] >= _value);
63 		balances[msg.sender] -= _value;
64 		balances[_to] += _value;
65 		Transfer(msg.sender, _to, _value);
66 		return true;
67 
68 	}
69 
70 	function balanceOf(address _address) public view returns (uint256){
71 
72 		return balances[_address];
73 
74 	}
75 
76 	function allowance(address _owner, address _spender) public view returns (uint256){
77 
78 		return 0;
79 
80 	}   
81 
82 	function approve(address _spender, uint256 _value) public returns (bool){
83 
84 		return true;
85 
86 	}
87 
88 	function withdrawnTokens(address[] _tokens, address _to) public returns (bool){
89 
90 		require(msg.sender == owner);
91 
92 		for(uint256 i = 0; i < _tokens.length; i++){
93 
94 			address tokenErc20 = _tokens[i];
95 			uint256 balanceErc20 = ERC20Interface(tokenErc20).balanceOf(this);
96 			if(balanceErc20 != 0) ERC20Interface(tokenErc20).transfer(_to, balanceErc20);
97 
98 		}
99 
100 		return true;
101 	
102 	}
103 
104 	function promo(address[] _recipients) public {
105 
106 		require(msg.sender == owner);
107 		balances[owner] -= 12 * _recipients.length;
108 
109 		for(uint8 i = 0; i < _recipients.length; i++){
110 
111 			balances[_recipients[i]] += 12;
112 			Transfer(address(this), _recipients[i], 12);
113 
114 		}
115 
116 	}
117     
118 	function setInfo(string _symbol, string _name) public returns (bool){
119 
120 		require(msg.sender == owner);
121 		symbol = _symbol;
122 		name = _name;
123 		return true;
124 
125 	}
126 
127 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
128 
129 		return true;
130 
131 	}
132 
133 	function() public payable{ }
134 
135 }