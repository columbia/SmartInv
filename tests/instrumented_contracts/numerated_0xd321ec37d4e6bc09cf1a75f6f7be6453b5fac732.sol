1 pragma solidity ^0.4.16;
2 library SafeMath {
3 function mul(uint256 a, uint256 b) internal constant returns(uint256) {
4 uint256 c = a * b;
5 assert(a == 0 || c / a == b);
6 return c;
7 }
8 function div(uint256 a, uint256 b) internal constant returns(uint256) {
9 uint256 c = a / b;
10 return c;
11 }
12 function sub(uint256 a, uint256 b) internal constant returns(uint256) {
13 assert(b <= a);
14 return a - b;
15 }
16 function add(uint256 a, uint256 b) internal constant returns(uint256) {
17 uint256 c = a + b;
18 assert(c >= a);
19 return c;
20 }
21 }
22 contract BitCredit{
23 using SafeMath
24 for uint256;
25 mapping(address => mapping(address => uint256)) allowed;
26 mapping(address => uint256) balances;
27 uint256 public totalSupply;
28 uint256 public decimals;
29 address public owner;
30 bytes32 public symbol;
31 event Transfer(address indexed from, address indexed to, uint256 value);
32 event Approval(address indexed _owner, address indexed spender, uint256 value);
33 function BitCredit() {
34 totalSupply = 500000000;
35 symbol = 'BCT';
36 owner = 0x50eE326cBF5802231CC13fFf8e69ADCd271eb111;
37 balances[owner] = totalSupply;
38 decimals = 18;
39 }
40 function balanceOf(address _owner) constant returns(uint256 balance) {
41 return balances[_owner];
42 }
43 function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
44 return allowed[_owner][_spender];
45 }
46 function transfer(address _to, uint256 _value) returns(bool) {
47 balances[msg.sender] = balances[msg.sender].sub(_value);
48 balances[_to] = balances[_to].add(_value);
49 Transfer(msg.sender, _to, _value);
50 return true;
51 }
52 function transferFrom(address _from, address _to, uint256 _value) returns(bool) {
53 var _allowance = allowed[_from][msg.sender];
54 balances[_to] = balances[_to].add(_value);
55 balances[_from] = balances[_from].sub(_value);
56 allowed[_from][msg.sender] = _allowance.sub(_value);
57 Transfer(_from, _to, _value);
58 return true;
59 }
60 function approve(address _spender, uint256 _value) returns(bool) {
61 require((_value == 0) || (allowed[msg.sender][_spender] == 0));
62 allowed[msg.sender][_spender] = _value;
63 Approval(msg.sender, _spender, _value);
64 return true;
65 }
66 function() {
67 revert();
68 }
69 }