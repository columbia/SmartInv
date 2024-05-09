1 pragma solidity ^0.4.25;
2 
3 
4 library SafeMath {
5   function mul(uint a, uint b) internal pure  returns (uint) {
6     uint c = a * b;
7     require(a == 0 || c / a == b);
8     return c;
9   }
10   function div(uint a, uint b) internal pure returns (uint) {
11     require(b > 0);
12     uint c = a / b;
13     require(a == b * c + a % b);
14     return c;
15   }
16   function sub(uint a, uint b) internal pure returns (uint) {
17     require(b <= a);
18     return a - b;
19   }
20   function add(uint a, uint b) internal pure returns (uint) {
21     uint c = a + b;
22     require(c >= a);
23     return c;
24   }
25   function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
26     return a >= b ? a : b;
27   }
28   function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
29     return a < b ? a : b;
30   }
31   function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
32     return a >= b ? a : b;
33   }
34   function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
35     return a < b ? a : b;
36   }
37 }
38 
39 contract ERC20Basic {
40   uint public totalSupply;
41   function balanceOf(address who) public constant returns (uint);
42   function transfer(address to, uint value) public;
43   event Transfer(address indexed from, address indexed to, uint value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) public constant returns (uint);
48   function transferFrom(address from, address to, uint value) public;
49   function approve(address spender, uint value) public;
50   event Approval(address indexed owner, address indexed spender, uint value);
51 }
52 
53 
54 contract BasicToken is ERC20Basic {
55 
56   using SafeMath for uint;
57 
58   mapping(address => uint) balances;
59 
60   function transfer(address _to, uint _value) public{
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64   }
65 
66   function balanceOf(address _owner) public constant returns (uint balance) {
67     return balances[_owner];
68   }
69 }
70 
71 contract StandardToken is BasicToken, ERC20 {
72   mapping (address => mapping (address => uint)) allowed;
73 
74   function transferFrom(address _from, address _to, uint _value) public {
75     require(_to != 0x0 && _value > 0);
76     balances[_to] = balances[_to].add(_value);
77     balances[_from] = balances[_from].sub(_value);
78     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
79     Transfer(_from, _to, _value);
80   }
81 
82   function approve(address _spender, uint _value) public{
83     require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
84     allowed[msg.sender][_spender] = _value;
85     Approval(msg.sender, _spender, _value);
86   }
87   
88   /* Approves and then calls the receiving contract */
89   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
90     approve(_spender,_value);
91     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
92     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
93     //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
94     //require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")), abi.encode(msg.sender, _value, this, _extraData)));
95     require(_spender.call(abi.encodeWithSelector(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")),msg.sender, _value, this, _extraData)));
96     return true;
97 }
98 
99   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
100     return allowed[_owner][_spender];
101   }
102 }
103 
104 
105 contract Ownable {
106     address public owner;
107 
108     function Ownable() public{
109         owner = msg.sender;
110     }
111 
112     modifier onlyOwner {
113         require(msg.sender == owner);
114         _;
115     }
116     function transferOwnership(address newOwner) onlyOwner public{
117         if (newOwner != address(0)) {
118             owner = newOwner;
119         }
120     }
121 }
122 
123 
124 contract BCT is StandardToken, Ownable{
125     string public constant name = "BlockCircle Token";
126     string public constant symbol = "BCT";
127     uint public constant decimals = 18;
128 
129     using SafeMath for uint;
130     
131     function BCT() public {
132         totalSupply = 1000000000000000000000000000;
133         balances[msg.sender] = totalSupply; // Send tokens to owner
134     }
135     
136     function burn() onlyOwner public returns (bool) {
137         uint256 _burnValue = totalSupply.mul(5).div(100);//5 percent tokens should be burned every year
138         require(balances[msg.sender] >= _burnValue);
139         require(totalSupply >= _burnValue);
140 
141         balances[msg.sender] = balances[msg.sender].sub(_burnValue);
142         totalSupply = totalSupply.sub(_burnValue);
143         Transfer(msg.sender, 0x0, _burnValue);
144         return true;
145     }
146     
147 }