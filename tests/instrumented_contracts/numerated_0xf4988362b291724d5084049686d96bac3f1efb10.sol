1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public constant returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 contract ERC20Interface {
14     function totalSupply() constant returns (uint supply) {}
15     function balanceOf(address _owner) constant returns (uint balance) {}
16     function transfer(address _to, uint _value) returns (bool success) {}
17     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
18     function approve(address _spender, uint _value) returns (bool success) {}
19     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
20     event Transfer(address indexed _from, address indexed _to, uint _value);
21     event Approval(address indexed _owner, address indexed _spender, uint _value);
22 }
23 
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal constant returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   /**
63   * @dev transfer token for a specified address
64   * @param _to The address to transfer to.
65   * @param _value The amount to be transferred.
66   */
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[msg.sender]);
70 
71     // SafeMath.sub will throw if there is not enough balance.
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) public constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 
90 
91 contract WrapperLock is BasicToken {
92 
93   address ZEROEX_PROXY = 0x8da0d80f5007ef1e431dd2127178d224e32c2ef4;
94   address ETHFINEX;
95 
96   string public name;
97   string public symbol;
98   uint public decimals;
99   address public originalToken;
100 
101   mapping (address => uint) public depositLock;
102 
103   function WrapperLock(address _originalToken, string _name, string _symbol, uint _decimals) {
104     originalToken = _originalToken;
105     name = _name;
106     symbol = _symbol;
107     decimals = _decimals;
108     ETHFINEX = 0x5A2143B894C9E8d8DFe2A0e8B80d7DB2689fC382;
109   }
110 
111   function deposit(uint _value, uint _forTime) returns (bool success) {
112     require (_forTime >= 1);
113     require (now + _forTime * 1 hours >= depositLock[msg.sender]);
114     success = ERC20Interface(originalToken).transferFrom(msg.sender, this, _value);
115     if(success) {
116       balances[msg.sender] = balances[msg.sender].add(_value);
117       depositLock[msg.sender] = now + _forTime * 1 hours;
118     }
119   }
120 
121   function withdraw(uint8 v, bytes32 r, bytes32 s, uint _value, uint signatureValidUntilBlock) returns (bool success) {
122     require(balanceOf(msg.sender) >= _value);
123     if (now > depositLock[msg.sender]){
124       balances[msg.sender] = balances[msg.sender].sub(_value);
125       success = ERC20Interface(originalToken).transfer(msg.sender, _value);
126     }
127     else {
128       require(block.number < signatureValidUntilBlock);
129       require(isValidSignature(ETHFINEX, keccak256(msg.sender, _value, signatureValidUntilBlock), v, r, s));
130       balances[msg.sender] = balances[msg.sender].sub(_value);
131       success = ERC20Interface(originalToken).transfer(msg.sender, _value);
132     }
133   }
134 
135   function transferFrom(address _from, address _to, uint _value) {
136     assert(msg.sender == ZEROEX_PROXY);
137     balances[_to] = balances[_to].add(_value);
138     balances[_from] = balances[_from].sub(_value);
139     Transfer(_from, _to, _value);
140   }
141 
142   function allowance(address owner, address spender) returns (uint) {
143     if(spender == ZEROEX_PROXY) {
144       return 2**256 - 1;
145     }
146   }
147 
148   function isValidSignature(
149         address signer,
150         bytes32 hash,
151         uint8 v,
152         bytes32 r,
153         bytes32 s)
154         public
155         constant
156         returns (bool)
157     {
158         return signer == ecrecover(
159             keccak256("\x19Ethereum Signed Message:\n32", hash),
160             v,
161             r,
162             s
163         );
164     }
165 
166 }