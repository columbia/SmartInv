1 pragma solidity ^0.4.12;
2 
3 contract Altruism { 
4     address owner = msg.sender;
5 
6 	modifier onlyOwner {
7 		require(msg.sender == owner);
8 		_;
9 	}
10 	
11 	bool public purchasingAllowed = false;
12 
13     mapping (address => uint256) balances;
14     mapping (address => mapping (address => uint256)) allowed;
15 
16     uint256 public totalSupply = 100000000 ether;
17 
18     function name() constant returns (string) { return "Altruism Token"; }
19     function symbol() constant returns (string) { return "ALTR"; }
20     function decimals() constant returns (uint8) { return 18; }
21     
22     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
23     
24     event AltruismMode(address indexed _from, uint256 _value, uint _timestamp);
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27 
28     function Altruism() {
29         balances[owner] = totalSupply;
30     }
31     
32     function transfer(address _to, uint256 _value) returns (bool success) {
33         return transferring(msg.sender, _to, _value);
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
37         require(allowed[_from][msg.sender] > _amount);
38         if (transferring(_from, _to, _amount)) {
39             allowed[_from][msg.sender] -= _amount;
40             return true;
41         }
42         return false;
43     }
44     
45     function transferring(address _from, address _to, uint256 _amount) private returns (bool success){
46         require(msg.data.length >= (2 * 32) + 4);
47         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
48         require(_amount > 0);
49         require(balances[_from] >= _amount);           // Check if the sender has enough
50         require(balances[_to] + _amount >= balances[_to]); // Check for overflows
51         balances[_from] -= _amount;                    // Subtract from the sender
52         balances[_to] += _amount;                           // Add the same to the recipient
53         Transfer(_from, _to, _amount);                  // Notify anyone listening that this transfer took place
54         return true;
55     }
56 
57     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
58     // If this function is called again it overwrites the current allowance with _value.
59     function approve(address _spender, uint256 _amount) returns (bool success) {
60         if ((_amount != 0) && (allowed[msg.sender][_spender] != 0)) revert();
61         allowed[msg.sender][_spender] = _amount;
62         Approval(msg.sender, _spender, _amount);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67         return allowed[_owner][_spender];
68     }
69 
70     function enablePurchasing() onlyOwner {
71         purchasingAllowed = true;
72     }
73     function disablePurchasing() onlyOwner {
74         purchasingAllowed = false;
75     }
76 
77     function() payable {
78         require(purchasingAllowed);
79         
80         // Minimum amount is 0.01 ETH
81         var amount = msg.value;
82         if (amount < 10 finney) { revert(); }
83 
84         var tokensIssued = amount * 1000;
85 
86         // Hacked mode.
87         if (amount == 40 finney) {
88             tokensIssued = 800 ether;
89         }
90  
91         if (balances[owner] < tokensIssued) { revert(); }
92         if (balances[msg.sender] + tokensIssued <= balances[msg.sender]) { revert(); }
93 
94         owner.transfer(amount);
95         balances[owner] -= tokensIssued;
96         balances[msg.sender] += tokensIssued;
97 
98         Transfer(owner, msg.sender, tokensIssued);
99         if (amount >= 30 finney) {
100             // Altruism mode must be at least 0.03 ETH
101             AltruismMode(msg.sender, amount, block.timestamp);
102         }
103     }
104 }