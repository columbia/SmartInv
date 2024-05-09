1 pragma solidity ^0.4.21;
2 
3 /*
4   
5     ****************************************************************
6     AVALANCHE BLOCKCHAIN GENESIS BLOCK COIN ALLOCATION TOKEN CONTRACT
7     ****************************************************************
8 
9     The Genesis Block in the Avalanche will deploy with pre-filled addresses
10     according to the results of this token sale.
11     
12     The Avalanche tokens will be sent to the Ethereum address that buys them.
13     
14     When the Avalanche blockchain deploys, all ethereum addresses that contains
15     Avalanche tokens will be credited with the equivalent AVALANCHE ICE (XAI) in the Genesis Block.
16 
17     There will be no developer premine. There will be no private presale. This is it.
18 
19     WARNING!! When the Avalanche Blockchain deploys this token contract will terminate!!
20     You will no longer be able to transfer or sell your tokens on the Ethereum Network.
21     Instead you will be the proud owner of native currency of the Avalanche Blockchain.
22     You will be able to recover Avalanche Funds using your Ethereum keys. DO NOT LOSE YOUR KEYS!
23     
24     @author CHRIS DCOSTA For Meek Inc 2018.
25     
26     Reference Code by Hunter Long
27     @repo https://github.com/hunterlong/ethereum-ico-contract
28 
29 */
30 
31 
32 contract BasicXAIToken {
33     uint256 public totalSupply;
34     bool public allowTransfer;
35 
36     function balanceOf(address _owner) public constant returns (uint256 balance);
37     function transfer(address _to, uint256 _value) public returns (bool success);
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
39     function approve(address _spender, uint256 _value) public returns (bool success);
40     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 contract StandardXAIToken is BasicXAIToken {
47 
48     function transfer(address _to, uint256 _value) public returns (bool success) {
49         require(allowTransfer);
50         require(balances[msg.sender] >= _value);
51         balances[msg.sender] -= _value;
52         balances[_to] += _value;
53         emit Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(allowTransfer);
59         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
60         balances[_to] += _value;
61         balances[_from] -= _value;
62         allowed[_from][msg.sender] -= _value;
63         emit Transfer(_from, _to, _value);
64         return true;
65     }
66 
67     function balanceOf(address _owner) public constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     function approve(address _spender, uint256 _value) public returns (bool success) {
72         require(allowTransfer);
73         allowed[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84 }
85 
86 
87 contract XAIToken is StandardXAIToken {
88 
89     string public name = "AVALANCHE TOKEN";
90     uint8 public decimals = 18;
91     string public symbol = "XAIT";
92     string public version = 'XAIT 0.1';
93     address public mintableAddress;
94     address public creator;
95 
96     constructor(address sale_address) public {
97         balances[msg.sender] = 0;
98         totalSupply = 0;
99         name = name;
100         decimals = decimals;
101         symbol = symbol;
102         mintableAddress = sale_address; // sale contract address
103         allowTransfer = true;
104         creator = msg.sender;
105         createTokens();
106     }
107 
108     // creates AVALANCHE ICE Tokens
109     // this address will hold all tokens
110     // all community contrubutions coins will be taken from this address
111     function createTokens() internal {
112         uint256 total = 4045084999529091000000000000;
113         balances[this] = total;
114         totalSupply = total;
115     }
116 
117     function changeTransfer(bool allowed) external {
118         require(msg.sender == mintableAddress);
119         require(allowTransfer);
120         allowTransfer = allowed;
121     }
122 
123     function mintToken(address to, uint256 amount) external returns (bool success) {
124         require(msg.sender == mintableAddress);
125         require(balances[this] >= amount);
126         balances[this] -= amount;
127         balances[to] += amount;
128         emit Transfer(this, to, amount);
129         return true;
130     }
131 
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         emit Approval(msg.sender, _spender, _value);
135 
136         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
137         return true;
138     }
139 
140     // This function kills the token when Avalanche Blockchain is deployed
141     function killAllXAITActivity() public {
142       require(msg.sender==creator);
143       allowTransfer = false;
144     }
145 }