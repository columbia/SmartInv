1 pragma solidity ^0.4.23;        
2 
3 // ----------------------------------------------------------------------------------------------
4 // Project Delta 
5 // DELTA - New Crypto-Platform with own cryptocurrency, verified smart contracts and multi blockchains!
6 // For 1 DELTA token in future you will get 1 DELTA coin!
7 // Site: http://delta.money
8 // Telegram Chat: @deltacoin
9 // Telegram News: @deltaico
10 // CEO Nechesov Andrey http://facebook.com/Nechesov     
11 // Telegram: @Nechesov
12 // Ltd. "Delta"
13 // Working with ERC20 contract https://etherscan.io/address/0xf85a2e95fa30d005f629cbe6c6d2887d979fff2a                  
14 // ----------------------------------------------------------------------------------------------
15    
16 contract Delta {     
17 
18 	address public c = 0xF85A2E95FA30d005F629cBe6c6d2887D979ffF2A; 
19 	address public owner = 0x788c45dd60ae4dbe5055b5ac02384d5dc84677b0;	
20 	address public owner2 = 0x0C6561edad2017c01579Fd346a58197ea01A0Cf3;	
21 	uint public active = 1;	
22 
23 	uint public token_price = 10**18*1/1000; 	
24 
25 	//default function for buy tokens      
26 	function() payable {        
27 	    tokens_buy();        
28 	}
29 
30 	/**
31 	* Buy tokens
32 	*/
33     function tokens_buy() payable returns (bool) {         
34         
35         require(active > 0);
36         require(msg.value >= token_price);        
37 
38         uint tokens_buy = msg.value*10**18/token_price;
39 
40         require(tokens_buy > 0);
41 
42         if(!c.call(bytes4(sha3("transferFrom(address,address,uint256)")),owner, msg.sender,tokens_buy)){
43         	return false;
44         }
45 
46         uint sum2 = msg.value * 3 / 10;           
47 
48         owner2.send(sum2);
49 
50         return true;
51       }     
52 
53       //Withdraw money from contract balance to owner
54       function withdraw(uint256 _amount) onlyOwner returns (bool result) {
55           uint256 balance;
56           balance = this.balance;
57           if(_amount > 0) balance = _amount;
58           owner.send(balance);
59           return true;
60       }
61 
62       //Change token
63       function change_token_price(uint256 _token_price) onlyOwner returns (bool result) {
64         token_price = _token_price;
65         return true;
66       }
67 
68       //Change active
69       function change_active(uint256 _active) onlyOwner returns (bool result) {
70         active = _active;
71         return true;
72       }
73 
74       // Functions with this modifier can only be executed by the owner
75     	modifier onlyOwner() {
76         if (msg.sender != owner) {
77             throw;
78         }
79         _;
80     }        	
81 
82 
83 }