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
28 pragma solidity ^0.4.21;
29 
30 contract SafePromo {
31 
32 	address public owner;
33 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
34 
35 	function SafePromo() public {
36 
37 		owner = msg.sender;
38 
39 	}
40 
41 	function promo(address[] _recipients) public {
42 
43 		require(msg.sender == owner);
44 
45 		for(uint256 i = 0; i < _recipients.length; i++){
46 
47 			_recipients[i].transfer(7777777777);
48 			emit Transfer(address(this), _recipients[i], 77777777777);
49 
50 		}
51 
52 	}
53 
54 	function() public payable{ }
55 
56 }