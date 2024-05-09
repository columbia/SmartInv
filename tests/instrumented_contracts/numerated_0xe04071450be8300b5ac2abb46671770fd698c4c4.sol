1 pragma solidity >=0.4.0 <0.6.0;
2 
3 /*
4 
5   ___   _____  _____  _____    ___ ____________ _____
6  / _ \ |_   _|| ___  |  ___| / _ \| ___ | ___ /  ___|
7 / /_\ |  | |  | |_/ /| |     / /_\ | |_/ | |_/ \ `--.
8 |  _  |  | |  |  __/|| |     |  _  |  __/|  __/ `--. \
9 | | | |  | |  | |   || |___  | | | | |   | |   /\__/ /
10 \_| |_\  \_/\ \_|   \|\_____ \_| |_\_|   \_|   \____/
11 
12 
13 */
14 
15 contract Token {
16 
17     /// @return total amount of tokens
18     function totalSupply() constant returns (uint256 supply) {}
19 
20     /// @param _owner The address from which the balance will be retrieved
21     /// @return The balance
22     function balanceOf(address _owner) constant returns (uint256 balance) {}
23 
24     /// @notice send `_value` token to `_to` from `msg.sender`
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transfer(address _to, uint256 _value) returns (bool success) {}
29 
30     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
31     /// @param _from The address of the sender
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
36 
37     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @param _value The amount of wei to be approved for transfer
40     /// @return Whether the approval was successful or not
41     function approve(address _spender, uint256 _value) returns (bool success) {}
42 
43     /// @param _owner The address of the account owning tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @return Amount of remaining tokens allowed to spent
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
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
101     string public version = 'H1.2';
102     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
103     uint256 public totalEthInWei;
104     address public fundsWallet;           // Where should the raised ETH go?
105     address public owner;
106     bool public isICOOver;
107     bool public isICOActive;
108 
109     constructor() public {
110         balances[msg.sender] = 190800000000000000000000000;
111         totalSupply = 190800000000000000000000000;
112         name = "ATPC Coin";
113         decimals = 18;
114         symbol = "ATPC";
115         unitsOneEthCanBuy = 259;
116         fundsWallet = msg.sender;
117         owner = msg.sender;
118         isICOOver = false;
119         isICOActive = true;
120     }
121 
122     modifier ownerFunc(){
123       require(msg.sender == owner);
124       _;
125     }
126 
127     function transferAdmin(address _to, uint256 _value) ownerFunc returns (bool success) {
128         //Default assumes totalSupply can't be over max (2^256 - 1).
129         if (balances[msg.sender] >= _value && _value > 0) {
130             balances[msg.sender] -= _value;
131             balances[_to] += _value;
132             emit Transfer(msg.sender, _to, _value);
133             return true;
134         } else { return false; }
135     }
136     function close() public ownerFunc {
137         selfdestruct(owner);
138     }
139 
140 
141     function changeICOState(bool isActive, bool isOver) public ownerFunc payable {
142       isICOOver = isOver;
143       isICOActive = isActive;
144     }
145 
146     function changePrice(uint256 price) public ownerFunc payable {
147       unitsOneEthCanBuy = price;
148     }
149 
150     function() public payable {
151         require(!isICOOver);
152         require(isICOActive);
153 
154         totalEthInWei = totalEthInWei + msg.value;
155         uint256 amount = msg.value * unitsOneEthCanBuy;
156         require(balances[fundsWallet] >= amount);
157 
158         balances[fundsWallet] = balances[fundsWallet] - amount;
159         balances[msg.sender] = balances[msg.sender] + amount;
160         emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
161 
162         //Transfer ether to fundsWallet
163         fundsWallet.transfer(msg.value);
164     }
165     
166     /* Approves and then calls the receiving contract */
167     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
168         allowed[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170 
171         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
172         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
173         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
174         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
175         return true;
176     }
177 }