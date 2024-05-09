1 /**
2  * Source Code first verified at https://etherscan.io on Sunday, April 28, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.4;
6 
7 contract Token {
8 
9     /// @return total amount of tokens
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) returns (bool success) {}
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
28 
29     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) returns (bool success) {}
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 
43 }
44 
45 contract StandardToken is Token {
46 
47     function transfer(address _to, uint256 _value) returns (bool success) {
48         //Default assumes totalSupply can't be over max (2^256 - 1).
49         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
50         //Replace the if with this one instead.
51         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
52         if (balances[msg.sender] >= _value && _value > 0) {
53             balances[msg.sender] -= _value;
54             balances[_to] += _value;
55             Transfer(msg.sender, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61         //same as above. Replace this line with the following if you want to protect against wrapping uints.
62         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
63         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
64             balances[_to] += _value;
65             balances[_from] -= _value;
66             allowed[_from][msg.sender] -= _value;
67             Transfer(_from, _to, _value);
68             return true;
69         } else { return false; }
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83       return allowed[_owner][_spender];
84     }
85 
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88     uint256 public totalSupply;
89 }
90 
91 contract Ujillvon is StandardToken { 
92 
93     /* Public variables of the token */
94 
95     /*
96     NOTE:
97     The following variables are OPTIONAL vanities. One does not have to include them.
98     They allow one to customise the token contract & in no way influences the core functionality.
99     Some wallets/interfaces might not even bother to look at this information.
100     */
101     string public name;                   // Token Name
102     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
103     string public symbol;                 // An identifier: eg SBX, XPR etc..
104     string public version = 'H1.0'; 
105     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
106     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
107     address public fundsWallet;           // Where should the raised ETH go?
108 
109 
110     // which means the following function name has to match the contract name declared above
111     function Ujillvon() {
112         balances[msg.sender] = 3000000000000000000000000000;
113         totalSupply = 3000000000000000000000000000;
114         name = "Ujillvon";
115         decimals = 18;
116             symbol = "ULV";
117         unitsOneEthCanBuy = 20000;
118         fundsWallet = msg.sender;
119     }
120     /** 
121    *  sale start 
122     * ---------------------
123     
124     * presale
125 	uint public presaleStartTime = 1537876800; // Saturday, 01 June 2019 19:00:00 GMT+07:00
126     uint256 public presalePerEth = 1075268;
127     
128     * ico
129     uint public icoStartTime = 1539190800; // Saturday, 15 June 2019 00:00:00 GMT+07:00
130     uint256 public icoPerEth = 1075268;
131     
132     * ico1
133     uint public ico1StartTime = 1540573200; // Monday, 01 July 2019 00:00:00 GMT+07:00
134     uint256 public ico1PerEth = 1075268;
135     
136     * ico2
137     uint public ico2StartTime = 1541955600; // Monday, 15 July 2019 00:00:00 GMT+07:00
138     uint256 public ico2PerEth = 1075268;
139     
140     * ico start and end
141     uint public icoOpenTime = presaleStartTime;
142     uint public icoEndTime = 1543251600; // Thursday, 01 August 2019 00:00:00 GMT+07:00
143     
144 	*/
145     
146     
147     
148 
149     function() payable{
150         totalEthInWei = totalEthInWei + msg.value;
151         uint256 amount = msg.value * unitsOneEthCanBuy;
152         require(balances[fundsWallet] >= amount);
153 
154         balances[fundsWallet] = balances[fundsWallet] - amount;
155         balances[msg.sender] = balances[msg.sender] + amount;
156 
157         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
158 
159         //Transfer ether to fundsWallet
160         fundsWallet.transfer(msg.value);                               
161     }
162 
163     /* Approves and then calls the receiving contract */
164     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
165         allowed[msg.sender][_spender] = _value;
166         Approval(msg.sender, _spender, _value);
167 
168         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
169         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
170         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
171         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
172         return true;
173     }
174 }