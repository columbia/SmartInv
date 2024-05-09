1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner public {
34     require(newOwner != address(0));
35     OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 }
39 
40 /**
41  * @title Destructible
42  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
43  */
44 contract Destructible is Ownable {
45 
46   /**
47    * @dev Transfers the current balance to the owner and terminates the contract.
48    */
49   function destroy() onlyOwner public {
50     selfdestruct(owner);
51   }
52 
53   function destroyAndSend(address _recipient) onlyOwner public {
54     selfdestruct(_recipient);
55   }
56 }
57 
58 contract Token {
59 
60     /// total amount of tokens
61     uint256 public totalSupply;
62 
63     /// @param _owner The address from which the balance will be retrieved
64     /// @return The balance
65     function balanceOf(address _owner) constant returns (uint256 balance);
66 
67     /// @notice send `_value` token to `_to` from `msg.sender`
68     /// @param _to The address of the recipient
69     /// @param _value The amount of token to be transferred
70     /// @return Whether the transfer was successful or not
71     function transfer(address _to, uint256 _value) returns (bool success);
72 
73     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
74     /// @param _from The address of the sender
75     /// @param _to The address of the recipient
76     /// @param _value The amount of token to be transferred
77     /// @return Whether the transfer was successful or not
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
79 
80     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
81     /// @param _spender The address of the account able to transfer the tokens
82     /// @param _value The amount of tokens to be approved for transfer
83     /// @return Whether the approval was successful or not
84     function approve(address _spender, uint256 _value) returns (bool success);
85 
86     /// @param _owner The address of the account owning tokens
87     /// @param _spender The address of the account able to transfer the tokens
88     /// @return Amount of remaining tokens allowed to spent
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
90 
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 }
94 
95 contract BaseToken is Token {
96 
97     function transfer(address _to, uint256 _value) returns (bool success) {
98         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
99         balances[msg.sender] -= _value;
100         balances[_to] += _value;
101         Transfer(msg.sender, _to, _value);
102         return true;
103     }
104 
105     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
106         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
107         balances[_to] += _value;
108         balances[_from] -= _value;
109         allowed[_from][msg.sender] -= _value;
110         Transfer(_from, _to, _value);
111         return true;
112     }
113 
114     function balanceOf(address _owner) constant returns (uint256 balance) {
115         return balances[_owner];
116     }
117 
118     function approve(address _spender, uint256 _value) returns (bool success) {
119         allowed[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
125       return allowed[_owner][_spender];
126     }
127 
128     mapping (address => uint256) balances;
129     mapping (address => mapping (address => uint256)) allowed;
130 }
131 
132 contract TeraCoin is BaseToken, Destructible  {
133     string public name = "TeraCoin";
134     uint8 public decimals = 0;
135     string public symbol = "TERA";
136     string public version = '0.1';
137     
138     function TeraCoin() {
139         totalSupply = 1000000000000;
140         balances[msg.sender] = totalSupply;
141     }
142 }