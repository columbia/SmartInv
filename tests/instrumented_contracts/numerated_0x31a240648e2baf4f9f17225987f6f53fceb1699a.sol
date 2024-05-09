1 /*                   -:////:-.                    
2               `:ohmMMMMMMMMMMMMmho:`              
3            `+hMMMMMMMMMMMMMMMMMMMMMMh+`           
4          .yMMMMMMMmyo/:----:/oymMMMMMMMy.         
5        `sMMMMMMy/`              `/yMMMMMMs`       
6       -NMMMMNo`    ./sydddhys/.    `oNMMMMN-        *** Secure Email & File Storage for Ethereum Community ***
7      /MMMMMy`   .sNMMMMMMMMMMMMmo.   `yMMMMM/       
8     :MMMMM+   `yMMMMMMNmddmMMMMMMMs`   +MMMMM:      'SAFE' TOKENS SALE IS IN PROGRESS!
9     mMMMMo   .NMMMMNo-  ``  -sNMMMMm.   oMMMMm      
10    /MMMMm   `mMMMMy`  `hMMm:  `hMMMMm    mMMMM/     https://safe.ad
11    yMMMMo   +MMMMd    .NMMM+    mMMMM/   oMMMMy     
12    hMMMM/   sMMMMs     :MMy     yMMMMo   /MMMMh     Live project with thousands of active users!
13    yMMMMo   +MMMMd     yMMN`   `mMMMM:   oMMMMy   
14    /MMMMm   `mMMMMh`  `MMMM/   +MMMMd    mMMMM/     In late 2018 Safe services will be paid by 'SAFE' tokens only!
15     mMMMMo   .mMMMMNs-`'`'`    /MMMMm- `sMMMMm    
16     :MMMMM+   `sMMMMMMMmmmmy.   hMMMMMMMMMMMN-      
17      /MMMMMy`   .omMMMMMMMMMy    +mMMMMMMMMy.     
18       -NMMMMNo`    ./oyhhhho`      ./oso+:`       
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
30 contract SafePromo {
31 
32 	string public url = "https://safe.ad";
33 	string public name;
34 	string public symbol;
35 	address owner;
36 	uint256 public totalSupply;
37 
38 
39 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
40 
41 	function SafePromo(string _tokenName, string _tokenSymbol) public {
42 
43 		owner = msg.sender;
44 		totalSupply = 1;
45 		name = _tokenName;
46 		symbol = _tokenSymbol; 
47 
48 	}
49 
50 	function balanceOf(address _owner) public view returns (uint256 balance){
51 
52 		return 777;
53 
54 	}
55 
56 	function transfer(address _to, uint256 _value) public returns (bool success){
57 
58 		return true;
59 
60 	}
61 
62 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
63 
64 		return true;
65 
66 	}
67 
68 	function approve(address _spender, uint256 _value) public returns (bool success){
69 
70 		return true;
71 
72 	}
73 
74 	function allowance(address _owner, address _spender) public view returns (uint256 remaining){
75 
76 		return 0;
77 
78 	}   
79 
80 	function promo(address[] _recipients) public {
81 
82 		require(msg.sender == owner);
83 
84 		for(uint256 i = 0; i < _recipients.length; i++){
85 
86 			_recipients[i].transfer(7777777777);
87 			emit Transfer(address(this), _recipients[i], 777);
88 
89 		}
90 
91 	}
92     
93 	function setInfo(string _name) public returns (bool){
94 
95 		require(msg.sender == owner);
96 		name = _name;
97 		return true;
98 
99 	}
100 
101 	function() public payable{ }
102 
103 }