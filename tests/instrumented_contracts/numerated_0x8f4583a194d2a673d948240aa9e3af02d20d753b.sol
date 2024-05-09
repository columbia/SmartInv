1 pragma solidity ^0.4.25;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38     event setNewBlockEvent(string SecretKey_Pre, string Name_New, string TxHash_Pre, string DigestCode_New, string Image_New, string Note_New);
39 }
40 
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
46         //Replace the if with this one instead.
47         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48         if (balances[msg.sender] >= _value && _value > 0) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         //same as above. Replace this line with the following if you want to protect against wrapping uints.
58         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79         return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84     uint256 public totalSupply;
85 }
86 
87 contract ZivJillcoin is StandardToken {
88 
89     function ZivJillcoin() public { 
90         totalSupply = INITIAL_SUPPLY;
91         balances[msg.sender] = INITIAL_SUPPLY;
92     }
93     function () {
94         //if ether is sent to this address, send it back.
95         throw;
96     }
97 
98     /* Public variables of the token */
99 
100     /*
101     NOTE:
102     The following variables are OPTIONAL vanities. One does not have to include them.
103     They allow one to customise the token contract & in no way influences the core functionality.
104     Some wallets/interfaces might not even bother to look at this information.
105     */
106     string public name = "ZivJillcoin";
107     string public symbol = "ZJ";
108     uint public decimals = 0;
109     uint public INITIAL_SUPPLY = 520 * (10 ** decimals);
110     string public Image_root = "https://swarm-gateways.net/bzz:/13a2b8bb7a59e37de702f269206f489ae6c2a5994219f82100f6ed1453d0a939/";
111     string public Note_root = "";
112     string public DigestCode_root = "bf68e30522087834e4df15e3581ba0354ba5c8136e0a0dc0512542b7b88f4418";
113     function getIssuer() public view returns(string) { return  "MuseeDuLouvre"; }
114     function getSource() public view returns(string) { return  "https://swarm-gateways.net/bzz:/b516fb7e631390e55780c2134a2dbecc4efbbbde86ecd617143016f533716bc0/"; }
115     string public TxHash_root = "genesis";
116 
117     string public ContractSource = "";
118     string public CodeVersion = "v0.1";
119     
120     string public SecretKey_Pre = "";
121     string public Name_New = "";
122     string public TxHash_Pre = "";
123     string public DigestCode_New = "";
124     string public Image_New = "";
125     string public Note_New = "";
126 
127     function getName() public view returns(string) { return name; }
128     function getDigestCodeRoot() public view returns(string) { return DigestCode_root; }
129     function getTxHashRoot() public view returns(string) { return TxHash_root; }
130     function getImageRoot() public view returns(string) { return Image_root; }
131     function getNoteRoot() public view returns(string) { return Note_root; }
132     function getCodeVersion() public view returns(string) { return CodeVersion; }
133     function getContractSource() public view returns(string) { return ContractSource; }
134 
135     function getSecretKeyPre() public view returns(string) { return SecretKey_Pre; }
136     function getNameNew() public view returns(string) { return Name_New; }
137     function getTxHashPre() public view returns(string) { return TxHash_Pre; }
138     function getDigestCodeNew() public view returns(string) { return DigestCode_New; }
139     function getImageNew() public view returns(string) { return Image_New; }
140     function getNoteNew() public view returns(string) { return Note_New; }
141 
142     function setNewBlock(string _SecretKey_Pre, string _Name_New, string _TxHash_Pre, string _DigestCode_New, string _Image_New, string _Note_New )  returns (bool success) {
143         SecretKey_Pre = _SecretKey_Pre;
144         Name_New = _Name_New;
145         TxHash_Pre = _TxHash_Pre;
146         DigestCode_New = _DigestCode_New;
147         Image_New = _Image_New;
148         Note_New = _Note_New;
149         emit setNewBlockEvent(SecretKey_Pre, Name_New, TxHash_Pre, DigestCode_New, Image_New, Note_New);
150         return true;
151     }
152 
153     /* Approves and then calls the receiving contract */
154     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
155         allowed[msg.sender][_spender] = _value;
156         Approval(msg.sender, _spender, _value);
157 
158         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
159         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
160         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
161         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
162         return true;
163     }
164 }
