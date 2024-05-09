1 pragma solidity ^0.4.24;
2 /**
3  * Implementation of the basic standard token
4  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
5  */
6 contract TokenERC20 {
7     // [ERC20] the name of the token - e.g. "Vehicle Owner’s Benefit"
8     string public name;
9     // [ERC20] the symbol of the token. E.g. "VOB".
10     string public symbol;
11     // [ERC20] the total token supply
12     uint256 public totalSupply;
13     // [ERC20] the number of decimals the token uses - e.g. 18
14     uint8 public decimals = 18;
15 
16     // [ERC20] the account balance of another account with address _owner
17     mapping (address => uint256) public balanceOf;
18 
19     // [ERC20]the amount which _spender is still allowed to withdraw from _owner.
20     mapping(address => mapping(address => uint256)) allowance;
21 
22 
23     mapping (address => uint256) public freezeOf;
24 
25     // [ERC20] MUST trigger when tokens are transferred, including zero value transfers.
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     // [ERC20] MUST trigger on any successful call to approve
29     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
30 
31     // This notifies clients about the amount frozen
32     event Freeze(address indexed from, uint256 value);
33 
34     // This notifies clients about the amount unfrozen
35     event Unfreeze(address indexed from, uint256 value);
36 
37     constructor(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimalUnits) public {
38         totalSupply = _initialSupply;
39         balanceOf[msg.sender] = totalSupply;
40         name = _tokenName;
41         symbol = _tokenSymbol;
42         decimals = _decimalUnits;
43     }
44 
45     /**
46      * Transfers _value amount of tokens to address _to, and MUST fire the Transfer event.
47      */
48     function _transfer(address _from, address _to, uint256 _value) internal {
49 
50         // the _to account address is not invalid
51         require(_to != 0x0);
52 
53         // the _from account balance has enough tokens to spend
54         require(balanceOf[_from] >= _value);
55 
56         // the _to account balance must not be overflowing after transfer
57         require(balanceOf[_to] + _value >= balanceOf[_to]);
58 
59         balanceOf[_from] -= _value;
60         balanceOf[_to] += _value;
61 
62         // emit event
63         emit Transfer(_from, _to, _value);
64     }
65 
66     /**
67      * [ERC20]
68      * Transfers _value amount of tokens to address _to, and MUST fire the Transfer event.
69      * The function SHOULD throw if the _from account balance does not have enough tokens to spend.
70      *
71      * Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
72      */
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74 
75         _transfer(msg.sender, _to, _value);
76 
77         return true;
78     }
79 
80     /**
81      * [ERC20]
82      * Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
83      * The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf.
84      * This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in sub-currencies.
85      * The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism.
86      *
87      * Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
88      */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         require(allowance[_from][msg.sender] >= _value);     // Check allowance
91         allowance[_from][msg.sender] -= _value;
92         _transfer(_from, _to, _value);
93         return true;
94     }
95 
96     /**
97      * [ERC20]
98      * Allows _spender to withdraw from your account multiple times, up to the _value amount.
99      * If this function is called again it overwrites the current allowance with _value.
100      *
101      * NOTE: To prevent attack vectors like the one described here and discussed here,
102      * clients SHOULD make sure to create user interfaces in such a way that they set the allowance first to 0 before setting it to another value for the same spender.
103      * THOUGH The contract itself shouldn't enforce it, to allow backwards compatibility with contracts deployed before
104      *
105      */
106     function approve(address _spender, uint256 _value) public returns (bool success) {
107         allowance[msg.sender][_spender] = _value;
108         emit Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function freeze(uint256 _value) returns (bool success) {
113         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
114         require(_value > 0);
115         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
116         freezeOf[msg.sender] += _value;
117         Freeze(msg.sender, _value);
118         return true;
119     }
120 
121     function unfreeze(uint256 _value) returns (bool success) {
122         require(freezeOf[msg.sender]>= _value);            // Check if the sender has enough
123         require(_value > 0);
124         freezeOf[msg.sender] -= _value;                      // Subtract from the sender
125         balanceOf[msg.sender] += _value;
126         Unfreeze(msg.sender, _value);
127         return true;
128     }
129 
130 
131 
132 }