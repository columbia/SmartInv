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
47     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
48         uint _allowance = allowed[_from][msg.sender];
49         require(_to != address(0));
50         require(_value <= _allowance);
51         balances[_from] = balances[_from].sub(_value);
52         balances[_to] = balances[_to].add(_value);
53         allowed[_from][msg.sender] = _allowance.sub(_value);
54         emit Transfer(_from, _to, _value);
55         return true;
56     }
57     function approve(address _spender, uint256 _value) public returns(bool) {
58         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
59         allowed[msg.sender][_spender] = _value;
60         emit Approval(msg.sender, _spender, _value);
61         return true;
62     }
63     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
64         return allowed[_owner][_spender];
65     }
66 }
67 contract ETTOKEN is StandardToken {
68     string public constant name = "ET TOKEN";
69     string public constant symbol = "ET";
70     uint8 public constant decimals = 8;
71     function ETTOKEN() public {
72         totalSupply = 10000000000000000000;
73         balances[msg.sender] = totalSupply;
74     }
75 }