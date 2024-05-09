1 /*
2 This is the contract for Smart City Coin Test Net(SCCTN) 
3 
4 Smart City Coin Test Net(SCCTN) is utility token designed to be used as prepayment and payment in Smart City Shop.
5 
6 Smart City Coin Test Net(SCCTN) is utility token designed also to be proof of membership in Smart City Club.
7 
8 Token implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
9 
10 Smart City Coin Test Net is as the name implies Test Network - it was deployed in order to test functionalities, options, user interface, liquidity, price fluctuation, type of users, 
11 market research and get first-hand feedback from all involved. We ask all users to be aware of test nature of the token - have patience and preferably 
12 report all errors, opinions, shortcomings to our email address info@smartcitycoin.com. Ask for bounty program for reporting shortcomings and improvement of functionalities. 
13 
14 Smart City Coin Test Network is life real-world test with the goal to gather inputs for the Smart City Coin project.
15 
16 Smart City Coin Test Network is intended to be used by a skilled professional that understand and accept technology risk involved. 
17 
18 Smart City Coin Test Net and Smart City Shop are operated by Smart City AG.
19 
20 Smart City AG does not assume any liability for damages or losses occurred due to the usage of SCCTN, since as name implied this is test Network design to test technology and its behavior in the real world. 
21 
22 You can find all about the project on http://www.smartcitycointest.net
23 You can use your coins in https://www.smartcityshop.net/  
24 You can contact us at info@smartcitycoin.com 
25 */
26 
27 pragma solidity ^0.4.24;
28 contract Token {
29 
30     /// return total amount of tokens
31     function totalSupply() public pure returns (uint256) {}
32 
33     /// param _owner The address from which the balance will be retrieved
34     /// return The balance
35     function balanceOf(address) public payable returns (uint256) {}
36 
37     /// notice send `_value` token to `_to` from `msg.sender`
38     /// param _to The address of the recipient
39     /// param _value The amount of token to be transferred
40     /// return Whether the transfer was successful or not
41     function transfer(address , uint256 ) public payable returns (bool) {}
42 
43     /// notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
44     /// param _from The address of the sender
45     /// param _to The address of the recipient
46     /// param _value The amount of token to be transferred
47     /// return Whether the transfer was successful or not
48     function transferFrom(address , address , uint256 ) public payable returns (bool ) {}
49 
50     /// notice `msg.sender` approves `_addr` to spend `_value` tokens
51     /// param _spender The address of the account able to transfer the tokens
52     /// param _value The amount of wei to be approved for transfer
53     /// return Whether the approval was successful or not
54     function approve(address , uint256 ) public payable returns (bool ) {}
55 
56     /// param _owner The address of the account owning tokens
57     /// param _spender The address of the account able to transfer the tokens
58     /// return Amount of remaining tokens allowed to spent
59     function allowance(address , address ) public payable returns (uint256 ) {}
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }
64 
65 
66 /*
67 This implements implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
68 .*/
69 
70 contract StandardToken is Token {
71 
72     function transfer(address _to, uint256 _value) public payable returns (bool ) {
73         if (balances[msg.sender] >= _value && _value > 0) {
74             balances[msg.sender] -= _value;
75             balances[_to] += _value;
76             emit Transfer(msg.sender, _to, _value);
77             return true;
78         } else { return false; }
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) public payable returns (bool ) {
82         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
83             balances[_to] += _value;
84             balances[_from] -= _value;
85             allowed[_from][msg.sender] -= _value;
86             emit Transfer(_from, _to, _value);
87             return true;
88         } else { return false; }
89     }
90 
91     function balanceOf(address _owner) public payable  returns (uint256 ) {
92         return balances[_owner];
93     }
94 
95     function approve(address _spender, uint256 _value) public payable returns (bool ) {
96         allowed[msg.sender][_spender] = _value;
97         emit Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender) public payable returns (uint256 a ) {
102       return allowed[_owner][_spender];
103     }
104 
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;
107     uint256 public totalSupply;
108 }
109 
110 /*
111 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
112 
113 This Token will be deployed, and then used by humans - members of Smart City Community - as an utility token as a prepayment for services and Smart House Hardware in SmartCityShop - www.smartcityshop.net .
114 
115 This token specify
116 1) Initial Finite Supply (upon creation one specifies how much is minted).
117 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
118 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
119 
120 .*/
121 
122 contract SmartCityCoinTestNet is StandardToken {
123 
124     function () public {
125         //if ether is sent to this address, send it back.
126         revert();
127     }
128 
129     /* Public variables of the token */
130 
131     /*
132     NOTE:
133     We've inlcuded the following variables as OPTIONAL vanities. 
134     They in no way influences the core functionality.
135     Some wallets/interfaces might not even bother to look at this information.
136     */
137     string public name;                   //fancy name: eg Simon Bucks
138     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
139     string public symbol;                 //An identifier: eg SBX
140     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
141 
142     constructor (
143         uint256 _initialAmount,
144         string _tokenName,
145         uint8 _decimalUnits,
146         string _tokenSymbol
147         ) public {
148         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
149         totalSupply = _initialAmount;                        // Update total supply
150         name = _tokenName;                                   // Set the name for display purposes
151         decimals = _decimalUnits;                            // Amount of decimals for display purposes
152         symbol = _tokenSymbol;                               // Set the symbol for display purposes
153     }
154 
155     /* Approves and then calls the receiving contract */
156     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public payable returns (bool )  {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159 
160         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
161         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
162         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
163         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
164         return true;
165     }
166 }