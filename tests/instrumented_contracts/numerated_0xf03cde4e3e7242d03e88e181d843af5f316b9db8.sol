1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns(uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns(uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 contract EthereumCenturion {
27     using SafeMath
28     for uint256;
29     mapping(address => mapping(address => uint256)) allowed;
30     mapping(address => uint256) balances;
31     uint256 public totalSupply;
32     uint256 public decimals;
33     address public owner;
34     bytes32 public symbol;
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed _owner, address indexed spender, uint256 value);
37 
38     function EthereumCenturion() {
39         totalSupply = 24000000;
40         symbol = 'ETHC';
41         owner = 0x5D4B79ef3a7f562D3e764a5e4A356b69c04cbC5A;
42         balances[owner] = totalSupply;
43         decimals = 0;
44     }
45 
46     function balanceOf(address _owner) constant returns(uint256 balance) {
47         return balances[_owner];
48     }
49 
50     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
51         return allowed[_owner][_spender];
52     }
53 
54     function transfer(address _to, uint256 _value) returns(bool) {
55         balances[msg.sender] = balances[msg.sender].sub(_value);
56         balances[_to] = balances[_to].add(_value);
57         Transfer(msg.sender, _to, _value);
58         return true;
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns(bool) {
62         var _allowance = allowed[_from][msg.sender];
63         balances[_to] = balances[_to].add(_value);
64         balances[_from] = balances[_from].sub(_value);
65         allowed[_from][msg.sender] = _allowance.sub(_value);
66         Transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function approve(address _spender, uint256 _value) returns(bool) {
71         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function() {
78         revert();
79     }
80 }