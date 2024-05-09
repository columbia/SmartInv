1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /**
32  * @title ERC20Basic
33  */
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) public constant returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 /**
42  * @title Basic token
43   */
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51     require(_value <= balances[msg.sender]);
52 
53     // SafeMath.sub will throw if there is not enough balance.
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     emit Transfer(msg.sender, _to, _value);
57     return true;
58   }
59   
60   function balanceOf(address _owner) public constant returns (uint256 balance) {
61     return balances[_owner];
62   }
63 
64 }
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) public constant returns (uint256);
72   function transferFrom(address from, address to, uint256 value) public returns (bool);
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) internal allowed;
80 
81   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[_from]);
84     require(_value <= allowed[_from][msg.sender]);
85 
86     balances[_from] = balances[_from].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89     emit Transfer(_from, _to, _value);
90     return true;
91   }
92 
93   /**
94    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
95    * @param _spender The address which will spend the funds.
96    * @param _value The amount of tokens to be spent.
97    */
98   function approve(address _spender, uint256 _value) public returns (bool) {
99     allowed[msg.sender][_spender] = _value;
100     emit Approval(msg.sender, _spender, _value);
101     return true;
102   }
103 
104   /**
105    * @dev Function to check the amount of tokens that an owner allowed to a spender.
106    * @param _owner address The address which owns the funds.
107    * @param _spender address The address which will spend the funds.
108    * @return A uint256 specifying the amount of tokens still available for the spender.
109    */
110   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
111     return allowed[_owner][_spender];
112   }
113 
114   /**
115    * approve should be called when allowed[_spender] == 0. To increment
116    * allowed value is better to use this function to avoid 2 calls (and wait until
117    * the first transaction is mined)
118    */
119   function increase (address _spender, uint _addedValue) public returns (bool success) {
120     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
121     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122     return true;
123   }
124 
125   function decrease (address _spender, uint _subtractedValue) public returns (bool success) {
126     uint oldValue = allowed[msg.sender][_spender];
127     if (_subtractedValue > oldValue) {
128       allowed[msg.sender][_spender] = 0;
129     } else {
130       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
131     }
132     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 
136 }
137 
138 /**
139  * @title Ownable
140  * @dev The Ownable contract has an owner address, and provides basic authorization control
141  * functions, this simplifies the implementation of "user permissions".
142  */
143 contract Ownable {
144   address public owner;
145 
146 
147   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148 
149 
150   /**
151    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
152    * account.
153    */
154   constructor() public {
155     owner = msg.sender;
156   }
157 
158 
159   /**
160    * @dev Throws if called by any account other than the owner.
161    */
162   modifier onlyOwner() {
163     require(msg.sender == owner);
164     _;
165   }
166 
167 
168   /**
169    * @dev Allows the current owner to transfer control of the contract to a newOwner.
170    * @param newOwner The address to transfer ownership to.
171    */
172   function transferOwnership(address newOwner) onlyOwner public {
173     require(newOwner != address(0));
174     emit OwnershipTransferred(owner, newOwner);
175     owner = newOwner;
176   }
177 
178 }
179 
180 contract BIRCToken is StandardToken, Ownable {
181     string constant public name = "Business Interactive Reward Coin";
182     string constant public symbol = "BIRC";
183     uint8 constant public decimals = 6;
184     bool public isLocked = true;
185 
186     constructor(address BIRCWallet) public {
187         totalSupply = 1 * 1000 * 1000 * 1000 * 1000000;
188         balances[BIRCWallet] = totalSupply;
189     }
190 
191     modifier illegalWhenLocked() {
192         require(!isLocked || msg.sender == owner);
193         _;
194     }
195 
196     // should be called  when crowdSale is finished
197     function unlock() onlyOwner public {
198         isLocked = false;
199     }
200 
201     function transfer(address _to, uint256 _value) illegalWhenLocked public returns (bool) {
202         return super.transfer(_to, _value);
203     }
204 
205     function transferFrom(address _from, address _to, uint256 _value) illegalWhenLocked public returns (bool) {
206         return super.transferFrom(_from, _to, _value);
207     }
208 }