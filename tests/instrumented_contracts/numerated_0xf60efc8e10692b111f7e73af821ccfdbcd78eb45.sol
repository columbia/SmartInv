1 pragma solidity ^0.4.19;
2 
3 contract FrikandelToken {
4     address public contractOwner = msg.sender; //King Frikandel
5 
6     bool public ICOEnabled = true; //Enable selling new Frikandellen
7     bool public Killable = true; //Enabled when the contract can commit suicide (In case of a problem with the contract in its early development, we will set this to false later on)
8 
9     mapping (address => uint256) balances; //This is where de lekkere frikandellen are stored
10     mapping (address => mapping (address => uint256)) allowed; //This is where approvals are stored!
11 
12     uint256 internal airdropLimit = 450000; //The maximum amount of tokens to airdrop before the feature shuts down
13     uint256 public airdropSpent = 0; //The amount of airdropped tokens given away (The airdrop will not send past this)
14     
15     //uint256 internal ownerDrop = 50000; //Lets not waste gas storing this solid value we will only use 1 time - Adding it here so its obvious though
16     uint256 public totalSupply = 500000; //We're reserving the airdrop tokens, they will be spent eventually. Combining that with the ownerDrop tokens we're at 500k
17     uint256 internal hardLimitICO = 750000; //Do not allow more then 750k frikandellen to exist, ever. (The ICO will not sell past this)
18 
19     function name() public pure returns (string) { return "Frikandel"; } //Frikandellen zijn lekker
20     function symbol() public pure returns (string) { return "FRIKANDEL"; } //I was deciding between FRKNDL and FRIKANDEL, but since the former is already kinda long why not just write it in full
21     function decimals() public pure returns (uint8) { return 0; } //Imagine getting half of a frikandel, that must be pretty shitty... Lets not do that. Whish we could store this as uint256 to save gas though lol
22 
23     function balanceOf(address _owner) public view returns (uint256) { return balances[_owner]; }
24 
25 	function FrikandelToken() public {
26 	    balances[contractOwner] = 50000; //To use for rewards and such - also I REALLY like frikandellen so don't judge please
27 	    Transfer(0x0, contractOwner, 50000); //Run a Transfer event for this as recommended by the ERC20 spec.
28 	}
29 	
30 	function transferOwnership(address _newOwner) public {
31 	    require(msg.sender == contractOwner); //:crying_tears_of_joy:
32 
33         contractOwner = _newOwner; //Nieuwe eigennaar van de frikandellentent
34 	}
35 	
36 	function Destroy() public {
37 	    require(msg.sender == contractOwner); //yo what why
38 	    
39 	    if (Killable == true){ //Only if the contract is killable.. Go ahead
40 	        selfdestruct(contractOwner);
41 	    }
42 	}
43 	
44 	function disableSuicide() public returns (bool success){
45 	    require(msg.sender == contractOwner); //u dont control me
46 	    
47 	    Killable = false; //The contract is now solid and will for ever be on the chain
48 	    return true;
49 	}
50 	
51     function Airdrop(address[] _recipients) public {
52         require(msg.sender == contractOwner); //no airdrop access 4 u
53         if((_recipients.length + airdropSpent) > airdropLimit) { revert(); } //Hey, you're sending too much!!
54         for (uint256 i = 0; i < _recipients.length; i++) {
55             balances[_recipients[i]] += 1; //One frikandelletje 4 u
56         }
57         airdropSpent += _recipients.length; //Store the amount of tokens that have been given away. Doing this once instead of in the loop saves a neat amount of gas! (If the code gets intreupted it gets reverted anyways)
58     }
59 	
60 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { //Useful if someone allowed you to spend some of their frikandellen or if a smart contract needs to interact with it! :)
61         //if (msg.data.length < (3 * 32) + 4) { revert(); } - Been thinking about implementing this, but its not fair to waste gas just to potentially ever save someone from sending a dumb malformed transaction, as a fault of their code or systems. (ERC20 Short address migration)
62         if (_value == 0) { Transfer(msg.sender, _to, 0); return; } //Follow the ERC20 spec and just mark the transfer event even through 0 tokens are being transfered
63 
64         //bool sufficientFunds = balances[_from] >= _value; (Not having this single use variable in there saves us 8 gas)
65         //bool sufficientAllowance = allowed[_from][msg.sender] >= _value;
66         if (allowed[_from][msg.sender] >= _value && balances[_from] >= _value) {
67             balances[_to] += _value;
68             balances[_from] -= _value;
69             
70             allowed[_from][msg.sender] -= _value;
71             
72             Transfer(_from, _to, _value);
73             return true;
74         } else { return false; } //ERC20 spec tells us the feature SHOULD throw() if the account has not authhorized the sender of the message, however I see everyone using return false... As its not a MUST to throw(), I'm going with the others and returning false
75     }
76 	
77 	function approve(address _spender, uint256 _value) public returns (bool success) { //Allow someone else to spend some of your frikandellen
78         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; } //ERC20 Spend/Approval race conditional migration - Always have a tx set the allowance to 0 first, before applying a new amount.
79         
80         allowed[msg.sender][_spender] = _value;
81         
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85     
86     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
87         if (allowed[msg.sender][_spender] >= allowed[msg.sender][_spender] + _addedValue) { revert(); } //Lets not overflow the allowance ;) (I guess this also prevents it from being increased by 0 as a nice extra)
88         allowed[msg.sender][_spender] += _addedValue;
89         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
90         return true;
91     }
92 	
93 	function allowance(address _owner, address _spender) constant public returns (uint256) {
94         return allowed[_owner][_spender];
95     }
96 
97     function transfer(address _to, uint256 _value) public returns (bool success) {
98         //if (msg.data.length < (2 * 32) + 4) { revert(); } - Been thinking about implementing this, but its not fair to waste gas just to potentially ever save someone from sending a dumb malformed transaction, as a fault of their code or systems. (ERC20 Short address migration)
99 
100         if (_value == 0) { Transfer(msg.sender, _to, 0); return; } //Follow the ERC20 specification and just trigger the event and quit the function since nothing is being transfered anyways
101 
102         //bool sufficientFunds = balances[msg.sender] >= _value; (Not having this single use variable in there saves us 8 gas)
103         //bool overflowed = balances[_to] + _value < balances[_to]; (Not having this one probably saves some too but I'm too lazy to test how much we save so fuck that)
104 
105         if (balances[msg.sender] >= _value && !(balances[_to] + _value < balances[_to])) {
106             balances[msg.sender] -= _value;
107             balances[_to] += _value;
108             
109             Transfer(msg.sender, _to, _value);
110             return true; //Smakelijk!
111         } else { return false; } //Sorry man je hebt niet genoeg F R I K A N D E L L E N
112     }
113 
114     event Transfer(address indexed _from, address indexed _to, uint256 _value);
115 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
116 
117     function enableICO() public {
118         require(msg.sender == contractOwner); //Bro stay of my contract
119         ICOEnabled = true;
120     }
121 
122     function disableICO() public {
123         require(msg.sender == contractOwner); //BRO what did I tell you
124         ICOEnabled = false; //Business closed y'all
125     }
126 
127     function() payable public {
128         require(ICOEnabled);
129         require(msg.value > 0); //You can't send nothing lol. It won't get you anything and I won't allow you to waste your precious gas on it! (You can send 1wei though, which will give you nothing in return either but still run the code below)
130         if(balances[msg.sender]+(msg.value / 1e14) > 50000) { revert(); } //This would give you more then 50000 frikandellen, you can't buy from this account anymore through the ICO (If you eat 50000 frikandellen you'd probably die for real from all the layers of fat)
131         if(totalSupply+(msg.value / 1e14) > hardLimitICO) { revert(); } //Hard limit on Frikandellen
132         
133         contractOwner.transfer(msg.value); //Thank you very much for supporting, I'll promise that I will spend an equal amount of money on purchaching frikandellen from my local store!
134 
135         uint256 tokensIssued = (msg.value / 1e14); //Since 1 token can be bought for 0.0001 ETH split the value (in Wei) through 1e14 to get the amount of tokens
136 
137         totalSupply += tokensIssued; //Lets note the tokens
138         balances[msg.sender] += tokensIssued; //Dinner is served (Or well, maybe just a snack... Kinda depends on how many frikandel you've bought)
139 
140         Transfer(address(this), msg.sender, tokensIssued); //Trigger a transfer() event :)
141     }
142 }