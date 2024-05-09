1 pragma solidity ^0.4.23;
2 
3 contract Token {
4 
5   /// @return total amount of tokens
6   function totalSupply() view public returns (uint256 supply) {}
7 
8   /// @param _owner The address from which the balance will be retrieved
9   /// @return The balance
10   function balanceOf(address _owner) view public returns (uint256 balance) {}
11 
12   /// @notice send `_value` token to `_to` from `msg.sender`
13   /// @param _to The address of the recipient
14   /// @param _value The amount of token to be transferred
15   /// @return Whether the transfer was successful or not
16   function transfer(address _to, uint256 _value) public returns (bool success) {}
17 
18   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19   /// @param _from The address of the sender
20   /// @param _to The address of the recipient
21   /// @param _value The amount of token to be transferred
22   /// @return Whether the transfer was successful or not
23   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
24 
25   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26   /// @param _spender The address of the account able to transfer the tokens
27   /// @param _value The amount of wei to be approved for transfer
28   /// @return Whether the approval was successful or not
29   function approve(address _spender, uint256 _value) public returns (bool success) {}
30 
31   /// @param _owner The address of the account owning tokens
32   /// @param _spender The address of the account able to transfer the tokens
33   /// @return Amount of remaining tokens allowed to spent
34   function allowance(address _owner, address _spender) view public returns (uint256 remaining) {}
35 
36   event Transfer(address indexed _from, address indexed _to, uint256 _value);
37   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38     
39 }
40 
41 
42 contract StandardToken is Token {
43 
44   function transfer(address _to, uint256 _value) public returns (bool success) {
45     if (balances[msg.sender] >= _value && _value > 0) {
46       balances[msg.sender] -= _value;
47       balances[_to] += _value;
48       emit Transfer(msg.sender, _to, _value);
49       return true;
50     } else { 
51       return false;
52       }
53   }
54 
55   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
56     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57       balances[_to] += _value;
58       balances[_from] -= _value;
59       allowed[_from][msg.sender] -= _value;
60       emit Transfer(_from, _to, _value);
61       return true;
62     } else {
63       return false;
64       }
65   }
66 
67   function balanceOf(address _owner) view public returns (uint256 balance) {
68     return balances[_owner];
69   }
70 
71   function approve(address _spender, uint256 _value) public returns (bool success) {
72     allowed[msg.sender][_spender] = _value;
73     emit Approval(msg.sender, _spender, _value);
74     return true;
75   }
76 
77   function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
78     return allowed[_owner][_spender];
79   }
80 
81   mapping (address => uint256) balances;
82   mapping (address => mapping (address => uint256)) allowed;
83   uint256 public totalSupply;
84 }
85 
86 
87 contract WORLD1Coin is StandardToken {
88 
89   /* Public variables of the token */
90 
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96   string public name;                   
97   uint8 public decimals;                
98   string public symbol;                 
99   string public version = "H1.0";  
100   address public owner;
101   bool public tokenIsLocked;
102   mapping (address => uint256) lockedUntil;
103 
104   constructor() public {
105     owner = 0x04c63DC704b7F564870961dd2286F75bCb3A98E2;
106     totalSupply = 300000000 * 1000000000000000000;
107     balances[owner] = totalSupply;                 
108     name = "Worldcoin1";                                // Token Name
109     decimals = 18;                                      // Amount of decimals for display purposes
110     symbol = "WRLD1";                                    // Token Symbol
111   }
112 
113   /* Approves and then calls the receiving contract */
114   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
115     allowed[msg.sender][_spender] = _value;
116     emit Approval(msg.sender, _spender, _value);
117 
118     if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
119       revert();
120       }
121     return true;
122   }
123 
124   function transfer(address _to, uint256 _value) public returns (bool success) {
125     if (msg.sender == owner || !tokenIsLocked) {
126       return super.transfer(_to, _value);
127     } else {
128       revert();
129     }
130   }
131 
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
133     if (msg.sender == owner || !tokenIsLocked) {
134       return super.transferFrom(_from, _to, _value);
135     } else {
136       revert();
137     }
138   }
139   
140   function killContract() onlyOwner public {
141     selfdestruct(owner);
142   }
143 
144   function lockTransfers() onlyOwner public {
145     tokenIsLocked = true;
146   }
147 
148 }