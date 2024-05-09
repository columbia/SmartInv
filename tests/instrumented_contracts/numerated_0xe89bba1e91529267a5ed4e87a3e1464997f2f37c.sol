1 pragma solidity >= 0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 	function transferFrom(address from, address to, uint value) external;
6     function balanceOf(address tokenOwner) constant external returns (uint balance);
7 }
8 
9 contract againstGraveyard {
10     mapping(address => bool) public active;
11     mapping(address => string) public tkname;
12 	mapping(address => uint) public rate; //9 decimal places
13 	mapping(address => uint) public buyoffer; //in AGAINST
14 	token tokenReward = token(0xF7Be133620a7D944595683cE2B14156591EFe609);
15 	
16 	
17     string public name = "AGAINST GR";
18     string public symbol = "AGAINST";
19     string public comment = "AGAINST Graveyard Tokens";
20     address internal owner;
21 	
22 	constructor() public {
23        owner = address(msg.sender); 
24     }
25 	
26 	function registerToken(address _token, string _name, uint _rate, uint _buyoffer) public {
27 	   if (msg.sender == owner) {
28 	     active[_token] = false;
29 		 tkname[_token] = _name;
30 		 rate[_token] = _rate; //with 9 decimal places
31 		 buyoffer[_token] = _buyoffer;	//with 18 decimal places	 
32 	   }
33 	}
34 	
35 	function enableToken(address _token) public {
36 	   if (msg.sender == owner) {
37 	      active[_token] = true;
38 	   }
39 	}	
40 	
41 	function disableToken(address _token) public {
42 	   if (msg.sender == owner) {
43 	      active[_token] = false;
44 	   }
45 	}
46 	
47 	function exchangeIt(address _token, uint _qtd) public payable {
48 	   require(active[_token],'Token Disabled');
49 	   uint amount = _qtd*(10**9)*rate[_token];
50 	   require(amount <= buyoffer[_token]);
51 	   buyoffer[_token] = buyoffer[_token]-amount;
52 	   token deadToken = token(_token);
53 	   deadToken.transferFrom(msg.sender,owner,_qtd);
54 	   tokenReward.transfer(msg.sender, amount);
55 	}
56 	
57 }