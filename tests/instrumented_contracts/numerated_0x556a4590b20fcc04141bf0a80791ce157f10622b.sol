1 pragma solidity ^ 0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal pure returns(uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17     function add(uint256 a, uint256 b) internal pure returns(uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22 }
23 contract ERC20 {
24     uint256 public totalSupply;
25     function balanceOf(address who) public view returns(uint256);
26     function transfer(address to, uint256 value) public returns(bool);
27     function allowance(address owner, address spender) public view returns(uint256);
28     function transferFrom(address from, address to, uint256 value) public returns(bool);
29     function approve(address spender, uint256 value) public returns(bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 contract StandardToken is ERC20 {
34     using SafeMath for uint256;
35         mapping(address => uint256) balances;
36     mapping(address => mapping(address => uint256)) allowed;
37     function balanceOf(address _owner) public view returns(uint256 balance) {
38         return balances[_owner];
39     }
40     function transfer(address _to, uint256 _value) public returns(bool) {
41         require(_to != address(0));
42         balances[msg.sender] = balances[msg.sender].sub(_value);
43         balances[_to] = balances[_to].add(_value);
44         emit Transfer(msg.sender, _to, _value);
45         return true;
46     }
47     function batchTransfer(address[] _tos, uint256[] _count)  public returns(bool) {
48         require(_tos.length > 0);
49         for (uint32 i = 0; i < _tos.length; i++) {
50             transfer(_tos[i], _count[i]);
51         }
52         return true;
53     }
54     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
55         uint _allowance = allowed[_from][msg.sender];
56         require(_to != address(0));
57         require(_value <= _allowance);
58         balances[_from] = balances[_from].sub(_value);
59         balances[_to] = balances[_to].add(_value);
60         allowed[_from][msg.sender] = _allowance.sub(_value);
61         emit Transfer(_from, _to, _value);
62         return true;
63     }
64     function approve(address _spender, uint256 _value) public returns(bool) {
65         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
66         allowed[msg.sender][_spender] = _value;
67         emit Approval(msg.sender, _spender, _value);
68         return true;
69     }
70     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
71         return allowed[_owner][_spender];
72     }
73 }
74 contract BUTOKEN is StandardToken {
75     string public constant name = "BUToken";
76     string public constant symbol = "BUTO";
77     uint8 public constant decimals = 6;
78     constructor()  public {
79         totalSupply = 21000000000000;
80         balances[msg.sender] = totalSupply;
81     }
82 }