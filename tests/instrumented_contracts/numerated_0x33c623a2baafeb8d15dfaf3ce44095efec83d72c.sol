1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 contract ERC223ReceivingContract {
47     function tokenFallback(address _from, uint _value, bytes _data);
48 }
49 
50 
51 /*
52  * ERC20Basic
53  * Simpler version of ERC20 interface
54  * see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20Basic {
57   function totalSupply() constant returns (uint256);
58   function balanceOf(address _owner) constant returns (uint256);
59   function transfer(address _to, uint256 _value) returns (bool);
60   event Transfer(address indexed from, address indexed to, uint value);
61 }
62 
63 contract ERC223Basic is ERC20Basic {
64     function transfer(address to, uint value, bytes data) returns (bool);
65 }
66 
67 /*
68  * ERC20 interface
69  * see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC223Basic {
72   // active supply of tokens
73   function allowance(address _owner, address _spender) constant returns (uint256);
74   function transferFrom(address _from, address _to, uint _value) returns (bool);
75   function approve(address _spender, uint256 _value) returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 contract ControllerInterface {
80 
81   function totalSupply() constant returns (uint256);
82   function balanceOf(address _owner) constant returns (uint256);
83   function allowance(address _owner, address _spender) constant returns (uint256);
84 
85   function approve(address owner, address spender, uint256 value) public returns (bool);
86   function transfer(address owner, address to, uint value, bytes data) public returns (bool);
87   function transferFrom(address owner, address from, address to, uint256 amount, bytes data) public returns (bool);
88   function mint(address _to, uint256 _amount)  public returns (bool);
89 }
90 
91 contract Token is Ownable, ERC20 {
92 
93   event Mint(address indexed to, uint256 amount);
94   event MintToggle(bool status);
95 
96   // Constant Functions
97   function balanceOf(address _owner) constant returns (uint256) {
98     return ControllerInterface(owner).balanceOf(_owner);
99   }
100 
101   function totalSupply() constant returns (uint256) {
102     return ControllerInterface(owner).totalSupply();
103   }
104 
105   function allowance(address _owner, address _spender) constant returns (uint256) {
106     return ControllerInterface(owner).allowance(_owner, _spender);
107   }
108 
109   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
110     Mint(_to, _amount);
111     Transfer(address(0), _to, _amount);
112     return true;
113   }
114 
115   function mintToggle(bool status) onlyOwner public returns (bool) {
116     MintToggle(status);
117     return true;
118   }
119 
120   // public functions
121   function approve(address _spender, uint256 _value) public returns (bool) {
122     ControllerInterface(owner).approve(msg.sender, _spender, _value);
123     Approval(msg.sender, _spender, _value);
124     return true;
125   }
126 
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     bytes memory empty;
129     return transfer(_to, _value, empty);
130   }
131 
132   function transfer(address to, uint value, bytes data) public returns (bool) {
133     ControllerInterface(owner).transfer(msg.sender, to, value, data);
134     Transfer(msg.sender, to, value);
135     _checkDestination(msg.sender, to, value, data);
136     return true;
137   }
138 
139   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
140     bytes memory empty;
141     return transferFrom(_from, _to, _value, empty);
142   }
143 
144 
145   function transferFrom(address _from, address _to, uint256 _amount, bytes _data) public returns (bool) {
146     ControllerInterface(owner).transferFrom(msg.sender, _from, _to, _amount, _data);
147     Transfer(_from, _to, _amount);
148     _checkDestination(_from, _to, _amount, _data);
149     return true;
150   }
151 
152   // Internal Functions
153   function _checkDestination(address _from, address _to, uint256 _value, bytes _data) internal {
154 
155     uint256 codeLength;
156     assembly {
157       codeLength := extcodesize(_to)
158     }
159     if(codeLength>0) {
160       ERC223ReceivingContract untrustedReceiver = ERC223ReceivingContract(_to);
161       // untrusted contract call
162       untrustedReceiver.tokenFallback(_from, _value, _data);
163     }
164   }
165 }
166 
167 /**
168  Simple Token based on OpenZeppelin token contract
169  */
170 contract SGPay is Token {
171 
172   string public constant name = "SGPay Token";
173   string public constant symbol = "SGP";
174   uint8 public constant decimals = 18;
175 
176 }