1 /**
2  *  Ether Carbon Token, ERC20 compliant (see https://github.com/ethereum/EIPs/issues/20)
3  *
4  *  Code is based on multiple sources:
5  *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20.sol
6  *  https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/HumanStandardToken.sol
7  */
8 
9 pragma solidity ^0.4.13;
10 
11 
12 contract Token {
13     /* This is a slight change to the ERC20 base standard.
14     function totalSupply() constant returns (uint256 supply);
15     is replaced with:
16     uint256 public totalSupply;
17     This automatically creates a getter function for the totalSupply.
18     This is moved to the base contract since public getter functions are not
19     currently recognised as an implementation of the matching abstract
20     function by the compiler.
21     */
22     /// total amount of tokens
23     uint256 public totalSupply;
24 
25     /// @param _owner The address from which the balance will be retrieved
26     /// @return The balance
27     function balanceOf(address _owner) constant returns (uint256 balance);
28 
29     /// @notice send `_value` token to `_to` from `msg.sender`
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transfer(address _to, uint256 _value) returns (bool success);
34 
35     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
36     /// @param _from The address of the sender
37     /// @param _to The address of the recipient
38     /// @param _value The amount of token to be transferred
39     /// @return Whether the transfer was successful or not
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41 
42     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @param _value The amount of tokens to be approved for transfer
45     /// @return Whether the approval was successful or not
46     function approve(address _spender, uint256 _value) returns (bool success);
47 
48     /// @param _owner The address of the account owning tokens
49     /// @param _spender The address of the account able to transfer the tokens
50     /// @return Amount of remaining tokens allowed to spent
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
52 
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 
58 contract StandardToken is Token {
59 
60     function transfer(address _to, uint256 _value) returns (bool success) {
61         require(_to != 0x00);
62         if (balances[msg.sender] >= _value && _value > 0) {
63             balances[msg.sender] -= _value;
64             balances[_to] += _value;
65             Transfer(msg.sender, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96     address owner;
97 }
98 
99 
100 
101 contract  EtherCarbon is StandardToken {
102 
103     
104     /* Public variables of the token */
105     string public name = " EtherCarbon";
106     uint256 public decimals = 2;
107     string public symbol = "ECN";
108     
109     event Mint(address indexed owner,uint amount);
110     
111     function EtherCarbon() {
112         owner = 0x9362586f90abad2D25309033320C9Affc97AEb7D;
113         /* Total supply is Five million (5,000,000)*/
114         balances[0x9362586f90abad2D25309033320C9Affc97AEb7D] = 5000000 * 10**decimals;
115         totalSupply = 5000000 * 10**decimals;
116     }
117 
118     function mint(uint amount) onlyOwner returns(bool minted ){
119         if (amount > 0){
120             totalSupply += amount;
121             balances[owner] += amount;
122             Mint(msg.sender,amount);
123             return true;
124         }
125         return false;
126     }
127 
128     modifier onlyOwner() { 
129         if (msg.sender != owner) revert(); 
130         _; 
131     }
132     
133     function setOwner(address _owner) onlyOwner{
134         balances[_owner] = balances[owner];
135         balances[owner] = 0;
136         owner = _owner;
137     }
138 
139 }