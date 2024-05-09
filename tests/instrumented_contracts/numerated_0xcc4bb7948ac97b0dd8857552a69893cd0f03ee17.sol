1 pragma solidity ^0.4.19;
2 
3 contract Frikandel {
4     address creator = msg.sender; //King Frikandel
5 
6     bool public Enabled = true; //Enable selling new Frikandellen
7     bool internal Killable = true; //Enabled when the contract can commit suicide (In case of a problem with the contract in its early development, we will set this to false later on)
8 
9     mapping (address => uint256) balances;
10     mapping (address => mapping (address => uint256)) allowed;
11 
12     uint256 public totalSupply = 500000; //500k Frikandellen (y'all ready for some airdrop??)
13     uint256 public hardLimitICO = 750000; //Do not allow more then 750k frikandellen to exist, ever. (The ICO will not sell past this)
14 
15     function name() public pure returns (string) { return "Frikandel"; } //Frikandellen zijn lekker
16     function symbol() public pure returns (string) { return "FRKNDL"; }
17     function decimals() public pure returns (uint8) { return 0; } //Imagine getting half of a frikandel, that must be pretty shitty... Lets not do that
18 
19     function balanceOf(address _owner) public view returns (uint256) { return balances[_owner]; }
20 
21 	function Frikandel() public {
22 	    balances[creator] = totalSupply; //Lets get this started :)
23 	}
24 	
25 	function Destroy() public {
26 	    if (msg.sender != creator) { revert(); } //yo what why
27 	    
28 	    if ((balances[creator] > 25000) && Killable == true){ //Only if the owner has more then 25k (indicating the airdrop was not finished yet) and the contract is killable.. Go ahead
29 	        selfdestruct(creator);
30 	    }
31 	}
32 	
33 	function DisableSuicide() public returns (bool success){
34 	    if (msg.sender != creator) { revert(); } //u dont control me
35 	    
36 	    Killable = false;
37 	    return true;
38 	}
39 
40     function transfer(address _to, uint256 _value) public returns (bool success) {
41         if(msg.data.length < (2 * 32) + 4) { revert(); } //Something wrong yo
42 
43         if (_value == 0) { return false; } //y try to transfer without specifying any???
44 
45         uint256 fromBalance = balances[msg.sender];
46 
47         bool sufficientFunds = fromBalance >= _value;
48         bool overflowed = balances[_to] + _value < balances[_to];
49 
50         if (sufficientFunds && !overflowed) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             
54             Transfer(msg.sender, _to, _value);
55             return true; //Smakelijk!
56         } else { return false; } //Sorry man je hebt niet genoeg F R I K A N D E L L E N
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
60         if(msg.data.length < (3 * 32) + 4) { revert(); } //Something wrong yo
61 
62         if (_value == 0) { return false; }
63 
64         uint256 fromBalance = balances[_from];
65         uint256 allowance = allowed[_from][msg.sender];
66 
67         bool sufficientFunds = fromBalance <= _value;
68         bool sufficientAllowance = allowance <= _value;
69         bool overflowed = balances[_to] + _value > balances[_to];
70 
71         if (sufficientFunds && sufficientAllowance && !overflowed) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             
75             allowed[_from][msg.sender] -= _value;
76             
77             Transfer(_from, _to, _value);
78             return true;
79         } else { return false; }
80     }
81 
82     function approve(address _spender, uint256 _value) internal returns (bool success) {
83         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
84         
85         allowed[msg.sender][_spender] = _value;
86         
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) public view returns (uint256) {
92         return allowed[_owner][_spender];
93     }
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 
98     function enable() public {
99         if (msg.sender != creator) { revert(); } //Bro stay of my contract
100         Enabled = true;
101     }
102 
103     function disable() public {
104         if (msg.sender != creator) { revert(); } //BRO what did I tell you
105         Enabled = false;
106     }
107 
108     function() payable public {
109         if (!Enabled) { revert(); }
110         if(balances[msg.sender]+(msg.value / 1e14) > 30000) { revert(); } //This would give you more then 30000 frikandellen, you can't buy from this account anymore through the ICO
111         if(totalSupply+(msg.value / 1e14) > hardLimitICO) { revert(); } //Hard limit on Frikandellen
112         if (msg.value == 0) { return; }
113 
114         creator.transfer(msg.value);
115 
116         uint256 tokensIssued = (msg.value / 1e14); //Since 1 token can be bought for 0.0001 ETH split the value (in Wei) through 1e14 to get the amount of tokens
117 
118         totalSupply += tokensIssued;
119         balances[msg.sender] += tokensIssued;
120 
121         Transfer(address(this), msg.sender, tokensIssued);
122     }
123 }