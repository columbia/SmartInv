1 pragma solidity ^0.4.19;
2 
3 contract FrikandelToken {
4     address public contractOwner = msg.sender; //King Frikandel
5 
6     bool public ICOEnabled = true; //Enable selling new Frikandellen
7     bool public Killable = true; //Enabled when the contract can commit suicide (In case of a problem with the contract in its early development, we will set this to false later on)
8 
9     mapping (address => uint256) balances;
10 
11     uint256 public totalSupply = 500000; //500k Frikandellen (y'all ready for some airdrop??)
12     uint256 internal hardLimitICO = 750000; //Do not allow more then 750k frikandellen to exist, ever. (The ICO will not sell past this)
13 
14     function name() public pure returns (string) { return "Frikandel"; } //Frikandellen zijn lekker
15     function symbol() public pure returns (string) { return "FRKNDL"; }
16     function decimals() public pure returns (uint8) { return 0; } //Imagine getting half of a frikandel, that must be pretty shitty... Lets not do that
17 
18     function balanceOf(address _owner) public view returns (uint256) { return balances[_owner]; }
19 
20 	function FrikandelToken() public {
21 	    balances[contractOwner] = totalSupply; //Lets get this started :)
22 	}
23 	
24 	function transferOwnership(address newOwner) public {
25 	    if (msg.sender != contractOwner) { revert(); } //:crying_tears_of_joy:
26 
27         contractOwner = newOwner; //Nieuwe eigennaar van de frikandellentent
28 	}
29 	
30 	function Destroy() public {
31 	    if (msg.sender != contractOwner) { revert(); } //yo what why
32 	    
33 	    if (Killable == true){ //Only if the contract is killable.. Go ahead
34 	        selfdestruct(contractOwner);
35 	    }
36 	}
37 	
38 	function DisableSuicide() public returns (bool success){
39 	    if (msg.sender != contractOwner) { revert(); } //u dont control me
40 	    
41 	    Killable = false;
42 	    return true;
43 	}
44 
45     function transfer(address _to, uint256 _value) public returns (bool success) {
46         if(msg.data.length < (2 * 32) + 4) { revert(); } //Something wrong yo
47 
48         if (_value == 0) { return false; } //y try to transfer without specifying any???
49 
50         uint256 fromBalance = balances[msg.sender];
51 
52         bool sufficientFunds = fromBalance >= _value;
53         bool overflowed = balances[_to] + _value < balances[_to];
54 
55         if (sufficientFunds && !overflowed) {
56             balances[msg.sender] -= _value;
57             balances[_to] += _value;
58             
59             Transfer(msg.sender, _to, _value);
60             return true; //Smakelijk!
61         } else { return false; } //Sorry man je hebt niet genoeg F R I K A N D E L L E N
62     }
63 
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65 
66     function enableICO() public {
67         if (msg.sender != contractOwner) { revert(); } //Bro stay of my contract
68         ICOEnabled = true;
69     }
70 
71     function disableICO() public {
72         if (msg.sender != contractOwner) { revert(); } //BRO what did I tell you
73         ICOEnabled = false;
74     }
75 
76     function() payable public {
77         if (!ICOEnabled) { revert(); }
78         if(balances[msg.sender]+(msg.value / 1e14) > 30000) { revert(); } //This would give you more then 30000 frikandellen, you can't buy from this account anymore through the ICO
79         if(totalSupply+(msg.value / 1e14) > hardLimitICO) { revert(); } //Hard limit on Frikandellen
80         if (msg.value == 0) { return; }
81 
82         contractOwner.transfer(msg.value);
83 
84         uint256 tokensIssued = (msg.value / 1e14); //Since 1 token can be bought for 0.0001 ETH split the value (in Wei) through 1e14 to get the amount of tokens
85 
86         totalSupply += tokensIssued;
87         balances[msg.sender] += tokensIssued;
88 
89         Transfer(address(this), msg.sender, tokensIssued);
90     }
91 }