1 pragma solidity ^0.4.13;
2 
3 contract IERC20 {
4     function totalSupply() constant returns (uint _totalSupply);
5     function balanceOf(address _owner) constant returns (uint balance);
6     function transfer(address _to, uint _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) returns (bool success);
8     function approve(address _spender, uint _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint remaining);
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 
15 library SafeMathLib {
16 
17   function minus(uint a, uint b) returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function plus(uint a, uint b) returns (uint) {
23     uint c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28 }
29 
30 /**
31  * @title Ownable
32  * @notice The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36 
37   address public owner;
38 
39   /**
40    * @notice The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() {
44     owner = msg.sender;
45   }
46 
47   /**
48    * @notice Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56    * @notice Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) onlyOwner {
60     require(newOwner != address(0));
61     owner = newOwner;
62   }
63   
64 }
65 
66 
67 /**
68  * @title Erc20 Token
69  * @notice The ERC20 Token for Cove Identity.
70  */
71 contract Erc20 is IERC20, Ownable {
72     
73     using SafeMathLib for uint256;
74     
75     uint256 public constant totalTokenSupply = 100000000 * 10**18;
76 
77     string public name = "Dontoshi Token";
78     string public symbol = "DTD";
79     uint8 public constant decimals = 18;
80     
81     mapping (address => uint256) public balances;
82     //approved[owner][spender]
83     mapping(address => mapping(address => uint256)) approved;
84     
85     function Erc20() {
86         balances[msg.sender] = totalTokenSupply;
87     }
88     
89     function totalSupply() constant returns (uint256 _totalSupply) {
90         return totalTokenSupply;
91     }
92     
93     function balanceOf(address _owner) constant returns (uint256 balance) {
94         return balances[_owner];
95     }
96     
97     /* Internal transfer, only can be called by this contract */
98     function _transfer(address _from, address _to, uint256 _value) internal {
99         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
100         require (balances[_from] >= _value);                // Check if the sender has enough
101         require (balances[_to] + _value > balances[_to]);   // Check for overflows
102         balances[_from] = balances[_from].minus(_value);    // Subtract from the sender
103         balances[_to] = balances[_to].plus(_value);         // Add the same to the recipient
104         Transfer(_from, _to, _value);
105     }
106 
107     /**
108      * @notice Send `_value` tokens to `_to` from your account
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transfer(address _to, uint256 _value) returns (bool success) {
113         _transfer(msg.sender, _to, _value);
114         return true;
115     }
116     
117     /**
118      * @notice Send `_value` tokens to `_to` on behalf of `_from`
119      * @param _from The address of the sender
120      * @param _to The address of the recipient
121      * @param _value the amount to send
122      */
123     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
124         require (_value <= approved[_from][msg.sender]);     // Check allowance
125         approved[_from][msg.sender] = approved[_from][msg.sender].minus(_value);
126         _transfer(_from, _to, _value);
127         return true;
128     }
129     
130     /**
131      * @notice Approve `_value` tokens for `_spender`
132      * @param _spender The address of the sender
133      * @param _value the amount to send
134      */
135     function approve(address _spender, uint256 _value) returns (bool success) {
136         if(balances[msg.sender] >= _value) {
137             approved[msg.sender][_spender] = _value;
138             Approval(msg.sender, _spender, _value);
139             return true;
140         }
141         return false;
142     }
143     
144     /**
145      * @notice Check `_value` tokens allowed to `_spender` by `_owner`
146      * @param _owner The address of the Owner
147      * @param _spender The address of the Spender
148      */
149     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
150         return approved[_owner][_spender];
151     }
152     
153     event Transfer(address indexed _from, address indexed _to, uint256 _value);
154     
155     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
156     
157 }