1 pragma solidity ^0.5.16;
2  
3 library SafeMath {
4 
5   function mul(uint a, uint b) internal   returns (uint) {
6     uint c = a * b;
7     require(a == 0 || c / a == b);
8     return c;
9   }
10   function div(uint a, uint b) internal  returns (uint) {
11     require(b > 0);
12     uint c = a / b;
13     require(a == b * c + a % b);
14     return c;
15   }
16   function sub(uint a, uint b) internal  returns (uint) {
17     require(b <= a);
18     return a - b;
19   }
20   function add(uint a, uint b) internal  returns (uint) {
21     uint c = a + b;
22     require(c >= a);
23     return c;
24   }
25 
26 }
27 
28 
29 contract ERC20Basic {
30 
31   uint public totalSupply;
32   function balanceOf(address who) public view returns (uint);
33   function transfer(address to, uint value) public ;
34   event Transfer(address indexed from, address indexed to, uint value);
35   
36   function allowance(address owner, address spender) public view returns (uint);
37   function transferFrom(address from, address to, uint value) public;
38   function approve(address spender, uint value) public;
39   event Approval(address indexed owner, address indexed spender, uint value);
40 }
41 
42 
43 contract BasicToken is ERC20Basic {
44 
45   using SafeMath for uint;
46     
47   mapping(address => uint) balances;
48 
49   function transfer(address _to, uint _value) public {
50 	balances[msg.sender] = balances[msg.sender].sub(_value);
51 	balances[_to] = balances[_to].add(_value);
52 	emit Transfer(msg.sender, _to, _value);
53   }
54 
55   function balanceOf(address _owner) public view returns (uint balance) {
56     return balances[_owner];
57   }
58  
59 }
60 
61 contract StandardToken is BasicToken {
62 
63   mapping (address => mapping (address => uint)) allowed;
64 
65   function transferFrom(address _from, address _to, uint _value) public  {
66     uint _allowance = allowed[_from][msg.sender];
67   
68     balances[_to] = balances[_to].add(_value);
69     balances[_from] = balances[_from].sub(_value);
70     allowed[_from][msg.sender] = _allowance.sub(_value);
71     emit Transfer(_from, _to, _value);
72   }
73 
74   function approve(address _spender, uint _value) public {
75     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
76 
77     allowed[msg.sender][_spender] = _value;
78     emit Approval(msg.sender, _spender, _value);
79   }
80 
81   function allowance(address _owner, address _spender) public view returns (uint remaining) {
82     return allowed[_owner][_spender];
83   }
84   
85 }
86 
87 contract NUIILPToken is StandardToken {
88     string public constant name = "NUII LP";
89     string public constant symbol = "NUII LP";
90     uint public constant decimals = 4;
91 	address constant tokenWallet = 0x8b7e8575b7D84192E994a50cFEcDF46DF956b174;
92     /**
93      * CONSTRUCTOR, This address will be : 0x...
94      */
95     constructor () public  {
96         totalSupply = 200000000 * (10 ** decimals);
97         balances[tokenWallet] = totalSupply;
98 		emit Transfer(address(0x0), tokenWallet, totalSupply);
99     }
100 
101     function () external payable {
102         revert();
103     }
104 }