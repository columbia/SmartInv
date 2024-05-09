1 /**
2   * SafeMath Libary
3   */
4 pragma solidity ^0.4.21;
5 contract SafeMath {
6     function safeAdd(uint256 a, uint256 b) internal pure returns(uint256)
7     {
8         uint256 c = a + b;
9         assert(c >= a);
10         return c;
11     }
12     function safeSub(uint256 a, uint256 b) internal pure returns(uint256)
13     {
14         assert(b <= a);
15         return a - b;
16     }
17     function safeMul(uint256 a, uint256 b) internal pure returns(uint256)
18     {
19         if (a == 0) {
20         return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26     function safeDiv(uint256 a, uint256 b) internal pure returns(uint256)
27     {
28         uint256 c = a / b;
29         return c;
30     }
31 }
32 
33 contract Ownable {
34     address public owner;
35 
36     function Ownable() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) onlyOwner public {
46         owner = newOwner;
47     }
48 }
49 
50 contract EIP20Interface {
51     /// total amount of tokens
52     uint256 public totalSupply;
53     /// @param _owner The address from which the balance will be retrieved
54     /// @return The balance
55     function balanceOf(address _owner) public view returns (uint256 balance);
56     /// @notice send `_value` token to `_to` from `msg.sender`
57     /// @param _to The address of the recipient
58     /// @param _value The amount of token to be transferred
59     /// @return Whether the transfer was successful or not
60     function transfer(address _to, uint256 _value) public returns (bool success);
61     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
62     /// @param _from The address of the sender
63     /// @param _to The address of the recipient
64     /// @param _value The amount of token to be transferred
65     /// @return Whether the transfer was successful or not
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
67     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @param _value The amount of tokens to be approved for transfer
70     /// @return Whether the approval was successful or not
71     function approve(address _spender, uint256 _value) public returns(bool success);
72 
73     /// @param _spender The address of the account able to transfer the tokens
74     /// @return Amount of remaining tokens allowed to spent
75     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
76     // solhint-disable-next-line no-simple-event-func-name
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender,uint256 _value);
79 }
80 
81 
82 contract THBCToken is EIP20Interface,Ownable,SafeMath{
83     //// Constant token specific fields
84     string public constant name ="THBCToken";
85     string public constant symbol = "THBC";
86     uint8 public constant decimals = 18;
87     string  public version  = 'v0.1';
88     uint256 public constant initialSupply = 20000000000;
89     
90     mapping (address => uint256) public balances;
91     mapping (address => mapping (address => uint256)) public allowances;
92 
93     function THBCToken() public {
94         totalSupply = initialSupply*10**uint256(decimals);                        //  total supply
95         balances[msg.sender] = totalSupply;             // Give the creator all initial tokens
96     }
97 
98     function balanceOf(address _account) public view returns (uint) {
99         return balances[_account];
100     }
101 
102     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
103         require(_to != address(0x0)&&_value>0);
104         require(balances[_from] >= _value);
105         require(safeAdd(balances[_to],_value) > balances[_to]);
106 
107         uint previousBalances = safeAdd(balances[_from],balances[_to]);
108         balances[_from] = safeSub(balances[_from],_value);
109         balances[_to] = safeAdd(balances[_to],_value);
110         emit Transfer(_from, _to, _value);
111         assert(safeAdd(balances[_from],balances[_to]) == previousBalances);
112         return true;
113     }
114 
115     function transfer(address _to, uint256 _value) public returns (bool success){
116         return _transfer(msg.sender, _to, _value);
117     }
118 
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120         require(_value <= allowances[_from][msg.sender]);
121         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender],_value);
122         return _transfer(_from, _to, _value);
123     }
124 
125     function approve(address _spender, uint256 _value) public returns (bool success) {
126         allowances[msg.sender][_spender] = _value;
127         emit Approval(msg.sender, _spender, _value);
128         return true;
129     }
130 
131     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
132         return allowances[_owner][_spender];
133     }
134  
135     function() public payable {
136         revert();
137     }
138 }