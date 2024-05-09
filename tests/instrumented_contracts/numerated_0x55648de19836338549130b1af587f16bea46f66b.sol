1 pragma solidity ^0.4.18;
2 
3 /**
4  * ERC 20 token
5  * https://github.com/ethereum/EIPs/issues/20
6  */
7 interface Token {
8 
9     /// @return total amount of tokens
10     /// function totalSupply() public constant returns (uint256 supply);
11     /// do not declare totalSupply() here, see https://github.com/OpenZeppelin/zeppelin-solidity/issues/434
12 
13     /// @param _owner The address from which the balance will be retrieved
14     /// @return The balance
15     function balanceOf(address _owner) public constant returns (uint256 balance);
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transfer(address _to, uint256 _value) public returns (bool success);
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29 
30     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of wei to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) public returns (bool success);
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44 }
45 
46 
47 /** @title Publica Pebbles (PBL contract) **/
48 
49 contract Pebbles is Token {
50 
51     string public constant name = "Pebbles";
52     string public constant symbol = "PBL";
53     uint8 public constant decimals = 18;
54     uint256 public constant totalSupply = 33787150 * 10**18;
55 
56     uint public launched = 0; // Time of locking distribution and retiring founder; 0 means not launched
57     address public founder = 0xa99Ab2FcC5DdFd5c1Cbe6C3D760420D2dDb63d99; // Founder's address
58     address public team = 0xe32A4bb42AcE38DcaAa7f23aD94c41dE0334A500; // Team's address
59     address public treasury = 0xc46e5D11754129790B336d62ee90b12479af7cB5; // Treasury address
60     mapping (address => uint256) public balances;
61     mapping (address => mapping (address => uint256)) public allowed;
62     uint256 public balanceTeam = 0; // Actual Team's frozen balance = balanceTeam - withdrawnTeam
63     uint256 public withdrawnTeam = 0;
64     uint256 public balanceTreasury = 0; // Treasury's frozen balance
65 
66     function Pebbles() public {
67         balances[founder] = totalSupply;
68     }
69 
70     function transfer(address _to, uint256 _value) public returns (bool success) {
71         if (balances[msg.sender] < _value) {
72             return false;
73         }
74         balances[msg.sender] -= _value;
75         balances[_to] += _value;
76         Transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
82             return false;
83         }
84         allowed[_from][msg.sender] -= _value;
85         balances[_from] -= _value;
86         balances[_to] += _value;
87         Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function balanceOf(address _owner) public constant returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95     function approve(address _spender, uint256 _value) public returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
102         return allowed[_owner][_spender];
103     }
104 
105     /**@dev Launch and retire the founder */
106     function launch() public {
107         require(msg.sender == founder);
108         launched = block.timestamp;
109         founder = 0x0;
110     }
111 
112     /**@dev Give _value PBLs to balances[team] during 5 years (20% per year) after launch
113      * @param _value Number of PBLs
114      */
115     function reserveTeam(uint256 _value) public {
116         require(msg.sender == founder);
117         require(balances[founder] >= _value);
118         balances[founder] -= _value;
119         balanceTeam += _value;
120     }
121 
122     /**@dev Give _value PBLs to balances[treasury] after 3 months after launch
123      * @param _value Number of PBLs
124      */
125     function reserveTreasury(uint256 _value) public {
126         require(msg.sender == founder);
127         require(balances[founder] >= _value);
128         balances[founder] -= _value;
129         balanceTreasury += _value;
130     }
131 
132     /**@dev Unfreeze some tokens for team and treasury, if the time has come
133      */
134     function withdrawDeferred() public {
135         require(msg.sender == team);
136         require(launched != 0);
137         uint yearsSinceLaunch = (block.timestamp - launched) / 1 years;
138         if (yearsSinceLaunch < 5) {
139             uint256 teamTokensAvailable = balanceTeam / 5 * yearsSinceLaunch;
140             balances[team] += teamTokensAvailable - withdrawnTeam;
141             withdrawnTeam = teamTokensAvailable;
142         } else {
143             balances[team] += balanceTeam - withdrawnTeam;
144             balanceTeam = 0;
145             withdrawnTeam = 0;
146             team = 0x0;
147         }
148         if (block.timestamp - launched >= 90 days) {
149             balances[treasury] += balanceTreasury;
150             balanceTreasury = 0;
151             treasury = 0x0;
152         }
153     }
154 
155     function() public { // no direct purchases
156         revert();
157     }
158 
159 }