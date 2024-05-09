1 pragma solidity ^0.4.4;
2 
3 /*
4 
5  _____ ___ ______ _____ _____ _____ _____    ___ ____________ _____
6 |_   _/ _ \| ___ |  __ |  ___|_   _|  _  |  / _ \| ___ | ___ /  ___|
7   | |/ /_\ | |_/ | |  \| |__   | | | | | | / /_\ | |_/ | |_/ \ `--.
8   | ||  _  |    /| | __|  __|  | | | | | | |  _  |  __/|  __/ `--. \
9   | || | | | |\ \| |_\ | |___  | | \ \_/ / | | | | |   | |   /\__/ /
10   \_/\_| |_\_| \_|\____\____/  \_/  \___/  \_| |_\_|   \_|   \____/
11 
12 */
13 
14 contract Token {
15 
16     /// @return total amount of tokens
17     function totalSupply() constant returns (uint256 supply) {}
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance) {}
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success) {}
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
35 
36     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of wei to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success) {}
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 
50 }
51 
52 contract StandardToken is Token {
53 
54     function transfer(address _to, uint256 _value) returns (bool success) {
55         require( now > 1548979261 );
56         //Default assumes totalSupply can't be over max (2^256 - 1).
57         if (balances[msg.sender] >= _value && _value > 0) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             emit Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
67             balances[_to] += _value;
68             balances[_from] -= _value;
69             allowed[_from][msg.sender] -= _value;
70             emit Transfer(_from, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         emit Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91     uint256 public totalSupply;
92 }
93 
94 contract AtpcCoin is StandardToken {
95 
96     /* Public variables of the token */
97 
98     string public name;
99     uint8 public decimals;
100     string public symbol;
101     string public version = 'H1.0';
102     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
103     uint256 public totalEthInWei;
104     address public fundsWallet;           // Where should the raised ETH go?
105     address public owner;
106     bool public isICOOver;
107     bool public isICOActive;
108 
109 
110     constructor() public {
111         balances[msg.sender] = 190800000000000000000000000;
112         totalSupply = 190800000000000000000000000;
113         name = "ATPC Coin";
114         decimals = 18;
115         symbol = "ATPC";
116         unitsOneEthCanBuy = 1460;
117         fundsWallet = msg.sender;
118         owner = msg.sender;
119         isICOOver = false;
120         isICOActive = true;
121     }
122 
123     modifier ownerFunc(){
124       require(msg.sender == owner);
125       _;
126     }
127 
128     function transferAdmin(address _to, uint256 _value) ownerFunc returns (bool success) {
129         //Default assumes totalSupply can't be over max (2^256 - 1).
130         if (balances[msg.sender] >= _value && _value > 0) {
131             balances[msg.sender] -= _value;
132             balances[_to] += _value;
133             emit Transfer(msg.sender, _to, _value);
134             return true;
135         } else { return false; }
136     }
137 
138     function changeICOState(bool isActive, bool isOver) public ownerFunc payable {
139       isICOOver = isOver;
140       isICOActive = isActive;
141     }
142 
143     function changePrice(uint256 price) public ownerFunc payable {
144       unitsOneEthCanBuy = price;
145     }
146 
147     function() public payable {
148         require(!isICOOver);
149         require(isICOActive);
150 
151         totalEthInWei = totalEthInWei + msg.value;
152         uint256 amount = msg.value * unitsOneEthCanBuy;
153         require(balances[fundsWallet] >= amount);
154 
155         balances[fundsWallet] = balances[fundsWallet] - amount;
156         balances[msg.sender] = balances[msg.sender] + amount;
157         emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
158 
159         //Transfer ether to fundsWallet
160         fundsWallet.transfer(msg.value);
161     }
162 
163     /* Approves and then calls the receiving contract */
164     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
165         allowed[msg.sender][_spender] = _value;
166         emit Approval(msg.sender, _spender, _value);
167 
168         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
169         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
170         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
171         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
172         return true;
173     }
174 }