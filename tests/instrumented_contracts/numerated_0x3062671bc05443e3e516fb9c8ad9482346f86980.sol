1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5     assert(b <= a);
6     return a - b;
7   }
8 
9   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     c = a + b;
11     assert(c >= a);
12     return c;
13   }
14 }
15 
16 contract ERC20Interface {
17   uint256 public totalSupply;
18   mapping(address => uint256) internal balances;
19   mapping(address => mapping(address => uint256)) internal allowed;
20 
21   function balanceOf(address owner) public view returns (uint256);
22   function allowance(address owner, address spender) public view returns (uint256);
23   function approve(address spender, uint256 value) public returns (bool);
24   function transfer(address to, uint256 value) public returns (bool);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function burn(uint256 value) public returns (bool);
27 
28   event Transfer(address indexed from, address indexed to, uint256 value);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30   event Burn(address indexed burner, uint256 value);
31 }
32 
33 contract ERC20Token is ERC20Interface {
34   using SafeMath for uint256;
35 
36   function balanceOf(address _owner) public view returns (uint256) {
37     return balances[_owner];
38   }
39 
40   function allowance(address _owner, address _spender) public view returns (uint256) {
41     return allowed[_owner][_spender];
42   }
43 
44   function approve(address _spender, uint256 _value) public returns (bool) {
45     allowed[msg.sender][_spender] = _value;
46     emit Approval(msg.sender, _spender, _value);
47     return true;
48   }
49 
50   function transfer(address _to, uint256 _value) public returns (bool) {
51     require(_to != address(0));
52     balances[msg.sender] = balances[msg.sender].sub(_value);
53     balances[_to] = balances[_to].add(_value);
54     emit Transfer(msg.sender, _to, _value);
55     return true;
56   }
57 
58   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
59     require(_to != address(0));
60     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
61     balances[_from] = balances[_from].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     emit Transfer(_from, _to, _value);
64     return true;
65   }
66 
67   function burn(uint256 _value) public returns (bool) {
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     totalSupply = totalSupply.sub(_value);
70     emit Burn(msg.sender, _value);
71     return true;
72   }
73 }
74 
75 contract CoomiToken is ERC20Token {
76   string public constant name = 'Coomi';
77   string public constant symbol = 'COOMI';
78   uint8 public constant decimals = 18;
79 
80   constructor(uint256 _totalSupply) public {
81     totalSupply = _totalSupply;
82     balances[msg.sender] = totalSupply;
83   }
84 }